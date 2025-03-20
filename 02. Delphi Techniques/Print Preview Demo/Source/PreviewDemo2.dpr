program PreviewDemo2;

uses
  Forms,
  U_PreviewDemo2 in 'U_PreviewDemo2.pas' {Form1},
  UPrintPreview2 in 'UPrintPreview2.pas' {Printpreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPrintpreview, Printpreview);
  Application.Run;
end.
