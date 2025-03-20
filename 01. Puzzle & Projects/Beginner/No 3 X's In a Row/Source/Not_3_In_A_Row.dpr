program Not_3_In_A_Row;

uses
  Forms,
  U_No_3_In_A_Row in 'U_No_3_In_A_Row.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
