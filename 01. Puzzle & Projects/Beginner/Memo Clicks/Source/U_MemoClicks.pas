unit U_MemoClicks;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, DFFUtils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{********* Memo1Click ************}
procedure TForm1.Memo1Click(Sender: TObject);
  var
  i:integer;
  s:string;
  linenbr,positionIndex:integer;
begin
  LineNbr:=LineNumberClicked(Memo1);
  PositionIndex:=LinePositionClicked(Memo1);
  label1.caption:=format('You clicked line number %d, and position number %d',
                 [linenbr, positionIndex]);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
