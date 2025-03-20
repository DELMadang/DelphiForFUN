program SevenCoins;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_7Coins in 'U_7Coins.pas' {Form1},
  U_msg in 'U_msg.pas' {MsgDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMsgDlg, MsgDlg);
  Application.Run;
end.
