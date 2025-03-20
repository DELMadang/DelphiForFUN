unit U_BadDnaTheory;
  {Copyright  © 2001, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    ShowmeBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    procedure ShowmeBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  {other letter arrangements will build different lists}
  letters:array[1..4] of char='ACGT';
procedure TForm1.ShowmeBtnClick(Sender: TObject);
var
  i,j,k,n:integer;
  candidates:array[1..4,1..4,1..4] of boolean;
begin
  {Initialize}
  listbox1.clear;
  for i:= 1 to 4 do  for j:= 1 to 4 do for k:=1 to 4 do candidates[i,j,k]:=true;

  {Eliminate shifted versions of each valid word}
  for i:= 1 to 4 do for j:= 1 to 4 do for k:=1 to 4 do
  if candidates[i,j,k]=true then
  begin  {the critical part}
    candidates[j,k,i]:=false;
    candidates[k,i,j]:=false;
  end;

  {Display output}
  n:=0;
  for i:= 1 to 4 do for j:= 1 to 4 do for k:=1 to 4 do
  if candidates[i,j,k]=true then
  begin
    inc(n);
    listbox1.items.add(format('%2d. ',[n])+letters[i]+letters[j]+letters[k]);
  end;
end;

end.
