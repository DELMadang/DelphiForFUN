unit U_ShapePaint;
{Copyright © 2006 2017, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{An illustration of how to add an OnPaint even exit to a TGraphicControl, a
 TShape in this case.
 {
 1.  Define a new class derived from the control (e.g. TNozzle)
       TNozzle = class(TShape)

 2. Expose FOnPaint and Paint methods.
        private
           FOnpaint:TNotifyEvent;
        protected
           procedure Paint; override;

 3. Add a line to Paint method to check for assignment and call FOnPaint
         inherited paint;
         if assigned(FOnPaint) then FonPaint(self);

 4  Publish the OnPaint event preperty as
        published
        property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;

 5.  The new class could be installed as a new component based on the above
     four steps.  I prefer to reintroduce the Create constructor to pass additional
     initial property values and to use the  existing grapic control as a
     "prototype" to source the new pertinent properties
     such as  owner, parent, left, top, height, width, shape, color, etc. for
     the new control.  The prototype control may be freed after transferring its
     properies to the new control;

         constructor create(NewNozzleId:integer;  s:TShape); reintroduce;

 6. Define your own OnPaint TNotifyEvent and assign it to OnPaint as new
    cotrol is intialized.

  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, contnrs, jpeg, shellAPI, uNozzle;

type
  (*   {Code moved to a new "UNozzle" unit}
  TNozzle = class(TShape)
  private
    FOnpaint:TNotifyEvent;
  protected
    procedure Paint; override;
  public
     NozzleId:string;
     StatusOn:boolean;
     cycletime:integer; {the amount of elapsed before this nozzle's pattern would repeat}
     Constructor  create(NewNozzleNbr:integer; s:TShape);  reintroduce;
   published
     property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;
  *)

  TForm1 = class(TForm)
    StartBtn: TButton;
    StopBtn: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Image1: TImage;
    Shape10: TShape;
    Shape9: TShape;
    Shape8: TShape;
    Shape7: TShape;
    Shape6: TShape;
    Shape5: TShape;
    Shape4: TShape;
    Shape3: TShape;
    Shape1: TShape;
    StaticText1: TStaticText;
    AvgLbl: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Shape2: TShape;
    procedure FormActivate(Sender: TObject);
    procedure NozzleDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure NozzleDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure NozzleStartDrag(Sender: TObject;
                    var DragObject: TDragObject);
    procedure StartBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    Nozzle:array of tNozzle;
    Maxnozzles:integer;
    hotx,hoty:integer;
    OnColor, Offcolor:TColor;
    MaxNbrOn:integer;
    procedure Nozzleinit(n:integer; s:TShape);
    procedure NozzlePaint(Sender: TObject);
    procedure NozzleMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

(*
{*************************************}
{           TNozzle Methods           }
{*************************************}

{********** TNozzle.create ********}
Constructor  TNozzle.create(NewNozzleNbr:integer; s:TShape);
begin
  inherited create(s.owner);
  left:=s.left;
  top:=s.top;
  height:=s.height;
  width:=s.width;
  brush.assign(s.brush);
  shape:=s.shape;
  parent:=s.parent;
  dragmode:=dmautomatic;
  s.free;
  statusOn:=false;
  canvas.Font.style:=[fsbold];
  NozzleID:=inttostr(newNozzleNbr);
  tag:=newNozzleNbr;
end;

{************* TNozzle.paint **********}
procedure TNozzle.Paint;
begin
  inherited paint;
  if assigned(FOnPaint) then FonPaint(self);
end;

*)


{*************************************}
{           Form Methods              }
{*************************************}

{********** Form1.NozzleInit ********}
procedure TForm1.Nozzleinit(n:integer; s:TShape);
begin
  nozzle[n]:=TNozzle.create(n,s);
  with nozzle[n] do
  begin
    onStartDrag:=NozzleStartDrag;
    Ondragover:=NozzleDragOver;
    OnDragDrop:=NozzleDragDrop;
    OnPaint:=nozzlepaint;
    OnMouseMove:=NozzleMouseMove;
  end;
end;

{******************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialize nozzles}
begin
  Maxnozzles:=10;
  OnColor:=clBlue;
  Offcolor:=Shape1.brush.color;
  setlength (nozzle,maxnozzles+1);
  {Make "TNozzle" events for each prototype shape}
  NozzleInit(1,shape1);
  NozzleInit(2,shape2);
  NozzleInit(3,shape3);
  NozzleInit(4,shape4);
  NozzleInit(5,shape5);
  NozzleInit(6,shape6);
  NozzleInit(7,shape7);
  NozzleInit(8,shape8);
  NozzleInit(9,shape9);
  NozzleInit(10,shape10);
  
end;

  {************ NozzleDragOver **********}
  procedure TForm1.NozzleDragOver(Sender, Source: TObject; X, Y: Integer;
                                State: TDragState; var Accept: Boolean);
  {can drop Nozzles on the fountain image or on other nozzles}
  begin
    accept:=true;
  end;



  {********* NozzleStartDrag ********88}
  procedure TForm1.NozzleStartDrag(Sender: TObject;
    var DragObject: TDragObject);
  {called when nozzle dragging is started - save the
   "hotpoint", location of the cursor on the nozzle.
   This is so that when nozzle is dropped, it can be
   relocated to the same potion relative to the mouse
   cursor. }
  var
    p:TPoint;
  begin
      p:=TControl(sender).screentoclient(mouse.cursorpos);
      hotx:=p.x;  {keep track of cursor location relative to top left corner }
      hoty:=p.y;  {of the Image being dragged}
  end;

  {***************** NozzleDragDrop ***********}
  procedure TForm1.NozzleDragDrop(Sender, Source: TObject; X, Y: Integer);
  {move the nozzle at drop time}
  begin
     if source is TNozzle then
     with TNozzle(source) do
     begin
       left:=x+TNozzle(sender).left-hotx;
       top:=y+TNozzle(sender).top-hoty;
     end;
  end;

{*************** StartBtnClick ********88}
procedure TForm1.StartBtnClick(Sender: TObject);
{Start flashing the shapes, turn a randomly selected nozzle on or off once
 every second}
var
  n:integer;
  count,toton,nbron:integer;
begin
  tag:=0;
  count:=0;
  toton:=0;
  nbron:=0;
  while tag=0 do
  begin
    inc(count);
    n:=random(maxnozzles)+1;
    sleep(1000);
    with nozzle[n] do
    begin
      statusOn :=not statusON;
      if statusON then
      begin
        brush.color:=OnColor;
        inc(nbron);
      end
      else
      begin
        brush.color:=OffColor;
        dec(nbron);
      end;
      inc(toton,nbron);
      AvgLbl.caption:=format('Avg. Nbr. On: %5.2f',[toton/count]);
      application.processmessages;
    end;

  end;
end;

{************* StopBtnClick **********8}
procedure TForm1.StopBtnClick(Sender: TObject);
{Set the flag to stop the run loop}
begin
  tag:=1;
end;

{**************** formCloseQuery ********888}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   {Set flag to stop fountain}
   tag:=1;
   canclose:=true;
end;


{************* Nozzlepaint **************8}

procedure TForm1.NozzlePaint(Sender: TObject);
var
  cx,cy:integer;
begin
  With TNozzle(sender) do
  begin
    (*debug stuff
    with mouse.cursorpos do
    begin

      cx:=x;
      cy:=y;
    end;
    form1.label2.caption:=format('(x:%d, y:%d)  Nozzle: '
    + 'left:%d, top:%d',
    [mouse.cursorpos.x,mouse.cursorpos.Y, cx+left, cy+top]);
    label2.caption:=format('(x:%d, y:%d)  Nozzle:(left:%d, top:%d',
    [mouse.cursorpos.x,mouse.cursorpos.Y, left, top]);
   *)


   (* {Id display moved from here to TNozzle code}
   
      {Draw NozzleId in center of the nozzle}
    if not nozzle.showid then
    with TCustomForm(parent).Canvas do
    textout(left+ (width-textwidth(nozzleId)) div 2 ,
            top + (height-textheight(nozzleId)) div 2 ,nozzleId);
   *)
  end
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin {for debugging}
  //label1.caption:=format('x:%d, y:%d', [x,Y]);
end;

procedure TForm1.NozzleMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin {for debugging}
  //label2.caption:=format('(x:%d, y:%d)  Nozzle:(left:%d, top:%d',
  //  [mouse.cursorpos.x,mouse.cursorpos.Y, left, top]);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.



