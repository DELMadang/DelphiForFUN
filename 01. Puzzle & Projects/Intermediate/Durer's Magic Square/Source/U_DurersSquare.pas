unit U_DurersSquare;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Durer's Magic Square is from a famous copper engraving, Melancholia, created in
 1514 by German artist Albrecht Durer.

 There are 86 different combinations of 4 numbers from the square that sum to
 it's magic number, 34.  How many can you find?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls, ShellAPI ;

type
  TForm1 = class(TForm)
    Grid1: TStringGrid;
    ShowBtn: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    ListBox1: TListBox;
    Msglbl: TLabel;
    ListBox2: TListBox;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Grid1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    s:array[1..4] of string; {string representations of 4 cells that sum to 34}
    n:array[1..4] of integer;
    nbrcount:integer;
    procedure display(msg:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  {Durer's magic square data}
  data:array[0..3, 0..3] of integer=((16,3,2,13),(5,10,11,8),(9,6,7,12),(4,15,14,1));

{************* FormActivate ********}
procedure TForm1.FormActivate(Sender: TObject);
{Draw initial magic square}
var i,j:integer;
begin
   For i:=0 to 3 do
   for j:=0 to 3 do
   grid1.cells[i,j]:=inttostr(data[j,i]);
   nbrcount:=0; {count of cells manually selected}
   for i:=1 to 4 do s[i]:=''; {values of selected cells}
end;

{**************** ShowBtnClick ********}
procedure TForm1.ShowBtnClick(Sender: TObject);
{Generate all 86 solutions}
var i1,i2,i3,i4:integer;
    n1,n2,n3,n4:integer;
    count:integer;
    i:integer;
    str:string;
begin
  nbrcount:=0;
  listbox2.clear;
  listbox2.visible:=true;
  if showbtn.caption='Stop' then
  begin
    tag:=1;
    showbtn.caption:='Show me';
    grid1.onclick:=grid1click;
    for i:=1 to 4 do s[i]:='';
    label1.caption:='';
    exit;
  end;
  showbtn.caption:='Stop';
  grid1.onclick:=nil;  {ignore user clicks while we're working}
  count:=0;
  tag:=0;  {use tag field as a stop flag}
  {generate all permutations of 4 numbers selected from 0-15}
  with grid1 do
  for i1:= 0 to 12 do
  begin
    s[1]:=cells[i1 mod 4, i1 div 4]; {convert number to column & row & get cell}
    n1:=strtoint(s[1]);              {save cell as a number}
    for i2:=i1+1 to 13 do
    begin
      s[2]:=cells[i2 mod 4, i2 div 4]; {convert number to column & row & get cell}
      n2:=strtoint(s[2]);              {save cell as a number}
      for i3:=i2+1 to 14 do
      begin
        s[3]:=cells[i3 mod 4, i3 div 4]; {convert number to column & row & get cell}
        n3:=strtoint(s[3]);              {save cell as a number}
        for i4:=i3+1 to 15 do
        begin
          s[4]:=cells[i4 mod 4, i4 div 4]; {convert number to column & row & get cell}
          n4:=strtoint(s[4]);              {save cell as a number}
          if n1+n2+n3+n4=34 then  {does sum of these four cells = 34?}
          begin
            grid1.invalidate; {force magic square to be redrawn}
            inc(count);
            label1.caption:='#'+inttostr(count);
            str:=format('%2d,%2d,%2d,%2d',[n1,n2,n3,n4]);
            listbox2.items.add(str); {add it to list}
            listbox2.itemindex:=listbox2.items.count-1; {keep last addition in view}
            application.processmessages;  {update screen }
            if self.tag=1 then exit  {stop if flag is set}
            else sleep(1000); {wait a second}

          end;
        end;
      end;
    end;
  end;
  {done - reset a few things for next time}
  Showbtn.caption:='Show me';
  grid1.onclick:=grid1click; {let user click again}
  for i:=1 to 4 do s[i]:='';
  {label1.caption:='';}
end;

{*************** StringGridDrawCell ***************}
procedure TForm1.Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Highlight preselectedc cells this iteration of drawing the square}
begin
  with Sender as Tstringgrid , canvas do
  begin
    if (cells[acol,arow]=s[1]) or  (cells[acol,arow]=s[2])
      or (cells[acol,arow]=s[3])  or (cells[acol,arow]=s[4])
    then
    begin
      font.color:=clred;
      brush.color:=clLime;
    end
    else
    begin
      font.color:=clblack;
      brush.color:=clwhite;
    end;
    font.style:=[fsbold];
    fillRect(Rect);
    textout(rect.left+6, rect.top+6,cells[acol,arow]);
  end;
end;

{************* FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{User wants to exit - set stop flag in case solutions are being drawn}
begin
   tag:=1;
   canclose:=true;
end;

procedure Tform1.display(msg:string);
{show a message for 2 seconds}
var  s:string;
begin
  s:=msglbl.caption;
  msglbl.caption:=msg;
  screen.cursor:=crhourglass;
  msglbl.update; {make sure it displays}
  sleep(1500);
  msglbl.caption:=s; {restore label}
  screen.cursor:=crdefault;
end;

procedure TForm1.Grid1Click(Sender: TObject);
{user clicked a cell}
var
  i,j,k,sum:integer;
  str:string;
begin
  if nbrcount=0 then for i:=1 to 4 do s[i]:=''; {1st cell, clear all prev selected}
  inc(nbrcount);
  with grid1 do
  begin
    n[nbrcount]:=strtoint(cells[col,row]); {save value}
    s[nbrcount]:=cells[col,row]; {& save cell string}
  end;

  { check for repeated selections }
  if nbrcount >= 1 then
    for i:= 1 to nbrcount-1 do
    if n[i] = n[nbrcount] then
    begin
      s[nbrcount]:='';
      dec(nbrcount);
      beep;
      break;
    end;
   grid1.invalidate; {force redraw}

  if nbrcount=4 then {4 cells selected - check sum and add if a new solution}
  begin
    sum:=n[1]+n[2]+n[3]+n[4];
    if sum = 34 then
    begin
      {we need to sort the four numbers before adding them to the list so that
       we can recognize the same solution if user select it again, even in a
       different sequence}
      for i:=1 to 3 do {sort}
      for j:=i+1 to 4 do
      if n[j]<n[i] then begin k:=n[i]; n[i]:=n[j]; n[j]:=k; end; {swap}
      {make the key to add to list, make digits 2 characters long}
      str:=format('%2d,%2d,%2d,%2d',[n[1],n[2],n[3],n[4]]);
      i:=listbox1.items.indexof(str); {solution already found?}
      if i>=0 then  display('Solution '+str+' already found')
      else {new solution}
      begin
        listbox1.items.add(str); {add it to list}
        listbox1.itemindex:=listbox1.items.count-1; {keep last addition in view}

        if listbox1.items.count=1 then str:=' user solution found'
        else str:=' user solutions';  {just for he sake of good grammar}

        msglbl.caption:=inttostr(listbox1.items.count)+str;
        {make computer search button visible after 20 solutions have been found}
        if listbox1.items.count>=20 then showbtn.visible:=true;
      end;
    end
    {else four #s were selected, but sum wasn't 34}
    else display(format('Sorry, %2d+%2d+%2d+%2d = %d',[n[1],n[2],n[3],n[4],sum]));
    nbrcount:=0;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open',
  'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);

end;

end.
