program ShortestPath;

uses
  Forms,
  U_ShortestPath in 'U_ShortestPath.pas' {Form1},
  UTGraphSearch in 'UTGraphSearch.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
