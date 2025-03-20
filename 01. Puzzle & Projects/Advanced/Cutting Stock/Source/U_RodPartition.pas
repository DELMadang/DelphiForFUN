unit U_RodPartition;
 {Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A test program for the TIntPartition class.  Displays all integer partitions
 or those of a specified size for a given integer.  Also displays partition
 counts }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, shellAPI, ExtCtrls, uRodPartition;


type
  TForm1 = class(TForm)
    Label1: TLabel;
    GenBtn: TButton;
    ListLbl: TLabel;
    Memo1: TMemo;
    NbrSpin: TSpinEdit;
    Label2: TLabel;
    StaticText1: TStaticText;
    Label3: TLabel;
    CountLbl: TLabel;
    UpDown1: TUpDown;
    Edit1: TEdit;
    UpDown2: TUpDown;
    Edit2: TEdit;
    CountBtn: TButton;
    Label4: TLabel;
    Memo2: TMemo;

    procedure GenBtnClickClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure CountBtnClick(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
  public
    count:integer;
    function Handlepartition:boolean;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

{********************** GenBtnClick *********}
procedure TForm1.GenBtnClickClick(Sender: TObject);
{Generate all or a subset of partitions}
var
  N:integer;
begin
  memo2.clear;
  N:=updown1.position; {the setsize}
  count:=0;
  with   defpartition do {the default pre-created partition class instance}
  begin
    partitioninit(N,updown2.position,HandlePartition);
    Countlbl.caption:=format('Displayed %d of %.0n',
                    [count,0.0+partitioncount(updown1.position,updown2.position)]);
  end;
end;

{************* Handlepartition ***********}
function TForm1.handlepartition:boolean;
{Procedure called for each partition returned}
var  j:integer;
     s:string;
begin
  with defpartition do
  begin
    s:='{';
    for j:=0 to partsize-1 do {for each element of this subset}
    begin {build the entry to display }
      if p[j]>=0 then s:=s+inttostr(p[j])+','
      else break;
    end;
    {fix up some punctuation}
    if s[length(s)]=',' then s[length(s)]:='}';
    if s[length(s)]='}' then   s:=s+',{';
    if s[length(s)]='{' then delete(s,length(s)-1,2);
    inc(count);
    memo2.lines.add(s); {display the partition}
  end;
  result:= count<NbrSpin.value;
end;

{*************** SpinEdit1Change ************}
procedure TForm1.SpinEdit1Change(Sender: TObject);
{New integer - change the label and rebuild Partition size combobox }
begin
  if edit1.text<>'' then
  If updown2.position=0
  then listlbl.caption:='All partitions of integer '+inttostr(updown1.position)
  else listlbl.caption:='Partitions of length '+inttostr(updown2.position)
                       +' for integer '+inttostr(updown1.position);
  updown2.max:=updown1.position;
end;

{************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  spinedit1change(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

{************* CountBtnClick ***********}
procedure TForm1.CountBtnClick(Sender: TObject);
{Enumerate all partitions or those of a certain size}
var
  count:int64;
  n,m:integer;
  s:string;
begin
  n:=updown1.position;
  m:=updown2.position;
  if m=0 then s:=') = ' else s:=', '+inttostr(m)+') = ';
  screen.cursor:=crhourglass;
  count:=defpartition.partitioncount(n,m);
  screen.cursor:=crdefault;
  memo2.lines.add(format('P(%d '+ s + '%.0n',[n,0.0+count]));
end;

(*  {Debug test to make sure that sum of P(N) = P(N,K),k=1 to N}
procedure TForm1.Button1Click(Sender: TObject);
var
  i,j,count1,count2:integer;
  s:string;
begin
  memo2.clear;
  for i:= 1 to 100 do
  begin
    count1:=0;
    for j:=1 to i do count1:=count1+defpartition.partitioncount(i,j);
    count2:=defpartition.partitioncount(i,0);
    if count1<>count2 then s:='Error - ' else s:='';
    memo2.lines.add(s+' N='+inttostr(i)+ ', Npart='+inttostr(count1)+', Part='+inttostr(count2));
  end;
end;
*)

end.
