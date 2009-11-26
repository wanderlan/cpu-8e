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
  LastR        : byte;
  LastItem     : TStaticText;
  LastDataFlow : array of TShape = nil;

procedure UnFlash(R: byte; Item: TStaticText; DataFlow : array of TShape);
{ Desfaz o realce de um dado, realcado pela rotina "Flash" }
var
  I : integer;
begin
  if Item <> nil then begin
    Item.Caption := copy(Item.Name, 3, 3) + ':' + IntToHex(R,2);
    Item.Font.Color := clBlack;
  end;
  for I := 0 to high(DataFlow) do
    DataFlow[I].Brush.Color := DataFlow[I].Tag;
  Application.ProcessMessages;
end;

procedure Flash(R: byte; Item: TStaticText; DataFlow : array of TShape);
{ Faz o realce de um dado, cujo valor e localizacao sao passados como
  paramentros. Eh utilizada para indicar uma mudanca de valor de um
  elemento da UCP }
var
  I : integer;
begin
  LastR        := R;
  LastItem     := Item;
  SetLength(LastDataFlow, high(DataFlow)+1);
  if Item <> nil then begin
    Item.Caption := copy(Item.Name, 3, 3) + ':' + IntToHex(R,2);
    Item.Font.Color := clRed;
    if Item = frmCPU.stPC then ShowMem(CPU.PC);
  end;
  for I := 0 to high(DataFlow) do
    with DataFlow[I] do begin
      Tag := Brush.Color;
      Brush.Color := clRed;
      LastDataFlow[I] := DataFlow[I]
    end;
  Application.ProcessMessages;
end;

procedure PulseClock(Off: boolean);
{ Faz a temporizacao do clock do sistema, conforme estabelecido pelo comando
  'Clock' do simulador }
begin
  if CPUMode =_Step then begin
// Se em modo "Single Step", cada pulso de clock aguarda uma tecla ser
// pressionada pelo usuario
    Cmd := _Pause;
    repeat
      Sleep(10);
      Application.ProcessMessages;
      if Cmd in [_Rst, _Halt, _Load, _Exit] then begin
        UnFlash(LastR, LastItem, LastDataFlow);
        Abort;
      end;
    until Cmd <> _Pause;
(*     if Off then
         write('Press any key ... ')
      else
         write('Press a Cmd key or any other ... ');
      //repeat until keypressed;
      //if Off then readkey;
   end else*)
  end;
  // senao simplesmente aguarda um intervalo de tempo estabelecido pelo "Clock"
  sleep(Ucontrol.Timer);
  inc(UControl.T);
end;

procedure ProcessULA;
{ Na fase de execucao, aqui eh computadi o valor de saihda da ULA, caso
  a operacao envolva esta }
var
  R: Word;       // variavel auxiliar para o computo da saihda
begin
   with CPU do begin
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
      ULA.Value := R and $FF;
      ULA.Z := (ULA.Value = 0);
      ULA.N := (R and $80) = $80;
      ULA.C := (R and $100) = $100;
// ... e mostra novos valores da saihda da ULA
      with frmCPU do begin
        ShowReg(stULA,ULA.Value);
        ShowReg(stZ, Byte(ULA.Z));
        ShowReg(stN, Byte(ULA.N));
        ShowReg(stC, Byte(ULA.C));
        ShowReg(sxZ, Byte(ULA.Z));
        ShowReg(sxN, Byte(ULA.N));
        ShowReg(sxC, Byte(ULA.C));
      end;
   end;
end;

procedure MARToPC; begin
  with CPU, frmCPU do begin
    PC := MAR; Flash(PC,stPC, [shMAROut1, shMAROut2, shBI1, shPCIn1, shPCIn2]);   // atualiza PC com novo valor
    PulseClock(false); UnFlash(PC,stPC, [shMAROut1, shMAROut2, shBI1, shPCIn1, shPCIn2]);
  end;
end;

procedure PCToMAR; begin
  with CPU, frmCPU do begin
    MAR := PC; Flash(MAR,stMAR, [shPCOut1, shPCOut2, shBI1, shMARIn1, shMARIn2]);   // atualiza PC com novo valor
    PulseClock(false); UnFlash(MAR,stMAR, [shPCOut1, shPCOut2, shBI1, shMARIn1, shMARIn2]);
  end;
end;

procedure MemToMDR; begin
  with CPU, frmCPU do begin
    MDR := Mem[MAR]; Flash(MDR,stMDR, [shRD1, shRD2, shMDRIn3, shMDRIn4, shBD1, shBD2]);  // le endereco do operando
    PulseClock(true); UnFlash(MDR,stMDR, [shRD1, shRD2, shMDRIn3, shMDRIn4, shBD1, shBD2]);
  end;
end;

