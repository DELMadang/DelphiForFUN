unit UNozzle;
{Copyright © 2017, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface
 uses
     ExtCtrls, Forms,Classes, SysUtils, Graphics, Controls;

 type
  TNozzle = class(TShape)
  private
    FOnpaint:TNotifyEvent;
  protected
    procedure Paint; override;
  public
     NozzleId:string;
     StatusOn:boolean;
     cycletime:integer; {the amount of elapsed time before this nozzle's pattern would repeat}
     showID:boolean;
     Constructor  create(NewNozzleNbr:integer; s:TShape);  reintroduce;
   published
     property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

implementation

{***************** TNozzle.create *************}
Constructor  TNozzle.create(NewNozzleNbr:integer; s:TShape); begin
  inherited create(s.parent);
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
  showid:=true
end;

{************* TNozzle.paint **********}
procedure TNozzle.Paint;
begin
  inherited paint;
  if (showid) and (parent is TCustomForm)
  then with TCustomForm(parent).Canvas do {Center the id display}
  begin
    brush.Color:=self.Brush.color;
    textout(left+ (width-textwidth(nozzleId)) div 2 ,
            top + (height-textheight(nozzleId))
             div 2 ,nozzleId);
  end;

  if assigned(FOnPaint) then FonPaint(self); {custom painting by user}
end;


end.

