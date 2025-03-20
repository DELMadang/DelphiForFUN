unit U_RCoaster6;
{Copyright  © 2002,2003  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Grids, u_Splines, U_CoasterB, Menus,
  mmsystem, Spin, jpeg;

type
  TForm1 = class(TForm)
    PageControl: TPageControl;
    TrackPage: TTabSheet;
    CartPage: TTabSheet;
    Runpage: TTabSheet;
    FrictionBar: TTrackBar;
    Label1: TLabel;
    CartYEdt: TEdit;
    CHeightUD: TUpDown;
    CartXEdt: TEdit;
    CLengthUD: TUpDown;
    Label5: TLabel;
    Label6: TLabel;
    FrictionLbl: TLabel;
    MassEdt: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    XrptLbl: TLabel;
    YRptLbl: TLabel;
    ThetaCRptLbl: TLabel;
    ACRptLbl: TLabel;
    GCRptLbl: TLabel;
    VCRptLbl: TLabel;
    Label21: TLabel;
    AMinRptLbl: TLabel;
    GMinRptLbl: TLabel;
    VMinRptLbl: TLabel;
    AMaxRptLbl: TLabel;
    GMaxRptLbl: TLabel;
    VMaxRptLbl: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    VZeroEdt: TEdit;
    VZeroUD: TUpDown;
    Label15: TLabel;
    Runrptlbl: TLabel;
    DebugPage: TTabSheet;
    TimeloopBox: TCheckBox;
    LoopTimeLbl: TLabel;
    Label18: TLabel;
    Edit3: TEdit;
    MaxflyUD: TUpDown;
    DebugGrid: TStringGrid;
    DebugBox: TCheckBox;
    LoadTrackBtn: TButton;
    SaveTrackBtn: TButton;
    DesignBox: TCheckBox;
    NewTrackBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Constrainedbox: TCheckBox;
    PopupMenu1: TPopupMenu;
    Addcontrolpoint1: TMenuItem;
    Deletecontrolpoint1: TMenuItem;
    ThetaMinRptLbl: TLabel;
    ThetaMaxRptLbl: TLabel;
    Image1: TPaintBox;
    SimPage: TTabSheet;
    RunSoundbox: TCheckBox;
    Label2: TLabel;
    PosLbl: TLabel;
    GroupBox1: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    GroupBox2: TGroupBox;
    Label22: TLabel;
    Label25: TLabel;
    Label4: TLabel;
    StepSecEdt: TEdit;
    StepsSecUD: TUpDown;
    Label3: TLabel;
    Label7: TLabel;
    FlyCRptLbl: TLabel;
    FlyMinRptLbl: TLabel;
    FlyMaxRptLbl: TLabel;
    XFirstUD: TUpDown;
    YFirstUD: TUpDown;
    XFirstEdt: TEdit;
    YFirstEdt: TEdit;
    FallSoundBox: TCheckBox;
    Edit1: TEdit;
    NbrCartsUD: TUpDown;
    Label16: TLabel;
    TimeScaleEdt: TEdit;
    TimeScaleUD: TUpDown;
    AspectBox: TCheckBox;
    VrXEdt: TEdit;
    VRYEdt: TEdit;
    GravityEdt: TEdit;
    PosLblBox: TCheckBox;
    AboutSheet: TTabSheet;
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Panel2: TPanel;
    StartBtn: TButton;
    StopBtn: TButton;
    StepBtn: TButton;
    ResetBtn: TButton;
    Label23: TLabel;
    TrackScaleEdt: TEdit;
    TrackScaleUD: TUpDown;
    Label24: TLabel;
    SkylineEdt: TEdit;
    SkylineUD: TUpDown;
    Label26: TLabel;
    trackScaleBtn: TButton;
    StatusBar2: TStatusBar;
    Button2: TButton;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StopBtnClick(Sender: TObject);
    procedure FrictionBarChange(Sender: TObject);
    procedure StepSecEdtChange(Sender: TObject);
    procedure VZeroEdtChange(Sender: TObject);
    procedure MassEdtChange(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StepBtnClick(Sender: TObject);
    procedure NewTrackBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DesignBoxClick(Sender: TObject);
    procedure SaveTrackBtnClick(Sender: TObject);
    procedure LoadTrackBtnClick(Sender: TObject);
    procedure ConstrainedboxClick(Sender: TObject);
    procedure CartYEdtChange(Sender: TObject);
    procedure CartXEdtChange(Sender: TObject);
    procedure SoundboxClick(Sender: TObject);
    procedure VredtExit(Sender: TObject);
    procedure VredtKeyPress(Sender: TObject; var Key: Char);
    procedure GravityEdtExit(Sender: TObject);
    {procedure XYFirstUDClick(Sender: TObject; Button: TUDBtnType);}
    procedure SkylineUDClick(Sender: TObject; Button: TUDBtnType);
    procedure XYFirstUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure NbrCartsUDClick(Sender: TObject; Button: TUDBtnType);
    procedure FormPaint(Sender: TObject);
    procedure TimeScaleEdtChange(Sender: TObject);
    procedure XYFirstEdtChange(Sender: TObject);
    procedure GravityEdtKeyPress(Sender: TObject; var Key: Char);
    procedure PosLblBoxClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure trackScaleBtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  public
    coaster:TCoaster;
    prevtime:float;
    debugrow:integer;
    directory, filename:string;
    paused:boolean;
    vmin,vmax,amin,amax,gmin,gmax,tmin,tmax,hmin,hmax:float;
    ybase:integer;
    procedure updatereportstats;
    procedure LoadCoaster(f:string);
    procedure LoadDisplaysFromCoaster;
    procedure CheckSaveModified;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

const
  statfreq:float=0.0;  {update stats every seconds of scale run time}

{******************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  directory:=extractfilepath(application.exename);
  filename:='default.coaster';
  savedialog1.initialdir:=directory;
  opendialog1.initialdir:=directory;
  randomize;
end;

{************************** TForm1.FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsmaximized;
  copyright.caption:='Copyright '+#169+' 2001,2002  Gary Darby  www.delphiforfun.org';

  coaster:=tCoaster.create(image1);
  If fileexists(directory+filename) then loadcoaster(directory+filename);

  with DebugGrid do {set dubug grid column labels}
  begin
    cells[0,0]:='Time';
    cells[1,0]:='Xval';
    cells[2,0]:='Yval';
    cells[3,0]:='Theta';
    cells[4,0]:='V';
    cells[5,0]:='Vx';
    cells[6,0]:='Vy';
    cells[7,0]:='a(tang.)';
    cells[8,0]:='a(norm.)';

    cells[9,0]:='g';
    cells[10,0]:='Dist';
    cells[11,0]:='Index';
  end;
  debugrow:=0;
  paused:=false; {to force reset}
  startbtnclick(sender);
end;

{********************** StartBtnClick ************}
procedure TForm1.StartBtnClick(Sender: TObject);
var
  loopcount, count, count2, freq:int64;
begin
   if not paused then resetbtnclick(sender);

   with pagecontrol do
   if (activepage<>DebugPage) and (activepage<>RunPage)
   then activepage:=RunPage;
   tag:=0;
   debugrow:=0;
   paused:=false;
   designbox.checked:=false;
   coaster.designmode:=false;
   DebugGrid.rowcount:=2;
   Debuggrid.fixedrows:=1;
   queryperformancefrequency(freq);
   queryperformancecounter(count);
   loopcount:=0;
   repeat
     stepbtnclick(sender) ;
     if loopcount mod 10 = 9 {every 10 steps, check for interruptions}
     then application.processmessages;
     inc(loopcount);
   until (tag<>0) or  (not coaster.cartready);
   if timeloopbox.checked then
   begin
     queryperformancecounter(count2);
     looptimelbl.caption:=format(' Avg loop time: %6.2n milliseconds',
                                 [(count2-count)/freq/loopcount*1e3]);
   end;
  end;

{********************* ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  vertex:tVertex;
begin
  tag:=1;
  sleep(100);
  timescaleEdtChange(sender);
  designbox.checked:=false;

  coaster.init(maxflyud.position);  {max fly height}
  (* no need for these updates here?
  frictionbarchange(sender);
  gravityEdtExit(sender);
  stepsecEdtChange(sender);
  SoundBoxClick(sender);
  CartxEdtChange(sender);
  CartyEdtChange(sender);
  VzeroEdtChange(sender);
  MassEdtchange(sender);
  *)
  prevtime:=0;
  coaster.drawcart;
  paused:=false;
  amin:=1e6;   amax:=-1e6;
  vmin:=1e6;   vmax:=-1e6;
  gmin:=1e6;   gmax:=-1e6;
  tmin:=1e6;   tmax:=-1e6;
  hmin:=1e6;   hmax:=-1e6;
  updatereportstats; {zero out previous results}
  with coaster do
  begin
    vertex:=bspline.vertexnr(1);
    XFirstUD.position:=round(100*(vertex.x/width));
    YFirstUD.position:=round(100*(height-vertex.y)/height);
    vertex:=bspline.vertexnr(BSpline.numberofvertices);
    SkylineUD.position:=round(100*Yskyline/height);
    VrXedt.text:=format('%5.1f',[cxmax-cxmin]);
    VryEdt.text:=format('%5.1f',[cymax-cymin]);
  end;
end;

{******************* StopBtnClick *************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin   paused:=true; tag:=1;  {set stop flag} end;

{************************ StepBtnClick **************}
procedure TForm1.StepBtnClick(Sender: TObject);
begin
  with coaster do
  if cartready then
  begin
    cartready:=steptime;
    if not cartready then
    begin {cleanup values}
      a:=0;
      v:=0;
      prevtime:=time-statfreq; {force final stats update}
    end;
    UpdateReportStats;
  end
  else  beep;
end;

{****************** NewTrackBtnClick ****************}
procedure TForm1.NewTrackBtnClick(Sender: TObject);
begin
   if coaster.modified then checksavemodified;
   coaster.free;
   coaster:=tCoaster.create(image1);
   LoadDisplaysFromCoaster;
   filename:='New.Coaster';
   designbox.checked:=true;
   coaster.designmode:=true;
   coaster.modified:=true;
end;

{*********************** SaveTrackBtnClick ***********}
procedure TForm1.SaveTrackBtnClick(Sender: TObject);
var
  st:TFilestream;
begin
  savedialog1.initialdir:=directory;
  if filename<>'' then savedialog1.filename:=filename;
  if savedialog1.execute then
  begin
    st:=tfilestream.create(savedialog1.filename,fmCreate);
    coaster.savetoStream(st);
    filename:=extractfilename(savedialog1.filename);
    directory:=extractfilepath(savedialog1.filename);
    st.free;
    loadcoaster(savedialog1.filename);
  end;
end;

{******************** LoadTrackBtnClick *************}
procedure TForm1.LoadTrackBtnClick(Sender: TObject);

begin
  opendialog1.initialdir:=directory;
  if coaster.modified then checksavemodified;
  if opendialog1.execute then loadcoaster(opendialog1.FileName);
end;

procedure TForm1.LoadDisplaysFromCoaster;
  begin
    with coaster do
    begin
      frictionbar.position:=trunc(friction*1000);
      Gravityedt.text:=format('%5.1f',[gravity]);
      if timestep=0 then timestep:=0.1;
      StepssecUD.position:=round(1/timestep);
      CLengthUD.position:=round(cartx);
      CHeightUD.position:=round(carty);
      VZeroUD.position:=trunc(vzero);
      NbrCartsUD.position:=nbrcarts;
      MassEdt.text:=inttostr(trunc(mass));
      constrainedbox.checked:=constrained;
      timescaleUD.position:=round(timescale);
      runsoundbox.checked:=playrunsounds;
      fallsoundbox.checked:=playfallsounds;
    end;
  end;

{********************* UpdateReportStats *********}
procedure TForm1.UpdateReportStats;
var
  n,t:float;
  r:integer;
begin
  with coaster do
  begin
    runrptlbl.caption:=format(' %5.1n ',[time]);
    xrptlbl.caption:=format(' %4.1n ',[xval]);
    yrptlbl.caption:=format(' %4.1n ',[yval]);
    t:=-180/pi*theta;
    thetaCrptlbl.caption:=format(' %5.1n ',[t]);
    acrptlbl.caption:=format(' %5.1n ',[a]);
    gcrptlbl.caption:=format(' %5.1n ',[coaster.g]);
    vcrptlbl.caption:=format(' %5.1n ',[v]);
    n:=max(flyheight,0);
    FlyCrptlbl.caption:=format(' %5.1n ',[n]);
    if ((not onchain) and (rec.x<brakepoint))
        or (time=0) then
    {update max & min velocity, etc. diplays only while free coaasting}
    begin

      if t>tmax then tmax:=t;
      if t<tmin then tmin:=t;
      thetaMinrptlbl.caption:=format(' %5.1n ',[tmin]);
      thetaMaxrptlbl.caption:=format(' %5.1n ',[tmax]);
      n:=a;
      If n>amax then amax:=n;
      if n<amin then amin:=n;
      aminrptlbl.caption:=format(' %5.1n ',[amin]);
      amaxrptlbl.caption:=format(' %5.1n ',[amax]);

      n:=g;
      if n>gmax then gmax:=n;
      if n<gmin then gmin:=n;
      gminrptlbl.caption:=format(' %5.1n ',[gmin]);
      if gmin<-3 then gminrptlbl.color:=clred
      else if gmin<-2 then gminrptlbl.color:=clyellow
      else gminrptlbl.color:=clAqua;
      gmaxrptlbl.caption:=format(' %5.1n ',[gmax]);
      if gmax>6 then gmaxrptlbl.color:=clred
      else if gmax>4.5 then gmaxrptlbl.color:=clyellow
      else gmaxrptlbl.color:=clAqua;

      n:=v;
      if n>vmax then vmax:=n;
      If n<vmin then vmin:=n;
      vminrptlbl.caption:=format(' %5.1n ',[vmin]);
      vmaxrptlbl.caption:=format(' %5.1n ',[vmax]);

      n:=max(Flyheight,0);
      if n>hmax then hmax:=n;
      If n<hmin then hmin:=n;
      Flyminrptlbl.caption:=format(' %5.1n ',[hmin]);
      Flymaxrptlbl.caption:=format(' %5.1n ',[hmax]);
      prevtime:=time;
    end;
    If debugbox.checked then
    with DebugGrid do
    begin
      inc(debugrow);
      r:=debugrow;
      if r>=rowcount then rowcount:=rowcount+1;
      cells[0,r]:=format('%5.2f',[Time]);
      cells[1,r]:=format('%5.2f',[Xval]);
      cells[2,r]:=format('%5.2f',[Yval]);
      cells[3,r]:=format('%5.2f',[Theta]);
      cells[4,r]:=format('%5.2f',[V]);
      cells[5,r]:=format('%5.2f',[Vx/scale]);
      cells[6,r]:=format('%5.2f',[Vy/scale]);
      cells[7,r]:=format('%5.2f',[a]);
      cells[8,r]:=format('%5.2f', [an/scale]); {a - normal}
      cells[9,r]:=format('%5.2f',[g]);
      cells[10,r]:=format('%5.2f',[distance]);
      cells[11,r]:=format('%5d',[rec.Index]);
      row:=rowcount-1;   {set cursor to last row}
    end;
  end;
end;



{************************** FormCloseQuery *****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{If the coaster has been changed, then give user a chance to save before exiting}
begin
   tag:=1;  {set stopflag}
   if coaster.modified then checksavemodified;
   canclose:=true;
   playsound(nil,0,0);
end;

{******************** CartYEdtChnage **************}
procedure TForm1.CartYEdtChange(Sender: TObject);
begin
  if assigned(coaster) then
  if coaster.carty<>cheightUD.position then
  begin
    coaster.carty:=CheightUD.position;
  end;
end;

{****************** CartXEdtChange ***************}
procedure TForm1.CartXEdtChange(Sender: TObject);
begin
  If assigned(coaster) then
  if coaster.cartx<>clengthUD.position then
  begin
    coaster.cartx:=CLengthUD.position;
  end;
end;

{******************* FrictionBarChange **************}
procedure TForm1.FrictionBarChange(Sender: TObject);
var
  n:float;
begin
  with frictionbar do
  begin
    n:=position/1000;
    if n<>coaster.friction then
    begin
      coaster.setfriction(position/1000);
      {modified:=true;}
    end;
    frictionlbl.caption:=format(' %5.3n ',[position/1000]);
  end;
end;

{******************* GravityFEditExit ************}
procedure TForm1.GravityEdtExit(Sender: TObject);
var n:float;
begin
  n:=StrtoFloat(GravityEdt.text);
  coaster.SetGravity(n);
end;

{******************* MassEdtChange *************}
procedure TForm1.MassEdtChange(Sender: TObject);
var  n:float;
begin
  n:=strtointdef(massedt.text,1000);
  if coaster.mass <> n then
  begin
    coaster.setmass(n);
    {modified:=true;}
  end;
end;

{*********************** StepsSecEdtChange ***********}
procedure TForm1.StepSecEdtChange(Sender: TObject);
var
  n:float;
begin
   If assigned(coaster) then
   begin
     n:=1/stepssecUD.position;
     if stepssecUD.position<>round(1/coaster.timestep) then
     begin
       Coaster.settimestep(n);
       coaster.settimescale(coaster.timescale); {recalc  sleep time}
     end;
   end;
end;

{********************* VZeroEdtChange *************}
procedure TForm1.VZeroEdtChange(Sender: TObject);
var
  n:float;
begin
  if assigned(coaster) then
  begin
    n:=VZeroUD.position;
    if coaster.V<>n then
    begin
      Coaster.VZero:=n;
    end;
  end;
end;

{************** DesignBoxClick *****************}
procedure TForm1.DesignBoxClick(Sender: TObject);
begin
   coaster.designmode:=designbox.checked;
   coaster.drawpoints(100);
end;

{****************** CheckaveModified *********}
procedure TForm1.CheckSaveModified;
var
  r:integer;
begin
  r:=messagedlg('Save current coaster?', mtConfirmation,[mbyes,mbno,mbcancel],0);
  if r=mryes  then SaveTrackBtnClick(self)
  else if r=mrno then coaster.modified:=false;
end;

{************** LoadCoaster *************}
procedure TForm1.LoadCoaster(f:string);
 var
  st:TFilestream;
 begin
    if coaster.modified then checksavemodified;
    st:=tfilestream.create(f,fmopenRead);
    try
      coaster.loadfromstream(st);
      with coaster do
      begin
        directory:=extractfilepath(f);
        filename:=extractfilename(f);
        LoadDisplaysFromCoaster;
      end;
      finally st.free;
    end;
    resetbtnclick(self);
    coaster.modified:=false;
    caption:='Curent Coaster: '+ filename;
    paused:=true;  {just to prevent another reset at start}
 end;

 {**************ContrainedBoxClick ************}
procedure TForm1.ConstrainedboxClick(Sender: TObject);
begin
  If constrainedbox.checked <> coaster.constrained
  then coaster.setconstrained(constrainedbox.checked);
end;

{************************ CoundBoxClick *************}
procedure TForm1.SoundboxClick(Sender: TObject);
{set sound options}
begin
  coaster.playrunsounds:=Runsoundbox.checked;
  coaster.playfallsounds:=Fallsoundbox.checked
end;

{***************** VrFEdtExit ***************}
procedure TForm1.VredtExit(Sender: TObject);
var
  newx,newy:float;
  newcxmax,newcymax:float;
begin
  with coaster do
  if sender=VRXEdt then
  begin
    newx:=Strtofloat(VRXEdt.text);
    if aspectbox.checked
    then newy:=newx/(cxmax-cxmin)*(cymax-cymin)
    else newy:=cymax-cymin;
    newcxmax:=cxmin+newx;
    newcymax:=cymin+newy;
    VRYEdt.text:=format('%5.2f',[newy]);
  end
  else
  if sender=VRYEdt then
  begin
    newy:=Strtofloat(VRyEdt.text);
    if aspectbox.checked
    then newx:=newy/(cymax-cymin)*(cxmax-cxmin)
    else newx:=cxmax-cxmin;
    newcxmax:=cxmin+newx;
    newcymax:=cymin+newy;
    VRXEdt.text:=format('%5.2f',[newx]);
  end;

  with coaster do
  rescale(cxmin,newcxmax,cymin, newcymax,
             xmin,xmax,ymin,ymax);
end;

{*******************VRFEditKeyPress *****************}
procedure TForm1.VredtKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    VredtExit(Sender);
    key:=#00;
  end
  else if not (key in ['0'..'9','.']) then
  begin
   key:=#00;
   messagebeep(MB_ICONEXCLAMATION);
  end;
end;

{********************* TimescaleUDExit *************}
procedure TForm1.TimeScaleEdtChange(Sender: TObject);
begin
  if assigned(coaster) then coaster.Settimescale(TimeScaleUD.position);
end;

{********************XYFirstEdtChange *******************}
procedure TForm1.XYFirstEdtChange(Sender: TObject);
{Check and change coaster starting point}
var
  i:integer;
  dx,dy:float;
  vertex:TVertex;
begin
    if not assigned(coaster) then exit;
    vertex:=coaster.bspline.vertexnr(1);
    dx:=XFirstUD.position*(coaster.width)/100-vertex.x;
    dy:=((100-YFirstUD.position)*(coaster.height))/100-vertex.y;

    with coaster do
    if (xmin+dx>=0) and (xmax+dx<=width) and (ymin+dy>=0) and (ymax+dy<=height)
    then
    begin
      xmin:=xmin+dx;
      xmax:=xmax+dx;
      ymin:=ymin-dy;
      ymax:=ymax-dy;

      for i:=1 to bspline.numberofvertices do
      begin
        vertex:=bspline.vertexnr(i);
        vertex.x:=vertex.x+dx;
        vertex.y:=vertex.y+dy;
        bspline.changevertex(i,vertex.x,vertex.y);
      end;
      resetbtnclick(sender)
    end
    else messagebeep(MB_ICONEXCLAMATION);
 end;

{******************** SkylineUDClick *******************}
procedure TForm1.SkylineUDClick(Sender: TObject; Button: TUDBtnType);
{change skyline}
begin
  Coaster.YSkyline:=round(coaster.height*(SkylineUD.position)/100);
  coaster.invalidate;
end;

{********************* XYFirstUDChangingEx **************}
procedure TForm1.XYFirstUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
{Check if start point change is valid}
var
  n:integer;
  d:float;
  vertex:TVertex;
begin
  allowchange:=false;
  vertex:=coaster.bspline.vertexnr(1);
  n:=newvalue;
  with coaster do
  if Sender=XfirstUD then
  begin
    d:=n*width/100-vertex.x;
    if (xmin+d>=0) and (xmax+d<=width)
    then allowchange:=true;
  end
  else if Sender=YFirstUD then
  begin
    d:=-((100-n)*height/100-vertex.y);
    if (ymin+d>=0) and (ymax+d<=height)
    then allowchange:=true;
  end ;
  if not allowchange then beep;
end;

procedure TForm1.NbrCartsUDClick(Sender: TObject; Button: TUDBtnType);
{Set nbr of carts in cart train}
begin
  coaster.nbrcarts:=NbrCartsUD.position;
end;

procedure TForm1.FormPaint(Sender: TObject);
{form will draw automaically handle all painting except for the coaster paintbox -
 call to coaster paint ensures that coaster image is redrawn when necessary}
begin  coaster.paintall(sender); end;

procedure TForm1.GravityEdtKeyPress(Sender: TObject; var Key: Char);
{make sure only valid numbers are entered}
begin
  if key=#13 then
  begin
    GravityEdtExit(sender);
    key:=#00;
  end
  else If not (key in['0'..'9','.']) then
  begin
    key:=#00;
    messagebeep(MB_ICONEXCLAMATION);
  end
end;

procedure TForm1.PosLblBoxClick(Sender: TObject);
{display mouse position in virtual world coordinates when over coaster }
begin  coaster.poslbl.visible:=PosLblBox.checked;  end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  coaster.imagecopy.savetofile('coaster.bmp');
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  pagecontrol.top:=clientheight-statusbar2.height-pagecontrol.height;
  with panel2 do
  begin
    top:= pagecontrol.top;
    left:=self.clientwidth-width;
  end;

  with image1 do
  begin
    height:=pagecontrol.top -10;
    width:=self.clientwidth;
  end;

  if coaster<>nil then
  begin
    loaddisplaysfromcoaster;
    {resetbtnclick(sender);}
  end;
end;

procedure TForm1.trackScaleBtnClick(Sender: TObject);
var n:float;
begin
  if coaster<>nil then
  with coaster do
  begin
    n:=trackscaleud.position/100;
    rescale(cxmin,cxmax,cymin,cymax,
            xmin,xmin+(xmax-xmin)*n,
            ymin,ymin+(ymax-ymin)*n);
    resetbtnclick(sender);
    trackscaleud.position:=100;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  resetbtnclick(sender);
end;

end.
