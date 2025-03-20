unit U_OnIdle;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Demonstrates use of Application.OnIdle event exit to allow time consuming
 calculations to take place in the background without impacting user
 interactions}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, UGeometry;

type                                                     TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo5: TMemo;
    NoInterruptBtn: TButton;
    OnIdleExitBtn: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    procedure StaticText1Click(Sender: TObject);

    procedure NoInterruptBtnClick(Sender: TObject);
    procedure OnIdleExitBtnClick(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
  public
    NbrTested:integer;
    TotalSoFar:int64;
    starttime:TDateTime;
    ResultsShown:boolean;
    Procedure Initialize;
    procedure MyIdleProc(sender:TObject; Var Done:boolean); {the OnIdle exit}
    procedure SumDigits(loops:integer); {Calculate digit sum for "loops" integers}
    procedure UpdateStats(msg:string);  {Display processing statistics}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  nbrtotest:integer=trunc(1e8); {100,000,000}

{************* NoInteruptclick *********}
procedure TForm1.NoInterruptBtnClick(Sender: TObject);
{Find the average digit value of 1,000,000 random 5 digit integers}
{with no breaks for user interaction}
begin
  Initialize;
  application.onIdle:=nil;
  screen.Cursor:=crHourGlass;
  SumDigits(nbrtotest);  {calculate result for all integers}
  Screen.cursor:=crDefault;
  Updatestats('Calc without onIdle');
end;

{************ OnIdleExitBtnClick ************}
procedure TForm1.OnIdleExitBtnClick(Sender: TObject);
 {Find the average digit value of 10,000,000 random 5 digit integers}
begin
  Initialize;
  Application.onIdle:=MyIdleproc;
end;

{************* Memo2Change ************}
procedure TForm1.Memo2Change(Sender: TObject);
{Using this exit as a way just to keep user updated on background calculation status}
begin
  updatestats('On Idle calc');
end;

{*********** MyIdleProc ************}
Procedure TForm1.MyIdleProc(Sender: TObject; var Done: Boolean);
begin
  SumDigits(10000); {User is locked out until we exit, so only calculate
                    a few integers each time we enter.  10,000 integers
                    can be tested in less than a millisecond so user probably
                    won't even notice.  :>}

  {Set flag to tell Application to stop calling us when we are done.}
  Done:= nbrtested>=nbrtotest;
  if Done then UpdateStats('OnIdle Calc'); {We'll display  the final statistics}
end;

{********* Initialize ***********}
procedure TForm1.Initialize;
{Set up to do calculations}
begin
  randomize;
  Nbrtested:=0;
  Totalsofar:=0;
  starttime:=now;
  ResultsShown:=false;
end;

{************** SumDigits ***********}
procedure TForm1.SumDigits(loops:integer);
{Total digits sum for the next "loops" integers}
var
  i,j,n:integer;
  begin
    {adjust loops value if necessary}
    if nbrtested+loops>nbrtotest then loops:=nbrtotest-nbrtested;
    for i:= 1 to loops do
    begin
      n:=random(90000)+10000;  {generate random numbers between 10000 and 99999}
      for j:= 1 to 5  do  {for all 5 digits}
      begin
        inc(TotalSoFar, n mod 10); {add the units digit to total}
        n:=n div 10;    {drop the units digit}
      end;
    end;
    inc(nbrtested,loops); {update number tested}
  end;

{************ UpdateStats *************}
Procedure TForm1.UpdateStats(msg:string);
{called by Memo2Change and at end of MyIdleproc processing}
begin
  Label1.caption:='Nbrtested ='+inttostr(Nbrtested);
  If (nbrtested>=nbrtotest) and (not resultsshown) then
  with memo1.Lines do
  begin
    add('');
    add(Format('**%s (%6.3f seconds)',[msg, (now-starttime)*secsperday]));
    add(format('Average digit value %6.2f',[totalsofar/(5*nbrtested)]));
    ResultsShown:=true;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
