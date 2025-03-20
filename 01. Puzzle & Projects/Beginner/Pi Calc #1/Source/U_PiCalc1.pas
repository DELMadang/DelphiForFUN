unit U_PiCalc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ShotsEdt: TEdit;
    Label1: TLabel;
    ShootBtn: TButton;
    ResetBtn: TButton;
    PondHitsLbl: TLabel;
    RatioLbl: TLabel;
    PiLbl: TLabel;
    TotShotsLbl: TLabel;
    procedure ShootBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure showstats;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Const
  inpond:integer=0;  {Number in pond}
  totshots:integer=0; {Total number}
  radius2= 0.25; {for radius squared}

procedure TForm1.ShootBtnClick(Sender: TObject);
var
  i:integer;
  x,y:single;
begin
  if strtoint(shotsEdt.text)<high(i) then
  for i:= 1 to strtoint(ShotsEdt.text) do
  Begin
    x:=random- 0.5;  {get random numbers in the range -0.5 to + 0.5}
    y:= random - 0.5;
    if x*x+y*y < radius2 then inc(inpond);  {distance from center is < 0.5}
   {Note: no need to take square root, just compare dist squared to 0.25}
    inc(totshots);
  end
  else showmessage('Max shots exceeded');
  showstats;
end;

procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  totshots:=0;
  inpond:=0;
  Showstats;
end;

procedure tform1.showstats;
var r:single;
begin
  PondHitsLbl.caption:='Pond Hits '+inttostr(inpond);
  TotShotsLbl.caption:=' Total shots:'+inttostr(totshots);
  if totshots>0 then r:= inpond/totshots else r:=0;
  begin
    RatioLbl.caption:='Ratio of Pond hits to shots '+floattostr(r);
    PiLbl.caption:= 'Pi estimate: '+ floattostr(4*r);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
end;

end.
