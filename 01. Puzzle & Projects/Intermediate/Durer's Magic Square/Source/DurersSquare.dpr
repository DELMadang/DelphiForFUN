program DurersSquare;

uses
  Forms,
  U_DurersSquare in 'U_DurersSquare.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
