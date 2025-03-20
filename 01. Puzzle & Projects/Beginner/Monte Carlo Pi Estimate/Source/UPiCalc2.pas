unit UPiCalc2;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ There is a rumor that if we divide the probability of 2 random integers being
  relatively prime into 6 and take the square root, the result is Pi!
  Let's write a program to check and see if that could be true.

  (Numbers are relatively prime if the have no common factors greater than 1.
   Pi is the ratio of the circumference of a circle to its diameter.)
}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    CalcBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    ResetBtn: TButton;
    ProgressBar1: TProgressBar;
    StopBtn: TButton;
    procedure CalcBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    totpairs,totRP:int64; {Total pairs check and total relatively rpme}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************** GCD **************}
Function gcd(a,b:integer):integer;
   {return greatest common denominator of a and b}
   {Euclid's method - the gcd of a and b also the gcd of a and remainder of a/b }
   var
     g,z:integer;
   Begin
     g:=b;
     If b<>0 then
     while g<>0 do
     Begin
       z:=a mod g;
       a:=g;
       g:=z;
     end;
     result:=a;
   end;

{**************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{initialization stuff}
begin
  totrp:=0; totpairs:=0;
  randomize;
  stopbtn.top:=calcbtn.top; {align Stop button over the Calc button}
  stopbtn.left:=calcbtn.Left;
end;

{*************** TForm1.CalcBtnClick ************}
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  i,offset,range,a,b,RPCount, nbrpairs:integer;
  PIEst:double;
  s:string;
begin
  RPCount:=0;
  tag:=0;
  s:=edit1.text;
  repeat {remove commas from input}
    a:= pos(',',s);
    if a>0 then delete(s,a,1);
  until a=0;
  NbrPairs:=strtointdef(s, 10000);
  edit1.text:=inttostr(nbrpairs);
  screen.cursor:=crHourGlass;
  stopbtn.visible:=true;
  i:=0;
  while (tag=0) and (i<=nbrpairs) do
  begin
    a:=random(maxint-1);
    b:=random(maxint-1);
    if gcd(a+1,b+1)=1 then inc(RPcount);
    if i mod 1024 = 0 then
    begin {every once in a while}
      application.processmessages;
      progressbar1.position := 100*i div nbrpairs;
    end;
    inc(i);
  end;
  screen.cursor:=crDefault;
  stopbtn.visible:=false;
  dec(i); {that last inc(i) was too many}
  nbrpairs:=i;
  with memo2.lines do
  begin
    add(format('%6.0n pairs of %6.0n are relatively prime',[rpcount+0.0,nbrpairs+0.0]));
    add(format('.....Probability of relatively prime is %6.4n',[rpcount/nbrpairs]));
    add(format('.....Estimate of PI is %8.6f',[Sqrt(6*NbrPairs/RPcount)]));
    inc(totpairs,nbrpairs);
    inc(totRP,RpCount);
    Piest:=sqrt(6*totPairs/TotRP);
    add(format('.....Cumulative estimate for %8.0n pairs is %8.6f, Error: %5.3f%%',
                 [totpairs+0.0,PiEst, 100*(PiEst -pi)/Pi] ));
  end;
end;

{************* ResetBtnClick ****************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  Totpairs:=0;
  TotRp:=0;
  memo2.clear;
  tag:=0;
end;

{***************** StopBtnClick ***************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

end.
