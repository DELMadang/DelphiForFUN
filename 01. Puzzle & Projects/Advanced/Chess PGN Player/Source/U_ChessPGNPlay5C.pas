Unit U_ChessPGNPlay5C;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Version 1: Generate chess board and  pieces}
{Version 2: Read PGN files, allow game selection, extract moves for replay}
{Version 3: Implement PGN replay of extracted moves}
{Version 4:  Add move "Undo" feature,
             Fix missing move code handlers e.g. R3b6}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, strutils, Buttons,inifiles;

type
  TPieceKind=(P,N,B,R,Q,K,E);

  TPiece=class(TImage)
  public
    Loc:TPoint;
    Kind:TPieceKind;
    Pcolor:char;
    constructor create(newparent:TWincontrol;
               newkind:TPiecekind; newcolor:char;
               newloc:TPoint;Psize:integer; baseimages:TImage);   reintroduce;
    procedure assign(Proto:TPiece); reintroduce;
  end;

  TBoard = record
    B:array[0..7,0..7] of TPiece;
  end;

  TGamerec=record
    id:string;
    namelist:TStringlist;
    movestr:String;
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    SelectSheet: TTabSheet;
    PGNSheet: TTabSheet;
    Memo1: TMemo;
    LoadBtn: TButton;
    StaticText2: TStaticText;
    BaseImage: TImage;
    MoveList: TListBox;
    Label1: TLabel;
    BoardPanel: TPanel;
    OpenDialog1: TOpenDialog;
    IDList: TMemo;
    PGNMoveList: TMemo;
    GameBox: TComboBox;
    UndoBtn: TBitBtn;
    MoveBtn: TBitBtn;
    ResetBtn: TButton;
    BeforeLbl: TLabel;
    AfterLbl: TLabel;
    NextMoveLbl: TLabel;
    PrevMoveLbl: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    File_GameText: TStaticText;
    Panel1: TPanel;
    debugbox: TCheckBox;
    DefaultBox: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure GameBoxClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure PGNSheetEnter(Sender: TObject);
    procedure MoveListDblClick(Sender: TObject);
    procedure debugboxClick(Sender: TObject);
    procedure DefaultBoxClick(Sender: TObject);
  public
    { Public declarations }
    //PGNList:TStringlist;
    Wpiece, BPiece:array [P..K] of tPiece;
    emptyPiece:TPiece;
    Board:TBoard;
    filename:string;
    
    games:array of TGamerec;
    gamecount:integer;

    movecount:integer;

    check,checkmate:boolean;
    takes:boolean;
    enpassantloc:TPoint;
    errflag: boolean;
    side:char;
    undolist:TStringlist;

    procedure makeboard;
    procedure makepieces;
    procedure resetpieces;

    procedure movepiece(fromloc,toloc:TPoint); overload;
    procedure movepiece(fromloc,toloc:TPoint; special:string); overload;

    procedure Clearlist(list:TStringlist);

    procedure Loadgames(fname:string);
    procedure error(msg:string);

    Function FindFromPiece(side:char; Piece:Char; ToLoc:TPoint;
                           takes:boolean; sourceRowOrCol:char):TPoint; //overload;

    function KingsideCastle(side:char):boolean;
    function QueensideCastle(side:char):boolean;

    procedure DebugCounts(n:integer);
    procedure ShowMoveLbls;
    procedure setdefault(fname:string; gameindex:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses DFFUtils;

const
  white=clWhite;
  bg=clOlive;
  psize=64;
  InitPieces:array[0..7] of TPieceKind =(R,N,B,Q,K,B,N,R);
  PieceStrings:array[0..6] of char=('P','N','B','R','Q','K','E');
  Rook:TPieceKind=R; {necessary because, by accident, R is TPiecekind and a variable name} 
  dxN:array[1..8] of integer =(-2,-2,-1,-1,+1,+1,+2,+2);
  dyN:array[1..8] of integer =(-1,+1,-2,+2,-2,+2,-1,+1);
  dx:array [1..8] of integer=(-1,-1,-1, 0, 0,+1,+1,+1);
  dy:array [1..8] of integer=(-1, 0,+1,+1,-1,-1, 0, +1);

function getword(str:string; nbr:integer):string;
var
  k,n:integer;
  s:string;
begin
  s:=trim(str)+' ';
  result:='';
  if length(s)=1 then exit; {empty string was passed}
  k:=0;
  repeat
    n:=pos(' ',s);
    if n>0 then
    begin
      inc(k);
      if k=nbr then result:=copy(s,1,n-1)
      else
      begin
        delete(s,1,n);
        s:=trimleft(s);
      end;
    end;
  until (k=nbr) or (s='');
end;

function valid(n:integer):boolean;
{check than n is a valid column or row number}
    begin
      result:=(n>=0) and (n<=7);
    end;


constructor TPiece.create(newparent:TWincontrol;newkind:TPiecekind;
         newcolor:char; newloc:TPoint;psize:integer;baseimages:TImage);
var
  x,y:integer;
begin
  inherited create(newparent);
  parent:=newparent;
  height:=Psize;
  width:=Psize;
  kind:=newkind;
  Pcolor:=newcolor;
  with newloc do
  begin
    left:=x;
    top:=y;
    if (x+y) mod 2 =0 then canvas.brush.color:=white else canvas.brush.color:=bg;
  end;
  x:=ord(kind)*psize;
  If pcolor='W' then y:=0
  else y:=psize; {black pieces defined in 2nd row within baseimages}
  if kind<>e then
  begin
    canvas.Rectangle(rect(0,0,psize,psize));
    canvas.copyrect(rect(1,1,psize-2,psize-2),baseimages.canvas,
                    rect(x+1,y+1,x+psize-2,y+psize-2));
  end
  else canvas.Rectangle(rect(0,0,psize,psize));
end;

{********* TPiece.assign ***********}
Procedure TPiece.assign(proto:TPiece);
begin
  inherited picture.assign(proto.picture);
  Pcolor:=proto.pColor;
  kind:=proto.kind;
  if ((left+top) div psize)  mod 2 =0 then canvas.brush.color:=white else canvas.brush.color:=bg;
  if kind<>e then  canvas.floodfill( 2,2,clblack, fsborder)
  else canvas.Rectangle(rect(0,0,psize,psize));
end;

{************ MakeBoard ***********}
procedure TForm1.makeboard;
var i,j:integer;
    x,y:integer;
    cellsize:extended;
begin
  for i:=0 to 7 do
  for j:=0 to 7 do
  with Panel1 do
  begin
    x:=Psize*i;
    y:=PSize*j;
    board.b[i,j]:=TPiece.create(Panel1,E,' ',point(x,y),psize,nil);
    with board.b[i,j].canvas do
    begin
      if (i+j) mod 2 =0 then brush.color:=White else brush.color:=Bg;
      rectangle(rect(0,0,psize, psize));
    end;
  end;
  {do the ranks and file lables}
  for i:=1 to 8 do
  begin
    {Make the bottom horizontal alpha column label}
    cellsize:=panel1.width/8;
    with (TLabel.create(boardPanel)) do
    begin
      parent:=boardpanel;
      font.Size:=18;
      caption:=char(ord('a')+i-1);
      {center the letter under the column}
      left:=panel1.Left+trunc((i-1)*cellsize+(cellsize-width)/2);
      top:=panel1.Top+panel1.Height;
    end;
    with (TLabel.create(boardPanel)) do
    begin
      parent:=boardpanel;
      font.Size:=18;
      caption:=inttostr(i);
      {center the number left of the column}
      top:=panel1.Top+panel1.Height- trunc((i)*cellsize-(cellsize-height)/2);
      left:=panel1.left-canvas.textwidth('8')-4;
    end;
  end;
end;

{********** MakePieces ***********}
Procedure TForm1.MakePieces;
{Extract the 12 basic piece shapes from "baseimage", 6 white in the 1st row and
 6 black in the 2nd row in order [Pawn, Knight, Bishop, Rook, Queen, King]}

var
  i:TPieceKind;
begin
  for i:= P to K do
  begin
    BPiece[i]:=TPiece.create(Panel1,i,'B',point(0,0),psize,BaseImage);
    WPiece[i]:=TPiece.create(Panel1,i,'W',point(0,0),psize,BaseImage);
  end;
  emptypiece:=TPiece.create(Panel1,E,' ',point(0,0),psize,nil);
end;



{********** ResetPieces ********}
Procedure TForm1.resetpieces;

  {------------ SetRow ------------}
  procedure setrow(r:integer; color:char);
  {Set initial rows of piece images}
  var c:integer;
  begin
    with board do
    for c:=0 to 7 do
    begin
      case color of
       'W': b[c,7-r].assign(WPiece[initpieces[c]]);
       'B': b[c,7-r].assign(BPiece[initpieces[c]]);
      end;
    end;

  end;

   {------------ SetPawnRow ------------}
  procedure setPawnrow(r:integer; color:char);
  {Set initial rows of piece images}
  var c:integer;
  begin
    with board do
    for c:=0 to 7 do
    begin
      case color of
       'W': b[c,7-r].assign(WPiece[P]);
       'B': b[c,7-r].assign(BPiece[P]);
      end;
    end;
  end;

var
  i,j:integer;
begin {resetpieces}
  for i:=0 to 7 do for j:=0 to 7 do board.b[i,j].assign(Emptypiece);
  setrow(0,'W'); {Set uo initial row of white pieces}
  setrow(7,'B'); {Initial row of black pieces}
  setPawnRow(1,'W'); {Initial row of white pawns}
  setPawnRow(6,'B'); {Initial row of black pawns}
  movecount:=0;
  movelist.itemindex:=0; {move to the start}
  undolist.Clear;
  if movelist.count>0 then showMoveLbls;
end;

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
var f:string;
    ini:TInifile;
    gameindex:integer;
begin
  UndoList:=TStringlist.Create;
  MakePieces;
  Makeboard;
  ini:=TInifile.create(extractfilepath(application.ExeName)+'ChessPGN.ini');
  with ini do
  begin
    f:=extractfilepath(application.exename)+'Kasparov - OK.pgn';
    self.filename:=readstring('General','Filename',f);
    gameindex:=readinteger('General','GameIndex', 0);
    gamecount:=-1;
    if fileexists(self.filename) then
    begin
      loadgames(self.filename);
      gameBox.itemindex:= gameindex;
      setdefault(self.filename,gameindex);
      resetBtnClick(sender);
      Pagecontrol1.activepage:= PGNSheet;
    end;
    Resetpieces;
  end;
  ini.free;
end;

{*********** ClearList **************}
procedure TForm1.Clearlist(list:TStringlist);
{Empt a stringlist where entry entry may conain stringlist objects}
var i:integer;
begin
  with list do
  for i:=0 to count-1 do
  if assigned(TStringlist(objects[i])) then TStringlist(objects[i]).free;
  list.clear;
end;

{************ LoadBtnClick *************}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  if opendialog1.execute then loadgames(opendialog1.FileName);
end;

{************* Loadgames ***************}
procedure TForm1.Loadgames(fname:string);
var
  templist:TStringlist;
  i,n,k:integer;
  event, date, round:string;
  whitename, blackname, WhiteLname, BlackLName:string;
  w,d:string;
  line:string;
  nextevent:boolean;

      {------------ GetQuotedLine -------------}
      function getquoted(line:string):string;
      {extract the string between double quote marks}
      var
        n1,n2:integer;
      begin
        result:='';
        n1:=pos('"',line);
        if n1>0 then
        begin
          n2:=posex('"',line, n1+1);
          if n2>0 then result:=copy(line,n1+1, n2-n1-1);
        end;
      end;
            
  begin {Loadgames}
    filename:=fname;
    templist:=TStringlist.Create;
    templist.LoadFromFile(filename);
    if gamecount>=0 then
    for i:=0 to gamecount do
    with games[i] do
    begin
      freeandnil(namelist);
      moveStr:='';
    end;
    gamebox.clear;
    errflag:=false;
    gamecount:=-1;
    setlength(games,100);
    i:=0;
    repeat
      line:=trim(templist[i]);
      if length(line)>6 then
      begin
        if AnsiContainstext(line,'[Event ') then
        begin
          inc(gamecount);
          if gamecount>high(games)
          then setlength(games, gamecount+100);
          with games[gamecount] do
          begin
            if assigned(namelist) then namelist.free;
            namelist:=TStringlist.create;
            moveStr:='';
            NextEvent:=false;
            event:='';
            date:='';
            round:='';
            whitename:='';
            blackname:='';
            repeat
              if ansicontainstext(line,'[') then
              begin
                n:=pos(' ',line);
                w:=copy(line,2,n-2);
                d:=getquoted(line);
                if sametext(w,'Event') then event:=d
                else if sametext(w,'Date') then date:=d
                else if sametext(w,'Round') then  round:=d
                else if sametext(w,'White') then
                begin
                  whiteLname:=d;
                  n:=pos(',',d);
                  if n>0 then whiteLName:=copy(d,1,n-1)
                end
                else if sametext(w,'Black') then
                begin
                  blackLname:=d;
                  n:=pos(',',d);
                  if n>0 then BlackLName:=copy(d,1,n-1);
                end;
                Namelist.add(w+': '+d);
              end
              else movestr:=movestr+' '+line;{should be moves or comments data}
              inc(i);
              if i<templist.count then
              begin
                line:=templist[i];
                if ansicontainstext(line,'[Event ')
                then nextevent:=true;
              end;
            until  nextevent or (i>=templist.count);
            id:=format('%s vs. %s, Event:%s, Round:%s  %s',
                [whiteLname, blackLname, event, round, date]);
            GameBox.items.add(id);
          end;
        end; {event}
      end
      else inc(i); {line was short or blank or unknown type}
    until i>=templist.count;
    setlength(games,gamecount+1);
    templist.Free;
    {select the first game as default}
    gamebox.itemindex:=0;
    gameboxclick(self);
   File_Gametext.caption:='File: '+filename
             +'   Game: '+gamebox.items[gamebox.itemindex];
  end; {Loadgames}


{************* MovePiece (normal)**************}
procedure TForm1.movepiece(fromloc,toloc:TPoint);
begin
  movepiece(fromloc, toloc, '');
end;

{************* MovePiece {special)*************}
procedure TForm1. MovePiece(fromloc,toloc:TPoint; special:string);
var n:int64;
    promotekind:TPiecekind;
    promoteflag:boolean;
    s:string;

    {------------PieceCharToKind ----------}
    function piecechartokind(c:char):TPiecekind;
    {Given a letter, return the TPieceKind}
    var
      i:integer;
    begin
      result:=E;
      for i:=0 to high(PieceStrings) do
      if c=piecestrings[i] then
      begin
        result:=TPieceKind(i);
        break;
      end;
    end;

begin {MovePiece}
  with board do
  if valid(fromloc.x) and valid(7-fromloc.y) and valid(toloc.x) and valid(7-toloc.y) then
  begin
    if (length(special)=2) and (special[1]='=') then
    begin
      promoteflag:=true;
      promotekind:=piecechartokind(special[2]);
    end
    else promoteflag:=false;

    {encode piece replaced and toloc and fromloc as a 5 digit integer string for use in undoing moves}
    if (special='') or ((length(special)=2) and (special[1]='='))
    then
    begin
      if ((length(special)=2) and (special[1]='='))  then  s:='=' else s:='';
      undolist.Add(s+
         inttostr(10000*ord(b[toloc.X,7-toloc.Y].Kind)+1000*toloc.X
                 +100*(7-toloc.Y)+10*fromloc.X+(7-fromloc.Y)));
    end
    else if special='En Passant' then
    begin
      n:=1000000*enpassantloc.X
         +100000*enpassantloc.y
         +10000*ord(b[toloc.X,7-toloc.Y].Kind)
         +1000*(toloc.X)
         +100*(7-toloc.Y)+10*fromloc.X+(7-fromloc.Y);
      undolist.add(inttostr(n));
    end
    else undolist.add(special);

    b[toloc.x,7-toloc.y].assign(b[fromloc.x,7-fromloc.y]);{return piece}
    if promoteflag then
    with toloc do {assign the promotion piece over the pawn}
    if b[x,7-y].pcolor='W' then b[x,7-y].assign(WPiece[promotekind])
    else b[x,7-y].assign(BPiece[promotekind]);
    b[fromloc.x, 7-fromloc.y].assign(emptypiece); {empty the "from" location}
  end;
  inc(movecount);
end;

{*********** SetDefault ************}
procedure TForm1.setdefault(fname:string; gameindex:integer);
{Set the game to be loaded upon initial program entry}
var
  ini:TInifile;
begin
  ini:=TInifile.create(extractfilepath(application.ExeName)+'ChessPGN.ini');
  with ini do
  begin
    writestring('General','Filename',fname);
    writeinteger('General','GameIndex',gameindex);
  end;
  ini.free;
end;

{************ GameBoxClick ************}
procedure TForm1.GameBoxClick(Sender: TObject);
{User selected a game to play back}
var
  i:integer;
  n,n2,ns,ne:integer;
  endquote:integer;
  move:string;
begin
  IdList.clear;
  PGNMoveList.clear;
  with games[gamebox.itemindex] do
  begin
    {Display all of the If information}
    for i:=0 to namelist.count-1 do
    IdList.lines.add(namelist[i]);
    IdList.Lines.add('Moves: '+movestr);
    move:=movestr+'.'; {add an extra "." at end of move text as a stopper}
    {extract moves from MoveStr to PGNMoveList.lines}
    n:=pos('.',move); {dots appear after move numbers and before the move}
    {remove comments}
    for i:=length(move) downto 1 do
    begin
      if move[i]='}' then endquote:=i
      else if move[i]='{' then
      begin
        if endquote>0 then  system.delete(move,i,endquote-i+1);
        endquote:=0;
      end;
    end;
    while n>0 do
    begin
      ns:=n-1;
      while (ns>0) and (move[ns] in ['0'..'9']) do dec(ns);
      n2:=posex('.',move,n+1); {find the next move # position}
      if n2=0 then break;
      {fix missing blank after rule #}
      if (length(move)>n2) and (move[n2+1]<>' ') then insert(' ',move,n2+1);
      ne:=n2-1;
      while move[ne] in ['0'..'9'] do dec(ne); {back up over the "next" move #}
      PGNMoveList.lines.add(trim(copy(move,ns+1, ne-ns-1))); {extract the move}
      n:=n2;
    end;
    movetotop(PGNMovelist);
    movetotop(IdList);
    MoveList.Items.Assign(PGNMoveList.Lines); {copy moves to the "Play game" page}
    Movelist.ItemIndex:=0;
    resetPieces;
    File_Gametext.caption:='File: '+filename
             +'   Game: '+gamebox.items[gamebox.itemindex];
    if defaultbox.checked
    then setdefault(filename, gamebox.itemindex);
  end;
end;



procedure TForm1.error(msg:string);
begin
  showmessage(msg);
  errflag:=true;
end;

procedure TForm1.DebugCounts(n:integer);
begin
  case n of
  1: beforelbl.caption:=format('Before action'
                               +#13+ 'MoveList Index=%d'
                               +#13+'Movecount=%d'
                               +#13+'UndoList count=%d',
                               [Movelist.itemindex, Movecount, Undolist.count]);
  2: afterlbl.caption:=format('After action'
                               +#13+ 'MoveList Index=%d'
                               +#13+'Movecount=%d'
                               +#13+'UndoList count=%d',
                               [Movelist.itemindex, Movecount, Undolist.count])
  end;
end;
(*
begin {disambiguation, piece moved is in col m[2] and moving to m[3]}
          r2:=strtoint(m[4])-1;
          c2:=ord(m[3])-ord('a');
          toLoc:=point(c2,r2);
          enpassantloc.x:=-1;
          fromLoc:=findfrompiece(side, m[1], toloc, takes, m[2] ); {overload to pass the source column}
        end;
        if fromloc.X >=0 then
        if enpassantloc.x>=0 then movepiece(fromloc, toloc,'En Passant')
        else movepiece(fromloc, toloc);
*)
{*************** MoveBtnClick *************}
procedure TForm1.MoveBtnClick(Sender: TObject);
var
  mm,m:string;

  fromLoc,ToLoc:TPoint;
  //check,checkmate:boolean;
  c2,r2,n:integer;
  rulestr:string;
begin
  debugcounts(1);
  with movelist do
  begin
    mm:=movelist.items[movelist.itemindex];
    n:=pos('.',mm);
    if n>0 then system.insert(' ',mm,n+1)  {ensuire that there is a space after the move number}
    else
    begin
      error(format('Invalid move entry "%s".  Missing rule # or "."',[mm]));
      exit;
    end;
    if length(mm)=0 then exit;
    rulestr:=getword(mm,1);
    if movecount mod 2 = 0 then side:='W' else side:='B';
    if side='W' then  m:=getword(mm,2) else
    begin
      m:=getword(mm,3);
      if length(m)=0 then exit;
      movelist.itemindex:=movelist.itemindex+1; {move to the next entry}
    end;

    if m[1] in ['a'..'h'] then m:='P'+m;

    if length(m)>2 then
    begin
      takes:=false;
      if m[2]='x' then
      begin
        Takes:=true;
        delete(m,2,1);
      end;
      if (m[2] in ['a'..'h','1'..'8']) then
      begin
        if m[3]='x' then
        begin
          Takes:=true;
          delete(m,3,1);
        end;
        enpassantloc.x:=-1;
        if (m[2]in['a'..'h']) and (m[3] in ['1'..'8']) then
        begin
          r2:=strtoint(m[3])-1;
          c2:=ord(m[2])-ord('a') ;
          if (board.B[c2,7-r2].kind<>E) and (not takes) then
          begin
            error(format('Rule %s (%s): Target location %s occupied but "take" not specified',[rulestr,SIDE,m]));
          end
          else
          begin
            toLoc:=point(c2,r2);
            fromLoc:=findfrompiece(side, m[1], toloc, takes,' ');
          end;
        end
        else if m[3]in ['a'..'h'] then
        begin {disambiguation, piece moved is in col m[2] and moving to m[3]}
          r2:=strtoint(m[4])-1;
          c2:=ord(m[3])-ord('a');
          toLoc:=point(c2,r2);
          fromLoc:=findfrompiece(side, m[1], toloc, takes, m[2] ); {overload to pass the source column}
        end;
        if fromloc.X >=0 then

        {check for promotion and pass = + piece letter (e.g. "=Q")as special code}
        if pos('=',m)>0 then movepiece(fromloc,toloc,copy(m,length(m)-1,2))
        else if enpassantloc.x>=0 then movepiece(fromloc, toloc,'En Passant')
        else movepiece(fromloc, toloc);
      end
      else
      if m='O-O' then  Kingsidecastle(side)
      else if m='O-O-O' then Queensidecastle(side);
       //check:=false;
      //checkmate:=false;

      //if m[length(m)]='+' then check:=true
      //else  if m[length(m)]='#' then checkmate:=true;
    end;
  end;
  debugcounts(2);
  showmovelbls;
end;



  {***************  FindFromPiece (source column) *****************}
Function TForm1.FindFromPiece(side:char; Piece:Char; ToLoc:TPoint;
                       takes:boolean; sourceRowOrCol:char {integer}):TPoint;
    {Given a side ('W' or 'B;), and a Piece (P,N,B,R,Q,K), and the targeet location,
     find where the piece is setting now}

var
  sourcecol,sourcerow:integer;

        {--------------- OnPath ----------------}
        function onpath(cc,rr:integer; testkind:TPiecekind; side:char;
                         dx,dy:integer; var newloc:Tpoint):boolean;
        var
          c,r:integer;
          done:boolean;
        begin
          c:=cc; r:=rr;
          newloc.X:=-1;
          done:=false;
          with board do
          repeat
            inc(c,dx);
            inc(r,dy);
            if (not valid(c)) or (not valid(7-r)) then done:=true
            else
            with b[c,7-r] do
            begin
              if (kind=testkind) and (PColor=side) then
              begin
                if ((sourcecol<0) and (sourcerow<0)) or
                    (sourcecol=c) or (sourcerow=r) then
                begin
                  newloc.X:=c;
                  newloc.Y:=r;
                  done:=true;
                end;
              end
              else if (kind<>E) and (not takes) then done:=true;
            end;
          until done;
          result:=newloc.x<>-1;
       end;



     var
       c,r:integer;
       i:integer;
       newloc:TPoint;
       yOff:integer;
     begin
       c:=toloc.x;
       r:=toloc.Y;
       sourcecol:=-1;
       sourcerow:=-1;
       if  sourceroworcol in ['a'..'h'] then sourcecol:=ord(sourceroworcol)-ord('a')
       else if sourceroworcol in ['1'..'8'] then sourcerow:=strtoint(sourcerowOrCol)-1;
       case Piece of
         'P':  with board do
         begin {Pawn must be in "to" row-1 or row-2}
           if side='W' then yoff:=-1 else yoff:=+1;
           if not takes then
           begin
             with b[c,7-(r+yoff)] do
             if (kind=P) and (Pcolor=side) then  r:=r+yoff
             else with b[c,7-(r+2*yoff)] do
             if (b[c,7-(r+yoff)].kind=E) and (kind=P) and (Pcolor=side)
             then r:=r+2*yoff;
           end
           else {Capture move}
           begin
             enpassantloc.x:=-1;
             with b[sourcecol,7-(r+yoff)] do
             if (kind=P) and (Pcolor=side) then
             begin
               {Check for "En Passant"}
               {if toloc is empty and fromloc is a white pawn and
                the piece in fromloc.x and toloc.y is a black pawn then
                this is an "en passant" capture and we can pretend that the
                black pawn was in toloc.  The undo location for the piece though
                must be its current real location.  Whew!}
               if  b[c,7-r].kind = E then
               begin  {The take location is empty, this had better
                                        be an "en passant" or else it is an error!}
                 with b[c,7-(r+yoff)] do
                 if (kind=P) and (not (PColor=side)) then
                 begin
                   enpassantloc:=point(c,7-(r+yoff));
                   b[c,7-(r+yoff)].assign(emptypiece);
                   c:=sourcecol;
                   r:=r+yoff;
                 end
                 else error('Invalid "en passant" capture specified');
               end
               else
               begin
                 c:=sourcecol;
                 r:=r+yoff;
               end;
             end
           end;
         end;
         'N':  with board do
         begin
           {Knight of the same color must be in one of 8 locations}
           for i:=1 to 8 do
           if valid(c+dxN[i]) and valid(7-(r+dyN[i])) then
           begin
             with b[c+dxN[i],7-(r+dyN[i])] do
             if (kind=N) and (Pcolor=side)
                and ((sourcecol<0) or (sourcecol=c+dxN[i])) then
             begin
               c:=c+dxN[i];
               r:=r+dyN[i];
               break;
             end;
           end;
         end;

         'B':
         begin

           {Bishop of same color must be on a clear path in one of 4 diagonal directions}
           newloc.x:=-1;
           if not onpath(c,r,B,side,-1,-1, newloc)
           and not onpath(c,r,B,side,-1,+1, newloc)
           and not onpath(c,r,B,side,+1,-1, newloc)
           and not onpath(c,r,B,side,+1,+1, NEWLOC) then error('Bishop move failed');
           if newloc.x>=0 then
           begin
             c:=newloc.x;
             r:=newloc.y;
           end;
         end;
         'R':
         begin with board do
           {Rook of same color must be on a clear path in one of 4
           horizontal or vertical directions}
           newloc.x:=-1;

           If  not onpath(c,r,Rook,side,0,-1, newloc)
           and not onpath(c,r,Rook,side,0,+1, newloc)
           and not onpath(c,r,Rook,side,+1,0, newloc)
           and not onpath(c,r,Rook,side,-1,0, newloc) then error('Rook move move failed');
           if newloc.x>=0 then
           begin
             c:=newloc.x;
             r:=newloc.y;
           end;
         end;

         'Q':
         begin
           {Queen of same color must be on a clear path in one of 8  directions}
           with board do
           for i:=1 to 8 do
           begin
             if onpath(c,r,Q,side,dx[i],dy[i],newloc) then break;
           end;
           if   newloc.x>=0 then
           begin
             c:=newloc.x;
             r:=newloc.y;
           end;
         end;
         'K':
         begin
           newloc.X:=-1;
           with board do
           for i:=1 to 8 do
           if valid(c+dx[i]) and valid(r+dy[i]) then
           begin
             with b[c+dx[i],7-(r+dy[i])] do if (kind=K) and (PColor=side)
             then
             begin
               newloc:=point(c+dx[i],(r+dy[i]));
               break;
             end;
           end;
           if   newloc.x>=0 then
           begin
             c:=newloc.x;
             r:=newloc.y;
           end;
         end;
       end; {case}
       result.x:=c;
       result.y:=r;
     end;


  {************* KingSideCastle *************}
  function TForm1.KingsideCastle(side:char):boolean;
  var row:integer;
  begin
    result:=false;
    if side='W' then row:=7 else row:=0;
    begin  {e1=K, f1=E, g1=E, h1=(W)R}
      with board do
      begin
        if (b[4,row].kind=K) and (b[4,row].Pcolor=side)
        and (b[5,row].kind=E)and (b[6,row].kind=E)
        and (b[7,row].kind=R)and (b[7,row].PColor=side) then
        begin
          movepiece(point(4,7-row),point(6,7-row));
          movepiece(point(7,7-row),point(5,7-row),side+'O-O'); {flag castle for undo checking}
          dec(movecount); {only count as 1 move}
          result:=true;
        end;
      end;
    end;
  end;

  {************ QueensideCastle *************}
  function TForm1.QueensideCastle(side:char):boolean;
  var  row:integer;
  begin
    result:=false;
    if side='W' then row:=7 else row:=0;
    begin  {a1=WR, b1=E, c1=E, D1=E,  e1=K }
      with board do
      begin
        if (b[4,row].kind=K) and (b[4,row].Pcolor=side)
        and (b[3,row].kind=E)and (b[2,row].kind=E) and (b[1,row].kind=E)
        and (b[0,row].kind=R)and (b[0,row].PColor=side) then
        begin
          movepiece(point(4,7-row),point(2,7-row));
          movepiece(point(0,7-row),point(3,7-row),side+'O-O-O'); {flag castle for undo checking}
          dec(movecount); {only count as 1 move}
          result:=true;
        end;
      end;
    end;
  end;

{********** ResetBtClick **********8}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  resetpieces;
end;

{************ UndoBtnClick ************8}
procedure TForm1.UndoBtnClick(Sender: TObject);
var
  s:string;
  n:integer;
  fx,fy,tx,ty:integer;
  kindOrd:integer;
  nextside:char;
  enpassantloc:TPoint;
  demote:boolean;
     {----------- UndoKingsCastle -----------}
     procedure UndoKingsCastle(color:char);
       var
         row:integer;
        begin  {kingsidecastle - locations are fixed so might as well use that info}
          if color='W' then row:=7 else row:=0;
          with board, undolist do
          if (b[6,row].kind=K)and (b[6,row].Pcolor=color)
          and (b[7,row].kind=E)and (b[7,row].kind=E)
          and (b[5,row].kind=R)and (b[5,row].PColor=color) then
          begin
            b[4,row].assign(b[6,row]);
            b[6,row].assign(Emptypiece);
            b[7,row].assign(b[5,row]);
            b[5,row].assign(EmptyPiece);
            delete(count-1);  {two undo records were added for castling
                             (K & R moves), delete the extra one here}
          end
          else error('Undo of Kingside Castle failed');
        end;

    {---------- UndoQueensCastle --------}
    procedure UndoQueensCastle(color:char);
    var  row:integer;
    begin  {QueenSidecastle}
      if side='W' then row:=7 else row:=0;
      with undolist, board do
      begin  {e.g. for White: a1=E, b1=E c1=K, d1=R, e1=E }
        if (b[2,row].kind=K) and (b[2,row].Pcolor=side)
        and (b[0,row].kind=E)and (b[1,row].kind=E) and (b[4,row].kind=E)
        and (b[3,row].kind=R)and (b[3,row].PColor=side) then
        begin
          b[4,row].assign(b[2,row]);
          b[0,row].assign(b[3,row]);
          b[2,row].assign(Emptypiece);
          b[3,row].assign(Emptypiece);
          delete(count-1);  {two undo records were added for castling
                             (K & R moves), delete the extra one here}
        end
        else error('Undo of Queenside Castle failed');
      end;
    end;

begin {UndoBtnClick}
  debugcounts(1);
  with undolist, board do
  if count>0 then
  begin
    s:=strings[count-1];
    if s[1]='=' then
    begin
      demote:=true;
      system.delete(s,1,1);
    end
    else demote:=false;
    n:=strtointdef(s,-1);
    if n>=100000  then
    begin
      enpassantloc.x:=n div 1000000;
      n:=n mod 1000000;
      enpassantloc.y:=n div 100000;
      n:=n mod 100000;
    end
    else enpassantloc.x:=-1;

    if n>0 then
    begin  {undo normal or promotion}
      kindOrd:=n div 10000;
      n:=n mod 10000;
      fx:=n div 1000;
      n:=n mod 1000;
      fy:=n div 100;
      n:=n mod 100;
      tx:=n div 10;
      ty:=n mod 10;
      b[tx,ty].assign(b[fx,fy]);
      if demote then
      begin
        if b[tx,ty].pColor='W' then b[tx,ty].assign(WPiece[P])
        else b[tx,ty].assign(BPiece[P]);
      end;
      if movecount mod 2 =0 then nextside:='W' else nextside:='B';

      if enpassantloc.x>=0 then
      with enpassantloc do
      begin
        if nextside='W'
        then b[x,y].assign(WPiece[P])
        else b[x,y].assign(BPiece[P]);
      end;
      {If empty piece moved back, no need to replace the former occupant}
      if TPieceKind(kindord)=E then b[fx,fy].assign(Emptypiece)
      else {Former occupant was color of nextside}
      if nextside ='W' then b[fx,fy].assign(WPiece[TPieceKind(kindord)])
      else b[fx,fy].assign(BPiece[TPiecekind(kindord)]);
    end
    else {special}
    begin
      if (s='BO-O') then undoKingsCastle('B')
      else if (s='WO-O') then UndoKingscastle('W')
      else if (s='BO-O-O') then undoQueensCastle('B')
      else if (s='WO-O-O') then UndoQueensCastle('W')
      else error('Undo code '+s +' not recognized');
    end;
    delete(count-1);
    dec(movecount);
    movelist.itemindex:=movecount div 2;
  end;
  debugcounts(2);
  showmovelbls;
end;

{************ PGNSheetEnter ************}
procedure TForm1.PGNSheetEnter(Sender: TObject);
begin
  showmovelbls;
end;

{**************** ShowMoveLbls ************}
procedure TForm1.showMovelbls;
{display next move left of Move button and previous move right of Undo button}
var sn, sp:string;
begin

  with movelist do
  begin
    if movecount mod 2 = 0 then
    begin
      sn:=getword(items[itemindex],2);
      if itemindex>0 then sp:=getword(items[itemindex-1],3)
      else sp:='None';
    end
    else
    begin
      sn:=getword(items[itemindex],3);
      sp:=getword(items[itemindex],2);
    end;
    nextmovelbl.caption:=sn;
    prevmovelbl.caption:=sp;
  end;
end;

{************* MoveListBtnClick **************}
procedure TForm1.MoveListDblClick(Sender: TObject);
var
  target:integer;
begin
  with movelist do
  if (itemindex>=0) and (itemindex<= items.Count-1) then
  begin
    target:=itemindex;
    itemindex:=movecount div 2;
    if itemindex<target then
    repeat
      movebtnclick(sender);
      sleep(50);
      application.processmessages;
    until itemindex>=target
    else if itemindex>=target then
    repeat
      undobtnclick(sender);
      sleep(50);
      application.processmessages;
    until (itemindex<target) or (movecount=0);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
procedure TForm1.debugboxClick(Sender: TObject);
begin
  if debugbox.checked then
  begin
    beforelbl.visible:=true;
    afterlbl.visible:=true;
  end
  else
  begin
    beforelbl.visible:=false;
    afterlbl.visible:=false;
  end;
end;

procedure TForm1.DefaultBoxClick(Sender: TObject);
begin
  if defaultbox.checked then
  begin
    setdefault(filename, gamebox.itemindex);
    showmessage(format('Default gane at startup is now number %d in file %s', [gamebox.itemindex+1, filename]));
  end;
  defaultbox.Checked:=false;
end;                                                                                               

end.
