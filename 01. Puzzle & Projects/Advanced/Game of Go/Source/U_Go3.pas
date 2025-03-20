unit U_Go3;
{Copyright  © 2005, 2007 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ShellAPI;

type
  TstoneColor=(black,white,empty,invalid);
  TStoneRec = record
    occupiedBy:TstoneColor;
    blocknbr:integer;
  end;

  TBoard=array[0..18,0..18] of TStonerec;

  {Class of block info (block=group of connected stones of same color)}
  TBlock=class(TObject)
    id:integer;
    color:TStonecolor;
    openedges:integer;
    stonelist:TStringlist;
    constructor Create;
    Destructor Destroy;  override;
  end;

  TForm1 = class(TForm)
    Image1: TImage;
    TurnLbl: TLabel;
    Button1: TButton;
    Label1: TLabel;
    Whitescorelbl: TLabel;
    Label3: TLabel;
    blackscorelbl: TLabel;
    BoardSizeGrp: TRadioGroup;
    ResetBtn: TButton;
    Shape1: TShape;
    modegrp: TRadioGroup;
    StaticText1: TStaticText;
    Memo1: TMemo;
    UndoBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Savedialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    ReloadBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure BoardSizeGrpClick(Sender: TObject);
    procedure modegrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure ReloadBtnClick(Sender: TObject);
  public
    board:TBoard;
    saveboard:TBoard; {board before move to remove in case of Ko repeat or Undo}
    prevboard: array[black..white] of TBoard; {previous bourd positions by color}
    hlines,vlines:integer; {stone # of columns and rows (always equal?)}
    hincr, vincr:integer; {pixel increments between stones}
    xstart, ystart:integer;
    tokensizex, tokensizey:integer;
    playerColor:TStoneColor;  {color for player whhose turn it is}
    nonplayerColor:TStoneColor; {color for player whose turn it isn't}
    score: array [black..white] of  integer;
    boardcolor:TColor;

    nbrblocks:integer;
    blocks: array of TBlock;
    savescore:integer;  {score to restore after undo}

    procedure resetboard;
    procedure changeplayer;
    procedure updatescore(const col,row:integer);
    procedure drawstone(const col,row:integer);
    procedure DrawAllStones;
    procedure findblocks;
    procedure drawboard;
    procedure copyboard (var source,dest:TBoard);
    function  sameboard({const} b1,b2:TBoard):boolean;
    procedure loadfile(filename:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{**********************************}
{********** TBlock methods ********}
{**********************************}

    {******** TBlock,Create *********}
    constructor TBlock.create;
    begin
      inherited;
      openedges:=0;
      color:=empty;
      id:=0;
      stonelist:=TStringlist.create;
      stonelist.sorted:=true;
      stonelist.duplicates:=dupignore;
    end;

    {********* TBlock.,Destrot *******}
    destructor TBlock.destroy;
    begin
      stonelist.free;
      inherited;
    end;

{**********************************}
{********* TForm1 Methods *********}
{**********************************}

{********* FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  boardcolor:=rgb(240,240,180); {tan?}
  resetboard;
  opendialog1.initialdir:=extractfilepath(application.exename);
  opendialog1.fileName:='';
  savedialog1.initialdir:=opendialog1.initialdir;
end;

{************** CopyBoard ***********}
procedure TForm1.copyboard (var source,dest:TBoard);
begin
  move(source,dest,sizeof(source));
end;

{************** SameBoard ***************}
function TForm1.sameboard({const} b1,b2:TBoard):boolean;
{tests two boards for any difference }
var
  i,j:integer;
begin
  result:=true;
  for i:=0 to vlines-1 do
  begin
    for j:= 0 to hlines-1 do
    begin
      if b1[i,j].occupiedby<>b2[i,j].occupiedby then
      begin
        result:=false;
        break;
      end;
    end;
    if not result then break;
  end;
end;

{************ DrawBoard **********}
procedure TForm1.drawboard;
{Draw empty board outline}
var
  i:integer;
  x,y:integer;
begin
  with image1,Canvas do
  begin
    brush.color:=boardcolor;
    rectangle(clientrect);

    for i:=0 to hlines-1 do
    begin
      y:= ystart+i*vincr;
      moveto(xstart,y);
      lineto(xstart+(vlines-1)*hincr,y);
    end;
    for i:=0 to vlines-1 do
    begin
      x:= xstart+i*hincr;
      moveto(x,ystart);
      lineto(x,ystart+(hlines-1)*vincr);
    end;
  end;
end;

{************** DrawStone ***************}
procedure TForm1.drawstone(const col,row:integer);
{Draw a single stone at "col", "row"}
var
  offsetxleft, offsetxright:integer;
  offsetyup, offsetydown:integer;
begin
 {this will draw the token on the board}
  with image1, canvas do
  begin
    if board[col,row].occupiedby=empty then
    begin
      brush.color:=boardcolor;
      pen.color:=boardcolor;
       ellipse(xstart+col*hincr-tokensizex,
           ystart+row*vincr-tokensizey,
           xstart+col*hincr+tokensizex,
           ystart+row*vincr+tokensizey);
      pen.color:=clblack;
      if col = 0 then offsetxleft:=0 else offsetxleft:=tokensizex;
      if col=vlines-1 then offsetxright:=0 else offsetxright:=tokensizex;
      if row = 0 then offsetyup:=0 else offsetyup:=tokensizey;
      if row=hlines-1 then offsetydown:=0 else offsetydown:=tokensizey;
      moveto(xstart+(col)*hincr-offsetxleft,
                     ystart+row*vincr);
      lineto(xstart+(col)*hincr+offsetxright,
                     ystart+row*vincr);
      moveto(xstart+(col)*hincr,
             ystart+row*vincr-offsetyup);
      lineto(xstart+(col)*hincr,
             ystart+row*vincr+offsetydown);
    end
    else
    begin
      If board[col,row].occupiedby=white then brush.color:=clwhite
      else brush.color:=clblack;
      ellipse(xstart+col*hincr-tokensizex,
           ystart+row*vincr-tokensizey,
           xstart+col*hincr+tokensizex,
           ystart+row*vincr+tokensizey);
     if modegrp.itemindex>0 then
     begin
       {display block numbers (for debugging)}
        If brush.color=clblack then font.color:=clwhite
        else font.color:=clblack;
        textout(xstart+col*hincr-3,ystart+row*vincr-4, inttostr(board[col,row].blocknbr));
        brush.color:=boardcolor;
      end;
    end;
  end;
end;

{************* DrawAllStones ***********}
procedure TForm1.DrawAllStones;
var
  i,j:integer;
begin
  for i:=0 to vlines-1 do
  for j:=0 to vlines-1 do
  drawstone(i,j);
end;


{*********** Image1MouseUp ***********}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{This is the signal to try to place a stone}
var
  col,row:integer;
   p1,p2: integer;
begin
  col:=x div hincr;
  row:=y div vincr;

  if  (button=mbRight) and (modegrp.itemindex>0) then
  begin
    board[col,row].occupiedby:=empty;
    board[col,row].blocknbr:=0;
    prevboard[playercolor][0,0].occupiedby:=invalid;
    drawstone(col,row);
  end
  else if (button=mbleft) and (board[col,row].occupiedby=empty) then
  begin     {a valid attempt to place a stone}
    copyboard(board,saveboard); {save the board}
    savescore:=score[playercolor]; {save the score}
    {try the move}
    board[col,row].occupiedby:=playerColor;
    p1:=score[playercolor];
    updatescore(col,row);  {try to make the move}
    p2:=score[playercolor];
    if board[col,row].occupiedby<>empty then {the move was not a suicide, so far so good}
    begin
      {make sure it's not a repeated position (Ko move)}
      if sameboard(board,prevboard[playercolor]) and (p2-p1=1) then  {Ko, repeated position not alllowed}
      begin {not allowed, restore  to pre-move state}
        copyboard(saveboard,board);
        score[playercolor]:=savescore;

        drawAllstones;  {redraw to show any blocks removed in error}
        showmessage('KO (immediate move to previous capture location not allowed)') ;
      end
      else
      begin
        copyboard(board,prevboard[playercolor]);
        changeplayer;
      end;
    end;
  end
  else showmessage('Already occupied')
end;

{************* PassBtnClick *******}
procedure TForm1.Button1Click(Sender: TObject);
begin
  prevboard[playercolor][0,0].occupiedby:=invalid; {ensure no Ko on next play this color}
  changeplayer;
end;



{************ ResetBoard ***********}
procedure TForm1.resetboard;
var i,j:integer;
begin
  case boardsizegrp.itemindex of
    0: begin
        hlines:=9;
        vlines:=9;
      end;
    1: begin
        hlines:=13;
        vlines:=13;
      end;
    2: begin
        hlines:=19;
        vlines:=19;
      end;
  end;
  {intialize internal board}
  for i:=0 to hlines-1  do
  for j:=0 to vlines-1 do
  with board[i,j] do
  begin
    occupiedby:=empty;
    blocknbr:=0;
    prevboard[black][i,j].occupiedby:=empty;
    prevboard[white][i,j].occupiedby:=empty;
  end;
  playerColor:=white;
  changeplayer;
  hincr:=image1.width div vlines;  {horizontal pixel spacing}
  tokensizex:= hincr div 2 -1;
  vincr:=image1.height div hlines; {vertical pixel spacing}
  tokensizey:= vincr div 2 -1;
  xstart:=hincr div 2;
  ystart:=vincr div 2;
  prevboard[black][0,0].occupiedby:=invalid;  {ensure first move does not look like a repeat}
  prevboard[white][0,0].occupiedby:=invalid;
  drawboard;
  score[white]:=0;
  score[black]:=0;
  {reset any previous block info}
  if nbrblocks>0 then for i:=0 to nbrblocks-1 do blocks[i].free;
  nbrblocks:=0;
  setlength(blocks,10);
end;

{*********** ChangePlayer ********}
procedure Tform1.changeplayer;
begin
  case modegrp.itemindex of
    0:
    begin
      nonplayerColor:=playerColor;
      if playerColor=white then playerColor:=black else playerColor:=white;
    end;
    1:
    begin
      nonplayercolor:=white;
      playercolor:=black;
    end;
    2:
    begin
      nonplayercolor:=black;
      playercolor:=white;
    end;
  end;{case}

  if playerColor=white then
  begin
    TurnLbl.caption:='White plays';
    shape1.brush.color:=clwhite;
  end
  else
  begin
    turnlbl.caption:='Black plays';
    shape1.brush.color:=clblack;
  end;
end;


{************ UpdateScore *********}
procedure TForm1.UpdateScore(const col,row:integer);
var
  i,j:integer;
  newscore:integer;
  possibleSuicide:boolean;  {set true if played stone group would be surrounded,
                             if an opponent's block is captured, this is valid}
  s:string;
  col2,row2:integer;
begin  {UpdateScore}
  {update score for player  whose turn it is}
  newscore:=0;
  possibleSuicide:=false;
  {first reasign all the blocks}
  findblocks;

  {Now remove all adjoining blocks with no open edges of opposite color and add removed stones to score}
  i:=0;
  while i<=nbrblocks-1 do
  with blocks[i] do
  begin
    if openedges=0 then
    begin
      if (color<>board[col,row].occupiedby)  {and (openedges=0)} then
      begin  {remove the block}
        newscore:=newscore+stonelist.count;
        for j:=0 to stonelist.count-1 do
        with stonelist do
        begin
          s:=strings[j];
          col2:=strtoint(copy(s,1,2));
          row2:=strtoint(copy(s,3,2));
          with board[col2,row2] do
          begin
            prevboard[playercolor][col2,row2].occupiedby:=empty;
            occupiedby:=empty;
            blocknbr:=0;
            drawstone(i,j);
          end;
        end;
        blocks[i].free;
        for j:=i to nbrblocks-2 do blocks[j]:=blocks[j+1];
        dec(nbrblocks);
      end
      else
      begin
        {my block is surrounded, not allowed unless I capture opponent's block}
        if color=board[col,row].occupiedby then possiblesuicide:=true;
        inc(i);
      end;
    end
    else inc(i);
  end;

  if (newscore =0) and (possibleSuicide) then
  {played stone completed a block of my color and did not result in any other block being removed}
  begin {retract the move}
    board[col,row].occupiedby:=empty;
    board[col,row].blocknbr:=0;
    showmessage('Suicide not allowed');
    {make sure next move of other color shows a change, i.e. not a Ko}
    prevboard[playercolor][0,1].occupiedby:=invalid;
  end;

  DrawAllStones;{Redraw the stones}
  inc(score[playercolor],newscore);
  whitescorelbl.caption:=inttostr(score[white]);
  blackscorelbl.caption:=inttostr(score[black]);
end;


{***************  ResetBtnClick **********8}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  resetboard;
end;

{************ BoardSizeGrpClick **********}
procedure TForm1.BoardSizeGrpClick(Sender: TObject);
begin
  resetboard;
end;

{********** ModeGrpClick ********}
procedure TForm1.modegrpClick(Sender: TObject);
var
  i,j:integer;
begin
  if modegrp.itemindex=0 then playercolor:=white;  {to force start with black for normal play}
  for i:=0 to hlines-1  do
  for j:=0 to vlines-1 do  drawstone(i,j);
  prevboard[black][0,0].occupiedby:=invalid;
  prevboard[white][0,0].occupiedby:=invalid;
  changeplayer;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************* UndobtnClick *************}
procedure TForm1.UndoBtnClick(Sender: TObject);
begin
  copyboard(saveboard,board);
  score[nonplayercolor]:=savescore;
  whitescorelbl.caption:=inttostr(score[white]);
  blackscorelbl.caption:=inttostr(score[black]);
  drawAllstones;
  changeplayer;
  prevboard[black][0,0].occupiedby:=invalid;
  prevboard[white][0,0].occupiedby:=invalid;
end;

{************ SaveBtnClick ***********}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  i,j:integer;
  f:textfile;
begin
  If savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    {1st line of output file will contain board sixe, current player color, mode,
     and scores for black and whiite}
    writeln(f,boardsizegrp.itemindex, ' ', ord(playercolor), ' ',modegrp.itemindex,
                ' ', score[black], ' ', score[white]);
    {Rest of file is contents of each board cell}
    for i:=0 to hlines-1 do
    for j:=0 to vlines-1 do
    with board[i,j] do writeln(f,ord(occupiedby), ' ',blocknbr);
    closefile(f);
  end;
end;

{************* LoadbtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  image1.onmouseup:=nil;  {keep double click in opedialog from registering as a
                           move on the Go board.  (Delphi bug?)}
  If opendialog1.execute then
  begin
    loadfile(opendialog1.filename);
    application.processmessages; {Let mouse up message get processed}
  end;
  image1.onmouseup:=Image1MouseUp;
end;

{************* LoadFile **********}
procedure TForm1.loadfile(filename:string);
var
  i,j,k,b,w:integer;
  f:textfile;
  stonecolor:integer;
begin
  assignfile(f,opendialog1.filename);
  reset(f);
  readln(f,i,j,k,b,w);
  boardsizegrp.itemindex:=i;
  resetboard;
  playercolor:=TStonecolor(j);
  score[black]:=b;
  score[white]:=w;
  modegrp.itemindex:=k;
  for i:=0 to hlines-1 do
  for j:=0 to vlines-1 do
  with board[i,j] do
  begin
    readln(f,stonecolor, blocknbr);
    occupiedby:=TStonecolor(stonecolor);
  end;
  closefile(f);
  drawallstones;
  whitescorelbl.caption:=inttostr(score[white]);
  blackscorelbl.caption:=inttostr(score[black]);
end;

{************ ReloadBtnClick **************}
procedure TForm1.ReloadBtnClick(Sender: TObject);
begin
  if opendialog1.filename<>'' then loadfile(opendialog1.FileName);
end;


{*********** FindBlocks ************}
procedure tform1.findblocks;
  {Identifies and initializes new blocks }
  {calls recursive "findblocksfrom "routine to extend block in all four directions}


      {************ FindBlocksFrom  ***********}
      procedure findblocksfrom(col,row:integer);
         {recursive routine to extend block in all four direction}
         {counts stones and open edges in each block}
         {add block to blocks array}
         var
           c1,r1:integer;
           index:integer;


         function check(c1,r1:integer; msg:string):boolean;
         begin
           result:=false;
           with blocks[nbrblocks-1] do
           if (board[c1,r1].occupiedby=board[col,row].occupiedby)
           then
           begin
             if (board[c1,r1].blocknbr<>board[col,row].blocknbr)
             then
             begin
               if board[c1,r1].blocknbr=0 then {same color and tested cell is not assigned to a block}
               begin
                 board[c1,r1].blocknbr:=board[col,row].blocknbr;
                 stonelist.add(format('%2d%2d',[c1,r1]));
                 result:=true;
               end
               else showmessage(format('Block %s (%2d,%2d) already assigned to different block',
                                     [msg,col,row]) );
             end
             else if not stonelist.find(format('%2d%2d',[c1,r1]),index)
                  then
                  begin
                    stonelist.add(format('%2d%2d',[c1,r1]));
                    result:=TRUE;
                  end;
           end
           else if board[c1,r1].occupiedby=empty then inc(openedges);
         end;  {check}

         begin {findblocksfrom}
           {checkl left}
           c1:=col-1;  r1:=row;
           if (c1>=0) and (check(c1,r1,'left of')) then findblocksfrom(c1,r1);

           {checkl up}
           c1:=col; r1:=row-1;
           if (r1>=0) and (check(c1,r1,'above')) then findblocksfrom(c1,r1);

           {check right}
           c1:=col+1; r1:=row;
           if (c1<vlines) and (check(c1,r1,'right of')) then findblocksfrom(c1,r1);

           {check down}
           c1:=col; r1:=row+1;
           if (r1<hlines) and (check(c1,r1,'below')) then findblocksfrom(c1,r1);
         end; {findblocksfrom}

var
  i,j:integer;
begin {findblocks}
  {first forget about all old block numbers}
  for i:=0 to vlines-1 do
  for j:= 0 to hlines-1 do
  with board[i,j] do
  begin
    blocknbr:=0;
  end;
  {clear block objects array}
  for i:=0 to nbrblocks-1 do blocks[i].free;
  nbrblocks:=0;
  {now assign new block numbers}
  for i:=0 to vlines-1 do
  for j:= 0 to hlines-1 do
  if board[i,j].occupiedby<>empty then
  begin
    if board[i,j].blocknbr=0 then
    begin {start a new block}
      inc(nbrblocks);
      if nbrblocks<length(blocks) then setlength(blocks,nbrblocks+10);
      blocks[nbrblocks-1]:=TBlock.create;
      with blocks[nbrblocks-1] do
      begin
        id:=nbrblocks;
        color:=board[i,j].occupiedby;
        stonelist.add(format('%2d%2d',[i,j])); {add first stone to stonelist}
        board[i,j].blocknbr:=nbrblocks;
        findblocksfrom(i,j);
      end;
    end;
  end;
end;

end.
