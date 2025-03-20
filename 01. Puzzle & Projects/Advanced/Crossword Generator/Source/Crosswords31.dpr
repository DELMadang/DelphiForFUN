program Crosswords31;

uses
  Forms,
  U_Crosswords31 in 'U_Crosswords31.pas' {Form1},
  UPrintPreview in '\\UPSTAIRSP4\Projects (D)\DFF\Projects\Crosswords\UPrintPreview.pas' {Printpreview};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPrintpreview, Printpreview);
  Application.Run;
end.
