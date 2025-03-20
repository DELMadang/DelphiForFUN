unit U_TimeDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, ComCtrls;

type
  TTimeDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Edit2: TEdit;
    UpDown3: TUpDown;
    Edit3: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TimeDlg: TTimeDlg;

implementation

{$R *.DFM}

end.
