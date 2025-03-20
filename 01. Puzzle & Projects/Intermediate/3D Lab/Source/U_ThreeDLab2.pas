// 3D Lab -- Show selected object from specified eye coordinates.
//
// Copyright (C) 1997-1998 Earl F. Glynn, All Rights Reserved. E-Mail EarlGlynn@att.net
{ Figure animation and reposting at Delphiforfun.org by Gary Darby with EFG permission}

unit U_ThreeDLab2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, ComCtrls, ShellAPI;

type
  TFormLab3D = class(TForm)
    GroupBoxEyePosition: TGroupBox;
    LabelAzimuth: TLabel;
    SpinEditAzimuth: TSpinEdit;
    LabelElevation: TLabel;
    SpinEditElevation: TSpinEdit;
    LabelDistance: TLabel;
    SpinEditDistance: TSpinEdit;
    GroupBoxScreen: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    SpinEditScreenWidthHeight: TSpinEdit;
    SpinEditScreenToCamera: TSpinEdit;
    ComboBoxFigure: TComboBox;
    Panel3DLab: TPanel;
    Image: TImage;
    LabelFigureSelect: TLabel;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    AzSpeed: TSpinEdit;
    Label4: TLabel;
    Elspeed: TSpinEdit;
    Label2: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure SpinEditBoxChange(Sender: TObject);
    procedure ComboBoxFigureChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedChange(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure AzSpeedKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Changing:  BOOLEAN;
    PROCEDURE ShowFigure;
  public
    { Public declarations }
    azup:boolean;
    Msfreq,start:Int64;
    AzLastCount, AzFrameCount, AzNextCount:int64;
    ElLastCount, ElFrameCount, ElNextCount:int64;
  end;

var
  FormLab3D: TFormLab3D;

implementation
{$R *.DFM}
  USES
    GraphicsMathLibrary,        {TMatrix}
    GraphicsPrimitivesLibrary,  {TPantoGraph}
    DrawFigures;                {DrawCube}


{*********** FormCreate **************}
procedure TFormLab3D.FormCreate(Sender: TObject);
  VAR
    Bitmap:  TBitmap;
begin
  Bitmap        := TBitmap.Create;
  Bitmap.Width  := Image.Width;
  Bitmap.Height := Image.Height;
  Image.Picture.Graphic := Bitmap;
  ComboBoxFigure.ItemIndex := 0;
  Changing := FALSE;
  azup:=true;
  QueryPerformanceFrequency(Msfreq); {Counts per second}
  MsFreq:=MSFreq div 1000;  {Counts per millisecond}
  ShowFigure
end;

{**************** ShowFigure ************}
PROCEDURE TFormLab3D.ShowFigure;
  VAR
    a         :  TMatrix;
    b         :  TMatrix;
    pantograph:  TPantoGraph;
    u         :  TVector;
BEGIN
  WITH Image DO
    Canvas.FillRect( Rect(0,0, Width, Height) );
  pantograph := TPantoGraph.Create(Image.Canvas);
  {Use whole canvas as viewport}
  pantograph.ViewPort (0.00,1.00, 0.00,1.00);
  TRY
    a := ViewTransformMatrix(
           coordSpherical,
           ToRadians(SpinEditAzimuth.Value),
           ToRadians(SpinEditElevation.Value),
           SpinEditDistance.Value,
           SpinEditScreenWidthHeight.Value,
           SpinEditScreenWidthHeight.Value,
           SpinEditScreenToCamera.Value);

    IF   ComboBoxFigure.ItemIndex = 4
    THEN
    BEGIN
      pantograph.WorldCoordinatesRange (0.00,5.00, 0.00,1.50);  {establish aspect ratio}

      // For football field, we need to translate the origin from the corner of the
      // field to the center of the field.
      u := Vector3D(-80.0, -180.0, 0.0);
      b := TranslateMatrix(u);

      // Multiply this translation matrix by the view transform matrix to get overall
      // 3D transform matrix.
      b := MultiplyMatrices(b, a);
      pantograph.SetTransform(b);
      pantograph.SetClipping(TRUE);
    END
    ELSE
    BEGIN
      {The ViewTransformMatrix is all that is needed for other objects defined
      in world coordinates.}
      pantograph.WorldCoordinatesRange (0.0, 1.0,  0.0, 1.0);
      pantograph.SetTransform(a);
    END;


    CASE ComboBoxFigure.ItemIndex OF
      0:  DrawCube (pantograph, clRed);

      1:  DrawSphere (pantograph,
            {LatitudeColor}        clBlue,
            {LongitudeColor}       clLime,
            {LatitudeCircles}       9,
            {LongitudeSemicircles} 25,
            {PointsInCircle}       40);

      2:  BEGIN
            DrawCube (pantograph, clRed);
            DrawSphere (pantograph,
                {LatitudeColor}        clBlue,
                {LongitudeColor}       clLime,
                {LatitudeCircles}       9,
                {LongitudeSemicircles} 25,
                {PointsInCircle}       40);
          END;

      3:  DrawSurface (pantograph);

      4:  DrawFootballField (pantograph, clLime, clPurple, clGray);

    END
  FINALLY
    pantograph.free
  END
END {ShowFigure};

{****************** SpinEditBoxChange **************}
procedure TFormLab3D.SpinEditBoxChange(Sender: TObject);
begin
  IF   NOT Changing
  THEN ShowFigure
end;

{************** ComboBoxFigureChange ************}
procedure TFormLab3D.ComboBoxFigureChange(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  TRY

    {Adjust "eye" coordinates so figure is as big as possible without clipping}

    CASE ComboBoxFigure.ItemIndex OF

      {Cube, Sphere, SphereInCube}
      0,1,2:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 30;  {degrees}
            SpinEditElevation.Value   := 45;  {degrees}
            SpinEditDistance.Value    := 11;  {distance units}
            SpinEditScreenWidthHeight.Value := 10;
            SpinEditScreenToCamera.Value    := 30;
            Changing := FALSE;
          END;

      {z = f(x,y) surface}
      3:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 30;  {degrees}
            SpinEditElevation.Value   := 45;  {degrees}
            SpinEditDistance.Value    := 17;  {distance units}
            SpinEditScreenWidthHeight.Value := 10;
            SpinEditScreenToCamera.Value    := 30;
            Changing := FALSE;
          END;

      {Football field}
      4:  BEGIN
            Changing := TRUE;
            SpinEditAzimuth.Value     := 90;  {degrees}
            SpinEditElevation.Value   := 30;  {degrees}
            SpinEditDistance.Value    := 225; {feet}

            {Use wide angle view}
            SpinEditScreenWidthHeight.Value := 5;
            SpinEditScreenToCamera.Value    := 2;
            Changing := FALSE;
          END;
    END;

    ShowFigure
  FINALLY
    Screen.Cursor := crDefault
  END
end;


{************** Timer1Timer ************}
procedure TFormLab3D.Timer1Timer(Sender: TObject);
var
  CurrentCount:Int64;
begin
  QueryPerformanceCounter(currentcount);
  if (currentcount>AzNextCount) and (azspeed.value>0) then
  with spineditazimuth do
  begin
    azlastcount:=Currentcount;
    AzNextCount:=AzLastCount+AzFrameCount;
    Value:=(value+1) mod 360;
  end;
  if (currentcount>ElNextCount) and (Elspeed.value>0) then
  with spineditElevation do
  begin
    Ellastcount:=Currentcount;
    ElNextCount:=ElLastCount+ElFrameCount;
    //Value:=((value+91) mod 360)  - 90 ;
    if azup then
    begin
      if value<90 then value:=(value+1)
      else
      begin
        azup:=false;
        value:=value-1;
      end;
    end
    else
    begin
      if value > -90 then value:=(value-1)
      else
      begin
        azup:=true;
        value:=value+1;
      end;
    end;
  end;
end;

{*********** SpeedChange ***********}
procedure TFormLab3D.SpeedChange(Sender: TObject);

begin
  if sender = Azspeed then
  begin
    if azspeed.value>0 then
    begin
      QueryPerformanceCounter(AzLastCount);
      AzFrameCount:=(100 div (azspeed.value))*MSFreq;
      AzNextCount:=AzLastCount+AzFrameCount;
    end;
  end
  else
  if sender = Elspeed then
  begin
    if elspeed.value>0 then
    begin
      QueryPerformanceCounter(ElLastCount);
      ElFrameCount:=(100 div (Elspeed.value))*MSFreq;
      ElNextCount:=ElLastCount+ElFrameCount;
    end;
  end;
end;

procedure TFormLab3D.StaticText2Click(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'http://www.efg2.com/', nil, nil, SW_SHOWNORMAL) ;

end;

procedure TFormLab3D.StaticText1Click(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/', nil, nil, SW_SHOWNORMAL) ;
end;

procedure TFormLab3D.AzSpeedKeyPress(Sender: TObject; var Key: Char);
begin
  SpeedChange(Sender);
end;

end.
