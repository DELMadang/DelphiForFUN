program Decrypt3;

uses
  Forms,
  U_Decrypt3 in 'U_Decrypt3.pas' {Decryptform},
  U_Decrypt3Suggest in 'U_Decrypt3Suggest.pas' {SuggestionDlg},
  U_Decrypt3Msg in 'U_Decrypt3Msg.pas' {MakeMsgDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDecryptform, Decryptform);
  Application.CreateForm(TSuggestionDlg, SuggestionDlg);
  Application.CreateForm(TMakeMsgDlg, MakeMsgDlg);
  Application.Run;
end.
