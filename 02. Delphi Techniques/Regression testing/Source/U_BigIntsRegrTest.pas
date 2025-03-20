unit U_BigIntsRegrTest;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,ShellAPI, URegrtest, ubigintsv2;

type
  TForm1 = class(TForm)
    XEdit: TEdit;
    YEdit: TEdit;
    ZEdit: TEdit;
    Result1edt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    OpGrp: TRadioGroup;
    Modegrp: TRadioGroup;
    CalcBtn: TButton;
    Memo1: TMemo;
    Result2Edt: TEdit;
    Movetoxbtn: TButton;
    TimeLbl: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ResetBtn: TButton;
    RunAllBtn: TButton;
    StaticText1: TStaticText;
    Button2: TButton;
    Label7: TLabel;
    Baselbl: TLabel;
    procedure GetNextBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ModegrpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MovetoxbtnClick(Sender: TObject);
    procedure XEditDblClick(Sender: TObject);
    procedure Result1edtDblClick(Sender: TObject);
    procedure RunAllBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  public
    Regr:TRegress;
    x,y,z,r1,r2:TInteger;
    
    xBool:boolean;
    //fs:string;
    rBool:boolean;
    starttime, stoptime,runtime:int64;
    lastmode:integer;  {last clicked mode radio button, used to reset mode if user
                        cancels open or save dialogs while processing a mode change}
    fileeof:boolean;

    Function LoadFields(var Oprec:TOprec):boolean ;{Load input fields from a
                                                   passed filerec and call Evaluate}
    Function evaluate(var Oprec:TOprec):boolean ; {Evaluate field and build Oprec}
  end;

var
  Form1: TForm1;

implementation

uses U_ShowAll;

{$R *.DFM}

{*********** LoadFields ********}
Function TForm1.Loadfields(var Oprec:TOprec):Boolean;
{callback to load display fields and calls Evaluate to calculate and display
 results for each call to saverec}
begin
  with oprec do
  begin
    opgrp.itemindex:=strtoint(opcode);
    Xedit.text:=op1;
    YEdit.text:=op2;
    ZEdit.text:=op3;
    result:=true;
  end;
end;

{*********** Evaluate ********}
Function TForm1.Evaluate(var Oprec:TOprec):Boolean;
{callback procedure to fill in oprec with results fo each call to
 saverec (which calls Loadfields which in turn call Evaluate) or getnextrec}
var n:integer;
    errflag:boolean;
    X64, y64:Int64;
begin
  errflag:=false;
  if Xedit.text<>'' then X.assign(Xedit.text);
  if Yedit.text<>'' then Y.assign(Yedit.text);
  if Zedit.text<>'' then Z.assign(Zedit.text);
  screen.cursor:=crHourGlass;
  queryperformancecounter(starttime);
  R1.assign(x);
  R2.assign(0);
  case opgrp.itemindex of
    0: r1.add(y);
    1: R1.subtract(y);
    2: R1.mult(Y);
    3: R1.divide(Y);
    4: begin
        if y.convertToInt64(y64) then  R1.Pow(Y64)
        else showmessage('Y too large , max exponents is 2^63-1');
       end;
    5: R1.Square;
    6: r1.dividerem(Y,R2);
    7: R1.mult(Y);
    8: R1.assign(X);
    9: begin
         try
           X64:=strtoint64(Xedit.text);
         except
           showmessage('Attempted to pass Invalid X value, case ignored');
           errflag:=true;
         end;
         If not errflag then
         begin
           R1.assign(X64);
         end;
       end;
    10: begin
          RBool:=R1.IsOdd;
          r1.assign(Int64(RBool));
        end;
    11: R1.Factorial;
    12: R1.SqRoot;
    13: begin
          RBool:=R1.IsProbablyPrime;
          R1.assign(Int64(RBool));
        end;
    14: R1.modulo(Y);
    15: begin
          Y64:=strtoint(Yedit.text);
          R1.modulo(Y64);
        end;
    16: R1.ModPow(Y,Z);
    17: R1.GCD(Y);
    18: begin
          Y64:=strtoint(Yedit.text);
          R1.GCD(Y);
        end;
    19: R1.InvMod(Y);
    20: R1.ShiftLeft;
    21: R1.ShiftRight;
    22: begin
          Setbaseval(strtoint64(xedit.text));
          n:=GetBasePower;
          X.free; x:=TInteger.create;
          Y.free; Y:=TInteger.create;
          Z.free; Z:=TInteger.create;
          R1.free;  R1:=TInteger.create;
          R2.free;  R2:=TInteger.create;
          R1.Assign(10); R1.pow(n);  R2.assign(0);
          if Xedit.text<>'' then X.assign(Xedit.text);
          if Yedit.text<>'' then Y.assign(Yedit.text);
          if Zedit.text<>'' then Z.assign(Zedit.text);
          BaseLbl.caption:='Base='+r1.converttodecimalstring(true);
        end;
  end;
  queryperformancecounter(stoptime);
  runtime:=(stoptime-starttime)*1000000 div regr.freq;
  screen.cursor:=crdefault;
  result:=not errflag;
  if result then
  with Oprec do
  begin
    funcstr:=opgrp.items[opgrp.itemindex];
    OpCode:=inttostr(opgrp.itemindex);
    Op1:=Xedit.text;
    Op2:=YEdit.text;
    Op3:=Zedit.text;
    Result1:=r1.converttodecimalstring(true);
    Result2:=r2.converttodecimalstring(true);
    result1edt.text:=result1;
    result2edt.text:=result2;
    runMuSecs:=inttostr(runtime);
    Timelbl.caption:=runmusecs+' Microseconds';
  end;
