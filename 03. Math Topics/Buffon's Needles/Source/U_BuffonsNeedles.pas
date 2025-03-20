unit U_BuffonsNeedles;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, shellapi, ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    StaticText1: TStaticText;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TimeLbl: TLabel;
    StopBtn: TButton;
    CountGrp: TRadioGroup;
    SpacingEdt: TSpinEdit;
    NeedleEdt: TSpinEdit;
    GraphitBtn: TButton;
    FastCalcBtn: TButton;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    Image2: TImage;
    Label7: TLabel;
    Memo3: TMemo;
    Label8: TLabel;
    Memo4: TMemo;
    Label9: TLabel;
    procedure FastCalcBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GraphitBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SpacingEdtChange(Sender: TObject);
    procedure NeedleEdtChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  public
    spacing,needleLength:integer;
     crosses, tot:integer;
     crosscounts, crosschances:array of integer;
     starttime:TDateTime;
     sines:array of double;  {hold precalculated sines for speed}
     procedure showpi(tot:integer);
     procedure setup;
     procedure ShowProb; {show probability chart for >1000 needles}
     procedure ShowProb1000; {show probability chart for 1000 needles}
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************** Setup **************}
procedure TForm1.setup;
{setup to drop needles}
var i:integer;
begin
  with image1, canvas do
  begin
    brush.color:=clwhite;
    fillrect(clientrect);
  end;
  spacing:=2;
  needlelength:=2;
  crosses:=0;
  tot:=1000;
  for i:=1 to countgrp.itemindex do tot:=tot*10; {COMPUTE TOTAL NUMBER TO DROP}
  image2.width:=image1.width;
  setlength(crosscounts,image1.width);
  setlength(crosschances,image1.width);
  setlength(sines,image1.width);
  for i:=0 to image1.width-1 do
  begin    crosscounts[i]:=0;
    crosschances[i]:=0;
    sines[i]:=sin(i/image1.width*pi);
  end;
  stopbtn.visible:=true;
  tag:=0;
  screen.cursor:=crHourGlass;
  starttime:=now;
end;




