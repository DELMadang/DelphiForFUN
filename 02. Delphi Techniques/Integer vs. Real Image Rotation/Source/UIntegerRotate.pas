unit UIntegerRotate;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Example of a less than optimal way to save points defining a figure to be rotated}
{See URealRotate unit for a well commented version with identical logic and
 structure that used floating point variables to store coordinates}

interface
  uses windows, classes, controls, extctrls, graphics;

type
  TIntegerRotate=class(TPaintbox)
  private
    FData: TList;
    FDataOrig: TList;
    FPenDown: Boolean;
    FCurRect: TRect;
    Originalcolor, RotateColor:TColor;
    FShowOriginalFlag:Boolean;
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    Function MaxX: LongInt;
    Function MaxY: LongInt;
    Function MinX: LongInt;
    Function MinY: LongInt;
    Procedure RotatePoint( Org: PPoint; theta: Double; var Dest: TPoint );
    function GetShowFlag:boolean;
    procedure SetShowFlag(value:boolean);
    function Get(Index: Integer): TPoint;
    function getcount:integer;
    destructor destroy;
    public
      property ShowOriginal:boolean read GetShowFlag write SetShowFlag;
      property IData[Index:integer]:TPoint read Get; default;
      property Count:integer read getcount;
      Procedure Clear;
      Procedure AddItem( const x, y: Integer );
      constructor Create(ProtoPaintbox:TPaintBox; NewColor:TColor);
      procedure Rotatepoints(RotationAngle:extended);
      procedure DrawOriginal(drawcolor:TColor);
      procedure DrawCurrent(drawcolor:TColor);
      procedure refresh;
  end;


implementation


constructor TIntegerRotate.Create(ProtoPaintbox:TPaintBox; NewColor:TColor);
begin
  inherited create(protopaintbox.owner);
  left:=protopaintbox.left;
  top:=protopaintbox.top;
  height:=protopaintbox.height;
  width:=protopaintbox.width;
  parent:=protopaintbox.parent;
  visible:=true;
  protopaintbox.visible:=false;
  OnPaint:=PaintBox1Paint;
  OnMouseDown:=PaintBox1MouseDown;
  OnMouseMove:=PaintBox1MouseMove;
  OnMouseUp:=PaintBox1MouseUp;
  FData := TList.Create;
  FDataOrig := TList.Create;
  FPenDown := False;
  OriginalColor:=Newcolor;
  RotateColor:=NewColor;
  canvas.rectangle(0,0,width, height);
  FShowOriginalFlag:=False;
  invalidate;
end;

destructor TIntegerRotate.destroy;
begin
  clear;
  FData.free;
  FDataOrig.free;
  inherited;
end;

function TIntegerRotate.MaxX: LongInt;
var
  z: LongInt;
begin
  Result := 0;
  for z := 0 to FData.Count-1 do
  begin
    if PPoint( FData[z] )^.X > Result
    then Result := PPoint( FData[z] )^.X;
  end;
end;

function TIntegerRotate.MaxY: LongInt;
var
  z: LongInt;
begin
  Result := 0;
  for z := 0 to FData.Count-1 do
  begin
    if PPoint( FData[z] )^.Y > Result
    then Result := PPoint( FData[z] )^.Y;
  end;
end;

function TIntegerRotate.MinX: LongInt;
var
  z: LongInt;
begin
  Result := Width;
  for z := 0 to FData.Count-1 do
    begin
      if PPoint( FData[z] )^.X < Result
      then Result := PPoint( FData[z] )^.X;
    end;
end;

function TIntegerRotate.MinY: LongInt;
var
  z: LongInt;
begin
  Result := Height;
  for z := 0 to FData.Count-1 do
    begin
      if PPoint( FData[z] )^.Y < Result
      then Result := PPoint( FData[z] )^.Y;
    end;
end;


procedure TIntegerRotate.PaintBox1Paint(Sender: TObject);
var
  x: LongInt;
