Unit CPU8E_Control;
{
  CPU-8E Simulator

                                                   Copyright 2009 Joel Guilherme

  Simulador para uma CPU de 8-bits Educacional, conforme especificações
  contidas no documento CPU-8E-Specs-vX.Y.pdf ('X.Y' conforme a versão atual
  do programa), parte deste pacote.

  Este programa, e todos seus componentes, é colocado à disposição do público
  na forma de um 'Programa Livre' ("Free Software") sob uma licença "GNU -
  General Public License" (Copyleft), sendo assim entendido que você tem o
  direito de utilizá-lo livremente, sem pagar quaisquer direitos por isto,
  inclusive o direito de copiá-lo, modificá-lo e redistribuí-lo, desde que
  mantidos estes termos a quaisquer cópias ou modificações.
  Este programa é distribuido na esperança de que possa ser útil, mas SEM
  NENHUMA GARANTIA, IMPLÍCITA OU EXPLÍCITA, de ADEQUAÇÃO a qualquer MERCADO
  ou APLICAÇÃO EM PARTICULAR. Para maiores detalhes veja o documento
  "Copiando(GPL).txt", parte integrante deste pacote de programa.

  Autor: Prof. Joel Guilherme da Silva Filho
  Organização: IESB - Instituto de Educação Superior de Brasília
  Local: Brasília/DF, Brasil

  Histórico:
    Versão: 0.9 - 01/02/2009: Primeira versão totalmente operacional
    Versão: 1.0  - 04/02/2009 - Corrigida lógica de "Single Step"/"Single Cycle"
                              - Corrigida representacão de End. Imediato/Direto
    Versão: 1.0b - 28/04/2009 - Registradores CPU.A e CPU.B (ULA) foram
                                redefinidos como do tipo "Byte"
                              - Corrigida lógica de geração dos flags da ULA.
}

{
  CPU8E_Control.pas
  Esta Unit implementa a logica da unidade de controle da UCP-8E, o mais proximo
  das especificacoeso quanto nos foi possivel implementar em software.
  Ver documento de especificacao da UCP-8E, "UCP-8E - Especificacoes - vX.Y.pdf"
}

Interface

uses SysUtils,CPU8E_Utils,CPU8E;

var
// Define o estado atual da Unidade de Controle
 UControl: record
    S: byte;          // variavel de estado 'S' que indica a fase de execucao
                      // do ciclo de instrucao
    T: byte;          // indicador do ciclo de clock interno de cada fase
    Timer: integer;   // corresponde ao valor atribuido para a duracao de cada
                      // sub-ciclo do clock de execucao de uma instrucao
 end;

procedure Execute;
{ Implementa a fase de Execucao de uma instrucao }
procedure FetchOperandAddr;
{ Implementa a fase de Busca do Operando de uma instrucao }
procedure FetchOpCode;
{ Implementa a fase de Busca do OpCode de uma instrucao }
procedure RunProgram;
{ Nucleo da maquina de estados de controle da ICP }
procedure RunStep;

Implementation

uses StdCtrls, Graphics, Dialogs, ExtCtrls, CPU8E_Panel, Forms;

var
  LastR        : array of byte = nil;
  LastItem     : array of TStaticText = nil;
  LastDataFlow : array of TShape = nil;

procedure UnFlash;
{ Desfaz o realce de um dado, realcado pela rotina "Flash" }
var
  I : integer;
begin
  for I := 0 to high(LastItem) do begin
    LastItem[I].Caption := copy(LastItem[I].Name, 3, 3) + ':' + IntToHex(LastR[I], LenReg(LastItem[I]));
    LastItem[I].Font.Color := clBlack;
  end;
  for I := 0 to high(LastDataFlow) do
    LastDataFlow[I].Brush.Color := LastDataFlow[I].Tag;
  Application.ProcessMessages;
end;

procedure Flash(R : array of byte; Item : array of TStaticText; DataFlow : array of TShape);
{ Faz o realce de um dado, cujo valor e localizacao sao passados como
  paramentros. Eh utilizada para indicar uma mudanca de valor de um
  elemento da UCP }
var
  I : integer;
