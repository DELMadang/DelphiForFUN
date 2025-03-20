unit U_Taylor;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Taylor power series or, more properly, a version
known a Maclaurin power series,  may be used to
accurately evaluate a number of important functions.

Illustrated here are the  exponential function, e^x,
and the trig function sine(x).

e^x = 1+x + x^2/2! + x^3/3! + x^4/4! ....

sine(x) = x - x^3/3! + x^5/5! - x^7/7! ....

The symbol " ^ " means "raised to the power", and "
N! ",  the factorial function, is the product of the
numbers from 1 to N.  Evaluation is step by step until
maximum internal accuracy is reached.

This is probably how the computer built-in routines evaluate these funtions. 
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    XLbl: TLabel;
    ListBox1: TListBox;
    EvalBtn: TButton;
    ResetBtn: TButton;
    StepsLbl: TLabel;
    FuncGrp: TRadioGroup;
    Label1: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure EvalBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FuncGrpClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    x, fx, prevfx:extended;
    bestval:extended;  {the value provided by built-in math routines}
    stepnbr:integer;
  end;

var  Form1: TForm1;

implementation

{$R *.dfm}
uses math;

{********** Factorial *************}
function factorial(n:integer):extended;
var i:integer;
begin
  result:=1.0;
  for i:=2 to n do result:=result*i;
end;

{***************** EvalBtnClick ************}
procedure TForm1.EvalBtnClick(Sender: TObject);
{Evaluate one step of the Taylor series expansion of the function being evaluated}
var OK:boolean;
    n:integer;
begin
  if (stepnbr>0) and ((bestval=fx) or (fx=prevfx))
  then showmessage('Maximum accuracy of internal representation reached')
  else
  begin
    OK:=true;
    prevfx:=fx;
    case funcgrp.ItemIndex of
      0: {exponential function e^x}
      begin
        fx:=fx+power(x,stepnbr)/factorial(stepnbr);
        bestval:=exp(x);
      end;
      1: {sin(x)}
      begin
        n:=2*stepnbr+1;
        if stepnbr mod 2 =0 then
        fx:=fx+power(x,n)/factorial(n)
        else fx:=fx-power(x,n)/factorial(n);
        bestval:=sin(x);
      end;

      else
      begin
        showmessage('Ha!');
        OK:=false;
      end;
    end;
    if ok then
    with listbox1,Items do
    begin
      inc(stepnbr);
      add(format('%2d: %20.18f',[stepnbr,fx]));
      add(format('         Error: %20.18f',[bestval-fx]));
      itemindex:=count-1; {force scroll down to show new item}
      stepslbl.Caption:='Step Nbr. '+inttostr(stepnbr);
    end;
  end;
end;

{***************** ResetBtnClick **************}
procedure TForm1.ResetBtnClick(Sender: TObject);
var s:string;
  i:integer;
begin
  listbox1.Clear;
  evalbtn.Enabled:=true;
  stepslbl.Caption:='Step Nbr.  0';
  stepnbr:=0;
  fx:=0;
  s:=trim(edit1.text[1]);
  if s[1]='.' then s:='0'+s;
  for i:=1 to length(s) do if not (s[i] in ['0'..'9','.'])
  then
  begin
     showmessage('Only digits and ''.'' allowed in input value');
     stepnbr:=-1; {set as error flag}
     evalbtn.enabled:=false;
  end
  else x:=strtofloat{def}(edit1.text{,1.0});
end;

{************ FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
begin  funcgrpclick(sender);  end;

{************** FuncGrpClick ************}
procedure TForm1.FuncGrpClick(Sender: TObject);
{Select & set up for the function to evaluate}
begin
  case funcgrp.ItemIndex of
    0: Xlbl.caption:='x in e^x';
    1: Xlbl.Caption:='x in sine(x)';
    else
    begin
       Xlbl.caption:='Not yet!';
       showmessage('Implementation of this function left as an exercise for the student! {:>)');
    end;   
  end;
  resetbtnclick(sender);
end;

{************* Get new input X value *************}
procedure TForm1.Edit1Exit(Sender: TObject);
begin
   resetbtnclick(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
