program RelayBoardtest;

uses
  Forms,
  U_RelayBoardTest in 'U_RelayBoardTest.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
