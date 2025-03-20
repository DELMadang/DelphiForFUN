program TicTacToeMachine2;
 {Copyright 2002, 2016 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_TicTacToeMachine2 in 'U_TicTacToeMachine2.pas' {Form1},
  UBeadsDlg in 'UBeadsDlg.pas' {BeadsDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TBeadsDlg, BeadsDlg);
  Application.Run;
end.
