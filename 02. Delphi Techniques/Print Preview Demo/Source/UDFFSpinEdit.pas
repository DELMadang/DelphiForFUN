unit UDFFSpinEdit;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This is a TSpinEdit control replacement.  It uses a TEdit as a
 "prototype" visual control and creates a TUpDnEdit control to provide
 the visual up-down arrows.

 To create the control  create passing the prototype and the intial minvalue,
 maxvalue, and value property values.
    TDFFSpinEdit.create(prototype:TEdit; mn,val,mx:integer);
}

interface

uses Windows, controls, Comctrls, Stdctrls, Sysutils;

type
  TDFFSpinEdit=class(TEdit)
   private
     FUpDnBtn:TUpDown;
     Procedure OnChanging(Sender: TObject; var AllowChange: Boolean);

     function GetMinValue:integer;
     procedure SetMinValue(Value:integer);
     function GetMaxValue:integer;
     procedure SetMaxValue(Value:integer);
     function GetValue:integer;
     procedure SetValue(Value:integer);

    published
      Property MinValue:integer  read GetMinvalue write SetMinvalue;
      Property MaxValue:integer  read GetMaxvalue write SetMaxvalue;
      Property Value:integer  read GetValue write SetValue;
    public
     constructor create(Prototype:TEdit;mn,val,mx:integer); reintroduce;
     procedure assign(p:Tedit);  reintroduce;
  end;


implementation

Procedure TDFFSpinEdit.OnChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if assigned(onChange) then onChange(self);
  allowchange:=true;
end;

function TDFFSpinEdit.GetMinValue:integer;
begin
  result:=FupDnBtn.min;
end;

procedure TDFFSpinEdit.SetMinValue(value:integer);
begin
  FUpDnBtn.min:=value;
  {Fix to force the Associated TEdit control to be updated}
  if FUpDnBtn.position<=value then text:= inttostr(value);
end;

function TDFFSpinEdit.GetMaxValue:integer;
begin
  result:=FupDnBtn.max;
end;

procedure TDFFSpinEdit.SetMaxValue(Value:integer);
begin
  FUpDnBtn.max:=value;
  {Fix to force the update of the Associated TEdit if position changes}
  if FUpDnBtn.position>=value then text:= inttostr(value);
end;

function TDFFSpinEdit.GetValue:integer;
begin
  result:=FupDnBtn.position;
end;
procedure TDFFSpinEdit.SetValue(Value:integer);
begin
  FUpDnBtn.position:=value;
end;

constructor TDFFSpinEdit.create(prototype:TEdit; mn,val,mx:integer);
begin
  inherited create(prototype.owner);
  assign(prototype);
  FUpDnBtn:=TUpDown.create(owner);
  FUpDnBtn.parent:=parent;
  FupDnBtn.Associate:=TWinControl(self);
  with FupDnBtn do
  begin
    min:=mn;
    max:=max;
    position:=val;
  end;
  FUpDnBtn.OnChanging:=OnChanging;
  OnChange:=prototype.onchange;

end;

{************ Assign ************}
procedure TDFFSpinEdit.assign(p:Tedit);
{Only field that I currently want or need are transferred
 from the TEdit Prototype.  Many more propertoes could be
 transferred }
begin
  parent:=p.parent;
  left:=p.left;
  top:=p.top;
  width:=p.width;
  height:=p.height;
  text:=p.text;
  font.assign(p.font);
  OnClick:=p.OnClick;
end;

(*
procedure TDFFSpinEdit.fixit;
begin
  with FUpDnBtn do
  SendMessage(Handle, UDM_SETPos, 0, MakeLong(position, 0));
end;
*)

end.
