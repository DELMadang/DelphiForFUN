unit U_DragColorsPuzzle;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ This program assigns hidden
colors to the three target circles.

Players task is to discover the secret
pattern by dragging colors to the
target circles and then clicking the
"Guess" button.

For extra credit:

What is the optimal (fewest
guesses) strategy?  What is the
expected number of guesses to
solve the puzzle under this strategy?
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellAPI;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    GroupBox2: TGroupBox;
    Shape3: TShape;
    Shape2: TShape;
    Shape1: TShape;
    Memo1: TMemo;
    GuessBtn: TButton;
    ResetBtn: TButton;
    StaticText1: TStaticText;
    procedure ShapeDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ShapeDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure GuessBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    nbrGuesses:integer;
    newcolor:array[1..3] of TColor;   {the "secret" pattern}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

VAR
 {color choices}
  colors:array[0..3] of TColor=(clred,clyellow,clblue,clLime);

{********* FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;  {initialize randomizer}
  resetBtnclick(sender);   {make the first guess}
end;

{*********** ShapeDragDrop ********}
procedure TForm1.ShapeDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  Tshape(sender).brush.color:=Tshape(source).brush.Color;
end;

{********** ShapeDragOver ***********}
procedure TForm1.ShapeDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin accept:=true; end;

{************** GuessBtnClick ***********}
procedure TForm1.GuessBtnClick(Sender: TObject);
var
  correct:integer;
  guessword, colorword:string;
begin
  Inc(nbrGuesses);   {Count total guesses}
  correct:=0;
  if  (shape1.brush.color=newcolor[1]) then inc(correct);
  if  (shape2.brush.color=newcolor[2]) then inc(correct);
  if  (shape3.brush.color=newcolor[3]) then inc(correct);
  if correct=3 then
  begin
    showmessage('Yes!!  Good job, you solved it in '
                +inttostr(Nbrguesses)+' guesses.');
    resetBtnclick(sender);
  end
  else
  begin
    {let's improve our grammer before showing message}
    if correct=1
    then colorword:=' color in the correct position'
    else colorword:=' colors in their correct positions' ;
    If nbrguesses=1
    then guessword:= ' guess.' else guessword:= ' guesses.';

    showmessage('Sorry, that is not correct. You have made  '
                +inttostr(NbrGuesses)+guessword
                + #13 {force a new line}
                +  'You have ' + inttostr(correct)
                   + colorword  );
  end;
end;

{************* ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var  i,n:integer;
     shape:Tshape;
begin
  {do not let user click a button while we are messing with the colors}
  guessbtn.enabled:=false;
  resetbtn.enabled:=false;
  {Flash 50 sets of colors just for a little glitz}
  for n:= 1 to 40 do
  begin
    sleep(50); {slow things down by sleeping 50 ms between displays}
    for i:=1 to 3 do
    begin
      newcolor[i]:=colors[random(4)];
      case i of
        1: shape:=shape1;
        2: shape:=shape2;
        3: shape:=shape3;
      end;
      shape.Brush.color:=newcolor[i];
      shape.repaint;
    end;
  end;

  {OK, we have a pattern, now hide the colors}
  shape1.Brush.color:=clwhite;
  shape2.Brush.color:=clwhite;
  shape3.Brush.color:=clwhite;

  NbrGuesses:=0;
  guessbtn.enabled:=true;
  resetbtn.enabled:=true;
end;

{***************** StaticsText1Click **********}
procedure TForm1.StaticText1Click(Sender: TObject);
{link to DFF home page}
begin
     ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
