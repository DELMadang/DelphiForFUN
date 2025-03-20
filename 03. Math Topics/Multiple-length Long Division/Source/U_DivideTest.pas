unit U_DivideTest;

{Copyright  © 2001-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Spin, shellAPI;

type
  Tbigints = class(TForm)
    Long1Edt: TEdit;
    Long2Edt: TEdit;
    DivideBtn: TButton;
    Memo1: TMemo;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    StaticText1: TStaticText;
    procedure DivideBtnClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    freq:Int64;
    
  end;

var
  bigints: Tbigints;

implementation
{$R *.DFM}
uses UBigIntsV2;

var  Firstclick:boolean=true;


procedure Tbigints.DivideBtnClick(Sender: TObject);
{divide}
var
  i1,i2,rem :Tinteger;
  start,stop:int64;
begin
  if firstclick then
  begin
    memo1.lines.clear;
    firstclick:=false;
  end;;
  i1:=TInteger.create;
  i2:=TInteger.create;
  rem:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  queryPerformanceCounter(start);
  i1.Olddividerem(i2,rem);
  queryPerformanceCounter(stop);

  memo1.lines.add('Old: '+long1edt.text+'/'+long2edt.text
    +' = '+i1.converttoDecimalString(true)+'   Remainder='
    + rem.converttoDecimalString(true)
    +format(' Time: %5.2f microseconds', [(stop-start)/freq*1e6]));
  i1.free;
  i2.free;
  rem.free;
end;

procedure Tbigints.Button1Click(Sender: TObject);
var
  i1,i2,rem :Tinteger;
  start,stop:int64;
begin
  if firstclick then
  begin
    memo1.lines.clear;
    firstclick:=false;
  end;;
  i1:=TInteger.create;
  i2:=TInteger.create;
  rem:=TInteger.create;
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
   queryPerformanceCounter(start);
  i1.dividerem(i2,rem);
   queryPerformanceCounter(stop);
  memo1.lines.add('New: '+long1edt.text+'/'+long2edt.text
    +'='+i1.converttoDecimalString(true)+'   Remainder='
    + rem.converttoDecimalString(true)
     +format(' Time: %5.2f microseconds', [(stop-start)/freq*1e6]));
  i1.free;
  i2.free;
  rem.free;
end;



procedure Tbigints.SpinEdit1Change(Sender: TObject);
var
  i:integer;
  b:int64;
begin
  B:=10;
  for i:=2 to spinedit1.value do b:=b*10;
  setbaseval(B);
  If not firstClick then Memo1.lines.add('Base='+inttostr(B));
end;

procedure Tbigints.FormCreate(Sender: TObject);
begin
  spinedit1change(sender);
  queryperformanceFrequency(freq);
  FirstClick:=true;
end;

procedure Tbigints.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
