unit UTicTacToeCount;
{Copyright  © 2000, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    list:TStringList;
    function IsWinner(s:string; mark:char):boolean;
  end;

var
  Form1: TForm1;

implementation
{Generate all boards with
 1 'X', 0 'O'
 1 'X', 1 'O'
 2 'X', 1 'O'
 2 'X', 2 'O'
  etc.
}


{$R *.DFM}

Uses UcomboV2;


function TForm1.IsWinner(s:string; mark:char):boolean;
{check string S  for 3 in a row}
var
  test:string;
begin
  result:=false;
  If length(s)<>9 then exit;
  test:=stringOfChar(mark,3);
  if (copy(s,1,3)=test)   {row1}
     or (copy(s,4,3)=test){row2}
     or (copy(s,7,3)=test) {row3}
     or ((s[1]=mark) and (s[5]=mark) and (s[9]=mark)) {diag1}
     or ((s[3]=mark) and (s[5]=mark) and (s[7]=mark)) {diag2}
     or ((s[1]=mark) and (s[4]=mark) and (s[7]=mark)) {col1}
     or ((s[2]=mark) and (s[5]=mark) and (s[8]=mark)) {col2}
     or ((s[3]=mark) and (s[6]=mark) and (s[9]=mark)) {col3}
   then result:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j,k, nx,no, count:integer;
  combos1,combos2:TComboset;
  a:array[1..9] of integer;
  acount:integer;
  s:string;
  XWins,OWins:integer;

begin
  list.clear;
  count:=1;
  list.add('_________');  {use _ for empty}
  combos1:=TComboset.create;
  combos2:=TComboset.create;
  for i:= 0 to 8 do
  begin
    NX:=i div 2+1;
    No:= i+1 - nx;
    combos1.Setup(nx,9,combinations);
    {get locations for nx  x's}
    with combos1 do
    while getnext do
    begin
      s:='_________';  {initialize a board}
      for j:=1 to 9 do a[j]:=j; {initialize available position array}

      for j:=1 to nx do {for this permutation}
      begin
        s[selected[j]]:='X'; {fill in an X}
        a[selected[j]]:=0; {and remove it from availables}
      end;

      {now make an array of available positions for O's}
      j:=1;
      acount:=9;
      while (j<acount) do
      begin
        if  a[j]=0 then {by eliminating the positions taken by X's}
        begin
          for k:=j to 8 do a[k]:=a[k+1];
          dec(acount);
        end
        else inc(j);
      end;

      if no>0 then {we have some O's to fill in}
      with combos2 do
      begin
        {set up to get positions for nO O's out of 9-nx positions}
        Setup(nO,9-nx,combinations);
        while getnext do
        begin
          for j:= 1 to nO do  {fill in the O's}
          s[a[selected[j]]]:='O'; {into available positions}
          inc(count);
          list.add(s); {save the node}
          {remove the O's added for the next interation}
          for j:= 1 to 9 do if s[j]='O' then s[j]:='_';
        end;
      end
      else {there were no O's yet (first 9 boards)}
      begin
        list.add(s);
        for j:=1 to 9 do If s[j]='X' then s[j]:='_';
        inc(count);
      end;
    end;
  end;
  list.sort;
  XWins:=0; OWins:=0;
  for i:= 0 to list.count-1 do
  with memo1 do
  begin
    s:=list[i];
    if IsWinner(s,'X') then inc(Xwins)
    else if IsWinner(s,'O') then inc(Owins);
  end;
  showmessage(inttostr(count)+' valid tic-tac-toe boards generated'
                      +#13+inttostr(Xwins)+ ' ''X'' winners and '
                      + inttostr(oWins)+' ''O'' winners' );
  memo1.clear;
  {show the first and last 100 boards}
  memo1.lines.add('First 100 boards');
  for i:= 0 to 99 do memo1.lines.add(list[i]);
  memo1.lines.add('Last 100 boards');
  for i:= list.count-100 to list.count-1 do
  with memo1, lines do
  begin
    s:=list[i];
    if IsWinner(s,'X')
    then  s:=s+' X Wins'
    else if IsWinner(s,'O')
    then  s:=s+' O Wins';
    add(s);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  list:=TStringList.create;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
