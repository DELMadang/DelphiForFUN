unit U_MercatorDemo;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A program to test code for converting Latitude/Longitude location
  coordinates to pixel coordinates on a Mercator projection map.
  }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UGetLocDlg, ComCtrls, Inifiles, DFFUtils;

type
  TRealpoint=record
    X,Y:Extended;
  end;

  TDefinedloc=class(TObject)
    LongLat:TRealPoint; {Coordinates}
    LongLatXY:TRealPoint; {Projected coordinates}
    PixelXY:TPoint;  {projected coordinates scaled to pixels}
    Id:String;
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    StaticText1: TStaticText;
    LoadMapDlg: TOpenDialog;
    Panel1: TPanel;
    SetScaleLbl: TLabel;
    Label2: TLabel;
    Image1: TImage;
    LocationList: TListBox;
    AddlocBtn: TButton;
    RescaleBtn: TButton;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    Scale1PixelLbl: TLabel;
    Scale2PixelLbl: TLabel;
    ScaleLoc1Edt: TEdit;
    ScaleLoc2Edt: TEdit;
    ChangeScaleBtn: TButton;
    Button1: TButton;
    procedure Image1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AddlocBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocationListClick(Sender: TObject);
    procedure RescaleBtnClick(Sender: TObject);
    procedure LoadmapBtnClick(Sender: TObject);
    procedure ScaleChange(Sender: TObject);
    procedure LocationListKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeScaleBtnClick(Sender: TObject);
  public
    { Public declarations }
    scaling:boolean;  {true while scaling points are being collected}
    scalepoint:integer; {next sclaepoint to add}
    scaleloc:array[0..1] of TDefinedLoc;  {the 2 scaling points}
    ScaleX,ScaleY:extended;  {scaling factors pixels/degree calculated from scaling points}
    LastDot:TPoint; {pixel coordinates of the most recent loc clocked or selected}
    picfilename, mapName, IniName:string;
    BaseDeg:TRealPoint;
    BasePix:TPoint;
    Procedure InitializeScale;
    function StringToLocObject(s:string; loc:TDefinedloc):boolean;
    procedure makeRedDot(const P:TPoint);
    procedure addloc(const s:string; const lat,long:extended; const newy,newx:integer);
    procedure Loadmap(const fname:string);
    function loadscale(mapname:string):boolean;
    procedure savescale(mapname:string);
    procedure setscalepoint(const p:TPoint);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses UAngles;



{************************************************}
{                Support Routines                }
{************************************************}

{**************** FormCreate *****************}
procedure TForm1.FormCreate(Sender: TObject);
var
  s:string;
begin
  pagecontrol1.activepage:=Tabsheet1;
  SetMemoMargins(memo1, 20,20,20,20);
  ReformatMemo(Memo1);
  scaleloc[0]:=TDefinedLoc.create;
  scaleloc[1]:=TDefinedloc.create;
  scale1pixelLbl.caption:='';
  scale2pixelLbl.caption:='';

  {initialize dialog initial directories with program folder name}
  s:=extractfilepath(application.exename);
  LoadmapDlg.initialdir:=s;
  picfilename:=s+'USA.bmp';
  mapname:=extractfilename(picfilename);
  Ininame:=s+'Mercator.ini';
end;

