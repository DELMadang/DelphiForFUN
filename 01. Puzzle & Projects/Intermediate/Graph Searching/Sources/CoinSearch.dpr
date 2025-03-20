program CoinSearch;

uses
  Forms,
  U_CoinSearch in 'U_CoinSearch.pas' {Form1},
  UTGraphSearch in 'UTGraphSearch.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
