unit U_Tower1;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, MathCtrl;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    SolveBtn: TButton;
    StopBtn: TButton;
    UpDown2: TUpDown;
    TimeLbl: TLabel;
    MovesLbl: TLabel;
    RateLbl: TLabel;
    Label5: TLabel;
    EstSecsLbl1: TLabel;
    EstSecsLbl2: TLabel;
    Edit1: TEdit;
    procedure SolveBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure DisksEdtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    nbrdisks:Integer;
    movecount:Int64;
    starttime:TDateTime;
    seconds,rate:double;
    Moveincr:integer;
    Procedure MoveOne(A,C:integer);
    Procedure MoveStack(n, A,C,B:integer);
    Procedure MakeLabels(s:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses math;

Procedure TForm1.MoveOne(A,C:integer);
var
  starttime, endtime:TDateTime;
  targettime:real;
Begin
  inc(movecount);
  application.processmessages;
End;

Procedure TForm1.MoveStack(n, A,C,B:integer);
{Use recursive calls to move n disks from Peg A to Peg C with Peg B as a spare}
  Begin
    if tag=1 then exit; {User signaled stop}
    If n=1 then
    Begin
       MoveOne(A,C); {If there's only one to move, move it}
    end
    else
    Begin
      MoveStack(n-1, A,B,C);  {Move n-1 disks to peg B}
      MoveOne(A,C);           {Move 1 disk to Peg C}
      MoveStack(n-1,B,C,A);   {Then move n-1 disks from B back to Peg C}
    end;
  end;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i:integer;
begin
  tag:=0; {Quit flag - set by stop button}
  SolveBtn.enabled:=false;
  StopBtn.enabled:=true;
  movecount:=0;
  starttime:=time;
  MovesLbl.Caption:='Number of moves:' ;
  timelbl.caption:='Number of Seconds: ';
  ratelbl.caption:='Moves per second: ';
  screen.cursor:=crHourGlass;
  MoveStack(nbrdisks,1,3,2); {move nbrdisks from peg 1 to peg 3 using peg2 as the spare}
  If tag=0 then makelabels('Complete');
  SolveBtn.enabled:=true;
  StopBtn.enabled:=false;
  Screen.cursor:=CrDefault;
end;

Procedure TForm1.MakeLabels(S:String);
Begin
  MovesLbl.Caption:='Number of moves: '+floattostrf(movecount,ffnumber,9,0);
  seconds:=(time-starttime)*SecsPerDay;
  timelbl.caption:='Number of Seconds: '+floattostrf(seconds,ffnumber,6,1);
  If seconds>=0.5 then
  Begin
     rate:=movecount / seconds;
     ratelbl.caption:='Moves per second: '+floattostrf(rate,ffnumber,9,0);
  end
  else
   ratelbl.caption:='Moves per second: Need runtime of at least'
                   +#13+' 1/2 second to calculate rate';
End;

procedure TForm1.StopBtnClick(Sender: TObject);
var
  years:single;
  s:string;
begin
  makelabels('Not Complete');
  Screen.cursor:=crArrow;
  EstSecsLbl1.caption:= 'Estimated time to complete: '
      + floattostrf((power(2,nbrdisks)-1)/Rate,ffnumber,8,1)+' seconds';
  years:=power(2,nbrdisks)/(365*24*3600);
  if years>1 then s:=' years)' else s:=' year)';
  EstSecsLbl2.caption:=
   'Est. time at 1 move per second: '
   +#13
   +floattostrf(Power(2,nbrdisks),ffnumber,20,0)
   +' seconds '+#13+'(That''s '
   +floattostrf(years,ffnumber,15,1)+s;
  SolveBtn.enabled:=true;
  StopBtn.enabled:=false;
  tag:=1; {Set quit flag}
end;


procedure TForm1.DisksEdtChange(Sender: TObject);
begin
  nbrdisks:=strtoint(edit1.text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  disksedtchange(sender);
end;

end.
