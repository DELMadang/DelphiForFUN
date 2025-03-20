unit U_bigcursor;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Simple program showing one possible way to easily implement a large cursor}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bigcursor:TBitmap;
    BCFlag:boolean;  {true when big cursor should be used}
    W,H:integer;   {width and height of the cursor image}
    formimage,workimage:TBitmap; {form image and work area image}
    oldrect,newrect:TRect; {previous and next cursor rectangles}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{**************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var p:TPoint;
begin
  {get the original form image}
  formimage:=TBitmap.create;
  formimage:=getformimage;
  {get the work area image}
  workimage:=TBitmap.create;
  workimage:=getformimage;

  {get the cursor image}
  bigcursor:=TBitmap.create;
  with bigcursor do
  begin
    loadfromfile('bigarrow2.bmp');
    transparentmode:=tmAuto;
    transparent:=true;
    w:=width; H:=height;
  end;

end;

{***************** FormMouseMove ************}
procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Need to define this as an "onMouseMove" exit for each control}
var p:TPoint;
    rr:TRect;
begin
  if bcflag then
  begin
    p:=screentoclient(mouse.cursorpos);
    {get rectangle for the new cursor postion}
    newrect:=rect(p.x,p.y,p.x+w,p.y+h);
    {erase the old cursor image in work image by copying from formimage}
    workimage.canvas.copyrect(oldrect,formimage.canvas,oldrect);
    {draw the new cursor on the workimage}
    workimage.canvas.draw(p.x,p.y,bigcursor);
    {get a rectangle that covers both old and new cursor positions}
    unionrect(rr,oldrect,newrect);
    {and copy that areA from work image tO the form canvas}
    canvas.CopyRect(rr,workimage.canvas,rr);
    oldrect:=newrect;
  end;
end;

{*************** Button1Click ***********}
procedure TForm1.Button1Click(Sender: TObject);
var p:TPoint;
begin
 {draw the original cursor image on the form canvas}
  p:=screentoclient(mouse.cursorpos);
  oldrect:=rect(p.x,p.y,p.x+w,p.y+h);
  canvas.draw(p.x,p.y,bigcursor);
  cursor:=crNone;
  bcFlag:=true;

end;

{*************** Button2Click **********}
procedure TForm1.Button2Click(Sender: TObject);
var p:TPoint;
begin
  {erase the old cursor image in work image by copying from formimage}
  canvas.copyrect(oldrect,formimage.canvas,oldrect);
  cursor:=crDefault;
  BcFlag:=false;
end;

end.
