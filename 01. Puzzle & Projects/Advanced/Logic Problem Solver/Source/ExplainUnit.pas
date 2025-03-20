unit ExplainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus;

type
  TExplainForm = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    Print1: TMenuItem;
    PrintDialog1: TPrintDialog;
    procedure Print1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExplainForm: TExplainForm;

implementation
Uses printers, u_printroutines;

{$R *.DFM}

procedure TExplainForm.Print1Click(Sender: TObject);
begin
  if printdialog1.execute then
  Begin
    printer.Begindoc;
    try
      PrintMemo(Memo1);
    finally
      Printer.EndDoc;
    end;  
  end;
end;

end.
