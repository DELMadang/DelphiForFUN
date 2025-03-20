unit U_NumbrixGenerator;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, shellapi;

type
  TForm1 = class(TForm)
    Image1: TImage;
    SpinEdit1: TSpinEdit;
    PathBtn: TButton;
    StopBtn: TButton;
    Showprogress: TCheckBox;
    CheckHoleCount: TCheckBox;
    SaveBtn: TButton;
    Display: TRadioGroup;
    TryMoves: TRadioGroup;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    StartAt: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure PathBtnClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure DisplayClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    size, sizesqr:integer;
    cellsize:integer;
    halfw:integer;
    dotrad:integer;
    board:array of array of integer;
    location:array of tpoint;
    count:int64; {loop count}
    filename:string;
    procedure newboard;
    procedure resetboard;
    procedure redrawimage;
    procedure showpathto(stop:integer);
    function placenext(next,nextx,nexty:integer):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

type TOffset=array[1..4] of TPoint;
var
  maxloop1:integer=100000; {try 100,000 moves before giving up}
  offset:TOffset =((x:0;y:-1),(x:+1;y:0),
                                 (x:0;y:+1), (x:-1;y:0));
  offsets:array[0..23] of TOffset;
  permutes:array[0..23] of array[1..4] of integer=
         ((1,2,3,4),(1,2,4,3),(1,3,2,4),(1,3,4,2),(1,4,2,3),(1,4,3,2),
          (2,1,3,4),(2,1,4,3),(2,3,1,4),(2,3,4,1),(2,4,1,3),(2,4,3,1),
          (3,1,2,4),(3,1,4,2),(3,2,1,4),(3,2,4,1),(3,4,1,2),(3,4,2,1),
          (4,1,2,3),(4,1,3,2),(4,2,1,3),(4,2,3,1),(4,3,1,2),(4,3,2,1));


{************* RedrawImage *********}
procedure TForm1.redrawimage;
var
  i,j,x,y:integer;
begin
  with image1, canvas do
  begin
    brush.color:=clwhite;
    canvas.rectangle(clientrect);

    for i:=0 to size-1 do
    begin
      if display.itemindex=0 then x:=i*cellsize+halfw
      else
      begin
        x:=i*cellsize;
        pen.color:=clblack;
        moveto(x,0);
        lineto(x,width);
        moveto(0,x);
        lineto(width,x);
      end;
      for j:=0 to size-1 do
      begin
        with image1, canvas do
        begin
          case display.itemindex of
          0:begin {display the path}
              y:=j*cellsize+halfw;
              brush.Color:=clred;
              ellipse(x-dotrad,y-dotrad,x+dotrad,y+dotrad);
              if board[i+1,j+1]<>0
              then
              begin
                brush.color:=clwhite;
                font.Size:=8;
                font.Color:=clblack;
                textout(x+dotrad, y+dotrad,inttostr(abs(board[i+1,j+1])));
              end;
            end;
          1,2:begin  {diaplay a Numberix pattern}
              if display.itemindex=1 then
              begin
                board[i+1,j+1]:=abs(board[i+1,j+1]);
                if (i=0) or (i=size-1) or (j=0) or (j=size-1)
                then board[i+1,j+1]:=-board[i+1,j+1];
              end;
              y:=j*cellsize;
              font.Size:=12;
              brush.color:=clwhite;
              if board[i+1,j+1]<0 then
              begin
                font.style:=[fsbold];
                font.color:=clblue;
                textout(x+4, y+4,inttostr(-board[i+1,j+1]));
              end else
              begin
                font.style:=[];
                font.color:=clred;
                textout(x+4, y+4,inttostr(board[i+1,j+1]));
              end;
            end;
          end;{case}
        end;
      end;
    end;
  end;
end;


{*********** NewBoard *********}
procedure TForm1.Newboard;
begin
  size:=spinedit1.value;
  sizesqr:=size*size;
  resetboard;
  cellsize:=image1.width div (size);
  halfw:=cellsize div 2;
  dotrad:=3;
  redrawimage;
end;



{************** FormActvate *********88}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,j:integer;
begin
  randomize;
  savedialog1.InitialDir:=extractfilepath(application.exename);
  with image1.Picture.bitmap do
  begin
    width:=image1.Width;
    height:=image1.Height;
  end;
  {make all permutations of offsets to randomly select directions tried}
  for i:=0 to 23 do
  for j:=1 to 4 do
  offsets[i,j]:=offset[permutes[i,j]];
end;

{************ Resetboard *******}
procedure TForm1.resetboard;
var
  i,j:integer;
