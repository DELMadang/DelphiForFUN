unit U_CenturySunday;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{What is the probability that a century begins on a Sunday?}
{Answer 0 !

     year= 52 weeks + 1 day

     except leapyears = 52 weeks + 2 days

     leapyears occur every 4 years except for years divisible by 100 which
     are not leapyears except years divisible by 400 are leapyears:

     Any 100 year period will contain one year divisible by 100.

     So 100 years containing a year divisible by 400 has 24 leap years
     (would be 25, every 4th year, except for that year divisible by 100
     which is not a leap year).  There must therefore be 76 regular years.
     Therefore counting "extra" days over and obove full weeks,
     we have 76 years with one extra day and 24 years with 2 extra days
     which is 124 extra days  which is 17 weeks + 5 days.

     100 years containg a year divisible by 400 has one extra day or 17 weeks
     + 6 days.

     By coincidence the the 400 year cycle has added 5+5+5+6=21 extra days,
     exactly 3 weeks so the 4 days that start any 4 consecutive centuries,
     will start every 4 consecutive centuries before or after }

     {The program will illustrate the 4 days that may start century, none of
     them happen to be a Sunday}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    CalcBtn: TButton;
    Memo1: TMemo;
    procedure CalcBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.CalcBtnClick(Sender: TObject);
var
  date:TDateTime;
  s:string;
  century, days:integer;
begin
  memo1.clear;  {empty memo1}
  for century:=16 to 51 do
  Begin
    date:= encodedate(100*(century),1,1);  {get the date for Jan 1st}
    s := FormatDateTime('dddd, mmm d, yyyy' ,date); {format it}
    days:=trunc(encodedate(100*(century+1),1,1)-date); {calculate the number of days in the century;}
    s:= 'Century starting '+s+' has ' +inttostr(days) + ' days (or ' +inttostr(days div 7) + ' weeks and '
             + inttostr(days mod 7) + ' days)  ' ;
    memo1.lines.add(s); {add a line to memo}
  end;
  memo1.selstart:=0;  {sets memo1 pointer back to beginning}
  memo1.sellength:=0; {but for some reason this actually causes the move}
end;

end.
