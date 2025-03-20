program MakeCaption;

uses
  Forms,
  U_MakeCaption in 'U_MakeCaption.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
