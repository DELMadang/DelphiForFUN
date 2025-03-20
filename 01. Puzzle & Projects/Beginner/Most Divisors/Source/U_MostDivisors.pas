unit U_MostDivisors;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  n,j:integer; {loop indices}
  divcount:integer; {divisor count for current integer being tested}
  maxdivcount:integer; {max divisor count found so far}
  maxint:integer;  {the integer with max divisors}
begin
  maxdivcount:=0;
  for n := 100 to 999 do
  begin
    divcount:=0;
    for j:= 1 to n div 2 do {check possible divisors up to 1/2 n }
      if n mod j = 0 then inc(divcount); {mod is the "remainder" function}
    if divcount>maxdivcount then {we've found a new high}
    begin
      maxint:=n;
      maxdivcount:=divcount;
    end;
  end;
  {display results}
  with listbox1.items do
  begin
    clear;
    add(inttostr(maxint)+' has '+inttostr(maxdivcount+1)+' divisors');
    for j:= 1 to maxint div 2 do
      if maxint mod j = 0 then add(inttostr(j));
    add(inttostr(maxint));
  end;
end;
end.
