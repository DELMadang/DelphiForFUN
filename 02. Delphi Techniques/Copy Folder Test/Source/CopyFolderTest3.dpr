program CopyFolderTest3;

uses
  Forms,
  U_CopyFolderTest3 in 'U_CopyFolderTest3.pas' {Form1},
  Masks in 'Masks.pas',
  UCopyFolder3Test in 'UCopyFolder3Test.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
