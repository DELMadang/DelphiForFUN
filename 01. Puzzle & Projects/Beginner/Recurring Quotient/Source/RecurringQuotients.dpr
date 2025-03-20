program RecurringQuotients;

uses
  Forms,
  U_RecurringQuotient in 'U_RecurringQuotient.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
