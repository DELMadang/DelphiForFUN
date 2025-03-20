program Twofers;

uses
  Forms,
  U_Twofers in 'U_Twofers.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
