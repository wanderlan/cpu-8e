unit CPU8E_Panel;

{$mode objfpc}{$H+}

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
    Versao: 2.2.3 - 18/10/2010 - Componente TShapeEx para facilitar instalação
                                 no Lazarus.
}

{
  CPU8E_Panel.pas
  Esta Unit implementa a parte visual do simulador e as funcoes de interacao
  com o usuario.
}

interface

uses
  Classes, SysUtils, Process, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, Menus, Grids, ComCtrls, Buttons, ActnList, CPU8E,
  ShapeEx;

type

  { TfrmCPU }

  TfrmCPU = class(TForm)
    acLoad: TAction;
    acGo: TAction;
    acPause: TAction;
    acHalt: TAction;
    acReset: TAction;
    acExit: TAction;
    acHelp: TAction;
    acSave: TAction;
    acStatus: TAction;
    alAtalhos: TActionList;
    Bevel1: TBevel;
    Bevel2: TBevel;
    ClockSelect: TComboBox;
    ilImagens: TImageList;
    Label1: TLabel;
    sbStatus: TImage;
    IR0 : TShapeEx;
    IR1 : TShapeEx;
    IR2 : TShapeEx;
    IR3 : TShapeEx;
    IR4 : TShapeEx;
    IR5 : TShapeEx;
    cbMode: TComboBox;
    lblFetch: TLabel;
    lblOperand: TLabel;
    lblExecute: TLabel;
    odLoad: TOpenDialog;
    Panel1: TPanel;
    sdSave: TSaveDialog;
    sbSave: TSpeedButton;
    Shape19: TShapeEx;
    Shape20: TShapeEx;
    shSPIn2: TShapeEx;
    Shape16: TShapeEx;
    shSPOut1: TShapeEx;
    shSPOut2: TShapeEx;
    shSPIn1: TShapeEx;
    Shape1 : TShapeEx;
    Shape10 : TShapeEx;
    shFetch: TShapeEx;
    shOperand: TShapeEx;
    shExecute: TShapeEx;
    shRD1 : TShapeEx;
    shRD2 : TShapeEx;
    shWR1 : TShapeEx;
    shWR2 : TShapeEx;
    shZOut1 : TShapeEx;
    shZOut3 : TShapeEx;
    shNOut1 : TShapeEx;
    shZOut2 : TShapeEx;
    Shape108 : TShapeEx;
    shCOut2 : TShapeEx;
    shCOut1 : TShapeEx;
    shNOut2 : TShapeEx;
    shZOut5 : TShapeEx;
    shZOut6 : TShapeEx;
    shNOut3 : TShapeEx;
    shNOut4 : TShapeEx;
    shCOut4 : TShapeEx;
    shCOut3 : TShapeEx;
    shZOut4 : TShapeEx;
    Shape12 : TShapeEx;
    Shape13 : TShapeEx;
    Shape14 : TShapeEx;
    Shape15 : TShapeEx;
    shBI1 : TShapeEx;
    shBI3 : TShapeEx;
    shULAOut2 : TShapeEx;
    shBI2 : TShapeEx;
    Shape2 : TShapeEx;
    shULAOut1 : TShapeEx;
    shACCOut1 : TShapeEx;
    shACCOut2 : TShapeEx;
    shMDROut1 : TShapeEx;
    shMDROut2 : TShapeEx;
    shACCIn1 : TShapeEx;
    shACCIn2 : TShapeEx;
    shPCIn1 : TShapeEx;
    shMDRIn1 : TShapeEx;
    shMDRIn2 : TShapeEx;
    Shape3 : TShapeEx;
    shPCOut1 : TShapeEx;
    shPCIn2 : TShapeEx;
    shPCOut2 : TShapeEx;
    shMARIn1 : TShapeEx;
    shMARIn2 : TShapeEx;
    shBIn2 : TShapeEx;
    Shape36 : TShapeEx;
    shIRIn1 : TShapeEx;
    shIRIn2 : TShapeEx;
    shBIn1 : TShapeEx;
    Shape4 : TShapeEx;
    shIROut1 : TShapeEx;
    shIROut2 : TShapeEx;
    shAIn2 : TShapeEx;
    shAIn1 : TShapeEx;
    shIROut3 : TShapeEx;
    shIROut4 : TShapeEx;
    shIROut5 : TShapeEx;
    shIROut6 : TShapeEx;
    shIROut7 : TShapeEx;
    shIROut8 : TShapeEx;
    Shape5 : TShapeEx;
    shIROut9 : TShapeEx;
    shIROut10 : TShapeEx;
    shIROut11 : TShapeEx;
    shIROut12 : TShapeEx;
    shIROut13 : TShapeEx;
    shIROut14 : TShapeEx;
    shIROut15 : TShapeEx;
    shIROut16 : TShapeEx;
    shUCIn1 : TShapeEx;
    shUCIn2 : TShapeEx;
    Shape6 : TShapeEx;
    shUCIn3 : TShapeEx;
    shUCIn4 : TShapeEx;
    shUCIn5 : TShapeEx;
    shUCIn6 : TShapeEx;
    Shape64 : TShapeEx;
    shClock1 : TShapeEx;
    shClock2 : TShapeEx;
    Shape68 : TShapeEx;
    Shape69 : TShapeEx;
    Shape7 : TShapeEx;
    Shape70 : TShapeEx;
    Shape71 : TShapeEx;
    Shape72 : TShapeEx;
    Shape73 : TShapeEx;
    Shape74 : TShapeEx;
    Shape75 : TShapeEx;
    Shape76 : TShapeEx;
    Shape77 : TShapeEx;
    Shape78 : TShapeEx;
    Shape79 : TShapeEx;
    Shape8 : TShapeEx;
    Shape80 : TShapeEx;
    Shape81 : TShapeEx;
    Shape82 : TShapeEx;
    Shape83 : TShapeEx;
    Shape84 : TShapeEx;
    Shape85 : TShapeEx;
    Shape86 : TShapeEx;
    Shape87 : TShapeEx;
    Shape88 : TShapeEx;
    Shape89 : TShapeEx;
    Shape9 : TShapeEx;
    shBD1 : TShapeEx;
    shBD2 : TShapeEx;
    shMDRIn3 : TShapeEx;
    shMDRIn4 : TShapeEx;
    shMDROut4 : TShapeEx;
    shMDROut3 : TShapeEx;
    shBE1 : TShapeEx;
    shBE2 : TShapeEx;
    shMAROut3 : TShapeEx;
    shMAROut4 : TShapeEx;
    shMAROut1: TShapeEx;
    shMAROut2: TShapeEx;
    spHelp: TSpeedButton;
    sbGo: TSpeedButton;
    sbPause: TSpeedButton;
    sbHalt: TSpeedButton;
    sbLoad: TSpeedButton;
    sbReset: TSpeedButton;
    spExit: TSpeedButton;
    stA : TStaticText;
    StaticText10 : TStaticText;
    StaticText25: TStaticText;
    StaticText26: TStaticText;
    stMAR: TStaticText;
    stSP: TStaticText;
    stULA : TStaticText;
    StaticText12 : TStaticText;
    stZ : TStaticText;
    stN : TStaticText;
    stC : TStaticText;
    sxZ : TStaticText;
    sxN : TStaticText;
    sxC : TStaticText;
    StaticText19 : TStaticText;
    stB : TStaticText;
    StaticText20 : TStaticText;
    StaticText21 : TStaticText;
    StaticText22 : TStaticText;
    StaticText24: TStaticText;
    stACC : TStaticText;
    stMDR : TStaticText;
    stIR : TStaticText;
    stPC : TStaticText;
    stDI : TStaticText;
    stUC1 : TStaticText;
    sgMemoria : TStringGrid;
    procedure acLoadExecute(Sender: TObject);
    procedure ClockSelectChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbModeChange(Sender: TObject);
    procedure sbHaltClick(Sender: TObject);
    procedure sbPauseClick(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure sgMemoriaSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure spExitClick(Sender: TObject);
    procedure sbGoClick(Sender: TObject);
    procedure spHelpClick(Sender: TObject);
    procedure sbResetClick(Sender: TObject);
    procedure stACCMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stACCMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stAMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stAMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stBMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stIRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stIRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stMARMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stMARMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stMDRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stMDRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stPCMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stPCMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stSPMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stSPMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stULAMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stULAMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure Disassembler;
    procedure LoadMem;
    procedure StoreMem;
    { private declarations }
  public
    procedure SetPhase(Phase: PhaseType);
    { public declarations }
  end; 

var
  frmCPU : TfrmCPU;

implementation

uses
  CPU8E_Utils, CPU8E_Oper, CPU8E_Control;

{ TfrmCPU }

procedure TfrmCPU.FormCreate(Sender: TObject);
var
  I : integer;
begin
  CPU_Caption := ProgName + ' ' + Version + ' - ' + Author;
  Caption := CPU_Caption;
  SetLocalDir;
  SetClock;
  for I := 0 to 255 do
    sgMemoria.Cells[0, I+1] := IntToHex(I, 2);
end;

procedure TfrmCPU.cbModeChange(Sender: TObject); begin
  CPUMode := ModeType(cbMode.ItemIndex);
end;

procedure TfrmCPU.sbHaltClick(Sender: TObject); begin
  Cmd := _Halt;
  frmCPU.ilImagens.GetBitmap(0, frmCPU.sbStatus.Picture.Bitmap);
  SetPhase(_Reset);
  acGo.Enabled := false;
  acPause.Enabled := false;
end;

procedure TfrmCPU.sbPauseClick(Sender: TObject); begin
  Cmd := _Pause;
  frmCPU.ilImagens.GetBitmap(1, frmCPU.sbStatus.Picture.Bitmap);
end;

procedure TfrmCPU.sbSaveClick(Sender: TObject);
var
  NRead : integer;
begin
  if sdSave.Execute then begin
    NRead := SaveFile(sdSave.FileName);
    if NRead >=0 then begin
      Caption := CPU_Caption + ' - ' + ExtractFileName(sdSave.FileName);
      ShowMessage('Foram gravados ' + IntToStr(NRead) + '(' + IntToHex(NRead, 2) + 'h) bytes para disco.');
    end
    else
      ShowMessage('Erro ao gravar arquivo ' + sdSave.FileName);
  end;
end;

procedure TfrmCPU.sgMemoriaSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string); begin
  CPU.Mem[ARow-1] := StrToIntDef('$' + Value, 0);
  sgMemoria.Cells[ACol, ARow] := IntToHex(CPU.Mem[ARow-1], 2);
  if ARow > CPU.LenProg then CPU.LenProg := ARow;
  Disassembler;
  acGo.Enabled    := CPU.LenProg <> 0;
  acPause.Enabled := acGo.Enabled;
  acHalt.Enabled  := acGo.Enabled;
  acReset.Enabled := acGo.Enabled;
