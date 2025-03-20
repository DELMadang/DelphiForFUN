unit U_Timing;

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
    procedure Button1Click(Sender: TObject);
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



end.


