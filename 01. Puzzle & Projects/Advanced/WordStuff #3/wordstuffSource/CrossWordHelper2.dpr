program CrossWordHelper2;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_CrossWordHelper2 in 'U_CrossWordHelper2.pas' {WordCompleteForm},
  UDict in 'UDict.pas' {DicForm},
  USearchAnagrams in 'USearchAnagrams.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWordCompleteForm, WordCompleteForm);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
