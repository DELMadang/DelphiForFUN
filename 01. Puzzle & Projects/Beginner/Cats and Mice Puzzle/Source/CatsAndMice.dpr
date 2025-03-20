program CatsAndMice;

uses
  Forms,
  U_CatsMice in 'U_CatsMice.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
