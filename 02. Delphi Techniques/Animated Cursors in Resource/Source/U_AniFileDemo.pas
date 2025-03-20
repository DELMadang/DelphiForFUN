unit U_AniFileDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,FileCtrl;

type
  TForm1 = class(TForm)
    GlobeBtn: TButton;
    CoffeeBtn: TButton;
    DefaultBtn: TButton;
    procedure GlobeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CoffeeBtnClick(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const AniGlobe = 1;
      AniCoffee= 2;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Screen.Cursors[AniGlobe] := LoadCursorFromFile('GLOBE.ANI');
  Screen.Cursors[AniCoffee] := LoadCursorFromFile('COFFEE.ANI');
end;

procedure TForm1.GlobeBtnClick(Sender: TObject);
begin
  Cursor := AniGlobe;
end;


procedure TForm1.CoffeeBtnClick(Sender: TObject);
begin
  Cursor := AniCoffee;
end;

procedure TForm1.DefaultBtnClick(Sender: TObject);
begin
  Cursor:=crDefault;
end;

end.
