program PhraseFinder;

uses
  Forms,
  U_PhraseFinder in 'U_PhraseFinder.pas' {Form1},
  UDict in 'UDict.pas' {DicForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
