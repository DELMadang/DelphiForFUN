program SimpleDragDrop;

uses
  Forms,
  U_SimpleDragDrop in 'U_SimpleDragDrop.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
