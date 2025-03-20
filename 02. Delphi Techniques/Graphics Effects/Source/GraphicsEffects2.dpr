program GraphicsEffects2;

uses
  Forms,
  U_GraphicsEffects2 in 'U_GraphicsEffects2.pas' {Form1};

{$R *.res}

Begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
