unit U_DominoPuzzle;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ The board contains set a set of dominoes whose outlines have been removed.
The dominoes in a separate list will exactly fill the board. The task is to
restore the domino outlines by "clicking and draging" between two numeric values
on the board. Dominoes may be oriented vertically or horizontally and with
numbers in either order. If you make a mistake,any domino may be removed from
the board by clicking on it or clicking the entry in the "added" list.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ShellAPI;

type
  TCellRec = record
    occupied:boolean;
    dominoNbr:integer; {The id nbr of the domino if it is its top or leftmost cell
                       {Bottom and rightmost are identified by dominonbr = 0}
    orientation:char;
    corner:TPoint; {pixelcooridinates of the top left corner}
    cellvalue:integer;  {the value displayed for this cell}
    DominoColor:TColor;
    value:array[1..2] of byte; {values of the domino [left,right] or [top,bottom]}
    showing:boolean;  {domino has been drawn}
  end;

  TBoard=array of array of TCellRec;

  TForm1 = class(TForm)
    Image1: TImage;
    CreateBtn: TBitBtn;
    Memo1: TMemo;
    SolutionBtn: TButton;
    SizeGrp: TRadioGroup;
    AvailListBox: TListBox;
    StaticText1: TStaticText;
    RestartBtn: TButton;
    ShowCountsBox: TCheckBox;
    SaveBtn: TButton;
    LoadBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    AddedListBox: TListBox;
    Label1: TLabel;
    Label3: TLabel;
    procedure CreateBtnClick(Sender: TObject);
    procedure SolutionBtnClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RestartBtnClick(Sender: TObject);
    procedure ShowCountsBoxClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure AddedListBoxClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SizeGrpClick(Sender: TObject);
  public
    across, down:integer;
    cellsize, halfcell:integer;
    board, board2:TBoard;
    dominovalues:array of TPoint; {array of domino values}
    boardcolor:TColor;
    {Original imagesize. Every board adjusts one of the image dimensions
     downward as necessary keep size a multiple of row and column counts
     Reset to this size before each new puzzle to avoid "shrinkage"}
    OriginalImagesize:TPoint;

    {Mousing info when user is solving}
    mousedown:TPoint; {column and row of cell where mousedown occurred}
    mousedownPixel:TPoint; {center pixel coordinates of mousedown cell}
    currentmousePixel:TPoint; {pixel coordinates of last mouse move entry}
    dominocount:integer;  {nbr of dominos drawn by user}

    {The random seed used to create the current board for save and load operations}
    saveseed:integer;



    procedure drawdominoes(const board:TBoard; const outline, values:boolean);
    function addDomino(i,j,n:integer):boolean;
    procedure setupBoard;
    procedure assignvalues;
    procedure showvalues(ListBox:TListBox);
    procedure validate(msg:string);  {for debugging}
    procedure ShowCounts;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  keyformatstr:string='%2d - %2d';
{************* Sort **********}
procedure sort(var a:array of tpoint);
{sort the points by ascending X then Y}
var
  i,j:integer;
  temp:TPoint;
begin
  for i:=0 to high(a)-1 do
  for j:=i+1 to high(a) do
  if (a[j].x<a[i].x) or
     ((a[j].x=a[i].x) and (a[j].y<a[i].y)) then
  begin
    temp:=a[j];
    a[j]:=a[i];
    a[i]:=temp;
  end;
end;

{************* SwapPoint *********}
procedure swappoint(var a,b:TPoint);
var temp:TPoint;
begin
  temp:=a;
  a:=b;
  b:=temp;
end;

function ListBoxFind(Listbox:TListbox; const s:string; var index:integer):boolean;
  var  k:integer;
  begin
    result:=false;
    index:=-1;
    for k:=0 to ListBox.items.count-1 do
    with ListBox do
    if copy(items[k],1,length(s))=s then
    begin
      index:=k;
      result:=true;
      break;
    end;
  end;


{************ MakeDominoLey *************}
function makeDominoKey(v1,v2:integer):string;
    begin
      if v1>v2 then result:=format(keyformatstr,[v1,v2])
      else result:=format(keyformatstr,[v2,v1]);
    end;


{************ CopyBoard ***********}
Procedure copyboard(const b1:TBoard; var b2:TBoard);
var
  i,j:integer;
begin
  for i:=0 to high(b1) do
  for j:=0 to high(b1[i]) do
  b2[i,j]:=b1[i,j];
end;



{*************** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  boardcolor:=$00FBFBF0; {very light blue}
  with image1,canvas do
  begin
    brush.color:=boardcolor;
    rectangle(clientrect);
    font.style:=[fsbold];
    font.size:=10;
  end;
  with image1 do originalImageSize:=Point(width,height);
  opendialog1.InitialDir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
  CreateBtnclick(sender);  {create the initial puzzle}
end;

{************* CreateBtnClick ***********}
procedure TForm1.CreateBtnClick(Sender: TObject);
{Create a new random puzzle of the selected size}
var
  i,j:integer;
begin
  saveseed:=randseed; {in case user wants to save this puzzle}
  {$IFDEF DEBUG}
    randseed:=-1127308321;  {make result repeatable for testing}
    memo1.clear;
    memo1.lines.add('Randseed='+inttostr(randseed));
  {$ENDIF}
  across:=sizegrp.itemindex+6;
  down:=across-1;
  image1.width:=originalImagesize.x;
  image1.height:=originalImagesize.y;
  setupboard; {make a set of dominoes that fill the board}
  if not adddomino(1,0,1) then showmessage('Domino fill failed, try again')
  else
  begin
    AssignValues; {assign values to the dominoes}
    copyboard(board,board2);
    {remove the solution so user can solve the board}
    for i:=1 to across do
    for j:=1 to down do
    with board[i,j] do
    begin
      dominonbr:=0;
      occupied:=false;
    end;
    dominocount:=0;  {no user drawn dominoes yet}
    DrawDominoes(board,false, true);
    showvalues(AvailListBox);
    addedlistbox.clear;
    if showcountsbox.checked then showcounts;
  end;
end;


{*********** RestartBtnClick *********}
procedure TForm1.RestartBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  copyboard(board2,board);
  {remove the solution so user can solve the board}
  for i:=1 to across do
  for j:=1 to down do
  with board[i,j] do
  begin
    dominonbr:=0;
    occupied:=false;
  end;
  DrawDominoes(board,false, true);
  showvalues(AvailListBox);
  dominocount:=0;
  addedlistbox.clear;
  if showcountsbox.checked then showcounts;
end;


{**************** SolutionBtnClick ************}
procedure TForm1.SolutionBtnClick(Sender: TObject);
var
  i,j:integer;
  s:string;
  index:integer;
begin
  copyboard(board2,board);
  drawdominoes(board,true,true);
  availlistbox.clear;
  for i:=0 to across*down div 2 -1 do AvailListBox.items.add('');
  Showvalues(AddedlistBox);
  for i:=1 to across do
  for j:= 1 to down do
  with board[i,j] do
  if occupied and (dominonbr>0) then
  begin
    s:=makedominokey(value[1], value[2]);
    if listboxfind(addedListBox,s,index)then
    begin
      addedlistbox.items.objects[index]:=TObject(down*i+(j-1));
      dominonbr:=index+1;  {need to renumber the dominoes to indicate order added}
    end;
  end;
end;

{************ SizeGrpClick ***********8}
procedure TForm1.SizeGrpClick(Sender: TObject);
{Create a new puzzle when size changes}
begin
  createBtnClick(sender);
end;

{*********** SetupBoard *********}
procedure TForm1.setupBoard;
var
  i,j:integer;
begin
  {Setup the board}
  setlength(dominovalues,across*down div 2);
  setlength(board, across+2,down+2);
  setlength(board2, across+2,down+2);
  with image1 do
  begin
    cellsize:=width div across;
    if cellsize > height div down then cellsize:=height div down;
    width:=across*cellsize;
    height:=down*cellsize;
    halfCell:=cellsize div 2;
  end;

  for i:= 0 to high(board) do
  for j:= 0 to high(board[0]) do
  with board[i,j] do
  begin
    if (i=0) or (i>=high(board)) or (j=0) or (j=high(board[0]))
    then occupied:=true
    else occupied:=false;
    corner.x:=(i-1)*cellsize;
    corner.y:=(j-1)*cellsize;
    orientation:=' ';
    Dominocolor:=boardcolor;
    cellvalue:=0;
    dominonbr:=0;
    value[1]:=0;
    value[2]:=0;
  end;
end;



{********** Assignvalues **********}
Procedure TForm1.assignvalues;
var
  i,j,n:integer;
  count:integer;
begin
  n:=0;
  for i:=0 to across-1 do
  for j:= 1 to i do
  begin
    dominovalues[n].x:=i;
    dominovalues[n].y:=j;
    inc(n);
  end;
  count:=0;
  for i:=1 to across do
  for j:=1 to down do
  with board[i,j] do
  begin
    if occupied and (DominoNbr>0) then
    begin
      n:=random(length(DominoValues)-count);
      with dominovalues[n] do {randomly swap the values}
      if random(2)>0 then
      begin
        value[1]:=x;
        value[2]:=y;
      end
      else
      begin
        value[1]:=y;
        value[2]:=x;
      end;
      cellvalue:=value[1];
      if orientation='H' then board[i+1,j].cellvalue:=value[2]
      else board[i,j+1].cellvalue:=value[2];
      inc(count);
      swappoint(dominovalues[n],dominovalues[length(dominovalues)-count]);
    end;
  end;
  //sort(dominovalues);
end;

{*********** Showvalues **********}
procedure TForm1.showvalues(ListBox:TListBox);
var
  i,temp:integer;
begin
  ListBox.clear;
  {make largest value first}
  for i:=0 to high(dominovalues) do
  with dominovalues[i] do if y>x then
  begin
    temp:=x;
    x:=y;
    y:=temp;
  end;
  sort(dominovalues);
  for i:=0 to high(dominovalues) do
  with dominovalues[i] do ListBox.items.add(format(keyformatstr,[x,y]));
end;

{*************** DrawDominoes **********}
procedure TForm1.drawdominoes(const Board:TBoard; const outline,values:boolean);
var
  i,j:integer;
  r:TRect;
  textx,texty:integer;
begin
  image1.Canvas.brush.color:=Boardcolor {clWhite};
  with image1 do canvas.rectangle(clientrect);
  {set position to draw the value}
  with image1.canvas do
  begin
    textx:=(cellsize - textwidth('0')) div 2;
    texty:=(cellsize-textheight('0')) div 2;
  end;
  for i:=1 to across do
  for j:= 1 to down do
  with board[i,j], corner do
  begin
    if (dominoNbr>0) and outline then    {this is left or top}
    begin
      if orientation='H' then r:=Rect(x,y,x+2*cellsize-2,y+cellsize-2)
      else r:=Rect(x,y,x+cellsize-2,y+2*cellsize-2);
      with image1.canvas do
      begin
        pen.width:=2;
        if dominocolor=boardcolor
        then
        begin
          dominocolor:=(64+random(164)) shl 16+(64+random(164))shl 8+64+random(164);
          if orientation='H' then board[i+1,j].dominocolor:=dominocolor
          else board[i,j+1].dominocolor:=dominocolor;
        end;
        brush.color:=dominocolor;
        rectangle(r);
      end;
    end;
    if values then  {show values}
    with image1.canvas do
    begin
      if not outline then dominocolor:=boardcolor;
      brush.color:=dominocolor;
      textout(corner.x+textx, corner.y+texty,inttostr(cellvalue));
    end;
  end;
  application.processmessages;
end;

{************** addDomino ***********}
function TForm1.addDomino(i,j,n:integer):boolean;
{Recursive call to add a domino to the next available position, filling by
 column. When available cell is found, attempt is made to fit a domino vertically
 or horizontally, the direction chosen randomly.  If neither fits, return false.
 If one fits, add it and call addDomino to fit the next.  If that returns false,
 remove the domino added and try the other direction.  If both have failed,
 return false which will effectively backtrack and come forward again as far as
 necessary to find a solution.
}
var
  h:integer;
  triedH, triedV:boolean;

  {----------- AddHorizontal --------}
  function addhorizontal:boolean;
  begin
    result:=false;
    if not triedH then
    begin
      triedH:=true;
      If (not board[i+1,j].occupied) then
      with board[i,j] do
      begin {add horizontal domino}
        occupied:=true;
        dominoNbr:=N;
        orientation:='H';
        with board[i+1,j] do
        begin
          occupied:=true;
          orientation:='H';
          dominonbr:=0;
        end;
        result:=true;
        {$IFDEF DEBUG}
        memo1.lines.add(format( 'Add ,%d- %s @ (%d,%d)',[N,orientation, i,j]));
        {$ENDIF}
      end;
    end
  end;
  {--------- AddVertical ---------}
  function addvertical:boolean;
  begin
    result:=false;
    if not triedV then
    begin
      triedV:=true;
      if  (not board[i,J+1].occupied) then
      with board[i,j] do
      begin {add vertical}
        occupied:=true;
        orientation:='V';
        dominoNbr:=N;
        with board[i,j+1] do
        begin
          occupied:=true;
          orientation:='V';
          dominonbr:=0;
        end;
        result:=true;
        {$IFDEF DEBUG}
        memo1.lines.add(format( 'Add ,%d-%s @ (%d,%d)',[N,orientation, i,j]));
        {$ENDIF}
      end;
    end;
  end;

  {--------- RemoveDomino --------}
  procedure removeDomino;
  begin
    with board[i,j] do
    begin
      {$IFDEF DEBUG}
      memo1.lines.add(format( 'Removed ,%d-%s from (%d,%d)',[N,orientation, i,j]));
      {$ENDIF}
      occupied:=false;
      dominoNbr:=0;
      if orientation='H'
      then
      with board[i+1,j] do
      begin
        dominoNbr:=0;
        occupied:=false;
        orientation:=' ';
        dominocolor:=boardcolor{clwhite};
      end
      else with  board[i,j+1] do
      begin
        dominoNbr:=0;
        occupied:=false;
        orientation:=' ';
        dominocolor:=boardcolor{clwhite};
      end;
      orientation:=' ';
      dec(N);
    end;
  end;

begin  {AddDomino}
  result:=false;
  repeat {find the next available slot to fill}
    if j>=down then
    begin {if we're at the bottom row, go to top and increment column}
      j:=1;
      inc(i);
      if i>across then
      begin {all cell are full, success!}
        result:=true;
        exit;
      end;
    end;
    while (j<=down) and (board[i,j].occupied) do inc(j);
  until not board[i,j].occupied;


  triedH:=false; {keeps track of directions tried}
  triedV:=false;
  H:=random(2); {choose direction to try first}

  with board[i,j] do
  repeat
    if (h>0) and (not triedH)  {try horizontal first}
    then result:=addhorizontal;
    if not result then result:=addvertical;
    if (not result) and (not triedH)
    then result:=addhorizontal;

    if result then
    begin {successfully added, make recursive call for next domino}
      result:=addDomino(i,j,n+1);
      if not result then removeDomino; {that one didn't work}
    end;
  {loop on this position until solved or we've tried both directions}
  until result or (triedh and triedv);
end;


{************** Image1MouseDown **************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j:integer;
  i2,j2:integer;
  n:integer;
  s:string;
  index:integer;
begin
  i:= x div cellsize +1;
  j:= y div cellsize +1;
  if not board[i,j].occupied then
  with board[i,j] do
  begin
    mousedown.x:= i;
    mousedown.y:= j;
    mousedownPixel.x:=corner.x+halfcell;
    mousedownPixel.y:=corner.y+halfcell;
    currentmousePixel:=mousedownPixel;
    setcursorpos(form1.left+image1.left+mousedownPixel.x,
                 form1.top+image1.top +mousedownPixel.y);
  end
  else {process request to remove the domino}
  begin
    i2:=i;
    j2:=j;
    with board[i,j] do
    if dominonbr=0
    then {this is the right or bottom cell of a domino}
      if orientation='H' then dec(i2)
      else dec(j2)
    else if orientation='H' then inc(i) else inc(j);
    {now [i2,j2] points to top or left and [i,j] to bottom or right}
    with board[i2,j2] do
    begin   {remove the top/left domino cell}
      n:=dominonbr;
      dec(dominocount);
      occupied:=false;
      dominonbr:=0;
      orientation:=' ';
      dominocolor:=boardcolor;
      s:=makedominokey(value[1], value[2]);
      AvailListBox.items[n-1]:=s;
    end;
    with board[i,j] do
    begin  {renove bottom/right cell}
      occupied:=false;
      dominonbr:=0;
      orientation:=' ';
      dominocolor:=boardcolor;

    end;
    Listboxfind(AddedlistBox,s,index);
    if index>=0 then AddedListBox.items.delete(Index);
    mousedown.x:=-1; {to keep the mouse move and mouse from acting}
    drawdominoes(board,true,true);
    {$IFDEF DEBUG}
      validate('Mouse down remove');
    {$ENDIF}
    if showcountsbox.checked then showcounts;
  end;
end;



{**************** Image1MouseMove **********}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if  ssleft in shift then
  begin
    if mousedown.x>=0 then
    with image1, canvas do
    begin
      drawdominoes(board,true,true);
      pen.color:=boardcolor;
      with currentMousePixel do moveto(x,y);
      with MouseDownPixel do lineto(x,y);
      pen.color:=clblack;
      currentmousePixel.x:=x;
      currentmousePixel.y:=y;
      lineto(x,y);
    end;

    update;
  end;
end;

{**************** Image1MouseUp *****************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

    {---------- Local function "CanDrop" ---------}
    function candrop(x1,y1,x2,y2:integer):boolean;
    {return true if passed coordinates are valid and available}
    begin
      if (not board[x1,y1].occupied)
       and (not board[x2,y2].occupied)
       and
         (     ((y1=y2) and (abs(x1-x2)=1))
            or ((x1=x2) and (abs(y1-y2)=1))
          )
       then result:=true{this is an adjacent empty cell, could drop here}
       else result:=false;
    end;

   {--------- Local function  "SetEntry" ----------}
   procedure setentry(const x1,y1,v1,v2:integer;const VH:char; const N:integer);
    {Set up a new domino entry passed on passed values}
   begin
     with board[x1,y1] do
     begin
       value[1]:=v1;
       value[2]:=v2;
       orientation:=VH;
       dominonbr:=N;
       occupied:=true;
       if (n>0) then  cellvalue:=value[1] else cellvalue:=value[2];
     end;
   end;



var
  x1,y1,x2,y2:integer;
  col,row:integer; {location of top/left of domino added}
  val1,val2:integer;
  s:string;
  index:integer;
begin {Image1MouseUp}
  if (x>=0)  and (y>=0) and  (mousedown.x>0) then
  begin
    x1:=mousedown.x;
    y1:=mousedown.y;
    x2:=x div cellsize +1;
    y2:=y div cellsize +1;
    if (mousedown.x>0) and candrop(x1,y1,x2,y2) then
    begin  {if then values match an unused domino, then create it here and
            remove the entry from the available list}
      val1:=board[x1,y1].cellvalue;
      val2:=board[x2,y2].cellvalue;
      s:=makeDominoKey(val1,val2);

      if listboxfind(AvailListBox,s,index) then
      begin {Make the domino entry}
        if (x1=x2) then
        begin
          col:=x1;
          if (y1=y2-1) then
          begin {vertical and y1 is on top}
            row:=y1;
            setentry(x1,y1,val1,val2,'V',index+1);
            setentry(x2,y2,val1,val2,'V',0);
          end
          else
          if (y2=y1-1) then
          begin {vertical and y2 is on top}
          row:=y2;
            setentry(x2,y2,val2,val1,'V',index+1);
            setentry(x1,y1,val2,val1,'V',0);
          end
          else showmessage('System error 1');
        end
        else if (y1=y2) then
        begin
          row:=y1;
          if (x1=x2-1) then
          begin {horzontal and x1 is left}
            col:=x1;
            setentry(x1,y1,val1,val2,'H',index+1);
            setentry(x2,y2,val1,val2,'H',0);
          end
          else
          if (x2=x1-1) then
          begin {horizontal and x2 is left}
            col:=y2;
            setentry(x2,y2,val2,val1,'H',index+1);
            setentry(x1,y1,val2,val1,'H',0);
          end
          else showmessage('System error 2');
        end;
        AvailListBox.items[index]:=' ';

        AddedlistBox.items.addobject(s,TObject(down*col+row-1));
        inc(dominocount);

        drawdominoes(board,true,true);
        if dominocount=length(dominovalues) then showmessage('Congratulations!');
        {$ifdef dbug}
           validate('Mouse up add'); {for debugging}
        {$endif}
        if showcountsBox.checked then ShowCounts;
      end
      else
      begin
        showmessage('This is not an available domino');
        drawdominoes(board,true,true);
      end;
    end;
  end
  else drawdominoes(board,true,true);
end;

{************ ShowCOuntsBoxClick **********}
procedure TForm1.ShowCountsBoxClick(Sender: TObject);
{show counts of possible locations for each domino not yet placed}
begin
  If showcountsBox.checked then showcounts;
end;

{********** SaveBtnClick **************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save current puzzle to a file}
var
  f:textfile;
begin
  if savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    opendialog1.filename:=savedialog1.filename;
    rewrite(f);
    {we only need two oitems to recreate the puxxle}
    writeln(f,saveseed); {the random seed used to create it}
    writeln(f,sizegrp.itemindex); {and the board size}
    closefile(f);
  end;
end;

{************ LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
{Load a previously saved puzzle}
var
  f:textfile;
  r,i:integer;
begin
  if opendialog1.execute then
  begin
    assignfile(f,opendialog1.filename);
    savedialog1.filename:=opendialog1.filename;
    reset(f);
    readln(f,r);
    readln(f,i);
    randseed:=r;
    sizegrp.itemindex:=i;
    closefile(f);
    createbtnclick(sender);
  end;
end;

{************* AddedListBoxClick **********}
procedure TForm1.AddedListBoxClick(Sender: TObject);
{Clicks on items here ==> remove the domino that was clicked}
var
  s:string;
  x,y,n:integer;
begin
  with addedlistbox do
  begin
    s:=items[itemindex];
    n:=Integer(items.objects[itemindex]);
    x:=(n div down-1)*cellsize+1;
    y:=(n mod down)*cellsize+1;
    {simulate mousedown on this cell}
    Image1MouseDown(Sender,mbleft, [], X, Y);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************ Validate ************}
procedure TForm1.validate(msg:string);
{debugging routine to validate that available domino count is half the
 number of unoccupied cells}
VAR
  I,J:integer;
  dcount:integer;
  occupiedcount:integer;
begin
  dcount:=0;
  with Availlistbox do
  for i:=0 to items.count-1 do
  if items[i]=' ' then inc(dcount);
  occupiedcount:=0;
  for i:= 1 to across do
  for j:= 1 to down do
  if  board[i,j].occupied then inc(occupiedcount);
  if 2*dcount<>occupiedcount
  then showmessage(format('%s,'+#13+'DCount=%d, OccupiedCells=%d',[msg,dcount,occupiedcount]));
end;

{*********** ShowCounts **********}
procedure TForm1.showcounts;
{process listbox entries, extracting domino values and
 search board for number of possible locations for this
 number pair}
var
  i,j,k:integer;
  v1,v2:integer;
  errcode:integer;
  s:string;
  count:integer;
begin
  for k:=0 to AvailListBox.items.count-1 do
  with AvailListBox do
  begin
    s:=items[k];
    if length(s)>7 then s:=copy(s,1,7);
    if length(s)=7 then
    begin
      val(copy(s,1,2),v1,errcode);
      if errcode=0 then val(copy(s,6,2),v2,errcode);
      if errcode=0 then
      begin {found two valid values, now count possible board locations}
        count:=0;
        for i:=1 to across do
        for j:=1 to down do
        with board[i,j] do
        if (not occupied) then
        begin
          if (cellvalue = v1) then
          begin
            {check right and down}
            with board[i+1,j] do if (not occupied) and (cellvalue=v2) then inc(count);
            with board[i,j+1] do if (not occupied) and (cellvalue=v2) then inc(count);
            if (v1<>v2) then
            begin {if values not equal, also check left and up}
               with board[i-1,j] do if (not occupied) and (cellvalue=v2) then inc(count);
              with board[i,j-1] do if (not occupied) and (cellvalue=v2) then inc(count);
            end;
          end;
        end;
        AvailListBox.items[k]:=s+ ' ('+inttostr(count)+')';
      end
      else showmessage('Invalid format for list values item: '+AvailListBox.items[k]);
    end;
  end;
end;

end.
