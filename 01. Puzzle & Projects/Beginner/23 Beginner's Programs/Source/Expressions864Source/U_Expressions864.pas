unit U_Expressions864;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses UIntlist, UComboV2;

procedure TForm1.Button1Click(Sender: TObject);
var
  slist:Tstringlist;
  a,b,target,indexa,indexb:integer;
  values:array[1..6] of integer;
  s1,s2:string;
begin
  memo1.clear;
  slist:=TStringlist.create;
  slist.commatext:=edit1.text;
  if slist.count=6 then
  begin
    for a:=0 to slist.count-1 do values[a+1]:=strtoint(slist[a]);
    target:=strtoint(edit2.text);
    combos.setup(6,6,permutations);
    {we will get all permutations of the siz input digits and form two
    3-digit numbers from each one.  Then check the sum against the required value}
    slist.clear;  {empty the list because we are going to use to it hold
                   solution numbers so we can check for and skip duplicate
                   equations}
    slist.sorted:=true;
    while combos.getnext do {get the next permutation}
    with combos do
    begin
      a:=values[selected[1]]*100+values[selected[2]]*10+values[selected[3]];
      b:=values[selected[4]]*100+values[selected[5]]*10+values[selected[6]];
      if a+b= target then
      begin
        s1:=inttostr(a); s2:=inttostr(b);
        if (not slist.find(s1,indexa)) and (not slist.find(s2,indexb)) then
        begin
          slist.Add(s1);  {add the numbers to the list so we don't use them again}
          slist.add(s2);
          memo1.lines.add(format('%d + %d = %d',[a,b,target]));
        end;
      end;
    end;
  end else showmessage('Must enter 6 digits separated by commas');
  slist.free;
end;
  
end.
