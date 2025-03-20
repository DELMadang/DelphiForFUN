unit U_Alphametics;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DFFUtils, ExtCtrls, U_SolvedDlg;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    SolveBtn: TButton;
    TrackBar1: TTrackBar;
    Memo1: TMemo;
    Memo2: TMemo;
    StopBtn: TButton;
    Panel1: TPanel;
    Button1: TButton;
    procedure SolveBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses U_Permutes;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  allchars:string;  {string containing all unique charatcers in the expression}
  terms:array [1..10] of string;  {array of terms to be added}
  result:string;  {string to right of = sign, the total}
  termcount:integer;  {nbr of terms}
  selected:array of integer; {permutations returned by GewtNextPermute}

  {work fields}
  text:string;
  w:string;
  t:string;
  s,nbrs:string;
  i,j,n,r,tot:integer;
  count:integer;  {loop counter for trackbar display}


  function translate(ch:char):char;
  var  i:integer;
  begin
    result:=ch;
    for i:=1 to length(allchars) do
    if ch=allchars[i] then
    begin
      result:=nbrs[i];
      break;
    end;
  end;


begin
  termcount:=0;
  tag:=0;
  text:=uppercase(edit1.text); {copy input as uppercase}
  allchars:='';

  {Scan input and separate terms and make string with all unique letters}
  for i:= 1 to length(text) do
  Begin
    case text[i] of
      '+','=':
        begin
          inc(termcount);
          if termcount<10 then
          Begin
            terms[termcount]:=w;
            w:='';
          end
          else Begin showmessage('Too many terms'); exit; end;
        end;
      'A'..'Z':
      Begin
        if pos(text[i],allchars)=0
        then allchars:=allchars+text[i]; {save new characters in allchars}
        w:=w+text[i]; {save character in term}
      end;
    end; {of case}
  end;

  result:=w; {save characters to right of =}
  screen.cursor:=crHourGlass;
  {Now try all combinations of integers substituting in
   terms until right one is found}
  trackbar1.max:=initpermutes(length(allchars),10); {In u_permutes}
  count:=0; {loop counter for trackbar display}
  setlength(selected,length(allchars)+1);
  stopbtn.visible:=true; {show stop button}
  {note: tag<>0 means user pressed stop button}
  Solveddlg.memo3.clear;
  while (tag=0) and getnextpermute(selected) do  {Call to U_Permutes unit}
  Begin
    {calculate result value for this permutation}
    r:=selected[pos(result[1],allchars)]-1;
    if r>0 then
    Begin
      for j:= 2 to length(result) {for each character i the term}
      {go from left to right & multiply prev digits by 10 and a character}
      do r:=10*r+selected[pos(result[j],allchars)]-1;
      tot:=0;
      {convert each term and add them up}
      for i:= 1 to termcount do {for each term}
      Begin
        t:=terms[i];
       {set n equal to the digit in Selected that is in the same
        positon as the first character of the term is in the
        Allchars string}
        n:=selected[pos(t[1],allchars)]-1;
        if n=0 then Begin tot:=r+1; break; end;
        for j:= 2 to length(t)
        {for each character in the term
         from left to right multiply prev term by 10
         and add a digit eg 4691=((4*10+6)*10+9)*10+1   }
        do n:=10*n+selected[pos(t[j],allchars)]-1;
        tot:=tot+n;
        if tot>r then break;
      end;
      if tot=r then
      Begin
        nbrs:='';
        for i:= 1 to length(selected)-1 do nbrs:=nbrs+inttostr(selected[i]-1);
        t:='';
        for i:=1 to length(selected) do   t:=t+allchars[i]+'='+nbrs[i]+', ';
        delete(t,length(t)-1,2);
        s:=edit1.text;
        for i:=1 to length(s) do
        if s[i] in ['A'..'Z'] then s[i]:= translate(s[i]);

        With solveddlg.memo3.lines  do
        begin
          add('Solution for:');
          add(edit1.Text);
          add('');
          add(t);
          add('');
          add('');
          add(s);
        end;
        if solveddlg.showmodal=mrcancel
        then break;
      end;
      inc(count);
      if count mod 2048=0 then
      Begin
        trackbar1.position:=count;
        application.processmessages;
      end;
    end;
  end;
  screen.cursor:=crDefault;
  showmessage('Finished solution search');
  stopbtn.visible:=false; {make stop button invisible again}
end;
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.Memo1Click(Sender: TObject);
var N:integer;
begin
  n:=lineNumberClicked(Memo1);
  if (N>=2) and (length(trim(Memo1.Lines[n]))>0) then  Edit1.Text:= Memo1.lines[n];
end;

end.
