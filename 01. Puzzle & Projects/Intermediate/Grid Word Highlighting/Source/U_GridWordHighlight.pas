unit U_GridWordHighlight;
{Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Demo showing one way to highlight occurrences of a specific word within a
 StringGrid (or DBGrid)}

{March, 2018: Version 1.1 removes the Grid1SetEditText routine which is no
longer needed and was incompatible with DBGrid controls.  Oher routines should
work fine with DBGrids. }


interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, Dialogs, Grids,
  Strutils, Graphics, DBGrids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Grid1: TStringGrid;
    FillWordsMemo: TMemo;
    RefillBtn: TButton;
    Label1: TLabel;
    LoadBtn: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    FillWordEdt: TEdit;
    procedure StaticText1Click(Sender: TObject);
    procedure RefillBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FillWordEdtClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FillWordsMemoChange(Sender: TObject);
    procedure FillWordEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  public
    highlightword:string;
    modified:BOOLEAN;
    maxcolwidths:array of integer;
    Function chkModified:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  delims:set of char=[' ',',',':','$','?','!','(',')','=']; {these mark word separators}

{*********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  modified:=false;
  Opendialog1.initialdir:=extractfilepath(application.exename);
  Savedialog1.initialdir:=Opendialog1.initialdir;
  {Tricky - grid canvas font is not initially assigned to the grid font
   so we do it here in order adjust column widths to fit cell contents later}
  grid1.canvas.font.assign(grid1.font);
  setlength(maxcolwidths, grid1.colcount);
end;

{*************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
{initial fill of the grid - doesn't work from FormCreate!}
begin
  RefillBtnClick(sender);
end;

{*********** RefillBtnClick *************}
procedure TForm1.RefillBtnClick(Sender: TObject);
{Reload the grid with randomly chosen words from the master word/phrase list}
var
  c,r:integer;
  s:string;
  n, maxn:integer;

begin
  with grid1 do
  begin
    for c:=0 to colcount-1 do
    begin
      maxn:=0;
      for r:=0 to rowcount-1 do
      begin
        with fillwordsMemo do
        s:=lines[random(lines.count)];
        n:=canvas.textwidth(s);
        if N>maxn then  maxn:=n;
        cells[c,r]:=s;
      end;
      colwidths[c]:=maxn + 4;
      maxcolwidths[c]:=colwidths[c];{used later if highlights change pixel width of a cell}
      //memo1.lines.add(format('Col %d refill btn width: %d',[c,maxcolwidths[c]]));
    end;
    fillWordEdtclick(sender); {now highlight if necessary}
  end;
end;


{************ FillWordEdtClick ***********}
procedure TForm1.FillWordEdtClick(Sender: TObject);
{set the current text as the highlight word, reset column widths if necessary}
var c:integer;
begin
  HighLightWord:=uppercase(FillwordEdt.text);
  Grid1.invalidate; {force redraw of grid with new highlight word}
  {"Invalidate" just issues the repaint message, we need to let the massges get processed
   before checking new column widths}
  application.processmessages;
  {Now adjust column widths if necessary}
  with grid1, canvas do
  begin
    for c:=0 to colcount-1 do
    begin
      //memo1.lines.add(format('Fillword col %d colw: %d, maxcw %d',[c,colwidths[c],maxcolwidths[c]]));
      if maxcolwidths[c] >colwidths[c]  then
      begin
        colwidths[c]:=maxcolwidths[c];
        //memo1.lines.add('Colwidth changed');
      end;
    end;
  end;
end;

{************ Grid1DrawCell ************}
procedure TForm1.Grid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw cell displays the given highlightWord in Bold red font}
  var
  s,su,part:string;
  n,n2,x,y:integer;
  savecolor:TColor;
  savestyle:TFontstyles;
begin
  with grid1, canvas do
  begin
    rectangle(rect);
    s:=(cells[acol,arow]);
    x:=rect.left+4;
    y:=rect.top+4;
    n:=0;

    su:=uppercase(s);
    n:=pos(highlightword,su); {N=position of 1st letter of highlight word}
    if n>0 then
    begin
      n2:=n+length(highlightword);  {n2=position of next character after highlight}
      {Highlight word must touch one end of text or be between delimiters}
      if ((n>1) and (not (su[n-1] in delims)))
        or ((n2<length(s)) and (not(s[n2] in delims)))
      then  canvas.textout(x,y,s) {otherwise normal display}
      else {highlight display in effect}
      with canvas do
      begin {display 3 pieces (1st part @ normal + highlighted word + rest @ normal}
        rectangle(rect);
        savecolor:=font.color; {save to restore font stuff later}
        savestyle:=font.style;
        part:=copy(s,  1,n-1);  {1st part}
        textout(x,y,part);
        x:=x+textwidth(part);
        part:=copy(s,n,length(highlightword)); {highlight part}
        font.color:=clred;     {restore font stuff}
        font.style:=[fsBold, fsItalic]; {last part}
        textout(x,y,part);
        x:=x+textwidth(part);
        font.color:=savecolor;
        font.style:=savestyle;
        part:=copy(s,n2,length(s)-n2+1);
        textout(x,y,part);
        x:=x+textwidth(part)-rect.left+8;
        if x>maxcolwidths[acol] then
        begin {save to to change outside of this exit}
          maxcolwidths[acol]:=x;
          //memo1.lines.add(format('Maxcolwidths changed to %d',[x]));
        end;
      end
    end
    else
    begin
       textout(x,y,s);{no match on HighlightWord}
    end;
  end;
end;




(*
{************* Grid1SetEdttext ************}
procedure TForm1.Grid1SetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
{Adjust column width if a user change to a grid cell makes it wider than the
 current column width}
var
  n:integer;
begin

  with TStringGrid(sender), canvas  do
  begin
    n:=textwidth(value)+4;
    if n>colwidths[acol] then colwidths[acol]:=n;
  end;

end;
*)


{*************** LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
{Load a new phraselist }
var
  n1,n2:integer;
  s:string;
begin
  if chkModified then
  if opendialog1.execute  then
  begin
    fillwordsmemo.lines.loadfromfile(opendialog1.filename);
    savedialog1.filename:=opendialog1.filename;
    modified:=false;
    refillbtnclick(sender);
    {Set hightlight word as the first word of the first cell}
    s:=grid1.cells[0,0];
    n1:=0;
    while (N1<length(s)) and (s[n1+1] in delims) do inc(n1);
    n2:=n1;
    while (N2<=length(s)) and (not (s[n2] in delims)) do inc(n2);
    fillwordEdt.text:=copy(s,n1,n2-n1-1);
    fillwordEdtClick(sender);
  end;
end;

{************ SaveBtnClick ************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save current phraselist }
begin
  If savedialog1.execute
  then
  begin
    fillwordsmemo.lines.savetofile(savedialog1.filename);
    modified:=false;
  end;
end;

{************ Form1CloseQuery *********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:=chkModified;
end;


{********** ChkModified *********}
function TForm1.chkModified:boolean;
{Common routine to give user a chance to save changes when they are about to be lost}
var r:integer;
begin
  result:=true;
  If modified  then
  begin
    r:=messagedlg('Save phrase list first?', mtConfirmation,[mbYes,mbNo,mbCancel],0);
    if r=mrYes then Savebtnclick(self)
    else if r=mrNo then modified:=false
    else result:=false;  {User clicked cancel button}
  end;
end;

{*********** FillWordsMemoChange ************}
procedure TForm1.FillWordsMemoChange(Sender: TObject);
{Flag the phrase memo as changed}
begin
  modified:=true;
end;

{************ FillWordEdtKeypress *************}
procedure TForm1.FillWordEdtKeyPress(Sender: TObject; var Key: Char);
{Intercept Enter key and treat it like a click}
begin
  if key=#13 then
  begin
    key:=char(0);
    fillwordEdtclick(sender);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




end.

