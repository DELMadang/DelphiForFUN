unit U_HexView;
{Copyright 2001-2003, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved

 Phase 2, (Adjust Line Breaks), added by Steve Moller, CSIRO, Australia. 2003.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    OKBtn: TBitBtn;
    Panel1: TPanel;
    UpBtn: TBitBtn;
    DownBtn: TBitBtn;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure UpDownBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  public
    { Public declarations }
    browsefilename:string;
    f_in : TFileStream;
    buffer:array of byte;
    buflen:integer; {buffer size and number of bytes to read}
    bytesread:integer;  {number of bytes actually read during last read}
    curpage,maxpage:integer;
    charsperline:integer;
    procedure setupPage;
    procedure showpage; {display the current page (curpage)}
  end;

var
  Form2: TForm2;

implementation


{$R *.DFM}

var hexchars:array[0..15] of char=('0','1','2','3','4','5','6','7','8',
                                   '9','A','B','C','D','E','F');

{*************** FormActivate *****************}
procedure TForm2.FormActivate(Sender: TObject);

begin
  caption:='File:  ' +browsefilename;
  f_in:=TFileStream.create(browsefilename,fmOpenread);
  formresize(sender);  {calculate page size stuff}
end;

{****************** SetupPage ****************}
procedure Tform2.SetupPage;
{{Called initally and if form size changes}
var
  savefont:TFont;
  w,h:integer;
  pagecharwidth, pagelines:integer;
begin
  {Memo does not have a canvas so wei'' use the foprms canvas to calculate
   character height and width}
  savefont:=font;
  font:=memo1.font;
  w:=canvas.textwidth('X');
  h:=canvas.textheight('X');
  font:=savefont;
  pagecharwidth:=memo1.clientwidth div w;
  pagelines:=memo1.clientheight div h-1;
  {due to hex display formatting, characters can only use less than  1/3 of width}
  charsperline:=4*((4*pagecharwidth div 13 -2) div 4);
  buflen:=charsperline*pagelines;
  setlength(buffer,buflen);
  maxpage:=f_in.size div buflen ;
  curpage:=0;
  showpage;
end;


{**************** ShowPage *************}
 procedure TForm2.showpage;
 {Display the page indicated by field CurPage}
 var
   lines:integer;
   i,j,n:integer;
   text:string;
   hex:string;
   bytesread, byteswritten:integer;
   hexsize:integer;
 begin
   f_in.seek(curpage*buflen, soFromBeginning);
   bytesread:=f_in.read(buffer[0],buflen);
   label1.caption:=inttostr(curpage+1) +#13+'of  '+ #13+ inttostr(maxpage+1);
   memo1.clear;
   lines:=bytesread div charsperline;
   hexsize:=charsperline*2+charsperline div 4; {length of a full hex string}
   if lines>=0 then
   begin
     byteswritten:=0;
     for i:= 0 to lines do {for all lines}
     begin
       hex:='';
       n:=i*charsperline;
       text:='';
       for j:=0 to charsperline -1 do  {for characters im the line}
       begin
         {The clear text part -  if it's displayable the do it}
         if (buffer[n+j]>=32) and (buffer[n+j]<=127) then text:=text+ char(buffer[n+j])
         else text:=text+char($90); {otherwise display a block char}
         {The hex part - turn lefdt and right halves of each character into a
          two character hex number}
         if (j mod 4=0) and (j>0) then hex:=hex+' ';
         hex:=hex+hexchars[(buffer[n+j] and $F0) shr 4]
            + hexchars[(buffer[n+j] and $0F)];
         inc(byteswritten);
         if byteswritten>=bytesread then break;
       end;
       {pad out the last hex string if it is short}
       if length(hex)< hexsize then hex:=hex+stringofchar(' ',hexsize-length(hex));
       memo1.lines.add(hex+' '+text);
       if byteswritten>=bytesread then break;
     end;
   end;
end;

{*********** UpBtnCLick *************}
procedure TForm2.UpDownBtnClick(Sender: TObject);
{User clicked and up or down button}
begin
  If sender = upbtn then  {up button clicked}
    if (curpage=0)  then beep
    else dec(curpage)
  else if curpage=maxpage then beep   {had to be down button}
       else inc(curpage);
  showpage;
end;


{***************** FormKeyDown ***************}
procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
{Form KeyPreview property is set to True, so we come here for any
keypress.  We'll handle PgUp, PgDn, CtrlPgUp,CtrlPgDn and Up and Dow arrow keys to
display a new page from the file}
  Shift: TShiftState);
begin
  If (key=vk_Next) or (key=vk_down) then
  begin
    if ssCtrl in shift then  curpage:=maxpage
    else if curpage<maxpage then inc(curpage) else beep;
    showpage;
 end
 else if (key=vk_Prior) or (key=vk_up) then
 begin
   if ssctrl in shift then  curpage:=0
   else if curpage>0 then dec(curpage) else beep;
   showpage;
  end;
end;

{************ FormResize *************}
procedure TForm2.FormResize(Sender: TObject);
{Resize the buttons, the panel and the memo1 display when the form is resized}
begin
  okbtn.top:=clientheight-okbtn.height-5;
  panel1.left:=clientwidth-panel1.width;
  memo1.width:=panel1.left-memo1.left-5;
  memo1.height:=OKBtn.top-memo1.top- 5;
  {position the buttons and label at 1/4, 1/2 and 3/4 o the panel height}
  upbtn.top:=panel1.height div 4;
  downbtn.top:=panel1.height div 2;
  label1.top:=3*panel1.height div 4;
  setuppage;
end;

{************* FormDeactivate ************}
procedure TForm2.FormDeactivate(Sender: TObject);
{Free the file stream}
begin
  f_in.free;
end;

end.