begin
  UnFlash;
  SetLength(LastR, high(R) + 1);
  SetLength(LastItem, high(Item) + 1);
  SetLength(LastDataFlow, high(DataFlow)+1);
  for I := 0 to high(LastItem) do begin
    Item[I].Caption := copy(Item[I].Name, 3, 3) + ':' + IntToHex(R[I], LenReg(Item[I]));
    Item[I].Font.Color := clRed;
    if Item[I] = frmCPU.stPC then ShowMem(CPU.PC);
    LastR[I] := R[I];
    LastItem[I] := Item[I];
  end;
  for I := 0 to high(DataFlow) do
    with DataFlow[I] do begin
      Tag := Brush.Color;
      Brush.Color := clRed;
      LastDataFlow[I] := DataFlow[I]
    end;
  Application.ProcessMessages;
end;

procedure Pause(Mode : ModeType); begin
  if (CPUMode = Mode) or (Cmd in [_Pause, _Halt]) then begin
    if Cmd <> _Halt then begin
      Cmd := _Pause;
      frmCPU.ilImagens.GetBitmap(1, frmCPU.sbStatus.Picture.Bitmap);
    end;
    repeat
      Sleep(10);
      Application.ProcessMessages;
      if Cmd in [_Rst, _Halt, _Load, _Exit] then begin
        UnFlash;
        Abort;
      end;
    until Cmd <> _Pause;
  end;
end;

procedure PulseClock(R: array of byte; Item: array of TStaticText; DataFlow : array of TShape);
{ Faz a temporizacao do clock do sistema, conforme estabelecido pelo comando
  'Clock' do simulador }
begin
  Flash(R, Item, DataFlow);
  Pause(_Step);
  // senao simplesmente aguarda um intervalo de tempo estabelecido pelo "Clock"
  Sleep(Ucontrol.Timer);
  inc(UControl.T);
end;

procedure ProcessULA;
{ Na fase de execucao, aqui eh computadi o valor de saihda da ULA, caso
  a operacao envolva esta }
var
  R : Word;       // variavel auxiliar para o computo da saihda
  Values : array of byte;
  Items  : array of TStaticText;
  DataFlows : array of TShape;

  procedure InsertReg(Value : array of byte; Item : array of TStaticText; DataFlow : array of TShape);
  var
    I : integer;
  begin
    for I := 0 to high(Value) do begin
      SetLength(Values, Length(Values)+1);
      Values[high(Values)] := Value[I];
    end;
    for I := 0 to high(Item) do begin
      SetLength(Items, Length(Items)+1);
      Items[high(Items)] := Item[I];
    end;
    for I := 0 to high(DataFlow) do begin
      SetLength(DataFlows, Length(DataFlows)+1);
      DataFlows[high(DataFlows)] := DataFlow[I];
    end;
  end;

begin
   with CPU, frmCPU do begin
      case OpCode of
         _NOT: R := not A;            // Negacao logica
         _LOD: R := A;                // Load acumulador
         _CMP: begin                  // Subtrai operando do acumulador
                  R := (not B) + 1;   // complemento de 2
                  R := A+R;
               end;
         _ADD: R := A+B;              // Add operando ao acumulador
         _SUB: begin                  // Subtrai operando do acumulador
                  R := (not B) + 1;   // complemento de 2
                  R := A+R;
               end;
         _AND: R := A and B;          // And logico do ocperando c/ o acumulador
         _XOR: R := A xor B;          // Xor logico do ocperando c/ o acumulador
      end;
      // atualiza ...
      SetLength(Values, 0);
      SetLength(Items, 0);
      SetLength(DataFlows, 0);
      if ULA.Value <> (R and $FF) then begin
        ULA.Value := R and $FF;
        InsertReg([ULA.Value], [stULA], []);
      end;
      if ULA.Z <> (ULA.Value = 0) then begin
        ULA.Z := (ULA.Value = 0);
        InsertReg([byte(ULA.Z), byte(ULA.Z)], [stZ, sxZ], [shZOut1, shZOut2, shZOut3, shZOut4, shZOut5, shZOut6]);
      end;
      if ULA.N <> ((R and $80) = $80) then begin
        ULA.N := (R and $80) = $80;
        InsertReg([byte(ULA.N), byte(ULA.N)], [stN, sxN], [shNOut1, shNOut2, shNOut3, shNOut4]);
      end;
      if ULA.C <> ((R and $100) = $100) then begin
        ULA.C := (R and $100) = $100;
        InsertReg([byte(ULA.C), byte(ULA.C)], [stC, sxC], [shCOut1, shCOut2, shCOut3, shCOut4]);
      end;
      // ... e mostra novos valores da saida da ULA
      PulseClock(Values, Items, DataFlows);
   end;
