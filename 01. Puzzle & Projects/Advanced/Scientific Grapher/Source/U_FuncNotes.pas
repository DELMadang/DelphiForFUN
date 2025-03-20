unit U_FuncNotes;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TFuncNotesDlg = class(TForm)
    OKBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FuncNotesDlg: TFuncNotesDlg;

implementation

{$R *.DFM}

end.
