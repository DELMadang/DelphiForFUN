unit U_PostFix;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TPostFixForm = class(TForm)
    PostFixMemo: TMemo;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PostFixForm: TPostFixForm;

implementation

{$R *.DFM}


end.
