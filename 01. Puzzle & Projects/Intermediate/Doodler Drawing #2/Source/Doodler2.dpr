program Doodler2;

uses
  Forms,
  U_Doodler2 in 'U_Doodler2.pas' {Form1},
  UMakeCaption in '\\UPSTAIRS\G (PROJECTS)\Projects\Doodler\UMakeCaption.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
