program WordStuff3;
{Copyright  © 2001-2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_Wordstuff3 in 'U_Wordstuff3.pas' {Form1},
  U_About in 'U_About.pas' {AboutBox},
  U_wordladder in 'U_wordladder.pas' {WordLadderForm},
  U_ScrambledPie in 'U_ScrambledPie.pas' {ScrambledPieForm},
  U_EnterWordsDlg in 'U_EnterWordsDlg.pas' {EnterWordsDlg},
  UDict in 'UDict.pas' {DicForm},
  U_CrossWordHelper2 in 'U_CrossWordHelper2.pas' {WordCompleteForm},
  U_Decrypt3 in 'U_Decrypt3.pas' {Decryptform},
  U_Unscramble in 'U_Unscramble.pas' {UnscrambleForm},
  U_Decrypt3Suggest in 'U_Decrypt3Suggest.pas' {SuggestionDlg},
  U_Decrypt3Msg in 'U_Decrypt3Msg.pas' {MakeMsgDlg},
  U_Spellbound2 in 'U_Spellbound2.pas' {Spellboundform};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDicForm, DicForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TWordLadderForm, WordLadderForm);
  Application.CreateForm(TScrambledPieForm, ScrambledPieForm);
  Application.CreateForm(TEnterWordsDlg, EnterWordsDlg);
  Application.CreateForm(TDicForm, DicForm);
  Application.CreateForm(TWordCompleteForm, WordCompleteForm);
  Application.CreateForm(TDecryptform, Decryptform);
  Application.CreateForm(TUnscrambleForm, UnscrambleForm);
  Application.CreateForm(TSuggestionDlg, SuggestionDlg);
  Application.CreateForm(TMakeMsgDlg, MakeMsgDlg);
  Application.CreateForm(TSpellboundform, Spellboundform);
  Application.Run;
end.
