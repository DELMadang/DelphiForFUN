unit U_BigCombos2;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UBigIntsV2, ComCtrls, ExtCtrls, shellAPI;

type
  TIarray=array of integer;
  TSumset=class(TObject)
     sumset:TIArray;
     Sum:Real;
  end;
  TForm1 = class(TForm)
    Memo1: TMemo;
    CCountLbl: TLabel;
    Infomemo: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit3: TEdit;
    UpDown2: TUpDown;
    Label4: TLabel;
    Edit4: TEdit;
    MaxDisplayUD: TUpDown;
    Edit1: TEdit;
    TypeRGrp: TRadioGroup;
    ShowManyBtn: TButton;
    StopBtn: TButton;
    ShowMthBtn: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    PrntBtn: TButton;
    SaveDialog1: TSaveDialog;
    procedure StopBtnClick(Sender: TObject);
    procedure ShowClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure PrntBtnClick(Sender: TObject);
  public
    { Public declarations }
    f:textfile;
    procedure GetCombocount(Const r,n:integer; var ccount:TInteger);
    procedure GetPermuteCount(Const r,n:integer; var pcount:TInteger);
    procedure ShowManyPermutes(sender:TObject);
    procedure ShowManyCombos(sender:TObject);
    procedure ShowMthPermute;
    procedure ShowMthCombo;
    procedure showcount(s:string);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
uses math;

