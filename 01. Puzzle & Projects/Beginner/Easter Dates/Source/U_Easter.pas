unit U_Easter;

{Calculates the date of Easter given any year.  I don't pretend to understand
the details of the algorithm.  It comes from the Art Of Programming series
of books by Donald Knuth}

{Gary Darby, www.dephiforfun.org}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Easter2lbl: TLabel;
    IntEdit1: TEdit;
    procedure IntEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure IntEdit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure getdate(Year:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Function KnuthCalcEaster(year:integer; var easter:TDateTime):String;
{From Vol 3 of The Art of Computer Programming, Donlad E. Knuth}
var
  golden,century:integer;
  Correction1,Correction2:integer;
  Sunday,Epact:Integer;
  N:Integer;
begin
 If Year <= 1582 then
     Showmessage('OK, but  results are only valid for years after 1582');
   Golden := Year mod 19  + 1 ;
   Century := Year div 100 + 1 ;
   Correction1 := trunc(3.0 * Century / 4.0) - 12;
   Correction2 := trunc((8.0 * Century + 5.0) / 25.0) - 5;
   Sunday := trunc(5.0 * year / 4.0) - Correction1 -10 ;
   Epact := (11 * Golden + 20 + Correction2 - Correction1) mod 30 ;
   IF ((Epact = 25) and (Golden > 11))  or (Epact = 24) then
      Epact := Epact + 1 ;
   N := 44 - Epact;
   if N < 21 then  N := N + 30 ;
   N := N + 7 - ((Sunday + N) mod 7) ;
   try
     {Pass a Year, Month, and Day and get a date back}
     easter:=encodedate(year,3,1)+n-1;
     result:=FormatDateTime('mmmm d',easter);
   except
     showmessage(inttostr(year)+' is an invalid year');
     result:='';
     easter:=0;
   end;
end;

Procedure TForm1.getdate(Year:integer);
{take a year, calculate Easter date and display it}
var
  iswas:string;
  s:string;
  Easter:TDateTime;
begin
  s:=Knuthcalceaster(year,Easter);
  If easter>now then iswas:=' will be on '
  else iswas:=' was on ';
  Easter2lbl.Caption:='Easter in '+inttostr(year)
   + iswas +s;
  Intedit1.text:=inttostr(year);
end;


procedure TForm1.IntEdit1KeyPress(Sender: TObject; var Key: Char);
{Get integers and show Easter when Enter key is pressed}
begin
  If key=#13 then
  begin
    Getdate(strtoint(IntEdit1.text));
    key:=#00;
  end
  else if not (key in ['0'..'9']) then
  begin  beep;  key:=#00; end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
  y,m,d:word;
  m2,d2:integer;
  e1,e2:TDateTime;
  s1,s2:string;
begin
  {set current data at start up time}
  decodedate(now,y,m,d);
  getdate(y);
end;

procedure TForm1.IntEdit1Click(Sender: TObject);
begin {also show Easter if year is clicked}
  getdate(strtoint(intedit1.text));
end;

end.

