program Spellbound2;

uses
  Forms,
  U_Spellbound2 in 'U_Spellbound2.pas' {Spellboundform},
  UDict in '..\Projects\WordStuff\UDICt.pas' {DicForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSpellboundform, Spellboundform);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
