unit U_Datecalc2;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Spin, dateutils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Label1: TLabel;
    CalcType: TComboBox;
    CalcBtn: TButton;
    DiffPanel: TPanel;
    Label2: TLabel;
    FromDate: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    YMWDDiffsEdt: TEdit;
    DaysDiffEdt: TEdit;
    Label4: TLabel;
    Todate: TDateTimePicker;
    AddSubPanel: TPanel;
    Label3: TLabel;
    DiffdatePicker: TDateTimePicker;
    Label8: TLabel;
    DateDiffEdt: TEdit;
    Addbtn: TRadioButton;
    SubtractBtn: TRadioButton;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    YearsEdt: TSpinEdit;
    MonthsEdt: TSpinEdit;
    DaysEdt: TSpinEdit;
    TestBtn: TButton;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure CalcTypeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DiffdataChange(Sender: TObject);
    procedure DateDataChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    randseedsave:integer;
    function setmessage(n:integer; units:string):string;
    procedure datediff(date1,date2:TDate; var ydiff,mdiff,wdiff,ddiff:integer);
    function getdateYMD(date1:TDate; ydiff,mdiff,ddiff:integer;subtract:boolean):TDate;
    //function getdate(date1:TDate; ydiff,mdiff,ddiff:integer;subtract:boolean):TDate;
    function getdateDMY(date1:TDate; ydiff,mdiff,ddiff:integer;subtract:boolean):TDate;

  end;

var
  Form1: TForm1;

implementation

uses U_ErrDlg2;

{$R *.DFM}





