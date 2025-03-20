unit U_EvalExpressions;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ShellAPI, UTEval, u_VerboseDisplay;

type
  TForm1 = class(TForm)
    Variables: TMemo;
    Expressions: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Results: TMemo;
    EvaluateBtn: TButton;
    Label3: TLabel;
    Verbosebox: TCheckBox;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure EvaluateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    ExpressionEval:TEval;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* EvaluateBtnClick **********}
procedure TForm1.EvaluateBtnClick(Sender: TObject);
{Evaluate the given expressions using the defined variable values}
var
  i,n:integer;
  newval:single;
  s:string;
begin
  results.clear;
  
  with ExpressionEval do
  begin
    clearvariables;
    verboselist.clear;
    verbose:=verbosebox.checked;
    with variables,lines do
    for i:=0 to count-1 do
    begin
      s:=lines[i];
      n:=pos('=',s);
      if n>0 then addvariable(copy(s,1,n-1), strtofloat(copy(s,n+1,length(s)-1)));
    end;
    with expressions do
    for i:=0 to lines.count-1 do
    begin
      if evaluate(lines[i], newval) then
      begin
        results.lines.add(lines[i]+' = '+format('%.2f',[newval]));
        if verbose then
        begin
          form2.VerboseMemo.lines.text:=verboselist.text;
        end;
      end
      else results.lines.add(lines[i]+': '+getlasterror);
    end;
    if verbose then form2.show;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ExpressionEval:=TEval.create;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
