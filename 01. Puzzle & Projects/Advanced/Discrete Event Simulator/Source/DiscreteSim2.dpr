program DiscreteSim2;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A discrete event simulator} 
 
uses
  Forms,
  U_DiscreteSim2 in 'U_DiscreteSim2.pas' {Form1},
  SimUnit in 'SimUnit.pas',
  DefClassUnit in 'DefClassUnit.pas' {DefClassForm},
  DefServerUnit in 'DefServerUnit.pas' {DefServerForm},
  UAnimate in 'UAnimate.pas' {AniForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDefClassForm, DefClassForm);
  Application.CreateForm(TDefServerForm, DefServerForm);
  Application.CreateForm(TAniForm, AniForm);
  Application.Run;
end.
