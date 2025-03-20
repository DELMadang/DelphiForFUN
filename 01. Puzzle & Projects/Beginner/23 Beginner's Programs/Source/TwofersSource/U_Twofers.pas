unit U_Twofers;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Here are two little problems each requiring only 10 to 15 lines of code to solve.
Each problem asks for the only two solutions to the given question. }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Button2: TButton;
    Memo3: TMemo;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{*********** Button1Click ****************}
procedure TForm1.Button1Click(Sender: TObject);
{There are only two 2-digit Farenheit temperatures (between 10 and 99)  whose
 reversed digits give the rounded equivalent Centegrade value.  What are they?}

var f{arenheit},c{entigrade},t{ens digit},u{nits digit}:integer;
begin
  for f:=10 to 99 do
  begin  {for 2 digit Farenheit temperatures}
    c:=round((5*(f-32))/9);
    if (c>10) and (c<99) then
    begin  {Centigrade is also 2 digit}
      t:=f div 10; {Farenheit 10's digit}
      u:=f mod 10; {Farenheit units digit}
      {If reversed digits value = Centigrade, then we we have a hit}
      if 10*u+t=c then memo1.lines.Add(format('F:%2d  C:%2d',[f,c]));
    end;
  end;
end;

{************** Button2Click ************}
procedure TForm1.Button2Click(Sender: TObject);
{What two pairs of K and M values satisfy the equation 13K + 41M = 1000?}
var i,j:integer;
begin
  i:=13;
  while i<1000 do
  begin
    j:=41;
    while i+j <= 1000 do
    begin
      if i+j=1000
      then memo2.lines.add(format('%d+%d=1000 (13*%d + 41*%d = 1000)',[i,j, i div 13,j div 41]));
      inc(j,41);
    end;
    inc(i,13);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
