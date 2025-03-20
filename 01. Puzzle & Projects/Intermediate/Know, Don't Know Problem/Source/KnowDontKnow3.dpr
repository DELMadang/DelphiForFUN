program KnowDontKnow3;
 {Copyright 2013, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_KnowDontKnow3 in 'U_KnowDontKnow3.pas' {Form1},
  u_primes in 'u_primes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
