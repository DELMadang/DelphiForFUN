unit U_TextSearch2;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, shellapi, DFFUtils, Inifiles;

type
  TForm1 = class(TForm)
    Button1: TButton;
    GoBtn: TButton;
    Memo1: TMemo;
    RichEdit1: TRichEdit;
    OpenDialog1: TOpenDialog;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    WholeWords: TCheckBox;
    CaseSensitive: TCheckBox;
    SearchString: TEdit;
    GroupBox2: TGroupBox;
    LeftBox: TCheckBox;
    StringBox: TCheckBox;
    RightBox: TCheckBox;
    GroupBox3: TGroupBox;
    OutputNonMatchedBox: TCheckBox;
    OutputMatchedBox: TCheckBox;
    ShowLinesBox: TCheckBox;
    SaveLinesBox: TCheckBox;
    Memo2: TMemo;
    SaveDialog1: TSaveDialog;
    InFileLbl: TLabel;
    Memo3: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    path:string;
    filename:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);

begin
  if opendialog1.execute
  then
  begin
    filename:=opendialog1.filename;
    savedialog1.InitialDir:=extractfilepath(filename);
    infilelbl.Caption:=filename;
    richedit1.clear;
    richedit1.lines.add('Search outputs display here');
    memo3.clear;
    memo3.lines.add('Search statistics display here');
  end;

  (*
  else
  begin
    filename:='';
    infilelbl.caption:='No file selected';
  end;
  *)

end;

var delims:set of char=[' ', ',', '.', ';', ':', '(', ')', '<', '>'];
function isword(start,stop:integer; s:string):boolean;
begin
  if (
      ((start>=1) and  (s[start]in delims))
       or (start<1)
     )
     and
     (
      ((stop<=length(s)) and  (s[stop]in delims))
        or (stop>length(s))
     )
     then result:=true
     else result:=false;
end;


procedure TForm1.GoBtnClick(Sender: TObject);
var
  i,n, start:integer;
  f, outf:textfile;
  line,line2,outline:string;
  search:string;
  incount, matchedcount, outcount:integer;

