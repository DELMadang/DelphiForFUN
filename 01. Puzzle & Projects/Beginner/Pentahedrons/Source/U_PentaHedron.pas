unit U_PentaHedron;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    procedure SolveBtnClick(Sender: TObject);
  end;

var  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
var i,sum,n:integer;
begin
  sum:=1;
  for i:= 2 to 100 do
  begin
    sum:=sum+i*i;
    n:=trunc(sqrt(sum));
    label1.caption :='A stack with '+Inttostr(i)+' balls on each side of the lowest '
             +' layer would contain ' +inttostr(sum)+ ' balls';
    label1.update;
    if n*n=sum then
    begin
        showmessage( 'Solved!, There were '+inttostr(sum)
           + ' balls arranged in a square pyramid '+inttostr(i)
           + ' layers high.'
           +#13+'No wonder they were concerned! (Layed out flat they made a '+inttostr(n)+' by '
           + inttostr(n)+' square)' );
        break;
    end;
    sleep(1000);
  end;
end;  
end.
