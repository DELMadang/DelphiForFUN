unit U_MakingChange1;

{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Dollar bill change making program #1}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UMakeCaption, ComCtrls;

type
  TForm1 = class(TForm)
    MakeChangeBtn: TButton;
    Memo1: TMemo;
    ListBox1: TListBox;
    procedure MakeChangeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var Form1: TForm1;

implementation
 {$R *.DFM}

{*************** MakeChangeBtnCLick ************}
procedure TForm1.MakeChangeBtnClick(Sender: TObject);
{User pushed the button}
var val,count:integer;
    c100,c50,c25,c10,c5,c1:integer; {coin counts for each coin value}
begin
  listbox1.clear;
  listbox1.items.add('    #        $1 coin     50c       25c     10c       5c         1c');
  listbox1.items.add('');
  count:=0;
  screen.cursor:=crhourglass; {show busy cursor}
  {Try all feasible combinations of coins, from 0 to maximum nbr less than or
   equal to $1 for each type}
  for c100:=0 to 1 do {dollars}  {Try all feasible combinations of coins}
    for c50:=0 to 2 do {half dollars}
      for c25:=0 to 4 do {quarters}
        for c10:=0 to 10 do {dimes}
          for c5:= 0 to 20 do {nickels}
            for c1:=0 to 100 do {pennies}
            begin
              val:=c100*100+c50*50+c25*25+c10*10+c5*5+c1;
              if val =100 then {total of selected coins is $1.00}
              begin
                inc(count); {increment the count of solutions}
                listbox1.items.add(
                     format('%4.3d        %4.2d        %4.2d       %4.2d      '
                             +'%4.2d      %4.2d       %4.2d',
                             [count, c100,c50,c25,c10,c5,c1]));
              end;
            end;
  screen.cursor:=crdefault; {show normal cursor}
end;

{****************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin  {display a title bar}
  makecaption('Making Change',#169+' 2001, G. Darby, www.delphiforfun.org',self);
end;

end.