begin

  canvas.pen.color:=Rotatecolor;
  Canvas.Rectangle( 0, 0, Width, Height  );
  if FData.Count > 0
  then Canvas.MoveTo( PPoint( FData[0] )^.X, PPoint( FData[0] )^.Y );
  for x := 1 to FData.Count-1 do
  begin
    Canvas.LineTo( PPoint( FData[x] )^.X, PPoint( FData[x] )^.Y );
  end;
  Canvas.Brush.Style := bsClear;
  FCurRect := Rect( MinX, MinY, MaxX, MaxY );
  Canvas.Rectangle( FCurRect );
  Canvas.Brush.Style := bsSolid;
  if fshowOriginalFlag then
  begin
    canvas.pen.color:=Originalcolor;
    if FDataOrig.Count > 0
    then Canvas.MoveTo( PPoint( FDataOrig[0] )^.X, PPoint( FDataOrig[0] )^.Y );
    for x := 1 to FData.Count-1 do
    begin
      Canvas.LineTo( PPoint( FDataOrig[x] )^.X, PPoint( FDataOrig[x] )^.Y );
    end;
  end;
end;

procedure TIntegerRotate.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPenDown := True;
  AddItem( x, y );
end;

procedure TIntegerRotate.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FPenDown then AddItem( x, y );
end;

procedure TIntegerRotate.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FPenDown := False;
end;

procedure TIntegerRotate.AddItem(const x, y: Integer);
var
  Ob: PPoint;
  z: LongInt;
  Match: Boolean;
begin
  Match := false;
  z := 0;
  while ( z < FData.Count ) and Not( Match ) do
    begin
      if ( PPoint( FData[z] )^.X = x ) and ( PPoint( FData[z] )^.Y = y ) then
        Match := True;
      Inc( z );
    end;
  if Not( Match ) then
    begin
      New( Ob );
      Ob^.X := x;
      Ob^.Y := y;
      FData.Add( Ob );
      New( Ob );
      Ob^.X := x;
      Ob^.Y := y;
      FDataOrig.add(ob);
    end;
  invalidate;
end;


procedure TIntegerRotate.RotatePoint(Org: PPoint; theta: Double; var Dest: TPoint);
begin
  Dest.x := round( Org.x * cos(theta) + Org.y * sin(theta));
  Dest.y := round(-Org.x * sin(theta) + Org.y * cos(theta));
end;

Procedure TIntegerRotate.Rotatepoints(RotationAngle:extended);
var
  i:integer;
  cenx,ceny:integer;
  x,y,xrotated,yrotated:integer;
begin
  CenX := FCurRect.Left + ( ( FCurRect.Right-FCurRect.Left ) div 2 );
  CenY := FCurRect.Top + ( ( FCurRect.Bottom-FCurRect.Top ) div 2 );
  try
    for i := 0 to FData.Count-1 do // actually StepCount + 1 points
      begin
        X := PPoint( FData[i] )^.X;
        Y := PPoint( FData[i] )^.Y;
        xRotated :=
          Round(
          CenX + (x - CenX) * COS(RotationAngle)
          - (y - CenY) * SIN(RotationAngle));

        yRotated :=
          Round(
          CenY + (x - CenX) * SIN(RotationAngle)
          + (y - CenY) * COS(RotationAngle));

        PPoint( FData[i] )^.X := xRotated;
        PPoint( FData[i] )^.Y := yRotated;
      end;
  finally
  end;
  Invalidate;
end;


procedure TIntegerRotate.refresh;
var
  i:integer;
begin
  for i := 0 to FData.Count-1 do
  PPoint(FData[i])^:=PPoint(FdataOrig[i])^;
  invalidate;
end;


Procedure TIntegerRotate.Clear;
var
  i: LongInt;
begin
  for i := 0 to FData.Count-1 do
    Dispose( FData[i] );
  FData.Clear;
  for i := 0 to FDataOrig.Count-1 do Dispose( FDataOrig[i] );
  FDataOrig.Clear;
  invalidate;
end;


procedure TIntegerRotate.DrawOriginal(drawcolor:TColor);
begin
  Canvas.Pen.Color := drawcolor;
  Originalcolor:=drawcolor;
  fshoworiginalflag:=true;
  invalidate;
end;

procedure TIntegerRotate.DrawCurrent(drawcolor:TColor);
begin
  RotateColor := drawcolor;
  invalidate;
end;

function TIntegerRotate.GetShowFlag:boolean;
begin
  Result:=FShowOriginalFlag;
end;

procedure TIntegerRotate.SetShowFlag(value:boolean);
begin
  FShowOriginalFlag:=value;
end;

function TIntegerRotate.Get(Index: Integer): TPoint;
begin
  if index<FData.count then result:=PPoint(Fdata[index])^
  else result:=Point(-1,-1);
end;

function TIntegerRotate.GetCount:integer;
begin
  result:=Fdata.count;
end;



end.


