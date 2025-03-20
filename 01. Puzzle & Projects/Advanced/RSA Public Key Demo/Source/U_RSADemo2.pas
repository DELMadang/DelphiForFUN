unit U_RSADemo2;
{Copyright © 2009, 2012 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A demo program applying the RSA public key security algorithm for exchanging
 messages. }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, shellAPI, uBigIntsV3, dffutils,
  Menus;

type

  TActor=(Alice, Bob);

  TKeyInt=TInteger;

  TKeyObj=class(TObject)
    ID:string;
    {Keep all four the following four values for debugging}
    {The public key is the pair [n,e]}
    {The private key is the pair [n,d]}
    n:TInteger; {the modulus, product p*q of 2 large random primes}
    {Term: CoPrime ==> relatively prime ==> no common factor >1}
    phi:TInteger; {The Totient phi=(p-1)*(q-1)= count of numbers < n which are coprime to n}
    e:TInteger; {Random number < phi and coprimne to phi}
    d:TInteger; {Multiplicative inverse if e relative to phi,
                 which means that  d*e mod phi = 1}
    blocksize:integer; {Number of characters encrypted as a single block}
    keysize:Integer; { number of bits in the modulus}
    constructor create(newid:string; newkeysize:integer);
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    AliceSheet: TTabSheet;
    BobSheet: TTabSheet;
    Label2: TLabel;
    AlicemakeKeyBtn: TButton;
    AliceRecodeBtn: TButton;
    AliceEncryptedMemo: TMemo;
    AlicePlainTextMemo: TMemo;
    AliceSendBtn: TButton;
    AliceSizeGrp: TRadioGroup;
    Label1: TLabel;
    BobMakeKeyBtn: TButton;
    BobRecodeBtn: TButton;
    BobEncryptedmemo: TMemo;
    BobPlainTextMemo: TMemo;
    BobSendBtn: TButton;
    BobSizeGrp: TRadioGroup;
    AlicePubKeyMemo: TMemo;
    BobPubKeyMemo: TMemo;
    StaticText1: TStaticText;
    AlicePrivateBtn: TButton;
    BobPrivateBtn: TButton;
    AliceClearBtn: TButton;
    Label3: TLabel;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    Memo3: TMemo;
    GoBobLbl: TLabel;
    GoAliceLbl: TLabel;
    AliceSampleBtn: TButton;
    BobSampleBtn: TButton;
    BobClearBtn: TButton;
    procedure AlicemakeKeyBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AliceRecodeBtnClick(Sender: TObject);
    procedure AliceSendBtnClick(Sender: TObject);
    procedure BobMakeKeyBtnClick(Sender: TObject);
    procedure BobRecodeBtnClick(Sender: TObject);
    procedure BobSendBtnClick(Sender: TObject);
    procedure BobPlainTextMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StaticText1Click(Sender: TObject);
    procedure AlicePrivateBtnClick(Sender: TObject);
    procedure PrivateBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SampleBtnClick(Sender: TObject);
  public
    Alice:TKeyObj;
    Bob:  TKeyObj;
    InitialMsgA, InitialMsgB:TStringlist;
    function getkeysize(keysizegrp:TRadiogroup):integer;
    procedure makeRSAKey(Actor:TKeyObj);
    function Encrypt(const s:string; actor:TKeyObj {n,e:Tinteger}):string;
    function Decrypt(const s:string; actor:TKeyObj {n,d:Tinteger}):string;
    procedure updatepubKeyMemos;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses math;

{************ TKeyObj.create *************8}
constructor TKeyObj.create(newid:string; newkeysize:integer);
begin
  id:=newid;
  keysize:=newkeysize;
  n:=TInteger.Create;
  phi:=TInteger.Create;
  e:=TInteger.create;
  d:=Tinteger.create;
end;


{************* MakeRSAKey *************}
procedure TForm1.MakeRSAKey(Actor:TKeyObj);
var
  p,q:TKeyInt;
  temp:TKeyint;
  primesize:integer;
