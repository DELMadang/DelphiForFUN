unit U_Triangle_3Lines;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Given 3 sides of a triangle, draw it.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, shellapi, Spin, jpeg;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    Memo1: TMemo;
    L1: TSpinEdit;
    L2: TSpinEdit;
    L3: TSpinEdit;
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LengthChange(Sender: TObject);
  public
    L:array[1..3] of Double;  {The 3 lengths}
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

Uses math;

{************ FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  LengthChange(sender); {draw initial triangle}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************* LengthChange **********}
procedure TForm1.LengthChange(Sender: TObject);
{redraw the triangle when any side length changes}
var
  s,a:extended;
  offsetx,offsetY:integer;
begin
  memo1.clear;
  L[1]:=L1.value;
  L[2]:=L2.value;
  L[3]:=L3.Value;
  offsety:=40;
  offsetx:=(image2.width-L1.value) div 2;   {center the image horizontally}
  with image2, canvas do
  begin
    pen.width:=3;
    rectangle(clientrect);  {clear the image}
    if maxValue(L)< sum(L) / 2 then {longest side must be less than 1/2 total}
    begin
      {If we draw L[1] as the base, we only need to compute the point where
       L[2] and L[3] intersect. }
      s:=(L[2]*L[2]+L[1]*L[1]-L[3]*L[3])/L[1]/2; {compute x offset to 3rd vertex}
      a:=sqrt(L[2]*L[2]-s*s); {compute altitude to 3rd vertex}

      memo1.lines.add('Valid -');
      {finish drawing the triangle}
      moveto( offsetx,height-offsety);  {move pen to start of base line}
      lineto(offsetx+trunc(s),height-offsety-trunc(a)); {line to (s,a)}
      lineto(offsetx+trunc(L[1]),height-offsety); {line to L2,0)}
      lineto(offsetx,height-offsety);   {close the triangle}
    end
    else
    begin
      s:=0; a:=0;
      memo1.lines.add('Invalid -');
      {draw the two short lines parallel and above the base line}
      moveto( offsetx,height-offsety);  {move pen to start of base line}
      lineto(offsetx+trunc(L[1]), height-offsety);

      moveto( trunc((width-L[2])/2),height-offsety-10);
      lineto(trunc((width+L[2])/2),height-offsety-10);

      moveto(trunc((width-L[3])/2),height-offsety-20);
      lineto(trunc((width+L[3])/2),height-offsety-20);
    end;
  end;
  memo1.lines.add('     L1='+inttostr(trunc(L[1])));
  memo1.lines.add('     L2='+inttostr(trunc(L[2])));
  memo1.lines.add('     L3='+inttostr(trunc(L[3])));
  memo1.lines.add(format('     s= %5.1f',[s]));
  memo1.lines.add(format('     a= %5.1f ',[a]));
end;

end.
