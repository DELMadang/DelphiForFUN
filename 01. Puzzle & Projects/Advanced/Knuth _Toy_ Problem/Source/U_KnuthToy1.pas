unit U_KnuthToy1;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Spin, UcomboV2, UIntList;

type
  TDigitsObj = class(Tobject)
    d:array of byte;
    //minNbr, maxNbr:int64;  {obsolete, used in original Button 3 exit}
    constructor create(n:integer);
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo5: TMemo;
    Button1: TButton;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Button3: TButton;
    Stopbtn: TButton;
    View3Btn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopbtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure View3BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    powers:array[0..9] of int64;
    n:integer;  {exponent for digits}
    minpower:int64;
    loopcount:int64;
    strRepeat:string;
    starttime:TDatetime;
    solutioncount:integer;
    procedure init(header:string);
    procedure wrapup;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses mathslib;




const powerstr:array[2..15] of string =
('second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth',
         'tenth','eleventh', 'twelvth', 'thirteenth','fourteenth', 'fifteenth');

procedure TForm1.Init(Header:string);
  var
    j:integer;
    combosrep, permutesrep:int64;
  begin
    n:=spinedit1.Value;
    for j:=0 to 9 do powers[j]:=intpower(j,n);
    MinPower:=IntPower(10,N-1) ;   {100 FOR 3 DIGIT, ETC.}
    memo1.clear;
    memo1.lines.add(Header);
    strRepeat:=stringOfChar('x',n-1);
    screen.cursor:=crHourglass;
    stopbtn.visible:=true;
    label2.tag:=0;
    label2.caption:='Total run time  0.0 seconds';
    label2.Update;
    with combos, memo1.lines do
    begin
      setupr(n,10,combinationswithrep);
      combosrep:=getcount;
      setup(n,10,permutationswithrep);
      permutesrep:=getcount;
      add(format('Searching integers whose sum of %s powers of digits equals the number', [powerstr[n]]));
      add(format('There are %.0n %d-tuples and %.0n sums of powers of digits of %d-tuples',
             [0.0+permutesrep,n, 0.0+combosrep,n]));
      add('');
    end;
    view3btn.visible:=false;
    application.processmessages;
    loopcount:=0;
    solutioncount:=0;
    label2.Caption:='0 seconds';
    starttime:=now;
  end;

procedure TForm1.Wrapup;
var
  s:string;
  begin
    if label2.tag>0 then s := ' - Interrupted' else s:='';
    label2.caption:=format('Total run time  %.2f seconds %s',
                  [(now-starttime)*secsperday,s]);
    with memo1.lines do
    begin
      if solutioncount >0 then
      begin
        if solutioncount=1 then add(inttostr(solutioncount)+' solution')
        else add(inttostr(solutioncount)+' solutions');
      end
      else add('No solutions');
    end;
    screen.cursor:=crdefault;
    Stopbtn.visible:=false;
  end;


{******************* Button1 ************8}
procedure TForm1.Button1Click(Sender: TObject);
var
  j:integer;
  testnbr,testsum:int64;
  pwr:int64;
begin
  Init('Button 1');
  with combos do
  begin
    {button1 processing}
     setupr(n,10,permutationsRepeat);
    {processing all permutations with repeats looking for those whose sum of
     powers equals the number represented by that permuation}
    while getnext do
    begin
      pwr:=powers[selected[1]-1];
      if pwr>0 then
      begin
        inc(loopcount);
        if (loopcount and $FFFF)=0
        then
        begin
          label2.caption:=format('%.1f seconds, checking  %d%s',
                  [(now-starttime)*secsperday,selected[1]-1,strRepeat]);
          application.processmessages;
          if label2.tag>0 then break;
        end;
        testsum:=powers[selected[1]-1];
        testnbr:=selected[1]-1;
        for j:= 2 to n do
        begin
          testsum:=testsum+powers[selected[j]-1];
          testnbr:=testnbr*10+(selected[j]-1);
        end;

        if testsum=testnbr then
        with memo1.lines do
        begin
          add(inttostr(testsum));
          add(format('Solution (%d digits): %.0n',[n, 0.0+testnbr]));
          application.processmessages;
          inc(solutioncount);
        end;
      end;
    end;     {while getnext}
  end;
  wrapup;
end;

{**************** Button2Click ***********}
procedure TForm1.Button2Click(Sender: TObject);
var
  testnbr,target:int64;
  test:int64;
  nn:integer;
  s:string;

