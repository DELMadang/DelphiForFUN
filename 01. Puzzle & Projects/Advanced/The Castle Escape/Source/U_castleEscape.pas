unit U_castleEscape;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {An elderly queen, her daughter, and little son, weighing 195, 105, and 90
  pounds respectively, were kept prisoners at the top of a high tower.  The only
  communication with the ground was a cord passing over a pulley, with a basket
  at each end, and so arranged that when one basket rested on the ground, the
  other was opposite the window.  Naturally, if the one were heavily loaded than
  the other, the heavier would descend; but if the excess weight on either side
  was more than 15 pounds, the descent became so rapid as to be dangerous, and
  from the position of the rope the captives could not slow it with their hands.
  The only thing available to help them in the tower was a cannonball weighting
  75 pounds.  They nonetheless contrived to escape.  How did they do it?
  
  Adapted from Merlin's Puzzle Passtimes, Charles Barry, Dover Publications.
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ComCtrls, ExtCtrls, jpeg;

type

  TSlotrec=record {info about images and their "home" locations}
    image:TImage;
    topslot:TPoint; {position of image when at top}
    bottomy:integer; {top of image when at bottom}
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SolveBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    TabSheet2: TTabSheet;
    AGrid: TStringGrid;
    StatusBar1: TStatusBar;
    ResetBtn: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Basket1: TShape;
    Pulley1: TShape;
    Pulley2: TShape;
    Basket2: TShape;
    Shape3: TShape;
    L2: TShape;
    L1: TShape;
    Memo3: TMemo;
    Label1: TLabel;
    Image5: TImage;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure DragOver1(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DragDrop1(Sender, Source: TObject; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    weight:array[0..3] of integer;
    name:array[0..3] of string;  {names of the 4 captives}
    maxdif,mindif:integer;
    solved:boolean;
    justsolved:boolean; {set when solved, reset by resetbtn,
                         called on next drag/drop if not reset before}

    {used in autosolve}
    adjacents:array [0..15,0..15] of integer;{array of adjacent nodes}
    visited:array[0..15] of boolean;
    path:TStringList;  {move positions leading to solution}


    {used in manual play and drawing animations}
    key:integer; {represents current positions of items as an integer 0 to 15,
                 1's in binary representation ==> top
                 0's ==> bottom
                 }
    slots:array[0..3] of TSlotrec;  {home positions of item images}
    topweight, bottomweight:integer;  {weights of items in basket}
    tempkey:integer;
    linetop, L1x, L2x:integer; {rope locations}
    inbasket:array[1..2,0..3] of integer;
    movecount:integer;


    procedure getnextnode(node:integer); {the recursive search procedure}
    procedure showsolution;
    function basketattop(b:Tshape):boolean;
    procedure movebaskets(key,tempkey:integer);
    procedure showmove(nbr,oldkey,newkey:integer);
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}

{************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{Lots of initialization stuff!}

     procedure setupslot(nbr:integer; im:TImage;s:string; w:integer);
       begin
         with slots[nbr] do
         begin
           image:=im;
           topslot.x:=im.left;
           topslot.y:=im.top;
           bottomy:=basket2.top+basket2.height;
           {
           weight:=w;
           name:=s;
           }
         end;
       end;

var
  i,j,k:integer;
  b,t,n:integer;
begin
  {make the castle show around the figures}
  image1.picture.Bitmap.transparentcolor:=clwhite;
  image2.picture.Bitmap.transparentcolor:=clwhite;
  image3.picture.Bitmap.transparentcolor:=clwhite;
  image4.picture.Bitmap.transparentcolor:=clwhite;

  path:=TStringlist.create; {the moves for computer solution}

  {fill in the weights}
  weight[0]:=75;  name[0]:='Cannonball';
  weight[1]:=90;  name[1]:='Son';
  weight[2]:=105; name[2]:='Daughter';
  weight[3]:=195; name[3]:='Queen';
  maxdif:=15;
  mindif:=1;

  {Adjacency grid}
  for i:=0 to 15 do {fill in row and column headers}
  begin
    agrid.cells[0,i+1]:=inttostr(i);
    agrid.cells[i+1,0]:=inttostr(i);
  end;

   {fill in valid adjacenncy array for all 16 nodes}
  for i:=0 to 15 do
  begin
    {check configuration i against all 16 other nodes filling in weight
     differences}
    for j:=0 to 15 do
    begin
      t:=0;
      b:=0;
      for k:=0 to 3 do
      begin
        n:=1 shl  k;
        if (i and n) <> (j and n) then
        begin  {this item moved up or down}
          if (i and n)>0 then  inc(t,weight[k])
          else inc(b,weight[k]);
        end;
      end;
      adjacents[i,j]:=abs(b-t);
      {If the weight difference is not OK, then mark this node aas unavailable}
      if (adjacents[i,j]>maxdif) or (adjacents[i,j]<mindif)
      then  adjacents[i,j]:=-1;
      agrid.cells[j+1,i+1]:=inttostr(adjacents[i,j]); {show the value in the stringgrid}
    end;
  end;
  {now go through and allow any valid position with the cannonball up to
   move to the same position with the cannonball down {and vice versa)}
   for i:=0 to 15 do
   if i mod 2 = 1 then  {odd keys can always move to the next lower even key}
   begin
     adjacents[i,i-1]:=weight[0];
     agrid.cells[i,i+1]:=inttostr(adjacents[i,i-1]);
   end;

   {set up manual play}
   resetbtn.Top:=statusbar1.top-100;
   solvebtn.Top:=resetbtn .Top;
   basket2.Top:=resetbtn.Top-60;
   image5.height:=basket2.top+basket2.height-image5.top;
   L2.height:=basket2.top-l2.top;
   setupslot(3,image1,'Queen',195);  {name and weight passed but not used (yet)}
   setupslot(2,image2,'Daughter',105);
   setupslot(1,image3,'Son',90);
   setupslot(0,image4,'Cannonball',75);

   linetop:=pulley1.top+pulley1.height div 2;
   L1x:=pulley1.left;
   L2x:=pulley2.left+pulley2.width;
   resetbtnclick(sender);
   tabsheet1.doublebuffered:=true;
end;

{*************** ShowMove **************}
procedure TForm1.showmove(nbr,oldkey,newkey:integer);
{Make text description of move from oldkey to newkey}
var
  i,j:integer;
  topstr, botstr:string;
  n,n2:integer;
  c1,c2:integer;
  m1,m2:string;
begin
  topstr:='';   botstr:='';
  n:=oldkey;
  n2:=newkey;
  if n=n2 then {assume this is the first move}
  begin
    memo1.lines.clear;
    for i:=0 to 3 do
    if n and (8 shr i) >0 then topstr:=topstr+name[3-i]+','
    else botstr:=botstr+name[3-i]+',';
    If length(topstr)>0 then
    begin
      delete(topstr,length(topstr),1);
      topstr:=topstr+' start at the top.';
    end;
    If length( botstr)>0 then
    begin
      delete(botstr,length(botstr),1);
      botstr:=botstr+' start at the bottom.';
    end;
    memo1.lines.add('Start: '+topstr +botstr);
  end
  else
  begin {display the next move}
    c1:=0; c2:=0; m1:=' moves '; m2:=' moves ';
    for j:=0 to 3 do
    begin
      if (n and (8 shr j)>0) and (n2 and (8 shr j)=0) then
      begin
        topstr:=topstr+name[3-j]+',';
        inc(c1); {count items in basket to kepp grammer correct}
      end
      else if (n and (8 shr j)=0) and (n2 and (8 shr j)>0) then
      begin
        inc(c2);
        botstr:=botstr+name[3-j]+',';
      end;
    end;
    if c1>1 then m1:=' move ';
    if c2>1 then m2:=' move ';
    memo1.lines.add('Move #'+inttostr(nbr)+': '+topstr+m1+'down.');
    if length(botstr)>0 then memo1.lines.add('           '+botstr +m2+'up.');
  end;
end;



{************* ShowSolution *********}
procedure TForm1.showsolution;
{ Display  text version and animation of moves to solution contained in "path" list}

    procedure loadbaskets(n,n2:integer);
    {move items to basket that is on the same level
    in binary representation of "n", 1=top, 0=bottom}


      procedure moveimage(imagenbr:integer; basket:TShape);
      begin
        with slots[imagenbr].image do
        begin
          left:=basket.left+10*imagenbr;
          top:=basket.top-height+10;
          inbasket[basket.tag,imagenbr]:=1;

        end;
      end;

    var
      t,b:TShape;
      x:integer;
      i:integer;
    begin
      If basketattop(basket1) then
      begin
        t:=basket1;
        b:=basket2;
      end
      else
      begin
        t:=basket2;
        b:=basket1;
      end;
      x:=n xor n2;  {identify only those that will moved}
      for i := 0 to 3 do
      begin
        if (x mod 2 =1) then
          if (n mod 2 =1) then
          begin
            moveimage(i,t);
            inc(topweight,weight[i])
          end
          else
          begin
            moveimage(i,b);
            inc(bottomweight,weight[i])
          end;

        x:=x div 2;
        n:=n div 2;
      end;

    end;
var
  n,n2:integer;
  i:integer;
begin
  solved:=true;
  n:= strtoint(path[0]);
  showmove(0,n,n);
  for i:=1 to path.count-1 do
  begin
    n2:=strtoint(path[i]);
    {load up the baskets}
    loadbaskets(n,n2);
    movebaskets(n,n2);
    n:=n2;
    if tag>0 then break;
  end;
  if n<>0 then
  begin
     loadbaskets(n,0);
     movebaskets(n,0); {move final cannonball down}
  end;
end;

{***************** GetNextNode ************}
procedure TForm1.getnextnode(node:integer);
{recursive depth-first through adjacent nodes table for a solution}
var i:integer;
begin
  for i:=0 to 15 do
  begin
    if (adjacents[node,i]>=0) and (not visited[i]) then
    begin  {we can move here}
      path.add(inttostr(i));

      visited[i]:=true;
      if i<=1 {solution found}
      then
      begin {report solution}
        showsolution;
        break;
      end
      else
      begin
        application.processmessages;
        getnextnode(i);
        if solved then break;
        path.delete(path.count-1);
        visited[i]:=false;
      end;
    end;
  end;
end;


{*************** SolveBtnClick ******}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Search for a solution}
var i:integer;
begin
  resetbtnclick(sender);
  solved:=false;
  path.clear;
 for i:=0 to 15 do visited[i]:=false;
 path.add('15');
 getnextnode(15);
 if not solved then showmessage('No solution found')
 else justsolved:=true;
end;

{****************** DragOver ******************}
procedure TForm1.DragOver1(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Images are the only things dragged, so accept it}
{Could move the check from DragDrop here that can only drop to basket on the same level}
begin
  accept:=true;
end;


function TForm1.basketattop(b:Tshape):boolean;
  begin
    if b.top+b.height <= slots[0].topslot.y+slots[0].image.height then result:=true
    else result:=false;
  end;

{***********   MoveBaskets *************}
procedure TForm1.movebaskets(key,tempkey:integer);
{move top basket and its contents to the bottom and vice-versa}
var
  incr:integer;
  i,killed:integer;
  newtop,newbottom:TShape;


    function cannonballOnly:boolean;
   {test to see if the the cannonball is the only occupant of
    the basket moving down (so we don't call that an error)}
    var i, sum:integer;
    begin
      sum:=0;
      for i:=0 to 3 do inc(sum,inbasket[newbottom.tag,i]);
      result:=sum=1;
    end;


begin
  if basketattop(basket1) then
  begin
    incr:=+2;
    newtop:=basket2;
    newbottom:=basket1;
  end
  else
  begin
    incr:=-2;
    newtop:=basket1;
    newbottom:=basket2;
  end;
  if topweight-bottomweight>maxdif then incr:=2*incr;
  inc(movecount);
  showmove(movecount,key,tempkey);
  repeat  {move everything one step}
    basket1.top:=basket1.top+incr;
    basket2.top:=basket2.top-incr;
    L1.height:=basket1.top-l1.top;
    L2.height:=basket2.top-l2.top;
    for i:=0 to 3 do
    if inbasket[1,i]>0 then slots[i].image.top:=slots[i].image.top+incr
    else if inbasket[2,i]>0 then slots[i].image.top:=slots[i].image.top-incr;

    application.processmessages;
    if topweight-bottomweight<=maxdif then sleep(5);
  until basketattop(newtop);

  killed:=0;
  if (topweight-bottomweight>maxdif) and (not cannonballOnly) then
  begin
    {play ouch sound}
    {give error message}
    for i:=0 to 3 do
    if inbasket[newbottom.tag,i]>0 then
    begin
      killed:=i;
      break;
    end;
    Showmessage('Sorry, you just killed the '+name[killed]+'!'
                +#13+'Game over');
    resetbtnclick(self);
    {call reset}
    exit;
  end;
  


  {unload the baskets}
  for i:=0 to 3 do
  begin
    if ((newtop=basket2) and (inbasket[2,i]>0))
    or ((newtop=basket1) and (inbasket[1,i]>0))
    then
    begin
      slots[i].image.left:=slots[i].topslot.x;
      slots[i].image.top:=slots[i].topslot.y;
      inbasket[newtop.tag,i]:=0;
    end
    else if ((newtop=basket1) and (inbasket[2,i]>0))
    or ((newtop=basket2) and (inbasket[1,i]>0))
    then
    begin
      slots[i].image.left:=slots[i].topslot.x;
      slots[i].image.top:=slots[i].bottomy-slots[i].image.height;
      inbasket[newbottom.tag,i]:=0;
    end;
  end;
  topweight:=0;
  bottomweight:=0;
end;

{***************** DragDrop1 ****************}
procedure TForm1.DragDrop1(Sender, Source: TObject; X, Y: Integer);

  function getindex(n:integer):integer;
  {convert image tag value to index}
  begin
    result:=0;
    while n>1 do
    begin
      inc(result);
      n:= n div 2;
    end;
  end;

var
  n,index,from:integer;
  t:TImage;
begin
  if justsolved then  resetbtnclick(sender);
  t:=Timage(source);
  index:=getindex(t.tag);
  if sender is Tshape then  {dropping in a basket}
  begin
    n:= T.tag and key ;
    If  ( (n>0) and basketattop(Tshape(sender) ))
     or ( (n=0) and (not basketattop(Tshape(sender)))) then
    begin
      T.left:=TShape(sender).left+x;
      T.top:=TShape(sender).top-2*t.height div 3;  {;eave 2/3 of the item sticking out of basket}
      if n>0 then topweight := topweight + weight[index]
      else bottomweight:=bottomweight+ weight[index];
      tempkey:=tempkey xor t.tag;
      if TShape(sender) = basket1 then inbasket[1,index]:=T.tag
      else if TShape(sender) = basket2 then inbasket[2,index]:=T.tag;

      if topweight> bottomweight then
      begin
        movebaskets(key,tempkey);
        key:=tempkey;
        if (key<=1) and (not solved) then
        begin
          showmessage('You did it!');
          solved:=true;
        end;
      end;
    end
    else showmessage('Hey!, No cheating!');
  end
  else  {must be dropping back on the form}
  begin
    n:= Timage(source).tag and key;
    {need to determine which basket this guy was moved from so
    we can reduce the weight of that basket}
    if inbasket[1,index]>0 then from:=1 else
    if inbasket[2,index]>0 then from:=2 else from:=0;

    if from>0 then
    begin
      if n >0 then
      begin
        T.left:=slots[index].topslot.x;
        T.top:=slots[index].topslot.y;
        topweight := topweight - weight[index];
      end
      else
      begin
        T.left:=slots[index].topslot.x;
        T.top:=slots[index].bottomy-t.height;
        bottomweight:=bottomweight - weight[index];
      end;
      inbasket[from,index]:=0;
      tempkey:=tempkey xor t.tag;
      if topweight> bottomweight then
      begin
        movebaskets(key,tempkey);
        key:=tempkey;
      end;
    end;

  end;

end;



var
  msg1:string='Drag person or item to the basket at their level to load the baskets.'
               +' Baskets automatically unload after moving.';
  msg2:string='Press "Solve" button to see the solution';

{******************* ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);

(*
       {**********(local)  MovebasketUp ***********}
      procedure MoveBasket1Up;
      var
        newtop:integer;
        incr:integer;
      begin
        incr:=1;
        newtop:=slots[0].topslot.y+slots[0].image.height-basket1.height;
        while basket1.top> newtop do
        begin
          basket1.top:=basket1.top-incr;
          basket2.top:=basket2.top+incr;
          L1.height:=basket1.top-l1.top;
          L2.height:=basket2.top-l2.top;
        end;
      end;
*)


var
  i:integer;
begin
  key:=15;
  movecount:=0;
  for i:= 0 to 3 do
  with slots[i] do
  begin
    image.left:=topslot.x;
    image.top:=topslot.y;
    inbasket[1,i]:=0;
    inbasket[2,i]:=0;
  end;
  basket1.top:=slots[0].topslot.y+slots[0].image.height-basket1.height;
  basket2.top:=slots[0].bottomy-basket2.height;
  L1.height:=basket1.top-l1.top;
  L2.height:=basket2.top-l2.top;
  tempkey:=key;
  topweight:=0;
  bottomweight:=0;

  {movebasket1up;}
  with memo1 do
  begin
    Clear;
    lines.add(msg1);
    lines.add('');
    lines.add(msg2);
  end;
  justsolved:=false; {set true after solution found, so that next dragdrop will
                      automatically reset board}
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;
  canclose:=true;
end;

end.
