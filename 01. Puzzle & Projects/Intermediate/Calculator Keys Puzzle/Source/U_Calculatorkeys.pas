unit U_Calculatorkeys;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
 The professor noticed that the keys
on his calculator formed an equation,
but not one that was true.

           7 8 9
        -  4 5 6
        =  1 2 3

But if he interchanged pairs of keys
twice he could make a valid
equation.   Can you find the  pairs of
keys  to swap to  equation  true?

Hint: There are two solutions ans
each involves "borrowing" in the
subtraction.
*)

{Adapted from 'Giant Book of Mensa Mind Challenges'
        Section 2 "Hard to Solve Puzzles", #24 p.95)  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mmsystem, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    Button1: TButton;
    Button2: TButton;
    Button5: TButton;
    ButtonM: TButton;
    Button4: TButton;
    Button8: TButton;
    ButtonE: TButton;
    Button7: TButton;
    Button3: TButton;
    Button6: TButton;
    Button9: TButton;
    AnsLbl: TLabel;
    ResetBtn: TButton;
    StaticText1: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure KeyBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    {Public declarations }
    key:array[1..9] of TButton;
    clickVal1, Clickval2:integer;
    lastTextline:integer;
    function checkans(var n1,n2,ans:integer):boolean;
    procedure swap(const i,j:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*********** CheckAns **************}
function TForm1.checkans(var n1,n2,ans:integer):boolean;
{See if current key arrangement returns a true equation}
    begin
      n1:=100*key[1].tag+10*key[2].tag+key[3].tag;
      n2:=100*key[4].tag+10*key[5].tag+key[6].tag;
      ans:=100*key[7].tag+10*key[8].tag+key[9].tag;
      if n1-n2=ans then  result:=true
      else result:=false;

    end;

{************** Swap ************}
procedure TForm1.swap(const i,j:integer);
{Exchange caption and tag information between two keys}
    var
      captionval:string;
      tagval:integer;
    begin
      captionval:=key[i].caption;
      tagval:=key[i].tag;
      key[i].caption:=key[j].caption;
      key[i].tag:=key[j].tag;
      key[j].caption:=captionval;
      key[j].tag:=tagval;
    end;

{********** SolveBtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);

var
  i,j,m,n,index:integer;
  n1,n2,ans:integer;
  count:integer;
  s:string;
begin   {SolveBtnClick}
  count:=0;
  resetbtnclick(sender);
  memo1.lines.add('Starting from the orignal (reset) position...');
  for i:= 1 to 8 do
  for j:=i+1 to 9 do
  begin
    swap(i,j);
    for m:= 1 to 8 do
    for n:= m+1 to 9 do
    begin
      inc(count);
      swap(m,n);
      if checkans(n1,n2,ans) then
      begin
        s:=format('   %d - %d = %d',[n1,n2,ans]);
        index:= memo1.lines.indexof(s);
        if index<0 then
        begin
          memo1.lines.add('');
          memo1.lines.add(format('Swap keys %d w %d and %d w %d',[i,j,m,n]));
          memo1.lines.add(s);
        end;
      end;
      swap(m,n); {undo swap}
    end;
    swap(i,j);  {undo swap}
  end;
  memo1.lines.add('');
  memo1.lines.add('All '+inttostr(count)+ ' pair swaps checked');

  Solvebtn.enabled:=false;
end;

{***************** KeyBtnClick ***************}
procedure TForm1.KeyBtnClick(Sender: TObject);
{User clicked on a key.  Check results after each pair of
 keys clicked}
var
  i,m,n:integer;
  n1,n2,ans:integer;
begin
  with tbutton(sender) do
  If clickval1=0 then clickval1:=tag
  else
  begin
    Clickval2:=tag;
    for i:=1 to 9 do
    if key[i].tag=clickval1 then
    begin
      m:=i;
      break;
    end;
    for i:=1 to 9 do
    if key[i].tag=clickval2 then
    begin
      n:=i;
      swap(n,m);
      if checkans(n1,n2,ans) then
      begin
        anslbl.caption:=format('%d - %d = %d',[n1,n2,ans]);
        //windows.messagebeep(MB_ICONEXCLAMATION);
        sndplaysound('tada.wav', snd_async);
        break;
      end
      else
      begin
        anslbl.caption:=format('%d - %d <> %d',[n1,n2,ans]);
        sndplaysound('balloon.wav', snd_async);
      end;
    end;
    clickval1:=0; {reset the clicked value so next click counts a 1st key}
  end;
end;

{*********** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
{Put calculator buttons into a key array}
begin
  key[1]:=Button1;
  key[2]:=Button2;
  key[3]:=Button3;
  key[4]:=Button4;
  key[5]:=Button5;
  key[6]:=Button6;
  key[7]:=Button7;
  key[8]:=Button8;
  key[9]:=Button9;
  lasttextline:=memo1.lines.count;
  resetbtnclick(sender);
end;

{************ ResetBtnClick ************8}
procedure TForm1.ResetBtnClick(Sender: TObject);
{put calculator keys back into original arrangement and
 reset 1st key clicked value to 0}
var
  i,inc:integer;
begin
  for i:= 1 to 9 do
  begin
    if i<=3 then inc:=6
    else if i<=6 then inc:=0
    else inc:=-6;
    key[i].caption:=inttostr(i+inc);
    key[i].tag:=i+inc;
  end;
  clickval1:=0;
  solvebtn.enabled:=true;
  anslbl.caption:='789 - 456 <> 123';
  for i:=memo1.lines.count -1 downto lasttextLine do memo1.lines.delete(i);
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
