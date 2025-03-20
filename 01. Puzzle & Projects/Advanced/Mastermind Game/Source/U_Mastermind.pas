unit U_Mastermind;
{ Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation
 }

 {Version 2 adds user control of peg count and number of colors}

 
interface

uses
  Windows, Messages, ImgList, Controls, StdCtrls, Buttons, ExtCtrls,
  Classes, SysUtils, Graphics, Forms, Dialogs, Spin, math, shellAPI;
 var
   NbrColors:integer=6;
   NbrPegs:integer=6;
   maxpatterns:integer=46656{7776}; {6^5 for 6 colors and 5 pegs - need dynamic}
   maxguesses:integer=15;
   offseth,offsetw,incrx,incry:integer;
type
  TPattern=array[1..6] of byte; {a set of pegs}
  TPatRec = record
    Pattern:TPattern;
    OKFlag:Boolean;  {this pattern is available for use}
  end;
  TGuessRec=record    {and guess and the resulting score}
    patternNbr,nbrinpos,nbroutofpos:integer;
  end;
  TMouseModes=(GetGuess,GetNbrRight);
  TRunModes=(Running,Solved,OutofGuesses,GaveUp,UserError);

  TForm1 = class(TForm)
    RoleBox: TRadioGroup;
    Imagelist1: TImageList;
    GiveUpBtn: TButton;
    InstLbl: TLabel;
    InstLbl2: TLabel;
    SecretBox: TGroupBox;
    PaintBox1: TPaintBox;
    MsgLoc: TLabel;
    ExitBtn: TButton;
    VerboseBox: TCheckBox;
    ShowVerboseBtn: TButton;
    PegsGrp: TRadioGroup;
    ColorsGrp: TRadioGroup;
    StartBtn: TButton;
    StaticText1: TStaticText;
    Panel1: TPanel;
    BoardImage: TPaintBox;
    OKPanel2: TPanel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    OKBtn2: TBitBtn;
    OKBtn: TBitBtn;
    procedure StartBtnClick(Sender: TObject);
    procedure BoardImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OKBtnClick(Sender: TObject);
    procedure GiveUpBtnClick(Sender: TObject);
    procedure BoardImagePaint(Sender: TObject);
    procedure OKBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VerboseBoxClick(Sender: TObject);
    procedure ShowVerboseBtnClick(Sender: TObject);
    procedure SizeGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    BoardPic:TPicture;
    Level:integer;  {Play level: 1=Beginner, 2=good, 3=unbeatable}
    SecretPattern:TPattern;    CurGuesses:array [1..30] of TGuessrec;
    CurGuessCount:Integer;
    Patterns:array [1..46656] of TPatRec;
    TwoPair:array [1..46656] of integer;
    nbrpairs:integer;

    UserGuess, UserNbrRight:TPattern;
    HelpScore:boolean;
    RunMode:TRunModes;
    MouseMode:TMouseModes;
    Workimage,BigPeg,PegImage:TBitmap;
    verbose:boolean;
    TotOK:integer;  {# of eligible patterns - used for verbose reporting}
    bkcolor:TColor;
    originalBoardHeight:integer;  {used to reet board size after possible expansion}
    Procedure InitPatterns;
    Function Eligible(Const guessrec:TGuessrec; const testpatnbr:Integer):boolean;
    Procedure MakeGuess;
    Procedure Score(Const Masterpat:TPattern; var TestGuess:TGuessrec);
    Procedure GetScoreFromUser;
    Procedure showBigpeg(colornbr,col,row:integer; Paintbox:TPaintBox);
    Procedure showguessnumbers(row:integer);
    Procedure ShowGuess;
    Procedure ShowNbrRight;
    Procedure DrawBoard;
    Procedure GetUserGuess;
    Function patternOK(Const pattern:TPattern):boolean;
    Function makepatternstr(patnbr:integer):string;
  end;

var
  Form1: TForm1;

implementation
uses  U_SelectPattern, U_ShowPattern, U_GetHiderOptions, U_Verbose;

{$R *.DFM}

Const
  colors:array[1..6]of char=('R','B','G','V','Y','L');

{********************* TForm1.Create ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  originalboardheight:=panel1.height;
  workimage:=TBitmap.create;
  workimage.transparent:=true;
  pegimage:=TBitmap.create;
  with pegimage do   {holds the peg image to be resized into workimage}
  begin
    transparent:=true;
    height:=imagelist1.height;
    width:=imagelist1.width;
  end;
  bkcolor:=rgb(150,150,150);
  bigpeg:=TBitmap.create;
  bigpeg.transparent:=true;
  bigpeg.transparentcolor:=bkcolor;
  incrx:=Boardimage.width div (9);  {keep horizontal peg  spacing constant}
  sizegrpclick(sender);
  giveupbtn.top:=StartBtn.top;
  giveupbtn.left:=StartBtn.left;
  randomize;
end;

{********************* TForm1.DrawBoard ******************}
Procedure TForm1.DrawBoard;
var
  itop,ileft:integer;
  r:TRect;
  i,j:integer;
Begin
  with BoardImage do
  Begin
    color:=bkcolor;
    canvas.rectangle(0,0,width,height);
    for i:= 0 to nbrpegs-1 do
    for j:= 0 to maxguesses-1 do
    {draw guess areas and big peg holes}
    Begin
      ileft:=offsetw+i*({incrx}width div (nbrpegs-i));
      itop:=2*offseth+j*incry+4;
      r:=rect(ileft,itop,ileft+incrx-4,itop+incry-4);
      canvas.moveto(0,itop+incry-2);
      canvas.lineto(width,itop+incry-2);
      {canvas.draw(ileft,itop,BigPeg);}
      showbigpeg(-1,i,j,boardimage);
    end;
    canvas.font.color:=clblack;
    canvas.textout(5*width div 10,  5, 'Right place     Right color' );
    canvas.textout(5*width div 10, 20,'Right color      Wrong place' );
  end;
end;

{********************** ShowBigPeg ******************}
Procedure TForm1.showBigpeg(colornbr,col,row:integer; Paintbox:TPaintbox);
{colornbr < 0 ==> draw an empty peg hole}
{if paintbox1 parent is main form then only use half of wdth for drawing pegss}
var
  itop,ileft:integer;
  r:Trect;
Begin
  If colornbr>=0 then
  begin
    workimage.height:=incry;
    workimage.width:=incrx;
    Imagelist1.Getbitmap(colornbr-1,pegimage);
    workimage.canvas.stretchdraw(rect(0,0,incrx,incry),pegimage);
    {shift row 0 images down slightly to make room for top label}
    if row=0 then itop:=trunc(offseth+4)
    else itop:=trunc(2*offseth+4+(row-1)*incry);
    if paintbox.parent=panel1  {mainform pegs only use left half of paintbox}
    then ileft:=trunc(offsetw+4+(col-1)*(paintbox.width div (2*nbrpegs)))
    else ileft:=trunc(offsetw+4+(col-1)*(paintbox.width div nbrpegs));
    Paintbox.canvas.draw(ileft-2,itop-2,workimage) ;
  end
  else {draw a peg hole if colornbr<0}
  begin
    ileft:=offsetw+col*(paintbox.width div (2*nbrpegs)){incrx}{+4};
    itop:=2*offseth+4+row*incry;
    {r:=rect(ileft,itop,ileft+incrx-4,itop+incry-4);}
    paintbox.canvas.draw(ileft,itop,BigPeg);
  end;
End;


{********************** TForm1.InitPatterns *****************}
Procedure TForm1.InitPatterns;
{initialize all 1296 (4 pegs, 6 colors) or 7776 (5 pegs 6 colors) patterns}
var
  i,j,k,l,m,n,count:integer;
Begin
  count:=0;
  nbrpairs:=0;
  for i:= 1 to NbrColors do
  for j:=1 to NbrColors do
  for k:=1 to NbrColors do
  for L:=1 to NbrColors do
  for m:=1 to nbrcolors do
  for n:= 1 to nbrcolors do
  begin
      inc(count);
      patterns[count].OKFlag:=true;
      if nbrpegs>=6 then patterns[count].Pattern[nbrpegs-5]:=i;
      if nbrpegs>=5 then patterns[count].Pattern[nbrpegs-4]:=j;
      if nbrpegs>=4 then patterns[count].Pattern[nbrpegs-3]:=k;
      patterns[count].Pattern[nbrpegs-2]:=l;
      patterns[count].Pattern[nbrpegs-1]:=M;
      patterns[count].Pattern[nbrpegs]:=n;

    if ((i=j) and (k=L) and (i<>k))
    or ((i=k) and (j=L) and (i<>j))
    or ((i=L) and (j=k) and (i<>j))
    then
    Begin
      inc(nbrpairs);
      twopair[nbrpairs]:=count;
    end;
  end;
  curguesscount:=0;
end;

{**************** MakePatternStr **************}
function TForm1.makepatternstr(patnbr:integer):string;
{used for verbose displays}
  var
    i:integer;
    pat:TPattern;
  begin
    result:='';
    pat:=patterns[patnbr].pattern;
    for i:=1 to nbrpegs do
      result:=result+colors[pat[i]];
  end;


{********************* Eligible *********************}
Function TForm1.Eligible(Const guessrec:TGuessrec;
                           Const testpatnbr:Integer):boolean;
{based on the current guess (Guessrec), determine if pattern "Testpatnbr"
 could possibly be the secret pattern}
var
  i,j:integer;
  oldnbrrightpos,NewNbrRightPos:integer;
  oldnbrrightcolor, NewNbrRightColor:integer;
  Pat1,Pat2:TPattern;
  TestGuess:TGuessrec;



  procedure makemsg(msg:string);
  begin
    with verboseform.listbox1 do
    begin
      items.add(msg + ', Testing '+makepatternstr(testpatnbr)
                  + ' against Guess '+makepatternstr(guessrec.patternnbr)
                  +format(' (%d,%d)',[guessrec.nbrinpos,guessrec.nbroutofpos]));
    end;
  end;

Begin
  result:=true;
  oldnbrrightpos:=guessrec.nbrinpos;
  oldnbrrightcolor:=oldnbrrightpos+guessrec.nbroutofpos;
  pat1:=patterns[guessrec.patternnbr].Pattern; {current guess }
  pat2:=patterns[testpatnbr].Pattern; {check against this pattern #}

  case level of
  1:  {kind of dumb}
    Begin

      {Heuristics}
      {#1 if total number matching is 0, then
          test pattern cannot have any of the colors in guessrec}
      If result then
      Begin
        if oldnbrrightcolor=0 then
        for i:= 1 to nbrpegs do
        if result then
        begin
          Begin
            j:=1;
            while (j<=nbrpegs) and result do
            if (pat1[i]<>pat2[j]) then inc(j)
            else
            begin
              result:=false;
              if verbose then makemsg('Heuristic 1 '
              +    '(none right previous, some matched in new guess),new guess rejected ');
            end;
          end;
        end;
      end;


      If result then
      {#2 If all of guess is one color, the # of that color in the
         new guess ,must exactly match the number right in this current guess}
      Begin
        j:=1;
        For i:=2 to nbrpegs do if pat1[i]=pat1[1] then inc(j);
        if j=nbrpegs then
        Begin
          j:=0;
          for i:= 1 to nbrpegs do if pat2[i]=pat1[1] then inc(j);
          if j<>oldNbrRightColor then
          begin
            result:=false;
            if verbose then makemsg('Heuristic 2 '
                   + '(prev all one color, new guess must match nbr in right position), new guess rejected ');
          end;
        end;
      end;


      {if result then}
      {#3 - Matching pegs in test pattern compared to guess must be at least
            as high as the nbr in correct position  the guess,
            e.g guess= RRGB and nbt in correct position=2 and testpattern = RGBV,
            then testpattern is not eligible beacuse at least two must match
            guess, ht only one peg does match}
            {Also if total in or out of position =3 then the number in the test
             pattern that match any position in the guess must be at least 3,
             e.g. guess is RRGB and sum of nbr in position and nbr out of
             position =3 then RVBB is not eligible}
      Begin
        NewNbrRightPos:=0;
        NewNbrRightColor:=0;
        for i:=1 to nbrpegs do if pat1[i]=pat2[i] then inc(Newnbrrightpos);
        for i:=1 to nbrpegs do
        Begin
          j:=1;
          while (j<=nbrpegs) and (pat1[i]<>pat2[j]) do inc(j);

          if (j<=nbrpegs) and (pat1[i]=pat2[j]) then
          Begin
            inc(NewNbrrightcolor);
            pat2[j]:=255; {so we don;t count it twice in determining how many match}
          end;
        end;
        if (NewNbrRightpos > {<> is a better test but makes it too smart!} OldNbrRightPos)
        then
        begin
          result:=false;
          If verbose then makemsg('Heuristic 3 '
            + '(new pattern did not match nbr right in prev guess), new guess rejected');
        end;
        if result and (NewNbrRightcolor<OldNbrRightColor)
        then
        begin
          result:=false;
          If verbose then makemsg('Heuristic 3 '
            + '(new pattern fewer matches that total right in prev guess), new guess rejected');
        end;
      end;
    end; {level=1}

  2,3: {Pick a solution that has same score as prev guess.
      i.e. for 4 peg game, each of the 14 possible scores will partition the
      remaining patterns into 14 groups -- the correct solution has to be
      in the group matching the previous score.  This surpsising result
      is based on the symmetry of scores, score(secret pattern, guess pattern)=
      score(guess pattern, secret pattern) }
    Begin
      If Patterns[testpatnbr].OKFlag then
      Begin
        with Testguess do
        Begin
          PatternNbr:=testpatnbr;
          nbrinpos:=-1;
          nbroutofpos:=-1;
        end;
        Score(patterns[guessrec.Patternnbr].Pattern,TestGuess);
        if(TestGuess.nbrinpos <> guessrec.nbrinpos)
             or (TestGuess.nbroutofPos<>guessrec.nbroutofpos)
        then result:=false;
      end
      else result:=false;
    end; {level=2}
  end; {case}
  if result and verbose then makemsg('Accepted as eligible ');
end; {Eligible}

{******************** MakeGuess ***********************}
Procedure TForm1.MakeGuess;
{Computer generates guesses here}

    Procedure displayError;
    var
      s:string;
      i:integer;
    Begin
      s:='';
      for i:=1 to nbrpegs
      do s:=s+colors[patterns[curguesses[curguessCount].patternnbr].Pattern[i]];
      If helpscore then
      Begin
        showmessage('System error, Last guess ' + s
                    +#13+'Program stopped - email Grandpa' );
        halt;
      end
      else
      Begin
        RunMode:=UserError;
      end;
    end; {displayerror}

var
  i,j,k:integer;
  testguess:TGuessrec;
  minmax, minmaxguess, maxval:integer;
  maxscores:array[0..30{24}] of integer;
  savecount:integer;
  nbrleft:integer;
  TestPatternNbrs: array [0..46656] of Integer;
  maxvalscore,minmaxscore:integer;
begin
  if verbose then verboseform.listbox1.clear;
  If curguesscount>0 then
  {elminate from consideration all patterns which are not possible
   based on current guess}
   begin
     savecount:=totok;
    {1. Make sure current does not get selected}
    patterns[curguesses[curguesscount].patternnbr].okFlag:=false;
    dec(totOK);
    {2. Flag all patterns that are not Eligible with the current guess}
    For i := 1 to maxpatterns do
    begin
      {definition of "Eligible" depends on level}
      if Patterns[i].OKFlag and (not Eligible(curguesses[curguessCount],i))
      then
      begin
        Patterns[i].OKFlag:=false;
        dec(TotOK);
      end;
    end;
    if verbose then verboseform.memo1.lines.add('Eligible patterns reduced from '
                                    + inttostr(savecount)+' to '
                                    + inttostr(TotOK));
  end
  else TotOK:=maxpatterns;
  {3. for level 1 or 2, select the first eligible (i.e consistent) pattern
      as next guess}
  If level<3 then
  begin
    i:=1;
    while (i<=maxpatterns) and
    (not patterns[i].OKFlag) do inc(i);
    If not patterns[i].OKFlag then displayerror
    else
    begin
      inc(curguessCount);
      with curguesses[curguessCount] do
      begin
        patternnbr:=i;
        nbrinpos:=-1;
        nbroutofpos:=-1;
      end;
    end;
  end
  else {for level 3 - use min-max technique}
  Begin
    {for each possible guess, get the distribution of scores
     when tested against all eligibles.  Save the largest of these for each guess.
     The pattern we want for our next guess is smallest of these}

    {For speed build a pruned array of just the eligible patterns,
     we can go through this list without checking for eligibility}
    nbrLeft:=0;
    for i:=1 to maxpatterns do
    begin
      if patterns[i].OKFlag then
      begin
        inc(NbrLeft);
        testpatternNbrs[Nbrleft]:=i;
      end;
    end;


    minmax:=9999;
    minmaxguess:=0;
    for i := 1 to nbrleft do {for all possible guesses}
    Begin
      for j:= 0 to high(maxscores) do maxscores[j]:=0;
      testguess.patternnbr:=TestPatternNbrs[i];
      {here's the trickiest part, find out which of the 14 possible
      scoresets, each of the remaing eligible scores belongs to}
      for j:= 1 to nbrleft do
      begin
        Score(Patterns[TestpatternNbrs[j]].pattern, testguess);
        k:=5*testguess.nbrinpos+testguess.nbroutofpos;
        inc(maxscores[k]);
      end;
      maxval:=0;
      {now find the largest};
      for j:=0 to high(maxscores) do  {highest subscrupt will be 5*4=20}
      if maxscores[j]>maxval then
      begin
        maxval:=maxscores[j];
        maxvalscore:=j;  {for ver bose display}
      end;
      if maxval<minmax then
      begin
        minmaxguess:=testpatternNbrs[i];
        minmax:=maxval;
        minmaxscore:=maxvalscore;
      end;
      if verbose then verboseform.listbox1.items.add
            ('Min-max max scoreset size for '+ makepatternstr(testpatternnbrs[i])
             +' is '+inttostr(minmax)+ '('+inttostr(minmaxscore div 5)
             +','+inttostr(minmaxscore mod 5)+')');
    end; {for i}
    {we've determined which pattern score contains the minimum maximum number
    of members, that's our next guess}

    if minmaxguess>0 then
    Begin
      inc(curguessCount);
      with curguesses[curguessCount] do
      Begin
        patternnbr:=minmaxguess;
        nbrinpos:=-1;
        nbroutofpos:=-1;
      end;
    end
    else DisplayError;
  end;
  if verbose then verboseform.Memo1.lines.add(makepatternstr(curguesses[curguesscount].patternnbr)
                               + ' selected as next guess');
End;  {makeguess}

{*************** Score *********************}
Procedure TForm1.Score(Const Masterpat:TPattern;
                           var TestGuess:TGuessrec);
var
  i,j:Integer;
  pat1,pat2:TPattern;
Begin
    with Testguess do
    Begin
      nbrinpos:=0;
      nbroutofpos:=0;
      pat2:=patterns[patternnbr].Pattern;
      pat1:=MasterPat;

      for i:= 1 to nbrpegs do if pat2[i]=pat1[i] then inc(nbrinpos);
      for i:= 1 to nbrpegs do
      for j:=1 to nbrpegs do
      If (pat2[i]=pat1[j]) and (pat2[i]<>255) then
      Begin
        inc(nbroutofpos);
        pat2[i]:=255; {don't match this one against any more}
        pat1[j]:=255; {and don't match any other pat1 against this pat2}
      end;
      nbroutofpos:=nbroutofpos-nbrinpos;
    end;
end;

{*************** GetScoreFromUser **************}
Procedure Tform1.GetScoreFromUser;
Var
  i:integer;
  testguess:TGuessRec;

Begin

  For i:= 1 to nbrpegs do UserNbrRight[i]:=0;
  OKPanel2.top:=2*offseth + 4+ incry*(curguesscount)
                       -okpanel2.height - (incry-okpanel2.height) div 2;
  spinedit1.value:=0;
  spinedit2.value:=0;
  OKPanel2.visible:=true;
  Instlbl2.visible:=true;

  GiveUpBtn.visible:=true;
  ExitBtn.visible:=false;
  tag:=0;

  repeat
    sleep(100);
    application.processmessages;
  until Tag<>0;

  with curguesses[curguesscount] do
  Begin
    nbrinpos:=0;
    nbroutofpos:=0;
  end;
  curguesses[curguesscount].nbrinpos:=strtoint(spinedit1.text);
  curguesses[curguesscount].nbroutofpos:=strtoint(spinedit2.text);

  if GetHiderOptions.radiogroup1.itemindex=1 then
  Begin
    testguess:=curguesses[curguesscount];
    Score(SecretPattern,testguess);
    If curguesscount<=maxguesses then
    Begin
      If (testguess.nbrinpos<>curguesses[curGuessCount].nbrinpos)
      or (testguess.nbroutofpos<>curguesses[curguesscount].nbroutofpos)
      then messagedlgpos('Oops - you made a scoring error, I''ll correct it for you',
                    mtinformation,[mbOK],0,msgloc.left,msgloc.top);
      curguesses[curguesscount]:=testguess;
      shownbrright;
    end;
  end;

  BoardImage.OnMouseup:=nil;
  OKPanel2.visible:=false;
  Instlbl2.visible:=false;
  GiveUpBtn.visible:=false;
  ExitBtn.visible:=true;
End;

Procedure TForm1.showguessnumbers(row:integer);
begin

  with  boardimage.canvas do
  begin
    font.size:=10; font.style:=[fsbold];
    textout(boardimage.width div 2+10,
                   3*offseth div 2+row*incry,inttostr(curguesses[row].nbrinpos)
                   +'               '+inttostr(curguesses[row].nbroutofpos));
  end;
end;

{**************** TForm1.ShowGuess ***************}
Procedure TForm1.ShowGuess;
{display a guess on the board}
var
  i:integer;
Begin
  with patterns[curguesses[curguesscount].patternnbr] do
  {for i:=1 to nbrpegs do showbigpeg(Pattern[i],i,curguesscount,BoardImage);}
  boardimage.invalidate
end;

{****************** ShowNbrRight *****************}
Procedure TForm1.shownbrRight;
{display nbr right pegs on the oard}
begin
  with curguesses[curguesscount] do
  Begin
    spinedit1.text:= inttostr(nbrinpos);
    spinedit2.text:= inttostr(nbroutofpos);
  end;
  showguessnumbers(curguesscount);
End;

{******************** GetUserGuess **************}
Procedure Tform1.GetUserGuess;
{solicit a guess from the user}
Var
  i:integer;
Begin
  MouseMode:=GetGuess;
  For i:= 1 to nbrpegs do UserGuess[i]:=0;
  BoardImage.OnMouseup:=BoardimageMouseUp;
  OKBtn.top:=2*offseth+4+incry*(curguesscount+1)-okbtn.height-(incry-okbtn.height) div 2;
  (*
  if row=0 then itop:=trunc(offseth+4)
    else itop:=trunc(2*offseth+4+(row-1)*incry);
  *)  
  OKBtn.visible:=true;
  GiveupBtn.Visible:=true;
  Instlbl.caption:= 'Click peg holes to pick '+inttostr(nbrpegs)+' pegs, then click ''Score this guess''  button';
  Instlbl.visible:=true;
  tag:=0;
  repeat
    application.processmessages;
  until tag<>0;
  BoardImage.OnMouseup:=nil;
  OKBtn.visible:=false;
  GiveupBtn.visible:=false;
  Instlbl.visible:=false;
  boardimage.update;
End;


{***************** PatternOK ******************}
function Tform1.PatternOK(Const pattern:TPattern):boolean;
{just check to ensure that "nbrpegs" colors have been selected}
var
  i:integer;
  Begin
    result:=true;
    for i:= 1 to nbrpegs do
    if pattern[i]=0 then
    begin
      result:=false;
      break;
    end;
  end;


{********************* StartBtnClcik **************}
procedure TForm1.StartBtnClick(Sender: TObject);
{begin the solving process}
var
  i:integer;
  msg:string;
begin
  StartBtn.enabled:=false;
  pegsgrp.enabled:=false;
  colorsgrp.enabled:=false;
  rolebox.enabled:=false;
  drawboard;
  secretbox.visible:=false;
  InitPatterns;
  RunMode:=Running;
  verboseform.memo1.lines.clear;

  case RoleBox.itemindex of
  0: {Computer solves}
  begin
    if GetHiderOptions.showmodal = mrok then
    begin
      application.processmessages;
      level:=GetHiderOptions.Smartbox.itemindex+1;
      helpscore:=false;
      totOK:=maxpatterns;
      case GetHiderOptions.radiogroup1.itemindex of
        0:  ShowpegsDlg.showmodal;
        1,2:
        begin
          if PatternDlg.showmodal<>mrOK then  {user changed his mind}
          begin
            StartBtn.enabled:=true;
            exit;
          end;
          if GetHiderOptions.radiogroup1.itemindex=2
          then helpscore:=true;
          Secretpattern:=PatternDlg.UserGuess;
          secretbox.visible:=true;
          for i:=1 to nbrpegs do showbigpeg(secretpattern[i],i,0,Paintbox1);
        end;

      end; {case}


      curguesscount:=1;
      with curguesses[1] do
      case level of
        1,2:  patternnbr:=random(maxpatterns)+1;  {make a random first guess}
        {for level 3 (smartest) make a random guess from all patterns wih two pairs}
        {this was true for 4 peg case,not checked for other cases}
        3:  if nbrpairs>0 then patternnbr:=twopair[random(nbrpairs)+1] {may only help in 4 peg case}
            else patternnbr:=random(maxpatterns)+1;
      end;
      ShowGuess;
      If helpscore then
      Begin
        Score(Secretpattern, curguesses[curGuessCount]);
        ShownbrRight;
        sleep(1000);
      end
      else GetScoreFromUser;
      {here is the solve loop}
      if helpscore then screen.cursor:=crhourglass; {auto solve - show busy cursor}

      If curguesses[curguesscount].nbrinpos=nbrpegs then RunMode:=solved;

      while (RunMode=running) do
      Begin
        makeguess;
        If curguesscount<=maxguesses then ShowGuess;
        If helpscore then
        Begin
          Score(SecretPattern,curguesses[curguesscount]);
          if curguesscount<=MaxGuesses then ShowNbrRight;
          sleep(1000);
        end
        else GetScoreFromUser;
        If curguesses[curguesscount].nbrinpos=nbrpegs then RunMode:=solved;
        If (curGuessCount=maxguesses) and (runmode=running) then runMode:=Outofguesses;
        application.processmessages;
      end;
      screen.cursor:=crdefault;

      Case RunMode of
         Solved:msg:='Solved it , I win in '+inttostr(curguesscount)+' moves!';
         OutOfGuesses: msg:='Too many guesses, you win';
         GaveUp: msg:='You gave up, I win!';
         UserError: msg:='You scored wrong, I win!';
      end; {case}
      messagedlgpos(msg,mtInformation,[mbOK],0,msgloc.left, msgloc.top);
    end;
  end;
  1:
    Begin  {user solves}
      {Make a Secret pattern}
      randomize;
      For i:=1 to nbrpegs do SecretPattern[i]:=random(Nbrcolors)+1;
      {Loop}
      repeat
        GetUserGuess;
        if runmode<>gaveup then
        begin
          Score(SecretPattern,curguesses[curguesscount]);
          if curguesscount<=MaxGuesses then ShowNbrRight;
          If curguesses[curguesscount].nbrinpos=nbrpegs then RunMode:=solved;
        end;  
      until not (RunMode=running) {or (curGuessCount>MaxGuesses)};
      case runmode of
        Solved: messagedlgpos('You solved it, you win!',mtInformation,[mbOK],0,msgloc.left, msgloc.top);
        OutOfGuesses: messagedlgpos('Too many guesses, I win!',mtInformation,[mbOK],0,msgloc.left, msgloc.top);
        GaveUp:messagedlgpos('You gave up, I win!',mtInformation,[mbOK],0,msgloc.left, msgloc.top);
      end; {case}
      If PatternOK(Secretpattern) then {"Nbrpegs" pegs were specified in the pattern}
      Begin
        secretbox.visible:=true;
        for i:=1 to nbrpegs do showbigpeg(secretpattern[i],i,0,Paintbox1);
      end;
    end;
  end; {case}
  StartBtn.enabled:=true;
  pegsgrp.enabled:=true;
  colorsgrp.enabled:=true;
  rolebox.enabled:=true;
end;



{******************* BoardImageMouseUp *******************}
procedure TForm1.BoardImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 {collect and display guess (bigpeg) or score (smallpeg) peg data
  depending on Mousemode flag}
var
  newrow,newcol:integer;
  relx, rely:integer;
begin
  newcol:= (x-offsetw-4{+incrx div 2})*2*nbrpegs div  boardimage.width + 1;
  newrow:= (y-2*offseth) div incry+1;
  If Mousemode=GetGuess then
  Begin
    If (newrow=curGuesscount+1) and (newcol>=1) and (newcol<=nbrpegs) then
    Begin
      inc(userguess[newcol]);
      if userguess[newcol]>nbrcolors
      then userguess[newcol]:=userguess[newcol]-nbrcolors;
      showbigpeg(userguess[newcol],newcol,newrow,BoardImage);
    end;
  end;
  (*
  else if Mousemode=GetNbrRight then
  Begin

    If (newrow=curGuesscount) and (newcol=6) then
    Begin
      {Convert column/row for small pegs to virtual column 5 to 9}
      {just for ease of counting - actual positions are not significant}
      relx:=(x-offsetw-4) - 5*incrx;
      rely:=(y - offseth-4) -(newrow-1)*incry;
      newcol:= relx div (incrx div 2) + 2*(rely div (incry div 2))+5;
      inc(usernbrright[newcol-4]);

      if usernbrright[newcol-4]>2 then
      Begin
        usernbrright[newcol-4]:=0;
        {showsmallpeg(ClBlack,newcol-4,newrow);}
      end
      else If usernbrright[newcol-4]=1 then showsmallpeg(ClRed,newcol-4,newrow)
      else If usernbrright[newcol-4]=2 then showsmallpeg(Clwhite,newcol-4,newrow);

    end;
  end;
  *)
end;

{******************** OKBtnClick *************}
procedure TForm1.OKBtnClick(Sender: TObject);
{score a users guess}
var
  count:integer;
  i,j:integer;
  found:boolean;
begin
  if not patternOK(Userguess) then messagedlgpos('Click on pegholes to set a pattern'
                                  +#13+'Then click this button',
                                  mtInformation,[mbOK],0,msgloc.left, msgloc.top)
  else
  Begin
    i:=0;
    found:=false;
    while (not found) and (i<MaxPatterns) do
    Begin
      inc(i);
      count:=0;
      for  j:=1 to nbrpegs{4} do if userguess[j]=patterns[i].Pattern[j] then inc(count);
      if count=nbrpegs{4} then found:=true;
    End;
    If found then
    Begin
      inc(curguesscount);
      Curguesses[curguesscount].patternnbr:=i;
      tag:=1;
    end
    Else
    Begin
      Showmessage('System error 2 - Email Grandpa');
      halt;
    end;
  end;

end;

{***************** GiveUpBtnClick *************}
procedure TForm1.GiveUpBtnClick(Sender: TObject);
begin
  RunMode:=GaveUp;
  tag:=1;
end;

{****************** BoardImagePaint *****************}
procedure TForm1.BoardImagePaint(Sender: TObject);
var
  i,j:integer;
begin
  drawboard;
  for j:= 1 to curguesscount do
  with curguesses[j], patterns[curguesses[j].patternnbr] do
  Begin
    for i:=1 to nbrpegs do showbigpeg(Pattern[i],i,j,BoardImage);
    if j<curguesscount then showguessnumbers(j);
  end;
end;

{************** OKBtn2Click ***********}
procedure TForm1.OKBtn2Click(Sender: TObject);
begin
  tag:=1;
end;


{*************** PaintBox1Paint **************}
procedure TForm1.PaintBox1Paint(Sender: TObject);
{repaint the secret code box as necessary}
var
  i:integer;
begin
  for i:=1 to nbrpegs do showbigpeg(secretpattern[i],i,0,Paintbox1);
end;

{****************** ExitBtnClick *****************}
procedure TForm1.ExitBtnClick(Sender: TObject);
begin
  close;
end;

{****************** TForm1.FormClose ***********************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  close;
end;


{************** FormCloseQuery *****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:=true;
  tag:=1;
  runmode:=gaveup;
end;

{****************** VerboseBoxClick ***************}
procedure TForm1.VerboseBoxClick(Sender: TObject);
begin
  If verbosebox.checked then
  begin
    verbose:=true;
    showverbosebtn.visible:=true;
  end
  else verbose:=false;
  verboseform.visible:=verbose;
  showverbosebtn.visible:=verbose;
end;

{************** ShowVerboseBtnClick ***************}
procedure TForm1.ShowVerboseBtnClick(Sender: TObject);
begin
  verboseform.visible:=true;
end;

{**************** SizeGrpClick ************}
procedure TForm1.SizeGrpClick(Sender: TObject);
{Number of pegs or colors changed - reset affected variables}
var  i:integer;
begin
  nbrpegs:=3+pegsgrp.itemindex;
  nbrcolors:=3+colorsgrp.itemindex;
  maxpatterns:=trunc(intpower(nbrcolors,nbrpegs));
  maxguesses:=8+4*(nbrpegs-3)-1;
  spinedit1.maxvalue:=nbrpegs;
  spinedit2.maxvalue:=nbrpegs;
  panel1.height:=originalboardheight;
  incry:=(Boardimage.height-30) div (maxguesses+1);
  if incry<okpanel2.height then
  begin
    panel1.height:=30+maxguesses*OKPanel2.height;
    incry:=OKpanel2.height;
  end;
  incrx:=Boardimage.width div (2*Nbrpegs{+5});
  if incrx>incry then incrx:=incry else incry:=incrx;
  offseth:=30 {incry div 2};
  offsetw:=incrx div 4;
  workimage.free;
  workimage:=TBitmap.create;
  workimage.transparent:=true;
  for i:=1 to nbrpegs do secretpattern[i]:=0; {make sure we don't reuse old pattern}
  (*
  bigpeg.free; {easiest way to clear any old image data}
  bigpeg:=Tbitmap.create;
  *)
  with Bigpeg do
  Begin
    height:=incry-4;
    width:=incrx-4;
    canvas.brush.color:=bkcolor;
    canvas.fillrect(rect(0,0,width,height));
    transparent:=true;
    transparentcolor:=bkcolor;
    canvas.brush.color:=clblack;
    canvas.Pen.color:=clteal;
    canvas.pen.width:=8-nbrpegs;
    canvas.ellipse(2,2,width-2,height-2);
  end;
  initpatterns;
  drawboard;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
