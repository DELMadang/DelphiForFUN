unit U_Counterfeit2;
  {Copyright  © 2003, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
The object of this puzzle is to determine which of a stack of coins is counterfeit based on it's weight,
which will always be different than all the other coins in the stack.

We'll do this by moving coins to (or from) the pans of a balance beam scale.  Coins are moved from
the stack to the left pan by clicking on it with the left mouse button.  Use the right mouse button to move
to the right pan.  Coins may be moved from the pans back to the stack by clicking on them.  A
weighing is recorded each time there are the same number of weights in each pan, so it is good
practice to adjust all of the coins in one pan before adjusting the other.

The objective is to find the counterfeit  coin in the fewest possible number of weighings.  When you
think you know, specify the odd coin by holding down the "Ctrl" key while clicking on it.  In the "heavy or
light" case you will be also asked whether the odd coin is heavy or light.

The stack may contain up to 12 coins.  For 2 to 9 coins, if it is known whether the countertfeit coin is
lighter or heavier than the standard, it can be found in two weighings!  For more than 9, or more than 3
if "light or heavy" is unknown, 3 weighings may be required.  Also for the "light or heavy" case with
more than 3 coins, spare known good coins are provided.  They may be required to for higher coin
counts to find the defective coin in 3 weighings.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Contnrs, ShellApi, U_scale2;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Image1: TImage;
    Label1: TLabel;
    WeighingsLbl: TLabel;
    MinWeighingsLbl: TLabel;
    Protocoin: TStaticText;
    UpDown1: TUpDown;
    CoinCountEdt: TEdit;
    WeightRGrp: TRadioGroup;
    ResetBtn: TButton;
    Button1: TButton;
    RestartBtn: TButton;
    Sparecoin: TStaticText;
    Memo2: TMemo;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    M1Lbl: TLabel;
    M2Lbl: TLabel;
    M3Lbl: TLabel;
    ResultsLbl: TLabel;
    Case1Memo: TMemo;
    Case2Memo: TMemo;
    StaticText1: TStaticText;
    Button2: TButton;
    StaticText2: TStaticText;
    procedure CoinCountEdtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RestartBtnClick(Sender: TObject);
    procedure WeightRGrpClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CoinMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    coins:TObjectList; {master list of coins (TStatictext controls)in this puzzle}

    sparecount:integer;  {coin of spare good coins in coins list}
    scale:TScale;
    minweighings:integer;{the minimum number of moves to find the bad coin in this set}
    resultsviewed:boolean;

    procedure Countweighings(w:integer);
    function makecoin(proto:TStaticText; N,newweight:integer; shownumber:boolean):TStatictext;
    procedure newcounterfeit;
    function checkminmoves:integer;
    procedure checkanswer(source:TStatictext);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses math ;


{******************* CoinCountEdtChange *************}
procedure TForm1.CoinCountEdtChange(Sender: TObject);
{Adjust the number of coins to current count value}
var  i,start:integer;
begin
  {remove any spare good coins}
  for i:=1 to sparecount do
  begin
      scale.removeweight(TStatictext(coins[coins.count-1]),true);
      coins.delete(coins.count-1);
  end;
  sparecount:=0;
  if Updown1.position > coins.count then
  begin
    for i:=coins.count+1 to updown1.position
    do coins.add(makecoin(protocoin,i,2,true));
  end
  else if updown1.position<coins.count then
  begin
    if (weightrgrp.itemindex=2) {unknown if lighter or heavier case}
       and (updown1.position<3) then
       begin
         showmessage('''Lighter or heavier'' case not solvable with just 2 coins, changed to 3');
          updown1.position:=3;
       end;

    start:=coins.count-1;
    for i:=start downto updown1.position do
    begin
      scale.removeweight(TStatictext(coins[i]),true);
      coins.delete(i);
    end;
  end;

  {pad with spare good coins as necessary for heavy or light case}
  If (weightrgrp.itemindex=2) and (coins.count>3)
  then for i:=coins.count+1 to 12 do
  begin
    coins.add(makecoin(sparecoin,i,2,false));
    inc(sparecount);
  end;

  newcounterfeit;
end;


type
  TCoinrec=record  {special coin definition used in CheckMinMoves function}
    nbr,weight:integer;
    key:string;
  end;

{******************** CheckMinMoves *************}
function TForm1.CheckMinMoves:integer;
{calculate the nbr of moves to solve this set of coins}
var
  w, w3, g, suma, sumb, counta, countb :integer;
  i,j:integer;
  wcoins:array of Tcoinrec;
  keys:TStringlist;  {used to build keys for unknow light/heavy case}
  OK:boolean;
  s,s2:string;
  res, leftpan, rightpan, coinword:string; {used to build wighing result messages}


  function ConvertToTrinary(n,size:integer):string;
  {convert n to "size" byte trinary string}
  var j:integer;
  begin
    result:='';
    j:=n;
    while j>0 do
    begin
      result:=inttostr(j mod 3)+result;
      j:=j div 3;
    end;
    {right pad if necessary}
    while length(result)< size do result:='0'+result;
  end;

begin
  setlength(wcoins,coins.count);
  for i:=0 to coins.count-1 do
  with wcoins[i] do
  begin
    nbr:=i+1;
    {tag = 100* weight + coin #, divide by 100 to get weight} 
    weight:=TStatictext(coins[i]).tag div 100;
  end;

    (*
    Martin Gardner's ALGORITHM
      (FROM: http://www.greylabyrinth.com/puzzle/puzzle019 )
    *)
  result:=0;
  If weightRgrp.itemindex=2 then
  begin { If we do not know whether the coin is light or heavy - }
    case1memo.Visible:=false;
    case2memo.Visible:=true;
    statictext2.Visible:=true;
    if coins.count >3 then   {2 weighings Ok for 3 coins, 4-12 need 3
                                   weighings}
    begin
      {number of coins is (3^w-3)/2 for w weighings - in this case
       with max of 12 coins, max of 3 weighings are required and
       number of weights is 2 (for 3 coins) or 3 (for 12 coins)}
      w:=12;
      setlength(wcoins,w);
      for i:=coins.count-sparecount to w-1 do
      with wcoins[i] do
      begin
        nbr:=i+1;
        weight:=2;
      end;
      w:=3;
    end
    else w:=2;

    {Assume that you are allowed W weighings. Write down the 3^W possible length W
    strings of the symbols '0', '1', and '2'}

    keys:=TStringlist.create; {use this list to construct the keys}
    w3:=3; for I:=1 to w-1 do w3:=w3*3;  {compute 3^w}
    for i:= 0 to w3-1 do keys.add(converttotrinary(i,w)); {build all possible keys}

    {Filter to remove some of the entries}
    for i:=keys.count-1 downto 0 do
    begin
      {Eliminate the three strings that consist of only one symbol
      repeated W times.}
      s:=keys[i];
      OK:=false;
      for j:=2 to length(s) do if s[j]<>s[1] then
      begin {two digits were different, so keep it}
        OK:=true;
        break;
      end;
      {
      For each string, find the first symbol that is different from the symbol
      preceeding it. Consider that pair of symbols. If that pair is not 01, 12, or 20,
      cross out that string. In other words, we only allow strings of the forms
      0*01.*, 1*12.*, or 2*20.* ( using ed(1) regular expressions ).
      }
      if ok then
      begin
        OK:=false;
        for j:=2 to length(s) do if s[j]<>s[j-1] then
        begin {the first two digits that were different must be 01, 12 or 20}
          if ((s[j-1]='0') and (s[j]='1'))
            or ((s[j-1]='1') and (s[j]='2'))
            or ((s[j-1]='2') and (s[j]='0'))
          then  OK:=true;
        break;
        end;
      end;
      if not OK then  keys.delete(i); {delete it}
    end;
    {
    You will have (3^W-3)/2 strings left. This is how many coins you can handle in
    W weighings.
    }
    for i:= 0 to high(wcoins) do wcoins[i].key:=keys[i];
    keys.free;
    setlength(wcoins,coins.count-sparecount);

    {
    Perform W weighings as follows:

    For weighing "i", take all the coins that have a 0 in string position I, and weigh
    them against all the coins that have a 2 in string position I.
    }
    s:=''; {to hold the key of the odd coin}
    for i:= 1 to w do
    begin
      leftpan:='';  rightpan:=''; {clear move results strings}
      suma:=0; counta:=0; sumb:=0; countb:=0; {and counters}
      for j:= 0 to high(wcoins) do
      begin
        with wcoins[j] do
        begin
          if key[i]='0' then
          begin
            inc(suma,weight);
            inc(counta);
            leftpan:=leftpan+','+inttostr(j+1);
          end
          else if key[i]='2' then
          begin
            inc(sumb,weight);
            inc(countb);
            rightpan:=rightpan+','+inttostr(j+1);
          end;
        end;
      end;
      {If the side with the 0's in position "i" goes down, write down a 0. If the other
       side goes down, write down a 2. Otherwise, write down a 1.
      }
      {since we didn't necessarily have (3^w-3) div 2 coins, simulate standard
      weight for those "missing coins"}

      {wrong plural form in text bugs me!}
      if abs(counta-countb)=1 then coinword:='coin' else coinword:='coins';

      if counta<countb then
      begin
        suma:=suma+2*(countb-counta);
        leftpan:=leftpan +' + '+inttostr(countb-counta)+' known good '+coinword;
      end
      else
      if counta>countb then
      begin
        sumb:=sumb+2*(counta-countb);
        rightpan:=rightpan + ' + '+inttostr(counta-countb)+' known good '+coinword;
      end;

      if suma>sumb then
      begin
        s:=s+'0';
        res:=' Left pan is heavy';
      end
      else
      if suma=sumb then
      begin
        s:=s+'1';
        res:=' Pans balance';
      end
      else
      begin
        s:=s+'2';
        res:=' Right pan is heavy';
      end;
      delete(leftpan,1,1); delete(rightpan,1,1); {delete leading ","s}
      res:='Left pan '+leftpan+', Right pan '+rightpan + #13+res;
      //with resultsform do
      case i of
        1:m1lbl.caption:='1) '+res;
        2:m2lbl.caption:='2) '+res;
        3:m3lbl.caption:='3} '+res;
      end;
    end;

    {After the W weighings, you have written down an W symbol string. If your string
    matches the string on one of the coins, then that is the odd coin, and it is
    heavy.If none of them match, than change every 2 to a 0 in your string, and
    every 0 to a 2. You will then have a string that matches one of the coins, and
    that coin is lighter than the others.
    }
    s2:=s;
    for i:=1 to length(s2) do if s2[i]='0' then s2[i]:='2'
                              else if s2[i]='2' then s2[i]:='0';
    for i:=0 to high(wcoins) do
    with wcoins[i] do
    begin
      if s=key then {this is the odd coin and it is heavy}
      begin
        resultslbl.caption:='Conclusion: The odd coin is number '
                                   + inttostr(i+1)+' and it is heavy.';
        break
      end
      else if s2=key then  {this is the odd coin and it is light}
      begin
        resultslbl.caption:='Conclusion:  The odd coin is number '
                                  + inttostr(i+1)+' and it is light.';
        break;
      end;
    end;
    result:=w;
  end
  else
  begin {case where we know whether the odd coin is heavy or light}
     case2memo.Visible:=false;
     statictext2.Visible:=false;
     case1memo.Visible:=true;
     w:=coins.count;
     w:=ceil(w/3);
    {If you know the odd coin is heavy (or light), you can handle 3^W coins.
    Given W weighings, there can only be 3^W possible combinations of balances,
    left pan heavy, and right pan heavy.

    The algorithm in this case:

    Divide the coins into three equal groups... A, B, and C. Weigh A against B.
    If a pan sinks, it contains the heavy coin, otherwise, the heavy coin is in
    group C. If your group size is 1, you've found the coin, otherwise recurse on
    the group containing the heavy coin.
    }
    g:=w;
    repeat
      suma:=0; sumb:=0;
      leftpan:=''; rightpan:='';
      for i:=0 to g-1 do
      begin
        suma:=suma+wcoins[i].weight;
        leftpan:=leftpan+','+inttostr(wcoins[i].nbr);
      end;
      for i:=g to 2*g-1 do
      begin
       sumb:=sumb+wcoins[i].weight;
       rightpan:=rightpan+','+inttostr(wcoins[i].nbr);
      end;
      if suma=sumb then {odd coin is in last third}
      begin
         res:='Pans are balanced';
         for i:=0 to g-1 do if 2*g+i<=high(wcoins) then wcoins[i]:=wcoins[2*g+i];
         {if we didn't have a third left, then adjust group size to the number remaining}
         if coins.count-2*g<g  then g:=coins.count-2*g;
      end
      else
      begin
        if suma<sumb then res:='Left pan is light'
        else res:='Left pan is heavy';
        if g>1 then
        If ((weightrgrp.itemindex=0) and (suma<sumb))
        or ((weightrgrp.itemindex=1) and (suma>sumb))
        then  for i:=0 to g-1 do if g+i<=high(wcoins) then wcoins[i]:=wcoins[g+i];
      end;
      if g>1 then g:=ceil(g/3)
      else g:=0;
      inc(result);
      delete(leftpan,1,1); delete(rightpan,1,1); {delete leading ","s}
      res:='Left pan '+leftpan+', Right pan '+rightpan + #13+res;
      //with resultsform do
      case result of
        1:m1lbl.caption:='1) '+res;
        2:m2lbl.caption:='2) '+res;
        3:m3lbl.caption:='3} '+res;
      end;
    until g=0;
    //with resultsform do
    If (weightrgrp.itemindex=0)then
      if (suma<sumb)
      then resultslbl.caption := 'Conclusion: Coin '+inttostr(wcoins[1].nbr)+' is heavy.'
      else resultslbl.caption := 'Conclusion: Coin '+inttostr(wcoins[0].nbr)+' is heavy.'
    else
      if (suma>sumb)
      then resultslbl.caption := 'Conclusion: Coin '+inttostr(wcoins[1].nbr)+' is light.'
      else resultslbl.caption := 'Conclusion: Coin '+inttostr(wcoins[0].nbr)+' is light.'
  end;
end;

{********************** MakeCoin *******************}
function TForm1.makecoin(proto:TStaticText; N,newweight:integer; shownumber:boolean):TStaticText;
{Make new coin # "N"}
begin
  result:=TStatictext.create(proto.owner);
  with result do
  begin
    {name:='C'+inttostr(N);}
    parent:=proto.parent;
    autosize:=false;
    left:=proto.Left;
    top:=proto.top-N*proto.height; {position on top of stack}
    width:=proto.width;
    height:=proto.height;
    If shownumber then caption:='#'+inttostr(N)
    else caption:=proto.caption;
    color:=proto.color;
    borderstyle:=sbsSingle;
    tag:=100*newweight + N;  {Tag= 100* weight + coins #}
    onmousedown:=proto.onmousedown;
    font.size:=8;
  end;
end;

{***************** NewCounterfeit ************}
procedure TForm1.newcounterfeit;
{make a new set of coins and assign one of them as light or heavy}
var i:integer;
begin
  for i:= 0 to coins.count-1 do
  with TStatictext(coins[i]) do
  begin
    tag:=100*2+i+1; {tag = 100 * weight + coin #}
    scale.removeweight(TStatictext(coins[i]),false);
    left:=protocoin.left;
    top:=protocoin.top-i*height;
  end;
  {select a random coin}
  i:=random(coins.count-sparecount)+1;
  with  TStatictext(coins[i-1]) do
  case weightRGrp.itemindex of
    0: tag:=100*3+i; {make it heavy}
    1: tag:=100*1+i; {make it light}
    2: if random(2) >0 then  tag:=100*1+i else tag:=100*3+i; {randomly heavy or light}
  end;
  resultsviewed:=false;
  scale.weighings:=0;
  WeighingsLbl.caption:='Weighings: 0';
  minweighings:=checkminmoves;
  minweighingslbl.caption:='Min Weighings: '+inttostr(minweighings);
end;

{******************** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
{initialize coins and scale}
begin
  coins:=TObjectList.create;
  scale:=TScale.create(tabsheet2);
  scale.setsize(image1.boundsrect);
  scale.oncountweighing:=Countweighings;
  Tabsheet2.doublebuffered:=true;
  randomize;
end;

{***************** ResetBtnClick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  newcounterfeit;
  scale.drawscale(0);
end;

{************ RestartBtnclick *****************}
procedure TForm1.RestartBtnClick(Sender: TObject);
var i:integer;
begin
  for i:= 0 to coins.count-1 do
  with TStatictext(coins[i]) do
  begin  {remove from panlists and move back to coin stack}
    scale.removeweight(TStatictext(coins[i]),false);
    left:=protocoin.left;
    top:=protocoin.top-i*height;
  end;
  resultsviewed:=false;
  scale.weighings:=0;
  WeighingsLbl.caption:='Weighings: 0';
  minweighings:=checkminmoves;
  minweighingslbl.caption:='Min Weighings: '+inttostr(minweighings);
  scale.drawscale(0);
end;


{************* FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
{draw initial scale image}
begin
  pagecontrol1.activepage:=TabSheet1;
  scale.drawscale(0);
  with case2memo do
  begin  {line up explanation memos kept separate for design ease}
    left:=case1memo.Left;
    top:=case1memo.Top;
  end;
end;

{**************** CountWeighings *********}
procedure TForm1.Countweighings(w:integer);
{redisplay weighing count - called by Tscale whenever number of coins in each
 pan becomes equal}
begin
  weighingslbl.caption:='Weighings: '+inttostr(w);
end;


{error and reward messages}
var
  {one of appropriate type randomly selected on each occurrence}
  goodmessagecount:integer=4;
  goodmsgs:array[0..3] of string =
    (
     'Yes!!',
     'Good Job!',
     'Alright!',
     'You did it!'
     );
  OKmessagecount:integer=3;
  OKmsgs:array[0..2] of string =
    (
     'You got it, but you can do better',
     'Well,  I''ll give you a B for that solution!',
     'This scale is very expensive to operate - try for the minimum'
     );
   Oopsmessagecount:integer=3;
   Oopsmsgs:array[0..2] of string =
    (
     'Sorry Charlie.',
     'Ooops! (Try again)',
     'Nope, but never give up!'
     );



{****************** Checkanswer ****************}
procedure TForm1.checkanswer(source:TStatictext);
{Coin dropped on answerbox, check to see if it is the correct one}
var
  n:integer;
  anscorrect:boolean;
  ansstr:string;
  ans:char;
begin
  begin
    n:=coins.indexof(tstatictext(source))+1;
    if (n>0) then
    begin
      anscorrect:=false;
      if (weightrgrp.itemindex<2) and (TStatictext(source).tag div 100<>2) then anscorrect:=true
      else if weightrgrp.itemindex=2 then
      begin

        repeat
          ansstr:=Inputbox(format('Is coin %d heavy or light?',[n]), 'Enter H or L','X');
          ans:=upcase(ansstr[1]);
        until ans in ['H','L'];


        if ((Tstatictext(source).tag div 100 = 1) and (ans='L'))
         or ((Tstatictext(source).tag div 100 = 3) and (ans='H'))
        then anscorrect:=true;
      end;
      if anscorrect then
      begin
        if resultsviewed then
        begin
          showmessage('Correct, but it''s better if you '
                        +  'don''t look at the answer first!');
          resetbtnclick(self); {make a new coin stack}
        end
        else If scale.weighings<minweighings then
        begin
          showmessage('Correct. You''re either lucky or cheated!');
          resetbtnclick(self); {make a new coin stack}
        end
        else
        if scale.weighings=minweighings then
        begin
          showmessage(goodmsgs[random(goodmessagecount)]);
          resetbtnclick(self);  {make new coin stack}
        end
        else
        begin
          showmessage(OKmsgs[random(OKmessagecount)] + #13 +'Try it again');
          restartbtnclick(self); {restack coins}
        end
      end
      else
      begin
        showmessage(Oopsmsgs[random(Oopsmessagecount)]+#13+'Try it again');
        restartbtnclick(self); {restack coins}
      end;
    end
    else showmessage('Progam error, unlikely as that seems.'
                   +#13+'Please inform feedback@delphiforfun.org');
  end;
end;


{************* WeightRGrpClick ***********}
procedure TForm1.WeightRGrpClick(Sender: TObject);
{Check to disallow unsolvable case with 2 coins when heavy or light is unknown}
begin
  If (weightrgrp.itemindex=2 ){light or heavy - need at least 3 coins}
     and (updown1.position=2) then  updown1.position:=3;
  coincountedtchange(sender);
  if coins.count>0 then resetbtnclick(sender);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   pagecontrol1.activepage:=tabsheet3;
   resultsviewed:=true;
end;

{************** CoinMouseDown *************}
procedure TForm1.CoinMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
    n, n2, index:integer;
    remove:boolean;
begin
  if sender is TStatictext then
  with sender as Tstatictext do
  begin
    if ssCtrl in shift then
    begin
      checkanswer(TStatictext(sender));
      exit;
    end;
    remove:=false;
    n:=tag mod 100;
    (* {for debugging}
    n2:=coins.indexof(tstatictext(sender))+1;
    if n<>n2
    then showmessage(format('Index(%d) <> Tag Mod 100 (%d)',[N2,N]));
    *)
    index:=scale.leftweights.indexof(sender);
    if index<0 then  {not on left pan}
    begin
      index:=scale.rightweights.indexof(sender);
      if index<0 then {not on right pan}
      begin {Coin is on the form, move it to the scale}
        if button=mbleft then
        begin
             {Center coin in the left pan}
          left:=scale.left+scale.pan1rect.left+(scale.pan1rect.right-scale.pan1rect.left-width) div 2;

          top:=scale.top+scale.pan1rect.bottom
                -(scale.leftweights.count+1)*height-1;
        end
        else
        begin  {right side}
          left:=scale.left+scale.pan2rect.left+(scale.pan2rect.right-scale.pan2rect.left-width) div 2;
         {place on top of existing stack already on the pan}
         top:=scale.top+scale.pan2rect.bottom
             -(scale.rightweights.count+1)*height-1;
        end;
        bringtofront;
        scale.addweight(TStatictext(sender));
      end
      else remove:=true; {on the right pan, flag for removal}
    end
    else remove:=true; {on the left pan, flag for removal}
    if remove then
    begin
      left:=protocoin.Left;
      n:=(tag mod 100)-1;
      top:=protocoin.top-N*protocoin.height; {position on top of stack}
      scale.removeweight(TStatictext(sender),true);
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  pagecontrol1.activepage:=tabsheet2;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.greylabyrinth.com/puzzle/puzzle019',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