{************ FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randseedsave:=0;
  FromDate.date:=Today;
  ToDate.date:=Today;
  DiffdatePicker.date:=today;
  YearsEdt.value:=0;
  MonthsEdt.value:=0;
  DaysEdt.value:=0;
  Diffpanel.BringToFront;
end;

{********** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  calcbtn.setfocus;
end;

{*************** CalcTypeClick ***********}
procedure TForm1.CalcTypeClick(Sender: TObject);
begin  {set type of calculation to be performed}
  case TComboBox(sender).ItemIndex of
    0: DiffPanel.BringToFront;
    1: AddSubPanel.BringtoFront;
  end;
  calcbtn.Setfocus;
end;


{*********** CalcBtnClick ***********}
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  diff:integer;
  yeardiff,monthdiff,weekdiff,daydiff:integer;
  date1,date2{,date3}:TDate;
  s:string;
begin
  if calctype.itemindex=0 then
  begin  {Calculate YMWD differences between two given dates}
    date1:=trunc(fromdate.date);
    date2:=trunc(todate.date);
    diff:=trunc(date2-date1);
    if  diff=0 then
    begin
      s:='Same date';
      daysdiffEdt.text:=s;
      YMWDDiffsEdt.Text:=s;
    end
    else
    begin
      datediff(date1,date2,yeardiff,monthdiff,weekdiff,daydiff);
      if diff<0 then diff:=-diff;

      s:=setmessage(diff,'day');
      delete(s, length(s)-1,2);  {get rid of the trailing ', '}
      daysdiffEdt.text:=s;  {display difference in days}

      {setup messages to drop 0 values and use correct plural form for others}
      s:=  setmessage(yeardiff,'year')+setmessage(monthdiff,'month')
                       +setmessage(weekdiff,'week')+setmessage(daydiff,'day');
      if length(s)>0 then delete(s,length(s)-1,2);
      YMWDDiffsEdt.Text:=s;
    end
  end
  else
  begin  {add/subtract years, months, and days from a given date}
    daydiff:=daysedt.value;
    monthdiff:=monthsedt.value;
    yeardiff:=yearsedt.value;
    date2:=getdateYMD(diffdatepicker.date,yeardiff,monthdiff,daydiff,subtractbtn.checked);
    //date3:=getdateDMY(diffdatepicker.date,yeardiff,monthdiff,daydiff,subtractbtn.checked);
    datediffedt.Text:=formatdatetime('dddddd',date2){+'  '+formatdatetime('dddddd',date3)};
  end;
end;

{************* TestBtnClick ************}
procedure TForm1.TestBtnClick(Sender: TObject);
var
  i,mr:integer;
  ydiff,mdiff,wdiff,ddiff:integer;
  date1,date2,date2B,date2C:TDate;
  nbrtests:integer;
  maxdiff:integer;
begin
  if errdlg.repeatbox.checked then randseed:=randseedsave  {make tests repeatable}
  else
  begin
    randomize;
    randseedsave:=randseed;
  end;
  nbrtests:=1000;
  with errdlg do
  begin
    hide;
    Testcount:=0;
    Errcount:=0;
    memo1.clear;
    cancelbtn.visible:=true;
    maxdiff:=difflimit.Value;
    done:=false;
    for i:=1 to nbrtests do
    begin
      if maxdiff<> difflimit.value then
      begin
        memo1.lines.add('');
        memo1.lines.add(format('%d tests completed, %d date pairs with recaalc difference >= %d',
                               [testcount, errcount, maxdiff]));
        testcount:=0;
        errcount:=0;
        maxdiff:=difflimit.value;
      end;
      inc(testcount);
      date1:=today+random(36000) -18000;
      date2:=today+random(36000) -18000;
      datediff(date1,date2,ydiff,mdiff,wdiff,ddiff);
      {date1>date2 = boolean "subtract" flag}
      date2B:=getdateYMD(date1,ydiff,mdiff,wdiff*7+ddiff,date1>date2);
      date2C:=getdateDMY(date1,ydiff,mdiff,wdiff*7+ddiff,date1>date2);

      d1Lbl.caption:=formatdatetime('dddddd',date1);
      d2Lbl.caption:=formatdatetime('dddddd',date2);
      DDiffLbl.caption:=setmessage(ydiff,'year')+setmessage(mdiff,'month')
                     +setmessage(wdiff,'week')+setmessage(ddiff,'day');
      RecalcLblYMD.caption:='YMD recalc order: '+formatdatetime('dddddd',date2B);
      RecalcLblDMY.caption:='DMY recalc order: '+formatdatetime('dddddd',date2C);

      if  (abs(trunc(date2B)-trunc(date2))>=maxdiff)
      then
      begin
        inc(errcount);
        memo1.lines.add(format('#%d: %s to %s, Diff(%dY, %dM, %dW, %dD),'
                                +' Recalc YMD Date: %s  Recalc error: %d',
                  [testcount, datetostr(date1),datetostr(date2),
                   ydiff,mdiff,wdiff,ddiff,datetostr(date2b), trunc(date2B-date2)]));
        if pausebox.checked then mr:=showmodal else mr:=0;
        if  mr=mrcancel then break;
      end;
    end;
    memo1.lines.add('');
    memo1.lines.add(format('%d tests completed, %d date pairs with recaalc difference >= %d',
      [testcount, errcount, difflimit.value]));
    done:=true;
    show;
  end;
  //form1.setfocus;
end;


{******************* DateDataChange ************}
procedure TForm1.DateDataChange(Sender: TObject);
begin
  YMWDDiffsEdt.text:=''; {Clear result fields when input dates change}
  DaysDiffEdt.text:='';
end;

{**************** DiffDataChange ****************}
procedure TForm1.DiffdataChange(Sender: TObject);
begin
  DateDiffEdt.text:='';  {clear results field when any date diff input changes}
end;

{***************************************************}
{                Support routines                   }
{***************************************************}

{--------------- SetMessage ------------}
function TForm1.setmessage(n:integer; units:string):string;
{sets a message with correct plurality for the passed value, n,  and units
fields.  zero values return and empty string, otherwise ', ' is appended
to the result}
begin
  if n=0 then result:=''
  else
  begin
    result:=format('%d %s',[n,units]);
    if n<>1 then result:=result+'s';
    result:=result+', ';
  end;
end;


{************ DateDiff ***************}
procedure TForm1.datediff(date1,date2:TDate; var ydiff,mdiff,wdiff,ddiff:integer);
{Find the Years, Months, Weeks, and Days between two dates}
 var
   y1,m1,d1,y2,m2,d2:word;
   kind:integer;
   tempdate:TDate;
begin
  decodedate(date1,y1,m1,d1);
  decodedate(date2,y2,m2,d2);
  {identify the 8 possible combinations of larger/smaller of differences of
   years, months, and days between the two given dates}
  if y1>y2 then kind:=4 else kind:=0; {0 or 4}
  if m1>m2 then inc(kind,2);  {add 0 or 2}
  if d1>d2 then inc(kind);    {add 0 or 1}

  {treat moving backwards across months in the same year as if we were moving
   backwards across years (case 2 or 3 becomes case 6 or 7)}
   if  (y1=y2) and (m1>m2) then inc(kind,4);
  case kind of
    0:  {(y1<=y2, m1<=m2, d1<=d2)}
    begin
      ydiff:=y2-y1;
      mdiff:=m2-m1;
      ddiff:=d2-d1;
    end;
    1:  {(y1<=y2, m1<=m2, d1>d2)}
    begin
      ydiff:=y2-y1;
      if  (m1<m2) or (y1<y2)  then
      begin
        if m1<m2 then mdiff:=m2-m1-1
        else
        begin
          mdiff:=11;
          dec(ydiff);
        end;

        {need mdiff to get us to the d1 date in the month prior to m2 if
        that is possible.  Prior month may not have d1 days in it, in that
        case set new date to the last day of the prior month}
        tempdate:=incyear(date1,ydiff);
        tempdate:=incmonth(tempdate,MDIFF);
        ddiff:=trunc(endofamonth(yearof(tempdate),monthof(tempdate))-tempdate)+D2;
      end
      else
      begin
        ddiff:=d1-d2;
        mdiff:=0;
      end;
    end;
    2:  {(y1<y2, m1>m2, d1<=d2)}
    begin
      If y1<y2 then
      begin
        ydiff:=y2-y1-1;
        mdiff:=12-(m1-m2);
        ddiff:=d2-d1;
      end;
    end;
    3: {(y1<y2, m1>m2, d1>d2)}
    begin
      ydiff:=y2-y1-1;
      {need mdiff to get us to the d1 date in the month prior to m2 if
       that is possible.  Prior month may not have d1 days in it, in that
       case set new date to the last day of the prior month}
       tempdate:=incyear(date1,ydiff);
       mdiff:=11-(m1-m2);
       tempdate:=incmonth(tempdate,MDIFF);
       ddiff:=trunc(endofamonth(yearof(tempdate),monthof(tempdate))-tempdate)+D2;

    end;
    {last four cases compute back in time, W7 Calculator will reverse these dates
     and always calculate the difference in the forward direction}
    4: {(y1>y2, m1<=m2, d1<=d2)}
    begin
      If (m1=m2) and (d1=d2) then
      begin  {exact number of years}
        ydiff:=y1-y2;
        mdiff:=0;
        ddiff:=0;
      end
      else
      begin
        ydiff:=y1-y2-1;
        mdiff:=11+M1-m2;
        ddiff:=d1+daysinamonth(y2,m2)-d2;
        (*  {this version also works}
        ydiff:=y1-y2-1;
        tempdate:=incyear(date1,-ydiff);
        mdiff:=11+m1-m2;
        tempdate:=incmonth(tempdate,-mdiff);
        ddiff:=trunc(tempdate-date2);
        *)
      end;
    end;
    5: {(y1>y2, m1<=m2, d1>d2)}
    begin
      ydiff:=y1-y2-1;
      mdiff:=m1+12-m2;
      ddiff:=d1-d2;
    end;
    6: {(y1>=y2, m1>m2, d1<=d2)}
    begin
      ydiff:=y1-y2;
      mdiff:=m1-m2-1;
      ddiff:=d1+daysinamonth(y2,m2)-d2;
    end;
    7: {(y1>=y2, m1>m2, d1>d2)}
    begin
      ydiff:=y1-y2;
      mdiff:=m1-m2;
      ddiff:=d1-d2;
    end;
  end;
  wdiff:=ddiff div 7;  {calculate weeks difference from days differences}
  ddiff:=ddiff mod 7;  {adjust day difference for the remainder after removing weeks}
end;


{*************** GetDateYMD ***************}
function TForm1.GetdateYMD(date1:TDate; ydiff,mdiff,ddiff:integer; subtract:boolean):TDate;
{Apply year, month and day differences to date1 and return the resulting date}
var
  mult:integer;
  monthdayerror:integer;
begin
  if subtract then mult:=-1 else mult:=+1;
  result:=incyear(date1,mult*ydiff);
  result:=incmonth(result,mult*mdiff);
  if mult<0 then
  begin
    monthdayerror:=dayof(result)-dayof(date1);
    inc(ddiff, monthdayerror);
  end;
  result:=incday(result,mult*ddiff);
end;

{*************** GetDateDMY ***************}
function TForm1.GetdateDMY(date1:TDate; ydiff,mdiff,ddiff:integer; subtract:boolean):TDate;
{Calculate new date from days through years (reverse order) }
{Mainly to illustrate that date arithmetic is not commutative (order matters!)}
var
  mult:integer;
begin
  if subtract then mult:=-1 else mult:=+1;
  result:=incday(date1,mult*ddiff);
  result:=incmonth(result,mult*mdiff);
  result:=incyear(result,mult*ydiff);
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
