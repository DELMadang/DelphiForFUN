unit U_RotateImage;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

{
    The main question I am trying to solve is how to rotate any given point
by a certain number of degrees around the center point.
    The application is basically in the case of drawing basic geometric objects.
Ellpises, Triangles, Rectangels, etc.  And the focal point of roation is the direct
center of the object.  This sample application draws free-hand points and bounds them
into a bounding box in order to find the center point in which to rotate.
    The problem with my solution is the fact that there ends up being a large
amount of errors into the rotation calculation that shows itself over time, especially
in the sample application.  If you draw any object, then rotate the object by 360
degrees, 10 degrees at a time, you will find the object distorted.  The proof can
be visably shown by copying the original object before rotating then drawing it again
after the rotation is complete.
    The question is how do you rotate a point around a center point without loosing
too much of the accuracy.

Joe W.

}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, ShellAPI, UIntegerRotate,
  URealRotate;

type

  TForm1 = class(TForm)
    ClearAllBtn: TBitBtn;
    RotateBtn: TBitBtn;
    PaintBox1: TPaintBox;
    Degrees: TSpinEdit;
    ClearRoateBtn: TBitBtn;
    PaintBox2: TPaintBox;
    ShowOriginalBox: TCheckBox;
    CopyLeftBtn: TBitBtn;
    CopyRightBtn: TBitBtn;
    Label1: TLabel;
    NbrTurns: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure ClearAllBtnClick(Sender: TObject);
    procedure RotateBtnClick(Sender: TObject);
    procedure ClearRoateBtnClick(Sender: TObject);
    procedure ShowOriginalBoxClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure CopyLeftBtnClick(Sender: TObject);
    procedure CopyRightBtnClick(Sender: TObject);
  public
    IntegerRotate:TIntegerRotate;
    RealRotate:TRealRotate;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses Math;

{*********** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  IntegerRotate:=TIntegerRotate.create(Paintbox1, clBlack);
  RealRotate:=TRealRotate.create(Paintbox2, clBlack);
  ShowOriginalBoxclick(sender);
end;

{************ ClearAllBtnClick *************}
procedure TForm1.ClearAllBtnClick(Sender: TObject);
begin
  IntegerRotate.Clear;
  RealRotate.clear;
end;


{************ RotateBtnClick *********}
procedure TForm1.RotateBtnClick(Sender: TObject);
var
  i:integer;
  RotationAngle: Extended;
begin
  if (IntegerRotate.count>0) or (RealRotate.count>0) then
  for i:=1 to nbrturns.value do
  begin
    RotationAngle := DegToRad(degrees.Value); {degrees} //*
    IntegerRotate.RotatePoints(rotationAngle);
    RealRotate.RotatePoints(rotationAngle);
    application.processmessages;
    sleep(200);
  end
  else showmessage('Use mouse to drag/draw a figure first');
end;

{************ ClearrotateBtnClick ********}
procedure TForm1.ClearRoateBtnClick(Sender: TObject);
begin
  IntegerRotate.refresh;
  RealRotate.refresh;
end;



{************** ShowOriginalBoxCLick ************}
procedure TForm1.ShowOriginalBoxClick(Sender: TObject);
{If ShowOriginal checkbox is checked then display original points in red
 otherw just redraw the current rotated image}
begin
  with IntegerRotate do
  begin
    ShowOriginal:=ShowOriginalBox.checked;
    if showoriginal then Draworiginal(clred)
    else DrawCurrent(clblack);
  end;
  with RealRotate do
  begin
    ShowOriginal:=ShoworiginalBox.checked;
    if showoriginal then Draworiginal(clred)
    else DrawCurrent(clblack);
  end;
end;

{****** CopyLeftBtnCLick **********}
procedure TForm1.CopyLeftBtnClick(Sender: TObject);
var
  i:integer;
  rpt:TRealPoint;
begin
  IntegerRotate.clear;
  for i:=0 to RealRotate.count-1 do
  begin
    rpt:=RealRotate[i];
    IntegerRotate.additem(round(rpt.x),round(rpt.y));
  end;
end;

{************ CopyRight ***************}
procedure TForm1.CopyRightBtnClick(Sender: TObject);
var
  i:integer;
  pt:TPoint;
begin
  RealRotate.clear;
  for i:=0 to IntegerRotate.count-1 do
  begin
    pt:=IntegerRotate[i];
    RealRotate.additem(pt.x,pt.y);
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