end;

procedure MARToPC; begin
  with CPU, frmCPU do begin
    PC := MAR;
    PulseClock(PC, stPC, [shMAROut1, shMAROut2, shBI1, shBI2, shBI3, shPCIn1, shPCIn2]);   // atualiza PC com novo valor
  end;
end;

procedure PCToMAR; begin
  with CPU, frmCPU do begin
    MAR := PC;
    PulseClock(MAR, stMAR, [shPCOut1, shPCOut2, shBI1, shBI2, shBI3, shMARIn1, shMARIn2, shMAROut3, shMAROut4, shBE1, shBE2]);   // atualiza PC com novo valor
  end;
end;

procedure MemToMDR; begin
  with CPU, frmCPU do begin
    MDR := Mem[MAR];
    PulseClock([MDR], [stMDR], [shRD1, shRD2, shMDRIn3, shMDRIn4, shBD1, shBD2]);  // le endereco do operando
  end;
end;

procedure Execute;
{ Implementa a fase de Execucao de uma instrucao }
begin
  with CPU, UControl, frmCPU do begin
    // Mostra que estamos na fase de execucao
    SetPhase(_Execute);
    case OpCode of
      _HLT: begin
               S := 3;       // se HALT, apenas vah para o estado terminal 3
               PulseClock([], [], []);
            end;
      _NOP: PulseClock([], [], []);      // nada a fazer!
      _NOT: begin
               A := ACC; // envia ACC para entrada da ULA
               ProcessULA;                   // processa operacao
               PulseClock([A], [stA], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
               ACC := ULA.Value;             // retorna valor a ACC
               PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
            end;
      _JMP: MARToPC;
      _JEQ: if ULA.Z then MARToPC;
      _JGT: if not(ULA.Z or ULA.N) then MARToPC;
      _JGE: if not ULA.N then MARToPC;
      _STO: begin
               MDR := ACC;
               PulseClock([MDR], [stMDR], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shMDRIn1, shMDRIn2]);
               Mem[MAR] := MDR; // armazena ACC na memoria
               sgMemoria.Cells[1, MAR+1] := IntToHex(Mem[MAR], 2);
               ShowMem(MAR);
               PulseClock([], [], [shMDROut3, shMDROut4, shBD1, shBD2, shWR1, shWR2]);
               ShowMem(PC);
            end;
      _LOD: begin
               MemToMDR;
               A := MDR;   // transfere para A
               PulseClock([A], [stA], [shMDROut1, shMDROut2, shBI1, ShBI2, shBI3, shAIn1, shAIn2]);
               ProcessULA;
               ACC := A; // Trasfere para ACC
               PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
            end;
      _CMP: begin
               MemToMDR;
               A := ACC; // transfere ACC para entrada da ULA
               B := MDR; // trasfere valor para entrada da ULA
               PulseClock([A, B], [stA, stB],
                 [shACCOut1, shACCOut2, shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shAIn1, shAIn2, shBIn1, shBIn2]);
               ProcessULA; // computa resultado da operacao
            end;
      _ADD,
      _SUB,
      _AND,
      _XOR: begin
               MemToMDR;
               A := ACC; // transfere ACC para entrada da ULA
               B := MDR; // trasfere valor para entrada da ULA
               PulseClock([A, B], [stA, stB],
                 [shACCOut1, shACCOut2, shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shAIn1, shAIn2, shBIn1, shBIn2]);
               ProcessULA;                // computa resultado da operacao
               ACC := ULA.Value; // coloca resultado em ACC
               PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
            end;
    end;
  end;
  with UControl do begin
    if S < 3 then S := 0;           // se nao encontrou HALT, reinicia ciclo
    T := 0;
  end;
  ShowMem(CPU.PC);
  Pause(_Cycle); // Se modo "Single Cycle, aguarda comando do usuario para iniciar novo ciclo