end;

procedure TfrmCPU.spExitClick(Sender: TObject); begin
  Cmd := _Exit;
  Close;
end;

procedure TfrmCPU.sbGoClick(Sender: TObject); begin
  frmCPU.ilImagens.GetBitmap(2, frmCPU.sbStatus.Picture.Bitmap);
  if Cmd <> _Pause then begin
    Cmd := _Go;
    Run;
  end
  else
    Cmd := _Go;
end;

procedure TfrmCPU.spHelpClick(Sender: TObject);
var HProcess: TProcess;
begin
  if FileExists('CPU8E_Sim.txt') then
  begin
     HProcess := TProcess.Create(nil);
     HProcess.CommandLine := 'gedit CPU8E_Sim.txt';
     HProcess.Execute;
     HProcess.Free;
  end else
     MessageDlg('CPU-8E', 'Arquivo <CPU8E_Sim.txt> não encontrado', mtInformation, [mbOk], 0);
end;

// Disassembla o programa carregado em memória
procedure TfrmCPU.Disassembler;
var
  I : integer;
  OpCode : OpCodeType;
  DW, ED : boolean;
begin
  I := 0;
  while I < CPU.LenProg do begin
    DecodeOpCode(CPU.Mem[I], OpCode, DW, ED);
    sgMemoria.Cells[2, I+1] := OpCodeStr[OpCode];
    if DW then begin // Double word, instrução tem operando
      inc(I);
      sgMemoria.Cells[2, I+1] := IntToHex(CPU.Mem[I], 2);
      if ED then // Endereçamento direto
        sgMemoria.Cells[2, I+1] := '[' + sgMemoria.Cells[2, I+1] + ']';
    end;
    inc(I);
  end;