begin
  {1.}
  if (filename='') or (not fileexists(filename)) then
  begin
    showmessage('Select a valid input file first.');
    exit;
  end;
  if (not leftbox.Checked) and (not stringbox.Checked) and (not rightbox.checked) then
  begin
    if messagedlg('No text seleted to be kept for matched records.  Continue?',
                 mtconfirmation, [mbyes,mbno],0) = mrno then exit;
  end;
  if (not showlinesbox.Checked) and (not savelinesBox.Checked) then
  begin
    if messagedlg('No results selected to be displayed or saved.  Continue?',
                 mtconfirmation, [mbyes,mbno],0) = mrno then exit;
  end;
  richedit1.clear;
  memo3.Clear;
  assignfile(f,filename);
  reset(f);
  matchedcount:=0;
  incount:=0;
  outcount:=0;
  if  savelinesbox.Checked then
  begin {select and open an output file}
    If   savedialog1.execute then
    begin
      if savedialog1.filename=opendialog1.filename then
      begin
        Showmessage('Output file name must be different than input file name.');
        exit;
      end;
      assignfile(outf, savedialog1.filename);
      rewrite(outf);
    end
    else
    begin
      showmessage('No output file selected, "Write outputs" checkebox reset');
      SaveLinesBox.Checked:=false;
    end;
  end;

  if not casesensitive.checked then search:=uppercase(searchstring.text)
  else search:=searchstring.text;

  while not eof(f) do
  begin
    readln(f,line);
    inc(incount);
    if not casesensitive.checked then line2:=uppercase(line)
    else line2:=line;
    n:=pos(search,line2);
    if n>0 then inc(matchedcount);
    if (n>0) and outputmatchedBox.checked then
    begin
      if (not wholewords.checked) or
      ((wholewords.checked) and (isword(n-1,n+length(search),line)))
      then  {match!}
      begin
        inc(outcount);
        outline:='';
        if leftbox.Checked then outline:=copy(line,1,n-1);
        if stringbox.Checked then outline:=outline + search;
        start:=n+length(search);
        if rightbox.Checked then outline:=outline+copy(line,start, length(line)-start+1);
        if savelinesbox.checked then writeln(outf,outline);
        If showlinesbox.checked  then
        with richedit1 do
        begin
          lines.add(outline);
          if stringbox.checked then
          begin
            if leftbox.Checked then selstart:=length(text)-length(outline)+n-3 {lines end with CR LF, so subtract}
            else selstart:=length(text)-length(outline)-3;
            selLength:=length(search); selattributes.style:=[fsbold];
          end;

          (*  {original version w/o outputs bolded multiple occurrences}
          while n<>0 do
          begin
            selstart:=length(text)-length(line)+n-3; {lines end with CR LF, so subtract}
            selLength:=length(search); selattributes.style:=[fsbold];
            // {erase that hit in line2 copy so that we can check for more occurrences}
            for i:=n to n+length(search)-1 do line2[i]:=CHAR($01);
            n:=pos(search,line2);
          end;
          *)
          //if showhits.checked then lines.add(' ');
        end;
      end;
    end
    else if (n=0) and outputnonmatchedBox.checked then
    begin
      inc(outcount);
      if showlinesbox.checked then richedit1.lines.add(line);
      if savelinesbox.Checked then  writeln(outf,line);
    end;
    //scrolltotop(tmemo(richedit1));
  end;
  with memo3,lines do
  begin
    add('');
    add('Input file: '+filename);
    add(format('%d records read',[Incount]));
    if (length(searchstring.text)>0) then
    begin
      add('Searching for '+searchstring.text);
      if  matchedcount=0 then add('No matches found')
      else if matchedcount=1 then add('1 match found')
      else add(format('%d matches found',[matchedcount]));
    end;
    if outcount>0 then
    begin
      if (showlinesbox.checked) then add(format('%d records displayed',[outcount]));
      if (savelinesbox.checked) then
      begin
         add(format('%d records written to output file',[outcount]));
         add('    ' + savedialog1.FileName);
      end;
    end
    else add('No lines output');
    scrolltotop(memo3);
  end;
  closefile(f);
  if savelinesbox.Checked then closefile(outf);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini:TIniFile;
begin
  path:=extractfilepath(application.ExeName);
  ini:=tinifile.create(path+'TextSearch.ini');
  with ini do
  begin
    WholeWords.checked:=readBool('Boxes','WholeWords',false);
    Casesensitive.checked:=readBool('Boxes','CaseSensitive',false);
    LeftBox.checked:=readBool('Boxes','LeftBox',True);
    StringBox.checked:=readBool('Boxes','StringBox',True);
    RightBox.checked:=readBool('Boxes','RightBox',True);
    OutputNonMatchedBox.checked:=readBool('Boxes','OutputNonMatchedBox',True);
    OutputMatchedBox.checked:=readBool('Boxes','OutputMatchedBox',True);
    ShowLinesBox.checked:=readBool('Boxes','ShowLinesBox',True);
    SaveLinesBox.checked:=readBool('Boxes','SaveLinesBox',True);
  end;
  ini.free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini:TIniFile;
begin
  ini:=tinifile.create(path+'TextSearch.ini');
  with ini do
  begin
    WriteBool('Boxes','WholeWords',WholeWords.checked);
    WriteBool('Boxes','CaseSensitive',Casesensitive.checked);
    WriteBool('Boxes','LeftBox',LeftBox.checked);
    WriteBool('Boxes','StringBox',StringBox.checked);
    WriteBool('Boxes','RightBox',RightBox.checked);
    WriteBool('Boxes','OutputNonMatchedBox',OutputNonMatchedBox.checked);
    WriteBool('Boxes','OutputMatchedBox',OutputMatchedBox.checked);
    WriteBool('Boxes','ShowLinesBox',ShowLinesBox.checked);
    WriteBool('Boxes','SaveLinesBox',SaveLinesBox.checked);
  end;
  ini.free;
  Action:=caFree;
end;

end.
