unit U_Josephus2;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ The "Josephus" problem is a counting elimination
"game" named after the story that Josephus Flavius
devised a "fair" way to kill off his troops who insisted on
suicide rather than surrender to the enemy.  41 of them
formed a circle and every third man was eliminated.
Maybe not so fair since Josephus, who was not too
keen on the idea, selected a position which assured
that he would be the last survior.  At that point he
decided that perhaps it was best to surrender after all!
In fact, the last name Flavius is that of the Roman family
that adopted him!   }

{Version 2 solves the inverse problem: Having chosen the final location to be
 selected, calculate the location at which to be begin the counting process.
 Numbering relative to 1, the starting location may be calculated as
 Start=(A-F(N,K)+N-1) mod N + 1 where
 N=number of people
 K= choose every Kth person
 A= desired final person chosen
 F(N,K) recursive function defined as
        F(N,K)=(F(N-1,K)-K) mod N for N>1
        F(1,K) = 0 for N=1
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, shellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    ResetBtn: TButton;
    StaticText1: TStaticText;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    SpinEdit3: TSpinEdit;
    ISolvebtn: TButton;
    Label5: TLabel;
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ISolvebtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    angle, radius, largediag:extended;
    s2:integer; {1/2 smileysize}
    smileysize, centerx, centery:integer;
    selected:integer;  {position selected by player}
    dir:string;
    startat:integer;
    {Smiley images}
    pic1:TBitmap; {default live}
    pic2:TBitmap; {default dead}
    pic3:TBitmap; {selected live}
    pic4:TBitmap; {selected dead}
    procedure Go;   {run the elimination process}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses math;

{*************** SpinEdit1Change **********}
procedure TForm1.SpinEdit1Change(Sender: TObject);
{Number of persons in trhe circle has changed - redraw all smileys}
var
  i:integer;
  cp:TPoint;

begin
  if spinedit1.text='' then exit; {skip entry while user is changing the number}
  dir:=extractfilepath(application.exename);
  largediag:=sqrt(2*28*28);  {this is the size of the large smileys}
  angle:=2*Pi/spinedit1.value;
  centerx:=(image1.width) div 2;
  centery:=(image1.height) div 2;
  radius:=0.95*centerx;
  {if the distance bewtween smiley locations is larger than the size of the
   larger smiley images, then use large images}
  if 2*(radius*sin(angle/2))>largediag then
  begin
    pic1.loadfromfile(dir+'regular_smile.bmp');
    pic2.loadfromfile(dir+'cry_smile.bmp');
    pic3.loadfromfile(dir+'smileX.bmp');
    pic4.loadfromfile(dir+'smileXDead.bmp');
  end
  else {otherwise use small smiley images}
  begin
    pic1.loadfromfile(dir+'regular_smile_small.bmp');
    pic2.loadfromfile(dir+'cry_smile_small.bmp');
    pic3.loadfromfile(dir+'smileX_small.bmp');
    pic4.loadfromfile(dir+'smileXDead_small.bmp');
  end;
  smileysize:=pic1.width;
  s2:=smileysize div 2;
  image1.canvas.fillrect(image1.clientrect); {clear the field}

  for i:= 0 to spinedit1.value-1 do
  begin  {draw all smilies}
    cp.x:=centerx+trunc(radius*cos(i*angle-pi/2));
    cp.y:=centery+trunc(radius*sin(i*angle-pi/2));
    image1.canvas.copyrect(rect(cp.x-s2,cp.y-s2,cp.x+s2,cp.y+s2),
                           pic1.canvas,
                           rect(0,0,pic1.width,pic1.height));
    {add numbers}
    cp.x:=centerx+trunc((radius-25)*cos(i*angle-pi/2))-6;
    cp.y:=centery+trunc((radius-25)*sin(i*angle-pi/2))-6;
    image1.canvas.TextOut(cp.x,cp.y,inttostr(i+1));
  end;
end;

{*********** FormCreate ********8}
procedure TForm1.FormCreate(Sender: TObject);
begin
   pic1:=TBitmap.create;
   pic2:=TBitmap.create;
   pic3:=TBitmap.create;
   pic4:=TBitmap.create;
end;

{************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
 spinedit1change(sender);
end;

{*************** Go *********}
procedure TForm1.Go;
{Animate the elimination process}
var
  i,j,n,increment,count:integer;
  circle:array of integer;
  cp:TPoint;
begin
  memo1.clear;
  setlength(circle,spinedit1.value); {initialize array of circle of people}
  for i:= 0 to spinedit1.value-1 do circle[i]:=i+1;
  count:=spinedit1.value; {count = nbr of people remaining to eliminate}
  increment:=spinedit2.value;
  n:=(startat-1+increment-1) mod count;{first to eliminate relative to indexing from 0}
  for i:= 0 to spinedit1.value-2 do {for nbr of people  less one do}
  begin
    {change the color of the eliminated person}
    cp.x:=centerx+trunc(radius*cos((circle[n]-1)*angle-pi/2));
    cp.y:=centery+trunc(radius*sin((circle[n]-1)*angle-pi/2));
    dec(count); {one less person in the circle}
    if circle[n]<>selected+1 then
    begin
      image1.canvas.copyrect(rect(cp.x-s2,cp.y-s2,cp.x+s2,cp.y+s2),
                           pic2.canvas,
                           rect(0,0,pic2.width,pic2.height));
      memo1.lines.add('#'+inttostr(circle[n])+' eliminated') {list the eliminated person}
    end
    else
    begin
      image1.canvas.copyrect(rect(cp.x-s2,cp.y-s2,cp.x+s2,cp.y+s2),
                           pic4.canvas,
                           rect(0,0,pic4.width,pic4.height));
      memo1.lines.add('Ooops, person number '+inttostr(selected+1)
       +', (you), is done for!');
    end;
    for j:=n to count-1 do circle[j]:=circle[j+1]; {close up the circle}
    n:=(n+increment-1) mod count; {we eliminated one person, so increase
                                     index by 1 less than increment}
    sleep(250);
    update;
  end;
  memo1.lines.add('Number '+inttostr(circle[0])+' is the survivor.');
  if circle[0]=selected+1 then memo1.lines.add('A wise choice on your part!');
end;

{************* ResetBtnclick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  memo1.clear;
  spinedit1change(sender);
end;

{********** Image1Mousedown **************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Select player's position based on which a smiley "wedge" was clicked}
var
  a:extended;
  cp:TPoint;
begin
  spinedit1change(sender);
  {computer angle of clicked smiley}
  if centerx=x then x:=centerx+1;
  a:=arctan2((centerx-x),y-centery);
  a:=a-pi +pi/spinedit1.value;
  if a<0 then a:=a+2*pi;

  if button=mbleft then
  begin
    selected:=trunc(a/(2*pi)*spinedit1.value);
    startat:=0;
  end
  else
  begin
    selected:=spinedit3.value-1;
    iSolvebtnclick(sender);
  end;
  memo1.lines.add(format('You are in position %d',[selected+1]));
  {change the color of the selected person}
  cp.x:=centerx+trunc(radius*cos((selected)*angle-pi/2));
  cp.y:=centery+trunc(radius*sin((selected)*angle-pi/2));
  image1.canvas.copyrect(rect(cp.x-s2,cp.y-s2,cp.x+s2,cp.y+s2),
                           pic3.canvas,
                           rect(0,0,pic3.width,pic3.height));
 Go; {run the elimination}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.ISolvebtnClick(Sender: TObject);

  function F(n,k:integer):integer;
  {recursive function -
    f(n,k)=(f(n-1,k)+k) mod n)
    f(0)=1;
   }
   begin
     if n=1 then result:=0
     else
     begin
       result:=(f(n-1,k)+k) mod n;
     end;
   end;


var
  n,k,a,last:integer;
begin
  n:=spinedit1.value;
  k:=spinedit2.value;
  a:=spinedit3.value;
  last:=f(n,k);
  startat:=(A-last+n-1) mod n +1 ;
  label5.caption:=format('To shoot #%d last, start counting at %d',[a,startat]);
end;

end.