end;

{************* GetNextBtnClick ***********}
procedure TForm1.GetNextBtnClick(Sender: TObject);
var
  OpRec,Filerec:TOprec;
  Matched:boolean;
begin
  case modegrp.itemindex of
    0,1,2: {New or append file}  regr.saverec;
    3:  {Read & process file}
    begin
      if regr.getnextrec(Oprec, Filerec,Matched)
      then with Oprec do
      begin
        result1edt.text:=result1;
        result2edt.text:=result2;
      end
      else
      begin
        showmessage('End of file reached');
        fileeof:=true;
      end;
    end;
  end; {case}
end;

{********** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Regr:=TRegress.create(LoadFields, Evaluate, memo1);
  regr.reset(none);
  x:=TInteger.create;
  y:=TInteger.create;
  z:=TInteger.create;
  r1:=TInteger.create;
  r2:=TInteger.create;
  queryPerformanceFrequency(regr.freq);
end;

{********** ModeGrpClick **************}
procedure TForm1.ModegrpClick(Sender: TObject);
{Define a new file mode}
begin
  Runallbtn.visible:=false;
  ResetBtn.visible:=false;
  case modegrp.ItemIndex of
    0: begin
        regr.reset(none);
        Calcbtn.caption:='Calculate';
      end;
    1:
      begin
        if regr.reset(write)
        then
        begin
          {modegrp.itemindex:=2;}   {change write to append}
          Calcbtn.caption:='Calc && save';
        end
        else  modegrp.itemindex:=lastmode;
        Calcbtn.caption:='Calc & save';
      end;
    2:
      begin
         If  not regr.reset(append)
         then modegrp.itemindex:=lastmode
         else Calcbtn.caption:='Calc & save';
       end;
    3:
       begin
         If regr.reset(read) then
         begin
           Runallbtn.visible:=true;
           Resetbtn.visible:=true;
           Calcbtn.caption:='Check next step';
         end
         else  modegrp.itemindex:=lastmode;
       end;
     end; {case}
     lastmode:=modegrp.itemindex;
     memo1.clear;
  end;

{*************** FormCloseQuery **********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  regr.reset(none);
  canclose:=true;
end;

{********** XEditDblClcik **********}
procedure TForm1.XEditDblClick(Sender: TObject);
begin
  With ShowAllDlg do
  begin
    memo1.lines.add(Xedit.text);
    Caption:='X Value';
    showmodal;
 end;
end;

{************ Result1EdtDblClick **********}
procedure TForm1.Result1edtDblClick(Sender: TObject);
begin
  With ShowAllDlg do
  begin
    memo1.lines.add(Result1Edt.text);
    Caption:='Result 1 Value';
    showmodal;
 end;
end;

{******** MoveToXBtnClick ********}
procedure TForm1.MovetoxbtnClick(Sender: TObject);
begin
  XEdit.text:=result1Edt.text;
end;

{*********** RunAllBtnClick ********}
procedure TForm1.RunAllBtnClick(Sender: TObject);
begin
  fileeof:=false;
  while not fileEof do GetNextbtnClick(sender);
end;

{******** ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  with regr do
  case modegrp.ItemIndex of
    0: reset(none);
    1: reset(write);
    2: reset(append);
    3: reset(read);
  end; {case}
  memo1.clear;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  regr.reset(renumber);  {close any open case file}
  
end;

end.
