program DominoPuzzle;

uses
  Forms,
  U_DominoPuzzle in 'U_DominoPuzzle.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
