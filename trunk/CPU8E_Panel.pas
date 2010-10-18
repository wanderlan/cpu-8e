unit CPU8E_Panel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, Grids, ComCtrls,
  Buttons, ActnList, CPU8E, ShapeEx;

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
    edtClock: TEdit;
    ilImagens: TImageList;
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
    Shape11 : TShapeEx;
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
    stMAR : TStaticText;
    stDI : TStaticText;
    stUC1 : TStaticText;
    sgMemoria : TStringGrid;
    UpDown1 : TUpDown;
    procedure acLoadExecute(Sender: TObject);
    procedure edtClockChange(Sender: TObject);
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
  Caption := ProgName + ' - ' + Author;
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
      Caption := ProgName + ' - ' + ExtractFileName(sdSave.FileName);
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

procedure TfrmCPU.spHelpClick(Sender: TObject); begin
  ExecuteProcess('Notepad.exe', 'CPU8E_Sim.txt');
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
      shFetch.Brush.Color := clYellow;
    end;
    _Operand : begin
      lblOperand.Enabled := true;
      shOperand.Brush.Color := clYellow;
    end;
    _Execute : begin
      lblExecute.Enabled := true;
      shExecute.Brush.Color := clYellow;
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

procedure TfrmCPU.edtClockChange(Sender: TObject); begin
  CPUClock := abs(StrToIntDef(edtClock.Text, 1));
  if CPUClock > 100 then CPUClock := 100;
  edtClock.Text := IntToStr(CPUClock);
  SetClock;
  shClock1.Brush.Color := clRed;
  shClock2.Brush.Color := clRed;
  Application.ProcessMessages;
  Sleep(100);
  shClock1.Brush.Color := $DFDF;
  shClock2.Brush.Color := $DFDF;
end;

procedure TfrmCPU.acLoadExecute(Sender: TObject); begin
  if odLoad.Execute then begin
    if LoadFile(odLoad.FileName) >= 0 then begin
      sbResetClick(nil);
      LoadMem;
      ShowMem(CPU.PC); // atualiza display da memoria
      Caption := ProgName + ' - ' + ExtractFileName(odLoad.FileName);
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

