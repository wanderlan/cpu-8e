{%RunFlags BUILD-}
unit CPU8E_Control;

{
  CPU-8E Simulator

                                 Copyright 2009/10 Joel Guilherme da Silva Filho

  Simulador para uma CPU Educacional de 8-bits, conforme especificacoes
  contidas no documento CPU-8E-Specs-vX.Y.pdf ('X.Y' indica a versão atual
  do programa), parte deste pacote.

  Este programa, e todos seus componentes, eh colocado aa disposicao do publico
  na forma de um 'Programa Livre' ("Free Software") sob uma licenca "GNU -
  General Public License" (Copyleft), sendo assim entendido que voce tem o
  direito de utiliza-lo livremente, sem pagar quaisquer direitos por isto,
  inclusive o direito de copia-lo, modifica-lo e redistribui-lo, desde que
  mantidos estes termos a quaisquer copias ou modificacoes.
  Este programa eh distribuido na esperanca de que possa ser util, mas SEM
  NENHUMA GARANTIA, IMPLICITA OU EXPLICITA, de ADEQUACAO a qualquer MERCADO
  ou APLICACAO EM PARTICULAR. Para maiores detalhes veja o documento
  "Copiando(GPL).txt", parte integrante deste pacote de programa.

  Autor: Prof. Joel Guilherme da Silva Filho
         joel@joelguilherme.com
  Organização: IESB - Instituto de Educação Superior de Brasília
  Local: Brasília/DF, Brasil

  Contribuicoes:
  V2.0 - Wanderlan Santos dos Anjos e Barbara A.B. dos Anjos
         wanderlan.anjos@gmail.com
         barbara.ab.anjos@gmail.com
  V2.1 - Wanderlan Santos dos Anjos e Barbara A.B. dos Anjos
         wanderlan.anjos@gmail.com
         barbara.ab.anjos@gmail.com
  V2.2 - Anderson de Souza Freitas e Daniel Machado Vasconcelos
         anderson.souza.freitas@gmail.com
         danielm.vasconcelos@gmail.com

  Historico:
    Versao 0.9    - 01/02/2009 - Primeira versão totalmente operacional.
    Versao 1.0a   - 04/02/2009 - Corrigida logica "Single Step"/"Single Cycle".
                               - Corrigida representacao para enderecamento
                                 Imediato/Direto.
    Versao 1.0b   - 28/04/2009 - Registradores CPU.A e CPU.B (ULA) foram
                                 redefinidos como do tipo "Byte"
                               - Corrigida lógica de geração dos flags da ULA.
    Versao 2.0    - 24/11/2009 - Interface modo texto substituida por interface
                                 grafica construida com o Lazarus/FPC,
                                 permitindo compilacao multiplataforma.
    Versao 2.1    - 16/12/2009 - Introduzido o disassembly automatico dos
                                 codigos em memoria.
                                 Introduzidas facilidades para editar e salvar
                                 um programa no simulador.
    Versao: 2.2.0 - 21/07/2010 - Expandido conjunto de instrucoes para incluir
                                 shifts, rotates e chamada de sub-rotina.
                               - Revistas funcoes de controle e do simulador.
    Versao: 2.2.2 - 09/10/2010 - Revisao geral do codigo com total adequacao
                                 deste aas especificacoes da CPU-8Ev2.0.
}

{
  CPU8E_Control.pas
  Esta Unit implementa a logica da unidade de controle da UCP-8E, o mais proximo
  das especificacoeso quanto nos foi possivel implementar em software.
  Ver documento de especificacao da CPU-8E, "CPU-8E-Specs-vX.Y.pdf"
}

interface

uses
  CPU8E;

var
  // Define o estado atual da Unidade de Controle
  UControl: record
    S:     byte;          // variavel de estado 'S' que indica a fase de execucao
    // do ciclo de instrucao
    T:     byte;          // indicador do ciclo de clock interno de cada fase
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
// Decodifica OpCode
procedure DecodeOpCode(IR : byte; out OpCode : OpCodeType; out DW, ED : boolean);

implementation

uses
  SysUtils, StdCtrls, Graphics, Dialogs, ExtCtrls, Forms,
  CPU8E_Utils, CPU8E_Panel;

var
  LastR       : array of byte = nil;
  LastItem    : array of TStaticText = nil;
  LastDataFlow: array of TShape = nil;

procedure SetValue(var R: Byte; var Item: TStaticText);
begin
   Item.Caption    := copy(Item.Name, 3, 3) + ':' + IntToHex(R, LenReg(Item));
end;

procedure UnFlash;
{ Desfaz o realce de um dado, realcado pela rotina "Flash" }
var
  I: integer;
begin
  for I := 0 to high(LastItem) do begin
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
  I: integer;
