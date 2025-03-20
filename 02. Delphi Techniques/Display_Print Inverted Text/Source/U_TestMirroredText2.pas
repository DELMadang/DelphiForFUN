unit U_TestMirroredText2;
{Copyright  © 2004-2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {Experiments in text display and printing, right-side-up and upside-down }
 {And auto-scrolling}

 {Version 2.0 adds ability to display transformed text in full screen mode.
  Printing also now will display oin multiple pages.
  and new text files can be loaded. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, printers, shellAPI, ComCtrls, DFFUtils;

type
  TForm1 = class(TForm)
    PrintDialog1: TPrintDialog;
    StaticText1: TStaticText;
    FontDialog1: TFontDialog;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    ScrollBox2: TScrollBox;
    Memo1: TMemo;
    Panel1: TPanel;
    Modegrp: TRadioGroup;
    Label3: TLabel;
    Edit1: TEdit;
    MarginsUD: TUpDown;
    FontBtn: TButton;
    PrintBtn: TButton;
    DisplayBtn: TButton;
    ScrollUpBtn: TButton;
    StopBtn: TButton;
    ScrollDownBtn: TButton;
    Scrollspeed: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    MaximizeBtn: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    ColorDialog1: TColorDialog;
    procedure setmargins(m:TMemo; L,R:integer);
    procedure DisplayBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FontBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MarginsUDChangingEx(Sender: TObject;
             var AllowChange: Boolean; NewValue: Smallint;
              Direction: TUpDownDirection);
    procedure ScrollBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure MaximizeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    public
      lineheight,externalLeading:integer;
      topmargin:integer;
      avgcharwidth:integer;
      Leftmargin, RightMargin:integer;
      firstentry:boolean;
      procedure SetParams(m:TMemo);
      procedure SetParams2(m:TMemo);
      procedure Drawlines(Form:TForm; Memo:TMemo; canvasout:TCanvas;
                          fromline,toline,pagewidth, pageheight:integer);
  end;

var
  Form1: TForm1;

implementation

uses U_FullScreen2;

{$R *.DFM}

{************ Setmargins *********}
procedure TForm1.setmargins(m:TMemo; L,R:integer);
{change the margins in a Tmemo}
begin
  setMemoMargins(m,L,-1,R,-1);
  leftmargin:=L;
  rightmargin:=R;
end;

{************* FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin

  scrollbox1.doublebuffered:=true;
  scrollbox2.doublebuffered:=true;
  setmargins(memo1,marginsUD.position, marginsUD.position);
  reformatMemo(memo1); {necessary on initial entry since text may contain  hard line breaks}
  stopbtn.bringtofront;  {button it's invisible, but in back at design time.  We need it
                           in front when we do make it visible during auto-scroll}
  firstentry:=true;
  opendialog1.initialdir:=extractfilepath(application.exename);
end;


{*********** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  if firstentry then
  with fullscreen do
  begin
    {this should all happen automatically with alclient alignment,
    but it does not happen soon enough for our use here}
    show;  hide;
    image1.picture.bitmap.width:=image1.width;  {resizing doesn't adjust these,}
    image1.picture.bitmap.height:=image1.height; {so we have to do it }
    
    memo1.left:=0;
    memo1.top:=0;
    memo1.width:=image1.width;
    memo1.height:=image1.height;
    memo1.text:=self.memo1.text;
    memo1.font:=self.memo1.font;

    reformatmemo(memo1);
    firstentry:=false;
  end;
  windowstate:=wsmaximized; {also seems like window maximize should call form resize}
  formresize(sender); {but it doesn't, so we'll call it ourselves to resize scrollboxes}
end;



{******** SetParams ************}
procedure TForm1.SetParams(m:TMemo);
{extract some metrics about the current font for Tmemo}
var
  t:TTextMetric;
  b:Tbitmap;
begin
  {Get text metric fields}
  b:=TBitmap.create;
  b.canvas.font.assign(m.font);  {assign font to something with a canvas }
  Gettextmetrics(b.canvas.handle,t);  {so that we can get the text metrics}
  b.free;
  lineheight:=t.tmHeight;
  externalleading:=t.tmExternalLeading;
  //topmargin:=lineheight-t.tmascent -t.tmdescent;
  avgcharwidth:=t.tmAvecharWidth;
end;


{******** SetParams2 ************}
procedure TForm1.SetParams2(m:TMemo);
{extract some metrics about the current font for Tmemo for the fullscreen display}
var
  t:TTextMetric;
  b:Tbitmap;
  h:integer;
begin
  with fullscreen do
  begin
    {Get text metric fields}
    b:=TBitmap.create;
    b.canvas.font.assign(m.font);  {assign font to something with a canvas }
    Gettextmetrics(b.canvas.handle,t);  {so that we can get the text metrics}
    b.free;
    lineheight:=t.tmHeight;
    externalleading:=t.tmExternalLeading;
    //topmargin:=lineheight-t.tmascent -t.tmdescent;
    avgcharwidth:=t.tmAvecharWidth;

    {Set heights to display all lines}
    h:=topmargin+(m.lines.count+2)*lineheight; {set height of memo to show all lines}
    m.height:=h;
    image1.height:=h;
    image1.picture.bitmap.height:=h;
    image1.canvas.font.assign(m.font);
    scrollbox1.vertscrollbar.range:=h;
    scrollbox1.vertscrollbar.position:=0;
  end;
end;

{****************** Drawlines  *************}
Procedure TForm1.Drawlines(form:TForm; Memo:TMemo; canvasout:TCanvas;
                 fromline, toline,pagewidth, pageheight:integer);
{Show the memo text as specified in passed canvas and per current modegrp setting}
var
  i:integer;

  b:TBitmap;
  h:integer;
  tmargin:integer;
  printat:integer;

        procedure transformpage;
        var
          rin,rout:Trect;
        begin
          rout:=rect(0,0,pagewidth-1,pageheight-1);
          case modegrp.itemindex of
          0:{Normal}
            begin
              rin:=rout;
              canvasout.copyrect(rout, b.canvas, rin);
            end;
          1:{Flipped}
            Begin
              rin:=rout;
              rin.top:=rout.bottom;
              rin.bottom:=rout.top;
              canvasout.copyrect(rout, b.canvas, rin);
              if form=self then with self, Scrollbox1,vertscrollbar do position:=range-height
              else with fullscreen, Scrollbox1,vertscrollbar do position:=range-height;
            end;
          2:{Mirrored Left to Right}
            begin
              rin:=rout;
              rin.left:=rout.right;
              rin.right:=rout.Left;
              canvasout.copyrect(rout, b.canvas, rin);
            end;
          3:{Both - Flippd and Mirrored}
            begin
              rin.top:=rout.bottom;
              rin.bottom:=rout.top;
              rin.left:=rout.right;
              rin.right:=rout.Left;
              canvasout.copyrect(rout, b.canvas, rin);
              if form=self then
              with self, Scrollbox1,vertscrollbar do position:=range-height
              else with fullscreen, Scrollbox1,vertscrollbar do position:=range-height
            end;
          end; {case}
        end;


begin
  if form=self  then
  begin
    setparams(memo);
    {Set heights to display all lines}
    h:=topmargin+(memo.lines.count+2)*lineheight; {set height of memo to show all lines}
    memo.height:=h;
    image1.height:=h;
    image1.picture.bitmap.height:=h;
    image1.canvas.font.assign(memo.font);
    scrollbox1.vertscrollbar.range:=h;
    scrollbox1.vertscrollbar.position:=0;
    scrollbox2.vertscrollbar.range:=h;
    scrollbox2.vertscrollbar.position:=0;
    if pageheight=0 then pageheight:=memo1.height
  end
  else if form=fullscreen then
  begin
    setparams2(memo);
    pageheight:=fullscreen.memo1.height;
  end;
  {first copy the TMemo text unchanged to something with a canvas}
  {if drawing to monitor, pass pageheight 0 so we can set adjusted height}
  canvasout.font.assign(memo.font);
  b:=TBitMap.create;
  b.height:=pageheight;
  b.width:=pagewidth;
  b.handletype:=bmdib;
  b.canvas.font.assign(memo.font);
  b.canvas.brush.color:=memo.color;
  b.canvas.fillrect(rect(0,0,pagewidth,pageheight));
  {scale the font to canvas out size}
  with b.canvas.font do size:=size*canvasout.font.pixelsperinch div pixelsperinch;
  lineheight:=lineheight*canvasout.font.pixelsperinch div pixelsperinch;
  tmargin:=topmargin*canvasout.font.pixelsperinch div pixelsperinch;
  if printer.printing then
  begin
    printat:=tmargin;
    for i:=fromline to toline do
    begin
      if printat>pageheight-2*lineheight then
      begin
        transformpage;
        printer.newpage;
        b.canvas.fillrect(rect(0,0,b.width,b.height));  {clear the image}
        printat:=tmargin;
      end
      else inc(printat,lineheight);
      b.canvas.textout(leftmargin,printat,memo.lines[i] );
    end;
    transformpage;  {process last partial page}
  end
  else
  begin
     for i:=fromline to toline do
     b.canvas.textout(leftmargin,tmargin+i*lineheight,memo.lines[i] );
     transformpage;
  end;
  screen.cursor:=crhourglass;

  screen.cursor:=crdefault;
  b.free;
end;

{*************** DisplayBtnClick **********}
procedure TForm1.DisplayBtnClick(Sender: TObject);
{The most accurate printing is achieved by duplicating the canvas operations
 that were used to produce the orignal images or controls}
begin
  image1.picture.bitmap.width:=image1.width;  {resizing doesn't adjust these,}
  image1.picture.bitmap.height:=image1.height; {so we have to do it }
  drawlines(self,memo1,image1.canvas,0,memo1.lines.count-1,memo1.width,0);
end;

{*************** PrintBtnClick **********}
procedure TForm1.PrintBtnClick(Sender: TObject);
{The most accurate printing is achieved by duplicating the canvas operrations
 that were used to produice the orignal images or controls}
begin
  if PrintDialog1.Execute then
  begin
    with Printer do
    begin
      BeginDoc;
        drawlines(self,memo1,printer.canvas,0,memo1.lines.count-1,pagewidth,pageheight);
      EndDoc;
    end;
    with memo1, clientrect do drawlines(self,memo1,image1.canvas,0,lines.count-1,width,0);
  end;
end;

{*************** FontBtnClick ************}
procedure TForm1.FontBtnClick(Sender: TObject);
begin
  fontdialog1.font:=memo1.font;   {set initial font selection in dialog}
  if fontdialog1.execute then {change the font characteristics}
  begin
    memo1.font:=fontdialog1.font;
    image1.canvas.font:=memo1.font;
  end;
  displaybtnclick(sender);
end;

{*********** StaticText1Click *******}
procedure TForm1.StaticText1Click(Sender: TObject);
{Link to DFF homepage}
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{***************** MarginsUDChangingEx *************}
procedure TForm1.MarginsUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
{Adjust margins for displays }
begin
  with sender as TUpDown do
  If (newvalue<=max) and (newvalue>=min)
  then
  begin
    allowchange:=true;
    setmargins(memo1,MarginsUd.position, MarginsUd.position);
    displaybtnclick(sender);
  end;
end;

{*********** ScrollBtnclick **********8}
procedure TForm1.ScrollBtnClick(Sender: TObject);
{start scrolling up or down base on which button was clicked}
var incr:integer;

  function stoptest:boolean;
  {different stopping points depending on scroll direction}
  begin
    with scrollbox2, vertscrollbar do
    if sender=Scrolldownbtn then result:=position>=range-height
    else result:=position<=0;
  end;

begin  {scrollbtnclick}
  if sender=Scrolldownbtn then incr:=+1 else incr:=-1;
  scrollbox2.tag:=0;
  stopbtn.visible:=true;
  with scrollbox2,VertScrollBar do
  repeat
    with scrollspeed do sleep(max-position);
    position:=position+incr;
    if modegrp.itemindex mod 2 =0 then  {right-side up}
      with scrollbox1.vertscrollbar do position:=position+incr
    {else upside down, scroll opposite direction}
    else with scrollbox1.vertscrollbar do position:=position-incr;
    application.processmessages;
  until (tag<>0) or stoptest  or (scrollspeed.position=scrollspeed.min);
  Stopbtn.visible:=false;
end;

{************ StopBtnClick ************}
procedure TForm1.StopBtnClick(Sender: TObject);
{Set flag tested by auto-scrolling loop to stop operation}
begin
  scrollbox2.tag:=1;
end;

{*************** FormCloseQuery **************8}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  scrollbox2.tag:=1; {in case auto-scrolling is happpening}
  canclose:=true;
end;

{************ FormResize *************}
procedure TForm1.FormResize(Sender: TObject);
var n:integer;
begin
  n:=width-15;
  scrollbox2.width:=n div 2;
  scrollbox2.height:= panel1.top -scrollbox2.top;
  scrollbox2.left:=5;
  label1.left:=scrollbox2.left;
  scrollbox1.left:=10+scrollbox2.width;
  label2.left:=scrollbox1.left;
  scrollbox1.width:=scrollbox2.width;
  scrollbox1.height:=scrollbox2.height;

  displaybtnclick(sender);
end;

{********************* MaximizeBtnClick ***********}
procedure TForm1.MaximizeBtnClick(Sender: TObject);
begin
  with Fullscreen do
  begin
    show;
    setmargins(memo1,marginsUD.position, marginsUD.position);
    memo1.text:=self.memo1.text;
    memo1.font:=self.memo1.font;
    memo1.color:=self.memo1.color;
    reformatMemo(memo1); {necessary on initial entry since text may contain  hard line breaks}
    drawlines(fullscreen,memo1,image1.canvas,0,memo1.lines.count-1,image1.width,0);
  end;
end;

{************* LoadBtnClick ***********}
procedure TForm1.Button2Click(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    memo1.lines.loadFromFile(opendialog1.filename);
    displaybtnclick(sender);
  end;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  if colordialog1.execute then
  begin
    memo1.color:=colordialog1.color;
    displaybtnclick(sender);
  end;  
end;

end.

