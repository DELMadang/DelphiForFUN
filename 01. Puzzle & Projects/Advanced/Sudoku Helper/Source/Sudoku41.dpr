program Sudoku41;

uses
  Forms,
  U_Sudoku41 in 'U_Sudoku41.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
