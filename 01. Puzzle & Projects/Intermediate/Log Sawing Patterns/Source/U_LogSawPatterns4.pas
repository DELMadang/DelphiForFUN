unit U_LogSawPatterns4;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Inifiles, U_LoadDlg, DFFUtils, ComCtrls ;

type
  TFaceRec=record
    FaceNbr:integer;
    NbrBoards:integer;
    TotLogHeight,TotCutHeight:Extended;
    StartHeight, StopHeight: Extended;
    MinCutWidth, MaxCutHeight:Extended;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    BladeEdt: TLabeledEdit;
    CantwEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ThickEdt: TLabeledEdit;
    MinWidthEdt: TLabeledEdit;
    SaveBtn: TButton;
    LoadBtn: TButton;
    DepthEdt: TEdit;
    Label3: TLabel;
    MinBladeEdt: TLabeledEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    Memo3: TMemo;
    SawBtn: TButton;
    PageControl2: TPageControl;
    Face1: TTabSheet;
    Image1: TImage;
    Face2: TTabSheet;
    Face3: TTabSheet;
    Face4: TTabSheet;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Memo4: TMemo;
    TextGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SawBtnClick(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);

  public
    diameter:Extended;
    BladeThick:Extended;
    BoardThick:Extended;//extended;
    radius:extended;
    BoardNbr:integer;
    scale:extended;
    MinBoardWidth, MinDepth, MinBladeHeight:extended;
    CurrentCasename:string;
    cantwidth, cantheight:extended;
    halfcantwidth, halfcantheight:extended;
    FaceHeight:array[1..2] of extended;
    FRec:Array[1..4] of TFaceRec;
    dir:string;
    function widthFunc(depth:extended):extended; {Boad width at "depth"}
    function Num(n:extended):string; {Numberic output format (decimal tenths) or fractional 16ths}
    procedure GetInputs;
    procedure CALC(FNbr:integer; CantHeight,cantWidth:extended);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math, mathslib;

const
  xoffset:integer=30;
  yoffset:integer=30;


{************DrawLog ***********}
procedure drawlog(image:TImage; Face:integer);
{draw the outline of the log}
var
  d,n:integer;

