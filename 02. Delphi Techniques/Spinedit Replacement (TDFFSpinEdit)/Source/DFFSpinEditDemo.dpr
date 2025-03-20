program DFFSpinEditDemo;

uses
  Forms,
  U_DFFSpinEditDemo in 'U_DFFSpinEditDemo.pas' {Form1},
  UDFFSpinEdit in 'UDFFSpinEdit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
