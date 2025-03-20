unit U_BBall1;
  {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Comctrls, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    DropBtn: TButton;
    Shape1: TShape;
    ResetBtn: TButton;
    TimescaleBar: TTrackBar;
    Label2: TLabel;
    Label1: TLabel;
    CEBar: TTrackBar;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure DropBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    inittop:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
begin
   panel1.doublebuffered:=true; {for smoother animation}
   inittop:=shape1.top; {save first ball position so we can reset it after a drop}
end;

procedure TForm1.DropBtnClick(Sender: TObject);
var
  v:real;     {current velocity in pixles}
  nextV:real; {look ahead to next velocity}
  c:real;     {Coefficient of elasticity}
  stopped:boolean;  {stop flag}
  lastTop:integer;
Begin
  resetbtnclick(sender);
  V:=0;
  stopped:=false;
  tag:=0;
  lasttop:=0;
  with shape1 do {so all uses of 'top' and 'height' in this loop mean refer to shape1}
  repeat
    {increment velocity 1 pixel per loop, i.e. gravity = 1 pixel per loop per loop}
    nextv:=v+1.0;
    //*{debugging}listbox1.items.add(format('top %3d, v %5.1f, nextv %5.1f',[top,v,nextv]));
    If v>=0 then {moving down}
    Begin
      if (top+ round(nextv)>=panel1.height-height)
      then {next move would go below the floor}
      Begin
        LastTop:=top;
        top:=panel1.height-height; {so just set it on the floor}
        c:=sqrt(CEBar.position / CEBar.max); {set coefficient of elasticity}
        nextv:=-(nextv)*c; {lose a little energy and start it back up}
        if nextv>-3 then stopped:=true; {If we won't move at least 3 pixels, then stop}
      end
      else top:=top+round(nextv);
    end
    else {moving up}
    Begin
      If top+round(nextv)<0
      then {shouldn't happen, but if next move goes through the ceiling} top:=0
      else
      if lasttop>0 then {first move up, use last move down position}
      begin
        top:=lasttop;
        lasttop:=0;
        nextv:=nextv-1;
      end
      else
      begin
         top:=top+round(nextv);
      end;
    end;
    v:=nextv;
    application.processmessages; {Let the screen update, etc.}
    sleep(timescalebar.max-timescalebar.position); {Wait a few milliseconds}
    if self.tag>0 then stopped:=true;
  until stopped;
end;

procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  tag:=1;

  shape1.top:=inittop;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

end.
