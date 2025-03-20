program Palindromes1;

uses
  Forms,
  U_Palindromes1 in 'U_Palindromes1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
