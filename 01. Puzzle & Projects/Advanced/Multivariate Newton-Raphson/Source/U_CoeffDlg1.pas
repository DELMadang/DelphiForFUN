unit U_CoeffDlg1;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A dialog to capture coefficients for a set of quadratic equations with up to
 4 variables}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TEditsrec=record
    val:extended;  {value of the coefficient}
    edit:TEdit;    {the visible coefficient}
    IdLabel:TLabel; {id info following the coefficient}
  end;

  TCoeffDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    C11: TEdit;
    C12: TEdit;
    C13: TEdit;
    C14: TEdit;
    C15: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label15: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Label25: TLabel;
    Label7: TLabel;
    Panel3: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Label35: TLabel;
    Label8: TLabel;
    Panel4: TPanel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Label45: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CoeffChange(Sender: TObject);
  public
    edits:array[1..4,1..9] of TEditsRec;
  end;

var
  CoeffDlg: TCoeffDlg;

implementation

{$R *.dfm}

{************** FormCreate **********}
procedure TCoeffDlg.FormCreate(Sender: TObject);
var
  i,k,r,c:integer;
  t:integer;
begin
  edits[1,1].edit:=c11;
  for k:=1 to controlcount-1 do
  if controls[k] is TPanel then
  with TPanel(controls[k]) do
  begin
    for i:=0 to controlcount-1 do
    if controls[i] is TEdit then
    begin
      t:=TEdit(controls[i]).tag;
      {2 digit tag values represent row and column of coefficients in equations}
      r:=t div 10;
      c:=t mod 10;
      {Put the edits and their values in an array for easy reference}
      edits[r,c].edit:=TEdit(controls[i]);
      edits[r,c].val:=strtofloat(TEdit(controls[i]).text);
    end
    else if controls[i] is TLabel then
    begin
      t:=TLabel(controls[i]).tag;
      {2 digit tag values represent row and column of coefficients in equations}
      r:=t div 10;
      c:=t mod 10;
      {Put the edits and their values in an array for easy reference}
      edits[r,c].IdLabel:=TLabel(controls[i]);
    end;
  end;
end;

{********** OKBtnClick *********8}
procedure TCoeffDlg.OKBtnClick(Sender: TObject);
var
  r,c:integer;
  OK:boolean;
  err:integer;
begin
  OK:=true;
  for r:=1 to 4 do
  begin
    for c:=1 to 9 do
    with edits[r,c] do
    begin
      if trim(edit.text)='' then edit.text:='0.0';
      system.val(edit.text, val, err);
      if err >0 then
      begin
        edit.color:=clred;
        OK:=false;
       end
     end;
   end;
   if not OK then modalresult:=0;
end;

{************** CoeffChange ***********}
procedure TCoeffDlg.CoeffChange(Sender: TObject);
begin
  Tedit(sender).color:=clWindow;   {In case it has an error, reset color}
end;

end.
