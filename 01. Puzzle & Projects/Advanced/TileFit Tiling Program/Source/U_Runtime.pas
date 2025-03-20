unit U_Runtime;
{Copyright 2001,2005 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {dialog to set max runtime}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, NumEdit2 ;

type
  TMaxRunForm = class(TForm)
    UpDown1: TUpDown;

    Label1: TLabel;

    UpDown2: TUpDown;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    public
      minedt,secedt:TIntedit;
  end;

var
  MaxRunForm: TMaxRunForm;

implementation

{$R *.DFM}

procedure TMaxRunForm.FormCreate(Sender: TObject);
begin
  minedt:=tintedit.create(self,edit1);
  updown1.associate:=minedt;
  edit1.free;
  secedt:=tintedit.create(self,edit2);
  updown2.associate:=secedt;
  edit2.free;
end;

end.
