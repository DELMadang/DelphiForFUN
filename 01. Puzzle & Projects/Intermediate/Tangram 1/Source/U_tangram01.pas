unit U_tangram01;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Prelim version 0.1 - load, drag, rotate pieces}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, U_TPiece, Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    ShowSqBtn: TButton;
    LoadPiecebtn: TButton;
    RestartBtn: TButton;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure ShowSqBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Saveas1Click(Sender: TObject);
    procedure LoadPiecebtnClick(Sender: TObject);
    procedure RestartBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tangram:TTangram;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


const
  {selectable colors for testing}
  colors:array[0..11] of tcolor=
  (clblue,clred,clyellow,clgreen,clpurple, cllime,
   clfuchsia,claqua,clteal,clNavy,clmaroon,clolive);


{******************* Form Methods *******************}


{***************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Tangram:=TTangram.createTangram(self,rect(0,0,panel1.left,clientheight-statictext1.height));
  doublebuffered:=true;
  randomize;
end;

{**************** FormClose **************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 tangram.free;
end;

{Info to make square figure for demo & testing }

  type
    trpoint=record   {rotatepoint - defines a figure}
      x,y,r,f:integer;  {r - amt to rotate, f - 1=mirror flip}
    end;

  var
  square: array[0..6] of trpoint =
       ((x:-31;y:20;r:1),  {medium triangle}
        (X:-29;y:5;R:0),   {left small triangle}
        (X:-33;y:13;r:2 ), {right small triangle}
        (x:-27;y:-7;r:4),
        (X:-19;y:0;r:2),   {big triangle}
        (X:-21;y:-3;r:7),
        (x:-35;y:-12;r:5));

{****************** ShowSqBtnClick ********************}
procedure TForm1.ShowSqBtnClick(Sender: TObject);
var
  i,j:integer;
  p:TPiece;
  n:integer;
begin
   If tangram.nbrpieces=7 then
   with tangram do
   begin
     restart;
     for i:= 0 to 6 do
     begin
       p:=TPiece.create;
       with  p do
       begin
         assign(piece[i]);
         movable:=false;
         piececolor:=clwhite;
         moveby(point(square[i].x-center.x,square[i].y-center.y));
         n:=square[i].r;
         while n<0 do inc(n,8);
         for j:=1 to n do p.rotate45;
         addpiece(p);
       end;
     end;
     invalidate;
   end
   else showmessage('Reload pieces file first');
end;

{***************** SaveAs1Click ****************}
procedure TForm1.Saveas1Click(Sender: TObject);
begin
  (*
  If savedialog1.execute then
  begin
  end;
  *)
end;

{******************** LoadPieceBtnClick ****************}
procedure TForm1.LoadPiecebtnClick(Sender: TObject);
var
  i,n:integer;
begin
  with tangram do
  begin
    loadpieces(extractfilepath(application.exename)+'tangram.pcs');
    {color them randomly}
    n:=random(high(colors));
    for i:= low(piece) to high(piece) do
    begin
      piece[i].piececolor:=colors[(n+i) mod high(colors)];
      homepiece[i].piececolor:=piece[i].piececolor;
    end;
  end;
end;

{**************** RestartBtnClck **********}
procedure TForm1.RestartBtnClick(Sender: TObject);
begin
  with tangram do
  begin
    setlength(piece,length(homepiece));
    nbrpieces:=length(piece);
    restart;
    invalidate;
  end;
end;

end.

