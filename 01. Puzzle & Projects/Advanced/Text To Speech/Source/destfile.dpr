program destfile;

uses
  Forms,
  U_DestFile in 'U_DestFile.pas' {frmChoose};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmChoose, frmChoose);
  Application.Run;
end.
