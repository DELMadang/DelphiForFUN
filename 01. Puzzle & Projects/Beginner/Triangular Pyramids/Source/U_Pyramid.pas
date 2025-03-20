unit U_Pyramid;
{A tetrahedron (triangular pyramid) has
 1,3,6,10, etc in successive layers.  A two layer
 tetrathedron has 4 marbles, a perfext square.  What is
 the next larger with a total that is a perfect square?}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo2: TMemo;
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

procedure TForm1.SolveBtnClick(Sender: TObject);
{User clicked solve button}
{pretty much self commenting - isn't Delphi great?}
const maxmarbles=1000;
var {the 4 variables}
  PyramidNbr, layer, total,root :integer;
begin
  layer:=0;
  total:=0;
  PyramidNbr:=0;
  repeat
    inc(PyramidNbr);
    layer:=layer+PyramidNbr;
    total:=total+layer;
    root:=trunc(sqrt(total));
  until ((PyramidNbr>3) and  (root*root=total)) or (PyramidNbr>maxMarbles);

  If root*root=total
  then  showmessage ('Side '+inttostr(PyramidNbr)
              +', Layer '+ inttostr(layer)
              +', Total '+inttostr(total)
              +', Sqrt(Total) '+inttostr(root))
  else Showmessage('No solutions with sides less than '+inttostr(maxmarbles));
end;

end.