begin
  screen.cursor:=crhourglass;
  with actor do
  begin
    {target number of decimal digits is about 0.3  times the specified bit length}
    primesize:=trunc(keysize*log10(2)/2)+1;

    p:=TKeyInt.create;
    q:=TKeyInt.create;
    temp:=TKeyInt.create;

    Temp.assign(2);
    temp.pow(keysize);  {this is smallest valid N value}


    repeat
      {Generate random p}
      p.randomOfSize(primesize);
      p.getnextprime;

      {Generate random q}
      repeat
        q.randomOfSize(primesize);
        q.getnextprime;
      until p.compare(q)<>0;
      {n=p*q}
      n.assign(p);
      n.mult(q);
    until N.Compare(temp)>0;

     {Phi=(p-1)*(q-1)}
    Phi.assign(p);
    phi.subtract(1);
    temp.assign(q);
    temp.subtract(1);
    phi.mult(temp);
     {random e < Phi such that GCD(phi,e)=1}
    repeat
      e.random(phi);
      temp.assign(phi);
      temp.GCD(e);
    until temp.compare(1)=0;
    d.assign(e);
    d.invmod(phi);
    n.Trim;
    Blocksize:=trunc(n.digitcount/log10(256));
    temp.free;
    p.free;
    q.free;
  end;
  screen.Cursor:=crdefault;
end;

(*
{************* MakeRSAKey *************8}
procedure TForm1.MakeRSAKey(Actor:TKeyObj);
var
  p,q:TKeyInt;
  temp:TKeyint;
  primesize:integer;
begin
  screen.cursor:=crhourglass;
  with actor do
  begin
    {target number of decimal digits is about 0.3  times the specified bit length}
    primesize:=trunc(keysize*log10(2)/2)+2{1};

    p:=TKeyInt.create;
    q:=TKeyInt.create;
    temp:=TKeyInt.create;

    {Generate random p}
    p.randomOfSize(primesize);
    p.getnextprime;
    //p.assign(109); {test value}

    {Generate random q}
    repeat
      q.randomOfSize(primesize);
      q.getnextprime;
    until p.compare(q)<>0;
    //q.assign(157); {test value}
    {n=p*q}
    n.assign(p);
    n.mult(q);
    {Phi=(p-1)*(q-1)}
    Phi.assign(p);
    phi.subtract(1);
    temp.assign(q);
    temp.subtract(1);
    phi.mult(temp);
    {random e < Phi such that GCD(phi,e)=1}
    repeat
      e.random(phi);
      temp.assign(phi);
      temp.GCD(e);
    until temp.compare(1)=0;
    //e.assign(17); {test value}
    d.assign(e);
    d.invmod(phi);
    n.Trim;
    blocksize:=1; //trunc(n.digitcount/log10(256));  {Error possible if >1}
    temp.free;
    p.free;
    q.free;
  end;
  screen.cursor:=crdefault;
end;
*)

procedure TForm1.updatepubKeyMemos;
      procedure UpdateMemo(PubKeyMemo:TMemo);
      begin
        with PubKeyMemo do
        begin
          clear;
          lines.add(format('Alice Public Key: <%s, %s>',
                    [alice.n.convertTodecimalstring(false),
                     alice.e.convertTodecimalstring(false)]));
          lines.Add('===========================================');           
          lines.add(format('Bob Public Key: <%s, %s>',
                    [bob.n.convertTodecimalstring(false),
                     bob.e.convertTodecimalstring(false)]));
        end;
      end;

begin  {Update Public Info}
  updatememo(AlicePubKeyMemo);
  updatememo(BobPubKeyMemo);
end;

{************* AliceMakeKeyBtnClick **********}
procedure TForm1.AlicemakeKeyBtnClick(Sender: TObject);

begin
  alice.keysize:=getkeysize(AliceSizeGrp);
  MakeRSAKey(Alice);
  UpdatePubKeyMemos;
end;


{************* BobMakeKeyBtnClick *********}
procedure TForm1.BobMakeKeyBtnClick(Sender: TObject);
begin
   bob.keysize:=getkeysize(BobSizegrp);
   MakeRSAKey(Bob);
   updatePubKeyMemos;
   (*
   bobpubkeymemo.clear;
   bobpubkeymemo.lines.add(format('Public Key: <%s, %s>',
           [bob.n.convertTodecimalstring(false),
            bob.e.convertTodecimalstring(false)]));
   *)
end;



