unit U_SelectPattern;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation.
 }

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, U_Mastermind, dialogs;

type
  TPatternDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    PaintBox1: TPaintBox;
    RandomBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure RandomBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    {incrx,incry,offseth,offsetw:integer;}
    userguess:TPattern;
    function makerandompattern:TPattern;
  end;

var
  PatternDlg: TPatternDlg;

implementation

uses U_ShowPattern;

{$R *.DFM}

procedure TPatternDlg.FormActivate(Sender: TObject);
begin
  label1.caption:='Select '+inttostr(nbrpegs)
                  + ' pegs for secret pattern by clicking on peg holes';
  
  with paintbox1 do
  Begin
  (*
    incry:=height div 2;
    incrx:=width div (nbrpegs+1);
    offseth:=incry div 2;
    offsetw:=incrx div 2;
    for i:= 0 to nbrpegs-1 do
    Begin
      ileft:=offsetw+i*incrx+4;
      itop:=offseth + 2;
      canvas.brush.color:=clblack;
      canvas.Pen.color:=clteal;
      canvas.pen.width:=4;
      canvas.ellipse(ileft,itop,ileft+incrx,itop+incry);
    end;
    for i:=1 to nbrpegs do form1.showbigpeg(-1,i,0,paintbox1);
    *)
    If Form1.patternOK(Form1.secretpattern) then userguess:=form1.secretpattern
    else userguess:=makeRandomPattern;
  end ;

end;


function TPatternDlg.makerandompattern:TPattern;
{called if we enter without a valid secret pattern}
var
  i:integer;
begin
  for i:=1 to nbrpegs do result[i]:=random(nbrcolors)+1;
end;


procedure TPatternDlg.PaintBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  newrow,newcol:integer;
begin
  newcol:= (x-offsetw-4)*nbrpegs div paintbox1.width + 1;
  newrow:= (y-offseth) div incry+1;
  If (newrow=1) and (newcol>=1) and (newcol<=nbrpegs) then
  Begin
    inc(userguess[newcol]);
    if userguess[newcol]>nbrcolors then userguess[newcol]:=userguess[newcol]-nbrcolors;
    Form1.showbigpeg(userguess[newcol],newcol,0,Paintbox1);
  end;
end;

procedure TPatternDlg.PaintBox1Paint(Sender: TObject);
var
  i:integer;
begin
  For i:= 1 to nbrpegs do
    Form1.showbigpeg(userguess[i],i,0,Paintbox1);
end;

procedure TPatternDlg.OKBtnClick(Sender: TObject);
begin
  If not Form1.patternOK(Userguess) then
  Begin
    showmessage('Select '+ inttostr(nbrpegs) + ' pegs first');
    modalresult:=0;
  end
  else modalresult:=MrOK;
end;

procedure TPatternDlg.RandomBtnClick(Sender: TObject);
begin
  userguess:=makerandompattern;
  paintbox1.invalidate;
end;

end.
