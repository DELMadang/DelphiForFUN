program ProbabilityDist;

uses
  Forms,
  U_ProbabilityDist in 'U_ProbabilityDist.pas' {Form1},
  U_ProbChart in 'U_ProbChart.pas' {ChartForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TChartForm, ChartForm);
  Application.Run;
end.
