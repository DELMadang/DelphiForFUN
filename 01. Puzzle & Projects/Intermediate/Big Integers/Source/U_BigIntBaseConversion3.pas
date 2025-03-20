(*

*)

Unit U_BigIntBaseConversion3;

Interface

uses windows, strutils,math;

const
  BASE2        = '01';
  BASE8        = '01234567';
  BASE10       = '0123456789';
  BASE16L      = '0123456789abcdef';
  BASE16U      = '0123456789ABCDEF';
  BASE26L      = 'abcdefghijklmnopqrstuvwxyz';
  BASE26U      = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BASE36L      = '0123456789abcdefghijklmnopqrstuvwxyz';
  BASE36U      = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BASE62       = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  BASE64       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  BASE75       = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.,!=-*(){}[]';

  BASE128      = #000#001#002#003#004#005#006#007#008#009#010#011#012#013#014#015#016#017#018#019#020#021#022#023#024#025#026#027#028#029#030#031+
			     #032#033#034#035#036#037#038#039#040#041#042#043#044#045#046#047#048#049#050#051#052#053#054#055#056#057#058#059#060#061#062#063+
			     #064#065#066#067#068#069#070#071#072#073#074#075#076#077#078#079#080#081#082#083#084#085#086#087#088#089#090#091#092#093#094#095+
			     #096#097#098#099#100#101#102#103#104#105#106#107#108#109#110#111#112#113#114#115#116#117#118#119#120#121#122#123#124#125#126#127;

  BASE256      = #000#001#002#003#004#005#006#007#008#009#010#011#012#013#014#015#016#017#018#019#020#021#022#023#024#025#026#027#028#029#030#031+
			     #032#033#034#035#036#037#038#039#040#041#042#043#044#045#046#047#048#049#050#051#052#053#054#055#056#057#058#059#060#061#062#063+
			     #064#065#066#067#068#069#070#071#072#073#074#075#076#077#078#079#080#081#082#083#084#085#086#087#088#089#090#091#092#093#094#095+
			     #096#097#098#099#100#101#102#103#104#105#106#107#108#109#110#111#112#113#114#115#116#117#118#119#120#121#122#123#124#125#126#127+
			     #128#129#130#131#132#133#134#135#136#137#138#139#140#141#142#143#144#145#146#147#148#149#150#151#152#153#154#155#156#157#158#159+
			     #160#161#162#163#164#165#166#167#168#169#170#171#172#173#174#175#176#177#178#179#180#181#182#183#184#185#186#187#188#189#190#191+
			     #192#193#194#195#196#197#198#199#200#201#202#203#204#205#206#207#208#209#210#211#212#213#214#215#216#217#218#219#220#221#222#223+
			     #224#225#226#227#228#229#230#231#232#233#234#235#236#237#238#239#240#241#242#243#244#245#246#247#248#249#250#251#252#253#254#255;
var
  checkpoint:array[0..10] of int64;

function Binbase(Const BaseNum:Integer):AnsiString;

function Base(Const BaseNum:Integer):AnsiString;

function Convert(const src: AnsiString; const srctable: AnsiString; const desttable: AnsiString): AnsiString;
function Convert2(const src: AnsiString; const srctable: AnsiString; const desttable: AnsiString): AnsiString;

Procedure InitInts;
Procedure releaseInts;
Procedure  CKP(N:integer);


Implementation

uses UBigIntsV5;

var
qbig,val,val2:TInteger;
cpkNames:array[0..10] of ANSIString;
Latest:Int64;


Procedure  CKP(N:integer{; s:ANSIstring});
var
  i:integer;
  counter:int64;
begin
  if n=0 then
  begin
    for i:=1 to 10 do
    begin
      checkpoint[i]:=0;
    end;
    queryPerformanceCounter(latest);
  end
  else
  begin
    queryPerformanceCounter(counter);
    inc(checkpoint[n], counter-latest);
    latest:=counter;
  end;
end;



procedure InitInts;
begin
  val:=TInteger.create(0);
  val2:=TInteger.create(0);
  qbig:=TInteger.create(0);
end;

Procedure releaseInts;
begin
  val.Free;
  val2.free;
  qBig.free;
end;

function Base(Const BaseNum:Integer):AnsiString;
begin
Result := Copy(BASE62,1,Basenum);
end;


function Binbase(Const BaseNum:Integer):AnsiString;
begin
Result := Copy(BASE256,1,Basenum);
end;

function Convert(const src: AnsiString; const srctable: AnsiString; const desttable:ANSIString): AnsiString;
var
  r, numlen, srclen, destlen: int64;
  i : integer;
  //qbig,val,val2:Tinteger;
begin
  Result := '';
  srclen := Length(srctable);
  destlen := Length(desttable);
  numlen := Length(src);


  if ((srclen = 0) or (destlen = 0) or (numlen = 0)) then
  begin
    Exit;
  end;
  //val:=TInteger.create(0);
  //val2:=TInteger.create(0);
  //qbig:=TInteger.create(0);
  val.Assign(0);
  for i := 1 to numlen do
  begin
  Val.Mult(srclen);
  Val.Add(Pos(src[i], srctable) - 1);
  end;
  val2.Assign(val);
  val2.Modulo(destlen);
  val2.ConvertToInt64(r);
  Result := desttable[r + 1];

  qbig.Assign(val);
  qbig.Divide(destlen);
  while (qbig.IsPositive) do
  begin
    val2.assign(qbig);
    val2.Modulo(destlen);
    val2.ConvertToInt64(r);
    qbig.Divide(destlen);
    Result := desttable[r + 1] + Result;
  end;