begin
  SetLength(LastR, high(R) + 1);
  SetLength(LastItem, high(Item) + 1);
  SetLength(LastDataFlow, high(DataFlow) + 1);
  for I := 0 to high(LastItem) do begin
    SetValue(R[I],Item[I]);
    Item[I].Font.Color := clRed;
    if Item[I] = frmCPU.stPC then ShowMem(CPU.PC);
    LastR[I]    := R[I];
    LastItem[I] := Item[I];
  end;
  for I := 0 to high(DataFlow) do
    with DataFlow[I] do begin
      Tag := Brush.Color;
      Brush.Color := clRed;
      LastDataFlow[I] := DataFlow[I];
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

procedure PulseClock(R : array of byte; Item : array of TStaticText; DataFlow : array of TShape);
{ Faz a temporizacao do clock do sistema, conforme estabelecido pelo comando
  'Clock' do simulador }
begin
  Flash(R, Item, DataFlow);
  Pause(_Step);
  // senao simplesmente aguarda um intervalo de tempo estabelecido pelo "Clock"
  Sleep(Ucontrol.Timer);
  Inc(UControl.T);
  UnFlash;
end;

procedure ProcessULA;
{ Na fase de execucao, aqui eh computado o valor de saida da ULA, caso
  a operacao envolva esta }
var
  R         : word;       // variavel auxiliar para o computo da saida
  Values    : array of byte;
  Items     : array of TStaticText;
  DataFlows : array of TShape;

  procedure InsertReg(Value : array of byte; Item : array of TStaticText; DataFlow : array of TShape);
  var
    I: integer;
  begin
    for I := 0 to high(Value) do begin
      SetLength(Values, Length(Values) + 1);
      Values[high(Values)] := Value[I];
    end;
    for I := 0 to high(Item) do begin
      SetLength(Items, Length(Items) + 1);
      Items[high(Items)] := Item[I];
    end;
    for I := 0 to high(DataFlow) do begin
      SetLength(DataFlows, Length(DataFlows) + 1);
      DataFlows[high(DataFlows)] := DataFlow[I];
    end;
  end;

  procedure SetFlags;
  begin
    with CPU, frmCPU do begin
      ULA.Z := (ULA.Value = 0);
      InsertReg([byte(ULA.Z), byte(ULA.Z)], [stZ, sxZ], [shZOut1, shZOut2, shZOut3, shZOut4, shZOut5, shZOut6]);
      ULA.N := (R and $80) = $80;
      InsertReg([byte(ULA.N), byte(ULA.N)], [stN, sxN], [shNOut1, shNOut2, shNOut3, shNOut4]);
      ULA.C := (R and $100) = $100;
      InsertReg([byte(ULA.C), byte(ULA.C)], [stC, sxC], [shCOut1, shCOut2, shCOut3, shCOut4]);
      with ULA do begin
        SetValue(Byte(Z),stZ);
        SetValue(Byte(N),stN);
        SetValue(Byte(C),stC);
      end;
    end;
  end;

begin
  with CPU, frmCPU do begin
    case OpCode of
      _NOT: R := not A;           // Negacao logica
      _LOD: R := A;               // Load acumulador
      _CMP: begin                 // Subtrai operando do acumulador
        R := (not B) + 1;         // complemento de 2
        R := R + A;
      end;
      _ADD: begin                 // Add operando ao acumulador
        R := A;
        R := R + B;
      end;
      _SUB: begin                 // Subtrai operando do acumulador
        R := (not B) + 1;         // complemento de 2
        R := R + A;
      end;
      _AND: begin
        R := A and B;         // And logico do ocperando c/ o acumulador
      end;
      _XOR: begin
        R := A xor B;         // Xor logico do ocperando c/ o acumulador
      end;
      _ORL: begin
        R := A or B;          // Or logico do operador c/ o acumulador
      end;
      _SHL: begin;                // Shift Left  c/ o acumulador
        R := A;
        R := R shl 1;
      end;
      _SHR: begin
        R := A shr 1;         // Shift Right c/ o acumulador
        if odd(A) then R := R or $100;
      end;
      _SRA: begin                 // Shitf Right Aritimetico
        if (A and $80) > 0 then
          R := (A shr 1) or $80
        else
          R := A shr 1;
        if odd(A) then R := R or $100;
      end;
      _ROL: begin                  //Rotate Left
        R := A shl 1;
        if (A and $80) > 0 then
          R := R or $101;
      end;
      _ROR: begin                  //Rotate Right
         R := A shr 1;
         if odd(A) then
           R := R or $180
      end;
    end;
    // atualiza ...
    SetLength(Values, 0);
    SetLength(Items, 0);
    SetLength(DataFlows, 0);
    ULA.Value := R and $FF;
    SetFlags;
    InsertReg([ULA.Value], [stULA], []);
    // ... e mostra novos valores da saida da ULA
    PulseClock(Values, Items, DataFlows);
  end;
