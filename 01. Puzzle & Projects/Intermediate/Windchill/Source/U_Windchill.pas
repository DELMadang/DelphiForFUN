unit U_Windchill;

{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Windchill formula info from:  http://www.nws.noaa.gov/om/windchill/
 }

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, ShellAPI, jpeg;

type
  TForm1 = class(TForm)
    ChillEdt: TEdit;
    Label2: TLabel;
    TempGrp: TGroupBox;
    FTempRadioBtn: TRadioButton;
    CTempRadioBtn: TRadioButton;
    TempEdt: TEdit;
    TempBar: TTrackBar;
    GroupBox1: TGroupBox;
    WindEdt: TEdit;
    WindBar: TTrackBar;
    MPHRadioBtn: TRadioButton;
    KPHRadioBtn: TRadioButton;
    NewChillEdt: TEdit;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Label1: TLabel;
    procedure TempBarChange(Sender: TObject);
    procedure WindBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FTempRadioBtnClick(Sender: TObject);
    procedure CTempRadioBtnClick(Sender: TObject);
    procedure MPHRadioBtnClick(Sender: TObject);
    procedure KPHRadioBtnClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    V,T:integer;
    handlev, handleT:boolean;
    procedure DoChill;
    procedure NewDoChill;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

uses math;

{Local routines }
    function  CtoF(T:integer):integer;   {centegrade to fahrenheit}
      begin result:=round(9/5*T)+32;  end;

    function FtoC(T:integer):integer;   {Fahenheit to centegrade}
      begin  result:=round((T-32)*5/9); end;


    function MtoK(V:integer):integer;   {Miles to kilometers}
      begin result:=round( V/0.6213700339); end;

    function KtoM(V:integer):integer;   {Kilometers to miles}
      begin result:=round( V*0.6213700339); end;


{***************** TempBarChange ****************}
procedure TForm1.TempBarChange(Sender: TObject);
begin

  {Stupid track bar puts max at bottom when it's vertical
  {so we adjust the displayed value to reverse it i.e.
   as the user drags the thumb up, Postion variable gets smaller
   but we want to make the temperature (or wind speed) get bigger.
   temperature = min+max-position does this.
   }
  if handleT then
  with tempbar do
  begin
    with tempbar do T:=min+max-position;
    TempEdt.text:=inttostr(T);
    DoChill;
  end;
end;

{***************** WindBarChange ****************}
procedure TForm1.WindBarChange(Sender: TObject);
begin
  if handleV then
  begin
    with Windbar do V:=min+max-position;
    WindEdt.text:=inttostr(V);
    DoChill;
  end;
end;

{********************* DoChill ***************}
procedure TForm1.doChill;
{calculate windchill factor}
var
  wc,TempT, TempV :integer;
begin
  { WC = 91.4 - (0.474677 - 0.020425 * V + 0.303107 * SQRT(V)) * (91.4 -T)}
  { T = degrees fahrenheit }
  { V = wind speed MPH }
  if CTempRadioBtn.checked {temp is in centigrade} then TempT:=CToF(T)else TempT:=T;
  if KPHRadioBtn.checked {wind is in KPH} then TempV:=KtoM(V) else TempV:=V;
  WC := trunc(91.4 - (0.474677 - 0.020425 * TempV + 0.303107 * SQRT(TempV))
     * (91.4 -TempT));
  If CTempRadioBtn.checked then WC:=FtoC(WC);
  chilledt.text:=inttostr(WC);
  NewDoChill;
end;


{********************* NewDoChill ***************}
procedure TForm1.NewDoChill;
{calculate windchill factor}
var
  wc,TempT, TempV :integer;
begin
  {Wind Chill (oF) = 35.74 + 0.6215T - 35.75(V^0.16) + 0.4275T(V^0.16)}
  { T = degrees fahrenheit }
  { V = wind speed MPH }
  if CTempRadioBtn.checked {temp is in centigrade} then TempT:=CToF(T)else TempT:=T;
  if KPHRadioBtn.checked {wind is in KPH} then TempV:=KtoM(V) else TempV:=V;
  WC := round(35.74 +0.6215*TempT - 35.75*power(Tempv,0.16) + 0.4275*T*Power(tempv,0.16));
  If CTempRadioBtn.checked then WC:=FtoC(WC);
  Newchilledt.text:=inttostr(WC);
end;

{******************* FTempRadioBtnClick *************}
procedure TForm1.FTempRadioBtnClick(Sender: TObject);
var
  tempt:integer;
begin
  with TempBar do
  if min<>-35 then {convert from Centigrade}
  begin
    handlet:=false;
    {HandleT variable solves a tricky problem -
      we are about to reset min and max which may cause "position" to
      change if it would lie it outside of the new min-max range.
      Changing position invokes the OnChange exit which changes global
      variable T , which we don't want changed.  Onchange makes sure
      handlet is true before changing T}
    min:=-35;
    max:=35;
    handlet:=true;
    TempT:=CtoF(T);
    position:=min+max-TempT;
  end;
end;

{******************* CTempRadioBtnClick *************}
procedure TForm1.CTempRadioBtnClick(Sender: TObject);
var
  tempt:integer;
begin
  with Tempbar do
  if min = -35 then {convert from Fahrenheit}
  begin
    handlet:=false;
    min:=FtoC(-35);
    max:=FToC(35);
    handlet:=true;
    TempT:=FtoC(T);
    position:=min+max-TempT;
  end;
end;

{******************* MPHRadioBtnClick *************}
procedure TForm1.MPHRadioBtnClick(Sender: TObject);
var
  tempv:integer;
begin
  with windbar do
  if min<>4 then  {convert from Kilometers}
  begin
    handlev:=false; {see Handlet comment above}
    min:=4;
    max:=80;
    handlev:=true;
    tempv:=KtoM(V);
    position:=min+max-tempV;
  end;
end;

{******************* KPHRadioBtnClick *************}
procedure TForm1.KPHRadioBtnClick(Sender: TObject);
var
  tempv:integer;
begin
  with windbar do
  if min = 4 then  {convert from miles}
  begin
    handlev:=false;
    min:=MtoK(4);
    max:=MToK(80);
    handlev:=true;
    tempV:=MtoK(V);
    position:=min+max-TempV;
  end;
end;

{****************** FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  with tempbar do
  begin
    max:=35;
    min:=-35;
    T:=32;
     handlet:=true;
    position:=min+max-T;
  end;
  with windbar do
  begin
    max:=80;
    min:=4;
    V:=10;
    handlev:=true;
    position:=min+max-V;
  end;
  DoChill;
end;




procedure TForm1.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.nws.noaa.gov/om/windchill/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
