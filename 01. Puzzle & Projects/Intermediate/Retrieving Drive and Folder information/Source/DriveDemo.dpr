program DriveDemo;

uses
  Forms,
  U_DriveDemo in 'U_DriveDemo.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
