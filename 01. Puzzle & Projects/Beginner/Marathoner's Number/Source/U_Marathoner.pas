unit U_Marathoner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveButton: TButton;
    Label1: TLabel;
    MinNbrEdt: TEdit;
    Label2: TLabel;
    MaxNbrEdt: TEdit;
    procedure SolveButtonClick(Sender: TObject);
    procedure NbrEdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Const
  newline=#13;  {Newline character}

 {************** SumConsec ***************}
Function Sum(lo,hi:integer):integer;
{Returns the sum of consecutive integers
 from lo to hi, including lo and hi}
var
  n:integer;
Begin
  if lo>hi then {if lo is not smaller, exchange lo and hi}
  begin
    n:=lo; lo:=hi; hi:=n;
  end;
  {The sum of a consecutive set of integers is
  the number of integers: (hi-lo+1)
  times the average integer: (lo+hi) divided by 2 }
  result:= (hi-lo+1)*(lo+hi) div 2;
end;

{**************** SolveButtonClick ****************}
procedure TForm1.SolveButtonClick(Sender: TObject);
var
  nbrRunners,MyNumber:integer;
  maxrunners:integer;
  x:integer;
begin
  NbrRunners:=strtoint(MinNbrEdt.text)+1;
  Maxrunners:=strtoint(MaxNbrEdt.text)-1;
  while (NbrRunners<=maxrunners) do
  Begin
    MyNumber:=1;
    while (MyNumber<=NbrRunners) do
    Begin
      screen.cursor:=crHourGlass;
      x:=sum(1,MyNumber-1);
      if x=sum(MyNumber+1,NbrRunners) then
      begin
        screen.cursor:=crDefault;
        showmessage('One solution is:'
          +newline + 'Number of runners: '+inttostr(NbrRunners)
          +newline + 'Our runner''s number: '+inttostr(MyNumber)
          +newline + 'Sum of numbers 1:'+inttostr(MyNumber-1)
                   + ' and '+inttostr(MyNumber+1) + ':'
                   + inttostr(NbrRUnners)+' is '+format('%6d',[x])
          );
        {Once we've found a solution,
         force this loop to stop since no bigger values for MyNumber will work}
        MyNumber:=NbrRunners;
      end;
      inc(MyNumber);
    end;
    inc(NbrRunners);
  end;
  screen.cursor:=crdefault;
  x:=maxrunners+1;
  Showmessage('No more solutions with less than '+format('%6d',[x])+' runners');
end;

procedure TForm1.NbrEdtKeyPress(Sender: TObject; var Key: Char);
begin
  {Keep user from entering any non-numeric character}
  If not (key in ['0'..'9']) then key:=' ';
end;

end.
