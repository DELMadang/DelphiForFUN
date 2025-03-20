unit U_TShirt2;
{Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Back of shirt:
   "The smallest 3 digit number that equals to the sum
   of the cubes of its digits."
 Front of shirt:  ?????

 This program searches out n digit numbers that are equal to the sum
 of the nth powers of its digits.   Brute force works up to about 8 or 9.
 After that run times become excessive and we'll have to find a smarter way.
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, SHellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    UpDown1: TUpDown;
    Label1: TLabel;
    Edit1: TEdit;
    Memo2: TMemo;
    Brute1Btn: TButton;
    Brute2btn: TButton;
    StopBtn: TButton;
    StaticText1: TStaticText;
    procedure Brute1BtnClick(Sender: TObject);
    procedure Brute2btnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

procedure TForm1.Brute1BtnClick(Sender: TObject);
{Brute Force method - just try all n digit numbers and show those that
 meet condition }
var
  j,p:integer;
  i,m,mm,x:int64;
  tot:int64;
  done:boolean;
  start:int64;
  starttime:TDateTime;
begin
  screen.cursor:=crhourglass; {busy cursor}
  start:=1;
  p:=updown1.position-1;  {n-1, just for convenience}
  for j:= 1 to p do start:=start*10; {compute "start", smallest n digit number}
  i:=start;
  done:=false;
  starttime:=now;
  tag:=0;
  {loop from start to 10*start-1, all n digit numbers}
  while (tag=0) and (i<start*10) and (not done) do
  begin
    m:=i;
    tot:=0;
    while m>0 do {the heart of the matter}
    begin
      mm:=m mod 10; {get units digit}
      x:=mm;
      for j:=1 to p do x:=x*mm; {raise it to nth power}
      tot:=tot+x; {add it to total}
      if tot>i then break;  {might as well stop checking if total gets too big}
      m:=m div 10; {divide by 10 to get next prior digit}
    end;
    if (m=0) and (tot=i) then
    begin
      {done:=true;} {set done:=true to stop after 1st success}
      memo2.lines.add(inttostr(i)+ format('%6.1f seconds',[(now-starttime)*secsperday]));
      inc(i);
    end
    else inc(i);
    if i mod 1024=0 then application.processmessages; {let stop button be handled}
  end;
 screen.cursor:=crdefault; {normal cursor}
end;

procedure TForm1.Brute2btnClick(Sender: TObject);
{We really only use 10 values of the digits 0-9 the the nth power for
 the summing part. What if we just precalculate the 10 values and put them
 in a table and use them for summing?}
  var
    j,k,p:integer;
    i,m,mm:int64;
    tot:int64;
    done:boolean;
    start:int64;
    pwrs:array[0..9] of int64;
    starttime:TDateTime;
begin
  screen.cursor:=crHourglass; {busy cursor}
  start:=1;
  p:=updown1.position-1;  {p=n-1 for convenience}
  {Calculate the values of 0 through 9 to the (P+1)th power}
  for j:=0 to 9 do pwrs[j]:=j;
  for j:= 1 to p do
  begin
    start:=start*10;
    for k:=0 to 9 do pwrs[k]:=pwrs[k]*k;
  end;
  i:=start;
  done:=false;
  starttime:=now;
  tag:=0;
  {same brute force code as above except sum pwrs[n] instead of recalculating}
  while (tag=0) and (i<start*10) and (not done) do
  begin
    m:=i;
    tot:=0;
    while m>0 do
    begin
      mm:=m mod 10;
      tot:=tot+pwrs[mm];
      if tot>i then break;
      m:=m div 10;
    end;
    if (m=0) and (tot=i) then
    begin
       {done:=true;} {set done:=true to stop after 1st success}
       memo2.lines.add(inttostr(i)+ format('%6.1f seconds',[(now-starttime)*secsperday]));
       inc(i);
    end
    else inc(i);
    if i mod 1024=0 then application.processmessages; {let stop button be handled}
  end;
  screen.cursor:=crdefault; {normal cursor}
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;{program loops will check for this value to abort processing}
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   tag:=1; {stop any running calculations if users wants to close}
   canclose:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
