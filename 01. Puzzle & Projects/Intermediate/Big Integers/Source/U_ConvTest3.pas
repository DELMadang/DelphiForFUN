unit U_ConvTest3;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls,  U_BigIntBaseConversion3,
  uBigIntsV5, {Vcl.Buttons,} DFFUtils  ;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Edit1: TEdit;
    ToBase1Grp: TRadioGroup;
    Memo1: TMemo;
    FromBaseGrp: TRadioGroup;
    Label1: TLabel;
    Output: TLabel;
    ToBase2Grp: TRadioGroup;
    Edit2: TEdit;
    OpsGrp: TRadioGroup;
    ValidateBox: TCheckBox;
    MakeRandomBtn: TButton;
    SourceGrp: TRadioGroup;
    Edit3: TEdit;
    SelectedTxt: TEdit;
    Label2: TLabel;
    DoItBtn: TButton;
    CodeGrp: TRadioGroup;
    Memo2: TMemo;
    Button1: TButton;
    Label3: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure DoItBtnClick(Sender: TObject);
    procedure MakeRandomBtnClick(Sender: TObject);
    procedure SourceGrpClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    BigRandom:ANSIString;
    NumIn1, NumOut1, NumOut2, NumOut3,Result:Ansistring;
    SrcTable,DestTable1, DestTable2, ResultTable:ANSIString;
    NumIsResult:boolean;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  maxtoshow=50;

Procedure Setup(Index:integer; Var Base:integer; var Table:ANSiString);
begin
   case index of
    0: Begin Base:=2; Table:=Base2; End;
    1: Begin Base:=8; Table:=Base8;  End;
    2: Begin Base:=10; Table:=Base10; End;
    3: Begin Base:=16; Table:=Base16L; End;
    4: Begin Base:=256; Table:=Base256; End;
  end;

end;

function small(s:ANSIString):String;
begin
    result:=copy(s,1,maxtoshow);
end;

{************** MakeRandomBtnClick ********}
procedure TForm1.Edit1Change(Sender: TObject);
begin
  if sourcegrp.itemindex=0 then sourcegrpclick(sender);
end;

procedure TForm1.MakeRandomBtnClick(Sender: TObject);
var
  A:TInteger;
  N:integer;
  s2:ANSIString;
begin
  screen.cursor:=crhourglass;
  n:=Strtointdef(Edit2.text,100);
  Edit2.text:=inttostr(n);
  A:=TInteger.Create(0);
  A.RandomOfSize(n);
  BigRandom:=A.converttodecimalstring(false);
  edit3.text:=small(bigrandom);
  sourcegrp.itemindex:=1;
  selectedtxt.text:=edit3.text;
  screen.cursor:=crDefault;
end;

var
  base10Table:ANSIstring='0123456789';

function Min(const a,b:integer):integer;
begin  if b<a then result:=b else result:=a; End;

{*********** DoItBtnClick ************}
procedure TForm1.Button1Click(Sender: TObject);
  var
  A:TInteger;
  B1,B2,B3:ANSIString;
  T:TextFile;
