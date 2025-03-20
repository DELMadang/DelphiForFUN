unit U_PeckingOrder;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface   

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type                                                     TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Memo4: TMemo;
    ShowMeBtn: TButton;
    Memo5: TMemo;
    TabSheet1: TTabSheet;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Memo3: TMemo;
    Memo6: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure ShowMeBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

   {************ CalculateShare ************8}
   Function CalculateShare(Var X, R:integer):boolean;
    begin
      if (R mod 3 = 2) then
      begin
        X:=2+(R-2) div 3; {X takes 2 seeds plus 1/3 of the pile after he takes 2}
        R:=R-X;  {take X amount from the pile}
        result:=true; {true if remaining mod 3 = 2, false othersise}
      end
      else result:=false;
    end;

{********** ShowMeBtnCLick *********}
procedure TForm1.ShowMeBtnClick(Sender: TObject);
var
   Pip,pep,pap,pop, N, Remaining:integer;
begin
  for n:=5 to 1000 do
  begin
    Remaining:=N; {Set "Remaining" to the number being tested}
    {If # seeds is valid, return True and set Pip's share and remaining seeds}
    If CalculateShare(Pip, Remaining) then
    begin {same for Pep}
      If  CalculateShare(Pep,Remaining) then
      begin {same for Pop}
        if CalculateShare(Pop,Remaining) then
        begin {same for Pap}
          if CalculateShare(Pap,Remaining) then
          begin;
            if (Pap = (Pep div 2) -2)  {Is Pap's number 2 less than 1/2 of Pep's seeds?}
            then {Yes!   Display the answer}
            with memo4.Lines do
            begin
              Add('Solution:');
              Add(format('Starting # = %d',[N]));
              Add(format('Pip= %d, Pep= %d, Pop= %d, Pap= %d',[Pip, Pep, Pop, Pap]));
              Add(format('Total taken = %d',[Pip+pep+pop+pap]));
              Add(format('Left over # = %d',[Remaining]));
            end ;
          end;
        end;
      end;
    end;
  end;
  memo4.visible:=true;
  memo6.visible:=true;
end;





procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