begin
  with image, canvas  do
  begin
    font.size:=14;
    font.style:=[fsBold];
    pen.Width:=2;
    rectangle(rect(0,0,width,height));
    d:=min(width-2*xoffset,height-2*yoffset);
    ellipse(xoffset,yoffset,d+xoffset,d+yoffset);
    {Label the faces clockwise with supplied "Face" at 12 O'clock}
    n:=face-1;
    textout(xoffset-5 + d div 2, 1,inttostr((n) mod 4 + 1));
    textout(xoffset+d+3, yoffset-5 +d div 2,inttostr((n+1) mod 4 +1));
    textout(xoffset-5 + d div 2, yoffset+d-1,inttostr((n+2) mod 4 +1));
    textout(3, yoffset-5 +d div 2,inttostr((n+3) mod 4 +1));
    update;
  end;
end;

{********* FormActivate *******}
procedure TForm1.FormActivate(Sender: TObject);
begin
  with image1.Canvas.font do
  begin
    size:=14;
    style:=[fsBold];
  end;
  reformatmemo(memo1);  {tidy up the introduction text}
  reformatMemo(Memo2);
  Pagecontrol1.tabindex:=1;
  Pagecontrol2.tabindex:=0;
  dir:=extractfilepath(application.exename); {directory for "LogSaw.ini" file to save cases}
end;

{************* WidthFunc ***********}
function Tform1.widthFunc(depth:extended):extended;
{return maximum board width from this log at this depth}
var
  d:extended;
begin
  result:=0;
  if (depth>diameter) or (depth<0) then exit;
  if depth>radius then
  //begin
    d:=diameter-depth else d:=depth-boardthick-bladethick;
  Result:=2.0*(sqrt(sqr(radius)-sqr(radius-d)));
end;

{*************** Num ***********}
function TForm1.Num(N:extended):string;
{Convert N to string based on formatting option}
begin
  if textgrp.itemindex=0 then result:=format('%.1f',[N])
  else result:=format('%s', [convertFloatToFractionString(N,16,true)]);
end;

{*************** SaveBttnClick **************}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  Ini:TIniFile;
  Valuelist:TStringList;
  r:integer;
  Newcasename:string;
begin
  Ini:=TInifile.create(dir+'LogSaw.ini');
  ValueList:=TStringlist.create;
  with Ini do
  begin
    NewCaseName:=Inputbox('Save Sawlog case','Enter a case name', currentcasename);
    ReadsectionValues(Newcasename, ValueList);
    if (valuelist.count>0) and (newcasename<>currentcasename)
    then r:=messagedlg('Case exists.  Overwite it?', mtConfirmation,[mbyes,mbno],0)
    else r:=mrOK;
    if r=mrOK then
    begin
      currentCasename:=Newcasename;
       Writestring(CurrentCasename,'Diameter',DepthEdt.Text);
       Writestring(CurrentCasename,'BladeThick',BladeEdt.Text);
       Writestring(CurrentCasename,'BoardThick',ThickEdt.Text);
       Writestring(CurrentCasename,'MinBoardWidth',MinwidthEdt.Text);
       writestring(CurrentCasename,'MinBladeHeight',MinBladeEdt.text);
       Writestring(CurrentCasename,'CantWidth',CantWEdt.text);
       Writeinteger(CurrentCasename,'TextFormat',TextGrp.ItemIndex);
    end;
  end;
  Ini.free;
  Valuelist.Free;
end;

{************* LoadBtnClick ************}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  ini:TiniFile;
begin
  with loaddlg do
  begin
    Ini:=TIniFile.create(dir+'LogSaw.ini');
    ini.readsections(listbox1.items);
    ShowModal;
    if modalresult=mrOK then
    with ini do
    begin
      currentcasename:=loadcasename;
      DepthEdt.text:=Readstring(CurrentCasename,'Diameter','20');
      BladeEdt.Text:=Readstring(CurrentCasename,'BladeThick','0');
      ThickEdt.Text:=Readstring(CurrentCasename,'BoardThick','1');
      MinwidthEdt.Text:=Readstring(CurrentCasename,'MinBoardWidth','0');
      MinBladeEdt.text:=Readstring(CurrentCasename,'MinBladeHeight','1.0');
      CantWEdt.text:= ReadString(CurrentCasename,'CantWidth','12');
      TextGrp.ItemIndex:=ReadInteger(CurrentCasename,'TextFormat',1);
    end;
  end;
  Ini.free;
end;



var
  HalfSqrRoot2:extended;


{************* GetInputs ***********}
Procedure TForm1.getinputs;
var
  d:integer;
  MaxSquareCantSize:Extended;
begin
   HalfSqrRoot2:=Sqrt(2)/2.0;
   Diameter:=strtofloatDef(depthedt.text,24);
   Radius:=Diameter/2;
   CantWidth:=strtofloatDef(cantwEdt.text,12);
   Radius:=Diameter/2;
   MaxSquareCantSize:=HalfSqrRoot2*Diameter;
   if CantWidth>=Diameter then CantWidth:=MaxSquareCantSize;

   {Get Cant Height}
   CantHeight:=2*sqrt(sqr(radius)-sqr(CantWidth/2));
   HalfcantWidth:=Cantwidth/2;
   HalfCantHeight:=Cantheight/2;
   BoardThick:=strtofloatDef(ThickEdt.text,1.0);
   BladeThick:=strtofloatDef( BladeEdt.text,0.045);
   MinBoardWidth:=strtofloatDef(MinWidthEdt.text,3);
   MinBladeheight:=strtofloatdef(minbladeedt.text,1);
   with image1 do d:=min(width,height);
   scale:=(d-2*xoffset)/diameter;   {pixels per inch}
end;


{********************* Calc *************}
procedure TForm1.CALC(FNbr:integer; CantHeight,cantwidth:extended);
{The business end of the program - calculates images and cutting data for
 current Cant height and width}


        {------- ScaleX ---------}
        function scaleX(const x:extended):integer;
        {Convert X axis inch measurement to pixels for plotting}
        var t:extended;
        begin
          t:=xoffset+scale*x;
          result:=trunc(t);
        end;
         {------- ScaleY ---------}
        function scaleY(const y:extended):integer;
        {Convert Y axis inch measurement to pixels for plotting}
        var t:extended;
        begin
          t:=yoffset+scale*(diameter-y);
          result:=trunc(t);
        end;
 var
   i:integer;
   boardtop:extended;
   Image:TImage;
   //halfcantwidth, halfcantheight:extended;
 begin
   halfcantwidth:=cantwidth/2;
   halfcantheight:=cantheight/2;
   With FRec[FNbr] do
   begin
     FaceNbr:=FNbr;
     case FNBR of
       1: Image:=Image1;
       2: ImaGE:=image2;
       3: Image:=Image3;
       4: Image:=Image4;
     end;
     TotLogHeight:=Diameter;

     StartHeight:=Radius+sqrt(sqr(Radius)-sqr(minboardwidth/2))-bladethick; {to get at least 3" wide board}
     if (cantheight>0) AND (cantwidth>0) then Stopheight:= Radius+Cantheight/2
     else stopheight:=minbladeheight;
     nbrBoards:=trunc((startheight-stopheight)/(BoardThick+BladeThick));
     Startheight:=stopheight+(Nbrboards)*(BoardThick+BladeThick);

     {Display results}
     memo3.Clear;
     with memo3.lines do
     begin

       add(Format('Diameter: %s, Board Thickness: %s, Blade Thickness: %s',
                          [num(Diameter), num(BoardThick),num(BladeThick)]));
       if Fnbr mod 2 =1  {odd face, report true cant wisdth & height}
       then  add(format('Cant Width: %s, Cant Height: %s, Min Board Width %s',
                     [num(CantWidth), num(CantHeight), num(MinBoardWidth)]))
       else  {Cant Height and Width have been reversed for image generation but
              we want to report "as input" values}    
             add(format('Cant Width: %s, Cant Height: %s, Min Board Width %s',
                     [num(CantHeight), num(CantWidth), num(MinBoardWidth)]));



       add('');
       add(format('Face %d',[FNbr]));

       drawlog(image, FNbr);
       with image,Canvas do
       begin    {draw cant}
         pen.color:=clwhite;
         pen.width:=3;
         case FNbr of  {erase the diameter arc image for faces already cut}
           2:
           begin
             arc(scalex(0),scaley(0),scalex(diameter), scaley(diameter),
                 scalex(radius-halfcantwidth), scaley(radius+halfcantheight),
                 scalex(radius-halfcantwidth), scaley(radius-halfcantheight));
           end;
           3:
            begin
             arc(scalex(0),scaley(0),scalex(diameter), scaley(diameter),
                 scalex(radius-halfcantwidth), scaley(radius+halfcantheight),
                 scalex(radius+halfcantwidth), scaley(radius-halfcantheight));
            end;
            4:
             begin
             arc(scalex(0),scaley(0),scalex(diameter), scaley(diameter),
                 scalex(radius-halfcantwidth), scaley(radius+halfcantheight),
                 scalex(radius+halfcantwidth), scaley(radius+halfcantheight));
            end;
          end;

         pen.color:=clblack;
         pen.width:=2;
         rectangle(trunc(xoffset+scale*(radius-halfcantwidth)),
                   trunc(yoffset+scale*(radius-HalfCantHeight)),
                   trunc(xoffset+scale*(radius+halfcantwidth)),
                   trunc(yoffset+scale*(radius+halfcantheight)));
         update;


         {Draw boards}
         boardtop:=startheight;
         i:=0;
         while boardtop>stopheight do
         begin
           inc(i);
           rectangle(scalex(radius-widthfunc(boardtop)/2),
                     scaley(boardtop),
                     scalex(radius+widthfunc(boardtop)/2),
                     scaley(boardtop-boardthick-bladethick));
           add(format('Board %d: Height: %s, Width: %s',
                       [i, Num(boardtop), Num(widthfunc(boardtop))]));
           boardtop:=boardtop-boardthick-bladethick;
         end;
       end;
     end;
   end;
 end;

{**************** SawBtnClick **************}
procedure TForm1.SawBtnClick(Sender: TObject);
{Setup and calulate FACE1 data & image}
begin
   GetInputs;
   pagecontrol1.activepage:=TabSheet3;
   pagecontrol2.activepage:=Face1;
   Calc(1, cantheight, cantwidth);
end;


{**************** PageControl2Change **************}
procedure TForm1.PageControl2Change(Sender: TObject);
{ReCalculate image and data for currently selected "FACE" page}
begin
  Getinputs;
  with PageControl2 do

  if cantwidth>0 then
  case tabindex of
    0,2:
      Calc(tabindex+1,cantheight,cantWidth);
    1,3:
      Calc(tabindex+1, Cantwidth,CantHeight);
  end
  else if (tabindex=0) then calc(0,cantheight,cantwidth);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
