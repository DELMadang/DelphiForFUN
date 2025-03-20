unit U_CatsMice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    procedure SolveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{A certain village was being overrun with mice.  Cats were brought in and,
by coincidence, each cat caught the same number of mice and they
eliminated 10,001 mice altogether.  Each cat kille more mice
than there were cats.  How many cats were there and how
many mice did each catch? }

procedure TForm1.SolveBtnClick(Sender: TObject);
{To solve this puzzle, we need to find the factors of 10,001.
 Hopefully there are only two (representing the
 numbers of cats and the number of mice).  If there are more than
 two factors, then there will be more than one solution.}

{Lets take the straightforward approach and try all divisors
  from 3 up to the square root of 10,001.}
var
  i,stop,n,cats,mice:integer;
begin
  stop:=trunc(sqrt(10001));
  for i:= 3 to stop do
  Begin
    {a mod b returns the remainder when a is divided by b}
    if 10001 mod i = 0 then
    Begin
      n:=10001 div i;
      if n>i then Begin cats:=i; mice:=n; end
      else Begin cats:=n; mice:=i; end;
      showmessage('Number of cats was '+inttostr(cats)
                  +' Number of mice caught by each cat was '
                  +inttostr(mice));
    end;
  end;
end;

end.
