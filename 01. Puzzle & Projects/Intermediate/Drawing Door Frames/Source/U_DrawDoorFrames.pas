unit U_DrawDoorFrames;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, Dialogs ;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    DrawBtn: TButton;
    Memo1: TMemo;
    Image1: TImage;
    NbrFramesGrp: TRadioGroup;
    DoorHEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    DoorWEdt: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MullionHOBEdt: TEdit;
    MullionWEdt: TEdit;
    procedure StaticText1Click(Sender: TObject);
    procedure DrawBtnClick(Sender: TObject);
  public
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses Math;
{************* DrawBtnClick *****************}
procedure TForm1.DrawBtnClick(Sender: TObject);
var
  i:integer;
  offsetx,offsetY:integer;
  NbrMullions, Nbrframes: integer;
  scaleX,ScaleY,Scale:extended;
  Doorw,DoorH, FrameW, MullionW, MullionHOB:integer;
  ScDoorw,ScDoorH, ScFrameW, ScMullionW, ScMullionHOB:integer;
  OK:Boolean;
  PluralMsg:string;

  {----------  DrawFrame  --------}
  Procedure Drawframe(FLeft, FTop:integer);
  {Draw a single section of the door }
  begin
    with image1,canvas do
    begin
      {Draw top rectangle}
        rectangle(Fleft,
                  FTop,
                  FLeft+ScFrameW,
                  FTop+ScDoorH-ScMullionHOB);

      {DrawLowerrectangle}
        rectangle(Fleft,
                  FTop+ScDoorH-ScMullionHOB+scMullionW,
                  FLeft+ScFrameW,
                  FTop+ScDoorH-2*ScMullionW);
   end;
 end;

   {--------- Error --------}
   procedure Error(msg:string);
   {The easy way to give an error message and flag that an error has occurred}
   begin
     showmessage(msg);
     OK:=false;
   end;

begin
  With Image1, canvas do
  begin
    NbrFrames:=NBrFramesgrp.itemindex+1;
    nbrMullions:=NbrFrames+1;

    OK:=true; {Set "no error" flag}
    Mullionw:=strtointDef(MullionWEdt.text,0);   {Change  string to integer, 0 if error}
    if MullionW<=0 then error('Invalid Mullion Width');
    MullionHOB:=strtointDef(MullionHOBEdt.text,0);
    DoorW:=strtointDef(DoorWEdt.text,0);
    if DoorW<=0 then error('Invalid Door Width');
    DoorH:=strtointDef(DoorHEdt.text,0);
    if DoorH<=0 then error('Invalid Door Door Height');
    if (MullionHOB<=0) or (OK and (MullionHOB>(DoorH-2*mullionW)))
     then error('Invalid Mullion Height Above Base');

    If not OK then exit;  {Errors in input}

    frameW:=(Doorw-MullionW*NbrMullions) div nbrframes;  {the width of each frame}
    scalex:=0.8*width/Doorw;
    scaleY:=0.8*height/DoorH;
    scale:=min(scalex,scaley);{Scale so image is no more than 80 % of  width or height}
    Offsetx:=width div 10;  {Top left of image will be 10% in and 10% down}
    OffsetY:=height div 10;
    {Get scaled (pixel) values for the 5 scaled values needed to draw the doorframe}
    ScMullionW:=round(scale*Mullionw);
    ScMullionHOB:=round(scale*MullionHOB);
    ScFrameW:=round(scale*FrameW);
    ScDoorH:=round(scale*DoorH);
    ScDoorW:=round(scale*DoorW);
    {Draw the outside edge}
    rectangle(Offsetx,offsety,
              offsetx+ScDoorW, offsety+scDoorH);


    for i:=0 to Nbrframes-1 do
    Begin  {draw each section in a common routine, adjust top/left corner for each}
      drawframe(offsetx+ScMullionW+i*(ScMullionW+ScFramew),  {Left edge}
       offsetY+ScMullionW);  {Top edge}
    end;
    with memo1,lines do
    begin {display the values used}
      clear;
      add(format('Door dimensions: %d W x %d H with %d sections',[Doorw, DoorH, NbrFrames]));
      add(format('Mullion width is %d',[MullionW]));
      {good grammer to use singular if only one section}
      If nbrframes=1 then Pluralmsg:='' else pluralmsg:='s';
      add(format('Upper Section opening%s: %d W x %d H  ',
                                       [pluralmsg, FrameW, doorH-2*Mullionw - MullionHOB]));
      add(format('Lower Section opening%s: %d W x %d H  ',
                                       [pluralmsg, FrameW, MullionHOB-Mullionw]));

    end;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
