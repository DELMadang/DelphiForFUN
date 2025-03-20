unit U_Digittree2;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Shape2: TShape;
    Shape6: TShape;
    Shape4: TShape;
    Shape1: TShape;
    Shape3: TShape;
    Shape7: TShape;
    Shape5: TShape;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    ResetBtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Solvedtext: TStaticText;
    Label1: TLabel;
    HintBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Label9DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Label9DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure HintBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    labels:array[1..9] of TLabel;
    shapes:array[1..7] of TShape;
    centers:array[1..7] of TPoint;
    hints:array[1..7] of integer;
    labelstart:TPoint;
    LabelInc:integer;
    hintcount:integer;
    procedure resetlabel(nbr:integer);
    procedure movelabel(Mover, target:TControl);
    procedure movelabelLeft(Mover, target:TControl);
    procedure movelabelRight(Mover, target:TControl);
    procedure checkvalid;
    procedure CleanupShapeTag(N:integer);
    procedure fillHints;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{*********** FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
  {Put the pointers to labels and shapes into an array to simplify coding}
  labels[1]:=Label9;
  labels[2]:=Label10;
  labels[3]:=Label11;
  labels[4]:=Label12;
  labels[5]:=Label13;
  labels[6]:=Label14;
  labels[7]:=Label15;
  labels[8]:=Label16;
  labels[9]:=Label1;

  shapes[1]:=shape1;
  shapes[2]:=shape2;
  shapes[3]:=shape3;
  shapes[4]:=shape4;
  shapes[5]:=shape5;
  shapes[6]:=shape6;
  shapes[7]:=shape7;

  for i:=1 to 7 do
  with centers[i], shapes[i] do
  begin
    x:=left + width div 2;
    y:=top + height div 2;
  end;

  with labels[1] do
  begin
    labelstart:=point(left,top);
    labelInc:=height+8;
  end;
  for i:=1 to 9 do labels[i].tag:=i;
  for i:= 1 to 7 do shapes[i].tag:=0;
  randomize;
  Fillhints;
  solvedtext.BringToFront;
end;

{************* ResetBtnClick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
var i:integer;
begin
  for i:=1 to 9 do resetlabel(i);
  hintcount:=0;
end;

{************ HintBtnClick *********}
procedure TForm1.HintBtnClick(Sender: TObject);
var
  n,leftn,rightn:integer;
  i,count:integer;
  shown, reset:boolean;
begin
  shown:=false;
  count:=0;
  repeat
    inc(count);
    n:=random(7)+1;
    leftN:=hints[N] div 10;
    rightn:=hints[n] mod 10;
    {If either part (or both parts) of this number are on the wrong shape,
     move the back to their home stations}
    reset:=false;

    for i:= 1 to 7 do
    with shapes[i] do
    begin
      if (leftn>0) and ((tag=leftn) or (tag div 10=leftn)) then
      begin
        if (i<>n) then
        begin
          resetlabel(leftn);
          reset:=true;
        end;
      end;
      if  (tag mod 10 = rightn) then
      begin
        if (i<>n) then
        begin
          {handle special case - shapes 4 and 5 can contain values 6 or 9 in either order}
          if ((i=4) or (i=5)) and ((rightn=6) or (rightn=9)) then
          else
          begin
            resetlabel(rightn);
            reset:=true;
          end;
        end;
      end;
    end;

    if (not reset) then
    begin
      {Otherwise, place an unfilled shape with the correct value}

      if (leftN>0) {2 digit hint}
         and (labels[leftn].Left=labelstart.x)  then
      begin
         with centers[N] do shape1dragdrop(shapes[N],labels[leftN],x-5,y);
         shown:=true;
      end;
      if (labels[rightn].Left=labelstart.x) then
      begin
        {handle special case - shapes 4 and 5 can contain values 6 or 9 in either order}
        if ((n=4) or (n=5)) and (rightn=6) and (shapes[n].tag=9)
        then
          if (shapes[4].tag=0) then n:=4
          else if (shapes[5].tag=0) then n:=5
               else n:=0
        else if ((n=4) or (n=5)) and (rightn=9) and (shapes[n].tag=6)
        then
          if (shapes[4].tag=0) then n:=4
          else if (shapes[5].tag=0) then n:=5
               else n:=0;

        If n>0 then
        begin
          with centers[N] do shape1dragdrop(shapes[N],labels[rightN],x,y);
          shown:=true;
        end;
      end;

      if shown then
      begin
        application.processmessages;
        sleep(1000);
        if leftN>0 then resetlabel(leftN);
        resetlabel(rightN);
      end;
    end
    else shown:=true;
  until shown or (count>=200);
  if shown then inc(hintcount);
end;

{*********** ResetLabel ***********}
procedure TForm1.resetlabel(nbr:integer);
{move a label back to its home column}
var i:integer;
begin
  with labels[nbr] do
  begin
    left:=labelstart.x;
    top:=labelstart.y + (nbr-1)*labelinc;
    for i:= 1 to 7 do
    if shapes[i].tag mod 10 =nbr then
    begin
      shapes[i].tag:= shapes[i].tag div 10;
      shapes[i].brush.color:=clWindow;
      break;
    end
    else if shapes[i].tag div 10 =nbr then
    begin
      shapes[i].tag:=shapes[i].tag mod 10;
      shapes[i].brush.color:=clWindow;
      break;
    end;
  end;
  checkvalid;
end;

{************** MoveLabel *************}
procedure TForm1.movelabel(Mover,Target:TCOntrol);
{move label to center of shape}
begin
  Mover.left:=Target.left+(Target.width-Mover.width) div 2;
  Mover.top:=target.top+(target.height-Mover.height) div 2;
  target.tag:=Mover.tag;
end;

{************** MoveLabelLeft *************}
procedure TForm1.movelabelLeft(Mover,Target:TCOntrol);
{move label to left digit position of 2 digit number}
begin
  Mover.left:=Target.left+(Target.width div 2) -mover.width;
  Mover.top:=target.top+(target.height-Mover.height) div 2;
  target.tag:=target.tag+10*Mover.tag;
end;

{************** MoveLabelRight *************}
procedure TForm1.movelabelRight(Mover,Target:TCOntrol);
{move label to right digit position of 2 digit number}
begin
  Mover.left:=Target.left+(Target.width div 2);
  Mover.top:=target.top+(target.height-Mover.height) div 2;
  target.tag := 10*target.tag + Mover.tag;
end;

{************ CleanupShapetag *********}
procedure TForm1. CleanupShapeTag(N:integer);
{If a label was been moved, we need to 0 that tag value if it was on another
 shape}
 var i:integer;
 begin
   for i:=1 to 7 do
   begin
     if Shapes[i].tag=n then
     begin
       shapes[i].tag:=0;
       break;
     end
     else if shapes[i].tag div 10 = n then
     begin
       shapes[i].tag := shapes[i].Tag mod 10;
       break;
     end
     else if shapes[i].tag mod 10 = n then
     begin
       shapes[i].tag := shapes[i].Tag div 10;
       break;
     end;
   end;
 end;

{************ Checkvalid *****************}
procedure TForm1.checkvalid;
{check shape values}
{If 3 numbers on a side are filled, color the sum square red or grenn based on
 whether the sum condiiton is satisfied}
var
  i:integer;
  solvedcount:integer;
begin
  solvedcount:=0;
  if shapes[4].tag*shapes[5].tag*shapes[6].tag*shapes[2].tag>0 then
  begin
    if (shapes[4].tag+shapes[5].tag+shapes[6].tag=shapes[2].tag) then
    begin
      inc(solvedcount);
      shapes[2].brush.color:=clgreen;
    end
    else shapes[2].brush.color:=clred;
  end
  else shapes[2].brush.color:=clwindow;
  if shapes[6].tag*shapes[7].tag*shapes[3].tag>0 then
  begin
    if (shapes[6].tag+shapes[7].tag=shapes[3].tag) then
    begin
      inc(solvedcount);
      shapes[3].brush.color:=clgreen;
    end
    else shapes[3].brush.color:=clred;
  end
  else shapes[3].brush.color:=clwindow;
  if shapes[2].tag*shapes[3].tag*shapes[1].tag>0 then
  begin
    if (shapes[2].tag+shapes[3].tag=shapes[1].tag) then
    begin
      inc(solvedcount);
      shapes[1].brush.color:=clgreen;
    end
    else shapes[1].brush.color:=clred;
  end
  else shapes[1].brush.color:=clwindow;
  if solvedcount=3 then {all 3 equations have been satisfied}
  begin
    with solvedtext do
    if Hintcount>0
    then caption:='  You did it but...      (with my help!)'
    else caption:='  Congratulations!        You did it!';

    for i:=1 to 6 do
    begin  {flash solved message}
      solvedtext.visible:=not solvedtext.visible;
      update;
      sleep(1000);
    end;
  end;
end;

{*******************************************}
{               Drag routines               }
{*******************************************}

{************* FormDragOver **************}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   accept:=true;
end;

{*************** FormDragDrop **************}
procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin  {value label dropped on the form, move back to it "home" location}
   resetlabel(TControl(source).tag);
end;

{************* Shape1DragOver ************}
procedure TForm1.Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Shape can always accept a dropped label}
begin
  Accept:=true;
end;

{************** Shape1DragDrop ***********}
procedure TForm1.Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
{Dropped a value label on a shape}
begin
  with TShape(Sender) do
  begin
    {if shape being dropped on already contains a label, reset that label}
    if tag<>0 then
    begin  {there are already 1 or 2 labels on  this circle}
      {if one, we'll add the second one to right or left depending on X value}
      if tag>=10 then
      begin  {two labels already there, reset left or right one depending on
              where the dropped occurred}
        if x<width div 2 then
        begin
          resetlabel(tag div 10);
          tag:=tag mod 10;
        end
        else
        begin
          resetlabel(tag mod 10);
          tag:=tag div 10;
        end;
      end;
      {only one label, add 2nd}
      {In case the label being dropped was dragged from another shape we need to
      adjust the tag for that shape to reflect the fact that the label has been moved}
      cleanupshapetag(TControl(source).tag);
      if x< width div 2 then
      begin
        {move the label that's there to the right a little}
        with labels[tag] do left :=left + width div 2;
        movelabelleft(TControl(source), TControl(sender));
      end
      else
      begin
        with labels[tag] do left:=left - width div 2;
        movelabelright(TControl(source), TControl(sender));
      end;
    end
    else
    begin  {no labels, add one}
      {the label being dropped may have been dragged from another shape,
       if so - reset that tag for that shape since it is being transferred to
       a different shape}
       cleanupshapetag(TControl(source).tag);
       movelabel(TControl(source),TControl(sender));
     end;
  end;
  CheckValid;
end;

{************ LabelDragOver **********}
procedure TForm1.Label9DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{we can always drop a label on a label}
begin
  accept:=true;
end;

{************* LabelDragDrop ************}
procedure TForm1.Label9DragDrop(Sender, Source: TObject; X, Y: Integer);
{dropping a  label on a label..}
var i:integer;
begin
  { if the label is in its home column, then reset the label being dropped}
  {if the label is in the figure, then reset the label being dropped on}
  If TControl(sender).left=labelstart.x then resetlabel(TControl(source).tag)
  else
  begin  {the label we are dropping is already in a shape}
    for i:=1 to 7 do {find the shape holdng the label we are dropping on}
    if shapes[i].tag=TControl(sender).tag  then
    begin
      resetlabel(TControl(sender).tag); {move that label back home}
      Shape1dragDrop(shapes[i],source,x,y); {and simulate a drop on that shape}
      break; {might as well stop searching}
    end;
  end;
end;



{********* FillHints ***********}
Procedure TForm1.fillHints;
{Solve the puzzle and save solution in Hints array}
var
  s1,s2,s3,s4,s5,s6,s7:integer;
  f,g,h,i:integer;
  used:array[1..9] of boolean;
begin
   {Number shapes 1 to 7 from top to bottom and left to right}
   {shape2:=shape4+shape5+shape6}
   {shape3:=shape6+shape7}
   {shape1=shape2+shape4}
   {need to use digits 1 through 9 to form 7 integers, 5 single digit and 2
    double digit}
   {One of shape2 or shape3 must be 2 digit and shape1 is 2 digit}
   {Therefore the single digit numbers are (shape2 or shape3), shape4, shape5,
    shape6, shape7}
   {1 and 2 will be the left digits of the 2 digit numbers, so cannot be
    included in the single digit numbers}
  for f:=1 to 9 do used[f]:=false; {keep track of used digits}
  for s6:=3 to 9 do {try all possible values for s6}
  begin
    used[s6]:=true;
    for s7:= 3 to 9 do {try all possible values for s7}
    if not used[s7] then
    begin
      used[s7]:=true;
      s3:=s6+s7;
      if (s3<10) and (not used[s3]) {assume that s3 is the 1 digit sum}
      then
      begin  {could be a valid s6+s7=s3 solution}
        used[s3]:=true;
        for s4:=3 to 9 do {try all possible values for s4}
        if not used[s4] then
        begin
          used[s4]:=true;
          for s5:=3 to 9 do {try all possible values for s5}
          if not used[s5] then
          begin
            used[s5]:=true;
            s2:=s4+s5+s6;
            if (s2>10)  {assume the s2 will be the lower 2 digit value}
            then
            begin
              f:=s2 div 10; {left digit}
              g:=s2 mod 10; {right digit}
              if (f>0) and (g>0) and (not used[f]) and (not used[g])
              and (f<>g) then
              begin
                used[f]:=true;
                used[g]:=true;
                s1:=s2+s3;
                if s1>10 then
                begin  {if s1 cotains the last two unused digits, we have a solution}
                  h:=s1 div 10; {left digit}
                  i:=s1 mod 10; {right digit}
                  if (h>0) and (i>0) and (not used[h]) and (not used[i])
                  and (h<>i) then {yes!}
                  begin
                    hints[1]:=s1;
                    hints[2]:=s2;
                    hints[3]:=s3;
                    hints[4]:=s4;
                    hints[5]:=s5;
                    hints[6]:=s6;
                    hints[7]:=s7;
                    exit;
                  end;
                end;
                {after each value test, marked as unused for the next test}
                used[f]:=false;
                used[g]:=false;
              end;
            end;
            used[s5]:=false;
          end; {s5}
          used[s4]:=false;
        end; {s4}
        used[s3]:=false;
      end; {s3}
      used[s7]:=false;
    end; {s7}
    used[s6]:=false;
  end;{s6}
end;

{************* FormPaint ***********}
procedure TForm1.FormPaint(Sender: TObject);
begin {draw the lines connecting the circles}
   with canvas do
  begin  {form is painted before shapes, so OK to draw center to center}
    with centers[1] do moveto(x,y); with centers[2] do lineto(x,y);
    with centers[1] do moveto(x,y); with centers[3] do lineto(x,y);
    with centers[2] do moveto(x,y); with centers[4] do lineto(x,y);
    with centers[2] do moveto(x,y); with centers[5] do lineto(x,y);
    with centers[2] do moveto(x,y); with centers[6] do lineto(x,y);
    with centers[3] do moveto(x,y); with centers[6] do lineto(x,y);
    with centers[3] do moveto(x,y); with centers[7] do lineto(x,y);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/programs/download/bruteforce.zip',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

