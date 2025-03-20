unit U_Rules;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dffUtils;

type
  TRulesForm = class(TForm)
    rulesMemo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RulesForm: TRulesForm;

implementation

{$R *.dfm}

end.
