unit U_GetHiderOptions;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TGetHiderOptions = class(TForm)
    RadioGroup1: TRadioGroup;
    Smartbox: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetHiderOptions: TGetHiderOptions;

implementation

{$R *.DFM}

procedure TGetHiderOptions.Button1Click(Sender: TObject);
begin
  modalresult:=mrOK;
end;

end.
