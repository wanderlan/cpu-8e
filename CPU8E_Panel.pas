unit CPU8E_Panel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, Grids, ComCtrls,
  DbCtrls, Buttons;

type

  { TfrmCPU }

  TfrmCPU = class(TForm)
    Bevel1: TBevel;
    edtClock : TEdit;
    IR0 : TShape;
    IR1 : TShape;
    IR2 : TShape;
    IR3 : TShape;
    IR4 : TShape;
    IR5 : TShape;
    cbMode: TComboBox;
    odLoad: TOpenDialog;
    Panel1: TPanel;
    pgPhase: TProgressBar;
    Shape1 : TShape;
    Shape10 : TShape;
    shRD1 : TShape;
    shRD2 : TShape;
    shWR1 : TShape;
    shWR2 : TShape;
    Shape104 : TShape;
    Shape105 : TShape;
    Shape106 : TShape;
    Shape107 : TShape;
    Shape108 : TShape;
    Shape109 : TShape;
    Shape11 : TShape;
    Shape110 : TShape;
    Shape111 : TShape;
    Shape112 : TShape;
    Shape113 : TShape;
    Shape114 : TShape;
    Shape115 : TShape;
    Shape116 : TShape;
    Shape117 : TShape;
    Shape118 : TShape;
    Shape12 : TShape;
    Shape13 : TShape;
    Shape14 : TShape;
    Shape15 : TShape;
    shBI1 : TShape;
    shBI3 : TShape;
    Shape18 : TShape;
    shBI2 : TShape;
    Shape2 : TShape;
    Shape20 : TShape;
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
    Shape40 : TShape;
    Shape41 : TShape;
    shAIn2 : TShape;
    shAIn1 : TShape;
    Shape44 : TShape;
    Shape45 : TShape;
    Shape46 : TShape;
    Shape47 : TShape;
    Shape48 : TShape;
    Shape49 : TShape;
    Shape5 : TShape;
    Shape50 : TShape;
    Shape51 : TShape;
    Shape52 : TShape;
    Shape53 : TShape;
    Shape54 : TShape;
    Shape55 : TShape;
    Shape56 : TShape;
    Shape57 : TShape;
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
    Shape96 : TShape;
    Shape97 : TShape;
    Shape98 : TShape;
    Shape99 : TShape;
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
    stUC : TStaticText;
    sgMemoria : TStringGrid;
    UpDown1 : TUpDown;
    procedure edtClockChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cbModeChange(Sender: TObject);
    procedure sbHaltClick(Sender: TObject);
    procedure sbPauseClick(Sender: TObject);
    procedure spExitClick(Sender: TObject);
    procedure sbGoClick(Sender: TObject);
    procedure spHelpClick(Sender: TObject);
    procedure sbLoadClick(Sender: TObject);
    procedure sbResetClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmCPU : TfrmCPU;

implementation

uses
  Dos, CPU8E, CPU8E_Utils, CPU8E_Oper, CPU8E_Control;

{ TfrmCPU }

procedure TfrmCPU.FormCreate(Sender: TObject);
var
  I : integer;
begin
  SetLocalDir;
  SetClock;
  for I := 0 to 255 do
    sgMemoria.Cells[0, I+1] := IntToHex(I, 2);
  pgPhase.Caption := 'Fetch';
end;

procedure TfrmCPU.cbModeChange(Sender: TObject);
begin
  CPUMode := ModeType(cbMode.ItemIndex);
end;

procedure TfrmCPU.sbHaltClick(Sender: TObject);
begin
  Cmd := _Halt;
end;

procedure TfrmCPU.sbPauseClick(Sender: TObject);
begin
  Cmd := _Pause;
end;

procedure TfrmCPU.spExitClick(Sender: TObject);
begin
  Cmd := _Exit;
  Close;
end;

procedure TfrmCPU.sbGoClick(Sender: TObject);
begin
  if Cmd = _Pause then
    Cmd := _Go
  else begin
    Cmd := _Go;
    case cbMode.ItemIndex of
      1 : RunStep;
    else
      Run;
    end;
  end;
end;

procedure TfrmCPU.spHelpClick(Sender: TObject);
begin
  Exec('Notepad.exe','CPU8E_Sim.txt');
end;

procedure TfrmCPU.sbLoadClick(Sender: TObject);
begin
  if odLoad.Execute then LoadFile(odLoad.FileName)
end;

procedure TfrmCPU.sbResetClick(Sender: TObject);
begin
  ResetCPU;
end;

procedure TfrmCPU.edtClockChange(Sender: TObject);
begin
  CPUClock := StrToIntDef(edtClock.Text, 0);
  SetClock;
end;

procedure TfrmCPU.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Cmd := _Exit;
  if MessageDlg('CPU-8E', 'Confirma saída do programa?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    CloseAction := caFree
  else
    CloseAction := caNone
end;

initialization
  {$I CPU8E_Panel.lrs}

end.

