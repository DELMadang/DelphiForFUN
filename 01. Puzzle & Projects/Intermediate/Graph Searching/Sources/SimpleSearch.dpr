program SimpleSearch;

uses
  Forms,
  U_SimpleSearch in 'U_SimpleSearch.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
