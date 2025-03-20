program ChineseRemainders1;

uses
  Forms,
  U_ChineseRemainders1 in 'U_ChineseRemainders1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
