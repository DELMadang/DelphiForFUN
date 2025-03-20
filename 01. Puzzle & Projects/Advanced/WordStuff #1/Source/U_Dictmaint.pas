unit U_Dictmaint;
 {Copyright  © 2000-2016, Gary Darby,  www.DelphiForFun.org
  This program may be used or modified for any non-commercial purpose
  so long as this original notice remains in place.
  All other rights are reserved
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, UDict, Grids, ExtCtrls, ComCtrls, Menus, Buttons ;

Const
  Prechecked=true;
  Compressed=true;
type
  Tdictemp=class(TDic);  {to gain access to protected elements of TDic}
  TDicMaintForm = class(TForm)
    Label1: TLabel;
    FindEdt: TEdit;
    WordGrid: TStringGrid;
    FindBtn: TButton;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    MinLenEdit: TEdit;
    MaxLenEdit: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    SaveDialog1: TSaveDialog;
    Dictionary1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    GroupBox1: TGroupBox;
    Shownormal: TCheckBox;
    Showabbrevs: TCheckBox;
    Showforeign: TCheckBox;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    ReSortBtn: TButton;
    ScanBtn: TButton;
    ABtn: TSpeedButton;
    Showcaps: TCheckBox;
    TextOpenDlg: TOpenDialog;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    abbreviation: TMenuItem;
    foreign: TMenuItem;
    Capitalized: TMenuItem;
    StatusBar1: TStatusBar;
    StaticText1: TStaticText;
    Label6: TLabel;

    procedure FormActivate(Sender: TObject);
    procedure FindEdtKeyPress(Sender: TObject; var Key: Char);
    procedure ScanBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WordGridKeyDown(Sender: TObject; var Key: Word;
                              Shift: TShiftState);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure checkboxclick(Sender: TObject);
    procedure WordGridDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ReSortBtnClick(Sender: TObject);
    procedure MinLenEditChange(Sender: TObject);
    procedure MaxLenEditChange(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure ABtnClick(Sender: TObject);
    procedure WordGridKeyPress(Sender: TObject; var Key: Char);
    procedure Delete1Click(Sender: TObject);
    procedure WordGridContextPopup(Sender: TObject; MousePos: TPoint;
                                    var Handled: Boolean);
    procedure optionclick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    AppPath:string;
    start,stop:char;
    min,max:integer;
    DicName:string;
    initialized:boolean;
    letterbtn:array ['a'..'z'] of TSpeedButton;
    procedure AddWord(S: string);
    procedure RemoveWord(S: string);
    Procedure ReBuildList(s:string);
  end;

var
  DicMaintForm: TDicMaintForm;
  Dic:TDicTemp;
  heapstat:THeapStatus;

implementation

uses U_AttribEdit;
{$R *.DFM}
Const
  endset=[' ',',','.','!','?',')',':',';','/','"','''',#10]; {#10=linefeed}
  startset=[' ','(','!','"','''',#10];

function lowcase(c:char):char;
begin   result:=char(ord(c) or $20); end;

{****************** Local routines **********************}

function stripparens(w:string):string;
{strip '(A,F)' property display cell string}
var
  p:integer;
  rest:string;
 begin
   If w[length(w)]=')' then
   begin
     p:=pos('(',w);
    if p>0 then
    Begin
      rest:=copy(w,p,length(w)-p);
      w:=copy(w,1,p-1);
    End
    else showmessage('Error in word - no ''(''');
  end;
  result:=lowercase(w);
end;

function getword(var w:string):string;
{destructive getword - word is removed from w}
    var
      i:integer;
    Begin
      i:=1;
      result:='';
      If length(w)=0 then exit;
      if w[length(w)]<>',' then w:=w+',';
      while (i<=length(w)) and  (w[i]in startset) do inc(i);
      If w[i]=' ' then getword:=''
      else
      Begin
        If i>1 then w:=copy(w,i,length(w)-i+1);
        i:=1;
        while (i<=length(w)) and  (not (w[i] in endset)) do inc(i);
        getword:=copy(w,1,i-1);
        system.delete(w,1,i);
      End;
    End;


{***************TDicMaintForm.Rebuildlist *********}
Procedure TDicMaintForm.RebuildList(s:string);
{rebuild wordgrid display - after any addition or deletion}
const
  x:array[0..3] of string =('','(A)','(F)','(A,F)');
var
  dicword:string;
  i,j,newrow,newcol:integer;
  a,f,c:boolean;
Begin
  If not dic.dicloaded then exit;
  with dic, WordGrid do
  Begin
    if length(s)>0 then s:=lowercase(s) else s:='a';
    start:=s[1]; stop:=start;
    setrange(start,min,stop,max);
    letterbtn[s[1]].down:=true;
    rowcount:=(letterindex[succ(start)]-letterindex[start]) div colcount +1;
    i:=-1;
    row:=0;col:=0;  {start over w/grid location}
    newrow:=0; newcol:=0;
    while getnextword(dicword,a,f,c) do
    Begin
      if (a and showabbrevs.checked) then j:=1 else j:=0;
      if (f and showforeign.checked) then inc(j,2);
      dicword:=dicword+x[j];
      If (shownormal.checked and (not a) and (not f) and (not c))
         or (a and showabbrevs.checked)
         or (f and showforeign.checked)
         or (c and showcaps.checked)
      then
      Begin
        inc(i);
        if ansiStrComp(pchar(s),pchar(dicword))>=0 then
        begin
          newcol:=i mod colcount;
          newrow:=i div colcount;
        end;
        if c  then dicword[1]:=upcase(dicword[1]);
        cells[i mod colcount,i div colcount]:=dicword;
      End;
    End;
    row:=newrow;
    col:=newcol;
    {clear out display of final row}
    for j:= i+1 to (WordGrid.rowcount)*colcount -1 do
          WordGrid.cells[j mod colcount,j div colcount]:='';
  End;
  WordGrid.setfocus {invalidate};
  if dic.dicloaded then
  with statusbar1, dic do
  begin
    panels[0].text:=dicname;
    panels[1].text:='Normal '+ inttostr(totalcount-abbrevcount-foreigncount-capscount);
    panels[2].text:='Abbrevs '+ inttostr(abbrevcount);
    panels[3].text:='Foreign '+inttostr(foreigncount);
    panels[4].text:='Capitalized '+inttostr(capscount);
    panels[5].text:='Total '+inttostr(totalcount);
  end;
End;

{*************** TDicMaintForm.AddWord **************}
procedure TDicMaintForm.AddWord(S: string);
{add a word to the dictionary}
var
  a,f,c:boolean;
begin
  s:=lowercase(s);
  If not dic.lookup(s,a,f,c) then
  Begin
    start:=s[1]; stop:=s[1];
    {initialize abbrec, foreign, caps to off}
    a:=false;  f:=false; c:=false;
    if length(s)>max then max:=length(s);
    {only ask user about properties if some are being displayed}
    if (showabbrevs.checked or showforeign.checked or showcaps.checked) then
    with editworddlg do
    begin
      okBtn.caption:='Add';
      nobtn.visible:=true;
      label1.caption:=s;
      if (showmodal=MROK) then
      begin
        a:=checkbox1.checked;
        f:=checkbox2.checked;
        c:=checkbox3.checked;
      end;
    end;
    If dic.addword(s,a,f,c) then Rebuildlist(s)
    else showmessage('Word '+s+ ' not added (too long?)');
  End
  else showmessage('Word ' + s +' already exists.');
end;

{*************** TDicMaintForm.FindBtnClick ***************}
procedure TDicMaintForm.FindBtnClick(Sender: TObject);
{find and select word in findedt.text}
var
  a,f,c:boolean;
  s:string;
begin
  s:=lowercase(FindEdt.text);
  if dic.IsValidword (s) then
    If dic.lookup(s,a,f,c) then
    Begin
      start:=s[1]; stop:=s[1];
      If min>length(s) then min:=length(s);
      If max<length(s) then max:=length(s);
      rebuildlist(s);
      with WordGrid do
      If (row<toprow) or (row>=toprow+visiblerowcount)
      then WordGrid.toprow:=WordGrid.row;
      findedt.text:='';
    End
    else showmessage(Findedt.text +' not found')
  else showmessage(FindEdt.text +'is not a valid word');
  findedt.selstart:=0;
  findedt.sellength:=length(findedt.text);
end;

{*************** TDicMaintForm.FormActivate ****************}
procedure TDicMaintForm.FormActivate(Sender: TObject);
var
  c:char;
begin
  if not initialized then {only one form - shouldn't need this test(?)}
  begin
    Dic:=TDicTemp.Create(prechecked);
    Apppath:=ExtractFilePath(Application.ExeName);
    letterbtn['a']:=abtn;
    for c:='b' to 'z' do
    begin
      letterbtn[c]:=TSpeedButton.create(self);
    with letterbtn[c] do
    begin
      parent:=abtn.parent;
      font:=abtn.font;
      left:=abtn.left+(ord(c)-ord('a'))*abtn.width;
      top:=abtn.top;
      width:=abtn.width;
      height:=abtn.height;
      groupindex:=abtn.groupindex;
      caption:=c;
      onclick:=abtnclick;
    end;
    end;
    load1click(sender);
  end;
  initialized:=true;
end;

{*************** TDicMaintForm.FindEdtKeyPress *****************}
procedure TDicMaintForm.FindEdtKeyPress(Sender: TObject; var Key: Char);
{incremental display - move cels with each character entered}
{treat Enter as a click }
var
  s:string;
  i,j:integer;
begin
  s:=lowercase(findedt.text);
  if lowcase(key) in ['a'..'z'] then
  begin
    {if first character or cell is beyond entry
     then start scan at beginning of grid}
    if    (length(findedt.text)=1)
      or  ((length(s)>0) and (lowercase(wordgrid.cells[0,0])>s)) then
    begin
      start:=s[1];
      stop:=start;
      min:=1;
      max:=dic.maxwordlength;
      rebuildlist(s);
    end
    {otherwiswe- just keep searching}
    else with wordgrid do
    begin
      i:=row;
      j:=0;
      while i< rowcount-1 do
      begin
        j:=0;
        while j<colcount-1 do
        if s<=cells[j,i] then break
         else inc(j);
        if s<=cells[j,i] then break
        else inc(i);
      end;
      col:=j;
      row:=i;
    end;
  end
  else
  if key=#13 then
  Begin
   FindBtnclick(sender);
   key:=#00;
 End;
end;

{***************TDicMaintForm.ScanBrnClick ******************}
procedure TDicMaintForm.ScanBtnClick(Sender: TObject);
{Scan a text file for new words}
var
  startletter:char;

    function processline(line:string):boolean;
    {process a line during scanline}
    {return true if user says quit}
     var
      quit:boolean;
      dicword:string;
      r:word;
      a,fo,c:boolean;
      begin
        quit:=false;
        repeat
          dicword:=getword(line);
          if (length(dicword)>0) and (dicword[1] in [startletter ..'z']) then
          if (dic.IsValidword(dicword)) and (length(dicword)>0)
              and (not dic.lookup(dicword,a,fo,c)) then
          Begin
            with editworddlg do
            Begin
              OKBtn.caption:='Add';
              Nobtn.caption:='Skip';
              nobtn.visible:=true;
              label1.caption:=dicword;
              r:= editworddlg.showmodal;
              if r=MROK then
              Begin
                dic.addword(dicword,checkbox1.checked,
                                              checkbox2.checked,checkbox3.checked);
                start:=dicword[1]; stop:=dicword[1];
                If min>length(dicword) then min:=length(dicword);
                If max<length(dicword) then max:=length(dicword);
                rebuildlist(dicword);
                dic.setrange('a',1,'z',dic.maxwordlength);
              End
              else if r=mrcancel then quit:=true;
            end;
          end;
        until (length(line)=0) or (quit);
        result:=quit;
      End;

var
  f:textfile;
  quit:boolean;
  savemin,savemax:integer;
  savestart,savestop:char;
  saveword:string;
  line:string;
begin {scanbtnclick}
  with TextOpenDlg do
  begin
    if execute and fileexists(filename) then
    Begin
      assignfile(f,filename);
      reset(f);
      quit:=false;
      {save range settings}
      savemin:=min;
      savemax:=max;
      savestart:=start;
      savestop:=stop;
      with wordgrid do saveword:=cells[col,row];
      startletter:=inputbox('Enter start scan letter','Letter','a')[1];
      dic.setrange(startletter,1,'z',dic.maxwordlength);
      readln(f,line);
      closefile(f);
      if length(line)<255 then {normal file}
      begin
        screen.cursor:=crHourGlass;
        reset(f);
        while (not eof(f)) and (not quit) do
        Begin
          readln(f,line);
          line:=lowercase(line);
          quit:=processline(line);
        end;
        closefile(f);
        screen.cursor:=crdefault;
      end
      else {long lines - use blockread}

      showmessage('Lines too long -'+
                  #13+'Reformat file so that lines are less than 255 characters');
      {restore range settings}
      start:=savestart;
      stop:=savestop;
      min:=savemin;
      max:=savemax;
      dic.setrange(start,min,stop,max);
      rebuildlist(saveword);
    end;
  end;
end; {scanbtnclick}

{*************** TDicMaintForm.WordGrid1DblClick **************}
procedure TDicMaintForm.WordGridDblClick(Sender: TObject);
{original way to edit properties retained
  popupmenu is now available as alternative}
var
  w:string;
  rowsave:integer;
  a,f,c:boolean;
begin
  with WordGrid do
  Begin
    w:=stripparens(cells[col,row]);
    with editworddlg do
    Begin
      OkBtn.caption:='OK';
      nobtn.visible:=false;
      label1.caption:=w;
      if dic.lookup(w,a,f,c) then
      begin
        checkbox1.checked:=a;
        checkbox2.checked:=f;
        checkbox3.checked:=c;
        if showmodal=mrOK then
        Begin
          dic.removeword(w);
          dic.addword(w,checkbox1.checked,checkbox2.checked,checkbox3.checked);
          rebuildlist(w);
        End;
      end
      else showmessage('Dictionary error - word '+w+' not found');
    End;
    rowsave:=row
  end;
  findedt.text:='';
  rebuildlist(w);
  WordGrid.toprow:=rowsave;
end;

{*************** TDicMaintForm.RemoveWord ****************}
procedure TDicMaintForm.RemoveWord(S:string);
{delete word s}
var
  a,f,c:boolean;
  n:integer;
  saverow,savecol:integer;
begin
  with dic do
  Begin
    n:= pos('(',s);
    if n>0 then s:=copy(s,1,n-1);
    s:=lowercase(s);
    If lookup(s,a,f,c) then
      if messagedlg('Remove '+s+'?',mtconfirmation, [mbyes,mbno],0)=mryes
      then
      with WordGrid do
      Begin
        saverow:=row;
        savecol:=col;
        dic.removeword(s);
        rebuildlist(s);
        col:=savecol;
        row:=saverow;
      End;
  End;
end;

{*************** TDicMaintForm.FormClose *******************}
procedure TDicMaintForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   if dic.dicdirty then dic.checksave;
end;

{***************TDicMaintForm.WordGridKeyDown ********************}
procedure TDicMaintForm.WordGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{key pressed when wordgrid has focus - could be insert, delete or a letter}
var
  s:string;
  begin
    If key=vk_delete then
    begin
      with WordGrid do removeword(cells[col,row]);
      findedt.text:='';
    end
    else If key=vk_insert then
    with WordGrid do
    begin
      s:=lowercase(inputbox('Add a word','Enter a new word and press enter',findedt.text));
      if length(s)>0 then
      begin
        addword(s);
      end;
      findedt.text:='';
    end
    else if key=vk_return then findedt.text:='';
  end;

{***************TDicMaintForm.Load1Click ******************}
procedure TDicMaintForm.Load1Click(Sender: TObject);
begin
  If not assigned(dicform) then dicform:=TDicform.create(self);
  with dicform.opendialog1 do
  begin
    If initialdir='' then initialdir:=apppath;
    if execute then
    begin
      cursor:=crHourGlass;
      refresh;
      Dic.loadDicfromfile(filename);
      dicname:=filename;
      caption:='Dictionary Maintenance: '+dicname;
      start:='a'; stop:='a';
      min:=1; max:=31;
      abtn.down:=true;
      abtnclick(abtn);
      cursor:=crDefault;
    end;
  end;
end;

{***************TDicMaintForm.Save1Click ******************}
procedure TDicMaintForm.Save1Click(Sender: TObject);
{If extension is txtthe save umcompressed file
 otherwise save compressed format}
begin
  if lowercase(extractfileExt(dicname))='.txt'
  then Dic.SaveDicToTextFile(dicname)
  else Dic.SaveDicToFile(dicname);
end;

{***************TDicMaintForm.CheckBoxClick ****************}
procedure TDicMaintForm.checkboxclick(Sender: TObject);
{User changed a display option radio button}
var
  s:string;
begin
   with WordGrid do
   begin
     {if current is is on a blank cell (end of words), then use first}
     if length(cells[col,row])=0 then s:=cells[0,0]
     else s:=cells[col,row];
     rebuildlist(s);
   end;
end;

{***************TDicMaintForm.FormCloseQuery ***************}
procedure TDicMaintForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var mr:integer;
begin
  canclose:=true;
  if dic.dicdirty then
  begin
    mr:=dic.checksave;
    if mr=mrcancel then canclose:=false;
  end;
end;

{***************TDicMaintForm.ReSortBtnClick *******************}
procedure TDicMaintForm.ReSortBtnClick(Sender: TObject);
var
  saveword:string;
begin
  with WordGrid do
  begin
    saveword:=cells[col,row];
    dic.resortrange;
    rebuildlist(saveword);
  end;
end;

{***************TDicMaintForm.MinLenEditChnage ******************}
procedure TDicMaintForm.MinLenEditChange(Sender: TObject);
begin
  if not initialized then exit;
  min:=strtointdef(minlenedit.text,1);
  {if initialized then} {exit is called during creation - before we're ready}
  with WordGrid do
  rebuildlist(cells[col,row]);
end;

{***************TDicMaintForm.MaxLenEditChnage ***************}
procedure TDicMaintForm.MaxLenEditChange(Sender: TObject);
begin
  if not initialized then exit;
  max:=strtointdef(maxlenedit.text,dic.maxwordlength);
  with WordGrid do
  rebuildlist(cells[col,row]);
end;

{*************** TDicMaintForm.SaveAs1Click *************}
procedure TDicMaintForm.SaveAs1Click(Sender: TObject);
var
  s:string;
begin
  with savedialog1 do
  begin
    initialdir:=extractfilepath(dicname);
    filename:=extractfilename(dicname);
    if execute then
    begin
      s:= lowercase(extractfileExt(filename));
      if (filterIndex=2) and (s<>'.txt')
       and (messagedlg('Save as .txt type?',mtconfirmation,[mbYes,mbNo],0)=mryes)
       then filename:=changefileext(filename,'.txt');
      if s='.txt' then Dic.SaveDicToTextFile(filename)
      else Dic.SaveDicToFile(filename);
    end;
  end;
end;

{*************** TDicMaintForm.ABtnClick **************}
procedure TDicMaintForm.ABtnClick(Sender: TObject);
{user clicker a letter speedbutton - go there}
begin
  start:=  TSpeedButton(sender).caption[1];
  stop:=start;
  rebuildlist(start);
end;

{*************** TDicMaintForm.WordGridKeyPress ***************}
procedure TDicMaintForm.WordGridKeyPress(Sender: TObject; var Key: Char);
{implement incremental search if letter key pressed}
begin
  if lowcase(key) in ['a'..'z'] then
  begin
    findedt.text:=findedt.text +lowcase(key);
    findedtkeypress(sender,key);
  end;
end;

{*************** TDicMaintForm.Delete1Click ****************}
procedure TDicMaintForm.Delete1Click(Sender: TObject);
{delete a word}
begin
  with WordGrid do removeword(cells[col,row]);
  findedt.text:='';
end;

{*************** TDicMaintForm.WordGridContextPopup ***********}
procedure TDicMaintForm.WordGridContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var
  a,f,caps:boolean;
  c,r:integer;
begin
   with popupmenu1, wordgrid  do
   begin
     dic.lookup(cells[col,row],a,f,caps);
     abbreviation.checked:=a;
     foreign.checked:=f;
     capitalized.checked:=caps;
     {treat right click as a select}
     mousetocell(mousepos.x,mousepos.y,c,r);
     col:=c;
     row:=r;
   end;
end;

{*************** TDicMaintForm.OptionClick ***************}
procedure TDicMaintForm.optionclick(Sender: TObject);
{User changed abbrev, foreign, or caps property of word}
{remove it and put it back with new properties}
var
  w:string;
begin
  with sender as tmenuitem do checked:=not checked;
  with wordgrid do w:=stripparens(wordgrid.cells[col,row]);
  dic.removeword(w);
  with popupmenu1 do
  dic.addword(w,abbreviation.checked,foreign.checked,capitalized.checked);
  rebuildlist(w);
end;

procedure TDicMaintForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