end;

procedure TfrmCPU.LoadMem;
var
  I : integer;
begin
  for I := 0 to 255 do begin
    sgMemoria.Cells[1, I+1] := IntToHex(CPU.Mem[I], 2);
    sgMemoria.Cells[2, I+1] := '';
  end;
  Disassembler;
end;

procedure TfrmCPU.StoreMem;
var
  I : integer;
begin
  for I := 0 to 255 do
    CPU.Mem[I] := StrToIntDef('$' + sgMemoria.Cells[1, I+1], 0);
end;

procedure TfrmCPU.SetPhase(Phase : PhaseType); begin
  lblFetch.Enabled   := false;
  lblOperand.Enabled := false;
  lblExecute.Enabled := false;
  shFetch.Brush.Color   := clBtnFace;
  shOperand.Brush.Color := clBtnFace;
  shExecute.Brush.Color := clBtnFace;
  case Phase of
    _Fetch : begin
      lblFetch.Enabled := true;
      shFetch.Brush.Color := clAqua;
    end;
    _Operand : begin
      lblOperand.Enabled := true;
      shOperand.Brush.Color := clYellow;
    end;
    _Execute : begin
      lblExecute.Enabled := true;
      shExecute.Brush.Color := clLime;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TfrmCPU.sbResetClick(Sender: TObject); begin
  frmCPU.ilImagens.GetBitmap(0, frmCPU.sbStatus.Picture.Bitmap);
  SetPhase(_Reset);
  ResetCPU;
  acGo.Enabled := true;
  acPause.Enabled := true;
