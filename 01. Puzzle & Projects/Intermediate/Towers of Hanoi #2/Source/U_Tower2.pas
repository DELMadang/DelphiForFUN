unit U_Tower2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

const
  maxdisks=64;
type
  TTowers = class(Tobject)
     peg:array[1..3, 1.. maxdisks] of integer;
     nbrdisks:array[1..3] of integer; {current nbr of disks on each peg}
     Procedure setdisks(NewNbrDisks:integer);
     Function MoveOne(Frompeg, topeg:integer):integer; {return disk nbr of disk moved}
  end;


  TForm1 = class(TForm)
    Label1: TLabel;
    SolveBtn: TButton;
    StopBtn: TButton;
    DisksUD: TUpDown;
    TimeLbl: TLabel;
    MovesLbl: TLabel;
    RateLbl: TLabel;
    Label5: TLabel;
    EstSecsLbl1: TLabel;
    EstSecsLbl2: TLabel;
    MoveBox: TListBox;
    Label2: TLabel;
    DisksEdt: TEdit;

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
    startcount:int64;
    seconds,rate:double;
    stopflag:boolean;
    Moveincr:integer;
    Procedure MoveOne(A,C:integer);
    Procedure MoveStack(n, A,C,B:integer);
    Procedure MakeLabels(s:string);
  end;

var
  Form1: TForm1;
  Tower:TTowers;
  MaxMovesToList:integer=1000; {No sense in listing more}

implementation

{$R *.DFM}
Uses math;

{********************* Tower Methods *****************}
Procedure TTowers.setdisks(NewNbrDisks:integer);
var
  i:integer;
Begin
  For i:=1 to 3 do nbrdisks[i]:=0;
  Nbrdisks[1]:=NewNbrdisks;
  {number the disks from high to low (low number in highest position}
  for i:= 1 to newnbrdisks do peg[1,i]:=newnbrdisks+1-i;
end;

Function TTowers.MoveOne(Frompeg, topeg:integer):integer; {return disk nbr of disk moved}
var
  disknbr:integer;
Begin
   disknbr:=Peg[frompeg, nbrdisks[frompeg]];
  {Can't move a disk to a smaller one}
  If (nbrdisks[topeg]>0) and (disknbr>=peg[topeg,nbrdisks[ToPeg]]) then result:=-1
  else
  begin
    dec(nbrdisks[Frompeg]);
    inc(nbrdisks[ToPeg]);
    Peg[Topeg,nbrdisks[topeg]]:=disknbr;
  end;
  result:=disknbr;
end;


Procedure Tform1.MoveStack(n, A,C,B:integer);
{Use recursive calls to move n disks from Peg A to Peg C with Peg B as a spare}
  Begin
    if stopflag then exit; {User signaled stop}
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



{********************* Form methods **********************}

Procedure TForm1.MoveOne(A,C:integer);
var
  DiskNbr:integer;
Begin
  inc(movecount);
  Disknbr:=Tower.moveone(A,C);
  application.processmessages;
  If movecount<=MaxMovesToList
  then MoveBox.items.add('Disk '+inttostr(Disknbr) + ' from peg '+inttostr(A)+' to '+inttostr(C));
End;


procedure TForm1.SolveBtnClick(Sender: TObject);
{solve button was clicked}
begin
  {Initialize stuff}
  stopflag:=false;; {Quit flag - set by stop button}
  EstsecsLbl1.caption:='';
  EstSecsLbl2.caption:='';
  SolveBtn.enabled:=false;
  StopBtn.enabled:=true;
  movecount:=0;
  movebox.clear;
  QueryPerformanceCounter(startcount); {Get initial count}
  MovesLbl.Caption:='Number of moves:' ;
  timelbl.caption:='Number of Seconds: ';
  ratelbl.caption:='Moves per second: ';
  Tower.setdisks(nbrdisks);
  MoveStack(nbrdisks,1,3,2); {move nbrdisks from peg 1 to peg 3 using peg2 as the spare}
  If tag=0 then makelabels('Complete');
  SolveBtn.enabled:=true;
  StopBtn.enabled:=false;
  Screen.cursor:=CrArrow;
end;

Procedure TForm1.MakeLabels(S:String);
var stopcount, freq:int64;
Begin
  QueryPerformanceCounter(stopcount); {Get end count}
  QueryPerformanceFrequency(freq); {Get frequency}
  MovesLbl.Caption:='Number of moves: '+floattostrf(movecount,ffnumber,9,0);
  seconds:=(stopcount-startcount)/freq;
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
  stopflag:=true; {Set quit flag}
end;


procedure TForm1.DisksEdtChange(Sender: TObject);
begin
  nbrdisks:=disksUD.position;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  disksedtchange(sender);
  Tower:=TTowers.create;
  Label2.caption:='The first '+ inttostr(maxmovestoList)+' moves';
end;

end.
