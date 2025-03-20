unit U_PreView;
 {Copyright 2001,2005 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Print preview form}
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Menus, StdCtrls;
 Const
   mrprint=100;
   mrnextpage=101;
   mrprevpage=102;
   mrclose=103;
   mrlayout=104;
type
  TPreviewForm = class(TForm)
    PreviewImage: TImage;
    MainMenu1: TMainMenu;
    Print1: TMenuItem;
    NextPage1: TMenuItem;
    Close1: TMenuItem;
    PrevPage1: TMenuItem;
    CHangeLayout1: TMenuItem;
    procedure Close1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure NextPage1Click(Sender: TObject);
    procedure PrevPage1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CHangeLayout1Click(Sender: TObject);
  end;

var
  PreviewForm: TPreviewForm;

implementation

{$R *.DFM}

procedure TPreviewForm.Close1Click(Sender: TObject);
begin
  modalresult:=mrclose;
end;

procedure TPreviewForm.Print1Click(Sender: TObject);
begin
  modalresult:=mrPrint;
end;

procedure TPreviewForm.NextPage1Click(Sender: TObject);
begin
  modalresult:=mrNextPage;
end;

procedure TPreviewForm.PrevPage1Click(Sender: TObject);
begin
  modalresult:=mrprevpage;
end;

procedure TPreviewForm.Button1Click(Sender: TObject);
begin
  with previewimage, previewimage.canvas do
  Begin
    brush.color:=clwhite;
    fillrect(previewimage.clientrect);
  end;
end;

procedure TPreviewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if modalresult=mrcancel then modalresult:=mrclose;
end;

procedure TPreviewForm.CHangeLayout1Click(Sender: TObject);
begin
  modalresult:=mrlayout;
end;

end.
