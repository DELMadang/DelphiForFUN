unit U_TileFit3;
{Copyright  © 2001, 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Fits a random subset of a given set of tiles to fill a given rectangle}

interface

{You'll see a lot of references to GCD in this program.  GCD stands for
 Greatest Common Denominator, in this case the largest integer that divides
 all tile sizes.  Thus if tiles come in multiples of 3 inches, the GCD
 is 3 and we can internally divide everything by 3 to build array of possible
 tile corners, etc.}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Menus, ExtCtrls, ComCtrls, NumEdit2, Spin, shellapi;

  Const
  maxNbrTileSizes=16; {max number of tile entries}
  maxTabledim=30; {max table height or width after dividing by GCD}
  maxtilesize=20; {max tilesize after dividing by GCD}
  maxtilesInFig=100; {max total tiles in a figure}

Type
  TTileType =record
     ID:string;
     x,y,nbr:integer;
     color:integer;
   end;
  TTileArray= array[1..maxNbrTileSizes] of TTileType;
  TFigArray=array[1..MaxTableDim,1..MaxTableDim] of integer;
  TTileSizes=array[1..MaxTileSize,1..MaxTileSize] of integer;

  TSavedTile = record
    p1,p2:TPoint;
    Id: string[6];
    color:integer;
  end;

  TSavedfig= class(TObject)
      tile: array[1..MaxTilesInFig] of TSavedTile;
      rectnbr:integer; {Which table is  this}
      figwidth,figheight:integer;  {how big is it}
      Procedure assign(infig:TSavedFig);
    end;

  TScaleInfo=record
        Origin:TPoint;
        scale:TPoint;
     end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    OpenTileSet1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    GroupBox2: TGroupBox;
    Tilegrid: TStringGrid;
    AddBtn: TButton;
    RemoveBtn: TButton;
    ChangeBtn: TButton;
    GetNextBtn: TButton;
    StopBtn: TButton;
    Panel1: TPanel;
    HLabel: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PrintDialog1: TPrintDialog;
    Oprtions1: TMenuItem;
    SetMaxRunTime1: TMenuItem;
    SaveBtn: TButton;
    SaveFigList: TListBox;
    PrintOptions1: TMenuItem;
    PrintPreview1: TMenuItem;
    PrintSavedPages1: TMenuItem;
    AreaHUD: TUpDown;
    SizeBox: TCheckBox;
    TickBox: TCheckBox;
    ColorBox: TCheckBox;
    StaticText1: TStaticText;
    ReduceBox: TCheckBox;
    Panel2: TPanel;
    Label1: TLabel;
    AreaWUD: TUpDown;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure TilegridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure AddBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure GetNextBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure SetMaxRunTime1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure OpenTileSet1Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveFigListClick(Sender: TObject);
    procedure SaveFigListKeyPress(Sender: TObject; var Key: Char);
    procedure SaveFigListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PrintOptions1Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure PrintSavedPages1Click(Sender: TObject);
    procedure Loadtiles(fname:string);
    procedure CheckBoxClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  public
   Thisfig : Tsavedfig;
   figmap:TFigArray;
   Sizesavail,SpacesAvail:TTileSizes;
   selectfigs:TTileArray;
   maxfigs:word;
   nbrSAVED:word;
   ScreenInfo:TScaleInfo; {origin and scale for displaying tiles}
   Topleft:Tpoint;
   Bottomright:TPoint;
   maxx,maxy:integer;
   filename:string;
   maxrunsecs:integer;
   figcount:integer;
   figsPerPage:integer;
   ShowTicmarks:boolean;  {Show unit spaced tick marks around table}
   GCDVal:integer;
   currentheld: boolean; {true=current pattern has been retained}
   areahedt,areawedt:TIntedit;
    Procedure drawfig(Tile:TSavedTile;ScaleInfo:TScaleInfo;Can:TCanvas);
    Function figfits(tile:TTiletype):boolean;
    Procedure reset;
    Procedure Loadselectfigs;
    Procedure Savetiles;
    Procedure MakePrintimage(Startat:integer;can:TCanvas);
    Function GetGCD:integer;
    procedure rescale;
  end;

