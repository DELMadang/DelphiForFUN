unit U_Intro;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TIntroDlg = class(TForm)
    OKBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntroDlg: TIntroDlg;

implementation

{$R *.DFM}

end.
