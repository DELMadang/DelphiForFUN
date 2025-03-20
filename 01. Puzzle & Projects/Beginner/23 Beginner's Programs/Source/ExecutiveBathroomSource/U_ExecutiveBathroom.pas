unit U_ExecutiveBathroom;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    Memo2: TMemo;
    SolveBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    lastline:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
{Examine all 3digit integers and count the ones that are odd and do not contain
 aby duplicate digits}
var
  i:integer;
  s:string;
  count:integer;
begin
  count:=0;
  for i:=100 to 999 do
  begin
    If i mod 2 =1 then{is it odd?}
    begin {yes, check for repeated digits}
      s:=inttostr(i);  {conter the integer to a string to check its digits}
      if (s[1]<>s[2]) and (s[1]<>s[3]) and (s[2]<>s[3])
      then inc(count); {only 3 tests are required to identify any duplicate digits}
    end;
  end;
  showmessage('Between 100 and 999 I counted '+inttostr(count) +' odd numbers with no repeated digits.');
  memo2.visible:=true;   {show the Mensa derivation }
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
