unit U_RelayBoardTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SynaSer, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    Shape0: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    Label4: TLabel;
    Shape2: TShape;
    Label5: TLabel;
    Shape3: TShape;
    Label6: TLabel;
    Shape7: TShape;
    Shape6: TShape;
    Shape5: TShape;
    Shape4: TShape;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ResetBtn: TButton;
    Label10: TLabel;
    Button1: TButton;
    procedure Shape0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     ser:TBlockSerial;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  cr:char=#$0A;
  lf:char=#$0D;


procedure TForm1.FormActivate(Sender: TObject);
begin
  ser:=TBlockSerial.Create;
  ser.RaiseExcept:=True;
  with  memo1.Lines, ser do
  begin
    try
      Connect(Edit1.Text);
      //Config(StrToIntDef(Edit2.Text, 9600),8,'N',0,false,false);
      resetbtnclick(sender);
      sleep(10);
    finally
    end;
  end;
end;

{*********** ShapeMouseUp *************}
procedure TForm1.Shape0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  s:string;
  relay:TShape;
begin
  relay:=Tshape(sender);
  With relay do
  begin
    if brush.color=clYellow then
    begin
      brush.color:=clblack;
      s:='relay off '+inttostr(tag)+Lf;
      ser.sendstring(s);

    end
    else
    begin
      brush.color:=clYellow;
      s:='relay on '+inttostr(tag)+Lf;
      ser.sendstring(s);
    end;
  end;
  memo1.lines.add(s);
end;


{************ ResetBtnClick **********8}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  ser.sendstring('reset'+Lf);
  memo1.lines.add('reset');
  shape0.Brush.Color:=clBlack;
  shape1.Brush.Color:=clBlack;
  shape2.Brush.Color:=clBlack;
  shape3.Brush.Color:=clBlack;
  shape4.Brush.Color:=clBlack;
  shape5.Brush.Color:=clBlack;
  shape6.Brush.Color:=clBlack;
  shape7.Brush.Color:=clBlack;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  s:string;
  n:integer;
begin
  for i:=0 to 7 do
  begin
    ser.SendString('relay read '+inttostr(i) +LF);
    s:=ser.recvstring(100);
    memo1.Lines.add(s);
  end;  
end;

end.