end;

// atualiza PC com novo valor
procedure MARToPC; begin
  with CPU, frmCPU do begin
    PC := MAR;
    PulseClock(PC, stPC, [shMAROut1, shMAROut2, shBI1, shBI2, shBI3, shPCIn1, shPCIn2]);
  end;
end;

procedure PCToMAR;  begin
  with CPU, frmCPU do begin
    MAR := PC;
    PulseClock(MAR, stMAR, [shPCOut1, shPCOut2, shBI1, shBI2, shBI3, shMARIn1, shMARIn2, shMAROut3, shMAROut4, shBE1, shBE2]);
  end;
end;

procedure MemToMDR; begin
  with CPU, frmCPU do begin
    MDR := Mem[MAR];
    PulseClock([MDR], [stMDR], [shRD1, shRD2, shMDRIn3, shMDRIn4, shBD1, shBD2]);
  end;
end;

procedure MDRToMem; begin
  with CPU, frmCPU do begin
    Mem[MAR] := MDR;
    PulseClock([], [], [shMDROut3, shMDROut4, shBD1, shBD2, shWR1, shWR2]);
    sgMemoria.Cells[1, MAR + 1] := IntToHex(Mem[MAR], 2);
    ShowMem(MAR);
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
      _NOP: PulseClock([], [], []); // nada a fazer!
      _NOT: begin
        A := ACC;   // envia ACC para entrada da ULA
        ProcessULA; // processa operacao
        PulseClock([A], [stA], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        ACC := ULA.Value;  // retorna valor a ACC
        PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
      end;
      _JMP: MARToPC;
      _JEQ: if ULA.Z then MARToPC;
      _JGT: if not (ULA.Z or ULA.N) then MARToPC;
      _JGE: if not ULA.N then MARToPC;
      _JCY: if ULA.C then MARToPC;       //Jump if carry
      _STO: begin
        MDR := ACC;
        PulseClock([MDR], [stMDR], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shMDRIn1, shMDRIn2]);
        MDRToMem;    // armazena ACC na memoria
        sgMemoria.Cells[1, MAR + 1] := IntToHex(Mem[MAR], 2);
        ShowMem(MAR);
        PulseClock([], [], [shMDROut3, shMDROut4, shBD1, shBD2, shWR1, shWR2]);
        ShowMem(PC);
      end;
      _LOD: begin
        MemToMDR;
        A := MDR;   // transfere para A
        PulseClock([A], [stA], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        ProcessULA;
        ACC := A; // Trasfere para ACC
        PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
      end;
      _CMP: begin
        MemToMDR;
        A := ACC; // transfere ACC para entrada da ULA
        PulseClock([A], [stA], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        B := MDR; // trasfere valor para entrada da ULA
        PulseClock([B], [stB], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shBIn1, shBIn2]);
        ProcessULA; // computa resultado da operacao
      end;
      _ADD,
      _SUB,
      _AND,
      _XOR,
      _ORL: begin
        MemToMDR;
        A := ACC; // transfere ACC para entrada da ULA
        PulseClock([A], [stA], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        B := MDR; // trasfere valor para entrada da ULA
        PulseClock([B], [stB], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shBIn1, shBIn2]);
        ProcessULA;       // computa resultado da operacao
        ACC := ULA.Value; // coloca resultado em ACC
        PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
      end;
      _CAL: begin   //Call Procedure
        MDR := PC;    // Salva endereco de retorno no MDR
        PulseClock([MDR], [stMDR], [shPCOut1,shPCOut2,shBI1,shBI2,shBI3,shMDRIn1,shMDRIn2]);
        PC := MAR;    // Endereca o procedimento sendo chamado
        PulseClock([PC], [stPC], [shMAROut1,shMAROut2,shBI1,shBI2,shBI3,shPCIn1,shPCIn2]);
        MAR := SP;
        PulseClock([MAR], [stMAR], [shSPOut1,shSPOut2,shBI1,shBI2,shBI3,shMARIn1,shMARIn2]);
        MDRToMem;    // Salva PC (endereco de retorno) na pilha
        SP := SP -1; //Movimenta o ponteiro da pilha para baixo
        SetValue(SP,stSP);
      end;
      _RET: begin   //Return Procedure
         SP := SP + 1;  // Movimenta o ponteiro da pilha para cima
         SetValue(SP,stSP);
         MAR := SP;
         PulseClock([MAR], [stMAR], [shSPOut1,shSPOut2,shBI1,shBI2,shBI3,shMARIn1,shMARIn2]);
         MemToMDR;
         PC := MDR; //pega o valor que esta na pilha e copia para o PC
         PulseClock([PC], [stPC], [shMDROut1,shMDROut2,shBI1,shBI2,shBI3,shPCIn1,shPCIn2]);
      end;
      _SHL,
      _SHR,
      _SRA,
      _ROL,
      _ROR: begin
        MemToMDR;
        B := MDR; // 'B' eh o contador para shifts e rotates
        PulseClock([B], [stB], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shBIn1, shBIn2]);
        A := ACC; // transfere ACC para entrada da ULA
        PulseClock([A], [stA], [shACCOut1, shACCOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        while B>0 do
        begin
          ProcessULA; // computa resultado da operacao
          A :=ULA.Value;  // Move o resultado da operacao para A
          B := B - 1;  // decrementa B
          SetValue(B,stB);
          PulseClock([A], [stA], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shAIn1, shAIn2]);
        end;
        ACC := ULA.Value;  // retorna valor a ACC
        PulseClock([ACC], [stACC], [shULAOut1, shULAOut2, shBI1, shBI2, shBI3, shACCIn1, shACCIn2]);
      end;
    end;
  end;
  with UControl do begin
    if S < 3 then S := 0; // se nao encontrou HALT, reinicia ciclo
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
    if DW then begin // se instrucao de 2 palavras,  PC aponta para a segunda palavra
      PCToMAR;
      Inc(PC);
      SetValue(PC,stPC);
      if ED then begin // se enderecamento direto ... subciclo S = 1
        MemToMDR;
        MAR := MDR;
        PulseClock([MAR], [stMAR], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shMARIn1, shMARIn2, shMAROut3, shMAROut4, shBE1, ShBE2]);
      end;
    end;
  end;
  with UControl do begin
    S := 2; // avanca maquina de estado para a outra fase
    T := 0;
  end;
