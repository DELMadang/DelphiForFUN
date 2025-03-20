unit U_ChessLogic4;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {
 Place the 6 missing chess pieces of color not on
the board in such a way that:

 --  Two men of opposite colors do not occupy
     the same  row, column, or diagonal

 --   Each Pawn must be adjacent to its King

 --  There are no more than 3 men per row or
     column.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, shellapi;

  Type
   TPiecerec=record
    pieceID:string; {Id of piece}
    imageoffset:integer;  {x offset of the image for this piece in Image1}
    locatedAt:TPoint; {where is it on the board?  (0,0)= not placed yet}
    fixed:boolean;  {true=already in place, cannot be moved}
    Image:TImage;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    InitLbl: TLabel;
    ResetBtn: TButton;
    StaticText1: TStaticText;
    Memo2: TMemo;
    RandomBox: TCheckBox;
    ShowStepsBox: TCheckBox;
    AnimateBox: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ResetBtnClick(Sender: TObject);
    procedure ImageStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure StaticText1Click(Sender: TObject);
  public
    pieces:array[1..12] of TPiecerec; {the chess pieces}
    board:array[1..4,1..4] of integer; {interal board representaion}
    displaytop:TPoint; {top left corner of the board}
    piecesplaced:integer; {current number of movable pieces on the board}
    automovecount:integer;  {number of trial moves to solve}
    function  placepiece(index:integer):boolean; {recursive search & place function}
    procedure placepieceat(i,c,r:integer; field:boolean);
    procedure removepieceat(i,c,r:integer);
    procedure updatedisplay;
    procedure resetboard;
    procedure animatepieceto(i,targetx,targety:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
var
   LongPiecenames:array[1..6] of string=
     ('Bishop','Rook','King','Knight','Pawn','Queen'); {white}

   Piecenames:array[1..12] of string=
     ('W-B','W-R','W-Ki','W-Kn','W-P','W-Q', {white}
      'B-B','B-R','B-Ki','B-Kn','B-P','B-Q'  {black}
     );

   {Offsets into images of piecees in image1 (*49 bits/image)}
   pieceoffsets:array[1..12] of integer = (7,2,10,8,5,0,6,3,11,9,4,1);

   {Rearranged when random order search is specified}
   shuffled:array[1..12] of integer=(1,2,3,4,5,6,7,8,9,10,11,12);

   sleepdelay:integer=5;

 const
   imagesize=49;
   cellsize=imagesize+2;
   linelength=4*cellsize;


procedure TForm1.animatepieceto(i,targetx,targety:integer);
  var
    startx,starty:integer;
    xdist,ydist:integer;
    dx,dy:extended;
  begin
    with pieces[i] do
    begin
      xdist:=targetx-image.left;
      ydist:=targety-image.top;
      image.bringtofront;  {show this piece on top of others}
      if abs(ydist)>abs(xdist) then
      begin
        dx:=xdist/abs(ydist);
        if ydist>0 then dy:=+2 else dy:=-2;
        startx:=image.left;
        for i:=1 to abs(ydist) div  2 do
        begin
          image.top:=image.top+trunc(dy);
          image.left:=startx+trunc(2*i*dx);
          if sleepdelay>0 then sleep(sleepdelay);
          image.update;
        end;
      end
      else  {horizontal move}
      if xdist<>0 then
      begin
        if xdist>0 then dx:=+2 else dx:=-2;
        dy:=ydist/abs(xdist);
        starty:=image.top;
        for i:= 1 to abs(xdist) div 2 do
        begin
          image.left:=image.left+trunc(dx);
          image.top:=starty+trunc(2*i*dy);
          if sleepdelay>0 then sleep(sleepdelay);
          image.update;
        end;
        image.left:=image.left+trunc(dx);
      end;
    end;
  end;

{************** PlacePieceAt *************}
procedure TForm1.placepieceat(i,c,r:integer; field:boolean);
var
  targetx,targety:integer;
begin
  pieces[i].locatedat:=point(c,r);
  board[c,r]:=i;
  pieces[i].fixed:=field;
  with pieces[i] do
  begin
    targetx:=displaytop.x+(c-1)*(cellsize)+1;
    targety:=displaytop.y+(r-1)*(cellsize)+1;
    if animatebox.checked then Animatepieceto(i,targetx,targety);
    image.left:=targetx; {Position piece exactly on target}
    image.top:=targety;
    image.update;
    if automovecount>0 then {don't report the fixed piece setup moves}
    if showstepsbox.checked
    then memo2.lines.add(format('%2d) %s added at (C:%d, R:%d)',
                                 [automovecount, pieceid, c, r]));
  end;
  updatedisplay;
end;

{************** RemovePieceAt ***********}
procedure TForm1.removepieceat(i,c,r:integer);
var
  j,k:integer;
begin
  with pieces[i] do
  begin
    if showStepsBox.Checked then
    with memo2, lines do
    begin
      for j:=1 to 11 do
      {we would like to report which piece could not be placed.  It will be
       the next piece in the "shuffled" array, unless that piece is one of
       the fixed pieces in which case it will be the first following piece
       which is not fixed in its location}
      if (shuffled[j]=i) then
      for k:=j+1 to 11 do
      if  (not pieces[shuffled[k]].fixed) then
      begin
        add(format('- Cannot place next piece, %s',[pieces[shuffled[k]].pieceid]));
        break;
      end;
      add(format('   %s removed from (C:%d, R:%d)',[pieceid,c,r]));
    end;
    if animatebox.checked then
    {move the piece image back to its home base}
    animatepieceto(i,label4.left + ((i-1) div 6)*cellsize,
                       label4.top-imagesize-2 + ((i-1) mod 6)*(cellsize+16));
    locatedat:=point(0,0);
    board[c,r]:=0;
    updateDisplay;
  end;
end;

{*********** UpdateDisplay **********}
procedure TForm1.updateDisplay;
begin
  application.processmessages;
  if sleepdelay>0 then sleep(125);
end;


{************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  displaytop:=point(304,56);
  for i:=1 to 12 do
  with pieces[i] do
  begin
    image:=TImage.create(self);;
    with image do
    begin
      parent:=self;
      width:=imagesize;
      height:=imagesize;
      picture.bitmap.height:=height;
      picture.bitmap.width:=width;
      visible:=true;
      dragMode:=dmautomatic;
      OnStartDrag:=ImageStartDrag;
      tag:=i;  {so we can check in reverse, from the image to the piece when dragging}
    end;
  end;
  resetboard;
  randomize;
end;

{*********** Resetboard ***********}
procedure TForm1.resetboard;
var
  i,j:integer;
begin
  for i:=1 to 4 do {initialize board}
  for j:=1 to 4 do
  begin
    board[i,j]:=0;
  end;
  solvebtn.visible:=false;
  resetbtn.visible:=false;
  initlbl.visible:=true;
  initlbl.caption:='Placing initial pieces';
  for i:=1 to 12 do with pieces[i] do
  with image do
  begin
    pieceId:=piecenames[i];
    imageoffset:=pieceoffsets[i]*imagesize;
    picture.bitmap.canvas.copyrect(rect(0,0,imagesize,imagesize),image1.canvas,
                          rect(imageoffset,0,imageoffset+imagesize,imagesize));
    left:=label4.left + ((i-1) div 6)*cellsize;
    top:= label4.top-imagesize-2 + ((i-1) mod 6)*(cellsize+16);
    locatedAt:=point(0,0);
    update;
  end;
  sleep(1000);
  placepieceat(5,1,2,true);  {white pawn}
  placepieceat(12,2,4,true); {black queen}
  placepieceat(9,2,3,true); {black queen}
  placepieceat(7,3,1,true); {black bishop}
  placepieceat(8,4,1,true); {black rook}
  placepieceat(4,4,4,true); {White knight}
  //initlbl.visible:=false;
  solvebtn.visible:=true;
  resetbtn.visible:=true;
  updatedisplay;
  piecesplaced:=0;
  initlbl.caption:='Drag and drop remaining pieces';
end;



{************** PlacePiece ***************}
function TForm1.placepiece(index:integer):boolean;
{Recursive routine to place pieces on the board}
var
  i,j,k:integer;
  c,r:integer;
  op,adj:integer;
  OK:boolean;
  sum:integer;
  n:integer;


  function NoOpposite(const i,j,offc,offr,Op:integer):boolean;
  var
    c,r:integer;
  {checking diagonals as specified by offsets offc and offr for something
   matching Op (the piece of the opposite color)}
  begin
    c:=i; r:=j;
    inc(c,offc);
    inc(r,offr);
    result:=true;
    while (c<=4) and (c>=1) and (r<=4) and (r>=1) do
    if board[c,r]=Op then
    begin
      result:=false;
      break;
    end
    else
    begin
      inc(c,offc);
      inc(r,offr);
    end;
  end;

begin
  n:=shuffled[index];
  result:=false;
  updatedisplay;
  if index>12 then
  begin
    result:=true;
    updatedisplay;
    showmessage('Solution found! '
             +#13+'('+inttostr(automovecount)+' trial moves made)');
    initlbl.caption:='Solution found!';
    exit;
  end
  else
  begin
    if pieces[n].locatedat.x>0 then
    begin
      result:=placepiece(index+1);
      exit;
    end
    else
    begin  {not placed, find a place for it}
      if n<=6 then op:=n+6 else op:=n-6;
      for i:=1 to 4 do
      begin
        for j:=1 to 4 do
        begin
          if board[i,j]=0 then
          begin   {empty space}
            {check conditions}
            {other piece of same color not in same column, row, or diagonal}
            ok:=true;
            for k:=1 to 4 do
            if (board[k,j]=op) or (board[i,k]=op) then
            begin
              ok:=false;
              break;
            end;
            if OK then
            begin
              {check diagonals}
              if ok then ok:= NoOpposite(i,j,-1,+1,Op);
              if ok then ok:= NoOpposite(i,j,+1,-1,Op);
              if ok then ok:= NoOpposite(i,j,+1,+1,Op);
              if ok then ok:= NoOpposite(i,j,-1,-1,Op);
            end;

            {pawn must be adjacent to king of same color}
            if OK then
            begin
              case n of
                3:adj:=5; {white pawn adj white king}
                5:adj:=3; {white king adj white pawn}
                9:adj:=11; {black pawn adj bkack king}
                11:adj:=9; {bakck king adj black pawn}
                else adj:=0;
              end;
              {If mandatory adjacent has been placed it must be adjacent to n}
              if (adj>0) and (pieces[adj].locatedat.x>0) then
              if (abs(i -pieces[adj].locatedat.x)<>1)
                 and (abs(j - pieces[adj].locatedat.y)<>1)
               then OK:=false;
            end;
            {no more than 3 men per row or column no more here than 2 since
             we haven't really added the piece[i,j] yet }
            if ok then
            begin
              sum:=0;
              for r:=1 to 4 do if board[i,r]>0 then inc(sum);
              if sum>=3 then ok:=false;
              if OK then
              begin
                sum:=0;
                for c:=1 to 4 do if board[c,j]>0 then inc(sum);
                if sum>=3 then ok:=false;
              end;
            end;
           {tests completed}
            if ok then
            begin
              inc(automovecount); {count the n umber of times routine is entered}
              placepieceat(n,i,j,false);
              result:= placepiece(index+1);
              if not  result then removepieceat(n,i,j);
            end;
            if result then exit;
          end;
        end;
      end;
    end;
  end;
end;

{************** SolveBtnClick ************}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i,j,swap:integer;
begin
  if piecesplaced > 0 then resetboard;
  memo2.clear;  initlbl.caption:='Auto-solving';
  if showStepsBox.checked
  then  memo2.visible:=true else memo2.visible:=false;
  if animatebox.checked then sleepdelay:=5 else sleepdelay:=0;
  automovecount:=0;
  if randombox.checked then
  begin {shuffle the list controlling the order that pieces are placed}
    for i:= 12 downto 2 do
    Begin
      j:=random(i-1)+1;  {get a random piece}
      {exchange the current piece with a randomly selected piece}
      swap:=shuffled[i];
      shuffled[i]:=shuffled[j];
      shuffled[j]:=swap;
    end;
  end;
  if not placepiece(1) {Place 1st piece, recursive call will try to place all others}
  then initlbl.caption:='No solution found :(';
  piecesplaced:=6;
  if showStepsBox.checked then
  with memo2 do
  begin
    selstart:=0;
    sellength:=0;
  end;
end;

{*********** Formpaint ***********}
procedure TForm1.FormPaint(Sender: TObject);
var
  x,y,i:integer;

begin
  with canvas do
  begin
    x:=displaytop.x;
    y:=displaytop.y;
    rectangle(x,y,x+linelength,y+linelength);
    for i:=0 to 4 do
    begin
      moveto(x+i*cellsize,y);
      lineto(x+i*cellsize,y+linelength);
      moveto(x,y+i*cellsize);
      lineto(x+linelength,y+i*cellsize);
    end;
  end;
end;

{*************** ImagedragDrop ***********}
procedure TForm1.ImageDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  col,row:integer;
  i,n:integer;
  OK:boolean;

      {---------- maxPieceCount ---------}
      function maxpiececount:integer;
      {return the maximum number of pieces in any row or column}
      var
        sum:integer;
        c,r:integer;
      begin
        result:=0;
        for c:=1 to 4 do
        begin
          sum:=0;
          for r:=1 to 4 do if board[c,r]>0 then inc(sum);
          if sum>result then result:=sum;
        end;

        for r:=1 to 4 do
        begin
          sum:=0;
          for c:=1 to 4 do if board[c,r]>0 then inc(sum);
          if sum>=result then result:=sum;
        end;
      end;

      {----------- SameDiagonal ----------}
      function samediagonal(p1,p2:integer):boolean;
      {return true if piece numbers p1 and p2 are on the same diagonal}
           function samediag(p1,offsetc, offsetr, p2:integer):boolean;
           var
             c,r:integer;
           begin
             c:=pieces[p1].locatedat.x;
             r:=pieces[p1].locatedat.y;
             inc(c,offsetc);
             inc(r,offsetr);
             result:=false;
             while (c<=4) and (c>=1) and (r<=4) and (r>=1) do
             if board[c,r]=p2 then
             begin
               result:=true;
               break;
             end
             else
             begin
               inc(c,offsetc);
               inc(r,offsetr);
             end;
           end;

      begin {samediagonal}
         result:= samediag(p1,-1,+1,p2);
         if result then result:= samediag(p1,+1,-1,p2) else exit;
         if result then result:= samediag(p1,-1,+1,p2) else exit;
         if result then result:= samediag(p1,-1,-1,p2) else exit;
         if result then result:= samediag(p1,+1,+1,p2) else exit;
      end;

      {----------- ErrMessage --------}
      procedure errmessage(msg:string);
      begin
        Initlbl.caption:=msg;
        //Initlbl.visible:=true;
      end;

begin
  {drop image , check that it is valid}
  col:=(x-displaytop.x) div cellsize;
  row:=(y-displaytop.y) div cellsize;
  if (row>=0) and (row<=3) and (col>=0) and (col<=3) then
  with source as TImage do
  begin
    left:=displaytop.x+col*cellsize+1;
    top:= displaytop.y+row*cellsize+1;
    update; {show piece in its landing position}
    with pieces[tag] do
    begin
      board[col+1,row+1]:=tag; {assign the piece nbr to the dropped board location}
      if locatedat.x=0  {this is a new entry into the board}
      then if piecesplaced<6 then inc(piecesplaced);  {count it}
      with locatedat do board[x,y]:=0; {empty old location}
      locatedat:=point(col+1, row+1); {assign new location on the board}
    end;
  end;

  if piecesplaced=6  then {all placed, check solution}
  begin
    OK:=true;
    {count occupied rows and columns (no more than 3 pieces allowed}
    n:=maxpiececount;
    if N >3 then
    begin
      errmessage('More than 3 pieces in a row or column');
      OK:=false;
    end;
    {check each piece to see that its opposite is not in the same
     column, row, or diagonal}
    if ok then
    for i:=1 to 6 do
    begin
      if (pieces[i].locatedAt.x=pieces[i+6].locatedAt.x) or
         (pieces[i].locatedAt.y=pieces[i+6].locatedAt.y)
      then
      begin
        errmessage(format('%s pieces are in the same row or column',
                      [LongPiecenames[i]]));
         ok:=false;
         break;
      end;
      if samediagonal(i,i+6) then
      begin
        errmessage(format('%s pieces are on the same diagonal',
                      [LongPiecenames[i]]));
         ok:=false;
         break;
      end;
    end;

    {Check that pawns are adjacent to king of the same color}
    if OK then
    begin
      if  ((abs(pieces[3].locatedat.x -pieces[5].locatedat.x)<>1)
           and (abs(pieces[3].locatedat.y - pieces[5].locatedat.y)<>1))
          or ((abs(pieces[9].locatedat.x -pieces[11].locatedat.x)<>1)
           and (abs(pieces[9].locatedat.y - pieces[11].locatedat.y)<>1))then
      begin
         errmessage('At least one pawn is not adjacent to the king of the same color');
         OK:=false;
      end;
   end;
   if OK then
   begin
     //showmessage('You solved it!'+#13+'Congratulations!');
     initlbl.caption:='Solved  Congratulations!';
   end;
 end;
end;

{************* FormDragOver *************}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  col,row:integer;
begin
  {User is dragging a chess piece}
  {Set accept=true if it is on an enpty board cell and does not violate any
   of the constraints}
   accept:=false;
   if pieces[timage(source).tag].fixed then exit; {can't drag a fixed piece}
   col:=(x-displaytop.x) div cellsize;
   row:=(y-displaytop.y) div cellsize;
   if (row>=0) and (row<=3) and (col>=0) and (col<=3) then
   begin
     inc(row);
     inc(col);
     if board[col,row]=0 then accept:=true;
   end;
end;

procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  resetboard;
end;

procedure TForm1.ImageStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  {start image drag ???}
  Initlbl.caption:='';
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