end;

procedure FetchOperandAddr;
{ Implementa a fase de Busca do Operando de uma instrucao }
begin
  with CPU, frmCPU do begin
    { mostra em que fase estamos }
    SetPhase(_Operand);
    if DW then begin // se instrucao de 2 palavras ...
      // PC aponta para a segunda palavra
      PCToMAR;
      if ED then begin // se enderecamento direto ...
        // subciclo S = 1
        MemToMDR;
        MAR := MDR;
        PulseClock([MAR], [stMAR], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shMARIn1, shMARIn2]);
      end;
      inc(PC);
      PulseClock([PC], [stPC], []);
    end;
  end;
  with UControl do begin
    S := 2;    // avanca maquina de estado para a outra fase
    T := 0;
  end;
end;

procedure FetchOpCode;
var
  D, E: byte;
  Operando : string;
begin
   with CPU, frmCPU do begin
      { Mostra onde estamos }
      SetPhase(_Fetch);
      PCToMAR;
      MemToMDR; // Le OPCode
      IR := MDR; PulseClock([IR], [stIR], [shMDROut1, shMDROut2, shBI1,shBI2, shBI3, shIRIn1, shIRIn2]); // coloca em IR
      inc(PC); PulseClock([PC], [stPC], []);
      // Decodifica OpCode
      case IR of
            $00: OpCode := _HLT;
            $01: OpCode := _NOP;
            $02: OpCode := _NOT;
            $C4: OpCode := _JMP;
            $C5: OpCode := _JEQ;
            $C6: OpCode := _JGT;
            $C7: OpCode := _JGE;
            $D0: OpCode := _STO;
        $91,$D1: OpCode := _LOD;
        $94,$D4: OpCode := _CMP;
        $95,$D5: OpCode := _ADD;
        $96,$D6: OpCode := _SUB;
        $9A,$DA: OpCode := _AND;
        $9B,$DB: OpCode := _XOR;
      else
        OpCode := _Invalid;
      end;
      D := (IR and DoubleMask) shr 7; DW := boolean(D);   // Instrucao de 2 Bytes
      E := (IR and DirectMask) shr 6; ED := boolean(E);   // Enderecamento Direto
      // Mostra operacao decodificada da instrucao
      if DW then begin
        Operando := IntToHex(Mem[PC], 2);
        if ED then
          Operando := '[' + Operando + ']'
        else
          Operando := ' ' + Operando;
      end
      else
        Operando := '';
      ShowReg(stDI, OpCodeStr[Byte(OpCode)] + Operando);
      stDI.Font.Color := clRed;
      PulseClock([], [], [shIROut1, shIROut2, shIROut3, shIROut4, shIROut5, shIROut6, shIROut7, shIROut8,
        shIROut9, shIROut10, shIROut11, shIROut12, shIROut13, shIROut14, shIROut15, shIROut16,
        shUCIn1, shUCIn2, shUCIn3, shUCIn4, shUCIn5, shUCIn6]);
      stDI.Font.Color := clBlack;
   end;
   // Determina estado seguinte
   with UControl do begin
     if CPU.DW then
       S := 1
     else
       S := 2;
     T := 0;
   end;
  with CPU do
    if OpCode = _Invalid then begin
      Buzz;
      ShowMessage('INVALID OpCode!');
      OpCode := _HLT;
      UControl.S := 3;
    end;
end;

procedure RunStep; begin
  case UControl.S of        // discrimina fase pelo estado atual
     0: begin
          ShowMem(CPU.PC);
          FetchOpCode;
        end;
     1: FetchOperandAddr;
     2: Execute;
     3: Cmd := _Halt;
  end;
end;

procedure RunProgram;
{ Nucleo da maquina de estados de controle da ICP }
begin
// Repete ateh chegar ao estado terminal S = 3 (HALT)
  repeat
    RunStep;
  until Cmd = _Halt;
  frmCPU.ilImagens.GetBitmap(0, frmCPU.sbStatus.Picture.Bitmap);
end;

// Inicializacao do Controle
begin
  with UControl do begin
    S := 0;
    T := 0;
    Timer := 10;
  end;
end.
