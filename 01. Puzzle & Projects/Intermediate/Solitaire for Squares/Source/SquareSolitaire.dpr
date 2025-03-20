program SquareSolitaire;

uses
  Forms,
  U_SquareSolitaire in 'U_SquareSolitaire.pas' {Form1},
  U_Intro in 'U_Intro.pas' {IntroDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TIntroDlg, IntroDlg);
  Application.Run;
end.
