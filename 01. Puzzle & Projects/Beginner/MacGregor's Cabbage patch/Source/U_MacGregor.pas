unit U_MacGregor;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A simple puzzle }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, jpeg, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure SolveitBtnClick(Sender: TObject);
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

{************** SolveitBtnClick ****************}
procedure TForm1.SolveitBtnClick(Sender: TObject);
var last,this:integer;
begin
   memo2.clear;
   for last:=1 to 100 do
   for this:=last+1 to 101 do
   if this*this-last*last=47 then
   with memo2, lines do
   begin
     add(format('MacGregor''s cabbage patch was %d x %d cabbages last year '
        +'(%.0n altogether) and %d x %d (%.0n cabbages) this year, 47 more.',
         [last,last,0.0+last*last,this,this,0.0+this*this]));
     add(' ');
     add('Here is the Delphi source code that solves the puzzle');
     add(' ');
     add('for last:=1 to 100 do ');
     add('for this:=last+1 to 100 do');
     add('if this*this-last*last=47 then');
     add('begin ');
     add('  {display answer here}');
     add('  break;');
     add('end;');
   end;
end;

end.