begin
  InitInts;
  A:=TInteger.create(0);
  A.RandomOfSize(100);
  B1:=A.converttodecimalstring(false);
  B2:=Convert2(B1,'0123456789','0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  memo1.lines.add('Step 1 OK');
  B3:=Convert2(B2,'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ','0123456789');
  memo1.lines.add('Step 2 OK');
  AssignFile(T,FormatDateTime('yyyymmddhhnnss',Now)+'.TXT'); Rewrite(T);
  writeln(T,B3);
  Closefile(T);

end;

procedure TForm1.DoItBtnClick(Sender: TObject);
var
  InBase,OutBase1, OutBase2:integer;
  Start,Stop,stopV,Freq:int64;
  Runtime, RuntimeV:String;
  i, ToShow:integer;
  QBig:TInteger;
begin
  Result:='';
  memo1.lines.clear;
  InitInts;
  QBig:=TInteger.create(0);
  application.processmessages;
  {Get input base and table}
  Inbase:=2; {Assume decimal unless Result is chosen as source input}
  case sourcegrp.ItemIndex of
    0:NumIn1:=Edit1.Text;  {Input is text}
    1:Numin1:=BigRandom; {input is current random #}
    2:begin  {input is previous result }
       numin1:=Result;
       if opsgrp.ItemIndex=0 then
       begin
         InBase:=OutBase1;
         srctable:=desttable1;
       end
       else
       begin
         inBase:=OutBase2;
         srctable:=desttable2;
      end;
    end;
  end;

  //else if not NumisResult then Numin1:= ANSIString(Edit1.Text);
  //NumIsResult:=false;

  screen.cursor:=crHourglass;
  queryPerformanceFrequency(Freq);
  queryPerformanceCounter(Start);
   //cpk(0,'Start');

  {Read an integer and convert it to another base}
  Setup(FromBaseGrp.itemindex, InBase,Srctable);
  Setup(Tobase1Grp.itemindex, OutBase1, DestTable1);
  if opsgrp.itemindex= 1 then Setup(Tobase2Grp.itemindex, OutBase2, DestTable2);
  //CKP(1,'After setups');

  if Codegrp.itemindex=0 then   {Test Convert2 function}
  begin
    NumOut1:=Convert2(Numin1, SrcTable, DestTable1);
  end
  else
  begin {Test Tinteger.ConvertToStringbase method}
    if frombasegrp.itemindex<>2 then
    begin
      showmessage('Input number must be base 10 for "method" test');
    end
    else
    begin
      qbig.assign(numin1);
      Numout1:=qbig.convertToStringBase(destTable1);
    end;
    //Result:=NumOut1;
    //ResultTable:=DestTable1);
  end;

  If Opsgrp.ItemIndex =1 then {Perform a second conversion}
  begin
    if codegrp.itemindex=0 then {testing convert2}
    begin
      Numout2:=Convert(NumOut1, DestTable1, DestTable2);
    end
    else  {testing two conversions for ConvertToStringBase method}
    begin  {do a second calculation}
      {convert Numout1 to base10 biginteger}
      qbig.assign(numout1, desttable1);
      Numout2:=qbig.convertToStringBase(destTable2);
    end;
    Result:=NumOut2;
    ResultTable:=DestTable2;
  end
  else
  begin  {Only a single conversion}
    Result:=Numout1;
    ResultTable:=DestTable1;
  end;
  queryPerformanceCounter(Stop);
  Runtime:=format('Run Time: %f ms',[(stop-start)/freq*1000]) ;
  If ValidateBox.Checked then
  begin
    Numout3:=Convert2(Result, ResultTable, SrcTable);
    queryPerformanceCounter(StopV);
    RuntimeV:=format('Validation Time: %f ms',[(stopV-stop)/freq*1000]) ;
  end;


  screen.cursor:=crDefault;
  with memo1,lines do
  begin
    toshow:=min(maxtoshow,length(numin1));
    add(format('Input: %s... 1st %d of %d',[Small(NumIn1),toshow,length(numin1)]));
     toshow:=min(maxtoshow,length(numout1));
    add(format('OutPut 1: %s... 1st %d of %d',[small(NumOut1),toshow,length(Numout1)]));
    If opsgrp.ItemIndex=1 then
    begin
      toshow:=min(maxtoshow,length(Numout2));
      add(format('Output 2: %s... 1st %d of %d',[small(NumOut2),toshow, length(NumOut2)]));
    end;
    Add(RunTime);
    if validatebox.Checked then
    begin
      If NumOut3=Numin1 then add('Conversion back to original base matched!"')
      else
      begin
        toshow:=min(maxtoshow,length(Numout3));
        add(Format('Resultdoes not match original: %s... %d',[small(NumOut3),toshow,length(numout3)]));
      end;
      add(RuntimeV);
    end;
    (*
    for i:=01 to 3 do
    begin
      Add(format('Checkpt %d : %.4f second',[i,checkpoint[i]/freq]));
    end;
    *)
  end;
  ReleaseInts;
  qbig.free;
end;

(*
  NumIn1:=Result;
  NumIsResult:=true;
  //if not checkbox1.checked then Edit1.text:=result;
  SrcTable:=ResultTable;
  with FromBaseGrp do
  case length(srctable) of
    2:  itemindex:=0;
    8:  itemindex:=1;
    10: itemindex:=2;
    16: itemindex:=3;
    256:itemindex:=4;
  end;
  edit1.text:=small(Numin1);
end;
*)


procedure TForm1.SourceGrpClick(Sender: TObject);
begin
  case sourcegrp.ItemIndex of
    0:SelectedTxt.text:=Edit1.Text;
    1:SelectedTxt.text:=small(Bigrandom);
    2:SelectedTxt.Text:=small(Result);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




end.
