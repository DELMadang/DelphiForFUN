unit Results;
{the results display form}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TResultsDlg = class(TForm)
    OKBtn: TButton;
    GroupBox1: TGroupBox;
    MovesLbl: TLabel;
    TimeLbl: TLabel;
    RateLbl: TLabel;
    EstSecsLbl1: TLabel;
    EstSecsLbl2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ResultsDlg: TResultsDlg;

implementation

{$R *.DFM}

end.
