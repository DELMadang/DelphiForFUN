unit U_TestRodDisplay;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, U_DisplayRodPattern, Buttons, shellAPI;

type
  TForm1 = class(TForm)
    Image1: TImage;
    DrawRodsBtn: TButton;
    Image2: TImage;
    StockDisplayBtn: TButton;
    Label1: TLabel;
    ColorDialog1: TColorDialog;
    ScrollBox1: TScrollBox;
    ClearBtn: TButton;
    Panel1: TPanel;
    Image3: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    ChooseColorBtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure DrawRodsBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StockDisplayBtnClick(Sender: TObject);
    procedure ChooseColorBnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    {for rod only tests}
    rod1:Trod;
    rod2:Trod;

    {for pattern display testst}
    patterndisplaytop:integer;
    patternNbr:integer;
    patterns:array of TDisplayPattern;
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}

{********* Sort **********}
procedure sort(var x:TRodlengths);
{sort a rod array in ascending sequence}
var i,j,n:integer;
begin
  for i:=0 to high(x)-1 do
  for j:=i+1 to high(x) do
  if x[i]>x[j] then
  begin  {swap}
    n:=x[i];
    x[i]:=x[j];
    x[j]:=n;
  end;
end;

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
{Initialization}
begin
  {for rod test}
  image1.canvas.brush.color:=color;
  rod1:=Trod.create(image1,ClRed, color);
  rod2:=TRod.create(image2,clAqua, color);

  {for Patterndisplay test}
  patterndisplaytop:=Panel1.top;
  patternnbr:=0;
  colordialog1.color:=$D2FFFF;
  panel2.color:=colordialog1.color;
  randomize;
  label2.caption:='Allocated memory: '+inttostr(allocmemsize);
end;


{************ DrawRodsBtnClick *********}
procedure TForm1.DrawRodsBtnClick(Sender: TObject);
{Draw two rods with random divisions}
var
  D1:TRodlengths;
  i:integer;
begin
  {make rod1}
  setlength(D1,5); {for rod1, 5 lengths}
  for i:= 0 to high(d1) do d1[i]:=random(20)+1;  {segment length 1 to 20}
  sort(d1); {sort lengths in increasing sequence}
  rod1.setlengths(d1); {assign lengths to rod}
  rod1.draw;  {draw it}

  {rod2}
  setlength(D1,4); {for rod2, 4 lengths}
  for i:= 0 to high(d1) do d1[i]:=random(5)+1;
  sort(d1);
  rod2.setlengths(d1);
  rod2.openleft:=false; {make this one open on the right}
  rod2.draw;

  label2.caption:='Allocated memory: '+inttostr(allocmemsize);
end;

{********* StockDisplayBtn ***********}
procedure TForm1.StockDisplayBtnClick(Sender: TObject);
{Create a TDisplayPattern in a new position
 with a rod and other text infomation}
var
  D1:TRodlengths;
  i:integer;
begin
  setlength(patterns, length(patterns)+1); {make room for a new display}
  patterns[high(patterns)]:=TDisplayPattern.create(panel1); {create it}

  with patterns[high(patterns)] do
  begin
    top:=patternDisplayTop-scrollbox1.vertscrollbar.position; {adjust the position down to a new location}
    patterndisplaytop:=patterndisplaytop+height+5; {next top coordinate}
    setlength(D1,random(5)+2); {2 to 6 lengths}
    for i:= 0 to high(d1) do d1[i]:=random(20)+1; {lengths 1 to 20 }
    sort(d1); {show them in ascending sequence}
    rod.rodcolor:=colordialog1.color; {set rod color}
    {apply the length and text infomation}
    makepattern(d1,'Pattern '+inttostr(patternnbr),'Cut '+inttostr(random(1000))+' of these');

    scrollbox1.scrollinview(patterns[high(patterns)]); {make it visible}
    inc(patternnbr);
  end;
  label2.caption:='Allocated memory: '+inttostr(allocmemsize);
end;

{************ ChooseColorClick ********}
procedure TForm1.ChooseColorBnClick(Sender: TObject);
begin
   colordialog1.execute;
   panel2.color:=colordialog1.color;
end;

{************* ClearbtnClick *************}
procedure TForm1.ClearBtnClick(Sender: TObject);
var i:integer;
begin
  for i:= high(patterns) downto 0 do
  begin
    patterns[i].free;
    setlength(patterns, i);
  end;
  patterndisplaytop:=Panel1.top;
  patternnbr:=0;
  label2.caption:='Allocated memory: '+inttostr(allocmemsize);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
