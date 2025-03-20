unit U_MoonDates;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Calculates date/times of new and full moons using approximations based on
 algorithm by based on the algorithm in 'Astronomical Calculations for your
 Calculator', Jean Meeus}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls;

type
  TForm1 = class(TForm)
    NbrEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    MonthsEdt: TSpinEdit;
    yearsEdt: TSpinEdit;
    Label3: TLabel;
    Button1: TButton;
    ListBox1: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    ListBox2: TListBox;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
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

uses math;

 FUNCTION FNV(A:EXTENDED):EXTENDED;
  {make sure angle is in range 0-360}
  BEGIN
    RESULT:=A-FLOOR(A/360.0)*360.0;
  END;

{*********************** NewFullMoon ***********************}
Procedure NewFullMoon(Date:TDateTime;
                               VAR FULLDATETIME, NEWDATETIME:TDATETIME;
                               VAR FULLLAT,NEWLAT:EXTENDED);

  PROCEDURE LOCAL(T,K:EXTENDED; VAR A:TDATETIME; VAR F:EXTENDED);
  VAR
    T2,C,E,A1,A2,DD,E1,B:EXTENDED;
  BEGIN
    T2:=T*T;
    E:=29.53*K;
    C:=DEGTORAD(166.56+(132.87-9.173E-3*T)*T);
    B:=5.8868E-4*K+(1.178E-4-1.55E-7*T)*T2;
    B:=B+3.3E-4*SIN(C)+7.5933E-1;
    A:=K/1.236886E1;
    A1:=359.2242+360*FRAC(A)-(3.33E-5+3.47E-6*T)*T2;
    A2:=306.0253+360.0*FRAC((K/9.330851E-1));
    A2:=A2+(1.07306E-2+1.236E-5*T)*T2;
    A:=K/9.214926E-1;
    F:=21.2964+360*FRAC(A)-(1.6528E-3+2.39E-6*T)*T2;
    A1:=FNV(A1);  A2:=FNV(A2);	F:=FNV(F);
    A1:=DEGTORAD(A1); A2:=degtorad(A2); F:=degtorad(F);
    dd:=(1.734e-1-3.93e-4*t)*sin(a1)+2.1e-3*sin(2*a1);
    DD:=DD-4.068E-1*SIN(A2)+1.61E-2*SIN(2*A2)-4E-4*SIN(3*A2);
    DD:=DD+1.04E-2*SIN(2*F)-5.1E-3*SIN(A1+A2);
    DD:=DD-7.4E-3*SIN(A1-A2)+4E-4*SIN(2*F+A1);
    DD:=DD-4E-4*SIN(2*F-A1)-6E-4*SIN(2*F+A2)+1E-3*SIN(2*F-A2);
    DD:=DD+5E-4*SIN(A1+2*A2);
    E1:=INT(E);
    B:=B+DD+E-E1;
    {B1:=INT(B); }
    A:=E1+B+1.5{+DLSHours/24.0};
    {B:=B-Bl;}
  END;


FUNCTION GETYEAR(DATE:TDATETIME):INTEGER;
VAR
  M,D,Y:WORD;
BEGIN
  DECODEDATE(DATE,Y,M,D);
  RESULT:=Y;
END;

VAR
  D1,K,TN,TF:EXTENDED;
begin {NewFullMoon}

  D1:=Date-strtodate('1/1/'+inttostr(getyear(Date)))+1;
  K:=FLOOR(((GETYEAR(DATE)-1900.0+(D1/365))*12.3685)+0.5);
  TN:=K/1236.5;
  TF:=(K+0.5)/1236.5;
  LOCAL(TN,K,NEWDATETIME, NEWLAT);
  K:=K+0.5;
  LOCAL(TF,K,FULLDATETIME,FULLLAT);
END; {NewFullMoon}

procedure TForm1.Button1Click(Sender: TObject);
var
  dt, startdate, stopdate:TDate;
  newlat,fulllat:extended;
  newtime,fulltime:TDatetime;
begin
  listbox1.clear;
  listbox2.clear;
  dt:=encodedate(yearsedt.value,monthsedt.value,1);
  startdate:=dt;
  stopdate:=incmonth(dt,nbredt.value);
  repeat
    newfullmoon(dt,fulltime,newtime,fulllat,newlat);
    if  (newtime>=startdate) and (newtime<stopdate)
    then listbox1.items.add(datetimetostr(newtime) );
    if (fulltime>=startdate) and (fulltime<stopdate)
    then listbox2.items.add(datetimetostr(fulltime));

    if fulltime>newtime then dt:=fulltime+1 else dt:=newtime+1;
  until dt>stopdate;
end;

end.
