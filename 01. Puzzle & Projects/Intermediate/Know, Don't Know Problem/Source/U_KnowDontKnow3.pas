unit U_KnowDontKnow3;
{Copyright © 2002, 2007,  2013 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Two integers, A and B, each between 2 and 100 inclusive, have been chosen.
 The product, AB, is given to mathematician Dr. P.  The sum, A+B, is given to
 mathematician Dr. S. They each know the range of numbers.  Their
 conversation is as follows:

 P: "I don't have the foggiest idea what your sum is, S."
             Not quite true, since he knows that S's sum is made up
             of terms from the two term factorizations of his product.
             So he knows that the solution must be one of these.

 S: "That's no news to me, P. I already knew that you didn't know. I don't know either."
            This means that the sum is not expressible as the sum
            of two primes or that would be the only representation
            of the numbers as the product of two integers.

 P: "Aha, Now I know what your sum must be, S!"
            Now P also knows that the sum cannot be represented as
            the sum of two primes. After he eliminates those, he
            must be left with only one choice.

 S: "And likewise P, I have figured out your product!!"
           S has a tougher job, but he knows that P's product is one of the
           products of all valid ways that his sum can be split into two parts.
           So he can play the same game a P did in the previous step except
           he has to do it with each potential product since he cannot be sure
           which is the real product beforehand.  It turns out that doing so
           eliminates all potential solutions except one, although I am
           convinced that it was coincudentally, not mathamatically guaranteed.


 What are the numbers?

 References:
    http://mathforum.org/library/drmath/view/55655.html
    http://www.mathematik.uni-bielefeld.de/~sillke/PUZZLES/logic_sum_product
 }

 {Version 2.0 - allows a max other than 100 to be specified.  Multiple solutions
  exist for higher max values unless additional constraints are added}
{Investigate this claim
    Hi, I was looking at your page about the know, don't know problem. I haven't
    looked at the program but think your reasoning about the problem may be
    flawed. In particular I don't think increasing the upper limit to 500
    should give an extra answer of (4, 61).

I think the flaw in your reasoning is when you think about primes. Unique
factorisation in this problem is not so much about primes as it is about
unique factorisation within the list we are given. So (in the original problem,
with limit of 100) something like the number 354 is not the product of 2 primes
(6 * 59), but it is uniquely factorisable, as other factorisations (2 * 177 or
3 * 118) do not meet the criteria for the upper limit.

Specifically for your example of the upper limit of 500, you claim that 2*437
is another factorisation of 874 whose sum is on sumlist1. However 439 as a sum
is not on sumlist1 -  because 50*389 is the unique factorisation of 19450,
116*323 is the unique factorisation of 37468, 86*353 is the unique factorisation
of 30358, etc etc etc.

Hope this explains where the bug in your program lies.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellAPI, DFFUtils;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    SearchBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    IntroMemo: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    MaxNum: TEdit;
    MaxNumUD: TUpDown;
    Label3: TLabel;
    StaticText1: TStaticText;
    Label4: TLabel;
    TabSheet4: TTabSheet;
    Memo1: TMemo;
    TabSheet5: TTabSheet;
    Edit1: TEdit;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    NextBtn: TButton;
    Say: TMemo;
    Label7: TLabel;
    SPad: TMemo;
    PPad: TMemo;
    Label9: TLabel;
    Label8: TLabel;
    Memo3: TMemo;
    procedure SearchBtnClick(Sender: TObject);
    procedure MaxNumChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    //procedure Button2Click(Sender: TObject);
    public
      solutionfound:boolean;
  end;

var  Form1: TForm1;

implementation

{$R *.DFM}

uses Mathslib;

const
  lownum=2;
  maxhighnum=1000;

var
  highnum:integer=100;
                                           

Type
  tsumrec=record
    sumcount,A,B:integer;
    testProd:integer;
    TopThree:array[1..3] of string;
  end;



{************ FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  pagecontrol1.activepage:=tabsheet1; {Ensure that we start with the Introduction page}
  reformatmemo(Intromemo);
  reformatMemo(Memo2);
end;

{************ SearchBtnClick *************}
{Note: Finding all solutions when neither sum nor product is know is a slightly
different problem than the one the Professors faced.  We will have to search
all valid  solution pairs in the given range to find sums and products which
meet the conditions.}

procedure TForm1.SearchBtnClick(Sender: TObject);
var
  TestA,TestB,aa,bb,i,j:integer;
  sum,prod,factor:integer;
  fcount:integer;
  OK:boolean;
  SumList1:array of boolean; //array[lownum+lownum..maxhighnum+maxhighnum] of boolean;
  SumList2:array of TSumrec; //[lownum+lownum..maxhighnum+maxhighnum] of TsumRec;
  msg:string;
begin
  listbox1.clear; listbox2.clear; listbox3.clear;
  screen.cursor:=crhourglass;
  setlength(sumlist1, 2*(highnum)+1);
  setlength(sumlist2, 2*(highnum)+1);
  for i:= lownum+lownum to highnum+highnum do
  begin
    SumList1[i]:=false;
    SumList2[i].sumcount:=0;
  end;
  {Filter all possible solution pairs based on given range}
  for TestA:= lownum to highnum do for TestB:=TestA to highnum do
  {no need to check both orders of A & B, so we'll keep TestB >= TestA}
  begin
    sum:=TestA+TestB;
    prod:=TestA*TestB;
    {Observation 1: product can't be product of 2 primes, otherwise Dr. P would know the numbers}
    primes.getfactors(prod);
    if primes.nbrfactors<>2 then {Filter from observation 1}
    with primes do
    begin
      {Observation 2: Cannot be the cube of a prime otherwise there would only be one
               choice for the two numbers and Dr. P would have figured that out.}
      if (nbrfactors=3) and (factors[1]=factors[3])
      then break; {Filter from observation 2}

      {Observation 3:  Must not be able to form A+B as the sum of two primes,
                      otherwise Dr. S could not have been sure in advance that
                      Dr. P did not know the numbers.}
      {Filter from Observation 3}
      ok:=true;
      for i:=lownum to sum div lownum do
      begin
        If (isprime(i) and isprime(sum-i)) {or (sum-i> )}  then
        begin
          ok:=false;
          break;
        end;
      end;
      {Action #1 Make a list of candidate sums}
      If OK then  {This A,B pair passed all filters so save the info in SumList1}
      begin       {We'll index the list by sum to simplify checking}
        If not sumlist1[sum] then
        begin
          listbox2.items.add(format('%d + %d = %d', [TestA, TestB, sum])); {show allowable sums}
          listbox2.update;
        end;
        SumList1[sum]:=true;
      end;
    end;
  end;


  {For every possible A and B in the range}
  for TestA:= lownum to highnum-1 do for TestB:=TestA to highnum do
  begin
    sum:=TestA+TestB;
    If SumList1[Sum] then  {it is not the product of 2 primes or the cube of a prime}
    begin
      {Observation 4: Since Dr. P says that he knows the numbers, there
         must be only one factorization of his product into two numbers whose
         sum is in the SumList1 candidate list.}
      prod:=TestA*TestB;
      fcount:=0;
      aa:=0; bb:=0;
      {now check every pair of integers that could produce Dr P's product and
      see if the sum of these two is in Sumlist1 only one time}
      for i:=lownum to  trunc(sqrt(prod)) do {check sum of factorizations}
      begin
        factor:=prod div i;
        sum:=i+factor;
        if (sum<=highnum) and (i*factor=prod) and (SumList1[sum])
        then
        begin
          inc(fcount);
          {just in case this is a solution}
          aa:=i;
          bb:=factor;
        end;
        {Might as well speed things up a little, once count of factorizations
         exceeds one, it's not unique and cannot be the solution}
        if fcount>1 then break;
      end;
      {Action 2:  Make a second list of solution sum records containing A,B and
       a count of how many possible solutions have this sum}
      if fcount =1 then
      with SumList2[aa+bb] do
      begin
        {Count occurrences of Dr. P choices and save the A,B values in case it is
         a unique solution}
        inc(sumcount);
        A:=aa;
        B:=bb;
        if sumcount<=3 then
        Topthree[sumcount]:=format('%d + %d',[A,B]);
      end;
    end;
  end;
  {Display SumList2}
  for i:= lownum+lownum to highnum+highnum do
  with sumlist2[i] do
  if sumcount>0 then
  with listbox3.items do
  begin
    if sumcount>3 then msg:='First 3 are:' else msg:='They are:';
    add(format('Sum: %d  Count: %d: %s',[i,sumcount,msg]));
    for j:= 1 to sumcount do
    begin
      add(TopThree[j]);
      if j>=3 then break;
    end;
    listbox3.update;
  end;

  {Action 3: The sums that pass the previous tests had better only occur one
             time, otherwise Dr. S  could not say that he knows the number also}

  //for i:=low(Sumlist2) to high(sumlist2)do
    {For debugging, index value in "For" loop may not reflect current expected
     value.  Above stement replaced by "While" loop and manually incrementing
     the index}
  i:=low(sumlist2);
  while i<=high(sumlist2) do
  with SumList2[i] do
  begin
    if sumcount=1
    then listbox1.items.add(
                  format('A=%3d, B=%3d, Sum=%3d, Product=%3d',
                  [a,b,a+b,a*b]));
    inc(i);
  end;
  screen.cursor:=crdefault;
end;

{******** MaxNumChange **********}
procedure TForm1.MaxNumChange(Sender: TObject);
begin
   highnum:=maxnumUD.position
end;

var
  SumList:array of TSumrec;
  sumlistcount:integer;
  sum,prod:integer;
  valid:boolean;

{**************** NextBtnClick ***********}
procedure TForm1.NextBtnClick(Sender: TObject);
var
  TestA,TestB:integer;
  i,j,k:integer;
  OK:boolean;
  testsum, testprod, pcount, testdiv:integer;
  Prodrec:TSumrec;
  msg:string;
  Phase:integer;
  {test,} mysum:integer;
  testsuma, testsumb:integer;
  solA, solB, TotOneChoice:integer;
  PadStart:integer;

    {------------ Initial_S_Analysis ---------}
    procedure Initial_S_Analysis;
    var
      i,j, TestA,TestB:integer;
    begin
      with primes do
      begin
        sum:=strtoint(edit1.text);
        if sum=4 then Say.lines.add('S says: "I know the solution already! (2, 2)"')
        else
        begin
          with SPad.lines  do
          begin
            add('******************************************');
            add('* Stage 0:  Waiting for P to speak       *');
            add('******************************************');
            add(format('I don''t know the solution for my sum %d',[sum]));
            add('But I do know that all of P''s possible products are included in my possible sums, namely:');
            for i:= 1 to sum div 2 do
              add(format('%d  = %d + %d (Product = %d)',[sum, i, sum-i, i*(sum-i)]));
          end;
          scrolltotop(Spad);
        end;
      end;
      if not solutionfound then
      with spad.lines do
      begin  {S is going to make sure that he could not know P's product in advance
              and that there is no unique factorizations of any of the possible
              two term possible products based on his sum}
        add('');
        add('I''ll check possible products based on my sum ('+Inttostr(sum)
                 +') to see if any have only one two-term factorization.' );
        setlength(SumList, sum div 2+3);
        sumlistcount:=0;
        valid:=true;
        screen.cursor:=crHourGlass;

        {Filter all possible solution pairs based on given range}
        for TestA:= 2 to sum div 2 do
        {no need to check both orders of A & B, so we'll keep TestB >= TestA}
        begin
          TestB:=sum-TestA;
          testprod:=TestA*TestB;

          {Observation 1: product can't be product of 2 primes, otherwise Dr. P would know the numbers}
          primes.getfactors(testprod);
          if primes.nbrfactors<>2 then {Filter from observation 1}
          with primes do
          begin
            {Observation 2: Cannot be the cube of a prime otherwise there would only be one
                     choice for the two numbers and Dr. P would have figured that out.}
            if (nbrfactors=3) and (factors[1]=factors[3])
            then break; {Filter from observation 2}

            {Observation 3:  Must not be able to form A+B as the sum of two primes,
                            otherwise Dr. S could not have been sure in advance that
                            Dr. P did not know the numbers.}
            {Filter from Observation 3}
            ok:=true;
            for i:=lownum to sum div lownum do
            begin
              If (isprime(i)) and (isprime(sum-i)) then
              begin
                ok:=false;
                break;
              end;
            end;
            {Action #1 Make a list of candidate sums}
            If OK then  {This A,B pair passed all filters so save the info in SumList1}
            begin       {We'll index the list by sum to simplify checking}

              with prodrec, primes do
              begin
                A:=Testa;
                B:=testB;
                TestProd:=a*B;

                {Can Testprod be expressed as the product of two numbers is more than one way?}
                getdivisors(testprod);
                pcount:=0;
                OK:=true;
                msg:='';
                for j:=1 to nbrdivisors do
                begin
                  testdiv:=testprod div divisors[j];
                  if (divisors[j]>1) and (divisors[j]<=testdiv) and (testdiv<highnum)
                  then
                  begin
                    msg:=msg+format(' = %d x %d',[divisors[j],testdiv]);
                    inc(pcount);
                  end
                end;
                if pcount>=2 then
                begin
                   msg:=msg + ' Not unique';
                end
                else
                begin
                  msg:=msg+ ' Unique';
                  OK:=false;
                end;
                Spad.lines.add(format('%d * %d = %d %s', [TestA, TestB, Testprod, msg]));
              end;
              if not OK then valid:=false;
              SumList[sumlistcount]:=Prodrec;
              inc(sumlistcount);
            end;
          end;
        end;
      end;
      setlength(SumList,sumlistcount);
      nextbtn.tag:=2;
      nextbtn.caption:='P speaks';
      screen.cursor:=crdefault;
      scrolltotop(spad);
    end;


begin  {NextBtnClick}
  if nextbtn.tag=0 then
  begin
    Say.clear;
    SPad.Clear;
    PPad.Clear;
  end;



  case NextBtn.Tag of
  0: {start Solution}
    with primes do
    begin
      with ppad.lines do
      begin
        add('');
        add('*******************************');
        add('*   Stage 1A:  Start analysis  *');
        add('*******************************');
      end;
      Initial_S_Analysis;
      prod:=strtoint(edit2.text);
      SolutionFound:=false;
      {P examines the factors of his product to make sure that there is more  than
       one way to factor it (and therefore he does not know the solution}

      getfactors(Prod);
      if nbrfactors=1 then Say.lines.add(format('S says: "There is no solution for my product %d"',[prod]))
      else
      if (nbrfactors=2) or ((nbrfactors=3) and (factors[3]=factors[1])) then
      begin
        Testa:=factors[1];
        if nbrfactors=2 then Testb:=factors[2]
        else testb:=testa*testa;
        say.lines.add('');
        Say.lines.add(format('P says: "I know the solution already! I am sure that you do too"',[] ));
        PPad.lines.add(format('I know the solution already! (%d, %d)',[Testa, TestB]));
        SolutionFound:=true;
      end
      else
      begin
        primes.getdivisors(prod);
        with primes do
        for i:=2 to nbrdivisors div 2 do
        begin
          TestA:=divisors[i];
          TestB:=prod div divisors[i];
          ppad.lines.add(format('%d = %d x %d (Sum of factors = %d)',[prod,TestA,TestB, TestA+TestB]));
        end;
      end;
      say.lines.add('');
      Say.Lines.add('P says: "I can''t figure out the solution for my product."');
      with PPad.Lines do
      begin
        add(format('I can''t figure out the solution for %d'
                 +' but I know all of the ways that my product can be written as A x B and'
                 +' A + B will be the sum that S is seeing' ,[prod]));
      end;
      nextbtn.caption:='S speaks';
      NextBtn.tag:=1;
    end;

  1:
    Begin
      {S speaks 1}
      If valid
      then
      begin
        say.lines.add('');
        Say.lines.add('S says: "I knew that you did not know the solution, I do not know either"');
        with spad.lines do
        begin
          add('');
          add('****************************************************');
          add('*   Stage 1B:  P said he does not know solution     *');
          add('****************************************************');
          add ('All possible products from my sum can be expressed as two-term products in more than one way'
                                     +' so I knew that P did not know the solution but I don''t know either');
        end;
        nextbtn.caption:='P speaks';
        NextBtn.tag:=2;
      end
      else
      begin
        say.lines.add('');
        Say.lines.add('S says: "No solution - perhaps ''Maximum #'' is not correct ?"');
        nextbtn.Tag:=0;
        nextbtn.caption:='Start solving';
        scrolltotop(spad);
        exit;
      end;
    end;

  2:
    begin
      {Let P do his checking}
      {For every way to factor his product get all two-term factorizations}

      with PPad.lines do
      begin
        ppad.perform(EM_LineScroll,0,ppad.lines.Count);
        padstart:=count;
        add('');
        add('**************************************************');
        add('* Stage 2A: S says he knew that I did not know    *');
        add('**************************************************');
        add('');
        add('I know all of S''s possible sums based on my product and, based on his comment, '
                   +'I can eliminate any that have a unique factorization because if there were, '
                   +'I could have known and he would have known that.' );
        add('');
        add('Check for unique factorizations of possible sums');
      end;
      pcount:=0;
      with primes do
      begin
        getdivisors(prod);
        for i:=1 to nbrdivisors do
        if divisors[i]>1 then
        begin
          TestA:=divisors[i];
          testB:=prod div TestA;
          if (TestA<=TestB) and (TestB<=highnum) then
          begin
            {Can S's sum for this product be formed as sum in
              of two primes, or
             as sum of a prime> highnum/2 and another number?}
            {yes - if prod is odd and prod-2 is prime or prod>=4 and even}
            OK:=true;
            testsum:=TestA+TestB;
            if (testsum mod 2) =1 then
            begin
              if isprime(testsum-2) then
              begin
                OK:=false;
                testsuma:=2;
                testsumb:=testsum-2;
              end;
            end
            else
            with primes do
            begin
              // shortcut for determining sum of 2 primes is possible}
              //if testsum>=4 then  OK:=false;
              {but we'll find the specific example for user's peace of mind}
              for j:= 2 to testsum div 2 do
              begin
                testsuma:=j;
                testsumb:=testsum-testsuma;
                if isprime(testsuma) and isprime(testsumb) then
                begin
                  ok:=false;
                  break;
                end;
              end;
            end;
            if  not OK then msg:=format(' = %d x %d : A prime factorization ==> Not a solution', [testsuma, testsumb])
            else
            begin
              msg:=' : Yes! (S''s sum is '+inttostr(Testa+TestB)+')';
              inc(pcount);
              sola:=testa;
              solb:=testb;
            end;
            PPad.lines.add(format('%d x %d = %d  %s',[TestA,TestB,prod, msg]));
          end;
        end;
      end;
      if pcount=1 then
      begin
        say.lines.add('');
        Say.lines.add(format('P says: "I now know the solution!  Your sum is %d"',[solA, solB]));
        PPad.lines.add(format('I now know the solution is  (%d, %d) and S''s sum is %d ',
                       [solA,solB, SolA+SolB]));
        solutionfound:=true;
      end
      else
      begin
        say.lines.add('');
        Say.lines.add('P says: "Sorry, I can''t figure out the solution"');
        Ppad.lines.add('No solution found');
      end;
      screen.cursor:=crDefault;
      nextbtn.tag:=3;
      nextbtn.Caption:='S speaks';
      ppad.perform(EM_LineScroll,0,-(ppad.lines.Count-padstart-5));
    end;
  3:
    begin
      If solutionfound then
      begin {P knows the answer, so I need figure it out}
        {This is a bit tricky.  If I can find the solution it must meet these conditions:
        1. The sum of the two solution numbers must equal the sum I was given.
        2. It cannot be factored into two primes or the cube of a prime.
           (Otherwise P would have know the solution immediately)
        3. There must be only one way for P to split his product into two sums
           which are not both prime. (Otherwise I would have known immediately
           that P could have possibly known the answer immdediately, but I had
           told him that I had no idea of the product which, in turn, let him
           know that his product had no factorization which whose sum could be
           split into two primes. Of the others (those factorizations whose sum
           could not be split into two primes, there must be only one occurrence
           or else he still would not have known the solution).
        }
        TotOneChoice:=0;
        //spad.Clear;
        spad.perform(EM_LineScroll,0,spad.lines.count);
        padstart:=spad.lines.count;
        with Spad.lines do
        begin
          add('*********************************');
          add('* Stage 2B:  P knows solution    *');
          add('*********************************');
          add('This is a bit tricky.  If I can find the solution it must meet these conditions:');
          add('1. The sum of the two solution numbers must equal the sum I was given.');
          add('2. It cannot be factored into two primes or the cube of a prime. (Otherwise P would have know the solution immediately)');
          add('3. There must be only one way for P to split his product into two sums which are '
            +'not both prime. (Otherwise I would have known immediately that P could have possibly '
            +'known the answer immdediately, but I had told him that I had no idea of the product which, '
            +'in turn, let him know that his product had no factorization which whose sum could be '
            +'split into two primes. Of the others (those factorizations whose sum could not be split '
            +'into two primes, there must be only one occurrence or else he still would not have known the solution).');
             add('');
          add('Check 2 term sums of possible product solutions (those that sum to '+inttostr(sum)+'). '
            +'For a particular possible solution, if there is only one sum of terms which cannot be factored into two terms, '
            +'that must be the solution!');
        end;
        with primes do
        for i:=0 to high(SumList) do
        with SumList[i], SPAd.lines do
        begin
          //test:=testProd;
          //mysum:=A+B;
          {check all two term factorizations of test and count if all but "mysum"   can be expressed as sum of two primes}
          getdivisors(testprod);
          add('');
          add(format('Checking if (%d x %d = %d) as possible solution',[A,B,testprod]));
          add(format('That is, %d cannot be expressed the product of as the sum of two prime numbers',[testprod]));
          pcount:=0;
          for j:=2 to nbrdivisors div 2 do
          begin
            TestA:=divisors[j];
            TestB:=testprod div TestA;
            testsum:=TestA+testB;
            if (TestB<=highnum) then
            begin
              {Can S's sum for this product be formed as sum
               of two primes}
              {yes - if prod is odd and prod-2 is prime or prod>=4 and even}
              OK:=false;
              if (testsum mod 2) =1 then
              begin {testsum is odd, 2 is the only other possible prime addend
                     because all other primes are odd and sum of 2 odd #s is even }
                if isprime(testsum-2) then
                begin
                  OK:=true;
                  testsuma:=2;
                  testsumb:=testsum-2;
                end;
              end
              {even # > 4 can be written as sum of 2 primes}
              else if testsum>=4 then
              begin
                for k:= 2 to testsum div 2 do
                begin
                  testsuma:=k;
                  testsumb:=testsum-testsuma;
                  if isprime(testsuma) and isprime(testsumb)
                  then OK:=true; {can eliminate}
                end;
              end;

              if not OK then
              begin
                inc(pcount);
                msg:=format('No sums of factors of %d are prime (Occurrence #%d)', [testsum, pcount]);
              end
              else
              begin  {has prime factor sum, we can exclude this one}
                msg:=format('Can exclude sum of prime factors %d & %d ', [Testsuma, Testsumb]);
              end;
            end;
            add(format('       Checked %d x %d .... %s',[TestA,TestB, msg]));
          end;
          if pcount=1 then
          begin
            inc(totOneChoice);
            solA:=A;
            solB:=B;
            add(format('************ Likely solution! (Only one possible product of (%d,%d) cannot be excluded)',
                         [A,B]));
          end;
        end;
        if totOnechoice=1 then
        begin
          say.lines.add('');
          Say.lines.add(format('S says: "I now know the solution! %d * %d = %d"',[solA,solB, solA*SolB]));
          SPad.lines.add(format('Solution is  %d * %d = %d',[solA,solB, solA*SolB]));
        end;
        //Scrolltotop(Spad);
        SPad.perform(EM_LINESCROLL,0, -(spad.lines.count-padstart-5));
      end
      else with say.lines do
      begin
        add('');
        add('S says: "P didn''t find a solution, so I cannot either."');
      end;
      nextbtn.caption:='Start Solving';
      screen.Cursor:=crdefault;
      nextbtn.Tag:=0;
    End;
  end; {case}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.

