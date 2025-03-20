unit U_AddedCorners;
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
    Shape8: TShape;
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
  private
    { Private declarations }
  public
    labels:array[1..8] of TLabel;
    shapes:array[1..8] of TShape;
    labelstart:TPoint;
    LabelInc:integer;
    procedure resetlabel(nbr:integer);
    procedure movelabel(Mover, target:TControl);
    procedure checkvalid;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  {Put the pointers to labels and shapes into an array for
   simpler coding}
  labels[1]:=Label9;
  labels[2]:=Label10;
  labels[3]:=Label11;
  labels[4]:=Label12;
  labels[5]:=Label13;
  labels[6]:=Label14;
  labels[7]:=Label15;
  labels[8]:=Label16;

  shapes[1]:=shape1;
  shapes[2]:=shape2;
  shapes[3]:=shape3;
  shapes[4]:=shape4;
  shapes[5]:=shape5;
  shapes[6]:=shape6;
  shapes[7]:=shape7;
  shapes[8]:=shape8;

  with labels[1] do labelstart:=point(left,top);
  labelInc:=labels[1].height+8;
  for i:=1 to 8 do
  begin
    labels[i].tag:=i;
    labels[i].color:=clwindow;
    shapes[i].tag:=0;
  end;
end;

{************* Shape1DragOver ************}
procedure TForm1.Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Shape can always accept a dropped label}
begin
  Accept:=true;
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
    for i:= 1 to 8 do
    if shapes[i].tag=nbr then
    begin
      shapes[i].tag:=0;
      shapes[i].brush.color:=clWindow;
      break;
    end;
  end;
end;

{************** MoveLabel *************}
procedure TForm1.movelabel(Mover,Target:TCOntrol);
begin
  Mover.left:=Target.left+(Target.width-Mover.width) div 2;
  Mover.top:=target.top+(target.height-Mover.height) div 2;
  target.tag:=Mover.tag;
end;

{************* FormDragOver **************}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);

begin
   accept:=true;
end;

{*************** FormDragDrop **************}
procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
   resetlabel(TControl(source).tag);
end;

{************** Shape1DragDrop ***********}
procedure TForm1.Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
var i:integer;
{Drop a label on a shape}
begin
   with TShape(Sender) do
  begin
    {if shape being dropped on already contains a label, reset that label}
    if tag<>0 then resetlabel(tag);  {Move label back to home base}
    {the label being dropped may have been dragged from another shape,
     if so - reset that tag for that shape since it is being trnsferred to
     a different shape}
    for i:=1 to 8 do if Shapes[i].tag=TControl(source).tag then
    begin
      shapes[i].tag:=0;
      break;
    end;
    {assign tag to receiving shape}
    tag:=TLabel(source).tag;
    {and move the label}
    movelabel(TControl(source), TControl(sender));
  end;
  CheckValid;
end;

{************ Checkvalid *****************}
procedure TForm1.checkvalid;
{check shape values}
{If 3 numbers on a side are filled, color the sum square red or grenn based on
 whether the sum condiiton is satidfied}
var
  i:integer;
  prev,next:integer;
  solvedcount:integer;
begin
  i:= 2;
  solvedcount:=0;
  repeat
    shapes[i].Brush.color:=clwindow;
    if shapes[i].tag>0 then
    begin
      if i>=8 then next:=1 else next:=i+1;
      prev:=i-1;
      if (shapes[prev].tag>0) and (shapes[next].tag>0) then
       begin
         If shapes[prev].tag+shapes[next].tag=shapes[i].tag
         then
         begin
            shapes[i].brush.color:=clgreen;
            inc(solvedcount);
         end
         else shapes[i].brush.color:=clred;
      end;
    end;
    inc(i,2);
  until i>8;
  if solvedcount=4 then
  for i:=1 to 6 do
  begin  {flash solved message}
    solvedtext.visible:=not solvedtext.visible;
    update;
    sleep(750);
  end;

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
    for i:=1 to 8 do {find the shape holdng the label we are dropping on}
    if shapes[i].tag=TControl(sender).tag  then
    begin
      resetlabel(TControl(sender).tag); {move that label back home}
      Shape1dragDrop(shapes[i],source,x,y); {and simulate a drop on that shape}
      break; {might as well stop searching}
    end;
  end;
end;

{************* ResetBtnClick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
var i:integer;
begin
  for i:=1 to 8 do resetlabel(i);
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
