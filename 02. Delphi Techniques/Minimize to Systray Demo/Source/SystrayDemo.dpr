program SystrayDemo;

uses
  Forms,
  U_SystrayDemo in 'U_SystrayDemo.pas' {Form1},
  U_CloseDlg in 'U_CloseDlg.pas' {CloseDlg};

{$R *.RES}

begin
  Application.Initialize;
  {Application.showmainform:=false;}
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCloseDlg, CloseDlg);
  Application.Run;
end.