{************ FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsmaximized;
  stopbtn.bringtofront;  {btn left back at design time to keep other buttons visible}
end;

{************* ShowCount *************}
procedure Tform1.showcount(s:string);
{Insert spaces in long number so that it will word wrap in label}
var
  i,w:integer;
  s1,s2, s3:string;
begin
  s3:=s;  {save input for scientific format}
  w:=ccountlbl.width-10;
  s2:='';
  s1:='';
  i:=1;

  with ccountlbl.canvas do
  while length(s)>0 do
  begin
    while (i<=length(s)) and (textwidth(s1)+textwidth(s[i])<w) do
    begin
      s1:=s1+s[i];
      inc(i);
    end;
    s2:=s2+' '+s1; {allow a break at the end of the label caption area}
    s1:='';
    delete(s,1,i-1);
    i:=1;
  end;

  {make scientific format for big numbers}
  i:=length(s3);
  while (i>1) and (s3[i] in ['0'..'9',',']) do dec(i);
  delete(s3,1,i);
  s1:=stringreplace(s3,',','',[rfReplaceAll]);
  If length(s1)>6 then
  begin
    i:=length(s1);
    delete(s1,7, length(s1));
    insert('.',s1,2);
    s2:=s2+#13+'('+s1+' E'+inttostr(i-1)+')';
  end;

  ccountlbl.caption:=s2;
end;

{*******************************************************}
{*************** Permutation routines ******************}
{*******************************************************}

{*************** GetPermuteCount *************}
procedure TForm1.GetPermuteCount(Const r,n:integer; var pcount:TInteger);
var  work:TINteger;
  begin
    with pcount do
    begin
      work:=TInteger.create;
      assign(N);
      factorial;
      work.assign(n-r);
      work.factorial;
      divide(work);
      work.free;
    end;
  end;

{************ GetNextPermutation ************}
function GetNextPermutation(var x:array of integer;n:integer):boolean;


     Function CanInc(p:integer; var newval:integer):boolean;
     {Tests to see if we can increment the integer at p}
     {If there is an integer greater than x[p] that doesn't appear
      to the left, then we can increment x[p] to that
      integer.  Set result to true if newval is a usable value,
      false otherwise}
     var
       i:integer;
     Begin
       if x[p]>=n then result:=false
       else
       Begin
         result:=false;
         newval:=x[p];
         {try all values > x[p] until we find an unused one,
          or run out of numbers}
         while (result=false) and (newval<n) do
         Begin
           inc(newval);
           result:=true;
           for i:= 0 to p-1 do
           if x[i]=newval then Begin result:=false;  break; end;
         end;
       end;
     end;

    var
      j,incpos:integer;
      OK:Boolean;
      newval,r:integer;
    begin
      r:=length(x);
      result:=true;
      Begin
        {find the position to increment starting with rightmost}
        incpos:=r-1;
        ok:=false;
        while (incpos>=0) and (not OK) do
        {If we can increment this position, do it}
        if CanInc(incpos,newval) then Begin x[incpos]:=newval; ok:=true; end
        else dec(incpos);  {otherwise, back-up to previous position}
        {now reset the remainder to the smallest values possible}
        for j:= incpos+1 to r-1 do
        Begin
          x[j]:=0;
          if CanInc(j,newval) then x[j]:=newval
          else result:=false;{showmessage('System error');}
        end;
     end;
  end;

{********** ShowManyPermutes ********}
procedure TForm1.ShowManyPermutes(sender:TObject);
var
  r,n:integer;
  i,j:integer;
  max:int64;
  s:string;
  x:array of integer;
  pcount,work:TInteger;
  begin
    n:=updown1.position;
    r:=updown2.position;
    pcount:=Tinteger.create;
    work:=Tinteger.create;
    if r>n then showmessage('R must be <= N')
    else
    Begin
      memo1.clear;
      getPermutecount(r,n, pcount);
      s:=pcount.convertTodecimalString(true);
      Showcount('Nbr of Permutations = '+s);
      if sender=PrntBtn then
      begin
        pcount.converttoint64(max);
        memo1.lines.add('');
      end
      else
      begin
        If pcount.compare(MaxDisplayUD.position) >0
        then max:=MaxDisplayUD.position
        else pcount.convertToInt64(max)
      end;
      if max>high(integer) then max:=high(integer);
      setlength(x,r);

      for i:=0 to r-1 do x[i]:=i+1;
      tag:=0;
      for i:=1 to max do
      begin
        if i>1 then getnextpermutation(x,n);
        s:=inttostr(x[0]);
        for j:= 1 to r-1 do
        begin
          s:=s+','+inttostr(x[j]);
        end;
        s:='#'+inttostr(i)+': '+s;
        if sender=PrntBtn
        then
        begin
          writeln(f,s);
          if (i and $4FF)=0 then
          begin
            memo1.lines[0]:=s;
            application.processmessages;
          end;
        end
        else
        begin
          memo1.lines.add(s);
          application.processmessages;
        end;
        if tag<>0 then break;
      end;
    end;
    pcount.free;
    work.free;
  end;

{************** ShowMthPermute *********}
procedure TForm1.ShowMthPermute;
var
  i,j:integer;
  bigi, bigwork:Tinteger;
  m:TInteger;
  morig:Tinteger;
  n,r, unusedcount:integer;
  bigd:array of Tinteger;
  used:array of boolean;
  s:string;
  pcount:TInteger;
begin
  tag:=0;
  m:= TInteger.create;
  s:=edit1.text;  {delete any ',' in input field}
  while pos(',',s)>0 do delete(s,pos(',',s),1);
  m.assign(s);
  morig:=TInteger.create;
  morig.assign(m);
  r:=updown2.Position;
  n:=updown1.position;

  pcount:=Tinteger.create;
  getPermuteCount(r,n, pcount);

  s:=pcount.convertTodecimalString(true);
  Showcount('Nbr of Permutations = '+s);
  if m.compare(pcount)>0 then showmessage('M must be < # Permutations ('
                  +pcount.converttodecimalstring(true)+')')
  else
  begin
    setlength(bigd,r);
    for i:= 0 to r-1 do bigd[i]:=TInteger.create;
    setlength(used,n);
    bigi:=TInteger.create;
    bigwork:=Tinteger.create;
    s:='';
    m.subtract(1);
    application.processmessages;
    if tag<>0 then exit;
    if m.compare(0)>=0 then
    begin
      for i:=0 to n-1 do used[i]:=false;
      bigi.assign(n);
      bigi.factorial;
      bigwork.assign(n-r);  bigwork.factorial;
      bigi.divide(bigwork);
      bigi.divide(n);
      {fill in the sub-sequence numbers}
      for j:= 0 to r-2 do
      begin
        bigd[j].assign(m);
        bigd[j].divide(bigi);
        m.modulo(bigi);
        bigi.divide(n-1-j);
        application.processmessages;
        if tag<>0 then exit;
      end;
      bigd[r-1].assign(m);
      for j:= 1 to r-1 do s:=s+','+bigd[j].convertTodecimalstring(false);

      {mark off and select the ith digit for each d[i]}
      for i:= 0 to r-1 do
      begin
        unusedcount:=0;
        for j:= 0 to n-1 do
        if not used[j] then
        begin
          inc(unusedcount);
          if bigd[i].compare(unusedcount-1)=0 then
          begin
            used[j]:=true;
            bigd[i].assign(j+1);
            break;
          end;
        end;
      end;
      s:=bigd[0].convertTodecimalstring(false) {inttostr(d[0])};
      for j:= 1 to r-1 do s:=s+','+bigd[j].converttodecimalstring(false) {inttostr(d[j])};
      memo1.lines.add('#'+ morig.converttodecimalstring(true)+': '+s);
    end;
  end;
  pcount.free;
  morig.free;
  m.free;

end;


{*******************************************************}
{*************** Combination routines ******************}
{*******************************************************}


{**************** GetComboCount *************}
procedure TForm1.GetCombocount(Const r,n:integer; var ccount:TInteger);
{Return number of combinations -- n things taken r at a time
 without replacement}
{Return number of combinations -- n things taken r at a time
 without replacement}
  var
    work:TInteger;
  begin
    work:=TInteger.create;
    if (r>0) and (r<n) then
    begin
      ccount.assign(N);
      ccount.factorial;
      work.assign(r); work.factorial;
      ccount.divide(work);
      work.assign(n-r); work.factorial;
      ccount.divide(work);
    end
    else if r=n then ccount.assign(1)
    else ccount.assign(0);
    work.Free;
  end;


{************* ShowManyCombos ************}
procedure TForm1.ShowManyCombos(sender:TObject);
var
  r,n:integer;
  i,j:integer;
  max:int64;
  s:string;
  x:array of integer;
  incpos:integer;
  Ccount:TInteger; {to get the combo count}
begin
  tag:=0;  {stop flag}
  n:=updown1.position;
  r:=updown2.position;
  Ccount:=Tinteger.create;
  if r>n then showmessage('R must be <= N')
  else
  begin
    setlength(x,r+1);
    for i:= 1 to r do x[i]:=i;
    dec(x[r]); {so 1st time though select 1st combo}
    memo1.clear;
    cursor:=crHourglass;
    getCombocount(r,n, ccount);
    Showcount('Nbr of Combos = '+ccount.converttodecimalstring(true));
    if sender=PrntBtn then
    begin
      ccount.converttoint64(max);
      memo1.lines.add('');
    end
    else
    begin
      If ccount.compare(MaxDisplayUD.position) >0
      then max:=MaxDisplayUD.position
      else  ccount.converttoint64(max);
    end;
    if max>high(integer) then max:=high(integer);
    for i:= 1 to max do
    begin
      {find the position to increment starting with rightmost}
      incpos:=r;
      {Count down until we find one that is not at max}
      while x[incpos]>=n-r+incpos do dec(incpos);
      {Increment that one}
      inc(x[incpos]);
      {And set rest from there to end as previous nbr + 1}
      for j:=incpos+1 to r do x[j]:=x[j-1]+1;
      s:=inttostr(x[1]);
      for j:= 2 to r do s:=s+','+inttostr(x[j]);
      s:='#'+inttostr(i)+': ' +s;
      if sender=PrntBtn then
      begin
        writeln(f,s);
        if (i and $4FF)=0 then
        begin
          memo1.lines[0]:=s;
          application.processmessages;
        end;
      end
      else
      begin
        memo1.lines.add(s);
        application.processmessages;
      end;
      if tag<>0 then break;
    end;
  end;
  Ccount.free;
  cursor:=crdefault;
end;

procedure binomial (n,k:integer; var B:TInteger);
{
!
!*******************************************************************************
!
!! BINOMIAL computes the binomial coefficient C(N,K).
!
!
!  Formula:
!
!    BINOMIAL(N,K) = C(N,K) = N! / ( K! * (N-K)! )
!
!  Reference:
!
!    M L Wolfson and H V Wright,
!    Combinatorial of M Things Taken N at a Time,
!    ACM algorithm 160,
!    Communications of the ACM,
!    April, 1963.
!
}
 var i,mn,mx:integer;
begin
  mn := min ( k, n - k );
  if ( mn < 0 ) then B.assign(0)
  else if ( mn = 0 ) then B.assign(1)
  else
  begin
    mx := max ( k, n - k );
    B.assign(mx+1);
    for  i := 2 to  mn do
    begin
      B.mult( mx + i );
      B.divide(i);
    end;
  end;
end;


function ksubset_lex_unrank ( rank:TInteger;  k, n:integer):TIArray;
{
!
!*******************************************************************************
!
!! KSUBSET_LEX_UNRANK computes the K subset from N with a given lexicographic rank.
!
!
!  Reference:
!
!    Algorithm 2.8,
!    Donald Kreher and Douglas Simpson,
!    Combinatorial Algorithms,
!    CRC Press, 1998, page 44.
!
     Adapted from Fortran version coded by John Burkardt
}

  var i:integer;
      x:int64;
      rank_copy,B:TInteger;
begin
  rank_copy:=TInteger.create;
  rank_copy.assign(rank);
  B:=TInteger.create;
  x := 1;
  for i := 1 to  k do
  begin
    binomial(n-x, k-i,B);
    while (B.compare(rank_copy )<0) do
    begin
      rank_copy.subtract(B);
      x := x + 1;
      binomial(n-x, k-i,B);
      if b.compare(0)=0 then
      begin
        showmessage('Infinite loop');
        break;
      end;  
    end;
    result[i]:=x;
    inc(x);
  end;
end;


 {*********** ShowMthCombo **********}
procedure TForm1.ShowMthCombo;
var
  r,n:integer;
  i,j:integer;
  s:string;
  perm:TIarray;
  CCount,m:TInteger;
begin
  tag:=0;
  ccount:=Tinteger.create;
  m:=Tinteger.create;
  n:=updown1.position;
  r:=updown2.position;
  (*
  Setlength(perm,n+1);
  For i:=1 to n do perm[i]:=i;
  *)
  Setlength(perm,r+1);
  For i:=1 to r do perm[i]:=i;
  s:=edit1.text;
  while pos(',',s)>0 do delete(s,pos(',',s),1);
  m.assign(s);
  if r>n then showmessage('R must be <= N')
  else
  Begin
    setlength(perm,r+1);
    memo1.clear;
    GetCombocount(r,n, ccount);
    ShowCount('Nbr of Combos = '+ccount.converttodecimalstring(true));
    if m.compare(ccount)>0 then showmessage('M must be < # Combos ('
                  +ccount.converttodecimalstring(true)+')')
    else
    begin
      perm:=KSubset_Lex_Unrank(m,r,n);
      s:=inttostr(perm[1]);
      for j:= 2 to r do s:=s+','+inttostr(perm[j]);
      memo1.lines.add('#'+m.converttodecimalstring(true)+': '+s);
    end;
  end;
  ccount.free;
  m.free;
end;


{**************************************}
{************ Button Handling *********}
{**************************************}

{************ StopBtnClick ***********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

{************** ShowClick ************}
procedure TForm1.ShowClick(Sender: TObject);
begin
  stopbtn.visible:=true;
  stopbtn.update;
  screen.cursor:=crHourGlass;
  memo1.lines.clear;
  if sender =showmthbtn then
    if typergrp.itemindex=0 then ShowMthPermute
    else ShowMthCombo
  else if sender=showmanybtn then
    if typergrp.itemindex=0 then ShowManyPermutes(sender)
    else ShowManyCombos(sender);
  screen.cursor:=crDefault;
  stopbtn.visible:=false;
  if tag<>0 then showmessage('Operation interrupted by user');
end;



procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.PrntBtnClick(Sender: TObject);
begin
  if savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    stopbtn.visible:=true;
    stopbtn.update;
    screen.cursor:=crHourGlass;
    memo1.lines.clear;
    //if sender=showmanybtn then
      if typergrp.itemindex=0 then ShowManyPermutes(sender)
      else ShowManyCombos(sender);
    screen.cursor:=crDefault;
    stopbtn.visible:=false;
    if tag<>0 then showmessage('Operation interrupted by user');
    closefile(f);
  end;

end;

end.
