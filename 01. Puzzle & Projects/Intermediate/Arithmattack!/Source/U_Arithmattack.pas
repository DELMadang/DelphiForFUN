unit U_Arithmattack;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {An arithmetic drill program converted from a Javascript program writtten
  by David Baurac at Argonne National Laboratories,
  http://www.dep.anl.gov/aattack.htm}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, jpeg;

type
  TForm1 = class(TForm)
    EqEdt: TEdit;
    Label1: TLabel;
    AnsEdt: TEdit;
    StaticText1: TStaticText;
    OperatorBox: TRadioGroup;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    LowEdt: TSpinEdit;
    HighEdt: TSpinEdit;
    Startmsg: TStaticText;
    StopMsg: TStaticText;
    Label2: TLabel;
    StaticText7: TStaticText;
    StaticText10: TStaticText;
    Timer1: TTimer;
    StaticText11: TStaticText;
    RangeLbl: TLabel;
    Panel1: TPanel;
    TimeLeftEdt: TEdit;
    Label3: TLabel;
    RightEdt: TEdit;
    StaticText8: TStaticText;
    WrongEdt: TEdit;
    StaticText9: TStaticText;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AnsEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StartmsgClickClick(Sender: TObject);
    procedure StopMsgClick(Sender: TObject);
    procedure ValEdtExit(Sender: TObject);
  public
    { Public declarations }
    answer:integer; {correct answer to the current problem}
    timeleft:integer; {start at 60 and decrement 1 per second}
    right, wrong:integer; {right and wrong counts}
    procedure makenextproblem;
    procedure checkanswer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{****************** MakeNextProblem ********}
procedure TForm1.makenextproblem;
{Generate a new problem}
var
  range:integer;
  v1,v2:integer;
  i,N:integer;
  opcode:char;
begin
  ansedt.setfocus; {This must occur before we compute the range so that the
                    high and low edit onexit procedure is called to fix-up high
                    and low range values if necessary}
  opcode:='?';
  range:=highedt.value-lowedt.value+1;
  v1:=lowedt.value+random(range);
  v2:=lowedt.value+random(range);
  if operatorbox.itemindex=4 then i:=random(4)
  else i:=operatorbox.itemindex;
  case i of
    0: {+}
    begin
      opcode:='+';
      answer:=v1+v2;
    end;
    1:{-}
      begin
        opcode:='-';
        if v1<v2 then {make sure difference is not negative}
        begin
          n:=v1;
          v1:=v2;
          v2:=n;
        end;
        answer:=v1-v2;
      end;
    2:{*}
      begin
        opcode:=char($D7);
        answer:=v1*v2;
      end;
    3:{/}
       begin
        opcode:=char($F7);
        if v2=0 then
        repeat
          v2:=lowedt.value+random(range);
        until v2<>0;
        v1:=v1*v2;
        answer:=v1 div v2;
      end;
  end;
  eqedt.text:=inttostr(v1)+' '+opcode+' '+inttostr(v2);
  ansedt.text:='';
end;

{****************** CheckAnswer **************}
procedure TForm1.checkanswer;
{Make sure answer is a valid # and check if it's correct}
var
  errcode, guess :integer;
begin

  val(ansedt.text,guess,errcode);
  if ansedt.text='' then
  begin
     timer1.enabled:=false;
     showmessage('Enter a number');
     timer1.enabled:=true;
  end
  else  {answer is a number, check it}
  begin
    if guess=answer then
    begin
      inc(right);
      rightedt.text:=inttostr(right);
    end
    else
    begin
      inc(wrong);
      wrongedt.text:=inttostr(wrong);
      messagebeep(mb_Iconexclamation);
      timer1.enabled:=false; {Stop timer while message is displayed}
      showmessage('Sorry, the correct answer is '+ eqedt.text
                   + ' = '+inttostr(answer));
      timer1.enabled:=true;
    end;
  end;
   ansedt.text:='';
end;



{**************** Timer1Timer **************}
procedure TForm1.Timer1Timer(Sender: TObject);
{when enabled, timer pops here every second to reduce "timeleft" counter}
{and give final message when timeleft gets to 0}
begin
  dec(timeleft);
  timeleftedt.text:=inttostr(timeleft);
  application.processmessages;
  if timeleft<=0 then
  begin
    timer1.enabled:=false;
    messagebeep(mb_iconasterisk);
    showmessage('You had '+inttostr(right)+' correct answers '
                 +#13+' and '+inttostr(wrong)+' incorrect answers'
                 +#13+ 'Press G to start the next round' );
    eqedt.text:=''; {erase that last equation so user doesn't try to solve it}
    ansedt.text:='';
  end;
end;

{******************* FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
{Called at startup to initalize stuff}
begin
  randomize;
  operatorbox.itemindex:=0;  {make default operator +}
  RangeLbl.caption:='(defines the range of operands for +, -, and '
                      +char($D7)+','+#13
                      +' or the range of quotient and answer for '+char($F7);
end;

{*************** AnsEdtKeyPress ****************}
procedure TForm1.AnsEdtKeyPress(Sender: TObject; var Key: Char);
{user key press, nopt that we don;t have to worry about handling
 G and S here because FormKeyPress will take of it first}
begin
  if not timer1.enabled then
  begin
    key:=#00;
    messagebeep(mb_iconAsterisk);
  end
  else if key=#13 {enter} then
  begin
    CheckAnswer;
    makeNextProblem;
    key:=#00;
  end
  else if not (key in[#8, '0'..'9']) then {allow digits and backspace character}
  begin
    key:=#00; {clear the key since we're handling it here}
    messagebeep(mb_Iconasterisk);
    timer1.enabled:=false;
    showmessage('Only numbers 0,1,2,3,4,5,6,7,8,9 are allowed');
    timer1.enabled:=true;
  end;
end;

{****************** FormKeyPress ******************}
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
{Intercept all keypressses looking for G (Go) or S (Stop)}
{Keypreview property is set to true ensuring that key is detectd
 regardless of which control has focus, e.g. if user changed
 limits}
var
  ch:char;
begin
  ch:=upcase(key);
  if ch in ['G','S'] then
  begin
    if ch='G' then StartMsgClickClick(sender) {start a run}
    else StopMsgClick(sender); {we'll stop on the next timer pop}
    key:=#00; {everbody else will ignore the key}
  end;
end;

{*************** StartMsgClick ******************}
procedure TForm1.StartmsgClickClick(Sender: TObject);
{User pressed 'G' key or clicked on Go message. If not already running
 then reset counters, start the timer, and make the first problem}
 begin
  if not timer1.enabled then
  begin
    timeleft:=60;
    rightedt.text:='0'; right:=0;
    wrongedt.text:='0';  wrong:=0;
    timer1.enabled:=true;
    makenextproblem;
  end;
end;

{****************** StopMsgClick ***************}
procedure TForm1.StopMsgClick(Sender: TObject);
{User clicked on stop message, if we're running assume he wanted to stop}
begin   if timer1.enabled then timeleft:=1;   end;


procedure TForm1.ValEdtExit(Sender: TObject);
{Called at exit time to check that lowest value is less than highest}
var n:integer;
begin
  {make high at least low + 1}
  if highedt.value=lowedt.value then highedt.value:=lowedt.value+1
  else
  If HighEdt.value< LowEdt.value then
  begin
    n:=highedt.value;
    highedt.value:=lowedt.value;
    lowedt.value:=n;
  end;
end;

end.
