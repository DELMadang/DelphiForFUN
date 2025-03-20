unit U_Biltmore;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, jpeg;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    Introsheet: TTabSheet;
    MathSheet: TTabSheet;
    CalcSheet: TTabSheet;
    Label1: TLabel;
    CalcBtn: TButton;
    Memo1: TMemo;
    ArmLengthEdt: TLabeledEdit;
    MaxDEdt: TLabeledEdit;
    Memo2: TMemo;
    Image1: TImage;
    RichEdit1: TRichEdit;
    Memo3: TMemo;
    Memo4: TMemo;
    Image2: TImage;
    Memo5: TMemo;
    UnitsGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure UnitsGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    incr:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*********** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.activepage:=introsheet; {make sure Intro sheet displays first}
end;

{************* CalcBtnClick ***********}
procedure TForm1.CalcBtnClick(Sender: TObject);
{Calculate the distances corresponding to diameter values}
var
  S,L:extended;
  MaxD:integer;
  D:integer;

begin
  memo2.clear;
  memo2.Lines.add('Tree          Distance');
  memo2.Lines.add('Diameter   On Stick');

  MaxD:=strToIntDef(MaxDEdt.Text,0);
  if MaxD>0 then
  begin
    L:=strToFloatDef(ArmlengthEdt.text,0);
    if L>0 then
    begin
      for D:= 1 to Maxd do
      begin
        if (incr=1) or (D mod 2 =0) then
        begin
          s:=sqrt(D*D*L/(D+L));
          memo2.lines.add(format('   %2d         %5.1f',[D,S]));
        end;
      end;
    end;
  end;
end;

{************ UnitsGrpClick **********8}
procedure TForm1.UnitsGrpClick(Sender: TObject);
{set up for inch or metric output;}
begin
  case unitsgrp.ItemIndex of
    0: begin
         incr:=1;
         MaxDedt.Text:='30';
         Armlengthedt.Text:='25';
       end;
    1: begin
         incr:=2;
         MaxDedt.Text:='60';
         Armlengthedt.Text:='50';
       end;
  end;
  memo2.Clear;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