{***************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Initializescale;
  scaling:=true;
  Scalepoint:=0;
  SetScalelbl.caption:='Click 1st scale point:'+scaleloc[0].id;
  lastdot.x:=-1; {initialize for no red dots to clear}
  loadmap(mapname);   {load initial scaling for the default map}
end;


{************* SetscalePoint ************}
procedure TForm1.setscalepoint(const p:TPoint);
{Set the next scale point to pixel coordinates "p"}
{Called in response to a click in image or simulated click using saved infor
 from init file. After the 2nd point is set, calculate scaling
 factors and apply them to list items}
var
  i:integer;
  Long,Lat:extended;
  savescaleflag:boolean;
  //p0{,p1}:TRealPoint;
begin
  with scaleLoc[Scalepoint] do
  begin {Set the old point  to black}
    with image1.canvas do
    begin
      pen.color:=clBlack;
      brush.color:=clBlack;
      ellipse(p.x-3,p.y-3,p.x+3,p.y+3);
    end;
    Long:=Longlat.X;
    Lat:=Longlat.y;
    LongLatXY.x:=GetLongToMercProjection(Long);
    LongLatXY.y:=GetLatToMercProjection(Lat);
    with pixelxy do
    begin
      if (x=p.x) and (y=p.y) then Savescaleflag:=false
      else
      begin
        x:=p.x;
        y:=p.y;
        Savescaleflag:=true;
      end;
    end;

    inc(ScalePoint);
    case scalepoint of
      1: begin
           scale1pixelLbl.caption:=format('Pixel location Y=%d, X=%d',[p.y,p.x]);
           SetScalelbl.caption:='Click 2nd scale point:'+scaleloc[scalepoint].id;
           if savescaleFlag then savescale(mapname);
         end;

      2: begin
           scale2pixelLbl.caption:=format('Pixel location Y=%d, X=%d',[p.y,p.x]);
           If ((scaleloc[1].PixelXY.x=0) and (scaleloc[0].PixelXY.x=0)) or
              ((scaleloc[1].PixelXY.y=0) and (scaleloc[0].PixelXY.y=0))
              then exit; {scaling values not filled in yet}
           SetScalelbl.caption:='Scaling complete. Click a point to see its Lat Long or a '
                           +' list location to see it on the map.' ;
           If saveScaleflag then savescale(mapname);
           scaling:=false;
           {do scaling here}
           BaseDeg:=scaleloc[1].LongLatXY;
           BasePix:=scaleloc[1].PixelXY;


           ScaleX:=(BasePix.x-scaleloc[0].PixelXY.x)/(Basedeg.x-scaleloc[0].LonglatXY.x);

           ScaleY:=(BasePix.y-scaleloc[0].PixelXY.y)/(BaseDeg.y-scaleloc[0].LonglatXY.y);


           for i:=0 to LocationList.items.count-1 do
           with tdefinedloc(LocationList.items.objects[i]) do
           begin {scaling is complete, fill in projection points for all locations}
             LongLatXY.x:=GetLongToMercProjection(Longlat.x);
             LongLatXY.y:=GetLatToMercProjection(longLat.y);
             pixelxy.x:=BasePix.x+trunc(scalex*(longlatxy.x-Basedeg.x));
             pixelxy.y:=trunc(BasePix.y+(longlatxy.y-Basedeg.y)*scaley);
           end;
         end;
    end; {case}
  end;
end;

{************* StringToLocObjectObject *************}
function TForm1.StringToLocObject(s:string; loc:TDefinedloc):boolean;
 var
   n:integer;
   i:integer;
 begin
   result:=true;
   {get rid of extraneous degree signs, ',", etc.}
   for i:=1 to length(s) do if s[i] in angledelims then s[i]:=' ';
   n:=pos(';',s);
   if n>0 then
   begin
     loc.id:=copy(s,1,n-1);
     delete(s,1,n);
     n:=pos(';',s);
     if n=0 then result:=false;
     If result
     then if not strtoangle(copy(s,1,n-1),loc.LongLat.y) then result:=false;
     if result then
     begin
       delete(s,1,n);
       If not strtoangle(s,loc.longlat.x) then result:=false;
       if scaling then Loc.pixelXy:=point(0,0)
       else
       begin
       end;
     end;
   end;
 end;

{************* InitializeScale *************8}
Procedure TForm1.InitializeScale;
var
 i:integer;
 Loc:TDefinedLoc;
 s:string;
begin
  s:='';
  if not StringToLocObject(scaleloc1Edt.text, scaleloc[0])
  then s:='Scalelocation 1 is invalid format'
  else if not StringToLocObject(scaleloc2Edt.text, scaleloc[1])
  then s:='Scalelocation 2 is invalid format';

  if s<>'' then showmessage(s) else
  begin  {scaling is OK, fill in listbox info}
    with LocationList do
    for i:=0 to items.count-1 do
    begin
      s:=items[i];
      loc:=TDefinedLoc.create;
      if StringToLocObject(s,loc) then
      with loc do
      begin
        items.objects[i]:=loc;
      end
      else
      begin
        showmessage('Location '+inttostr(i+1)+'('+items[i]+') is invalid');
        loc.free;
      end;
    end;
  end;
end;



{****************** Addloc ******************}
procedure TForm1.addloc(const s:string; const lat,long:extended; const newy,newx:integer);
{ Add a location to the location list}
   var
     loc:tDefinedLoc;
   begin
     loc:=TDefinedloc.create;

     with loc do
     begin
       id:=s;
       LongLat.Y:=lat;
       LongLat.X:=long;
       {Make pixel coordinates from supplied lat/long for added point}
       LongLatXY.x:=GetLongToMercProjection(long);
       LongLatXY.y:=GetLatToMercProjection(lat);
       pixelxy.y:=newy;
       pixelxy.x:=newx;
     end;
     with LocationList do
     begin
       items.addobject(format('%s; %s; %s',[s,angletostr(lat),angletostr(long)]),loc);
       itemindex:=items.count-1;
       LocationListclick(self);
       savescale(mapname);
     end;
   end;

{**************** MakeRedDot ***********}
procedure TForm1.makeRedDot(const P:TPoint);
begin
    with image1.canvas do
    begin
      if lastdot.x>=0 then
      with lastdot do
      begin {change last dot color to black}
        pen.color:=clblack;
        brush.color:=clblack;
        ellipse(x-3,y-3,x+3,y+3);
      end;
      pen.color:=clred;
      brush.color:=clred;
      ellipse(p.x-3,p.y-3,p.x+3,p.y+3);
      lastdot:=p;
    end;
  end;

{************ LoadMap**********}
procedure TForm1.Loadmap(const fname:string);
var
  i:integer;
begin
  picfilename:=fname;
  image1.picture.loadfromfile(picfilename);
  mapname:=extractfilename(picfilename);
  Tabsheet2.caption:='View map '+mapname;
  {clear list first}
    with LocationList do
    for i:=0 to items.count-1 do TDefinedLoc(items.objects[i]).free;
    LocationList.clear;
  if not loadscale(mapname) then
  begin  {mapname scaling information not found, clear out old scaling info}
    scaleloc1edt.text:='Click "Change" button to add 2 scaling points';
    scaleloc2edt.text:='Each point requires: Placename; latitude; Longitude';
    Scale1PixelLbl.caption:='Pixel  location: Y=0, X=0';
    Scale2PixelLbl.caption:='Pixel  location: Y=0, X=0';
    SetScalelbl.caption:='New map: Define 2 scaling points below to establish scale';
    scaling:=true;
    scalepoint:=0;
  end;
end;


{*************** LoadScale *************}
function Tform1.loadscale(mapname:string):boolean;
{restore scaling and location list items for a particilar map}
var
  ini:Tinifile;
  i:integer;
  s:string;
  loc:TDefinedLoc;

begin
  ini:=TInifile.create(ininame);
  with ini do
  if ini.sectionexists(mapname) then
  begin
    result:=true;

    {first restore list items so that scale points can add pixel information}
    i:=1;
    repeat
      s:=ini.readstring(mapname,format('Listitem%2.2d',[i]),'');
      if s<>'' then LocationList.items.add(s);
      inc(i);
    until s='';
    {extract lat/long from list items and create list location objects}
    with LocationList do
    for i:=0 to items.count-1 do
    begin
      s:=items[i];
      loc:=TDefinedLoc.create;
      if StringToLocObject(s,loc) then items.objects[i]:=loc
      else
      begin
        showmessage('Location '+inttostr(i+1)+'('+items[i]+') is invalid');
        loc.free;
      end;
    end;
    scaling:=true;
    scalepoint:=0;
    with scaleloc[0] do
    begin
      id:=readstring(mapname,'Sname1','Unknown');
      longlat.y:=readfloat(mapname,'Latitude1',0.0);
      longlat.x:=readfloat(mapname,'Longitude1',0.0);
      pixelxy.x:=readinteger(mapname,'X1',0);
      pixelxy.y:=readinteger(mapname,'Y1',0);

      ScaleLoc1Edt.text:=format('%s; %s; %s',
           [id, angletostr(longlat.y), angletostr(longlat.x)]);

      if (pixelxy.x>0) and (pixelxy.y>0) then
      begin
        scale1pixelLbl.caption:=format('Pixel location Y=%d, X=%d',[pixelxy.y,pixelxy.x]);
        {simulate clicking image at scaling pixel points to setup scaling}
        setscalePoint(pixelxy);
      end;
    end;
    //SetScalelbl.caption:='Click 1st scale point:'+scaleloc[0].id;
    with scaleloc[1] do
    begin
      id:=readstring(mapname,'Sname2','Unknown');
      longlat.y:=readfloat(mapname,'Latitude2',0.0);
      longlat.x:=readfloat(mapname,'Longitude2',0.0);
      pixelxy.x:=readinteger(mapname,'X2',0);
      pixelxy.y:=readinteger(mapname,'Y2',0);
      ScaleLoc2Edt.text:=format('%s; %s; %s',
           [id, angletostr(longlat.y), angletostr(longlat.x)]);

      if (pixelxy.x>0) and (pixelxy.y>0) then
      begin
        scale2pixelLbl.caption:=format('Pixel location Y=%d, X=%d',[pixelxy.y,pixelxy.x]);
        {simulate clicking image at scaling pixel points to setup scaling}
        setscalePoint(pixelxy);
      end;
    end;
  end
  else result:=false;;
  ini.free;
end;

{**************** SaveScale ***********}
procedure TForm1.savescale(mapname:string);
var
  i:integer;
  msg,s:string;
  ini:TInifile;

   function processScale(nbrstr, s:string):string;
   {take an "id; lat; long" string and  split into the three fields and write
    them to the ini file}
    var
      n:integer;
      sname,w:string;
      Lat, long:extended;
    begin
      result:='';
      n:=pos(';',s);
      if n>0 then
      begin
        sname:=copy(s,1,n-1);

        delete(s,1,n);
        n:=pos(';',s);
        if n>0 then
        begin
          w:=copy(s,1,n-1);
          if strtoangle(w,lat) then
          begin
            delete(s,1,n);
            w:=s;
            if  not strtoangle(w,Long) then result:='Longitude is not a valid angle';
          end
          else result:='Latitude is not a valid angle';
        end
        else result:='Sname'+nbrstr+': Lat and Long must be separated by a semicolon';
      end
      else result:='Sname'+nbrstr+': Name and Lat must be separated by a semicolon';
      if result='' then
      begin
        ini.writestring(mapname,'Sname'+nbrstr,sname);
        ini.writefloat(mapname,'Latitude'+nbrstr,lat);
        ini.writefloat(mapname,'Longitude'+nbrstr,long)
      end;
    end;



   procedure processxy(nbrstr:string;s:string);
   {take a pixel Y=, X= string and extract valur to write to the ini file}
   var
     n,x,y:integer;
   begin     ;
      n:=pos('Y=',s);
      if n=0 then y:=0 else
      begin
        delete(s,1,n+1);
        n:=pos(',',s);
        y:=strtoint(copy(s,1,n-1));
      end;
      ini.writeinteger(mapname,'Y'+nbrstr,Y);
      delete(s,1,n);
      n:=pos('X=',s);
      if n=0 then x:=0 else
      begin
        delete(s,1,n+1);
        x:=strtoint(s);
      end;
      ini.writeinteger(mapname,'X'+nbrstr,X);
    end;

  begin {savescale}
    ini:=TInifile.create(Ininame);
    s:=scaleLoc1edt.text;
    msg:=processscale('1' ,s);
    if (msg='') and (scalepoint>1) {don't process 2nd scale point if not there yet}
     then msg:=processscale('2',scaleLoc2edt.text);
    if msg='' then
    begin
      s:=scale1pixellbl.caption;
      processxy('1',scale1pixelLbl.caption);
      processxy('2',scale2pixellbl.caption);
    end;
    if msg='' then
    begin  {save location list items}
      for i:=0 to LocationList.items.count-1
      do ini.writestring(mapname,format('ListItem%2.2d',[i+1]),LocationList.items[i]);
    end
    else  showmessage(msg);
    {Delete any extra location list entries which were deleted by the user but
       are still in the ini file}
    i:=LocationList.items.count;
    s:=format('ListItem%.2d',[i+1]);
    while ini.valueexists(mapname,s) do
    begin
      ini.deletekey(mapname,s);
      inc(i);
      s:=format('ListItem%.2d',[i+1]);
    end;
    ini.free;
  end;

{************** ScaleChange ***********}
procedure TForm1.ScaleChange(Sender: TObject);
begin
  savescale(mapname);
end;

{****************************************************}
{                User event routines                 }
{             Click and keypress handlers            }
{****************************************************}


{***************** Image1Click *************}
procedure TForm1.Image1Click(Sender: TObject);
{for calibration, collect latitude and longitude information for the clicked point}
var
  p:TPoint;
  lx,ly:extended;
  //p1:Trealpoint;

begin
  p:=mouse.cursorpos;
  p:=image1.screentoclient(p);

  if scaling then setscalepoint(p)
  else  {(after scaling) we, add the point to the defined location list and "click" it}
  begin
    {Convert pixels to projected degrees}
    //p1:=scaleloc[1].LongLatXY;
    Lx:=BaseDeg.x-(BasePix.x-p.x)/scalex;
    Ly:=BaseDeg.y-(BasePix.y-p.y)/scaley;
    addloc('Clicked point', GetMercProjectionToLat(ly),
                    GetMercProjectionToLong(lx),
                    p.y,p.x);
  end;
end;

{*************** AddlocBtnClick ***********}
procedure TForm1.AddlocBtnClick(Sender: TObject);
{User request to add a location to the location list based on known Lat/long}
var
  p:TPoint;
  longlatxy:Trealpoint;
  p1:Trealpoint;
begin
  if scaling then showmessage('Click scaling points first')
  else
  begin
    addlocdlg.caption:='Enter information for new Location List entry';
    with addlocdlg do    {call dialog to get name & Lat/Long information}
    if showmodal = mrOK then
    begin
      LongLatXY.x:=GetLongToMercProjection(long);
      LongLatXY.y:=GetLatToMercProjection(lat);
      p1:=scaleloc[1].LongLatXY;
      p.x:=scaleloc[1].pixelxy.x+trunc(scalex*(longlatxy.x-p1.x));
      p.y:=scaleloc[1].pixelxy.y+trunc(scaley*(longlatxy.y-p1.y));
      addloc(addLocId,lat,long,p.y,p.x); {add location to the location list}
    end;
  end;
end;

{************* LocationListClick **************}
procedure TForm1.LocationListClick(Sender: TObject);
{Display the selected location on the map}
var
  p:TPoint;

begin
  with LocationList do
  if length(items[itemindex])>0 then
  with tdefinedloc(items.objects[itemindex]) do
  begin
    p:=pixelxy;
    MakeRedDot(p);
  end;
end;

{************* RescaleBtnClick ****************}
procedure TForm1.RescaleBtnClick(Sender: TObject);
{In case original scale point clicks were inaccurate, do it again}
var
  i:integer;
begin
  image1.picture.loadfromfile(picfilename);
  for i:=0 to LocationList.items.count-1 do TDefinedLoc(LocationList.items.objects[i]).free;
  Initializescale;
  scaling:=true;
  Scalepoint:=0;
  SetScalelbl.caption:='Click 1st scale point:'+scaleloc[0].id;
  lastdot.x:=-1; {initialize for no red dots to clear}
  scale1pixelLbl.caption:='';
  scale2pixelLbl.caption:='';
end;

{************* LoadmapBtnClick ***********}
procedure TForm1.LoadmapBtnClick(Sender: TObject);

begin
  If LoadmapDlg.execute
  then loadmap(LoadmapDlg.filename);
end;

{*************** ListBoxKeyUp ******************}
procedure TForm1.LocationListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  saveindex:integer;
  s:string;
  ini:TInifile;
  i:integer;
{recognize Delete key to delete a list item}
begin
  if key=vk_Delete then with LocationList do
  begin
    saveindex:=itemindex;
    items.delete(itemindex);
    ini:=TInifile.create(ininame);
    if saveindex>=items.count then
    begin {last item was deleted}
      itemindex:=items.count-1;
      s:=format('Listitem%.2d',[saveindex+1]);
      if ini.valueexists(mapname,s) then ini.deletekey(mapname,s);
    end
    else {deleted item was not the last, rebuild the list and delete the last list entry in Ini file}
    begin
      itemindex:=saveindex;
      for i:=0 to LocationList.items.count-1
      do ini.writestring(mapname,format('ListItem%2.2d',[i+1]),LocationList.items[i]);
     {Delete the last location list entry in the ini file}
      s:=format('ListItem%.2d',[LocationList.items.count+1]);
      ini.deletekey(mapname,s);
    end;
    ini.free;
  end;
end;

{******************* ChangeScaleBtnClick ***************}
procedure TForm1.ChangeScaleBtnClick(Sender: TObject);

      {------------- GetNewScalePoint ------------}
      function getnewscalepoint(n:integer):boolean;
      {Local function to collect info for a single scale point}
      {Called twice, once for each point}
      begin
        with addLocDlg do
        begin
          AddLocId:=scaleloc[n].id;
          Lat:=scaleloc[n].LongLat.y;
          Long:=scaleloc[n].LongLat.x;
          caption:='Enter Scaling point '+inttostr(n+1)+' information'
        end;
        if AddLocDlg.showmodal=MrOK then
        with addlocdlg, scaleloc[n] do
        begin
          id:=addlocid;
          LongLat.y:=lat;
          LongLat.x:=long;
          result:=true;
          if n=0 then
          {with scaleLoc[0] do} {1st scaling point}
          ScaleLoc1Edt.text:=format('%s; %s; %s',
                 [id, angletostr(longlat.y), angletostr(longlat.x)])
          else {with scaleloc[1] do} {2nd scaling point}
          {with scaleLoc[1] do  }
          ScaleLoc2Edt.text:=format('%s; %s; %s',
                 [id, angletostr(longlat.y), angletostr(longlat.x)])
        end
        else result:=false;
      end;

begin {ChangeScaleBtnClick}
  if getnewscalepoint(0) and  getnewscalepoint(1)
  then
  begin
    rescalebtnclick(sender);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