{************* FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  alice:=tkeyobj.create('Alice', Getkeysize(AliceSizeGrp));
  bob:=TKeyobj.create('Bob', Getkeysize(BobSizeGrp));
  AlicerecodeBtn.tag:=1;
  BobRecodebtn.tag:=1;
  AlicemakeKeyBtnclick(sender);
  BobMakeKeyBtnclick(sender);
  reformatmemo(memo2);
  reformatmemo(memo3);
  InitialMsgA:=TStringlist.create;
  InitialMsgB:=TStringList.create;
  InitialMsgA.text:=AlicePlainTextMemo.lines.text;
  InitialMsgB.Text:=BobPlainTextMemo.lines.text;
end;

{************** GetKeySize ************}
function TForm1.getkeysize(keysizegrp:TRadiogroup):integer;
begin
  case keysizegrp.ItemIndex of  {key bitsize}
    0: result:=16;
    1:result:=64;
    2:RESULT:=256;
    3: result:=512;
    4:result:=1024;
  end;
end;

{************* Encrypt *************8}
function TForm1.Encrypt(const s:string; actor:TKeyObj {n,e:Tinteger}):string;
var
  nbrblocks:integer;
  i,j,start:integer;
  p:TKeyInt;
  outblock:integer;
  temps:string;
begin
  {recode the string blocksize bytes at a time}
  with actor do
  begin
    p:=TKeyInt.create;
    nbrblocks:=length(s) div blocksize;
    outblock:=n.digitcount; {size of outputblocks}
    result:='';
    start:=1;
    for i:=0 to nbrblocks do
    begin
      p.assign(0);
      for j:=start to start+blocksize-1 do
      if j<=length(s) then
      begin
        p.mult(256); {shift the # left by one byte}
        p.add(ord(s[j]));
      end;
      p.modpow(e,n); {encryption step}
      temps:=p.converttodecimalstring(false);
      {pad out to constant output blocksize}
      while length(temps)<outblock do temps:='0'+temps;
      result:=result + temps;
      inc(start,blocksize);   {move to mext block}
    end;
  end;
end;

{************ Decrypt *************8}
function TForm1.Decrypt(const s:string; actor:TKeyObj{n,d:Tinteger}):string;
var
  k:integer;
  p:TKeyInt;
  q:TInteger;
  estring,dstring:string;
  ch:int64;
  t256:TInteger;
begin
  {recode the string blocksize bytes at a time}
  result:='';
  p:=TKeyInt.create;
  q:=TKeyInt.create;
  t256:=TInteger.create;
  t256.Assign(256);
  estring:=s;
  dstring:='';
  with actor do
  begin
    k:=n.digitcount;
    while length(estring)>0 do
    begin
      p.assign(copy(estring,1,k{-1}));
      p.modpow(d,n);
      while p.ispositive do
      begin
        p.dividerem(T256,q);
        q.converttoInt64(ch);
        dstring:=char(ch)+dstring;
      end;
      result:=result+dstring;
      dstring:='';
      delete(estring,1,k);
    end;
  end;
end;

{************ AliceRecodeBtnClick *************}
procedure TForm1.AliceRecodeBtnClick(Sender: TObject);
begin
  screen.Cursor:=crhourglass;
  case Alicerecodebtn.tag of
    1:  {We are encryptong a message to send to Bob}
      aliceencryptedmemo.text:=
        encrypt(AlicePlaintextMemo.text,bob);
    2:  {We are decrypting a message to us from Bob}
      AliceEncryptedmemo.text:=decrypt(AlicePlainTextMemo.text,alice);
  end;
  screen.Cursor:=crdefault;
end;

{************ BobRecodeBtnClick **********}
procedure TForm1.BobRecodeBtnClick(Sender: TObject);
begin
  (*
  with alice do
  begin
    n.assign(17113);
    d.assign(4895);
    e.assign(4175);
  end;
  *)
  screen.Cursor:=crhourglass;
  case Bobrecodebtn.tag of
    1:  {We are encrypting a message to send to Alice}
      begin
        bobencryptedmemo.text:=encrypt(BobPlaintextMemo.text,alice);
      end;
    2: {We are decrypting a message to us from Alice}
      BobEncryptedmemo.text:=decrypt(BobplainTextMemo.text, Bob);
  end;
  screen.Cursor:=crdefault;
end;

{************* AliceSendBtnClick **********}
procedure TForm1.AliceSendBtnClick(Sender: TObject);
begin
  label1.Caption:='Encrypted message from Alice';
   Bobplaintextmemo.text:= Aliceencryptedmemo.text;
  BobRecodeBtn.caption:='Decrypt message from Alice (w/ my private key)';
  Bobrecodebtn.tag:=2;
  Bobsendbtn.Enabled:=false;
  BobEncryptedmemo.clear;
  GoBobLbl.visible:=true;
  goboblbl.update;
  sleep(1000);
  GoBobLbl.visible:=false;
  pagecontrol1.activepage:=BobSheet;
  //Bobsendbtn.Enabled:=true;
end;

{************* BobSendBtnClick **********}
procedure TForm1.BobSendBtnClick(Sender: TObject);
begin
  label2.Caption:='Encrypted message from Bob';
   Aliceplaintextmemo.text:= Bobencryptedmemo.text;
  AliceRecodeBtn.caption:='Decrypt message from Bob (w/ my private key)';
  Alicerecodebtn.tag:=2;
  Alicesendbtn.Enabled:=false;
  AliceEncryptedMemo.clear;
  GoAliceLbl.visible:=true;
  goalicelbl.Update;
  sleep(1000);
  GoAliceLbl.visible:=false;
  pagecontrol1.activepage:=AliceSheet;
end;


{************* BobPlaintextMemoKeyDown ***************}
procedure TForm1.BobPlainTextMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   { Reset BobplainTextMemo }
  BobRecodeBtn.tag:=1;
  BobrecodeBtn.caption:='Encrypt message using Alice''s public key';
  BobSendbtn.Enabled:=true;
  label1.caption:='Plain text message for Alice';
end;

{**************** MemoKeyDown ***********8}
procedure TForm1.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if sender = AlicePlaintextmemo then
  begin
    AliceRecodeBtn.tag:=1;
    AlicerecodeBtn.caption:='Encrypt message using Bob''s public key';
    AliceSendbtn.Enabled:=true;
    label2.Caption:='Plain text message for Bob';
    AliceEncryptedmemo.clear;
  end
  else
  begin
    BobRecodeBtn.tag:=1;
    BobrecodeBtn.caption:='Encrypt message using Alice''s public key';
    BobSendbtn.Enabled:=true;
    label1.caption:='Plain text message for Alice';
    BobEncryptedmemo.Clear;
  end;
end;

function breakstring(s:string; linelength:integer):string;
   {break long strings by inserting linefeed characters every "linelength" characters}
   var i:integer;
   begin
     result:='';
     for i:=0 to length(s) div linelength do
     result:=result+copy(s,i*linelength+1,linelength)+#13;
     delete(result,length(result),1); {delete the final Linefeed}
   end;

{************* AliceShowBtnClick ***********}
procedure TForm1.AlicePrivateBtnClick(Sender: TObject);
begin
  showmessage('Alice private key' + #13 + '<'
   + alice.n.converttodecimalstring(false) +', '
   + alice.d.converttodecimalstring(false) +'>');
end;

{*********** BobPrivateBtnClick **********}
procedure TForm1.PrivateBtnClick(Sender: TObject);
var
  nstr,estr:string;
  actor:TKeyobj;
begin
  if sender=AlicePrivateBtn then actor:=Alice else actor:=Bob;
  with actor do
  begin
    nstr:= breakstring(n.converttodecimalstring(false),100);
    estr:= breakstring(d.converttodecimalstring(false),100);
    showmessage(ID+' private key' + #13 + '<'    + nstr +', '+ estr +'>');
  end;
end;

{********** ClearBtnClick *************}
procedure TForm1.ClearBtnClick(Sender: TObject);
var
  key:word;
  memo:TMemo;
begin
  key:=ord('A');
  If Sender = AliceSampleBtn
  then memo:=AlicePlaintextMemo
  else memo:=BobPlainTextmemo;
  memo.clear;  {New message button}
  MemoKeyDown(memo, Key, []);
end;

{*********** SampleBtnClick ********}
procedure TForm1.SampleBtnClick(Sender: TObject);
  var
  key:word;
  memo:TMemo;
begin
  key:=ord('A');
  If Sender = AliceSampleBtn then
  begin
    AlicePlaintextMemo.text:=InitialMsgA.Text;
    memo:=AlicePlaintextMemo
  end
  else
  begin
    BobPlaintextMemo.text:=InitialMsgB.Text;
    memo:=BobPlainTextmemo;
  end;
  MemoKeyDown(memo, Key, []);
end;

(*
{************ BobClearBtnClick ***********}
procedure TForm1.BobClearBtnClick(Sender: TObject);
var
  key:word;
begin
  key:=ord('A');
  BobPlainTextMemoKeyDown(Sender,key,[]);
  Bobplaintextmemo.clear;
end;
*)
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




end.