var
  Form1: TForm1;

implementation

uses U_Runtime,U_ChangeTile ,U_PrintLayout ,
         printers, {myutils,} U_PreView;

{$R *.DFM}
  {Local routines}


  function hexstrtoint(s:string):integer;
  {convert hex string to integer}
  var i,n:integer;
  begin
    n:=0;
    s:=uppercase(s);
    for i:=1 to length(s)do
    begin
      n:=n*16;
      if s[i] in ['0'..'9'] then n:=n+ord(s[i])-ord('0')
      else if s[i] in ['A'..'F'] then n:=n+10+ord(s[i])-ord('A');
    end;
    result:=n;
  end;

    function getword(var w:string):string;
    {Destructive getword - removes the first word from an
     input string and returns it in result string}
    var
      i:integer;
    Begin
      i:=1;
      result:='';
      If length(w)=0 then exit;
      if w[length(w)]<>',' then w:=w+','; {make sure we have a "stopper"}
      {skip leading spaces and tabs}
      while (i<=length(w)) and  (w[i] in [' ',#9]) do inc(i);
      If w[i] =',' then result:=''
      else
      Begin
        If i>1 then w:=copy(w,i,length(w)-i+1);
        i:=1;
        while (i<=length(w)) and not (w[i] in [' ',#9,',']) do inc(i);
        result:=copy(w,1,i-1);
      End;
      system.delete(w,1,i);
    End;

    Function gcd2(a,b:integer):integer;
   {return gcd of two integers, a and b}
   {Euclid's method
    - based of fact that GCD of 2 numbers also divides the remainder
      when one is divided by the other}
   var
     g,z:integer;
   Begin
     g:=b;
     If b<>0 then
     while g<>0 do
     Begin
       z:=a mod g;
       a:=g;
       g:=z;
     end;
     result:=a;
   end;

  Function GCD(A:array of integer):integer;
 {Greatest common denominator of an array of integers}
  var
   i:integer;
   g:integer;
 Begin                             g:=a[0];
   if length(a)>=2 then
   Begin
     g:=gcd2(g,a[1]); {get GCD for 1st two numbers}
     if length(a)>2 then {GCD for rest is GCD of prev GCD and next number}
     for i:= 2 to length(a)-1 do g:=gcd2(g,a[i]);
   end;
   result:=g;
 end;

 {******************************************************}
 {**************** TSavedFig Class methods *************}
 {******************************************************}

 {****************** Tsavedfig.Assign *****************}
 Procedure Tsavedfig.assign(infig:TsavedFig);
 {assign one table decription to another }
 var  i:integer;
 begin
   rectnbr:=infig.rectnbr;
   for i := 1 to rectnbr do tile[i]:=infig.tile[i];
   figwidth:=infig.figwidth;
   figheight:=infig.figheight;
 end;

 {***********************************************}
 {***************** TForm Methods ***************}
 {***********************************************}

 {********************** drawfig ***************}
 Procedure TForm1.drawfig(Tile:TSavedTile;ScaleInfo:TScaleInfo;Can:TCanvas);
 {draw a single tile with upper left corner at T}
     Var tx,ty,bx,by,w,h:word;
     begin
       With scaleinfo, tile do
       begin
         tx:=Origin.x+p1.x*scale.x;
         ty:=Origin.y+p1.y*scale.y;
         bx:=Origin.x+(p1.x+p2.x)*scale.x;
         by:=Origin.y+(p1.y+p2.y)*scale.y;
       end;
       if colorbox.checked then can.brush.color:=tile.color
       else can.brush.color:=clwhite;
       Can.Rectangle(Tx,ty,bx,by);
       if sizebox.checked then
       begin
         can.font.name:='Arial';
         can.font.size:= 8;
         w:=can.textwidth(tile.id);
         h:=can.textheight(tile.id);
         can.textout((tx+bx-w) div 2, (ty+by-h) div 2, tile.id);
       end;
     end;


 {***************** figFits *****************}
 Function TForm1.figfits(tile:TTileType):boolean;
 var
   worktile:TTiletype;
   n:integer;
  {test to see if this tile fits the space remaining}
     {************ tryfit *************}
     function tryfit(x,y:integer):boolean;
     var
        i,j:integer;
      begin
      result:=true;
      j:=topleft.y;
      repeat
        inc(j);
        i:=topleft.x;
        repeat
          inc(i);
          if (i>maxx) or (j>maxy) or (figmap[j,i]<>0)
                             then result:=false;
        Until (i>=topleft.x+x) or  not (result);
      until (j>=topleft.y+y) or (not result);
    end;

    {********** loadfig *********}
    procedure loadfig(const Tile:TTileType);
    {add this tile to the tilelist}
    var i,j:integer;
    begin
        for j:=topleft.y+1 to topleft.y + tile.y
        do for i:=topleft.x+1 to topleft.x +tile.x
        do figmap[j,i]:=1;
        inc(thisfig.rectnbr);
        If thisfig.rectnbr<maxtilesinfig then
        With thisfig.tile[thisfig.rectnbr] do
        begin
          p1.x:=topleft.x;
          p1.y:=topleft.y;
          p2.x:=tile.x;
          p2.y:=tile.y;
          Id:=tile.Id;
          color:=tile.color;
        end;
        {else showmessage('More than '+ maxfigs +' found, reduce table size');}

        i:=0; j:=1;
        repeat  {find next location to fill}
          inc(i);
          if i>maxx then
          begin
            i:=1;
            inc(j);
          end
          until (figmap[j,i]=0) or ((i>=maxx) and (j>=maxy));
        topleft.x:=i-1; topleft.y:= j-1;
        bottomright.x:=i; bottomright.y:=j;
        {figfits:=true;}
    end;

    begin {figfits}
      result:=false;
      worktile:=tile;

      {need to try both orientations randonly, otherwise
       we'll select too many with same orientation}
      if random(2)=0 then  {rotate tile half the time}
      begin
        worktile.x:=tile.y;
        worktile.y:=tile.x;
      end;
      with worktile do
      begin
        If  tryfit(x,y) then
        begin
          loadfig(worktile);
          result:=true;
        end
        else
        if (x<>y) and tryfit(y,x)
        then
          begin
            n:=worktile.x;
            worktile.x:=worktile.y;
            worktile.y:=n;
            loadfig(worktile);
            result:=true;
          end;
      end;

    end; {figfits}

{**************** reset ************}
Procedure TForm1.reset;
    Var i,j:word;
        {GCD:Integer;}
    begin
      GCDval:=getgcd;
      maxx:=AreaWEdt.value div GCDval;
      maxy:=AreaHEdt.value div GCDval;
      for i:=1 to maxx do
        for j:=1 to maxy do figmap[j,i]:=0;
      Topleft.x:=0; Topleft.y:=0;
      thisfig.rectnbr:=0;
    end;

{**************** GetGCD ***************}
Function TForm1.GetGCD:integer;
{Get greatest common divisor of tile sizes}
var
  i:integer;
  n:array{[1..2*maxtilesize]} of integer;
begin
  setlength(n,2*tilegrid.rowcount-2);
  with tilegrid do
  for i:=1 to rowcount-1 do
  begin
    n[2*(i-1)]:=strtoint(cells[1,i]);
    n[2*i-1]:=strtoint(cells[2,i]);
  end;
  result:=GCD(n);

  {set dimension edits so that allowable values are
   multiples of GCD for this tileset}
  with AreaHUD do
  begin
    min:=result;
    increment:=result;
  end;
  AreaHEdt.value:=(AreaHedt.value*result) div result;
  with AreaWUD do
  begin
    min:=result;
    increment:=result;
  end;
  AreaWEdt.value:=(AreaWedt.value*result) div result;
end;

{*************** TileGridSelectCell ***********}
procedure TForm1.TilegridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
  begin
    RemoveBtn.enabled:=true;
    ChangeBtn.enabled:=true;
  end;

{***************** AddBtnclick *************}
procedure TForm1.AddBtnClick(Sender: TObject);
{add a tile size}
  begin
    if TileForm.showmodal = mrOK then
    with TileForm, tilegrid do
    begin
      rowcount:=rowcount+1;
      row:=rowcount-1;
      cells[0,row]:=IdEdt.text;
      cells[1,row]:=inttostr(heightedt.value);
      cells[2,row]:=inttostr(widthedt.value);
      cells[3,row]:=inttostr(countedt.value);
      cells[4,row]:=inttohex(prototile.brush.color,6);
    end;
  end;

{***************** RemoveBtnLCick *************}
procedure TForm1.RemoveBtnClick(Sender: TObject);
{remove a tile size}
  var
    i,j:integer;
  begin
    if tilegrid.row>0 then
    with tilegrid do
    begin
      for i:= row to rowcount-2 do
      for j:=0 to colcount-1 do cells[j,i]:=cells[j,i+1];
      rowcount:=rowcount-1;
    end;
  end;



{******************** ChangeBtnclick *************}
procedure TForm1.ChangeBtnClick(Sender: TObject);
  begin
    if tilegrid.row=0 then exit;
    with TileForm,tilegrid do
    begin
      IdEdt.text:=cells[0,row];
      heightedt.value:=strtoint(cells[1,row]);
      widthedt.value:=strtoint(cells[2,row]);
      countedt.value:=strtoint(cells[3,row]);
      prototile.brush.color:=hexstrtoint(cells[4,row]);
      if showmodal = mrOK then
      begin
        cells[0,row]:=IdEdt.text;
        cells[1,row]:=inttostr(heightedt.value);
        cells[2,row]:=inttostr(widthedt.value);
        cells[3,row]:=inttostr(countedt.value);
        cells[4,row]:=inttohex(prototile.brush.color,6);
      end;
    end;
  end;

procedure TForm1.rescale;
var p:integer;
begin
  GCDval:=getGCD;
  If areaWedt.value>AreaHedt.value
  then p:=AreawEdt.value Div GCDval else p:=AreaHEdt.value div GCDval;
  screeninfo.scale.x:=panel1.width div (p* GCDval) *GCDval;
  screenInfo.scale.y:=panel1.height div (p * GCDval) *GCDval;
  repaint;
end;


{******************** GetNextBtnClick ****************}
procedure TForm1.GetNextBtnClick(Sender: TObject);
{The central routine of the program
  Search for a set of tiles that ecactly covers the defined table area}
  var
    i,j,k,p, sum, count, mini:integer;
    done, found,f:boolean;
    t:array[1..MaxTableDim] of TTileType;
    StartTime:TDateTime;
    {GCD:Integer; }
    szcount, cumcount, n:integer;
    sztiles,szcum:array[1..maxnbrtilesizes] of integer;
    lastadded:boolean;
  begin
    currentheld:=false;
    panel1.visible:=false;
    Screen.cursor:=crHourGlass;
    ScreenInfo.origin.x:=panel1.left;
    Screeninfo.origin.y:=panel1.top;
    GCDval:=getGCD;
    If areaWedt.value>AreaHedt.value
    then p:=AreawEdt.value Div GCDval else p:=AreaHEdt.value div GCDval;
    screeninfo.scale.x:=panel1.width div (p* GCDval) *GCDval;
    ScreenInfo.scale.y:=panel1.height div (p * GCDval) *GCDval;
    LoadSelectFigs;
    Reset;
    done:=false;
    starttime:=Time;
    tag:=0;
    lastadded:=false;
    stopbtn.enabled:=true; {let the user stop the search}
    Repeat
      If ((topleft.x<maxx-1) or (topleft.y<=maxy-1)) {not full yet}
      //if (bottomright.x<maxx) or (bottomright.y<maxy) {not full yet}
      then
      begin
        repeat
            {fill in array of available empty spaces across and down
                 from current location}
            i:=1;
            j:=1;
            mini:=maxx;
            if mini>maxtilesize then mini:=maxtilesize;
            while (figmap[topleft.y+j,topleft.x+i]=0)
                    and (topleft.y+j<=maxy)
            do
            begin
              while   (topleft.x+i<=maxx)
                  and (figmap[topleft.y+j,topleft.x+i]=0) do inc(i);
              if i<mini then mini:=i;

              for k:=1 to mini-1 do spacesavail[j,k]:=1;
              i:=1;
              inc(j);
            end;
            {now count how many available tiles could fit available space}
            count:=0;
            for i:= 1{i} to maxtilesize do
            for j:=1 to maxtilesize do
            begin
              if (spacesavail[j,i]>0) and (Sizesavail[j,i]>0) then
              begin
                inc(count);
                t[count].x:=i;
                t[count].y:=j;
              end;
              spacesavail[j,i]:=0; {reset}
            end;
            {If there are any then choose one randomly}
            If count>0 then
            begin
              p:=random(count)+1;
              //found:=false;
              i:=1;
              // Added code
              {we know the x and y sizes, but we don't know which tile it is - find it}
              {There may be multiple colors of the same size represented here - we need
               to select a random entry from those still available}

              szcount:=0;
              cumcount:=0;
              while i<=maxfigs do
              begin
                //if not((selectfigs[i].x=t[p].x) and (selectfigs[i].y=t[p].y))
                //   and  not ((selectfigs[i].x=t[p].y) and (selectfigs[i].y=t[p].x))
                //then
                //else
                if ((selectfigs[i].x=t[p].x) and (selectfigs[i].y=t[p].y)) or
                   ((selectfigs[i].x=t[p].y) and (selectfigs[i].y=t[p].x))
                then
                begin
                  inc(szcount);
                  sztiles[szcount]:=i;
                  cumcount:=cumcount+selectfigs[i].nbr;
                  szcum[szcount]:=cumcount;
                end;
                inc(i);
              end;
              If szcount>0 then
              Begin
                {select a random tile from all those of this size}
                n:=random(cumcount)+1;
                i:=1;
                while szcum[i]<n do inc(i);
                i:=sztiles[i]; {convert position to tile number}
              (*  {replaced code}
              {we know the x and y sizes, but we don't know which tile it is - find it}
              while not found do
              begin

                if not((selectfigs[i].x=t[p].x) and (selectfigs[i].y=t[p].y))
                   and  not ((selectfigs[i].x=t[p].y) and (selectfigs[i].y=t[p].x))
                then inc(i)
                else found:=true;
              end;
              *)
                if (topleft.x=maxx) and (topleft.y=maxy) then f:=true
                else f:=figfits(selectfigs[i]);
                If not f
                then showmessage('System Error: Selected Tile didn''t fit');
                p:=i;
              end
              else f:=faLSE;
            end
            else f:=false; {none found that will fit}
        Until (f) or (count=0) or (tag=1);
        If (not f) then
        if (bottomright.x<maxx) or (bottomright.y<maxy) then
        begin
          Application.Processmessages;
          If secsperday*(time-starttime)>maxrunsecs  then
          begin
             showmessage('No complete tilings found in '
                     + #13
                     + 'Retry or increase tile set and then retry');
             done:=true;
          end
          else
          begin  {stuck - start over}
            reset;
            lastadded:=false;
            Loadselectfigs;
          end;
        end;
        {Else} if f then  {found a tile that fits}
        with selectfigs[p] do
        begin
          dec(nbr); {it fits so decrement number avail}
          dec(sizesavail[y,x]); //:=nbr;
          if y<>x then dec(sizesavail[x,y]); //:=nbr;
         // sizesavail[y,x]:=nbr;
         // sizesavail[x,y]:=nbr;
        end;
      end;

      //else {table top is completely tiled!}
      if lastadded then
      begin
        sum:=0;
        for i:= 1 to maxx do for j:=1 to maxy do sum:=sum+figmap[j,i];
        If sum>=maxx*maxy  then done:=true
        else begin repaint; reset; lastadded:=false; LoadSelectFigs; end;

      end;
      if (bottomright.x>=maxx) and (bottomright.y>=maxy)
       then lastadded:=true;
    Until done or (tag=1);
    thisfig.figheight:=areahedt.value;
    thisfig.figwidth:=areaWEdt.value;
    Screen.cursor:=crDefault;
    repaint;
    stopbtn.enabled:=false;
    savebtn.enabled:=true;
  end;

{******************** LoadSelectFigs ***************}
Procedure TForm1.loadselectfigs;
{Build an array of available tiles and sizes}
  var
    i,j :integer;
    {Sizesavail[x,y]=count of unused tiles with dimension X x Y}
    begin
    for i:=1 to maxtileSize do
        for j:=1 to maxTileSize do
        begin
          SizesAvail[j,i]:=0;
          SpacesAvail[j,i]:=0;
        end;
    GCDval:=getGCD;
    for i := 1 to tilegrid.rowcount-1 do
    with tilegrid, Selectfigs[i] do
    begin
      Id:=cells[0,i];
      x:=strtoint(cells[1,i]) div GCDval;
      y:=strtoint(cells[2,i]) div GCDval;
      nbr:=strtoint(cells[3,i]);
      color:=hexstrtoint(cells[4,i]);
      SizesAvail[x,y]:=SizesAvail[x,y]+nbr;
      If x<>y then SizesAvail[y,x]:=SizesAvail[y,x]+nbr;
    end;
    maxfigs:=tilegrid.rowcount-1;
  end;

{************** FormPaint *************}
procedure TForm1.FormPaint(Sender: TObject);
{Draw all tiles on a table}
  var
    i,px,py:integer;
  begin
    if thisfig.rectnbr>0 then
    for i:=1 to thisfig.rectnbr do
          drawfig(thisfig.tile[i],ScreenInfo,canvas);
   if Tickbox.checked then
   with canvas, screeninfo do
   begin
     py:=origin.y+areahedt.value*scale.y div gcdval + 5;
     for i:=0 to areawedt.value do
     begin
        px:=origin.x+ i*scale.x div gcdval;
        moveto(px,py);
        lineto(px,py+10);
     end;
     px:=origin.x+areawedt.value*scale.x div gcdval + 5;
     for i:= 0 to areahedt.value do
     begin
        py:=origin.y+ i*scale.y div gcdval;
        moveto(px,py);
        lineto(px+10,py);
     end;
   end;
  end;

{*********************** SetMaxRunTime ***************}
procedure TForm1.SetMaxRunTime1Click(Sender: TObject);
{set maximum time to search for a solution}
begin
  with MaxRunForm do
  begin
    updown1.position:=maxrunsecs div 60;
    updown2.position:=maxrunsecs mod 60;
    ShowModal;
    maxrunsecs:= minedt.value*60+SecEdt.value;
  end;
end;

{**************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
var
  f:string;
begin
  maxrunsecs:=30;
  with MaxRunForm do
  begin
    updown2.position:=maxrunsecs;
    //secedt.value:=maxrunsecs;
    updown1.position:=0;
    //minedt.value:=0;
  end;
  Thisfig:=TSavedFig.Create;
  with PrintLayoutForm do
  figsperpage:=printacrossedt.value*printdownEdt.value;
  opendialog1.Initialdir:=ExtractFilePath(Application.Exename);
  f:=opendialog1.Initialdir+'\'+'sample.til';
  if fileexists(f) then Loadtiles(f);
  with Tilegrid do
  begin
      cells[0,0]:='Id';
      cells[1,0]:='Height';
      cells[2,0]:='Width';
      cells[3,0]:='Count';
      cells[4,0]:='Color';
  end;
end;


{*************** LoadTiles **************}
procedure TForm1.LoadTiles(fname:string);
{Load a table size and set of tiles from a file}
var
  f:textfile;
  i:integer;
  line:string;
  s:string;
begin
    filename:=FName;
    assignfile(f,filename);
    system.reset(f);
    tilegrid.rowcount:=1;
    while not eof(f) do
    with tilegrid do
    begin
      readln(f,line);
      s:=getword(line);
      if (length(s)=4) and (comparetext(s,'TILE')=0)
      then
      begin
        rowcount:=rowcount+1;
        for i := 0 to 4 do
        begin
          s:=getword(line);
          cells[i,rowcount-1]:=s;
        end;
        if cells[4,rowcount-1]=''
        then cells[4,rowcount-1]:='008080';{default color}
      end
      else If (length(s)=9) and (comparetext(s,'TABLESIZE')=0)
      then
      begin
        s:=getword(line);
        AreaWEdt.value:=strtoint(s);
        s:=getword(line);
        AreaHEdt.Value:=strtoint(s);
      end;
    end;
    closefile(f);
    with savefiglist do for i:= 0 to items.count-1 do items.delete(i);
    getnextbtnclick(self);
  end;

{*********************** OpenTileSet1Click **************}
procedure TForm1.OpenTileSet1Click(Sender: TObject);
{Load a user specified set of tiles}
begin
  if opendialog1.execute then  Loadtiles(opendialog1.Filename);
end;

{***************** SveTiles *************}
Procedure TForm1.Savetiles;
{Save a tablesize and set of files}
var
  f:textfile;
  i:integer;
begin
  assignfile(f,filename);
  rewrite(f);
  writeln(f,'TABLESIZE '+inttostr(AreaWEdt.value)
          +','+IntToStr(AreaHEdt.value));
  with tilegrid do
  for i:=1 to rowcount-1  do

     writeln(f,'TILE '+cells[0,i]+','+cells[1,i]+','
                      +cells[2,i]+','+cells[3,i]+','
                      +cells[4,i]);

  closefile(f);
end;

{********************* Save1Click **************}
procedure TForm1.Save1Click(Sender: TObject);
{Menu option to save a set of tiles}
begin
  If filename<>'' then savetiles;
end;

{******************* SaveAs1Click **************}
procedure TForm1.SaveAs1Click(Sender: TObject);
{Menu option to save a set of files as specified by user}
begin
  If saveDialog1.execute then
  begin
    filename:=savedialog1.filename;
    SaveTiles;
  end;
end;

{***************** StopBtnClick *************}
procedure TForm1.StopBtnClick(Sender: TObject);
{set flag to stop a search}
begin
  tag:=1;
end;


{******************* SaveBtnClick ****************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save a tiled table figure in a list for later review and printing}
var
  i,r:integer;
begin
  if not currentheld then
  begin
    inc(figcount);
    SaveFigList.items.addobject('#'+inttostr(Figcount),thisfig);
    thisfig:=TSavedFig.create;
    with savefiglist do thisfig.assign(TSavedFig(items.objects[items.count-1]));
    GCDval:=getgcd;
    If reducebox.checked then
    with thisfig, tilegrid do
    for i:=1 to rectnbr do
    begin
      r:=1;
      while (r<=rowcount-1)  {find matching tile}
           and (cells[0,r]<>tile[i].id)
      do inc(r);
      {reduce count}
      if r<=rowcount-1 then cells[3,r]:=inttostr(strtoint(cells[3,r])-1)
      else showmessage('System error: Tile with ID '+ tile[i].id +' not found ');
    end;
    currentheld:=true;
  end
  else showmessage('Current pattern has already been retained');  
end;

{********************* SaveFigListClick ****************}
procedure TForm1.SaveFigListClick(Sender: TObject);
{Select a saved tiled table configuration for display}
var
  p:integer;
begin
  with savefiglist do thisfig.assign(TSavedFig(items.objects[itemindex]));
  areahedt.Value:=thisfig.figheight;
  areaWedt.Value:=THISFIG.figwidth;
  If areaWedt.value>AreaHedt.value
    then p:=AreawEdt.value Div GCDval else p:=AreaHEdt.value div GCDval;
    screeninfo.scale.x:=panel1.width div (p * gcdval)*gcdval;
    ScreenInfo.scale.y:=panel1.height div (p *gcdval)* gcdval;
  repaint;
  end;

{********************** SaveFigListKeyPress ***************}
procedure TForm1.SaveFigListKeyPress(Sender: TObject; var Key: Char);
{Pressing enter on a saved table same as clicking}
Const
  kbEnter=#13;
begin
  If key = kbEnter then SaveFigListClick(Sender);
end;

{*************** SavedFigListKeyDown *****************}
procedure TForm1.SaveFigListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Recognize delete key press and delete a saved table from list}
var
  i:integer;
begin
  If key=vk_delete then
  With SaveFigList do
  If (itemindex<items.count) and (items.count>0) then
  begin
    i:=itemindex;
    items.delete(itemindex);
    If i<=items.count-1 then itemindex:=i
    else itemindex:=items.Count-1;
    Savefiglistclick(sender);
  end;
end;

{***************** PrintOptionsClick *************}
procedure TForm1.PrintOptions1Click(Sender: TObject);
begin
  with PrintLayoutForm do
  begin
    showmodal;
    figsperpage:=printacrossedt.value*printdownEdt.value;
  end;
end;

{******************* PrintPreview1Click ************}
procedure TForm1.PrintPreview1Click(Sender: TObject);
{Preview a page of table configurations before printing}
var
  result:integer;
  StartAt:integer;
begin
  startAt:=0;
  with previewform, previewimage  do
  repeat
    with previewimage.canvas do
    begin
      brush.color:=clwhite;
      fillrect(previewimage.clientrect);
    end;
    if startat>0 then prevpage1.enabled:=true
    else prevpage1.enabled:=false;
    If startat+figsperpage<savefiglist.items.count then nextpage1.enabled:=true
    else nextpage1.enabled:=false;
    previewimage.canvas.pen.width:=2;
    makeprintimage(startat,previewimage.canvas);
    result:=showmodal;
    case result of
      mrPrevPage:
        startat:=startat-figsperpage;
      mrNextPage:
        startat:=startat+figsperpage;
      mrprint:
        begin;
          printsavedpages1Click(sender);
          result:=mrclose;
        end;
      mrlayout:
        begin
           printoptions1click(sender);
           startat:=0;
        end;
    end;
  until result=mrclose;
end;

{******************* MakePrintImage ****************}
Procedure TForm1.MakePrintimage(startat:integer;can:TCanvas);
var
  i,j,k,a {, GCD}:integer;
  Scaleinfo:TScaleInfo;
  pagewidth,pageheight:integer;
  wfig:TSavedfig;
  offsetx,offsety,panewidth,paneheight:integer;
  begin
    pagewidth:=can.cliprect.right-can.cliprect.left;
    pageheight:=can.cliprect.bottom-can.cliprect.top;
    k:=startat-1;
    panewidth:=pagewidth div printlayoutform.printacrossedt.value;
    paneheight:=pageheight div PrintLayoutform.printdownedt.value;
    {set origin 10% in from top corner of pane}
    {set scale to fill 80% of pane}
    offsetx:= panewidth div 10;
    offsety:= paneheight div 10;
    If areaWedt.value>AreaHedt.value
    then i:=AreawEdt.value else i:=AreaHEdt.value;
    GCDval:=getGCD;
    scaleinfo.scale.x:= 8* panewidth div (10*i) * GCDval;
    scaleinfo.scale.y:= 8* paneheight div (10*i)* GCDval;
    with scaleinfo.scale do if x>y then x:=y  else y:=x;
    for j:= 1 to printLayoutform.printdownedt.value do
    begin
      scaleinfo.Origin.y:=(j-1)*paneheight +offsety;
      for i:= 1 to Printlayoutform.printacrossedt.value  do
      with scaleinfo, printer do
      begin
        inc(k);
        scaleinfo.origin.x:=(i-1)*panewidth +offsetx;
        If k>saveFigList.items.count-1 then break;
        wfig:=TSavedfig(SaveFigList.items.objects[k]);
        for a:=1 to wfig.rectnbr do
          drawfig(wfig.tile[a],ScaleInfo,can);
       end;
     end;
  end;

{******************* PrintSavedPages1Click *************}
procedure TForm1.PrintSavedPages1Click(Sender: TObject);
var
  startat:integer;
begin
  If printdialog1.Execute then
  begin
    startat:=0;
     While startat<Savefiglist.items.count-1 do
     begin
       printer.begindoc;
       printer.Canvas.pen.width:=4;
       Makeprintimage(startat,printer.canvas);
       printer.enddoc;
       inc(startat,figsperpage);
     end;
   end;
end;

procedure TForm1.CheckBoxClick(Sender: TObject);
begin
  repaint;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  with panel1 do
  begin
    width:=areahedt.left-left-10;
    height:=sizebox.top -top -10;
    panel2.left:=Left + (width-panel2.width) div 2;
    panel2.top:=top+height+10;
    rescale;
  end;  
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  areahEdt:=TIntedit.create(self,edit1);
  areahUD.associate:=areahedt;
  areawEdt:=TIntedit.create(self,edit2);
  areawUD.associate:=areawedt;
  randomize;
end;

end.

