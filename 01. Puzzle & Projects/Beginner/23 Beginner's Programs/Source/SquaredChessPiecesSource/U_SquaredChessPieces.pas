unit U_SquaredChessPieces;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{In a set of geometric chess pieces the KNIGHT amd KING have the the property
 that if the letters in their names are replaced by appropriate unique digits,
 the resulting numbers are both perfect squares.

 What are the digt to letter assignments?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UComboV2;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



type Tletters=(K,N,I,G,H,T); {an easy way to associate the letters with selected digits}
{Note, this does mean that we cannot use variables with these names,
 "I" and "N" for example. (voice of experience :>) }

var
  {Letters to display associated with type TLetters}
  Letters:array[Tletters] of char=('K','N','I','G','H','T');

{************ SearchBtnClick **********}
procedure TForm1.SearchBtnClick(Sender: TObject);
{The search routine}
var
  digits:array[Tletters] of integer; {selected set of letters}
  ii:TLetters; {Index of search loop}
  val1,val2,n1,n2:integer;  {variables for testing values}
  s:string;
begin
  with combos do
  begin
    setup(6,10,permutations); {Check permutations of 6 of 10 digits}
    while getnextpermute do
    begin
      val1:=0;
      for ii:= K to T do
      begin
        {combos "selected" has current integers 1 through 10 indexed in
         positions 1 through 6, thus add 1 to ord(ii) to get the "slected index,
         then subtract 1 from the value to convert integers 1-10 back to digits 0-9}
        digits[ii]:=selected[ord(ii)+1]-1;
        val1:=val1*10+digits[ii]; {compute the value at the same time}
      end;
      n1:=trunc(sqrt(val1));
      if n1*n1=val1 then
      begin {KNIGHT is a perfect square}
        {is KING also a perfect square?}
        val2:=1000*digits[K]+100*digits[I]+10*digits[N]+digits[G];
        n2:=trunc(sqrt(val2));
        if n2*n2=val2 then   {Yes!}
        with memo1.lines do
        begin
          add('');
          s:='';
          for ii:=K to T do  s:=s+ format('%s=%d, ',[letters[ii],digits[ii]]);
          system.delete(s,length(s),1);  {delete extra ',' at end of string}
          add(s);
          add('');
          add(format('KNIGHT = %d is a perfect square (%d x %d)',[val1,n1,n1]));
          add(format('KING = %d is a perfect square (%d x %d)',[val2,n2,n2]));
          add('');
        end;
      end;
    end;
    memo1.Lines.add(format('%.0n arrangements of 6 of 10 digits searched ',[0.0+getcount]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
