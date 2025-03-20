program AddedCorners;

uses
  Forms,
  U_AddedCorners in 'U_AddedCorners.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
