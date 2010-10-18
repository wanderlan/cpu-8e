program CPU8E_Main;

{$mode objfpc}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms,
  CPU8E_Panel;

{$IFDEF WINDOWS}{$R CPU8E_Main.rc}{$ENDIF}

begin
  Application.Title:='CPU-8E Simulator';
  Application.Initialize;
  Application.CreateForm(TfrmCPU, frmCPU);
  Application.Run;
end.

