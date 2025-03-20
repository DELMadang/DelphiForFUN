program Word_Square_Search_By_Column;

uses
  Forms,
  U_Word_Square_Search_By_Column1 in 'U_Word_Square_Search_By_Column1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

