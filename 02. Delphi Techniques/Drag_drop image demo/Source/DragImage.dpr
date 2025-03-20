program DragImage;

uses
  Forms,
  U_DragImage in 'U_DragImage.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
