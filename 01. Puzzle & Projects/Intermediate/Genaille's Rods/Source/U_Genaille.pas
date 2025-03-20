unit U_Genaille;
 {Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Draw and print Genaille's Rods for multiplication}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, MathCtrl, ExtCtrls, Printers, ComCtrls, Menus;

type
  {Rods object}
  TRodSet = class(TObject)
    boxwidth,boxheight,fontsize,space:integer;
    Procedure  drawbox(const n,index:integer; const P:TPoint; canvas:TCanvas);
    Procedure  DrawComplete(canvas:TCanvas);
  end;

  TForm1 = class(TForm)
    BarSizeBox: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    BarSizeLbl: TLabel;
    DrawItBtn: TButton;
    Image1: TImage;
    PrintDialog1: TPrintDialog;
    PrintBtn: TButton;
    FontSizeEdt: TEdit;
    Label5: TLabel;
    FontsizeUpDn: TUpDown;
    BarWidthUpDn: TUpDown;
    BarHeightUpDn: TUpDown;
    BarHeightEdt: TEdit;
    BarWidthEdt: TEdit;
    BkgndBtn: TButton;
    SampleBtn: TButton;
    Usagememo2: TMemo;
    UsageMemo1: TMemo;
    RodRadioGrp: TRadioGroup;
    DigitEdt: TEdit;
    DigitUpDn: TUpDown;
    IndexRadioGrp: TRadioGroup;
    IndexEdt: TEdit;
    IndexUpDn: TUpDown;
    procedure FormActivate(Sender: TObject);
    procedure DrawItBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BkgndBtnClick(Sender: TObject);
    procedure SampleBtnClick(Sender: TObject);
    procedure SampleBtnExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Rods:TRodSet;
    savetop:integer;
  end;

var
  Form1: TForm1;

implementation

uses U_GenailleInfo;

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
begin
  BarSizelbl.caption:= 'Total rod size is '
                       +InttoStr(BarwidthUpDn.position)
                       + ' X ' + Inttostr(46*BarHeightUpDn.position);
end;

type
  TriangleRec=record
    L,r1,r2:integer;
  end;


{************************* DrawBox **********************}
Procedure TRodset.drawbox(const n,index:integer; const P:TPoint; canvas:TCanvas);
{draw a box for column "n" and row "index" at point "p" on canvas}
var
  p1, p2:integer;
  p1max:integer;
  T1,T2: TriangleRec;  {describes "pointer" triangles}
  labeltop:integer; {first integer to list on left}
  barheight:integer;
  numboxleft:integer;
  i:integer;
  s:string;
Begin
  barheight:=index*boxheight;
  T2.L:=-1; {set no 2nd triangle flag}
  p1:=n*index; {compute the product}
  labeltop:=p1 mod 10; {units digit of product, the top number to display in box}
  p2:= p1 div 10; {the carry digit}
  T1.L:=p2;  {left index = 10s digit}
  t1.R1:=0;
  t1.R2:=index-1;
  p1max:=labeltop+index-1;
  If p1max>=10 then {we will have 2 triangles}
  Begin
    t1.r2:=10-labeltop-1;
    t2.r1:=t1.r2+1;
    t2.r2:=index-1;
    t2.L:=t1.L+1;
  end;
  {Now draw everything}
  with canvas do
  Begin
    pen.color:=clblack;
    brush.color:=clwhite;
    rectangle(p.x,p.y,p.x+boxwidth,p.y+boxheight*index);
    numboxleft:=p.x+3*(boxwidth) div 4; {3/4ths of the way across}
    moveto(numboxleft,p.y);
    lineto(numboxleft,p.y+barheight);
    for i:=0 to index-1 do
    Begin
      s:=inttostr(labeltop mod 10);
      textout(numboxleft+(p.x+boxwidth-numboxleft-textwidth(s)) div 2,
              p.y+i*boxheight+(boxheight-textheight(s)) div 2,
               s);
      inc(labeltop);
    end;
    brush.color:=clgray;
    polygon([point(numboxleft,p.y),
            point(p.x,p.y+t1.L*boxheight +boxheight div 2),
            point(numboxleft,p.y+(t1.r2+1)*boxheight)]);

    If t2.L>=0 then
    Begin
      polygon([point(numboxleft,p.y+t2.r1*boxheight),
               point(p.x,p.y+t2.L*boxheight +boxheight div 2),
               point(numboxleft,p.y+(t2.r2+1)*boxheight)]);
    end;
    brush.color:=clwhite;
  end;
end;

{****************** DrawComplete **********************}
Procedure  TRodSet.DrawComplete(canvas:TCanvas);
{draw a complete set of rods}
var
  digit,index:integer;
  P:TPoint;
  rect:TRect;
  i,j,bhd2,bh:integer;
  numleft:integer;
Begin
  P.x:=boxwidth div 2 + space;
  if fontsize>0 then Canvas.font.size:=fontsize
  else canvas.font.size:= - trunc((boxheight-8) * 72 / canvas.font.PixelsPerInch);
  For digit:=0 to 9 do {for all rods}
  Begin
    with p do
    Begin
      x:=x+(boxwidth+space);
      y:=boxheight div 2;
    end;
    with canvas do
    Begin
      pen.color:=clblack;
      brush.color:=clwhite;
      rectangle(classes.rect(p.x,p.y,p.x+boxwidth,p.y+boxheight));
      textout(p.x+(boxwidth-textwidth(inttostr(digit))) div 2,
              p.y++(boxheight-textheight(inttostr(digit))) div 2,
              inttostr(digit));
    end;
    p.y:=p.y+boxheight;
    for index:= 1 to 9 do    {for all digits in the rod}
    Begin
      with P do y:=y+(index-1)*boxheight;
      Drawbox(digit,index,P,canvas);
    end;
  end;
    {now draw the index bar}
    with canvas do
    Begin
      bhd2:=boxheight div 2;
      rect.top:=bhd2+boxheight;
      rect.left:=boxwidth div 2;
      rect.right:=rect.left+boxwidth;
      rectangle(rect.left , bhd2,
               rect.right, bhd2 + 46*boxheight);
      textout(rect.left+(boxwidth-textwidth('Index')) div 2,
              bhd2+(boxheight-textheight('Index'))div 2,
              'Index');
      numleft:=2*boxwidth div 3;
      for i:=1 to 9 do
      Begin
        bh:=i*boxheight;
        rect.bottom:=rect.top+bh;
        rectangle(rect);
        textout(rect.left+(boxwidth-textwidth(inttostr(i))) div 2,
                rect.top+(bh - textheight(inttostr(i))) div 2,
                inttostr(i));
        for j:= 0 to i-1 do
             textout(rect.left+numleft+(boxwidth-numleft-textwidth(inttostr(j))) div 2,
                     rect.top+j*boxheight+(boxheight-textheight(inttostr(j))) div 2,
                     inttostr(j));
        rect.top:=rect.bottom;
      end;
      moveto(rect.left+numleft, bhd2+boxheight);
      lineto(rect.left+numleft, bhd2+46*boxheight-1);
    end;
end; {Drawcomplete}


{***************** DrawIt  *******************}
procedure TForm1.DrawItBtnClick(Sender: TObject);
var
  digit,index:integer;
  P:TPoint;
  b:TBitmap;
begin
  b:=tBitmap.create;
  b.canvas.brush.color:=clWhite;
  rods.BoxHeight:=BarHeightUpDn.position;
  rods.BoxWidth:=BarWidthUpDn.position;
  rods.fontsize:=FontsizeUpDn.position;
  rods.space:=5; {5 pixels separation}
  with rods, b do
  If RodRadioGrp.Itemindex<>1 then
  Begin
    if IndexRadioGrp.Itemindex<>1 then {draw a single box}
    Begin
      digit:=strtoint(Digitedt.text);
      index:=strtoint(IndexEdt.text);
      height:=index*boxheight;
      width:=boxwidth;
      canvas.Rectangle(0,0,width,height);
      P:=point(0,0);
      Drawbox(digit,index,P,canvas);
    end
    else
    Begin
      {draw a complete rod for a single digit}
      digit:=strtoint(Digitedt.text);
      height:=46*Boxheight+2;
      width:=boxwidth;
      canvas.Rectangle(0,0,width,height);
      P:=Point(0,boxheight);
      for index:= 1 to 9 do
      Begin
        p.y:=p.y+(index-1)*boxheight;
        Drawbox(digit,index,P,canvas);
      end;
    end
  end
  else
  Begin
    if IndexRadioGrp.itemindex<>1 then
    {draw one box for all rods}
    with rods do
    begin
      index:=strtoint(IndexEdt.text);
      height:=(index+1)*(Boxheight+2);
      width:=12*boxwidth+space;
      canvas.Rectangle(0,0,width,height);
      P:=Point(-boxwidth div 2,boxheight);
      for digit:= 0 to 9 do
      Begin
        p.x:=p.x+boxwidth+space;
        Drawbox(digit,index,P,canvas);
      end;
    end
    else
    Begin
      {draw a complete set of rods for all digits}
      height:=47*boxheight;
      width:=(boxwidth+space)*12;
      canvas.Rectangle(0,0,width,height);
      rods.Drawcomplete(canvas);
    end;
  end;
  image1.height:=b.height;
  image1.width:=b.width;
  image1.picture.bitmap.assign(b);
  b.free;
end;

procedure TForm1.PrintBtnClick(Sender: TObject);
{print a set of rods}
begin
  if printdialog1.execute then
  Begin
    Printer.Begindoc;
    {leave room for 47 boxes vertically}
    rods.Boxheight:=printer.PageHeight div (47);
    {leave room for 13 rods - only 11 drawn}
    rods.boxwidth:= printer.pagewidth  div (13)-5;
    rods.fontsize:=0; {use automatic font sizing}
    rods.space:=10;
    (*
    {make the bitmap halfsize - use if not enough memory to draw full page}
    bitmap:=TBitmap.create;
    bitmap.width:=printer.pagewidth div 2;
    bitmap.height:=printer.pageheight div 2;
    rods.Boxheight:=rods.boxheight div 2;
    rods.boxwidth:= rods.boxwidth div 2;
    rods.Drawcomplete(bitmap.canvas);
    {now stretch it to full page size}
    with printer do
      canvas.stretchdraw(rect(0,0,pagewidth-1,pageheight-1), bitmap);
    *)
    rods.DrawComplete(printer.canvas);
    printer.enddoc;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Rods:=TRodSet.create;
end;

procedure TForm1.BkgndBtnClick(Sender: TObject);
begin
  infoform.show;
end;

procedure TForm1.SampleBtnClick(Sender: TObject);
{8563 X 4}
{draw partial index rod and digit rods in solution sequence}
var
  digit,index:integer;
  P:TPoint;
  rect:TRect;
  i,j,n,numhigh,bhd2,bh:integer;
  numleft:integer;
  s:string;
Begin
  s:='8563';
  numhigh:=(1+length(s))*length(s) div 2 +1;
  with rods, image1  do
  begin
    BoxHeight:=(usagememo2.top-usagememo1.top-usagememo1.height) div (numhigh+1);
    BoxWidth:=BarWidthUpDn.position;
    fontsize:=10;
    savetop:=top;
    top:=Usagememo1.top+usagememo1.height+5;
    height:=0;
    height:=(numhigh+1)*Boxheight;
    width:=(boxwidth+4)*(length(s)+2);
    canvas.brush.color:=clwhite;
    canvas.Rectangle(0,0,width,height);
    P.x:=boxwidth div 2 + 2;
    if fontsize>0 then Canvas.font.size:=fontsize
    else canvas.font.size:= - trunc((boxheight-4) * 72 / canvas.font.PixelsPerInch);
    For n:=0 to length(s)-1 do
    Begin
      digit:=strtoint(s[n+1]);
      with p do
      Begin
        x:=x+(boxwidth+2);
        y:=boxheight div 2;
      end;
      with canvas do
      Begin
        pen.color:=clblack;
        rectangle(classes.rect(p.x,p.y,p.x+boxwidth,p.y+boxheight));
        textout(p.x+(boxwidth-textwidth(inttostr(digit))) div 2,
                p.y++(boxheight-textheight(inttostr(digit))) div 2,
                inttostr(digit));
      end;
      p.y:=p.y+boxheight;
      {draw a rod}
      for index:= 1 to length(s) do
      Begin
        with P do y:=y+(index-1)*boxheight;
        Drawbox(digit,index,P,canvas);
      end;
    end;
    {now draw the index bar}
    with canvas do
    Begin
      bhd2:=boxheight div 2;
      rect.top:=bhd2+boxheight;
      rect.left:=boxwidth div 2;
      rect.right:=rect.left+boxwidth;
      rectangle(rect.left , bhd2,
               rect.right, bhd2 + numhigh*boxheight);
      textout(rect.left+(boxwidth-textwidth('Index')) div 2,
              bhd2+(boxheight-textheight('Index'))div 2,
              'Index');
      numleft:=2*boxwidth div 3;
      for i:=1 to 4 do
      Begin
        bh:=i*boxheight;
        rect.bottom:=rect.top+bh;
        rectangle(rect);
        textout(rect.left+(boxwidth-textwidth(inttostr(i))) div 2,
                rect.top+(bh - textheight(inttostr(i))) div 2,
                inttostr(i));
        for j:= 0 to i-1 do
             textout(rect.left+numleft+(boxwidth-numleft-textwidth(inttostr(j))) div 2,
                     rect.top+j*boxheight+(boxheight-textheight(inttostr(j))) div 2,
                     inttostr(j));
        rect.top:=rect.bottom;
      end;
      moveto(rect.left+numleft, bhd2+boxheight);
      lineto(rect.left+numleft, bhd2+numhigh*boxheight-1);
    end;
  end;
  UsageMemo1.visible:=true;
  UsageMemo2.visible:=true;
end;

procedure TForm1.SampleBtnExit(Sender: TObject);
begin
  UsageMemo1.visible:=false;
  UsageMemo2.visible:=false;
  image1.top:=savetop; {restore old top}
  image1.height:=0;
end;

end.
