unit U_ChangeTile;
{Copyright 2001, 2005  Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Dialog to define tile characteristics: Id, height, width, count, and color }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NumEdit2, ExtCtrls;

type
  TTileForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TileOKBtn: TButton;
    TileCancelBtn: TButton;
    Label4: TLabel;
    IdEdt: TEdit;
    ColorDialog1: TColorDialog;
    Button1: TButton;
    Panel1: TPanel;
    prototile: TShape;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure SizeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    public
      HeightEdt, WidthEdt, CountEdt:TIntedit;
  end;

var
  TileForm: TTileForm;

implementation

{$R *.DFM}

procedure TTileForm.Button1Click(Sender: TObject);
begin
  If colordialog1.execute then
  begin
    prototile.brush.color:=colordialog1.color;
  end;
end;

procedure TTileForm.SizeChange(Sender: TObject);
var
  scale:extended;
begin
  if heightedt.value>widthedt.value
  then scale:=(panel1.height-5)/heightedt.value
  else scale:=(panel1.height-5)/widthedt.value;
  prototile.height:=round(heightedt.value*scale);
  prototile.width:=round(widthedt.value*scale);
end;

procedure TTileForm.FormActivate(Sender: TObject);
begin
  sizechange(sender); {force initial draw of tile}
  colordialog1.color:=prototile.brush.color;
end;

procedure TTileForm.FormCreate(Sender: TObject);
begin
  HeightEdt:=TIntEdit.create(self,edit1);
  WidthEdt:=TIntEdit.create(self,edit2);
  CountEdt:=TIntEdit.create(self,edit3);

end;

end.
