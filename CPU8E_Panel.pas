unit CPU8E_Panel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, Grids, ComCtrls,
  Buttons, ActnList, CPU8E;

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
    alAtalhos: TActionList;
    Bevel1: TBevel;
    edtClock: TEdit;
    IR0 : TShape;
    IR1 : TShape;
    IR2 : TShape;
    IR3 : TShape;
    IR4 : TShape;
    IR5 : TShape;
    cbMode: TComboBox;
    lblFetch: TLabel;
    lblOperand: TLabel;
    lblExecute: TLabel;
    odLoad: TOpenDialog;
    Panel1: TPanel;
    Shape1 : TShape;
    Shape10 : TShape;
    shFetch: TShape;
    shOperand: TShape;
    shExecute: TShape;
    shRD1 : TShape;
    shRD2 : TShape;
    shWR1 : TShape;
    shWR2 : TShape;
    shZOut1 : TShape;
    shZOut3 : TShape;
    shNOut1 : TShape;
    shZOut2 : TShape;
    Shape108 : TShape;
    shCOut2 : TShape;
    Shape11 : TShape;
    shCOut1 : TShape;
    shNOut2 : TShape;
    shZOut5 : TShape;
    shZOut6 : TShape;
    shNOut3 : TShape;
    shNOut4 : TShape;
    shCOut4 : TShape;
    shCOut3 : TShape;
    shZOut4 : TShape;
    Shape12 : TShape;
    Shape13 : TShape;
    Shape14 : TShape;
    Shape15 : TShape;
    shBI1 : TShape;
    shBI3 : TShape;
    shULAOut2 : TShape;
    shBI2 : TShape;
    Shape2 : TShape;
    shULAOut1 : TShape;
    shACCOut1 : TShape;
    shACCOut2 : TShape;
    shMDROut1 : TShape;
    shMDROut2 : TShape;
    shACCIn1 : TShape;
    shACCIn2 : TShape;
    shPCIn1 : TShape;
    shMDRIn1 : TShape;
    shMDRIn2 : TShape;
    Shape3 : TShape;
    shPCOut1 : TShape;
    shPCIn2 : TShape;
    shPCOut2 : TShape;
    shMARIn1 : TShape;
    shMARIn2 : TShape;
    shBIn2 : TShape;
    Shape36 : TShape;
    shIRIn1 : TShape;
    shIRIn2 : TShape;
    shBIn1 : TShape;
    Shape4 : TShape;
    shIROut1 : TShape;
    shIROut2 : TShape;
    shAIn2 : TShape;
    shAIn1 : TShape;
    shIROut3 : TShape;
    shIROut4 : TShape;
    shIROut5 : TShape;
    shIROut6 : TShape;
    shIROut7 : TShape;
    shIROut8 : TShape;
    Shape5 : TShape;
    shIROut9 : TShape;
    shIROut10 : TShape;
    shIROut11 : TShape;
    shIROut12 : TShape;
    shIROut13 : TShape;
    shIROut14 : TShape;
    shIROut15 : TShape;
    shIROut16 : TShape;
    Shape58 : TShape;
    Shape59 : TShape;
    Shape6 : TShape;
    Shape60 : TShape;
    Shape61 : TShape;
    Shape62 : TShape;
    Shape63 : TShape;
    Shape64 : TShape;
    Shape65 : TShape;
    Shape66 : TShape;
    Shape68 : TShape;
    Shape69 : TShape;
    Shape7 : TShape;
    Shape70 : TShape;
    Shape71 : TShape;
    Shape72 : TShape;
    Shape73 : TShape;
    Shape74 : TShape;
    Shape75 : TShape;
    Shape76 : TShape;
    Shape77 : TShape;
    Shape78 : TShape;
    Shape79 : TShape;
    Shape8 : TShape;
    Shape80 : TShape;
    Shape81 : TShape;
    Shape82 : TShape;
    Shape83 : TShape;
    Shape84 : TShape;
    Shape85 : TShape;
    Shape86 : TShape;
    Shape87 : TShape;
    Shape88 : TShape;
    Shape89 : TShape;
    Shape9 : TShape;
    shBD1 : TShape;
    shBD2 : TShape;
    shMDRIn3 : TShape;
    shMDRIn4 : TShape;
    shMDROut4 : TShape;
    shMDROut3 : TShape;
    shBE1 : TShape;
    shBE2 : TShape;
    shMAROut3 : TShape;
    shMAROut4 : TShape;
    shMAROut1: TShape;
    shMAROut2: TShape;
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
    procedure sgMemoriaSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure spExitClick(Sender: TObject);
    procedure sbGoClick(Sender: TObject);
    procedure spHelpClick(Sender: TObject);
    procedure sbResetClick(Sender: TObject);
  private
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
  Dos, CPU8E_Utils, CPU8E_Oper, CPU8E_Control;

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
  SetPhase(_Reset);
end;

procedure TfrmCPU.sbPauseClick(Sender: TObject); begin
  Cmd := _Pause;
end;

procedure TfrmCPU.sgMemoriaSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string); begin
  CPU.Mem[ARow-1] := StrToIntDef('$' + Value, 0);
end;

procedure TfrmCPU.spExitClick(Sender: TObject); begin
  Cmd := _Exit;
  Close;
end;

procedure TfrmCPU.sbGoClick(Sender: TObject); begin
  if Cmd = _Pause then
    Cmd := _Go
  else begin
    Cmd := _Go;
    Run;
  end;
end;

procedure TfrmCPU.spHelpClick(Sender: TObject); begin
  Exec('Notepad.exe', 'CPU8E_Sim.txt');
end;

procedure TfrmCPU.LoadMem;
var
  I : integer;
begin
  for I := 0 to 255 do
    sgMemoria.Cells[1, I+1] := IntToHex(CPU.Mem[I], 2);
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
  SetPhase(_Reset);
  ResetCPU;
end;

procedure TfrmCPU.edtClockChange(Sender: TObject); begin
  CPUClock := abs(StrToIntDef(edtClock.Text, 0));
  if CPUClock > 100 then CPUClock := 100;
  edtClock.Text := IntToStr(CPUClock);
  SetClock;
end;

procedure TfrmCPU.acLoadExecute(Sender: TObject);
var
  NRead : integer;
begin
  if odLoad.Execute then begin
    NRead := LoadFile(odLoad.FileName);
    if NRead >=0 then begin
      LoadMem;
      ShowMem(CPU.PC); // atualiza display da memoria
      Caption := ProgName + ' - ' + ExtractFileName(odLoad.FileName);
      acGo.Enabled    := true;
      acPause.Enabled := true;
      acHalt.Enabled  := true;
      acReset.Enabled := true;
      ShowMessage('Foram lidos ' + IntToStr(NRead) + '(' + IntToHex(NRead, 2) + 'h) bytes para a memória.');
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