{************** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
   stopbtn.bringtofront;
  GraphItBtnclick(sender);
  memo2.sendtoback;

end;

{*************** ShowPi **************}
procedure TForm1.showpi(tot:integer);
{display results of a test run}
    var p:double;
    begin
      if tot=0 then exit;
      P:= crosses/tot * spacing/needlelength; {probability approximates 2/Pi}
      if p<>0 then
      label1.caption:=format('%d of %d lines crossed gridline'
       +#13+'Probability adjusted for ratio of spacing to needle length = '
       +#13 + 'p = %d/%d*%d/%d = %5.3f'
       +#13+' Estimate of Pi= 2/p= %8.6f',
                           [crosses,tot,crosses,tot,spacing,needlelength,p,2/p]);
      label1.update;
      timelbl.caption:=format('Run time: %6.3f seconds',[(now-starttime)*secsperday]);
    end;

{************* GraphItBtnClick ***********}
procedure TForm1.GraphitBtnClick(Sender: TObject);
var
  x,y,d, theta:double;
  i, index, yoffset, nbrspaces :integer;
  n2,s2: double;{half the needlewidth and half the spacing}
  saveheight:integer;
begin
  setup;
  saveheight:=image1.height;
  nbrspaces:=image1.height div spacing;
  image1.height:=nbrspaces*spacing;
  spacing:=spacingedt.value;  s2:=spacing/2;
  needlelength:=needleedt.value; n2:=needlelength/2;
  with image1, canvas do
  begin
    pen.color:=clblue;
    pen.width:=1;
    for i:= 1 to height div spacing do
    begin
      moveto(0,i*spacing);
      lineto(width,i*spacing);
    end;
    pen.color:=clblack;
    update;
  end;
  screen.cursor:=crHourGlass;
  starttime:=now;
  for i:= 0 to tot-1 do
  begin
    {Assume grid lines are "spacing" units apart}
    {Then a random number between 0 and spacing/2 can represent the distance of
    the middle of a randomly dropped needle from the nearest grid line}
    y:=random*s2;  {Image1.height}{s2};{random number between 0 and 1/2 the spacing}
    {And it fell at a random angle between 0 and 180 degeees}
    theta:=pi*random; {random angle between 0 and Pi}
    index:=trunc(theta*image1.width/pi); {index in sine table for angle theta}
    d:=n2*sines[index];
    if (i<1000) then   {graph the 1st 1000 needlkes dropped}
    with image1,canvas do
    begin
      x:=1+random(image1.width-2);

      {for visual effect we'll place some above the line and some below,
       even though mathematically it does not matter}
      yoffset:=round(y+random(image1.height)-s2);
      moveto(trunc(x+n2*cos(theta)), trunc(yoffset-d));
      lineto(trunc(x-n2*cos(theta)), trunc(yoffset+d));
      //sleep(10);
      showpi(i);
    end;
    {Is the vertical distance of the end of the needle from the midpoint
     greater than the distance fron the mid point to the line?  If so it crossed
     the line and counts as a crossing}
    inc(crosschances[index]);
    if d>y then
    begin
      inc(crosses);
      inc(crosscounts[index]);
      if (n2>s2) and (d>spacing-y) then
      begin
        inc(crosses,trunc(d/(spacing-y)));
        inc(crosscounts[index], trunc(d/(spacing-y)));
      end;

      {if needle length is greater than 2*spacing, it could cross more than 2 lines}
      if (n2>spacing)and ((d-y)>spacing) then
      begin
        inc(crosses, trunc((d-y)/spacing));
        inc(crosscounts[index],trunc((d-y)/spacing));
      end;
    end;
    if i and $fffff=0 then
    begin
       application.processmessages;
       if tag<>0 then
       begin
        tot:=i+1;
        break;
      end;
      showpi(i);
    end;
  end;
  screen.cursor:=crdefault;
  showpi(tot);
  image1.height:=saveheight;
  stopbtn.visible:=false;
end;

{************** FastCalcBtnClick *************}
procedure TForm1.FastCalcBtnClick(Sender: TObject);
{A faster calulation - no graphics and assumed spaceing and needle length}
var
  n:double;
  i, index:integer;
begin
  setup;
  for i:= 0 to tot-1 do
  begin
    {ASSUME GRID LINES ARE 2 UNITS APART}
    {Then a random number between 0 and 1 can represent the distance of
     the middle of a randomly dropped needle from the nearest grid line}
     n:= random; {random number between 0 and 1}
     {And  it fell at a random angle between 0 and 180 degeees}
     //theta:=pi*random; {random angle between 0 and Pi}
     index:=random(image1.width); {Just tpick a random # to represent angle}
    {Is the vertical distance of the end of the needle from the modpoint
     greater than the distance fron the mid point to the line?  If so it crossed
     the line and counts as a crossing}
    inc(crosschances[index]);
    if sines[index]{sin(theta)}>n then
    begin
      inc(crosses);
      inc(crosscounts[index]);
    end;
  end;
  screen.cursor:=crdefault;
  showpi(tot);
  stopbtn.visible:=false;
end;


{*************** ShowProb1000 **********}
procedure TForm1.Showprob1000;
{display probability histograms}
var i,j:integer;
    r:extended;
    prob, rw, adjust, sum1, sum2:extended;
    sumb,sumc:integer;
    rwp:extended;
    nbrrects,stop:integer;
    rectcounts,rectchances:array of integer;
begin
  label4.visible:=true; label5.visible:=true; label6.visible:=true;
  with image2, canvas do
  begin
    pen.color:=clblue;
    brush.color:=clwindow;
    fillrect(clientrect);
    memo3.clear;
    sum1:=0;
    SumB:=0; SumC:=0;
    rwp:=image2.width div tot; {rectangle width in pixels}
    if rwp=0 then rwp:=1;
    if tot div width < 10 then rwp:=10*tot / width;
    nbrrects:=trunc(width / rwp);
    rw:=Pi/nbrrects; {rectangle width in degrees }
    adjust:=spacing/needlelength;
    brush.color:=clteal;
    if rwp>1 then pen.color:=clblack else pen.color:=clteal;
    setlength(rectcounts,nbrrects);
    setlength(rectchances,nbrrects);
    for i:=0 to nbrrects-1  do
     begin
      //moveto(i,height);
      rectcounts[i]:=0;
      rectchances[i]:=0;
      stop:=trunc((i+1)*rwp)-trunc(i*rwp)-1; {to count all samples in some rectangle}
      for j:=0 to stop do
      begin
        rectcounts[i]:=rectcounts[i] + crosscounts[trunc(i*rwp+j)];
        rectchances[i]:=rectchances[i] +crosschances[trunc(i*rwp+j)];
      end;
      rectcounts[i]:=trunc(rectcounts[i]*adjust);
      r:=rectcounts[i]/tot;
      rectangle(trunc(i*rwp),height-trunc(width*height*r/rwp),trunc((i+1)*rwp),height);
      //lineto(i,height - trunc(width*height*r));
      if rectcounts[i]=0 then prob:=0 else prob:=rectcounts[i]/rectchances[i];
      sumb:=sumb+rectcounts[i];
      sumc:=sumc+rectchances[i];
      sum1:=sum1+prob*(rw); {Sum the rectangle areas}
      sum2:=1-cos(i/nbrrects*pi+rw/2);  {use the definite integral formula}
      memo3.lines.add(format('%5.1f     %5.5d   %5d    %6.4f   %6.4f    %6.4f  %6.4f' ,
            [(i*rw + rw/2)*180/pi,trunc(rectcounts[i]),rectchances[i],prob,
             sin(i*rw+ rw/2), sum1, sum2]));

    end;

    pen.color:=clred;
    pen.width:=2;
    moveto(0,height);
    for i:=1 to image1.width-1 do
      lineto(i,trunc(height*(1-sin(pi*i/width))));
    with memo3 do
    begin
      memo3.lines.add(format('Sums %8.0n  %9.0n    ' ,
            [0.0+sumb,0.0+sumc]));
      lines.add(format('Probability of crossing: Sum(B)/Sum(C)= '+
              '%6.3f',[sumb/sumc]));
      lines.add(format('Estimate of Pi: 2*Sum(C)/Sum(B)= %6.4f ',[2*sumc/sumb]));
      // debug memo3.lines.add('Nbr rects '+inttostr(nbrrects));
    end;
  end;

end;



{*************** ShowProbBtnClick **********}
procedure TForm1.Showprob;
{display probability histograms}
var i:integer;
    r:extended;
    prob, rw, adjust, sum1, sum2:extended;
    sumb,sumc:integer;
begin
  label4.visible:=true; label5.visible:=true; label6.visible:=true;
  with image2, canvas do
  begin
    pen.color:=clblue;
    brush.color:=clwindow;
    fillrect(clientrect);
    memo3.clear;
    sum1:=0;
    SumB:=0; SumC:=0;
    rw:=Pi/width; {rectangle width}
    adjust:=spacing/needlelength;
    for i:=0 to width-1 do
    begin
      moveto(i,height);
      r:=crosscounts[i]*adjust/tot;
      {if i mod 2=0 then }pen.color:=clteal {else pen.color:=clblack};
      lineto(i,height - trunc(width*height*r));
      if crosscounts[i]=0 then prob:=0 else prob:=crosscounts[i]*adjust/crosschances[i];
      sumb:=sumb+trunc(crosscounts[i]*adjust);
      sumc:=sumc+crosschances[i];
      sum1:=sum1+prob*(rw); {Sum the rectangle areas}
      sum2:={sum2+sin(i*rw)*(rw)} 1-cos(i*pi/width);  {use the definite integral formula}
      memo3.lines.add(format('%5.1f     %5.5d   %5d    %6.4f   %6.4f    %6.4f  %6.4f' ,
            [i*rw*180/pi,trunc(crosscounts[i]*adjust),crosschances[i],prob,
             sin(i*rw), sum1, sum2]));
    end;
    pen.color:=clred;
    pen.width:=2;
    moveto(0,height);
    for i:=1 to image1.width-1 do
      lineto(i,trunc(height*(1-sin(pi*i/width))));
    with memo3 do
    begin
      memo3.lines.add(format('Sums %8.0n  %9.0n    ' ,
            [0.0+sumb,0.0+sumc]));
      lines.add(format('P=Probability of crossing =Sum(B)/Sum(C) = '+
              '%6.3f',[sumb/sumc]));
      lines.add(format('Estimate of Pi = 2/P = %6.4f ',[2*sumc/sumb]));
      //selstart:=0; {force scroll up to show top line}
      //sellength:=0;
    end;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.SpacingEdtChange(Sender: TObject);
begin
  if needleedt.value>2*spacingedt.value
  then needleedt.value:=2*spacingedt.value ;
end;

procedure TForm1.NeedleEdtChange(Sender: TObject);
begin
  if needleedt.value>2*spacingedt.value
  then spacingedt.value:= (needleedt.value+1) div 2;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
  stopbtn.visible:=false;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  If pagecontrol1.activepage=tabsheet2 then
  if tot=1000 then showprob1000 else showprob;
end;


end.
