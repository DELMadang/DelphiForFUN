unit U_ProbChart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, TeeFunci, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, Buttons;

type
  TChartForm = class(TForm)
    Chart1: TChart;
    Series1: TBarSeries;
    TeeFunction1: TAddTeeFunction;
    BitBtn1: TBitBtn;
    Series2: TFastLineSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ChartForm: TChartForm;

implementation

{$R *.DFM}

end.
