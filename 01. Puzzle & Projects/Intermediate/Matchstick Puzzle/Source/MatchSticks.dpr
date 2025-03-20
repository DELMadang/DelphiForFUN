program MatchSticks;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_MatchSticks in 'U_MatchSticks.pas' {Form1},
  ShowReward in 'ShowReward.pas' {Reward};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TReward, Reward);
  Application.Run;
end.
