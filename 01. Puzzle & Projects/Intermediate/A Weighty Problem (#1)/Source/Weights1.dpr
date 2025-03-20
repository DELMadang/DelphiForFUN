program Weights1;

uses
  Forms,
  U_Weights1 in 'U_Weights1.pas' {Form1},
  U_Weights1_2 in 'U_Weights1_2.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
