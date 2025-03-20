program Cards2;

uses
  Forms,
  U_Cards2 in 'U_Cards2.pas' {Form1},
  U_Select in 'U_Select.pas' {OKBottomDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKBottomDlg, OKBottomDlg);
  Application.Run;
end.
