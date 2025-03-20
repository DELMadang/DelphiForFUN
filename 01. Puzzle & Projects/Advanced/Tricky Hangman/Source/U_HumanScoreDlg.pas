unit U_HumanScoreDlg;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{This dialog is called after a convict guess whenever  a human is the hangman
 and scoring without computer help}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  THumanScoreDlg = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    GuessLbl: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  public
    { Public declarations }
    knownpart:string;
    guess:char;
    lettersadded:integer;
    e:array of TEdit;
    procedure EditClick(Sender: TObject);
  end;

var
  HumanScoreDlg: THumanScoreDlg;

implementation

{$R *.DFM}

procedure THumanScoreDlg.OKBtnClick(Sender: TObject);
begin
  {check if any letters were really changed}
  if lettersadded>0 then modalresult:=MrOK else modalresult:=MrCancel;
end;

{***************** FormActivate *****************}
procedure THumanScoreDlg.FormActivate(Sender: TObject);
{Set up clickable edit boxes for all underscore characters so human
 hangman can indicate which lettters are matched by the convict's guess}
var  i:integer;
begin
  guesslbl.caption:=GUESS;
  lettersadded:=0;
  with panel1 do  {free and rebuild partial word & checkboxes}
  begin
    if length(e)>0 then for i:=0 to high(e) do e[i].free;
    setlength(e,length(knownpart));
    for i:= 1 to length(knownpart) do
    begin
      e[i-1]:=TEdit.create(panel1);
      with e[i-1] do
      begin
        parent:=panel1;
        left:=16+24*(i-1);
        top:=8;
        text:=knownpart[i];
        width:=24;
        if knownpart[i]<>'_' then enabled:=false
        else onclick:=EditClick;
      end;
    end;
  end;
end;

{**************** EditClick **************}
procedure THumanScoreDlg.EditClick(Sender: TObject);
{User clicked a letter -  insert or remove a letter in the partial word
(2nd click removes to allow error to be corrected) }
var
  n:integer;
begin
  with sender as TEdit do
  begin
    n:=(left-16) div 24 +1; {left coordinate of sender tells us which letter}
    if knownpart[n]='_' then
    begin
      knownpart[n]:=guess;
      inc(lettersadded);
    end
    else
    begin
      knownpart[n]:='_';
      dec(lettersadded);
    end;
    e[n-1].text:=knownpart[n];
  end;
end;

end.
