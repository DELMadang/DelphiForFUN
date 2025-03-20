unit U_CardTrick;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  U_CardComponent, StdCtrls, ExtCtrls, UMakecaption;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Next1Btn: TButton;
    Label4: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    Next2Btn: TButton;
    Panel3: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    ReplayBtn: TButton;
    ExitBtn: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    AnswerGrp: TRadioGroup;
    Thankslbl: TLabel;
    LiarLbl: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Next1BtnClick(Sender: TObject);
    procedure Next2BtnClick(Sender: TObject);
    procedure ReplayBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure AnswerGrpClick(Sender: TObject);
  public
    cards1:array[1..6] of TCard; {Cards for 1st screen}
    cards2:array[1..5] of TCard; {cards for last screen}
    function makecard(L,T:Integer; newvalue:TCardValue; newSuit:TShortSuit):TCard;
    procedure setup1;
  end;

var   Form1: TForm1;

implementation

{$R *.DFM}

{********************* MakeCard ****************}
function TForm1.makecard(L,T:Integer; newvalue:TCardValue; newSuit:TShortSuit):TCard;
{create and set position for a card}
begin
  result:=TCard.create(self);
  with result  do
  begin
    parent:=self;
    top:=T; left:=L;
    setcard(newvalue,newSuit);
  end;
end;

{******************** Setup1 ******************}
procedure TForm1.setup1;
{setup 1st panel, called by formactivate and by Replay button}
var
  i:integer;
begin
  for i:=1 to 6 do cards1[i].visible:=true; {show 1st set of cards}
  for i:=1 to 5 do cards2[i].visible:=false; {hide the 2nd set of cards}
  panel1.bringtofront;
end;

{****************** FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialize cards}
  var start,incr,starty:integer;
begin
  makecaption('Technology Breakthrough!',#169+' 2002, G.Darby, delphiforfun.org',self);
  start:=100;
  incr:=75;
  starty:=350;
  cards1[1]:=makecard(start,starty,13,H);
  cards1[2]:=makecard(start+incr,starty,11,C);
  cards1[3]:=makecard(start+2*incr,starty,13,S);
  cards1[4]:=makecard(start+3*incr,starty,12,D);
  cards1[5]:=makecard(start+4*incr,starty,12,C);
  cards1[6]:=makecard(start+5*incr,starty,11,D);
  start:=150;
  cards2[1]:=makecard(start,starty, 12,H);
  cards2[2]:=makecard(start+incr,starty, 13,C);
  cards2[3]:=makecard(start+2*incr, starty,11,H);
  cards2[4]:=makecard(start+3*incr, starty, 12,S);
  cards2[5]:=makecard(start+4*incr, starty, 13,D);
  setup1;
end;

procedure TForm1.Next1BtnClick(Sender: TObject);
var i:integer;
begin
  for i:= 1 to 6 do cards1[i].visible:=false; {hide the cards}
  panel2.bringtofront;
end;

procedure TForm1.Next2BtnClick(Sender: TObject);
var i:integer;
begin
  for i:= 1 to 5 do cards2[i].visible:=true;
  answergrp.visible:=true;  {show the answer radio group}
  answergrp.itemindex:=-1;  {with nothing preselected}
  thankslbl.visible:=false; {and hide the response labels}
  liarlbl.visible:=false;
  panel3.bringtofront;
end;

procedure TForm1.ReplayBtnClick(Sender: TObject);
begin  Setup1;  end;

procedure TForm1.ExitBtnClick(Sender: TObject);
begin  close;  end;

procedure TForm1.AnswerGrpClick(Sender: TObject);
begin
  answergrp.visible:=false;
  if Answergrp.itemindex=0  {show one of the response labels}
  then Thankslbl.visible:=true else Liarlbl.visible:=true;
end;

end.
