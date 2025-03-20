unit U_BinaryCards2;
{Copyright © 2006, 2007 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, jpeg, printers, ImgList, ShellAPI;

type

  {A class to hold the dragged objects}
  TMyDragObject = class(TDragControlObject)
  protected
    function GetDragImages: TDragImageList; override;
  end;

  TPanelrec=record  {A card (TPanel) and its original location}
    p:TPanel;
    origin:TPoint; {original card location used when cards are reset}
  end;

  TForm1 = class(TForm)
    Panel0: TPanel;
    OneBits: TStringGrid;
    Memo1: TMemo;
    Image1: TImage;
    Image2: TImage;
    Panel1: TPanel;
    Image3: TImage;
    Image4: TImage;
    TwoBits: TStringGrid;
    Memo2: TMemo;
    Panel2: TPanel;
    Image5: TImage;
    Image6: TImage;
    ThreeBits: TStringGrid;
    Memo4: TMemo;
    Panel3: TPanel;
    Image7: TImage;
    Image8: TImage;
    FourBits: TStringGrid;
    Memo7: TMemo;
    Basepanel: TPanel;
    TotGrid: TStringGrid;
    Memo9: TMemo;
    PrintBtn: TButton;
    Invertedmage1: TImage;
    InvertedImage2: TImage;
    InvertedImage3: TImage;
    InvertedImage4: TImage;
    WorkMemo: TMemo;
    Memo3: TMemo;
    StaticText1: TStaticText;
    DragImageList: TImageList;
    ResetBtn: TButton;
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Image1Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure StartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure FormCreate(Sender: TObject);
    procedure BasepanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure BasepanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure StaticText1Click(Sender: TObject);
  public
    Panel:array[1..4] of TPanelRec;
    HoleGrid:array[1..4] of TStringgrid;
    TopMemo:array[1..4] of TMemo;
    BottomImage:array[1..4] of TImage;
    Inverted:array[1..4] of boolean;
    InvertedFont:TFont;
    dragimage:TImage;
    dragpanel:TMyDragObject;
    hotx,hoty:integer; {"hotspot" for dragging operations}
    procedure makehole(gridnbr,x,y:integer); {mark a grid cell as a hole}
    procedure rebuildGrid(gridnbr:integer);
    Procedure DrawInvertedMessage(panelnbr, messageindex:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses U_InvertedText;

var
  {Initial top and bottom messages}
  ismsg:array[0..1] of string =
     ('YES! This side up if your number is in the set         ',
      'NO! This side up if your number is NOT in the set    '
     );

  {The numbers that appear on each card}
  numbermsg:array[1..4] of string =
      ('{1, 3, 5, 7, 9, 11, 13, 15}',
       '{2, 3, 6, 7, 10, 11, 14, 15}',
       '{4, 5, 6, 7, 12, 13, 14, 15}',
       '{8, 9, 10, 11, 12, 13, 14, 15}'
       );

  CardColor:Integer=$00DDFFFF; {pale tan}
  HoleColor:Integer=$00BFFFBF; {light green}

{************* MakeBinaryString **********}
function MakeBinaryString(const n:integer; MinLength:integer):string;
{Convert an integer to a binary string of at least length "MinLength"}
var i:integer;
begin
  result:='';
  i:=n;
  while i>0 do
  begin
    if i mod 2=0 then result:='0'+result
    else result:='1'+result;
    i:=i div 2;
  end;
  if length(result)<Minlength
  then result:=stringofchar('0',Minlength-length(result))+result;
end;

{************ GetDragImages **********}
function TMyDragObject.GetDragImages: TDragImageList;
{called at drag start time to get the image to be dragged}
begin
  Result := form1.DragImagelist;
end;

{************** FormCreate *************8}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
{Initialization stuff}
begin
  {Must add csDisplayDragImage to the ControlStyle of each control that is to
   display drag images}
  ControlStyle := ControlStyle + [csDisplayDragImage];

  {Fix up controlStyle property for all controls and child controls of scrollboxes
   (the shapes for Scrollbox1 and the panels on Scrollbox2)}
  for i:=0 to controlcount-1 do {for all controls on the form}
  with controls[i] do
  begin
    controlstyle:=ControlStyle + [csDisplayDragImage];
    if controls[i] is TPanel then
    with controls[i]as TPanel do
    begin
      for j:=0 to controlcount-1 do
      with TControl(controls[j]) do
        controlstyle:=ControlStyle + [csDisplayDragImage];
    end;
  end;

  {Put the 4 card panels into an array}
  Panel[1].p := Panel0;
  Panel[2].p := Panel1;
  Panel[3].p := Panel2;
  panel[4].p := Panel3;

  for i:=1 to 4 do {set up each panel}
  with panel[i].p do
  begin
    tag:=i;
    OnStartDrag:=StartDrag; {Panel can start drag}
    dragmode:=dmautomatic;
    {save original location so we can reset it after draging}
    panel[i].origin.x:=left;
    panel[i].origin.y:=top;
    for j:= 0 to controlcount-1 do {for all control in the panel}
    begin
      if controls[j] is TWinControl
      then with controls[j] as TWincontrol do
      begin
        OnStartDrag:=StartDrag;
        dragmode:=dmautomatic;
        OnClick:=Image1click;
      end;
      if controls[j] is TStringgrid
      then with TStringgrid(controls[j]) do
      begin
        holeGrid[i]:=TStringgrid(panel[i].p.controls[j]);
        holegrid[i].tag:=i;
      end
      else if controls[j] is TMemo then
      with TMemo(controls[j]) do
      begin
        font.name:='Arial';
        if top<panel[i].p.height div 2
        then
        begin
          topmemo[i]:= TMemo(panel[i].p.controls[j]);
          lines.add('Card #'+inttostr(i)+': '+ismsg[0]+numbermsg[i]);
          selstart:=0; sellength:=1;
        end;
      end
      else
      if (controls[j] is TImage) then
      with TImage(controls[j]) do
      begin
        dragmode:=dmmanual;
        if (copy(name,1,6)='Invert') then
        with canvas do
        begin
          bottomImage[i]:=TImage(panel[i].p.controls[j]);
          font.name:='Arial';
          font.size:=10;
          font.style:=[fsbold];
          brush.color:=cardcolor;
          
        end;
      end;
    end;
  end;

  for j :=1 to 4 do  {initialize grids}
  begin
    inverted[j]:=false;
    DrawinvertedMessage(j,1);
    RebuildGrid(j);
  end;
  {fill in numbers on totals grid}
  for i:=0 to 9 do for j:=0 to 3 do totgrid.cells[i,j]:=' ';
  for i:=0 to 15 do
    totgrid.cells[i mod 8 + 1, i div 8 +2]:=inttostr(i);
end; {formcreate}

{************* RebuildGrid *********}
procedure TForm1.rebuildGrid(gridnbr:integer);
var
  i,j,c,r:integer;
  s:string;
begin
  {reset holes}
  for i:= 0 to 9 do
  for j:=0 to 3 do
  begin
    holegrid[gridnbr].cells[i,j]:=' ';
  end;
  {assign holes}
  for i:= 0 to 15 do
  begin
    s:=makebinarystring(i,4);
    if s[5-gridnbr]='1'then
    begin
      c:=(i mod 8) + 1;
      r:=(i div 8 ) mod 2;
      makehole(gridnbr,c, r + 2); {r+2 = "1" bits row}
      makehole(gridnbr,c,r); {r = "0" bits row}
    end;
  end;
end;

{*********** MakeHole *************}
procedure TForm1.makehole(gridnbr,x,y:integer);
{mark holes with an *}
begin
  with holegrid[gridnbr] do  cells[x,y]:='*';
end;



{************* GridDrawCell ****}
procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw card cells with hole locations colored to match form color,
 simulating a hole.}

      function isHole(fcol,frow:integer):boolean;
      begin
        with TStringgrid(sender) do
        result:= ((not inverted[tag]) and (trim(cells[fcol,frow])<>''))
                or (inverted[tag] and (trim(cells[9-fcol,3-frow])<>'') )
      end;

begin
  With TStringgrid(sender),canvas do
  begin
    {
    if ((not inverted[tag]) and (cells[acol,arow]<>' '))
    or (inverted[tag] and (cells[9-acol,3-arow]<>' ') )
    }
    IF IsHole(acol,arow) then
    begin
      {if this is a hole and card has not been dragged to the totals stack,
       make the cell the form color}
      if (parent.left<>Basepanel.left)  then
      brush.color:=holecolor {this is a hole in it's home position}
      else
      begin
       {else if it is a hole through all cards then color it Basepanel color}
       if cells[acol,arow][1] in['0'..'9','/'] then brush.color:=Basepanel.color
       else brush.color:=CardColor;
      end;
    end
    else brush.color:=CardColor;
    if brush.color=holecolor then pen.color:=holecolor
    else pen.color:=clblack;
    with rect do fillrect(classes.rect(left,top,right,bottom));
    if cells[acol,arow]='' then cells[acol,arow]:=' ';


    {If this is a "hole" then draw an edge for any bordering cell which is not
     a hole}
    if brush.color=holecolor then
    with rect do
    begin
      pen.color:=clblack;
      {check left side}
      if (acol=0) or ((acol>0) and (not ishole(acol-1,arow))) then
      begin
        moveto(left, top);
        lineto(left, bottom);
      end;
      {check top}
      if (arow=0) or ((arow>0) and (not ishole (acol,arow-1))) then
      begin
        moveto(left, top);
        lineto(right, top);
      end;
      {check right side}
      if (acol=colcount-1) or ((acol<colcount-1) and (not ishole(acol+1,arow))) then
      begin
        moveto(right-1, top);
        lineto(right-1, bottom);
      end;
      {check bottom}
      if (arow=rowcount-1) or ((arow<rowcount-1) and (not IsHole(acol,arow+1))) then
      begin
        moveto(left, bottom-1);
        lineto(right,bottom-1);
      end;
    end;

    If (brush.color= Basepanel.color) and (not (cells[acol,arow][1] in ['*',' ','/']) )
    then
    begin
      font.Size:=14;
      font.style:=[fsbold];
      textout(rect.left+2,rect.top+2,cells[acol,arow]);
    end;
  end;
end;

{************ DrawInvertedMessage ***********}
Procedure TForm1.DrawInvertedMessage(panelnbr, messageindex:integer);
{Draw bottom message inverted to simulate card that can be rotated to
 move this message to the top}
var
  i:integer;
begin
  with bottomImage[panelnbr], workmemo do
  begin
    lines.clear;
    lines.add('Card # '+inttostr(panelnbr)+' '+ismsg[(messageindex) mod 2]+ numbermsg[panelnbr]);

    with Bottomimage[panelnbr], canvas do
    begin
      InitInvertedtext(canvas,cardcolor,width,height);
      for i:= 0 to workmemo.lines.count-1
      do DrawinvertedText(canvas,width,height,i+1, workmemo.lines[i]);
    end;
  end;
end;


{********* Image1Click ************}
procedure TForm1.Image1Click(Sender: TObject);
{arrow clicked, invert the card equivalent to moving grid "holes" to their
 position as if rotated.  Also exchange top and inverted bottom labels}
var
  tag1:integer;
  index:integer;
begin
  canceldrag;
  tag1:=TControl(sender).tag;
  if tag1=0 then
  showmessage('Tag =0 on Image1click');
  inverted[tag1]:=not inverted[tag1];
  {exchange memo labels}
  If inverted[tag1] then index:=1 else index:= 0;
  with topmemo[tag1] do
  begin
    topmemo[tag1].lines.clear;
    lines.add('Card # '+inttostr(tag1)+' '+ismsg[index]+ numbermsg[tag1]);
    selstart:=0;
    sellength:=1;
  end;
  DrawInvertedmessage(tag1,index+1);
  {rebuild grid holes}
  Rebuildgrid(tag1);
end;

{***************** PrintbtnClick ************}
procedure TForm1.PrintBtnClick(Sender: TObject);
{Print the form}
begin
  resetBtnclick(sender);
  with printer do
  begin
    orientation:=poLandscape;
  end;
  print;
end;

{************* StartDrag **********}
procedure TForm1.StartDrag(Sender: TObject;
  var DragObject: TDragObject);
{User want to drag a panel (i.e. a card), we'll build a drag image of the card
 to be dragged}
var
  b:TBitmap;
  pt:TPoint;
  tag1:integer;
  p:TPanel;
begin
  tag1:= TControl(sender).tag;
  p:=TPanel(panel[tag1].p);
  rebuildgrid(tag1);
  with p do
  begin
    dragImageList.clear;
    dragimagelist.height:=height;
    dragimagelist.width:=width;
    b:=tBitmap.create;
    b.width:=width;
    b.height:=height;
    b.canvas.copyrect(rect(0,0,b.width,b.height),self.canvas, p.boundsrect);
    if DragImageList.Add(b,nil)<0 then showmessage('Dragmage add failed');
    pt:=screentoclient(mouse.cursorpos);
    hotx:=pt.x;  {keep track of cursor location relative to top left corner }
    hoty:=pt.y;  {of the shape being dragged}

    dragimagelist.setdragimage(0,hotx,hoty);   {set the drag image}
    DragObject := TMyDragObject.Create(p); {Create the drag object}

  end;
end;



{************** BasepanelDragOver ************}
procedure TForm1.BasepanelDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Called when a card is dragged over the Base panel or one of its controls}
var
  tag1:integer;
begin
  accept:=false;
  if (sender = Basepanel) or  (sender = Totgrid) or  (sender = Memo9)
  then accept:=true
  else if  (TCOntrol(sender).tag>0) then
  begin
    tag1:= TControl(sender).tag;
    if panel[tag1].p.left=Basepanel.left then accept:=true;
  end;
end;

{************  BasepanelDragDrop **********}
procedure TForm1.BasepanelDragDrop(Sender, Source: TObject; X, Y: Integer);
{Dropping a shape on a panel}
var
  card:TPanel; {points to panel being dropped, just for ease of reference}
  stackholes:array[0..9,0..3] of boolean;
  i,j,k:integer;
begin
  for i:=0 to 9 do
  for j:=0 to 3 do stackholes[i,j]:=true;
  if source is tMyDragObject then
  with source as TMyDragObject do
  begin
    card:=TPanel(control);
    with card do
    begin
      left:=Basepanel.left;
      top:=Basepanel.top;
      bringtofront;
    end;
    for i:=1 to 4 do
    with panel[i].p do
    if left=Basepanel.left then
    begin  {this panel is in the stack - determine where the holes are}
      if inverted[i] then rebuildgrid(i); {to undo any changes made by previous drop processing}
      for j:=0 to 9 do
      for k:=0 to 3 do
      begin
        {if all panels in the stack have a hole in a cell position then
         the number on the base grid must show through.  We'll do this
         by incrementing every spot that is not a hole, then if that cell
         is still =0 when we're done, it must be a hole. }
        if ((not inverted[i]) and (holegrid[i].cells[j,k]<>' '))
          or (inverted[i] and (holegrid[i].cells[9-j,3-k]<>' '))
        then {it is a hole, leave "stackholes" in its current state}
        else stackholes[j,k]:=false;; {else not a hole, so mark it as false}
      end;
    end;

    for j:=0 to 9 do
    for k:=0 to 3 do
      {if it is a hole, put the base grid cell there}
      if stackholes[j,k] then
      begin
        holegrid[card.tag].cells[j,k]:=totgrid.cells[j,k];
        if holegrid[card.tag].cells[j,k]=' ' then holegrid[card.tag].cells[j,k]:='/';
      end;
  end;
end;

{********** ResetbtnClick *********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  for i:= 1 to 4 do
  begin
    {move it back where it belongs}
    with panel[i] do
    begin
      p.left:=origin.x;
      p.top:=origin.y;
    end;
    {If it's inverted, then turn it back over}
    if inverted[i] then image1click(panel[i].p)
    else rebuildgrid(i); {otherwise just rebuild numbers}
  end;
end;

{********** FormDragOver ***********}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{We cab always drop a card on the form}
begin
  accept:=true;
end;

{*********** FormDragDrop ***********}
procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
{Card dropped on the form, return it to its original location}
var
  tag1:integer;
begin

  with TMyDragObject(source)do
  begin
    tag1:=TPanel(control).tag;
    TPanel(control).left:=panel[tag1].origin.x;
    TPanel(control).top:=panel[tag1].origin.y;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
