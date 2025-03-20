Unit U_NumEditTest2;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{This version shows how to use TIntEdit and TFloatEdit without installing them as
 components.  We must create the controls ouselves (in the OnFormCreate exit in
 this example.  We must also set the properiees that were formerly set by
 dragging and dropping the controld on the form.  We accomplish this by
 dropping standard TEdit controls on the form as prototypes.  The prototypes are
 passed to the Create constructors where the prototype properties are copied to
 the new control
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SHellAPI, NumEdit2;

type
  TForm1 = class(TForm)
    
    Label1: TLabel;
    Label2: TLabel;
    SumLbl: TLabel;
    
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IntEdit1: TIntEdit;
    FloatEdit1: TFloatEdit;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Edit1Change(Sender: TObject);
begin
  sumLbl.caption:=format('Sum = %g',[intedit1.value+floatedit1.value]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //floatedit1.text:='';
  intedit1:=TIntedit.create(self,edit1);
  floatedit1:=TFloatedit.create(self,edit2);
  edit1change(sender);  {force initial calc of sum}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;

end;

end.