end;


(*
function Convert2(const src: AnsiString; const srctable: AnsiString; const desttable:ANSIString): AnsiString;
var
  r, numlen, srclen, destlen: int64;
  i,n : integer;
  //qbig,val,val2:Tinteger;
  indices:set of char;
  index:array[0..255] of integer;

begin

  for i:=0 to high(index) do index[i]:=0;
  for i:=0 to high(srctable) do index[ord(srctable[i])]:=i;
  Result := '';
  srclen := Length(srctable);
  destlen := Length(desttable);
  numlen := Length(src);

  if ((srclen = 0) or (destlen = 0) or (numlen = 0)) then
  begin
    Exit;
  end;
//  qbig:=TInteger.create(0);
//  val:=TInteger.create(0);
//  val2:=TInteger.create(0);
  val.assign(0);
  for i := 1 to numlen do
  begin
    Val.Mult(srclen);
    //Val.Add(Pos(src[i], srctable) - 1);
    val.add(index[ord(src[i])]-1);
  end;
  val2.Assign(val);
  val2.Modulo(destlen);
  val2.ConvertToInt64(r);
  Result := desttable[r + 1];
  //Result[1] := desttable[r + 1];

  qbig.Assign(val);
  qbig.Divide(destlen);
  n:=1;
  while (qbig.IsPositive) do
  begin
    //val2.assign(qbig);
    //val2.Modulo(destlen);
    //qbig.Divide(destlen);

    qbig.dividerem(destlen,val2);
    val2.ConvertToInt64(r);
    Result :=  desttable[r + 1]+result;
    //inc(n);
    //result[n]:=desttable[r+1];

  end;
  //setlength(result,n);
  //result:=ReverseString(result);
end;
*)

function Convert2(const src: AnsiString; const srctable: AnsiString; const desttable:ANSIString): AnsiString;
var
  r, numlen, srclen, destlen: int64;
  i,n : integer;
  indices:set of char;
  index:array[0..255] of integer;

begin

  for i:=0 to high(index) do index[i]:=0;
  for i:=0 to high(index) do index[ord(srctable[i])]:=i;

  srclen := Length(srctable);
  destlen := Length(desttable);
  numlen := Length(src);
  SETLENGTH(RESULT, TRUNC(1.1*LENGTH(SRC)*LOG10(SRCLEN)/LOG10(DESTLEN)));
  //Result := '';

  if ((srclen = 0) or (destlen = 0) or (numlen = 0)) then
  begin
    Exit;
  end;
  CKP(0);

  if srctable=Base10 then
  begin
    qbig.assign(src);
  end
  else
  begin  {convert input # to decimal base}
    val.assign(0);
    for i := 1 to numlen do
    begin
      Val.Mult(srclen);
      val.add(pos(src[i],srctable)-1);
      //val.add(index[ord(src[i])]-1);
    end;
    //val2.Assign(val);
    //val2.Modulo(destlen);
    //val2.ConvertToInt64(r);
    qbig.Assign(val);
    //qbig.Divide(destlen);
    // Result := desttable[r + 1];
    //Result[1] := desttable[r + 1];
  end;
  n:=0;
  CKP(1);
  val2.assign(destlen);
  while (qbig.IsPositive) do
  begin

    val2.assign(qbig);
    val2.Modulo(destlen);
    qbig.Divide(destlen);

    //qbig.dividerem(destlen,val2);
    val2.ConvertToInt64(r);
    //qbig.divModSmall(val2,r);
    CKP(3);
    inc(   n);
    result[n]:=desttable[r+1];
  end;
  ckp(5);
  setlength(result,n);
  result:=ReverseString(result);
end;


(*
function Convert2(const src: AnsiString; const srctable: AnsiString; const desttable:ANSIString): AnsiString;
var
  r, numlen, srclen, destlen: int64;
  i,n : integer;
  qbig,val,val2:Tinteger;
  indices:set of char;
  index:array[0..255] of integer;

begin

  for i:=0 to high(index) do index[i]:=0;
  for i:=0 to high(srctable) do index[ord(srctable[i])]:=i;
  Result := '';
  srclen := Length(srctable);
  destlen := Length(desttable);
  numlen := Length(src);
  //setlength(result, trunc(1.1*length(src)*log10(srclen)/log10(destlen)));

  if ((srclen = 0) or (destlen = 0) or (numlen = 0)) then
  begin
    Exit;
  end;
  val:=TInteger.create(0);
  val2:=TInteger.create(0);
  for i := 1 to numlen do
  begin
    Val.Mult(srclen);
    //Val.Add(Pos(src[i], srctable) - 1);
    val.add(index[ord(src[i])]-1);
  end;
  val2.Assign(val);
  val2.Modulo(destlen);
  val2.ConvertToInt64(r);
  Result := desttable[r + 1];
  //Result[1] := desttable[r + 1];
  qbig:=TInteger.create(0);
  qbig.Assign(val);
  qbig.Divide(destlen);
  n:=1;
  while (qbig.IsPositive) do
  begin
    val2.assign(qbig);
    val2.Modulo(destlen);
    qbig.Divide(destlen);

    //qbig.dividerem(destlen,val2);
    val2.ConvertToInt64(r);
    Result :=  desttable[r + 1]+result;
    //inc(n);
    //result[n]:=desttable[r+1];

  end;
  //setlength(result,n);
  //result:=ReverseString(result);
end;
*)
End.
