program TShirt4;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Find the smallest prime number that remains prime when added to its reversal}


uses
  Forms,
  U_TShirt4 in 'U_TShirt4.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
