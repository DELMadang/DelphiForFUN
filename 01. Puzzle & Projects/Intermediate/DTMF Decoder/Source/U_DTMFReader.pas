unit U_DTMFReader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SynaSer, StdCtrls, ExtCtrls, dffutils, Grids;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    ResetBtn: TButton;
    MonitorBtnClick: TButton;
    StopBtn: TButton;
    ConnectBtn: TButton;
    GroupBox2: TGroupBox;
    GPIOGrp: TRadioGroup;
    SetRBtn: TRadioButton;
    ClearRBtn: TRadioButton;
    SetClearBtn: TButton;
    FlipRBtn: TRadioButton;
    DrawGrid1: TDrawGrid;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure MonitorBtnClickClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ConnectBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SetClearBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     ser:TBlockSerial;
     stop:boolean;
     DeCodeList:TStringlist;
     bitsOn:array[0..7] of char;
     procedure DrawCell(ACol:Integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  cr:char=#$0D;
  lf:char=#$0A;
  crlf:array[0..1] of char=(#13,#10);
  decodeTable:array[0..15] of string= ('90=1','A0=2','B0=3','D8=A',
                                          '88=4','98=5','A8=6','E8=B',
                                          'B8=7','C0=8','D0=9','F8=C',
                                          'F0=*','E0=0','C8=#','80=D');



const table:array[0..15] of char = ('0','1','2','3','4','5','6','7',
                                    '8','9','A','B','C','D','E','F');

function ByteToHexStr(b:byte):string;
begin
  result:=table[b shl 4] + table[b and $0f];
end;

function HexCharToByte(H:char; var B:byte):boolean;
var
  i:integer;
begin
  result:=false;
  for i := 0 to 15 do
  if table[i]=H then
  begin
    B:=i;
    result:=true;
    break;
  end;
end;


function ByteToChar(b:byte):char;
begin
  result:=char(b);
end;

{**************** FormActivaye **********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  ser:=TBlockSerial.Create;
  ser.RaiseExcept:=False{True};

  {Make a name-value stringlist transating received of DTMF code to characters}
  DecodeList:=TStringList.create;
  for i:=0 to 15 do Decodelist.add(DecodeTable[i]);
  //Decodelist.sort;
  connectbtnclick(sender);
end;

{************* ConnectBtnClick **************8}
procedure TForm1.ConnectBtnClick(Sender: TObject);
var
  i:integer;
  s:string;
begin
  with  memo1.Lines, ser do
  begin
    s:=GetSerialPortNames;
    add(s);
    If length(s)=4 then edit1.Text:=s;
    Connect(Edit1.Text);
    for i:=0 to 7 do bitsOn[i]:='?';  {mark bit status as unknown}
    if lasterror<>0 then
    begin
      showmessage(format('Connection to %s failed, error %s',[edit1.text,LastErrorDesc]));
      exit;
    end
    else
    begin;
      memo1.lines.add(ser.Device +' connected');
      resetbtnclick(sender);
      sleep(10);
    end;  
  end;
end;

{************ ResetBtnClick **********8}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  Stop:=true;  {In case we are waiting for retrieval}
  ser.sendstring('gpio reset'+CR);
  sleep(10);
  //memo1.lines.add(ser.device + ' reset');
end;

{************ MonitorbtnClick **************}
procedure TForm1.MonitorBtnClickClick(Sender: TObject);
var
  i:integer;
  s:string;
  count:integer;

  code,lastStr:string;
  letter,recv:string;
  lettertime:TDateTime;
  elapsed:extended;
begin
  memo1.lines.clear;
  if not ser.InstanceActive then
  begin
    connectBtnClick(sender);
    if not ser.InstanceActive then
    begin
      showmessage('Device connection failed');
      exit;
    end;
  end;
  for i:=0 to 7 do bitsOn[i]:='?';
  count:=0;
  stop:=false;
  laststr:='';
  recv:='';
  with ser do
  begin
    raiseexcept:=false;
    tag:=0;
    sendstring(' '+cr);
    application.processmessages;
    memo1.Lines.add('Waiting for data');
    screen.cursor:=crHourGlass;
    lettertime:=now+ 1/24; {Set default lettertime an hour in the future}
    while (not stop) and (count<100000) do
    begin
      sleep(1);
      begin
        sendstring('gpio readall'+cr);
        sleep(1);
        waitingdataex;
        application.ProcessMessages;
        s:=recvpacket(10);
        If length(s)>10 then
        begin
          //i:=ansipos(#13,s); {Find the CR}
          i:=length(s)-4;
          code:=copy(s,i,2);
          sleep(1);
          if (length(code)=2) and (code<>laststr)  then
          begin
            laststr:=code;
            // memo1.lines.add('String received '+code);
            letter:=Decodelist.values[code];
            if length(letter)>0 then
            begin
              recv:=recv+letter;
              //lettertime:=now;
            end;
            lettertime:=now;
          end;
          //sendstring('gpio wrtieall 00'+cr);
          //sendbyte(0);
          //sleep(1);
          purge;
          sleep(1);
        end;
      end;
      inc(count);
      elapsed:=(now-lettertime)*secsperday;
      //memo1.lines.add(format('%.2f',[elapsed]));
      if (elapsed>1) then
      begin
        if (length(recv)>0) then
        begin
          memo1.Lines.add(recv);
          recv:='';
          for i:=0 to 7 do drawcell(i);
          lettertime:=now;
          application.processmessages;
        end;
      end;
    end;
  end;
  screen.cursor:=crDefault;
end;

{************** StopBrnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  ser.tag:=1;
  stop:=true;
  memo1.Lines.add('Stopped by user');
end;

{******** FormCloseQuery *********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  stop:=true;  {Stop monitoring in case is it still on}
  application.ProcessMessages;
  canclose:=true;
end;

{*********** SetClearBtn ***********}
procedure TForm1.SetClearBtnClick(Sender: TObject);
var
  ch:char;
  op,s:string;
  i, acol:integer;
begin
  if not ser.InstanceActive then
  begin
    connectBtnClick(sender);
    if not ser.InstanceActive then
    begin
      showmessage('Device connection failed');
      exit;
    end;
  end;
  if GPIOgrp.ItemIndex >=0  then
  with ser do
  begin
    stopbtnclick(sender);
    if bitson[0]='?' then for i:=0 to 7 do drawcell(i); {Preload bit display status}
    application.processmessages;
    acol:=(GPIOGrp.itemindex);
    ch:=inttostr(7-acol)[1];
    if (setRBtn.checked) or
       (flipRbtn.checked and (bitson[acol]='0'))
    then op:='set'
    else if ClearRBtn.checked or
         (flipRbtn.checked and (bitson[acol]='1'))
     then op:='clear'
    Else
    begin
      showmessage('Select Set, Clear, or Flip operation');
      exit;
    end;
    sendstring('gpio read '+ ch+cr);
    sleep(10);
    s:=recvpacket(10);
    sleep(1);
    s:=s[length(s)-3];
    if messagedlg(format('Port %s is %s, proceed with %s?',[ch,s,uppercase(op)]),
               mtconfirmation,[mbyes,mbno], 0) = mryes
    then
    begin
      sendstring('gpio '+op+' '+ch + cr);
      sleep(10);
      memo1.Lines.add('Sending '+ uppercase(op)+' command to GPIO');
      drawcell(Acol);
    end;
  end;
end;

{************DrawCell *************}
procedure TForm1.DrawCell(Acol:integer);
{Show current status of GPIO ports}
{Note: Port 6 (2nd from left)  on DTFM card is not used.
       DTMF port bit 2 is hard wired to the GPIO port 6 position}
  var
    ch:char;
    s:string;
    r:Trect;
begin
  with ser, drawgrid1, canvas do
  begin

    if not ser.instanceActive then exit;
    for acol:= 7  downto 0 do
    begin
      ch:=inttostr((7-acol))[1];
      sendstring('gpio read '+ ch+cr);
      sleep(10);
      s:=recvpacket(10);
      sleep(1);
      if length(s)>0 then
      begin
        s:=s[length(s)-3];
        bitsOn[acol]:=s[1];
        if s='0' then brush.Color:=clblack
        else brush.Color:=clred;
      end
      else brush.Color:=clNone;
      r:=cellrect(acol,0);
      with r do ellipse(left+2,top+2,left+20,top+20);
    end;
  end;
end;

end.
