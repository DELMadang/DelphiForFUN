unit URealRotate;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Defines an object to hold a set of coordinates defining a figure to be
 displayed in a TPaintbox control}

interface
  uses windows, classes, controls, extctrls, graphics;

type
  {Floating point vesion of Delphi's TPoint record}
  TRealpoint=record
    x,y:extended;
  end;

  {Floating point version of Delphi's TRect record}
  TRealRect = record
  case Integer of    0: (Left, Top, Right, Bottom: extended);    1: (TopLeft, BottomRight: TRealPoint);  end;

  {Real pointer to TRealPoint (like Delphi's PPoint type}
  PRealPoint = ^TRealPoint;

  {TRealRotate class descendant of TPaintbox}
  TRealRotate=class(TPaintbox)
  private
    FData: array of trealpoint;     {the data to be rotated}
    FDataOrig: array of trealpoint; {the original data as entered}
    FPenDown: Boolean;  {Mouse button down flag}
    FCurRect: TRealRect;  {The current bonding rectangle for the figure}
    Originalcolor, RotateColor:TColor; {Drawing pen colors}
    FShowOriginalFlag:Boolean; {true = paint as entered  data when painting}
    FNbrPoints:integer;
    {Paint box event methods}
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    {methods used to track the bounds of the current rotated figure}
    //Function MaxX: extended;
    //Function MaxY: extended;
    //Function MinX: extended;
    //Function MinY: extended;
    {replaced by GetBoundaryrect}
    function GetBoundaryRect:TRealRect;

    {rotate a single point}
    Procedure RotatePoint( Org: PRealPoint; theta: Double; var Dest: TPoint );

    {property methods}
    function GetShowFlag:boolean;
    procedure SetShowFlag(value:boolean);
    function GetCount:integer;
    function Get(Index: Integer): TRealPoint;


    public
      constructor Create(ProtoPaintbox:TPaintBox; NewColor:TColor); reintroduce;
      {set flag to force drawing of entered data}
      property ShowOriginal:boolean read GetShowFlag write SetShowFlag;
      {user access to the count of data points}
      property count:integer read getcount;
      {user access to the data points}
      property RData[Index:integer]:TRealPoint read Get; default;
      {allow users to add data points directly}
      Procedure AddItem( const newx, newy: Integer );
      {release the data points and the list of pointers to them}
      Procedure Clear;
      {rotate the current set of data by the specified angle}
      {rotation is about the point midway between the extreme x and y values}
      procedure Rotatepoints(RotationAngle:extended);
      {dra original data points}
      procedure DrawOriginal(drawcolor:TColor);
      {draw currently rotated points}
      procedure DrawCurrent(drawcolor:TColor);
      {Clear the rotated image & repaint }
      procedure refresh;
  end;


implementation

{********** RealPoint ***********}
function realpoint(xx,yy:extended):TrealPoint;
begin
  with result do
  begin
    x:=xx;
    y:=yy;
  end;
end;

{************ Realrect **********}
function realrect(a,b,c,d:extended):TRealrect;
begin
  with result do
  begin
    left:=a;
    top:=b;
    right:=c;
    bottom:=d;
  end;
end;

{************** Create ************}
constructor TRealRotate.Create(ProtoPaintbox:TPaintBox; NewColor:TColor);
begin
  {Fill in our paintbox properties based on a passed prototype paintbox}
  inherited create(protopaintbox.owner);
  left:=protopaintbox.left;
  top:=protopaintbox.top;
  height:=protopaintbox.height;
  width:=protopaintbox.width;
  parent:=protopaintbox.parent;
  visible:=true;
  protopaintbox.visible:=false;
  {Assign the event exits we need here}
  OnPaint:=PaintBox1Paint;
  OnMouseDown:=PaintBox1MouseDown;
  OnMouseMove:=PaintBox1MouseMove;
  OnMouseUp:=PaintBox1MouseUp;

  {Assign starter lengths to hols points}
  setlength(FData,100);
  setlength(FdataOrig,100);
  FNbrPoints:=0;

  FPenDown := False;
  OriginalColor:=Newcolor;
  RotateColor:=NewColor;
  FShowOriginalFlag:=False;
  invalidate;
end;


{************* GetBoundaryRect ***********}
function TRealRotate.GetBoundaryRect:TRealRect;
{Get smalles rectangle which encloses the figure}
var
  i: Integer;
begin
  with result do
  begin
    if FNbrPoints>0
    then with fdata[0] do result:=realrect(x,y,x,y)
    else result:=realrect(0,0,0,0);
    for i := 1 to FNbrPoints-1 do
    with fdata[i] do
    begin
      if X > right then right := X
      else if X <left then left := X ;
      if Y > bottom then bottom := Y
      else if Y <top then  top := Y;
    end;
  end;
end;

(* These 4 functions replaced by "GetBoundaryRect" function}
{***************** Maxx ************}
function TRealRotate.MaxX: extended;
var
  z: Integer;
begin
  result:=0;
  for z := 0 to FData.Count-1 do
    begin
      if PRealPoint( FData[z] )^.X > result then
        result := PRealPoint( FData[z] )^.X;
    end;
end;

{***************** Maxy ************}
function TRealRotate.MaxY: extended;
var
  z: Integer;
begin
  result:=0;
  for z := 0 to FData.Count-1 do
    begin
      if PRealPoint( FData[z] )^.Y > result then
        result := PRealPoint( FData[z] )^.Y;
    end;
end;

{************* Minx *************}
function TRealRotate.MinX: extended;
var
  z: Integer;
begin
  Result := Width;
  for z := 0 to FData.Count-1 do
    begin
      if PRealPoint( FData[z] )^.X < Result then
        Result := PRealPoint( FData[z] )^.X;
    end;
end;

{***************** Miny ***********}
function TRealRotate.MinY: extended;
var
  z: Integer;
begin
  Result := Height;
  for z := 0 to FData.Count-1 do
    begin
      if PRealPoint( FData[z] )^.Y < Result then
        Result := PRealPoint( FData[z] )^.Y;
    end;
end;
*)

{************** PaintBoxPaint **************}
procedure TRealRotate.PaintBox1Paint(Sender: TObject);
var
  i: Integer;
begin
  begin
    canvas.pen.color:=Rotatecolor;
    Canvas.Rectangle( 0, 0, Width, Height  );
    if FNbrPoints > 0
    then Canvas.MoveTo( round(FData[0].X), round(FData[0].Y) );
    for i := 1 to FNbrPoints-1 do
    begin
      Canvas.LineTo( round( FData[i].X), round(FData[i].Y ));
    end;
    Canvas.Brush.Style := bsClear;
    FCurRect := GetBoundaryRect;
    with fcurrect do Canvas.Rectangle( round(left), round(top), round(right), round(bottom));
    Canvas.Brush.Style := bsSolid;
    if fshowOriginalFlag then
    begin
      canvas.pen.color:=Originalcolor;
      if FNbrPoints > 0
      then Canvas.MoveTo( round(FDataOrig[0].X), round(FDataOrig[0].Y ));
      for i := 1 to FNbrPoints-1 do
      begin
        Canvas.LineTo( round(FDataOrig[i].X), round(FDataOrig[i].Y ));
      end;
    end;
  end;
end;

{*********** PaintBoxMouseDown **********}
procedure TRealRotate.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  {Start collecting points}
begin
  FPenDown := True;
  AddItem( x, y );
end;

{*********** PaintBoxMousemnove **********}
procedure TRealRotate.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Add the current point}
begin
  if FPenDown then AddItem( x, y );
end;

{**************** PaintBoxmouseUp ************8}
procedure TRealRotate.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Stop collecting points}
begin
  FPenDown := False;
end;

{**************** AddItem **************}
procedure TRealRotate.AddItem(const newx, newy: Integer);
{add a point to both original (as captured) data and data to be rotated}
begin
  with Fdata[FNbrPoints] do
  begin
    x:=newx;
    y:=newy;
  end;
  with FdataOrig[FNbrPoints] do
  begin
    x:=newx;
    y:=newy;
  end;
  inc(FNbrPoints);
  {increase array lengths if necessary}
  If FNbrPoints>high(Fdata) then
  begin
    setlength(FData,length(fdata)+1000);
    setlength(FDataOrig,length(fdataOrig)+1000);
  end;
  invalidate;  {force repaint}
end;



{****************** Rotatepoint ***************8}
procedure TRealRotate.RotatePoint(Org: PRealPoint; theta: Double; var Dest: TPoint);
begin
  Dest.x := round( Org.x * cos(theta) + Org.y * sin(theta));
  Dest.y := round(-Org.x * sin(theta) + Org.y * cos(theta));
end;

{************** Rotatepoints *************}
Procedure TRealRotate.Rotatepoints(RotationAngle:extended);
{Rotate all points by "RotationAngle"}
var
  i:integer;
  cenx,ceny:extended;
  x,y,xrotated,yrotated:extended;
begin
  CenX := ( ( FCurRect.Right+FCurRect.Left ) / 2 );
  CenY := ( ( FCurRect.Bottom+FCurRect.Top ) /2 );
  try
    for i := 0 to FNbrPoints-1 do
      begin
        X := FData[i].X;
        Y := FData[i].Y;
        xRotated :=

          CenX + (x - CenX) * COS(RotationAngle)
          - (y - CenY) * SIN(RotationAngle);

        yRotated :=

          CenY + (x - CenX) * SIN(RotationAngle)
          + (y - CenY) * COS(RotationAngle);

        FData[i].X := xRotated;
        FData[i].Y := yRotated;
      end;
  finally
  end;
  Invalidate;  {force repaint}
end;


{******** Refresh *********}
procedure TRealRotate.refresh;
{Replace currently rotated data values with the original "as entered" data}
var
  i:integer;
begin
  for i:=0 to FNbrPoints-1 do FData[i]:=FDataOrig[i];
  invalidate;  {force repaint}
end;

{************* Clear ***********}
Procedure TRealRotate.Clear;
begin
  setlength(FData,100);
  setlength(FDataOrig,100);
  FNbrPoints:=0;
  invalidate;  {force repaint}
end;


{**************** DrawOriginal *************}
procedure TRealRotate.DrawOriginal(drawcolor:TColor);
begin
  Canvas.Pen.Color := drawcolor;
  Originalcolor:=drawcolor;
  fshoworiginalflag:=true;
  invalidate;  {force repaint}
end;

{************** DrawCurrent **************}
procedure TRealRotate.DrawCurrent(drawcolor:TColor);
begin
  RotateColor := drawcolor;
  invalidate;  {force repaint}
end;

{************** GetShowFlag ********}
function TRealRotate.GetShowFlag:boolean;
{Get method for "ShowOriginal" property}
begin
  Result:=FShowOriginalFlag;
end;

{************** SetShowflag ***************}
procedure TRealRotate.SetShowFlag(value:boolean);
{Set method for "ShowOriginal" property}
begin
  FShowOriginalFlag:=value;
end;

{************** GetCount ***********}
function TRealRotate.getcount:integer;
{Retrieve data count}
{Get method for "Count" property}
begin
  result:=FNbrPoints;
end;

{************** Get ***************}
function TRealRotate.Get(Index: Integer): TRealPoint;
{Retrieve the rotated point indexed by "Index"}
begin
  if (index>=0) and (index<FNbrPoints) then result:=Fdata[index]
  else result:=RealPoint(-1,-1);
end;

end.
