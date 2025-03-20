unit U_CrackerDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, jpeg;

type
  TCrackerBarrelDlg = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    Memo1: TMemo;
    Psize: TRadioGroup;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CrackerBarrelDlg: TCrackerBarrelDlg;

implementation

{$R *.DFM}

end.
