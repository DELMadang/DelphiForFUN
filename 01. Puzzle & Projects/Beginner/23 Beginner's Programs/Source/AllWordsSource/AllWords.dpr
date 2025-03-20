program AllWords;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Given a set of letters, list all possible permutations or letters or,
 optionally, words found in a dictionary}

uses
  Forms,
  U_AllWords in 'U_AllWords.pas' {Form1},
  UDict in 'UDict.pas' {DicForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
