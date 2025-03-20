unit U_MostAll3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    DumbWayBtn: TButton;
    ListBox1: TListBox;
    StopBtn: TButton;
    SmartWayBtn: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure DumbWayBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure SmartWayBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

procedure adjustListboxtext(s1,s2,s3:string;listbox:TListbox);
{Align s1,s2,s3 into columns and add string to listbox}
var
  thirds:integer;
  s:string;
Begin
  thirds:=listbox.width div 4;
  with listbox do
  Begin
    {pad out the input strings to right align them}
    while canvas.textwidth(s1)<=thirds do s1:=' '+s1;
    while canvas.textwidth(s2)<=thirds do s2:=' '+s2;
    while canvas.textwidth(s3)<=thirds do s3:=' '+s3;
    s:=s1+s2+s3;
    items.add(s);
  end;
end;


procedure TForm1.DumbWayBtnClick(Sender: TObject);
{User clicked "Dumb way"}
var
  start:int64;
  nbr3,k:int64;
  i:integer;
  s,s1,s2,s3:string;
  x:single;
begin
  screen.cursor:=crHourglass;
  listbox1.clear;
  tag:=0;
  start:=1;
  i:=0;
  AdjustListBoxText('N    ','# with "3"s','% with "3"s',listbox1);
  {10 billion ought to be enough - user will hit stop before then}
  while (i<=10) and (tag=0) do
  Begin
    inc(i);
    nbr3:=0; {count of 3's}
    k:=0;  {nbr to be tested}
    while k<=start do
    Begin
      inc(k);
      s:=inttostr(k);  {make it a string and scan for a '3'}
      if pos('3',s)>0 then inc(nbr3);
      if k mod 10000 =0 then  {call processmessges once in a while}
      Begin
        application.processmessages;
        if tag=1 then break;  {user hit the stop button}
      end;
    end;
    
    if tag=0 then  {we finished that size OK - show results}
    Begin
      x:=100*(nbr3/start); {5 of nbrs with 3's}
      start:=start*10; {get next start, also upper limit for decade just completed}
      s1:=format('%12d',[start]); {format nbr}
      s2:=format('%12d',[nbr3]); {format count of 3's}
      s3:=format('%8.1f%%',[x]); {format % of nbrs with 3's}
      adjustlistBoxText(s1,s2,s3,listbox1); {add line to output}
      application.processmessages;
    end;
  end;
  screen.cursor:=crDefault;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.SmartWayBtnClick(Sender: TObject);
var
  i:integer;
  n1,n2,n3:extended;
  x:extended;
  s1,s2,s3:string;
begin
  listbox1.clear;
  AdjustListBoxText('N    ','# with "3"s','% with "3"s',ListBox1);
  n1:=1; n2:=1;
  for i:= 1 to 100 do {i is the power of 10 to start}
  Begin
    x:=100*(1-(Power(0.9,i))); {percent of numbers with 3's}
    If i<=6 then
    Begin  {up to 1,000,000 show number}
      n1:=N1*10;
      n2:=n2*9;
      n3:=n1-n2;
      s1:=format('%12.0n',[n1]);
      s2:=format('%12.0n',[n3]);
      s3:=format('%8.1f%%',[x]);
      adjustlistBoxText(s1,s2,s3,listbox1);
    end
    else {Nbrs getting large, switch to putting out power of N and % only}
    Begin
      If i=7 then {Put out some header data}
      Begin
        listbox1.items.add(' ');
        AdjustListBoxText('Power of  N','','Percent with "3"s',ListBox1);
      end;
      s1:=format('%12d',[i]);
      s2:=format('%8.4f%%',[x]);
      adjustlistBoxText(s1,'',s2,listbox1);
    end;
  end;
end;
end.
