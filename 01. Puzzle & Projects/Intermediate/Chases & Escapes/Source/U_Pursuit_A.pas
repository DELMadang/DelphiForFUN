unit U_Pursuit_A;
{Copyright © 2018, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids, UGeometry, Spin
  ;

type

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    MoveBtn: TButton;
    Memo2: TMemo;
    Panel2: TPanel;
    DogShape: TShape;
    RabbitShape: TShape;
    RSpeed: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    DSpeed: TSpinEdit;
    ResetBtn: TButton;
    DogName: TLabel;
    RabbitName: TLabel;
    HoleName: TLabel;
    HoleShape: TShape;
    Image1: TImage;
    HungryGrp: TRadioGroup;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure ImageDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ShapeEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    rabbitcenter:TPoint;
    rabbitspeed:integer;
    dogspeed:integer;
    dogcenter:TPoint;
    dogHome, RabbitHome, HoleHome:TPoint;  {Original shape locations}
    DogNameOffset, Rabbitnameoffset, HolenameOffset:TPoint;
    Stopflag:Boolean;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************Dist ***************}
function dist(p1,p2:TPoint):integer;
begin
  result:=round(sqrt(sqr(p1.x-p2.x)+sqr(p1.y-P2.y)));
end;



{************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  doublebuffered:=true;
  With image1, canvas do
  begin {Make a green field for te chase}
    brush.color:=$0041CE31;
    rectangle(clientrect);
    sendtoback;
    pen.width:=3;
  end;
  with dogshape do
  begin
    doghome:=point(left,top);
    dognameoffset:=point(left-dogname.left, top-dogname.top);
    dogcenter:=Point(left+width div 2, top+ height div 2);
  end;
  with rabbitshape do
  begin
    pen.color:=brush.color;
    rabbithome:=point(left,top);
    RabbitNameOffset:=point(left-rabbitname.left, top-rabbitname.top);
    rabbitcenter:=Point(left+width div 2, top- height div 2);
  end;
  with holeshape do
  begin
    holehome:=point(left,top);
    HoleNameOffset:=point(left-holename.left, top-holename.top);
  end;
end;

 {************ MoveBtnClick ***************}
 procedure TForm1.MoveBtnClick(Sender: TObject);
 {Start the chase}
 var
   d:integer;
   L:TLine;
   dogcenter,rabbitcenter:TPoint;
   HoleDist:integer;  {Rabbit is safe if it gets this close to the hole}
   msg:string;
   caught:boolean;
begin
  image1.canvas.pen.width:=3;
  with dogshape do
  begin
    dogcenter.x:=left+width div 2;
    dogcenter.y:=top+height div 2;
  end;
  stopflag:=false; {In case user resets while we're running}

  repeat  {loop to move the animals until rabbit is caught or safe in hole}
    HoleDist:=rabbitshape.Height-holeshape.height {DSpeed.value-RSpeed.value};
    rabbitspeed:=Rspeed.value;
    dogspeed:=DSpeed.Value;
    rabbitshape.top:=rabbitshape.Top-rabbitspeed;

    with rabbitshape do
    begin
      rabbitcenter:=point(left+width div 2,rabbitshape.top +height div 2);
      with rabbithome do
        image1.canvas.moveto(x+width div 2,y+height);
      image1.canvas.lineto(left+width div 2,top+height);

      RabbitName.left:=left-RabbitNameOffset.x;
      Rabbitname.Top:=top-RabbitNameOffset.y;

      L:=line(rabbitcenter, dogcenter);
      extendline(L,-dogspeed);
      with dogcenter do image1.canvas.textout(x, y,'*');
      dogcenter.X:=L.p2.X;
      dogcenter.Y:=L.p2.Y;
      d:=dist(dogcenter, rabbitcenter);  {make the dog swallow the rabbit}
    end;
    with dogshape do
    begin
      left:=dogcenter.x - width div 2;
      top:=dogcenter.y - height div 2;
      dogname.Left:=left;
      dogname.Top:=top-dogname.height;
    end;
    sleep(50); {Wait 50msbetween moves}
    application.processmessages; {update everything}

    If Hungrygrp.itemindex=1 then caught:=d<=(dogspeed-rabbitspeed) div 2  {dog swallows rabit}
     else caught:=d<(dogshape.width + rabbitshape.width) div 2; {Dog  just touches rabbit, even from the side}
  until  caught
       or (rabbitshape.left + rabbitshape.Top -holeshape.left- holeshape.top< holedist)
       or stopflag;

  If caught then
  begin
    if hungrygrp.itemindex=1 then
    begin
      msg:='Dog caught the rabbit. (Burp!)';
      rabbitname.Visible:=false;
    end
    else msg:='Dog tagged the rabbit.'+#13+' (No rabbits were harmed in this chase!)';
  end
  else
  if stopflag then msg:='Chase interrupted'
  else
  begin
    rabbitshape.visible:=false;
    rabbitname.visible:= false;
    msg:='Rabbit is safely in his hole.'+#13+'(You need a faster dog!)';
  end;

  showmessage(msg);
  resetbtnclick(self);
end;

{*************** ResetBtnCLick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  Stopflag:=true;
  application.processmessages; {Interrupt the chase if it is active}

  image1.canvas.rectangle(clientrect); {clear the image}

  {Reset the dog}
  with dogshape, doghome do
  begin
    left:=x;
    top:=y;
    dogname.left:=left-dognameoffset.x;
    dogname.Top:=top-dognameoffset.y;
  end;

  {Reset the rabbit}
  rabbitshape.visible:=true;
  rabbitname.visible:=true;
  with rabbitshape, rabbithome do
  begin
    left:=x;
    top:=y;
    rabbitname.left:=left-rabbitnameoffset.x;
    rabbitname.Top:=top-rabbitnameoffset.y;
  end;
end;


{************** DragOver ***************}
procedure TForm1.ImageDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin    {Allow dragged shape to be dropped and move the shape to here}
  Accept:=true;
  //if dogdrag then

  if source = Dogshape then
  with dogshape do
   begin
     top:=y;
     left:=x;
   end;
end;

{************ ShapeEndDrag *************}
procedure TForm1.ShapeEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  if sender=dogshape then
  with dogshape do
  begin
    dogname.Left:=left;
    dogname.Top:=top-dogname.height;
   end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
