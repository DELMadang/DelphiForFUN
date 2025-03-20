program WordLadder;

uses
  Forms,
  U_wordladder in 'U_wordladder.pas' {WordLadderForm},
  UDict in 'UDict.pas' {DicForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWordLadderForm, WordLadderForm);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
