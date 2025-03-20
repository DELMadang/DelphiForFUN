program EightQueens_Wirth2;

uses
  Forms,
  U_EightQueens_Wirth2 in 'U_EightQueens_Wirth2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
