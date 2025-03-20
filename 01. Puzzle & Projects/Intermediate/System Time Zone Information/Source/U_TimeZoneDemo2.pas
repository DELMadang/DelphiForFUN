unit U_TimeZoneDemo2;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, dateutils;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    Memo2: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
//    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function GetNthDSTDOW(Y,M,DST_DOW,N:word):integer;
{For Year "Y" and Month "M"  and DayOfWeek "DST_DOW", return the day of month
     for "DST_DOW" number "N"}
{If  N  is larger than the number of DST_DOW's in the month, return the day
                                                           of the last one}
{If Y, M, or N are otherwise invalid, return 0}
var
  dt:TDateTime;
  NdayDom, maxdays:integer;
begin
  if TryEncodeDate(y,m,1,dt) and (n>0) then {get date of first of month}
  begin
    if n>5 then n:=5;
    NdayDOM:=8+DST_DOW-DayOfTheWeek(dt);  {1st DST_DOW Day of Month}
    result:=NdayDOM+7*(n-1);
    maxdays:=daysinMonth(dt);
    If result>maxdays  then
    repeat dec(Result,7) until Result<=Maxdays;
  end
  else result:=0;
end;


{*************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  timezoneinfo:TTimezoneinformation;
  r:word;
  t:TDatetime;
  y,m,d,d2:word;
begin
  memo1.clear;
  decodedate(now,y,m,d);{need year later on just for formatting convenience}
  r:=GetTimezoneInformation(timezoneinfo);
  if r>0 then
  with timezoneinfo, memo1 do
  begin
    daylightdate.wYear:=y;
    lines.add('SYSTEM TIME ZONE INFORMATION');
    lines.add('');

    lines.add('Current Bias from local to UTC: '+inttostr(bias)+' minutes');
    lines.add('        (UTC = Local time + Bias)');
    lines.add('Time zone name: '+ standardname);

    with daylightdate do {dayLight saving start date}
    begin
    {Field wDayOfWeek field contains weekday of start (0=Sunday)}
    {Day of month Field speciies which occurrence of the day of week is the start day}
    {getNthDSTDOW function takes this information and converts it into day of month}
      if (Daylightname='') or (wmonth<=0) or  (wmonth>12) then
      begin
        lines.add('No Daylight Saving Time information available');
        exit;
      end;
      d2:=getNthDSTDOW(y,wmonth,wDayOfWeek,wDay);
      t:=encodedate(y,wmonth,d2)+encodetime(whour,wminute,wsecond,wmilliseconds);
      lines.add(formatdatetime('"Daylight saving starts: " mmmm dd hh:nn am/pm',t));
    end;
    with standarddate do {daylight saving end date}
    begin {same computation as for start time}
      if wmonth<daylightdate.wmonth then inc(y);
      d2:=getNthDSTDOW(y,wmonth,wDayOfWeek,wday);
      t:=encodedate(y,wmonth,d2)+encodetime(whour,wminute,wsecond,wmilliseconds);
    end;
    lines.add(formatdatetime('"Daylight saving ends: " mmmm dd hh:nn am/pm',t));

    lines.add('Daylight savings name: '+Daylightname);
    lines.add('Daylight savings bias: '+inttostr(Daylightbias)+' minutes');
    lines.add('');
    case r of
      time_zone_Id_unknown: lines.add('Current daylight status is unknown');
      time_zone_id_standard:lines.add('We are not currently in the daylight savings time period');
      time_zone_id_daylight: lines.add('We are currently in the daylight savings time period');
    end;
  end
  else memo1.lines.add('Time zone information not available');
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;


(*  //Code for tresting  
procedure TForm1.Button1Click(Sender: TObject);
var
  y,m,dst_dow,N,d2:word;
  t:TDatetime;
begin
  y:=2015;
  for m:=1 to 12 do
  for DST_DOW := 0 to 6 do
  for N:=1 to 5 do
  begin
    d2:=GetNthDSTDOW(Y,M,DST_DOW,N);
    begin
      t:=encodedate(y,M,d2);
      memo1.lines.add(format ('Year:%d, Month:%d, DOW:%d, #:%d',[y,m,DST_DOW,N])
                +formatdatetime('mmmm dd ',t));
    end;
  end;
end;
*)

end.