procedure Execute;
{ Implementa a fase de Execucao de uma instrucao }
begin
   with CPU, UControl, frmCPU do begin
     // Mostra que estamos na fase de execucao
     pgPhase.Caption  := 'Execute';
     pgPhase.Position := 100;
   case OpCode of
      _HLT: begin
               S := 3;       // se HALT, apenas vah para o estado terminal 3
               PulseClock(false);
            end;
      _NOP: PulseClock(false);      // nada a fazer!
      _NOT: begin
               A := ACC; Flash(A,stA, [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);      // envia ACC para entrada da ULA
               ProcessULA;                   // processa operacao
               PulseClock(true); UnFlash(A,stA, [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
               ACC := ULA.Value;             // retorna valor a ACC
               Flash(ACC,stACC, []); Flash(ACC,stACC, []);
               PulseClock(false); UnFlash(ACC,stACC, []);
            end;
      _JMP: MARToPC;
      _JEQ: if ULA.Z then MARToPC;
      _JGT: if not(ULA.Z or ULA.N) then MARToPC;
      _JGE: if not ULA.N then MARToPC;
      _STO: begin
               MDR := ACC; Flash(MDR,stMDR, [shACCOut1, shACCOut2, shBI1, shMDRIn1, shMDRIn2]);
               PulseClock(true); UnFlash(MDR,stMDR, [shACCOut1, shACCOut2, shBI1, shMDRIn1, shMDRIn2]);
               Mem[MAR] := MDR; Flash(0, nil, [shMDROut3, shMDROut4, shBD1, shBD2, shWR1, shWR2]); // armazena ACC na memoria
               //ShowMem(MAR);
               PulseClock(false); UnFlash(0, nil, [shMDROut3, shMDROut4, shBD1, shBD2, shWR1, shWR2]);
               //ShowMem(PC);
            end;
      _LOD: begin
               MemToMDR;
               A := MDR; Flash(A,stA, []);            // transfere para A
               ProcessULA; Flash(ULA.Value,stULA, []);
               PulseClock(true); UnFlash(A,stA, []); UnFlash(ULA.Value,stULA, []);
               ACC := A; Flash(ACC,stACC, []);        // Trasfere para ACC
               PulseClock(false); UnFlash(ACC,stACC, []);
            end;
      _CMP: begin
               MemToMDR;
               A := ACC; Flash(A,stA, []);   // transfere ACC para entrada da ULA
               B := MDR; Flash(B,stB, []);   // trasfere valor para entrada da ULA
               ProcessULA;                // computa resultado da operacao
               PulseClock(false); UnFlash(A,stA, []); UnFlash(B,stB, []);
            end;
      _ADD,
      _SUB,
      _AND,
      _XOR: begin
               MemToMDR;
               A := ACC; Flash(A,stA, []);   // transfere ACC para entrada da ULA
               B := MDR; Flash(B,stB, []);   // trasfere valor para entrada da ULA
               ProcessULA;                // computa resultado da operacao
               PulseClock(true); UnFlash(A,stA, []); UnFlash(B,stB, []);
               ACC := ULA.Value; Flash(ACC,stACC, []);  // coloca resultado em ACC
               PulseClock(false); UnFlash(ACC,stACC, []);
            end;
   end;

   end;
   with UControl do
   begin
      if S < 3 then S := 0;           // se nao encontrou HALT, reinicia ciclo
      T := 0;
   end;
   if CPUMode =_Cycle then
// Se modo "Single Cycle, aguarda comando do usuario para iniciar novo ciclo
   begin
      ShowMem(CPU.PC);
      write('Press a key ...');
      //repeat until keypressed;
   end;
end;

procedure FetchOperandAddr;
{ Implementa a fase de Busca do Operando de uma instrucao }
begin
   with CPU, frmCPU do begin
{ mostra em que fase estamos }
    pgPhase.Caption  := 'Operando';
    pgPhase.Position := 50;
   if DW then
// se instrucao de 2 palavras ...
   begin
// PC aponta para a segunda palavra
      PCToMAR;
      inc(PC); Flash(PC,stPC, []);
      if ED then
// se enderecamento direto ...
      begin
// subciclo S = 1
         MemToMDR;
         UnFlash(PC,stPC, []);
         MAR := MDR; Flash(MAR, stMAR, [shMDROut1, shMDROut2, shBI1, shMARIn1, shMARIn2]);
      end;
      PulseClock(false);
      if ED then
        UnFlash(MAR,stMAR, [shMDROut1, shMDROut2, shBI1, shMARIn1, shMARIn2])
      else
        UnFlash(PC,stPC, []);
   end;
   end;
   with UControl do
   begin
      S := 2;    // avanca maquina de estado para a outra fase
      T := 0;
   end;
end;

procedure FetchOpCode;
var
   D,E: byte;
   Operando : string;
begin
   with CPU, frmCPU do
   begin
    { Mostra onde estamos }
      pgPhase.Caption  := 'Fetch';
      pgPhase.Position := 10;
      PCToMAR;
      inc(PC); Flash(PC,stPC, []);
      MemToMDR;   // Le OPCode
      UnFlash(PC,stPC, []);
      IR := MDR; Flash(IR,stIR, [shMDROut1, shMDROut2, shBI1, shIRIn1, shIRIn2]);           // coloca em IR
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
      PulseClock(false); UnFlash(IR,stIR, [shMDROut1, shMDROut2, shBI1, shIRIn1, shIRIn2]);
      stDI.Font.Color := clBlack;
   end;
// Determina estado seguinte
   with UControl do
   begin
      if CPU.DW then
         S := 1
      else
         S := 2;
      T := 0;
   end;
   with CPU do if OpCode = _Invalid then
   begin
      Buzz;
      ShowMessage('INVALID OpCode!');
      OpCode := _HLT;
      UControl.S := 3;
   end;
end;

procedure RunStep;
begin
  case UControl.S of        // discrimina fase pelo estado atual
     0: begin
           ShowMem(CPU.PC);
           FetchOpCode;
        end;
     1: FetchOperandAddr;
     2: Execute;
     3: Cmd := _Halt;
  end;
//      if keypressed then exit;
end;

procedure RunProgram;
{ Nucleo da maquina de estados de controle da ICP }
begin
// Repete ateh chegar ao estado terminal S = 3 (HALT)
  repeat
    RunStep;
  until Cmd = _Halt;
end;

// Inicializacao do Controle
begin
   with UControl do
   begin
      S := 0;
      T := 0;
      Timer := 10;
   end;
end.

