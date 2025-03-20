unit U_Verbose;
{Copyright 2001-2004, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation.
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TVerboseForm = class(TForm)
    ListBox1: TListBox;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  VerboseForm: TVerboseForm;

implementation

{$R *.DFM}

procedure TVerboseForm.Button1Click(Sender: TObject);
begin
  visible:=false;
end;

end.