end;

procedure TfrmCPU.stACCMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.ACC;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stACC.Left-10;
      Top := stACC.Top-20;
      Caption := 'ACC='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stACCMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stAMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.A;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stA.Left-10;
      Top := stA.Top-20;
      Caption := 'A='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stAMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.B;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stB.Left-10;
      Top := stB.Top-20;
      Caption := 'B='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stBMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stIRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.IR;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stIR.Left-10;
      Top := stIR.Top-20;
      Caption := 'IR='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stIRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stMARMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.MAR;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stMAR.Left-20;
      Top := stMAR.Top-20;
      Caption := 'MAR='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stMARMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stMDRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.MDR;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stMDR.Left-20;
      Top := stMDR.Top-20;
      Caption := 'MDR='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stMDRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stPCMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.PC;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stPC.Left-10;
      Top := stPC.Top-20;
      Caption := 'PC='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stPCMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stSPMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.SP;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stSP.Left-10;
      Top := stSP.Top-20;
      Caption := 'SP='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stSPMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.stULAMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   BinStr: string;
   i,Val: Byte;
begin
   BinStr := '';
   Val := CPU.ULA.Value;
   for i := 1 to 8 do
   begin
      if boolean(Val and 1) then
         BinStr := '1' + BinStr
      else
         BinStr := '0' + BinStr;
      Val := Val shr 1;
   end;
   with Label1 do
   begin
      Left := stULA.Left-10;
      Top := stULA.Top-20;
      Caption := 'ULA='+BinStr;
      Visible := true;
   end;
   Application.ProcessMessages;
end;

procedure TfrmCPU.stULAMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Label1.visible := false;
  Application.ProcessMessages;
end;

procedure TfrmCPU.acLoadExecute(Sender: TObject); begin
  if odLoad.Execute then begin
    if LoadFile(odLoad.FileName) >= 0 then begin
      sbResetClick(nil);
      LoadMem;
      ShowMem(CPU.PC); // atualiza display da memoria
      Caption := CPU_Caption + ' - ' + ExtractFileName(odLoad.FileName);
      frmCPU.ilImagens.GetBitmap(0, frmCPU.sbStatus.Picture.Bitmap);
      acGo.Enabled    := true;
      acPause.Enabled := true;
      acHalt.Enabled  := true;
      acReset.Enabled := true;
      ShowMessage('Foram lidos ' + IntToStr(CPU.LenProg) + '(' + IntToHex(CPU.LenProg, 2) + 'h) bytes para a memória.');
    end
    else
      ShowMessage('Erro ao carregar arquivo ' + odLoad.FileName);
  end;
end;

procedure TfrmCPU.ClockSelectChange(Sender: TObject);
begin
  CPUClock := 10*(ClockSelect.ItemIndex + 1);
  SetClock;
  shClock1.Brush.Color := clRed;
  shClock2.Brush.Color := clRed;
  Application.ProcessMessages;
  Sleep(100);
  shClock1.Brush.Color := $DFDF;
  shClock2.Brush.Color := $DFDF;
end;

procedure TfrmCPU.FormClose(Sender: TObject; var CloseAction: TCloseAction); begin
  Cmd := _Exit;
  if MessageDlg('CPU-8E', 'Confirma saída do programa?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    CloseAction := caFree
  else
    CloseAction := caNone
end;

initialization
  {$I CPU8E_Panel.lrs}
end.

