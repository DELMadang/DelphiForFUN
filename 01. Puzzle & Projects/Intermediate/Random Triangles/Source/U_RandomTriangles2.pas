unit U_RandomTriangles2;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {What is probability that a stick broken into 3 random  pieces can be
 reassembled to form a triangle?}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, shellapi, jpeg;

type
  THistrec=record
    HistTotCount, HistOKcount:integer;
  end;


  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    MakeManyBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Image1: TImage;
    MakeOneBtn: TButton;
    TabSheet2: TTabSheet;
    RichEdit1: TRichEdit;
    ClearBtn: TButton;
    StaticText1: TStaticText;
    TabSheet3: TTabSheet;
    Memo3: TMemo;
    Strat1Btn: TButton;
    Strat2Btn: TButton;
    Strat3Btn: TButton;
    Memo4: TMemo;
    Strat2Theory: TButton;
    Button5: TButton;
    Image2: TImage;
    StaticText2: TStaticText;
    procedure MakeManyBtnClick(Sender: TObject);
    procedure MakeOneBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Strat1BtnClick(Sender: TObject);
    procedure Strat2BtnClick(Sender: TObject);
    procedure Strat3BtnClick(Sender: TObject);
    procedure Strat2TheoryClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    L:array[1..3] of EXTENDED;  {The 3 lengths}
    OKCount, TotCount:integer;  {Counts of successful and total trials}
    where:string;
    hist:array[0..99] of THistRec;

    function Maketriangle(strategy:integer):boolean;
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

  procedure swap(var a,b:extended);
  {Swap two variables - used for sorting piece lengths}
  var x:extended;
  begin   x:=a; a:=b; b:=x;   end;

