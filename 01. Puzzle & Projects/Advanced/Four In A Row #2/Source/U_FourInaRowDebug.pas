unit U_FourInaRowDebug;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TDebug = class(TForm)
    TreeView1: TTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Debug: TDebug;

implementation

{$R *.DFM}

end.
