unit U_IntPowerDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    NumEdt: TEdit;
    PowerEdt: TEdit;
    LoopsEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    x:extended;
    power:integer;
    loops:integer;
    start,stop,freq:int64;
    ans:extended;
    procedure starttime;
    procedure stoptime(msg:string);
    procedure setup;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

procedure TForm1.starttime;
begin
  queryperformancecounter(start);
end;

procedure TForm1.stoptime(msg:string);         
begin
  queryperformancecounter(stop);
  queryperformancefrequency(freq);
  showmessage('Time for '+format('%6.0g',[0.0+loops])+' calculations  of '
            +floattostr(x)+'^'+inttostr(power)
             +#13+'Answer is '+ floattostr(ans)
            +#13+'using '+msg +' is '+format('%8.6n seconds',[(stop-start)/freq])
           );
end;

procedure TForm1.setup;
begin
  x:=strtofloat(numedt.text);
  power:=strtoint(poweredt.text);
  loops:=strtoint(loopsedt.text);
  starttime;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j:integer;

begin
  setup;
  for i:= 1 to loops do
  begin
    ans:=x;
    for j:=2 to power do ans:=ans*x;
  end;
  stoptime('Loop method');
end;

procedure TForm1.Button2Click(Sender: TObject);
{if power,p, is even, tempans= v^(p div 2)*v^(p div 2)
{if p is odd and > 1, tempans:=v^(p div 2)*v^(p div 2)* x}
{if p=1 then tempans=v;
{use recursion}
var
  i:integer;

  function getpower(x:extended; p:integer):extended;
  var
    temp:extended;
  begin
    if p=1 then result:=x
    else
    begin
      temp:=getpower(x, p div 2);
      if p mod 2 = 0 then result:=temp*temp
      else result:=temp*temp*x;
    end;
  end;

begin
  setup;
  for i:= 1 to loops do ans:=getpower(x,power);
  stoptime('Recursion method');
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i,p:integer;
  temp:extended;
begin
  setup;
  for i:= 1 to loops do
  begin
    ans:=1;
    temp:=x;
    p:=power;
    while p>0 do
    begin
      if p mod 2 =1 then ans:=(ans*temp);
      temp:=temp*temp;
      p:= p div 2;
    end;
  end;
  stoptime('Powers of 2 method');
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i:integer;
begin
  setup;
  for i:= 1 to loops do ans:=intpower(x,power);
  stoptime('Delphi IntPower function');
end;

end.
