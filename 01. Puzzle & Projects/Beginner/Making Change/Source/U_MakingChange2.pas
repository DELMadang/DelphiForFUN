unit U_MakingChange2;

 {Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Dollar bill change making program #2 with:
    -- User selectable coin values and amount to change.
    -- Solves 2 additional change making problems.
    -- Uses Listview instead of Listbox to display results
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI;

type
  TCoinrec = record
     val, nbr:integer; {coins values and how many}
  end;

  TCoins = array of TCoinRec;

  Tsolution= array of integer;

  TForm1 = class(TForm)
    MakeChangeBtn: TButton;
    AmtUD: TUpDown;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    ListView1: TListView;
    MinCountBtn: TButton;
    MaxValBtn: TButton;
    StopBtn: TButton;
    StaticText1: TStaticText;
    procedure MakeChangeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MinCountBtnClick(Sender: TObject);
    procedure MaxValBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    coins:TCoins;  {array of current coin values and counts}

    count:integer;  {count of solutions found}
    loopcount:integer;
    amount:integer; {amount to be changed}
    mode:integer; {mode: 1 = MakeChange btn pressed,
                         2 = Min nbr of coins button pressed
                         3 = Min values set button pressed}
    solutionfound:boolean; {modes 2 and 3 stop at first solution}
    showsolutions:boolean; {mode 1 shows solutions
                            mode 3 calls Accumtotsfrom as mode 1 first, but
                                   doesn't want solutions displayed}

    coincounts:array of integer;
    savedcoins:array of Tcoins;  {array of saved solutions for minimum set size problem}
    nbrsolutions:integer;    {mode 3 uses solutions saved in solutions array}
    solutions:array of TSolution;

    procedure FindSolutions;
    procedure AccumTotsFrom(n,totsofar:integer);
    procedure AccumTotsDownto(n,totsofar:integer);
  end;

var Form1: TForm1;

implementation
 {$R *.DFM}

 {****************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var  i:integer;
begin
  for i:=0 to 5 do listview1.columns[i].alignment:=taRightJustify;
end;


{***************** FindSolutions ***************}
procedure TForm1.findsolutions;
{common procedure to initialize solution search and make initial call to
 recursive procedure AccumTotsFrom}
var  i:integer;
begin
  setlength(coins,6);
  coins[0].val:=100; coins[1].val:=50; coins[2].val:=25;
  coins[3].val:=10; coins[4].val:=5; coins[5].val:=1;
  listview1.items.clear;
  for i:=low(coins) to high(coins) do coins[i].nbr:=0;
  {fixup amount to make change for}
  amount:=strtointdef(edit1.text, 100);
  if amount>amtUD.max then amount:=amtud.max;
  edit1.text:=inttostr(amount);
  solutionfound:=false;
  setlength(coincounts,amount+1);
  setlength(SavedCoins,amount+1,6);
  for i:=0 to amount do coincounts[i]:=0;
  nbrsolutions:=0;
  loopcount:=0;
  count:=0;
  screen.cursor:=crhourglass;

  accumtotsfrom(0,0);
  screen.cursor:=crdefault;
end;


  procedure TForm1.AccumTotsFrom(n,totsofar:integer);
    {recursive change making routine}

    { For all allowable values for the nth coin, compute the
      total of coins so far, including this coin and make
      recursive call to ourselves for the next coin.

      If the total exceeds amount, we might as well stop adding coins
      of this value.

      When values has been assigned for all coins, see if the amount matches
      the desired amount. If so add the coin count info to a listview list}

    var   i:integer;
          nexttot:integer;
          tot:integer;
    begin
      If n<=high(coins) then
      begin
        application.processmessages; {allow interrupts }
        for i:= 0 to amount div coins[n].val do {vary # coins from 0 to feasible max}
        begin
          coins[n].nbr:=i;
          nexttot:=totsofar+ i*coins[n].val;
          if (nexttot>amount) then break;{stop checking if we get more than amount}
          accumtotsfrom(n+1,nexttot); {recursive call with next coin}
        end;
      end
      else { values have been assigned for each coin, check the total}
      case mode of
        1:if totsofar=Amount then  {yup, this is the correct change}
          begin
            inc(count);
            if showsolutions then
            with listview1.items.add do  {add info the listview}
            begin
              caption:=format('%4d  ',[count]); {solution number in column 1}
              for i:= low(coins) to high(coins) do{coin counts in rest of columns}
                subitems.add(format('%4d  ',[coins[i].nbr]));
            end
            else
            begin
              if nbrsolutions>high(solutions)
              then setlength(solutions,length(solutions)+50,length(coins));
              for i:= low(coins) to high(coins)
              do solutions[nbrsolutions,i]:=coins[i].nbr;
              inc(nbrsolutions);
            end;
          end;

        2: If totsofar=amount then
           begin
             tot:=coins[low(coins)].nbr;
             for i:=low(coins)+1 to high(coins) do tot:=tot+coins[i].nbr;
             inc(coincounts[tot]);
             for i:=low(coins) to high(coins) do
             savedcoins[tot,i]:=coins[i]; {save latest example of coin set of this size which will make change}
           end;
      end; {case}
    end;

  {******************** AccumTotsDown **************}
  procedure TForm1.AccumTotsDownto(n,totsofar:integer);
  {Recursive procedure used by MaxValbtn, similar to
   AccumTotsFrom except sets are generated from max value
   down towards 0.   And it stops when a set is found with
   no subsets which could make change.
   }

    var   i,j:integer;
          nexttot:integer;
          issubset:boolean;
    begin
      if tag<>0 then exit;
      inc(loopcount);
      if solutionfound then exit;
      If n<=high(coins) then
      begin
        if loopcount mod 1024=0 then application.processmessages; {allow interrupts }
        for i:= amount div coins[n].val downto 0 do {vary # coins from 0 to feasible max}
        begin
          nexttot:=totsofar+ i*coins[n].val;
          coins[n].nbr:=i;
          accumtotsdownto(n+1,nexttot); {recursive call with next coin}
        end;
        coins[n].nbr:=0; {reset this coin count back to zero before exiting}
      end
      else { values have been assigned for each coin, check the total}
           {if  no subset of this collection can make change, then this
            is the solution}
      begin
        issubset:=true;
        for i:= 0 to nbrsolutions-1 do {check previously generated solutions}
        begin
          issubset:=true;
          for j:=low(coins) to high(coins) do
          if coins[j].nbr<solutions[i,j] then
          begin
            issubset:=false; {we found a nbr of coins in this solution which
                              exceed the number in the test set, so it's not
                              a subset}
            break;
          end;
          if issubset then break; {any solution as a subset is enough to stop checking}
        end;
        if not issubset then {we got through all of the chnage making solutions
                              and didn't find any which is a subset of this test
                              set, so it's the solution!}
        begin
          solutionfound:=true; {set flag to stop the recursions}
          inc(count);
          with listview1.items.add do  {add info the listview}
          begin
            caption:=format('%4d  ',[count]); {solution number in column 1}
            for i:= low(coins) to high(coins) do{coin counts in rest of columns}
            begin
              subitems.add(format('%4d  ',[coins[i].nbr]));
              solutions[0,i]:=coins[i].nbr;
            end;
          end;
        end;
      end;
    end;




{*************** MakeChangeBtnCLick ************}
procedure TForm1.MakeChangeBtnClick(Sender: TObject);
begin
  mode:=1;
  showsolutions:=true;
  findsolutions;
end;



{*************** MinCOuntBtnClick *************}
procedure TForm1.MinCountBtnClick(Sender: TObject);
var  i,j:integer;
begin
  mode:=2;
  findsolutions;
  for i:= 1 to amount do
  begin
    if coincounts[i]=0 then
    begin
      showmessage('The smallest set of coins that cannot make change for '+inttostr(amount)
                  + ' cents, in any combination contains '+inttostr(i) +' coins'
                  +#13+'In other words, for every number between 1 and '+inttostr(i-1)
                  + ' there is at least one set of coins of that size which will make change for '
                  +inttostr(amount) +' cents.  Typical examples are shown in the table above.');
      break;
    end
    else
    {begin}
      with listview1.items.add do  {add info the listview}
      begin
        caption:=format('%4d  ',[i]); {solution number in column 1}
        for j:= low(savedcoins[i]) to high(savedcoins[i]) do{coin counts in rest of columns}
                subitems.add(format('%4d  ',[savedCoins[i][j].nbr]));
      end;
  end;
end;

procedure TForm1.MaxValBtnClick(Sender: TObject);
{this one is the most complex - we need to find the set of coins largest value
 with the property that no subset  of coins can make the required change.
 We'll change a couple things to figure this - first we'll simulate the MakeChange
 button, but instead of displaying solutuions, we'll put them in a "solutions"
 array for later checking.  Seconds, we use a modified version of AccumtotsFrom,
 (AccumTotsDownto), which test sets of coins in decreasing value order, ie from max
 number of coins of a values down to 0.   the for each combination generated, we'll
 test whether any subset could make change.  the first one that we find is the
 solution}


var  i:integer;
     tot:integer;
     validcoins:boolean;
begin

  mode:=1;
  showsolutions:=false;
  findsolutions;
  validcoins:=true;
  for i:=low(coins) to high(coins) do
  begin
    if amount mod  coins[i].val <>0
    then validcoins:=false;
  end;
  if validcoins then
  begin
    screen.cursor:=crhourglass;
    count:=0;
    loopcount:=0;
    tag:=0; {let accumtotsdown be interrupted}
    stopbtn.visible:=true;
    accumtotsdownto(0,0);
    screen.cursor:=crdefault;
    if tag=0 then
    begin
      tot:=coins[0].val*solutions[0,0];
      for i:=1 to high(coins) do with coins[i] do tot:=tot+val*solutions[0,i];
      showmessage('The value of the set of coins shown above is '
                +inttostr(tot)+' cents, which is the largest value '
              + 'of any set which will not make change for '+inttostr(amount)+' cents');
    end;
    stopbtn.visible:=false;
  end
  else
  showmessage('All coins must divide the amount to be changed evenly for this'
             +' problem to be solved.  (Otherwise you can select any number of the'
             +' coin that doesn''t divide the amount.)');
end;

{**************** StopBtnClick **************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin     tag:=1;  end;  {set stop flag}

{***************** FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Usr hit Close icon - set stop flag incase we're running a se}
begin  tag:=1; end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
