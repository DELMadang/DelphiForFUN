unit U_EasterCheck;
{Calculates the date of Easter given any year.  I don't pretend to understand
the details of the algorithm.  It comes from the Art Of Programming series
of books by Donald Knuth}
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
Begin
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

{Following procedure downloaded from
   http://www.cobweb.com.au/~gmarts/eastalg.htm#geteasterdated }
{Method 3 is for Gregorian dates and Western churches}

procedure GetEasterDate (y, method : word; var d, m : integer);
var
   FirstDig, Remain19, temp,              {intermediate results}
   tA, tB, tC, tD, tE         : integer;  {table A to E results}
begin

(* :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=
  *  This algorithm is an arithmetic interpretation
  *  of the 3 step Easter Dating Method developed
  *  by Ron Mallen 1985, as a vast improvement on
  *  the method described in the Common Prayer Book

  *  Published Australian Almanac 1988
  *  Refer to this publication, or the Canberra Library
  *  for a clear understanding of the method used

  *  Because this algorithm is a direct translation of the
  *  official tables, it can be easily proved to be 100%
  *  correct

  *  It's free!  Please do not modify code or comments!

  *  11.7.99 - Pascal converting by Thomas Koehler, www.thkoehler.de

   :=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=:=*)


    FirstDig := y div 100;            {first 2 digits of year}
    Remain19 := y mod 19;             {remainder of year / 19}

    if (method = 1) or (method = 2) then
        begin
         {calculate PFM date}
        tA := ((225 - 11 * Remain19) mod 30) + 21;

         {find the next Sunday}
        tB := (tA - 19) mod 7;
        tC := (40 - FirstDig) mod 7;

        temp := y mod 100;
        tD := (temp + temp div 4) mod 7;

        tE := ((20 - tB - tC - tD) mod 7) + 1;
        d := tA + tE;

        if method = 2 then  {convert Julian to Gregorian date}
            begin
            {10 days were skipped
            in the Gregorian calendar from 5-14 Oct 1582}
            temp := 10;
            {Only 1 in every 4 century years are leap years in the Gregorian
            calendar (every century is a leap year in the Julian calendar)}
            if y > 1600 then
                temp := temp + FirstDig - 16 - ((FirstDig - 16) div 4);
            d := d + temp;
            end;
        end
    else
        begin
       {calculate PFM date}
        temp := (FirstDig - 15) div 2 + 202 - 11 * Remain19;
        if (FirstDig > 26) then temp := temp - 1;
        if (FirstDig > 38) then temp := temp - 1;
        if (FirstDig = 21) Or (FirstDig = 24) Or (FirstDig = 25)
          Or (FirstDig = 33) Or (FirstDig = 36) Or (FirstDig = 37) then
            temp := temp - 1;

        temp := temp mod 30;
        tA := temp + 21;
        if (temp = 29) then
            tA := tA - 1;
        if (temp = 28) and (Remain19 > 10) then
            tA := tA - 1;

       {find the next Sunday}
        tB := (tA - 19) mod 7;

        temp := (40 - FirstDig) mod 4;
        {//tC := temp - (temp > 1) - (temp := 3)}
        tC := temp;
        if temp > 1 then tC := tC + 1;
        if temp = 3 then tC := tC + 1;

        temp := y mod 100;
        tD := (temp + temp div 4) mod 7;

        tE := ((20 - tB - tC - tD) mod 7) + 1;
        d := tA + tE;

        end;

  {return the date}
    m := 3;
    if (d > 61) then
    begin
        d := d - 61;  {when the original calculation is converted to the}
        m := 5;       {Gregorian calendar, Easter Sunday can occur in May}
    end;
    if (d > 31) then
      begin
          d := d - 31;
          m := 4;
      end;
end;


Procedure TForm1.getdate(Year:integer);
var
  iswas:string;
  s:string;
  Easter:TDateTime;
Begin
  s:=Knuthcalceaster(year,Easter);
  If easter>now then iswas:=' will be on '
  else iswas:=' was on ';
  Easter2lbl.Caption:='Easter in '+inttostr(year)
   + iswas +s;
  Intedit1.text:=inttostr(year);
End;


procedure TForm1.IntEdit1KeyPress(Sender: TObject; var Key: Char);
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
  decodedate(now,y,m,d);
  getdate(y);

 {Lets check a range of dates with both algorithms just for the heck of it}
 for y:= 1583 to 4000 do
 begin
   s1:=KnuthCalcEaster(y,e1);
   GetEasterDate (y, 3,d2,m2);
   e2:=encodedate(y,m2,d2);
   if e1<>e2 then
   begin
     s2:=datetostr(e2);
     if messagedlg('Date discrepancy for year ' + inttostr(y)
                   +#13 +'Knuth=    '+s1
                   +#13 +'Malland = '+s2
                   +#13+' Continue?'  ,mterror,[mbyes,mbno],0)=mrno
     then exit;
   end;
 end;
end;

procedure TForm1.IntEdit1Click(Sender: TObject);
begin {also show Easter if year is clicked}
  getdate(strtoint(intedit1.text));
end;

end.

