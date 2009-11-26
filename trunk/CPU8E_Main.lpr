program CPU8E_Main;

{$mode objfpc}{$H+}

uses
  Interfaces, // this includes the LCL widgetset
  Forms, LResources,
  { you can add units after this }
  CPU8E_Panel;

{$IFDEF WINDOWS}{$R CPU8E_Main.rc}{$ENDIF}

begin
  {$I CPU8E_Main.lrs}
  Application.Title := 'CPU-8E';
  Application.Initialize;
  Application.CreateForm(TfrmCPU, frmCPU);
  Application.Run;
end.