begin
  Init('Method 2');
  testnbr:=minpower div 10;
  while testnbr<= 10*minpower -1 do
  begin
    inc(testnbr);
    if (testnbr and $FFFFF)=0
    then
    begin
      label2.caption:=format('%.1f seconds, checking %d ',
                [(now-starttime)*secsperday,testnbr]);
      application.processmessages;
      if label2.tag>0 then break;
    end;

    {calculate the sum of powers of digits}
    target:=0;
    test:=testnbr;
    repeat
      target:=target+ powers[test mod 10];
      test:=test div 10;
    until test=0;

    if testnbr=target then
    with memo1.lines do
    begin
      s:=inttostr(testnbr);  {lazy man's way to count the digits}
      nn:=length(s);
      add(format('Solution (%d digits): %.0n',[nn, 0.0+testnbr]));
      application.processmessages;
      inc(solutioncount);
    end;
  end;
  wrapup;
end;


Constructor TDigitsObj.Create(N:integer);
begin
  inherited create;
  setlength(d,n);
end;



(*
{************* Button3Click *************}
{Rejected method - generates combinations rather than permutations
 first to determine which ones contain the same digit value counts as
 its sum and then permutes only those to detemine solution value.
 Replaced by the version that recognizes that if the digit count "sigantue"
 of a number matches the sum digit count signature, then the sum is a solution!
 No need to permute at all!.
 }


procedure TForm1.Button3Click(Sender: TObject);
var
  i,j,index:integer;
  sum, testnbr:int64;
  s:string;
  digitsobj:TDigitsobj;
  sumlist, answerlist:TIntList;
  dd:array of byte;


  procedure sortascending(var dd:array of byte);
  var
    i,j:integer;
    temp:byte;
  begin
    for i:= 0 to high(dd)-1 do
    for j:= i+1 to high(dd) do
    if dd[j]<dd[i] then
    begin
      temp:=dd[i];
      dd[i]:=dd[j];
      dd[j]:=temp;
    end;
  end;


begin
    {button 2 processing}
  Init;
  setlength(dd,n);
  sumlist:=TIntList.create;
  answerlist:=TIntlist.create;
  answerlist.sorted:=true;
  with combos do
  begin
    setupr(n,10,combinationswithrep);
    while getnext do
    begin
      {Try reducing time calculating sums of every permutation by generating the
       combinations with repeats.  The sum of the digits for each combination
       will have the same sum, so we can then permute those digits looking for
       one whose value as a number equal the sum of products}
      if label2.tag>0 then break;
      digitsobj:=TDigitsObj.create(n);
      with digitsobj do
      begin
        s:=inttostr(selected[1]-1);
        sum:=powers[selected[1]-1];
        d[0]:=selected[1]-1;
        dd[0]:=d[0];
        for i:=1 to n-1 do
        begin
          d[i]:=selected[i+1]-1;
          dd[i]:=d[i];
          s:=s+', '+ inttostr(d[i]);
          sum:=sum+powers[d[i]];
        end;
        sortascending(dd);
        for i := 0 to n-1 do
        begin
          minNbr:=minNbr*10+dd[i];
          maxNbr:=maxNbr*10+dd[n-1-i];
        end;
        if (minNbr<=sum) and (maxNbr>=sum)
        then sumlist.addobject(sum, TObject(DigitsObj));
      end;
    end;
    sumlist.sort;

    for i:= 0 to sumlist.count-1 do
    begin
      if label2.tag>0 then break;
      digitsobj:=TDigitsObj(sumlist.objects[i]);
      sum:=sumlist[i];
      with digitsobj do
      begin
        combos.setup(n,n,permutations);
        while getnext do
        begin
          inc(loopcount);
          if (loopcount and $FFFFF)=0
          then
          begin
            label2.caption:=format('%.1f seconds, checking  %d%s',
                [(now-starttime)*secsperday,selected[1]-1,strRepeat]);
            application.processmessages;
            if label2.tag>0 then break;
          end;
          testnbr:=d[selected[1]-1];
          for j:=2 to n do testnbr:=testnbr*10+d[selected[j]-1];
          if (testnbr=sum) and (testnbr>=minpower) and
          (not answerlist.find(testnbr,index)) then
          begin
            memo1.Lines.add('Solution: '+ inttostr(testnbr));
            answerlist.add(testnbr);
          end;
        end;
      end;
    end;
  end;
  sumlist.free;
  answerlist.free;
  if label2.tag>0 then s := ' - Interrupted' else s:='';
  label2.caption:=format('Total run time  %.1f seconds %s',
                [(now-starttime)*secsperday,s]);
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
end;
*)



{************ Button3Click ************}
procedure TForm1.Button3Click(Sender: TObject);
{The best method so far - generate combinations with repeats for numbers
 with N-1 and N digits (where N is the user specified power of the digits).
 for each combination compute the "signature" of the number and of the Power sum"
 of its digits.  The signature is a 10 digit number with each position representing
 the count of the number of occurrences of the digit values 0 through 9. So, for
 example, the signature of 370 is 1001000100.
 The signatures of the power sums are saved in a list and the number signatures saved
 there
 }
var
  i:integer;
  sum,summ, sumcheck:int64;
  testnbr:int64;
  s:string;
  digitsobj:TDigitsobj;
  dd:array of byte;
  digits1,digits2:array of int64;
  ok:boolean;
  nn:integer;
begin
  Init('Method 3');

  setlength(digits1,10);
  setlength(digits2,10);

  with combos do
  begin
    {button 3 processing}

    //for nn:= n-1 to N do {Check numbers with N-1 or N digits}
    for nn:= n-2 to N+1 do
    if nn>1 then
    with combos do
    begin
      setlength(dd,nn);
      minpower:=intpower(10,nn-1);
      setup(nn,10,combinationswithrep);
      while getnext do
      begin
        {The most efficient technique, in this case, we'll generate sums of powers
         of the digits for each combination with repeats of n digits. Then we'll
         make a "signature" for the sum and for each combination and for the sum
         of the powers of the digits.  The signature consists of an array of
         10 bytes representing the count of of each digit "0" though "9" for that
         number.  If the signature of the number matches the signature of the sum,
         we know that there is a permutaion of that combination which matches
         the sum!  Better yet, we know the exact permutation - it is the one
         represented by the digits of the sum!  As a double check we will recompute
         the sum of powers to make sure that there was not a coding error before
         reporting the solution.  This method is orders of magnatude faster than
         either Button1 or Button2 methods}

        digitsobj:=TDigitsObj.create(nn);
        with digitsobj do
        begin
          s:=inttostr(selected[1]-1);
          sum:=powers[selected[1]-1];
          d[0]:=selected[1]-1;
          testnbr:=d[0];
          inc(loopcount);
          if (loopcount and $FFFF)=0
          then
          begin
            label2.caption:=format('%.1f seconds, checking  %d%s',
                [(now-starttime)*secsperday,selected[1]-1,strRepeat]);
            application.processmessages;
            if label2.tag>0 then break;
          end;
          for i:=1 to nn-1 do
          begin
            d[i]:=selected[i+1]-1;
            s:=s+', '+ inttostr(d[i]);
            testnbr:=testnbr*10 + d[i];
            sum:=sum+powers[d[i]];
          end;
          if sum>=minpower then
          begin
            summ:=sum;
            for i:=0 to 9 do
            begin
              digits1[i]:=0;
              digits2[i]:=0;
            end;
            for i:=0 to nn-1 do
            begin
              inc(digits1[summ mod 10]);
              summ:=summ div 10;
              inc(digits2[d[i]]);
            end;
            ok:=true;
            for i:=0 to 9 do
            begin
              if digits1[i]<>digits2[i] then
              begin
                ok:=false;
                break;
              end;
            end;
            if OK {there is a solution buried in this set of digits}
            then
            begin
              {redundant, but we'll double check that this sum is a solution}
              {Extract the digits of sum}
              summ:=sum;
              sumcheck:=0;
              while summ>0 do
              begin
                sumcheck:=sumcheck+ intpower(summ mod 10,n);
                summ:=summ div 10;
              end;
              if sumcheck= sum
              then
              begin
                 memo1.Lines.add(format('Solution (%d digits): %.0n',[nn, 0.0+sum]));
                 inc(solutioncount);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  wrapup;
  View3Btn.Visible:=true;  {Let the use request to see the explanation}
end;

{************* FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin  {Move the Stop button over the other buttons to hide them while solving}
  Stopbtn.left:=button1.left;
  Stopbtn.top:=button1.top;
end;

{********** StopBtnClick *********8}
procedure TForm1.StopbtnClick(Sender: TObject);
begin
  label2.tag:=1; {User request to stop execution}
end;

{************* View3BtnClick *****************}
procedure TForm1.View3BtnClick(Sender: TObject);
begin
  with memo1.Lines do
  begin
    add('');
    add('Button 3 Explanation: The most efficient technique discovered so far and one of those '
       +'rare "Eureka" monments.  In this algorithm, we''ll generate sums of powers '
       +'of the digits for each combination with repeats of n digits. Then we''ll '
       + 'create a "signature" for each combination and for the sum of the powers '
       + ' of the digits.  The signature consists of an array of '
       + '10 bytes representing the count of of each digit "0" though "9" for that '
       + 'number.  If the signature of the number matches the signature of the sum, '
       + 'we know that there is some permutaion of that combination which matches '
       + 'the sum!  Better yet, we know the exact permutation - it is the number '
       + 'represented by the value of the sum!  As a double check we recompute '
       + 'the sum of powers to make sure that there was not a coding error before '
       + 'reporting the solution.  This method is orders of magnatude faster than '
       + 'either Button1 or Button2 methods');
  end;

end;

 procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
