unit U_GetTitle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TGetTitle = class(TForm)
    TitleEdt: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetTitle: TGetTitle;

implementation

{$R *.DFM}



end.
