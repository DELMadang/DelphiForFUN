unit U_Rally2;
  {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{Rally is a marble track game,m one of 1000 puzzles and games in the book
 "PlayThinks" by Ian Moscovich and published by Workman Publishing.

 The board consists of two tracks, horizontal and vertical each with 18 marbles.
 There are however 4 marbles in common between the two tracks at the intersection
 points making 32 marbles in total. The objective is to replace the 12 red
 marbles initilally forming the inner square with the 12 blue marbles which start
 the game at the ends of the loops.}

 {The key to understanding the following code is the system used to number the
  marble positions.  Each track (Hslots and Vslots), numbers the slots from 1 to
  18 in a clockwise direction. For the vertical track, numbering starts at top
  left yellow  marble.  For the horizontal track,  numbering starts at the top
  right yellow marble.  Under this system the shared marbles are (V6,H9),
  (V9,H15), (V15, H18) and (V18,H6).  Procedure SynchFrom uses this symmetric
  relationship to resynchronize marble colors after a move.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, ComCtrls, ShellAPI, dffutils;

type


  tSlot=record {describes a marble position}
    {base position plus two intermediate positions clockwise used to animate moves}
    positions:array[1..3] of trect;
    currRect:TRect; {current marble position, used for erasing during moves}
    color:TColor; {color of the marble currently occupying this slot}
   end;

  TSlots=array[0..18] of TSlot;  {Set of slot records describing a track}

  TForm1 = class(TForm)
    Image1: TImage;
    ResetBtn: TButton;
    MoveBox: TGroupBox;
    Label1: TLabel;
    MoveCount: TSpinEdit;
    HCWBtn: TButton;
    HCCWBtn: TButton;
    VCWBtn: TButton;
    VCCWBtn: TButton;
    memo1: TMemo;
    Label2: TLabel;
    MoveCountLbl: TLabel;
    ShowmeBtn: TButton;
    Memo2: TMemo;
    Searchbox: TRadioGroup;
    StaticText1: TStaticText;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure HCWBtnClick(Sender: TObject);
    procedure VCWBtnClick(Sender: TObject);
    procedure HCCWBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure VCCWBtnClick(Sender: TObject);
    procedure ShowmeBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    cx,cy,r,cr:integer;
    bgc:TColor; {background color for board}
    trkcolor:TColor; {Track color}
    vslots:TSlots;
    hslots:TSlots;
    nbrmoves:integer;
    procedure setup;
    procedure redraw;
    procedure draw(const Slots:TSlots; n:integer);
    procedure synchFrom(var Slots1, Slots2:TSlots);
    procedure move(var Slots:TSlots; clockwise:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var sleeptime:integer=50; {speed of move, 50 milliseconds allows move to be observed}

{**************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
{initialization}
begin
  setup; {Set colors}
  redraw;{Set track and marble positions}
  doublebuffered:=true;
end;


{************* FormResize *************}
Procedure TForm1.FormResize(Sender: TObject);
{when form size changes}
begin
  redraw;
end;

{************ Redraw **************}
procedure TForm1.redraw;
{size may have changed so recalc size fields and redraw marbles}
var   locs:array[1..5, 1..3] of TRect;

        {*****************************}
        {local routines used by ReDraw}
        {*****************************}

        {**** getpoint ****}
        function getpoint(cx,cy:integer;angle,d:extended):TPoint;
        {polar to cartesian conversion}
        begin
          result.x:=round(cx+d*cos(angle));
          result.y:=round(cy+d*sin(angle));
        end;

        {**** drawloop ****}
        procedure drawloop(startangle:extended; x,y:integer);
        {define one track loop, track and 5 marbles}
        var
          i,dx,dy:integer;
          p:TPoint;
        begin
          with image1, canvas do
          begin
            pen.width:=1;
            for i:= 0 to 4 do
            begin
              if (i=0) or (i=4) then brush.color:=clyellow
              else brush.color:=clblue;
              p:=getpoint(x,y,startangle+i*pi/4,3*r);
              locs[i+1,1]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
              p:=getpoint(x,y,startangle+i*pi/4+pi/12,3*r);
              locs[i+1,2]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
              p:=getpoint(x,y,startangle+i*pi/4+pi/6,3*r);
              locs[i+1,3]:=rect(p.x-cr,p.y-cr,p.x+cr,p.y+cr);
            end;
            pen.width:=2;
            dx:=round(r*cos(startangle));
            dy:=round(r*sin(startangle));
            {draw inner arc}
            arc(x+2*r,y+2*r,x-2*r,y-2*r, x-2*dx,y-2*dy, x+2*dx,y+2*dy);
            {extend inner arc by 1 radius width toward center and fill  it}
            brush.color:=clblack;
            fillrect(rect(x-2*dx,y-2*dy,x+2*dx+dy,y+2*dy-dx));
            {fill the inner arc}
            floodfill(round(x-2*sin(startangle)),round(y+2*cos(startangle)),
                        bgc,fssurface);

            {draw middle arc}
            arc(x+4*r,y+4*r,x-4*r,y-4*r, x-4*dx,y-4*dy, x+4*dx,y+4*dy);
            {extend ends of middle arc by 1 radius toward center}
            moveto(x-4*dx,y-4*dy); lineto(x-4*dx+dy,y-4*dy-dx);
            moveto(x+4*dx,y+4*dy); lineto(x+4*dx+dy,y+4*dy-dx);

            {draw outer arc}
            arc(x+5*r,y+5*r,x-5*r,y-5*r, x-5*dx,y-5*dy, x+5*dx,y+5*dy);
          end;
        end; {drawloop}

        procedure interpolate(var Slots:TSlots);
        {assign intermediate move postions to animate marbles in center of track
          (marble numbers 5,6,7,8,9 and 14,15,16,17,18) }
        var i:integer;
            r1,r2:Trect;
        begin
          for  i:=5 to 18 do
          if (i<10) or (i>13) then
          begin
            with slots[i] do
            begin
              r1:=positions[1];{r1 = one end of move}
              {r2 = other end of move}
              If i<18 then r2:=slots[i+1].positions[1]
              else r2:=slots[1].positions[1];
              with positions[2] do {move 1/3 of distance from r1 to r2}
              begin
                left:= positions[1].left + (r2.left-r1.left) div 3;
                top:= positions[1].top + (r2.top-r1.top) div 3;
                right:= positions[1].right + (r2.right-r1.right) div 3;
                bottom:= positions[1].bottom + (r2.bottom-r1.bottom) div 3;
              end;
              with positions[3] do {move 2/3 of distance from r1 to r2}
              begin
                left:= positions[1].left + 2*(r2.left-r1.left) div 3;
                top:= positions[1].top + 2*(r2.top-r1.top) div 3;
                right:= positions[1].right + 2*(r2.right-r1.right) div 3;
                bottom:= positions[1].bottom + 2*(r2.bottom-r1.bottom) div 3;
              end;
            end;
          end;
        end; {interpolate}

var i,j,n:integer;
begin  {redraw}

 {position left side controls at bottom of screen}
  movebox.Top:=clientheight-statictext1.height-movebox.height-10;
  searchbox.Top:=movebox.top;
  showmebtn.Top:=searchbox.Top+searchbox.Height+2;
  resetbtn.Top:=movebox.Top + movebox.Height-resetbtn.Height;
  memo2.Top:=movebox.Top-memo2.Height-10;
  memo1.Height:=memo2.Top-memo1.top-20;

  {now work on the track}
  with image1, canvas do
  begin
    bgc:=clsilver;
    trkcolor:=clolive;

    brush.color:=bgc;
    height:=self.clientheight-statictext1.height;
    width :=image1.height;
    picture.bitmap.height:=height;
    picture.bitmap.width:=width;
    left:=self.clientwidth-width;
    memo1.width:=left-memo1.left-20;
    memo2.Width:=memo1.Width;
    top:=0;

    reformatmemo(memo1);
    update;
    rectangle(0,0,width,height);

    cx:=width div 2;
    cy:=height div 2;

    r:= width div 22;  {basic track width}
    cr:=9*r div 10 - 1;  {marble radius}

    {fill in the black center square}
    brush.color:=clblack;
    fillrect(rect(cx-2*r,cy-2*r,cx+2*r,cy+2*r));
    update;
    {assign base poistions for inner square marbles}
    for n:=18 downto 15 do
    begin
      i:=0; j:=18-n;
      vslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    update;
    for n:=6 to 9 do
    begin
      i:=3; j:=n-6;
      vslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    for n:=15 to 18 do
    begin
      i:=n-15; j:=0;
      hslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;
    for n:=9 downto 6 do
    begin
      i:=9-n;  j:=3;
      hslots[n].positions[1]:=
          rect(cx+(2*i-3)*r-cr,cy+(2*j-3)*r-cr,cx+(2*i-3)*r+cr,cy+(2*j-3)*r+cr);
    end;

    {draw the four loops - marbles and track segments}
    drawloop(-pi,cx,cy-5*r);   {top loop}
    for i:=1 to 5 do for j:=1 to 3 do vslots[i].positions[j]:=locs[i,j];
    drawloop(0,cx,cy+5*r);     {bottom loop}
    for i:=10 to 14 do for j:=1 to 3 do vslots[i].positions[j]:=locs[i-9,j];
    drawloop(pi/2, cx-5*r,cy); {left loop}
    for i:=10 to 14 do for j:= 1 to 3 do hslots[i].positions[j]:=locs[i-9,j];
    drawloop(-pi/2,cx+5*r,cy); {right loop}
    for i:=1 to 5 do for j:= 1 to 3 do hslots[i].positions[j]:=locs[i,j];

    floodfill(cx,cy-9*r-2,bgc,fssurface); {fill outer arc}
    brush.color:=trkcolor;
    floodfill(cx-2*r-1,cy-2*r-1,bgc,fssurface); {fill track area}

    {assign intermediate marble positions}
    interpolate(HSlots);
    interpolate(VSlots);
  end;

  for i:=1 to 18 do
  begin
    hslots[i].currrect:=hslots[i].positions[1];
    vslots[i].currrect:=vslots[i].positions[1];
   end;


  {Show the track}
  draw(Vslots,1);
  draw(HSlots,1);
end; {redraw}

var
  {"Shift" array is used by procedure SynchForm to synchronize marble colors
   common to horizontal and vertical tracks after a move}
  shift:array[0..5] of integer = (18,6,9,15,18,6);

{*************** SynchForm *************}
procedure TForm1.SynchFrom(var slots1, slots2:TSlots);
{make the common slots in slots2 match color with slots1}
var
  i,d:integer;
begin
  if @slots1=@hslots then d:=-1 else d:=+1;
  for i:=1 to 4 do slots2[shift[i]].color:=slots1[shift[i+d]].color;
end;


{**************** Draw *****************}
procedure TForm1.draw(Const slots:TSlots; n:integer);
{draw marbles being moved, "n" indicates which intermediate position}
var i:integer;
begin
  with image1.canvas do
  begin
    pen.color:=trkcolor;
    brush.color:=trkcolor;
    for i:=1 to 18 do {erase all tokens from their old positions}
    with slots[i] do  with currrect do ellipse(left,top,right,bottom);

    for i:=1 to 18 do
    with slots[i] do
    begin
      brush.color:=color;
      pen.color:=clblack;
      with positions[n] do ellipse(left,top,right,bottom);
      currrect:=positions[n];
    end;
  end;
end;

{**************** Move ******************}
procedure Tform1.move(var Slots:TSlots; clockwise{,Visual}:boolean);
{Move Horiz or Vertical track one position clockwise or counterclockwise}
var
  i:integer;
  c:Tcolor;
begin
  if clockwise then
  begin
    for i:=2 to 3 do
    begin
     draw(slots, i);
     update;
     sleep(sleeptime);
    end;
    c:=slots[18].color;
    for i:=18 downto 2 do slots[i].color:=slots[i-1].color;
    slots[1].color:=c;
    draw(slots,1);
  end
  else
  begin {counterclockwise}
    c:=slots[1].color; {save last color}
    for i:=1 to 17 do slots[i].color:=slots[i+1].color; {shift all colors back}
    slots[18].color:=c; {put color 1 in slot 18}
    for i:=3 downto 1 do
    begin
      draw(slots,i);
      update;
      sleep(sleeptime);
    end;
  end
end;

{***************  Setup ************}
Procedure TForm1.Setup;
{Re-establish original marble arrangement}
var i:integer;
    c:Tcolor;
begin
  {Initial}
  for i:= 1 to 18 do
  begin
    case i of
      1,5,10,14: c:=clyellow;
      2,3,4,11,12,13:c:=clblue;
      else c:=clred;
    end;
    vslots[i].color:=c;
    hslots[i].color:=c;
  end;

  nbrmoves:=0;
  movecountlbl.caption:='0';
end;

{********************* HCWBtnCLick ***********}
procedure TForm1.HCWBtnClick(Sender: TObject);
{Horizontal clockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do  move(hSlots,true);
  synchfrom(hSlots,vslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** VCWBtnCLick ***********}
procedure TForm1.VCWBtnClick(Sender: TObject);
{Vertical clockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(vSlots,true);
  synchfrom(vSlots,hSlots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** HCCWBtnCLick ***********}
procedure TForm1.HCCWBtnClick(Sender: TObject);
{Horoizontal counterclockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(Hslots,false);
  synchfrom(hslots,vslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{****************** VCCWBtnCLick ***********}
procedure TForm1.VCCWBtnClick(Sender: TObject);
{Vertical counterclockwise move}
var i:integer;
begin
  for i:=1 to movecount.value do move(Vslots,false);
  synchfrom(vslots,hslots);
  inc(nbrmoves);
  movecountlbl.caption:=inttostr(nbrmoves);
end;

{**************** ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset the marbles to original position and score to 0}
begin
  setup;
  draw(vslots,1);
  draw(hslots,1);
end;



{Types for recursive solution searching}
type
  TDir=(HCW,HCCW,VCW,VCCW, None);
  TMovetype=record
    mtype:TDir;
    mcount:integer;
  end;
  TSearchSlots=array[1..18] of char;
  TMoves=array of TMovetype; {entry i>0 is number of spaces moved in move i
                                   >0 for clockwise, <0 for CCW,
                                   TMoves[0]=number of moves in the array}
var
  movechar:array[HCW..None] of string =
         ('HCW','HCCW','VCW','VCCW','???');
  maxdepth:integer=10;

procedure TForm1.ShowmeBtnClick(Sender: TObject);
var
  i:integer;
  SearchV,SearchH:TSearchSlots;
  Moves:TMoves;
  Solutioncount:integer;

  (*   {Obsolete- not needed and some of the longer solution will have same key '
        as shorter solutions}
  {------------- MakeKey -------------}
  function makekey(const H,V:TSearchslots):int64;
  {key is implemented as a 64 bit integer with 2 bits assigned to
   represent the color for each of the 32 marbles.  Note that all
   18 marbles in the horizontal loop are encoded + the 14 marbles in
   the vertical loop which do not belong to the horizontal loop}

  var
    i:integer;
    n:byte;
  begin
    result:=0;
    for i:=1 to 18 do
    begin
      case h[i] of
        'B':n:=1;
        'R':n:=2;
        'Y':n:=3;
        Else
        begin
          showmessage('Program error 1, invalid color code');
          n:=0;
        end;
      end;
      result:=result shl 2 or N;
    end;
    for i:=1 to 17 do
    {add vertical color codes except for the shared marbles (6,9,15 and 18)}
    if (i<>6) and (i<>9) and (i<>15) then
    begin
      case v[i] of
        'B':n:=1;
        'R':n:=2;
        'Y':n:=3;
      end;
      result:=result shl 2 or N;
    end;
  end;
  *)

    {-------------- TryNextMove ------------}
    function tryNextMove(var H,V:TSearchSlots):boolean;
    {recursive depth first search}
    var
      saveh,savev:TSearchSlots;
      lastmovenbr:integer;
      savem:TMoves;
      last:char;
      key:int64;
      index:integer;
      lastmovemade:TDir;
      S:String;
      i,j:integer;
      compMoves:TMoves; {compressed move array used to display solutions}

        {........... TryMove ...........}
        function trymove(m:TDir):boolean;
        {performs the actual manipulation of the horizontal and
        vertical marble loop arrays to set up a rotation of the
        specified loop in the specified direction}
        var
          i:integer;
        begin
          result:=false;
          setlength(savem,length(moves));
          begin
            saveh:=h;
            savev:=v;
            for i:=0 to high(moves) do savem[i]:=moves[i];
            inc(moves[0].mcount);
            with moves[moves[0].mcount] do
            begin
              mcount:=1;
              mtype:=m;
              case m of
                HCW: {Horizontal Clockwise}
                Begin
                  last:=H[18];
                  for i:=18 downto 2 do H[i]:=H[i-1];
                  H[1]:=last;
                  v[9]:=h[6]; {change the marble colors  in the vertical loop
                               positions which intersect with the horizontal loop}
                  v[15]:=h[9];
                  v[18]:=h[15];
                  v[6]:=h[18];
                end;
                HCCW: {Horizontal Counterclockwise}
                begin
                  last:=H[1];
                  for i:=1 to 17 do H[i]:=H[i+1];
                  H[18]:=last;
                  v[9]:=h[6];
                  v[15]:=h[9];
                  v[18]:=h[15];
                  v[6]:=h[18];
                end;
                VCW:  {Vertical Clockwise}
                Begin
                  last:=V[18];
                  for i:=18 downto 2 do V[i]:=V[i-1];
                  V[1]:=last;
                  h[6]:=v[9];
                  h[9]:=v[15];
                  h[15]:=v[18];
                  h[18]:=v[6];
                end;
                VCCW: {Vertical Counterclockwise}
                begin
                  last:=V[1];
                  for i:=1 to 17 do V[i]:=V[i+1];
                  V[18]:=last;
                  h[6]:=v[9];
                  h[9]:=v[15];
                  h[15]:=v[18];
                  h[18]:=v[6];
                end;
              end;
            end;
            (*  {no need to track visited positions for this puzzle}
            {check if we have already visited this board position}
            key:=makekey(H,V);
            if not visited.find(key,index) then
            begin   {no, mark it as visited and keep searching }
              visited.add(key);
              result:=trynextmove(H,V );
            end;
            *)
            result:=trynextmove(H,V );
            {restore the entry postions for the next entry}
            H:=saveh;
            V:=savev;
            for i:=0 to high(savem) do moves[i]:=savem[i];
          end;
        end; {trymove}

        {........... Solved ...........}
        function solved:boolean;
        begin
          if (V[6]='B') and (v[7]='B') and (v[8]='B') and (v[9]='B')
             and (V[15]='B') and (v[16]='B') and (v[17]='B') and (v[18]='B')
             and (H[7]='B') and (H[8]='B') and (H[16]='B') and (v[17]='B')
           then result:=true
           else result:=false;
         end;

    begin  {trynextmove}
      result:=false;
      //if quitflag then exit;
      if solved then
      begin
        inc(solutioncount);
        {compress the moves list by combining multiple moves in the same
         direction into a single entry}
        setlength(compmoves, maxdepth+1);
        compmoves[0].mcount:=0;
        j:=1;
        compmoves[1]:=moves[1];
        for i:=2 to moves[0].mcount do
        begin
          if moves[i-1].mtype=moves[i].mtype
          then inc(compmoves[j].mcount)
          else
          begin
            inc(j);
            compmoves[0].mcount:=j;
            compmoves[j]:=moves[i];
          end;
        end;

        s:='';
        for i:=1 to compmoves[0].mcount do
        with compmoves[i] do
        begin
          if mcount=1 then s:=s+ movechar[mtype]
          else s:=s+inttostr(mcount)+'x'+movechar[mtype];
          if i<compmoves[0].mcount then s:=s+' ,';
        end;
        with memo2.lines do
        begin
          add(format('#%2d: Has %d moves (%d single moves)',
               [solutioncount, compmoves[0].mcount, moves[0].mcount]));
          add('     '+s);
        end;
        (*
        j:=messagedlg(format('Solution with %d moves (%d single moves)',
               [compmoves[0].mcount, moves[0].mcount])+
                #13+s,mtConfirmation,[mbOK,mbCancel],0);
        if j=mrcancel then quitflag:=true;
        *)
      end ;
      //else
      begin
        lastmovenbr:=moves[0].mcount;
        lastmovemade:=moves[lastmovenbr].mtype;
        if  (lastmovenbr<high(Moves)) then
        begin
          {Try moves in the three directions than are not a direct reversal of the
           previous move, try all 4 direction if lastmovemade=None (1st time though)}
          for i:=lastmovenbr+1 to high(moves) do if moves[i].mtype<>none then showmessage('Stop');
          if lastmovemade<>HCCW then result:=trymove(HCW);
          if lastmovemade<>HCW then result:=trymove(HCCW);
          if lastmovemade<>VCCW then result:=trymove(VCW);
          if lastmovemade<>VCW then result:=trymove(VCCW);
        end;
      end;
    end;

  {----------- ColorCode --------}
  function colorcode(c:Tcolor):char;
  {Convert Tcolors to letter characters}
  begin
    case c of
      clred:result:='R';
      clblue:result:='B';
      clyellow:result:='Y';
      else result:=' ';
    end;
  end;


begin    {SearchBtnClick }
  memo2.clear;
  memo2.Lines.Add('Solutions');
  maxdepth:= searchbox.itemindex+8;
  solutioncount:=0;
  {load up search arrays}
  for i:=1 to 18 do
  begin
    SearchV[i]:=Colorcode(Vslots[i].color);
    SearchH[i]:=Colorcode(HSlots[i].color);
  end;
  setlength(moves, maxdepth+1);
  for i:=low(moves) to high(moves) do
  with moves[i] do
  begin
    mcount:=0;
    mtype:=None;
  end;
  (*
  {Set up visited list to avoid looping back through positions already checked}
  visited:=TIntlist.create;
  visited.sorted:=true;
  *)
  //quitflag:=false;
  Trynextmove(searchH,SearchV);   {Start the search}
  //visited.free;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