end;

procedure DecodeOpCode(IR : byte; out OpCode : OpCodeType; out DW, ED : boolean); begin
  case IR of
    $00: OpCode      := _HLT;
    $01: OpCode      := _NOP;
    $02: OpCode      := _NOT;
    $03: OpCode      := _RET;
    $C4: OpCode      := _JMP; {Direto}
    $C5: OpCode      := _JEQ; {Direto}
    $C6: OpCode      := _JGT; {Direto}
    $C7: OpCode      := _JGE; {Direto}
    $C8: OpCode      := _JCY; {Direto}
    $C9: OpCode      := _CAL; {Direto}
    $8A, $CA: OpCode := _SHL; {Imediato e Direto}
    $8B, $CB: OpCode := _SHR; {Imediato e Direto}
    $8C, $CC: OpCode := _SRA; {Imediato e Direto}
    $8D, $CD: OpCode := _ROL; {Imediato e Direto}
    $8E, $CE: OpCode := _ROR; {Imediato e Direto}
    $D0: OpCode      := _STO; {Direto}
    $91, $D1: OpCode := _LOD; {Imediato e Direto}
    $94, $D4: OpCode := _CMP; {Imediato e Direto}
    $95, $D5: OpCode := _ADD; {Imediato e Direto}
    $96, $D6: OpCode := _SUB; {Imediato e Direto}
    $9A, $DA: OpCode := _AND; {Imediato e Direto}
    $9B, $DB: OpCode := _XOR; {Imediato e Direto}
    $9C, $DC: OpCode := _ORL; {Imediato e Direto}
  else
    OpCode := _Invalid;
    DW := false;
    ED := false;
    exit;
  end;
  DW := boolean((IR and DoubleMask) shr 7); // Instrucao de 2 Bytes
  ED := boolean((IR and DirectMask) shr 6); // Enderecamento Direto
end;

procedure FetchOpCode;
var
  Operando: string;
begin
  with CPU, frmCPU do begin
    { Mostra onde estamos }
    SetPhase(_Fetch);
    PCToMAR;
    Inc(PC);
    SetValue(PC,stPC);
    MemToMDR; // Le OPCode
    IR := MDR;
    PulseClock([IR], [stIR], [shMDROut1, shMDROut2, shBI1, shBI2, shBI3, shIRIn1, shIRIn2]);
    // coloca em IR
    DecodeOpCode(IR, OpCode, DW, ED);
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
    ShowReg(stDI, OpCodeStr[OpCode] + Operando);
    stDI.Font.Color := clRed;
    PulseClock([], [], [shIROut1, shIROut2, shIROut3, shIROut4, shIROut5, shIROut6, shIROut7, shIROut8, shIROut9, shIROut10,
      shIROut11, shIROut12, shIROut13, shIROut14, shIROut15, shIROut16, shUCIn1, shUCIn2, shUCIn3, shUCIn4, shUCIn5, shUCIn6]);
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
      OpCode     := _HLT;
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
  Application.ProcessMessages;
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
    S     := 0;
    T     := 0;
    Timer := 10;
  end;
end.
