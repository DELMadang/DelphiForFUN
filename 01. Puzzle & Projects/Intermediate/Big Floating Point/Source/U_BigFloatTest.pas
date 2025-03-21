unit U_BigFloatTest;
 {Copyright  � 2003-2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, ShellAPI,
  UBigFloatV3;

type
  TOpBox = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    TestBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Result: TLabel;
    N1NormLbl: TStaticText;
    N1SciLbl: TStaticText;
    N2NormLbl: TStaticText;
    N2SciLbl: TStaticText;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Maxdigits: TSpinEdit;
    Memo1: TMemo;
    StopBtn: TButton;
    StaticText1: TStaticText;
    OpList: TListBox;
    Label10: TLabel;
    ResultN: TMemo;
    ResultS: TMemo;
    MoveBtn: TButton;
    Button1: TButton;
    AllocLbl: TLabel;
    procedure TestBtnClick(Sender: TObject);
    procedure OpGrpClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure OpListDblClick(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OpBox: TOpBox;

implementation

{$R *.dfm}

type
  //Input conversions, {float,float}, {float,integer}, {float,none}, {none,none}
  tconvertTypes=(FF,FI,FN,NN);
var converttype:array[0..19] of TConverttypes=(FF,FF,FF,FF,
                                               FN,FN,FI,FI,
                                               FI,FF,FF,FN,
                                               FN,FN,NN,
                                               FI,FI,FI,FI,FI);

{******************* TestBtnClick ***************}
procedure TOpBox.TestBtnClick(Sender: TObject);
  var  a,b:TBigfloat;
       bInt:Integer;
       r:integer;
{perform the selected operation}
begin

  a:=TBigFloat.create;  a.Setsigdigits(maxdigits.Value);
  b:=TBigFloat.create;  b.SetSigdigits(maxdigits.Value);


  N1SciLbl.caption:='';
  N1NormLbl.caption:='';
  if converttype[oplist.itemindex] in [FF,FI,FN] then
  begin {a= flost(x)}
      a.assign(edit1.text);
      N1SciLbl.caption:=a.converttoString(scientific);
      N1NormLbl.caption:=a.converttoString(normal);
   end;
   if converttype[oplist.itemindex] =FF then
   begin
      b.Assign(edit2.text);
      N2SciLbl.caption:=b.ConvertToString(scientific);
      N2NormLbl.caption:=b.ConvertToString(normal);
   end
   else
   if converttype[oplist.itemindex] =FI then
    begin
      bint:=strtoint(edit2.text);
      N2SciLbl.caption:='';
      N2NormLbl.caption:=edit2.text;
    end;

  with oplist do
  case itemindex of
    0: a.add(b);

    1: a.subtract(b);

    2: a.mult(b);

    3:begin
         screen.cursor:=crHourGlass;
         application.tag:=0;
         stopbtn.visible:=true;
         stopbtn.bringtofront;
         stopbtn.update;
         a.divide(b, maxdigits.Value);
         stopbtn.visible:=false;
         screen.cursor:=crdefault;
       end;
    4: a.square(maxdigits.value);
    5: a.sqrt(maxdigits.value);
    6: a.reciprocal(maxdigits.value);
    7: a.IntPower(bInt, maxdigits.value);
    8: a.Nroot(bInt, maxdigits.value);
    9:{compare} r:=a.compare(b);
    10:{Power} a.Power(b, maxdigits.value);
    11:{Log}   a.Log(maxdigits.value);
    12:{Log10} a.Log10(maxdigits.value);
    13:{Exp}   a.exp(maxdigits.value);
    //14:{Floor} a.floor(bInt);
    //15:{Ceil} a.Ceiling(bInt);
    14:{Pi}  a.PiConst(maxdigits.value);
    15: {RoundToPrec}
        a.roundtoprec(bint);
    16: {Round}
        a.round(bint);
    17: {Trunc}
        a.trunc(bint);
    18: {Floor}
        a.Floor(bint);
    19: {Ceiling}
        a.Ceiling(Bint);
  end;
  //a.round;
  if oplist.itemindex=9 then
  begin
    case r of
      -1:ResultN.text:='-1 (X<Y)';
      0: ResultN.text:='0 (X=Y)';
      +1:ResultN.text:='+1 (X>Y)';
    end;
  end
  else
  begin
    ResultS.text:=a.ConverttoString(scientific);
    ResultN.text:=a.ConverttoString(normal);
  end;
  a.free;
  b.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
  movebtn.enabled:=true;
end;

procedure TOpBox.OpGrpClick(Sender: TObject);
begin
  if (OpList.itemindex>=4) and (OpList.itemindex<=6) then edit2.visible:=false
  else edit2.visible:=true;
end;

procedure TOpBox.StopBtnClick(Sender: TObject);
begin
  application.tag:=1;
end;

procedure TOpBox.FormCreate(Sender: TObject);
begin
  Stopbtn.top:=testbtn.top;{buttons defined with different tops for convenience}
  {$IF compilerversion<=15}
  edit1.text:= '4'+decimalseparator+'91234567891e-5';
  {$ELSE}
  edit1.text:= '4'+FormatSettings.decimalseparator+'91234567891e-5';
  {$IFEND}
end;

procedure TOpBox.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TOpBox.OpListDblClick(Sender: TObject);
begin
   testbtnclick(sender);
end;

procedure TOpBox.MoveBtnClick(Sender: TObject);
begin
  edit1.text:=results.text;
  {update the labels}
  N1SciLbl.caption:=resultn.text;
  N1NormLbl.caption:=results.text
end;


procedure TOpBox.Button1Click(Sender: TObject);
var
  a:TBigFloat;
  result:extended;
 function Euro_Round(aValue: double): Extended; var
   a: TBigFloat;
  begin
     a := TBigFloat.Create(25);
     try
        a.Assign( aValue );
        if a.IsZero then
             Result := 0
        else begin
             a.Round(2);
             a.ConvertToExtended( Result );
        end;
     finally
        a.free;
     end;
   end;
   (*
program Project1;

{$APPTYPE CONSOLE}

uses
ubigFloatV3;

var
a: TBigFloat;
begin
a := TBigFloat.create(25);
try
a.Assign( 0.006 );
a.Round( 2 );

writeln( a.ConvertToString( normal ) );
readln;
finally
a.free;
end;
end.
===========================

It prints 0 instead of 0.01
Could you give it a try please ?


begin
   writeln( euro_round( 0.006 ) );
end.

//===========================================

//I should get 0.01 (rounding at the second digit after comma) but I get 1 !!!!!
*)

begin
  a := TBigFloat.Create(25);
  try
     a.Assign( 0.006 );
     a.Round(2);  // Range check Error in RoundToPrec
     a.ConvertToExtended( result);
     showmessage(format('Result= %f',[euro_round(0.006)]));
  finally
     a.free;
  end;
end;  


(*
procedure TOpBox.Button1Click(Sender: TObject);
var
  a:TBigFloat;
  prime:Tinteger;
  s:string;
  nbrdigits:integer;
begin
   nbrdigits:=10000;
   Prime:=TInteger.create;
   prime.assignrandomprime(64, '1234567890', true);
   //prime:=random(1000000000); {get a prime < 1 billion}

   a := TBigFloat.Create(nbrdigits);
   a.Assign(1);
   a.divide(prime,nbrdigits);
   a.Sqrt(nbrdigits);

   s:=a.ConvertTostring(normal);
   resultn.Text:=s;
end;
*)

end.
