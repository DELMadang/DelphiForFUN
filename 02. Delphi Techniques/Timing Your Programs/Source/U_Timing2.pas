unit U_Timing2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    S1Lbl: TLabel;
    Start1lbl: TLabel;
    Stop1Lbl: TLabel;
    Stop2Lbl: TLabel;
    FreqLbl: TLabel;
    FastBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FastBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{Unit MMsystem contains the required accurate timing routines
  QueryPerformanceCounter and QueryPerformanceFrequency
}

Uses mmsystem;

procedure TForm1.Button1Click(Sender: TObject);
var
  start,stop1,stop2,freq:int64;
  i:integer;
begin
  screen.cursor:=crHourGlass;
  QueryPerformanceFrequency(freq); {Get counts/second}
  QueryPerformanceCounter(start); {Get string count}
  for i:=1 to 1000000 do ;
  QueryPerformanceCounter(stop1);  {Get end of loop1 count}
  for i:=1 to 1000000 do application.processmessages;
  QueryPerformanceCounter(stop2); {Get end of loop2 count}
  screen.cursor:=crDefault;
  {calculate net counts per million processmessage calls and
   if we divide by freq (counts/sec), we get secs per million calls
  (i.e. microsecs per call)
 }
  If freq>0 then
     showmessage('Time for a call to application.processmessages is '
     + inttostr(((stop2-stop1)-(stop1-start)) div freq)
     +' microseconds (seconds per million calls)')
  else showmessage('No hardware timer available');
  {Show raw data just for kicks}
  Start1Lbl.caption:='Start loop1 count: '+inttostr(start);
  Stop1Lbl.caption:='Stop loop1 count: '+inttostr(stop1)
                 +', Diff: '+inttostr(stop1-start);
  Stop2Lbl.caption:='Stop loop2 count: '+inttostr(stop2)
                 +', Diff: '+inttostr(stop2-stop1);  ;
  FreqLbl.caption:='Freq (counts/sec): '+inttostr(freq);
end;

procedure TForm1.FastBtnClick(Sender: TObject);
{This time we'll just call processmessages every once in a while,
 determined by constant callfreq. Also needed to change output
 to from inttostr to format to display values < 1 microsecond.
 Hint:
 Try changing callfreq from 1000 to 1024 and see if it
 makes any difference in speed
}

const callfreq = 1000;
var
  start,stop1,stop2,freq:int64;
  i, count:integer;
begin
  screen.cursor:=crHourGlass;
  QueryPerformanceFrequency(freq); {Get counts/second}
  QueryPerformanceCounter(start); {Get string count}
  for i:=1 to 1000000 do ;
  QueryPerformanceCounter(stop1);  {Get end of loop1 count}
  count:=0;
  for i:=1 to 1000000 do
  Begin
    inc(count);
    if count mod callfreq = 0 then
    Begin
      application.processmessages;
      count:=0;
    end;
 end;
  QueryPerformanceCounter(stop2); {Get end of loop2 count}
  screen.cursor:=crDefault;
  {calculate net counts per million processmessage calls and
   if we divide by freq (counts/sec), we get secs per million times through
   the loop  (i.e. microsecs per loop)
 }
  If freq>0
  then
     showmessage('Time for a loop with call to application.processmessages '
     +' every ' + inttostr(callfreq) +' loops is '
     + format('%8.3n',[((stop2-stop1)-(stop1-start))/freq])
     +' microseconds (seconds per million loops)')
  else showmessage('No hardware timer available');
  {Show raw data just for kicks}
  Start1Lbl.caption:='Start loop1 count: '+inttostr(start);
  Stop1Lbl.caption:='Stop loop1 count: '+inttostr(stop1)
                 +', Diff: '+inttostr(stop1-start);
  Stop2Lbl.caption:='Stop loop2 count: '+inttostr(stop2)
                 +', Diff: '+inttostr(stop2-stop1);  ;
  FreqLbl.caption:='Freq (counts/sec): '+inttostr(freq);
end;

end.