{***************** MakeTriangle ************}
 function TForm1.maketriangle(Strategy:integer):boolean;
 {try to make a random triangle by cutting a stick of unit length to into
  3 random length pieces}
 var
   p1,p2:extended;
   P1Int:integer;
   
    function calclengths:boolean;
    var
      j,k:integer;
      begin
      {CALCULATE LENGTHS OF THE PIECES FROM THE 2 CUT POINTS}
      IF p1>p2 then {p2 is the leftmost cut point}
      begin
        L[1]:=p2;
        L[2]:=p1-p2;
      end
      else
      begin  {p1 is the leftmost cut point}
        L[1]:=p1;
        L[2]:=p2-p1;
      end;
      L[3]:=1-L[1]-L[2]; {Either way, final piece is whatever is left over}


      {Now sort descending by length}
      for j:= 1 to 2 do
        for k:= j+1 to 3 do  if L[j]<L[k] then swap(L[j],L[k]);

      {If L[1], longest piece, is greater than sum of the other two pieces,
       no triangle is possible}
      if L[1]>0.5 then result:=false else result:=true;
    end;


 begin
   {Strategy 3 randomly clooses between Strategy 1 and Strategy 2}
   if strategy=3 then if random(2)=0 then strategy:=1 else strategy:=2;

   case strategy of
     0:
     begin
       {MAKE TWO RANDOM CUTS IN A PIECE 1 UNIT LONG}
       p1:=random; {1st point - random # between 0 and 1}
       p2:=random; {2nd point - random # between 0 and 1}
       result:=Calclengths;
     end;
     1:
     begin
       {MAKE A RANDOM CUT IN A PIECE 1 UNIT LONG}
       p1:=random; {1st point - random # between 0 and 1}
       {Make 2nd random cut on shorter piece (should have 0 chance of success)}
       if p1>=0.5 then p2:=p1+(1-p1)*random
       else p2:=p1*random;
       result:=Calclengths;
     end;
     2:
     begin
       {MAKE A RANDOM CUT IN A PIECE 1 UNIT LONG}
       (*
       p1:=random; {1st point - random # between 0 and 1}
       {Make 2nd random cut on longer piece}
       if p1<=0.5 then p2:=p1+random*(1-p1)
       if p1<=0.5 then p2:=p1+random*(1-p1)
       else p2:=random*p1;
       *)

       {Might as well make the 1st in the left half - results are the same
        as making it randomly and turning the stick around if point is in then
        right half}
        p1:=0.5*random; p2:=p1+random*(1-p1);

       result:=Calclengths;

       (*  {used for debugging}
       {Accumulate Histogram}
       P1Int:=trunc(100*p1);
       with hist[p1Int] do
       begin
         inc(Histtotcount);
         if result then inc(HistOKcount);
       end;
       *)
     end;
     else result:=false;
   end; {case}
 end;

{************* MakeManyBtnClick **************}
procedure TForm1.MakeManyBtnClick(Sender: TObject);
var i:integer;
begin
  for i:=1 to 1000000 do
  begin
    inc(totcount);
    if maketriangle(0) then inc(OKcount);
  end;
   memo1.lines.add(format('%6.0n out of %7.0n can form triangle, %4.1n%%',
             [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
end;

{************** MakeOneBtnClick *************}
procedure TForm1.MakeOneBtnClick(Sender: TObject);
{try a single triangle and draw an image of results}
var
  scale:extended;
  s,a:extended;
begin
  inc(totcount);
  with image1, canvas do
  begin
    pen.width:=3;
    rectangle(clientrect);  {clear the image}
    moveto( 20,height-10);  {move pen to start of base line}
    if maketriangle(0) then
    begin
      {If we draw L[1] as the base, we need only to compute the point where
       L[2] and L[3] intersect.  See web site for derivation of the foillowig
       equations for "s" (x offset from left end of base) and "a" (y offset to
       top vertex)}
      inc(OkCount);
      s:=(L[2]*L[2]-L[3]*L[3]+L[1]*L[1])/L[1]/2; {compute x offset to 3rd vertex}
      a:=sqrt(l[2]*L[2]-s*s); {compute altitude to 3rd vertex}

      scale:=0.8*width/L[1];   {make longest line cover 80% of image width}
      {or scale by altitude if peak would be offscreen}
      if scale*a+10>height then scale:=0.8*(height/a);
      memo1.lines.add(format('Valid - L1= %5.3f L2=%5.3f L3=%5.3f',[L[1],L[2],L[3]]));
      {finish drawing the triangle}
      lineto(20+trunc(scale*L[1]),height-10);
      lineto(20+trunc(scale*L[1])-trunc(scale*s),height-10-trunc(scale*a));
      lineto(20,height-10);
      textout(5,5,'Yes!');
    end
    else
    begin
      memo1.lines.add(format('Invalid - L1= %5.3f L2=%5.3f L3=%5.3f',[L[1],L[2],L[3]]));
      scale:=width;
      lineto(20+trunc(scale*L[1]),height-10); {draw base line}
      {draw the two short lines parallel and above the base line}
      moveto( 20,height-20);
      lineto(20+trunc(scale*L[2]),height-20);
      moveto(20+trunc(scale*L[1]),height-20);
      lineto(20+trunc(scale*(L[1]-L[3])),height-20);
      textout(5,5, 'No :>(');
    end;
  end;
  memo1.lines.add(where);
  memo1.lines.add(format('%6.0n out of %7.0n can form triangle, %4.1n%%',
                         [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
end;

{************ FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize; {make random results not repeatable}
  clearbtnclick(sender);
end;

{************** ClearBtnClick ***********}
procedure TForm1.ClearBtnClick(Sender: TObject);
{reset everything}
begin
  okcount:=0;
  totcount:=0;
  memo1.clear;
  image1.canvas.rectangle(image1.clientrect);

end;



{*************** Strat1btnClick *************8}
procedure TForm1.Strat1BtnClick(Sender: TObject);
{Strategy 1: 1st cut at random location, 2nd cut to shorter side, should be
              zero chance of forming a valid triangle}
var i:integer;
begin
  totcount:=0;
  OKCount:=0;
  for i:=1 to 1000000 do
  begin
    inc(totcount);
    if maketriangle(1) then inc(OKcount);
  end;
  memo4.lines.add('Alternate Strategy 1: 2nd cut at random location on shortest piece after 1st cut');
  memo4.lines.add(format('  %6.0n out of %7.0n can form triangle, %4.1n%%',
                         [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
  memo4.lines.add('');
end;

{************** Strat2btnClick ************}
procedure TForm1.Strat2BtnClick(Sender: TObject);
{Strategy 2: 1st cut at random location, 2nd cut to longer side}
  var i:integer;
  probsum:extended;
begin
  totcount:=0;
  OKCount:=0;
  for i:=low(hist) to high(hist) do
  with hist[i] do
  begin
    HistTotcount:=0;
    HistOKcount:=0;
  end;

  for i:=1 to 1000000 do
  begin
    inc(totcount);
    if maketriangle(2) then inc(OKcount);
  end;

  With memo4, lines do
  begin
    add('Alternate Strategy 2: 2nd cut at random location on longest piece after 1st cut');
    add(format(' %6.0n out of %7.0n can form triangle, %4.1n%%',
                         [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
    add('');
    (*
    OkCOunt:=0;
    Totcount:=0;
    probsum:=0;


    add('');
    add('Histogram results for Strat 2: 2nd cut at random location on longest piece after 1st cut');
    for i:=low(hist) to high(hist) do
    with hist[i] do
    begin
     if Histtotcount>0
     then
     begin

       inc(okcount,HistOKcount);
       inc(totcount,HistTotcount);
       add(format('P1=%d, had %d successes out of %d trials, Prob=%.3f  Cum Prob=%.3f',
                            [i,HistOKcount, Histtotcount, HistOKcount/Histtotcount, okcount/totcount]));
     end;
    end;

    lines.add(format(' %6.0n out of %7.0n can form triangle, %4.1n%%',
                         [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
    *)
  end;
end;


{*********** Strat3BtnClick ***************}
procedure TForm1.Strat3BtnClick(Sender: TObject);
{Strategy 3: 1st cut at random location, 2nd cut  on randomly chosen side. Chance
 of forming a valid triangle should be 1/2 that computed for Strategy #2}
var i:integer;
begin
  totcount:=0;
  OKCount:=0;
  for i:=1 to 1000000 do
  begin
    inc(totcount);
    if maketriangle(3) then inc(OKcount);
  end;
  memo4.lines.add('Alternate Strategy 3: Randomly choose Strategy 1 or Strategy 2');
  memo4.lines.add(format(' %6.0n out of %7.0n can form triangle, %4.1n%%',
                          [0.0+OkCount,0.0+totcount, 100*OKcount/totcount]));
  memo4.lines.add('');
end;

{********* Start2TheoryBrn **************}
procedure TForm1.Strat2TheoryClick(Sender: TObject);
var
  i,nbrsteps,count:integer;
  p1,prob:extended;
  sum:extended;
begin
  okcount:=0;
  sum:=0.0;
  nbrsteps:=100;
  p1:=0.5/(2*nbrsteps); {start at middle of first interval}
  memo4.clear;
  memo4.lines.add('This routine calculates the theoretical probability of successfully completing a triangle'
      + ' from a stick of length 1 '
      + 'for 100 first cuts at point P stepping by 0.05 from 0.0 to 0.495.  Since all 100 '
      + 'cuts are equally likely, we can validly average the probablitilies that the '
      +'second random cut to the right of P will result in a valid triangle.');
 memo4.Lines.add('Stick lengths to the right of a cut at P have length of 1-P.  The probability '
      +'that neither piece resulting from a second cut will be longer than 0.5, is '
      +'P/(1-P). Visit Random Triangles DFF link for derivation.');

  for i:= 0 to nbrsteps-1 do
  begin
    prob:=p1/(1-p1);
    sum:= sum+prob;
    with memo4,lines do
     add(format('Step:%3d  P:%.3f, P/(1-P):%.3f, Cumulative Prob:%.3f',
                           [i+1,p1,prob, sum/(i+1)]));
    p1:=p1+ 0.5/nbrsteps;
  end;
  memo4.selstart:=0; memo4.sellength:=0;

  showmessage(format('Probability of forming triangles=%.3f for %d equally spaced 1st cuts between 0 and 0.5',[sum/nbrsteps,nbrsteps]));

end;


procedure TForm1.Button5Click(Sender: TObject);
begin
  memo4.Clear;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/Programs/Random_Triangles.htm',
  nil, nil, SW_SHOWNORMAL) ;

end;

end.
