unit U_MemLeakDemo;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Memo2: TMemo;
    Button3: TButton;
    Button4: TButton;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type

tRec=record
       x:array[1..250] of integer;
     end;
ptrec=^trec;  {pointer to tRec}

procedure allocate10without(n:integer);
{allocate N new recorde with the same pointer}
var
  i:integer;
  prec:ptRec;
begin
  for i:=1 to N do prec:=new(ptrec);
end;

procedure allocate10with(N:integer);
{allocate  and dispose of N records with the same pointer}
var
  i:integer;
  prec:ptRec;
begin
  for i:=1 to N do
  begin
    prec:=new(ptrec);
    dispose(prec);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo1.lines.add('');
  memo1.lines.add('Before New without Dispose 1 rec: '+inttostr(allocmemsize));
  allocate10without(1);
  memo1.lines.add('After New without Dispose 1 rec: '+inttostr(allocmemsize));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  memo1.lines.add('');
  memo1.lines.add('Before New and Dispose 1 rec: '+inttostr(allocmemsize));
  allocate10with(1);
  memo1.lines.add('After New and Dispose 1 rec: '+inttostr(allocmemsize));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  memo1.lines.add('');
  memo1.lines.add('Before New without Dispose 10 rcs: '+inttostr(allocmemsize));
  allocate10without(10);
  memo1.lines.add('After New without Dispose 10 recs: '+inttostr(allocmemsize));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  memo1.lines.add('');
  memo1.lines.add('Before New and Dispose 10 recs: '+inttostr(allocmemsize));
  allocate10with(10);
  memo1.lines.add('After New and Dispose 10 recs: '+inttostr(allocmemsize));
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
