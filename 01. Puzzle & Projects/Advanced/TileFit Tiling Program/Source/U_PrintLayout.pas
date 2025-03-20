unit U_PrintLayout;
 {Copyright 2001,2005 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {dialog to define print layout}
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, NumEdit2;

type
  TPrintLayoutForm = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    public
      PrintAcrossEdt:TIntedit;
      PrintDownEdt:TIntedit;
  end;

var
  PrintLayoutForm: TPrintLayoutForm;

implementation

{$R *.DFM}

procedure TPrintLayoutForm.FormCreate(Sender: TObject);
begin
  PrintAcrossedt:=TIntedit.create(self,edit1);
  edit1.free;
  PrintDownEdt:=TIntEdit.create(self,edit2);
  edit2.free;
end;

end.
