program Bruteforce35;
 {Copyright 2000-2015, Gary Darby, www.DelphiForFun.org


 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


uses
  Forms,
  U_BruteForce35 in 'U_BruteForce35.pas' {Form1},
  U_PostFix in 'U_PostFix.pas' {PostFixForm},
  U_GetTitle in 'U_GetTitle.pas' {GetTitle};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Brute Force';
  Application.HelpFile := 'Brute.hlp';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPostFixForm, PostFixForm);
  Application.CreateForm(TGetTitle, GetTitle);
  Application.Run;
end.