begin
  setlength(board,size+2,size+2);
  for i:=1 to size do
  for j:=1 to size do board[i,j]:=0;
  for i:=0 to high(board) do
  begin
    board[0,i]:=100;
    board[high(board),i]:=100;
    board[i,0]:=100;
    board[i,high(board)]:=100;
  end;
  setlength(location,sizesqr+1);
  for i:=1 to sizesqr do location[i]:=point(0,0);
end;

var r:integer=0;


{************ Placenext *********}
function TForm1.placenext(next,nextx,nexty:integer):boolean;

  {------------ Neighborcount ---------}
  function neighborcount(nx,ny:integer):integer;
  var
    i:integer;
  begin
    result:=0;
    for i:=1 to 4 do
    with offset[i] do
    if ( board[nx+x, ny+y])>0 then inc(result);
  end;

  {------------ ChangeHoleNbr -----------}
  procedure changeholenbr(const from,too:integer);
  var
    i,j:integer;
  begin
    for i:=1 to size do
    for j:=1 to size do
    if board[i,j]=from then board[i,j]:=too;
  end;


  {{--------- HoleCount ----------}
  function holecount:integer;
  {count "holes", non connected chains of enpty cells, on the board}
  var
    i,j,k:integer;
    minholenbr:integer;
    n:integer;
  begin
    result:=0;
    for i:=1 to size do
    for j:=1 to size do   {clear out previous hole ids}
    if board[i,j]<0 then board[i,j]:=0;

    for i:=1 to size do
    for j:=1 to size do
    if board[i,j]=0 then
    begin
      minHoleNbr:=-100;
      for k:=1 to 4 do {check for empty neighbors already assigned to a hole}
      with offset[k] do
      begin
        n:=board[i+x,j+y];
        {find the smallest hole nbr and asign that to all empty neighbors}
        if (n<0) and (n>minHoleNbr) then minHoleNbr:=n;
      end;
      if minholenbr=-100 then
      begin
        inc(result);
        minholenbr:=-result;
      end;
      board[i,j]:=minHolenbr;
      for k:=1 to 4 do {combine newly connected holes into one (minholenbr)}
      with offset[k] do
      begin
        n:=board[i+x,j+y];
        if n=0 then board[i+x,j+y]:=minholenbr
        else if (n<0) and (n<>minholenbr) then
        begin
          changeholenbr(n,minholenbr);
          dec(result);
        end;
      end;
    end;
  end; {holecount}

  {---------- validmove ----------}
  function validmove(const nxx,x,nyy,y:integer):boolean;
  var
    i,n:integer;
    nx,ny:integer;
  begin
    {if any empty neighbor of the move we are considering would be left with 4
     neighbors (test for 3  neighbors since we haven't made the move yet}
    result:=true;
    nx:=nxx+x; ny:=nyy+y;
    if (next>=sizesqr-2) then  exit;
    for i:=1 to 4 do
    with offset[i] do
    if (board[nx+x, ny+y]<=0)and (neighborcount(nx+x, ny+y) =3)
     then
    begin
      result:=false;
      break;
    end;
    if checkholecount.checked then
    {if the current move would divide the board into two segments then a path
     can never be completed so return false}
    If result then
    begin
      if ((nxx=2) and (x=-1))
      or ((nxx=size-1) and (x=1))
      or ((nyy=2) and (y=-1))
      or ((nyy=size-1) and (y=1))
      then {we are joining an edge, count holes}
      begin
        {make the move temporarily}
        board[nx,ny]:=next+1;
        n:=HoleCount;
        result:=n<=1;
        board[nx,ny]:=0;
      end;
    end;

  end; {validmove}

var
  i:integer;
begin   {placenext}
  inc(count);
  result:=false;

  if (count>maxloop1) or (tag>0) then exit;
  {check for stop btn click or other messages waiting}
  if (count and $FFFF)=0 then application.processmessages;

  location[next]:=point(nextx,nexty); {save the next path location}
  board[nextx,nexty]:=next;  {set location occupied}
  if showprogress.checked then
  begin
    showpathto(next);
    application.processmessages;
    sleep(1000-10*spinedit2.value);
  end;
  if next=sizesqr then result:=true  {done}
  else
  begin
    case trymoves.itemindex of
      0: r:=0;
      1: r:=random(24);
      2: if (count and $3 =0) then r:=random(24); {random order every 4th move}
    end;
    for i:=1 to 4 do
    begin
      with offsets[r,i] do
      if (board[nextx+x,nexty+y]<=0) {location is available}
      and validmove(nextx,x,nexty,y)
      then
      begin
        result:=placenext(next+1,nextx+x, nexty+y);
        if result then exit;
      end;
    end;
    location[next]:=point(0,0);
    board[nextx,nexty]:=0;  {set location as empty}
  end;
end;

{*************** PathbtnClick **********8}
procedure TForm1.PathBtnClick(Sender: TObject);
var
  startx,starty:integer;
  count2:integer;
  OK:boolean;
  start:TDatetime;

    procedure makestart(var startx, starty:integer);
    begin
      startx:=random(size)+1;
      starty:=random(size)+1;
    end;

begin
  //randseed:=0;   {for debugging}
  newboard;
  count2:=0;
  tag:=0;
  start:=now;
  repeat
    count:=0;
    resetboard;
    redrawimage;
    inc(count2);
    case startat.itemindex of
      0: makestart(startx,starty);
      1: repeat   {start within one cell of an edge}
           makestart(startx,starty);
         until (startx=1) or (startx=size)
            or (starty=1) or (starty=size);
      2: repeat   {start within one cell of an edge}
           makestart(startx,starty);
         until (startx<=2) or (startx>=size-1)
            or (starty<=2) or (starty>=size-1);
    end;{case}
    screen.cursor:=crhourglass;
    ok:= placenext(1,startx,starty);
    if ok then
    begin
      showpathto(sizesqr);
      //memo1.lines.add(format('%dx%d %.1f secs.',[size,size,(now-start)*secsperday]));
      //showmessage(format('Path found, Loopcount=%d after %d starts',[count,count2]));
    end
  until OK or (tag>0){or (count2>maxloop2)};
  screen.cursor:=crdefault;
  //if not Ok then showmessage(format('No Path found, Loopcount=%d',[count]));
end;

{************* ShowpathTo ***********8}
procedure TForm1.showpathto(stop:integer);
{Show board and path}
var
  i:integer;
begin
  redrawimage;
  if display.itemindex=0 then
  begin
    with image1.canvas do
    begin
      with location[1] do moveto((x-1)*cellsize+halfw,(y-1)*cellsize+halfw);
      for i:=2 to stop do
        with location[i] do lineto((x-1)*cellsize+halfw,(y-1)*cellsize+halfw);
    end;
  end;
end;

{*********** SpinEditChange ********}
procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  newboard;
end;

{******* StopbtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
{Stop search}
begin
  tag:=1;
end;

{*********** DisplayClick ********}
procedure TForm1.DisplayClick(Sender: TObject);
{User clicked "Display" option, reshow image}
begin
  showpathto(sizesqr);
end;

{************* SavebtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Write predefined pattern  as a Numbrix puzzle}
var
  f:textfile;
  i,j:integer;
  fname:string;
  s:string;
begin
  if display.itemindex=0 then
  begin
    showmessage('Select a Numbrix pattern first');
    exit;
  end
  else
  if savedialog1.execute then
  begin
    fname:=savedialog1.filename;
    assignfile(f,fname);
    filename:=fname;
    rewrite(f);
    case display.itemindex of
    1:begin
        for i:=1 to size do
        begin
          s:='';
          for j:=1 to size do
          begin
            if (i=1) or (i=size) or (j=1)  or (j=size) then
            s:=s+format('%2d ',[abs(board[i,j])])
            else s:=s+'00 ';
          end;
          writeln(f,trim(s));
        end;
      end;
    2:begin
        for i:=1 to size do
        begin
          s:='';
          for j:=1 to size do
          begin
            if board[i,j]<0 then
            s:=s+format('%2d ',[-board[i,j]])
            else s:=s+'00 ';
          end;
          writeln(f,trim(s));
        end;
      end;
      else showmessage('Pattern not yet implemented');
    end;
  end;
  writeln(f,'');
  writeln(f,'Solution:');

  for i:=1 to size do
  begin
    s:='';
    for j:=1 to size do
    begin
      s:=s+format('%2d ',[abs(board[i,j])]);
    end;
    writeln(f,s);
  end;
  closefile(f);
end;

{************* Image1Click **********}
procedure TForm1.Image1Click(Sender: TObject);
{if creating Numbrix pattern 2, click to reverse signs of board values,
 negative ==> predfined value}
var
  p:tpoint;
  i,j:integer;
begin
  if display.itemindex=2 then
  begin
    p:=image1.screentoclient(mouse.cursorpos);
    i:=p.x div cellsize+1;
    j:=p.y div cellsize+1;
    board[i,j]:=-board[i,j];
    redrawimage;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
