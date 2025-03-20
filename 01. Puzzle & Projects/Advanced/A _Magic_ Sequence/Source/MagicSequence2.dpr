program MagicSequence2;

uses
  Forms,
  U_MagicSequence2 in 'U_MagicSequence2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
