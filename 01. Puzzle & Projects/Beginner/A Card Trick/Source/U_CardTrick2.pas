unit U_CardTrick2;

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
    Button4: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    AnswerGrp: TRadioGroup;
    Thankslbl: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Next1BtnClick(Sender: TObject);
    procedure Next2BtnClick(Sender: TObject);
    procedure ReplayBtnClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure AnswerGrpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cards1:array[1..6] of TCard;
    cards2:array[1..5] of TCard;

    cards:array[0..11] of TCard;
    index1, index2: array[0..5] of integer; {pointers to cards to display}

    function makecard(L,T:Integer; newvalue:TCardValue; newSuit:TShortSuit):TCard;
    procedure setup1;
  end;

var
  Form1: TForm1;

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
    top:=T;
    left:=L;
    setcard(newvalue,newSuit);
  end;
end;

{******************** Setup1 ******************}
procedure TForm1.setup1;
{setup 1st panel, called by formactivate and by Replay button}
var
  i,j:integer;
  n,k:integer;
  start,starty,incr:integer;
begin
  {assign one J,Q,K of each color for the original 6 cards}
  {assign 5 of the 6 remaining cards to th 2nd display set}
  {shuffle the 12 posible card nbrs}
  for i:= 0 to 2 do
  begin
    index1[2*i]:=4*i+2*random(2);
    index1[2*i+1]:=4*i+1+ 2*random(2);
    if index1[2*i]=4*i then index2[2*i]:=4*i+2 else index2[2*i]:=4*i;
    if index1[2*i+1]=4*i+1 then index2[2*i+1]:=4*i+3 else index2[2*i+1]:=4*i+1;

  end;

  for j:= 1 to 10 do
  for i:= 0 to 5 do
  begin
    k:=random(6);
    n:=index1[k];
    index1[k]:=index1[i];
    index1[i]:=n;
    k:=random(6);
    n:=index2[k];
    index2[k]:=index2[i];
    index2[i]:=n;
  end;
  start:=100;
  incr:=75;
  starty:=325;
  for i:=0 to 5 do
  with cards[index1[i]] do
  begin
    left:= start+i*incr;
    top:=starty;
    visible:=true;
  end;
  start:=150;
  incr:=75;
  for i:=0 to 5 do
  with cards[index2[i]] do
  begin
    left:= start+i*incr;
    top:=starty;
    visible:=false;
  end;
  panel1.bringtofront;
end;

{****************** FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialize cards}
var
  i:integer;
  suit:TShortSuit;
  start,starty:integer;
begin
  makecaption('Technology Breakthrough!',#169+' 2002, G.Darby, delphiforfun.org',self);
   start:=100;
   starty:=325;
  for i:= 11 to 13 do for suit:=low(suit)  to high(suit) do
    cards[4*(i-11) + ord(suit)] :=makecard(start,starty,i,suit);
  (*
  cards1[2]:=makecard(start+incr,starty,11,C);
  cards1[3]:=makecard(start+2*incr,starty,13,S);
  cards1[4]:=makecard(start+3*incr,starty,12,D);
  cards1[5]:=makecard(start+4*incr,starty,12,C);
  cards1[6]:=makecard(start+5*incr,starty,11,D);
  start:=150;
  incr:=75;
  cards2[1]:=makecard(start,starty, 12,H);
  cards2[2]:=makecard(start+incr,starty, 13,C);
  cards2[3]:=makecard(start+2*incr, starty,11,H);
  cards2[4]:=makecard(start+3*incr, starty, 12,S);
  cards2[5]:=makecard(start+4*incr, starty, 13,D);
  *)
  setup1;
end;

procedure TForm1.Next1BtnClick(Sender: TObject);
var
  i:integer;
begin
  for i:= 0 to 5 do cards[index1[i]].visible:=false;
  panel2.bringtofront;
end;

procedure TForm1.Next2BtnClick(Sender: TObject);
var i:integer;
begin
  for i:= 0 to 4 do cards[index2[i]].visible:=true;
  answergrp.visible:=true;
  answergrp.itemindex:=-1;
  thankslbl.visible:=false;
  panel3.bringtofront;
end;

procedure TForm1.ReplayBtnClick(Sender: TObject);
begin  Setup1;  end;

procedure TForm1.Button4Click(Sender: TObject);
begin  close;  end;

procedure TForm1.AnswerGrpClick(Sender: TObject);
begin
  answergrp.visible:=false;
  Thankslbl.visible:=true;
end;

end.
