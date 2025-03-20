unit U_FindReplace;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, FileCtrl, masks,
  IniFiles;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    DriveComboBox1: TDriveComboBox;
    Memo1: TMemo;
    DirectoryListBox1: TDirectoryListBox;
    Label1: TLabel;
    FindStrEdt: TEdit;
    Label4: TLabel;
    ReplaceStrEdt: TEdit;
    RecurseBox: TCheckBox;
    MatchCaseBox: TCheckBox;
    ActionRGrp: TRadioGroup;
    Label5: TLabel;
    MaskEdt: TEdit;
    GoBtn: TButton;
    Label6: TLabel;
    DirLbl: TLabel;
    Memo2: TMemo;
    BackupBox: TCheckBox;
    LineRGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure ActionRGrpClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  public
    filecount, filehitcount,linehitcount:integer;

    filemask:string;
    oldpattern,newpattern:string;
    flags:TReplaceFlags;
    Displaymemo:TMemo;
    searchsubs:boolean;
    ChangeOneLinePerFile:boolean;
    BackupChanged:boolean;
    displayonly:boolean;
    procedure GetFiles(startpath:string);


end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{************* FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
var
  ini:TInifile;
  path:string;
  drive:string;
begin  {load previous options or defailt if ini file not found}
  ini:=TInifile.Create(extractfilepath(application.ExeName)+'FindReplace.ini');
  with ini do
  begin
    {as distributed, drive and path will be missing and wile default to then
    execuatble location, the same location as the "Test.txt"  which other
    parameters are set up for testing}
     path:=extractfilepath(application.ExeName);
     drive:=path[1];
    {After the first run, drive and starting directory will exist and will be
     reloaded at startup}

    DriveComboBox1.Drive:=char(readstring('Options','Drive',drive)[1]);
    DirectoryListBox1.Directory:=readstring('Options','Directory',path);
    FindStrEdt.text:=readstring('Options','Find',FindStrEdt.text);
    ReplaceStrEdt.text:=readstring('Options','ReplaceWith',ReplaceStrEdt.text);
    MaskEdt.text:=readstring('Options','Mask',MaskEdt.text);
    RecurseBox.checked:=readBool('Options','Recurse',RecurseBox.checked);
    MatchcaseBox.checked:=readBool('Options','MatchCase',MatchcaseBox.checked);
    BackupBox.Checked:=readBool('Options','Backup',BackupBox.Checked);
    ActionRGrp.Itemindex:=readInteger('Options','ActionIndex',ActionRGrp.Itemindex);
    LineRGrp.Itemindex:=readInteger('Options','LineChgIndex',LineRGrp.Itemindex);
  end;
  ini.free;
end;

{************* GoBtnClick ***********}
 procedure TForm1.GoBtnClick(Sender: TObject) ;
 {trigger a search }
 var
   fc,lc:string;
 begin
   memo1.clear;
   tag:=0;
   filecount:=0;
   filehitcount:=0;
   linehitcount:=0;
   filemask:=maskEdt.text;
   oldpattern:=findstrEdt.Text;
   newpattern:=replacestredt.Text;
   flags:=[];
   if LineRGrp.itemindex=1 then flags:=flags+[rfreplaceall];
   If not MatchCaseBox.checked then flags:=flags+[rfIgnorecase];
   displaymemo:=Memo1;
   searchsubs:= recursebox.Checked;
   ChangeOneLinePerfile:=actionRgrp.itemindex=1;
   BackupChanged:=backupbox.checked;
   getfiles(directoryListBox1.Directory);
   with memo1, lines do
   begin
     if tag>0 then add('Search interrupted');
     add('Files scanned: ' +inttostr(filecount));
     if displayonly then
     begin
       fc:='Files flagged for change ';
       lc:='Lines flagged for change ';
     end
     else
     begin
       fc:='Files changed ';
       lc:='Lines changed ';
     end;
     add(fc+inttostr(filehitcount));
     add(lc +inttostr(linehitcount));
   end;
 end;


{****************** GetFiles ***************}
procedure TForm1.GetFiles(startpath:string);
{recursively read all file names from directory S and add them to FileList}
{this is a version tailored for performance by only saving a requested number of
 largest files found}
var
  F:TSearchrec;
  r:integer;
  maskext:string;
  UpFName:string;

    {------------ Scanfile -------------}
    procedure scanfile(filename:string);
    {Scan one file and change change and backup as options dictate}
    var
      inff,outff:textfile;
      backupfilename,path:string;
      line,s:widestring;
      lineschanged:integer;
      linecount:integer;

    begin
      if not displayonly then
      begin
        path:=extractfilepath(filename);
        backupfilename:=path+'Copy of '+extractfilename(filename);
        if fileexists(backupfilename) then deletefile(backupfilename);
        renamefile(filename, backupfilename);
        assignfile(inff,backupfilename);
        assignfile(outff,filename);
        rewrite(outff);
      end
      else assignfile(inff,filename);

      reset(inff);

      lineschanged:=0;
      linecount:=0;
      while not eof(inff) do
      begin
        readln(inff,line);
        inc(linecount);
        if (not changeOneLineperFile) or (ChangeOneLinePerFile and (lineschanged=0))
        then
        begin
          s:=stringreplace(line,oldpattern,newpattern,flags);
          if not sametext(s,line)  then
          with displaymemo, lines do
          begin
            inc(lineschanged);
            if lineschanged = 1 then add(filename);

            add('Line # '+inttostr(linecount));
            add('     '+line);
            add('     '+s);
            if (not displayonly)   then line:=s;
          end;
        end;
        if not displayonly then writeln(outff,line);
      end;
      if (lineschanged>0)
      then
      begin
        displaymemo.Lines.add('');  {separate file reports with a blank line}
        inc(filehitcount);
        inc(lineHitCount,lineschanged);
      end;
      closefile(inff);
      if not displayonly then
      begin
        closefile(outff);
        if lineschanged = 0 then
        begin
          {rename the original file back to original name, just to keep file date/time info}
          deletefile(filename);
          renamefile(backupfilename,filename);
        end
        else
        begin {if lines were changed but backup was not requested, delete the "copy of" original file}
          if (not backupchanged) then deletefile(backupfilename);
        end;
      end;
    end;


begin {Getfiles}
  application.processmessages;  {allow user interrupt (tag set to 1)}
  if tag>0 then exit;
  maskext:=extractfileext(filemask);
  startpath:=includetrailingpathdelimiter(startpath);
  r:= FindFirst(startpath+'*.*', FaAnyfile, F);
  while (r=0) and (tag=0) do
  begin
    UpFName:=Uppercase(F.name);
    If (length(f.name)>0) and (UpFname<>'RECYCLED')  and  (copy(UpFname,1,8)<>'$RECYCLE')
    and (F.name[1]<>'.') and ((F.Attr and FAVolumeId)=0){not a volume id record}
    and (copy(UpFname,1,8)<>'COPY OF ')
    then
    begin
      if (searchsubs and ((F.Attr and FADirectory) >0)) {directory - get files from the next level}
      then  GetFiles(startpath+F.Name)
      else
      if matchesmask(f.Name,filemask) then
      begin
        inc(filecount); {count total files checked}
        scanfile(startpath+f.Name);
      end;
    end;
    r:=Findnext(F);
  end;
  FindClose(f);
end;


{************ ActionRGrpClick **********8}
procedure TForm1.ActionRGrpClick(Sender: TObject);
begin  {Set displayonly flag}
  if Actionrgrp.ItemIndex=0 then displayonly:=true
  else displayOnly:=false;
end;

{************ FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  ActionRGrpClick(sender); {Set DisplayOnly flag at dtartup}
end;



{*************** FormClose **************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini:TInifile;
begin
  ini:=TInifile.Create(extractfilepath(application.ExeName)+'Findreplace.ini');
  with ini do
  begin
    writestring('Options','Drive',DriveComboBox1.Drive);
    writestring('Options','Directory',DirectoryListBox1.Directory);
    writestring('Options','Find',FindStrEdt.text);
    writestring('Options','ReplaceWith',ReplaceStrEdt.text);
    writestring('Options','Mask',MaskEdt.text);
    writeBool('Options','Recurse',RecurseBox.checked);
    writeBool('Options','MatchCase',MatchcaseBox.checked);
    writeBool('Options','Backup',BackupBox.Checked);
    WriteInteger('Options','ActionIndex',ActionRGrp.Itemindex);
    WriteInteger('Options','LineChgIndex',LineRGrp.Itemindex);
  end;
  ini.free;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
