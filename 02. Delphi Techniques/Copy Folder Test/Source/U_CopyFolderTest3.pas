unit U_CopyFolderTest3;
{Copyright © 2006, 2008 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 2 tests new features of file copy.  Counts of files copied,
 duplicate files overwritten and duplicate files not copied are
 kept by the copyfolder functions and are reported by this program at job
 completion time.

 A new option allows user to specify that all files found be copied to the same
 output folder, ignoring input subfolder directory structure. This increases the
 likleyhood that duplicate file names will be found.  The "Ask" dialog when
 duplicates are found now has "Yes to all" and "No to all" to specify a default
 action when additional duplicate file names are encountered}

{Version 3 switches date test for overwriting from "creation date" to "last modified date".
  Also test to ensure that if the target folder is a subfolder of the source folder,
  the resursive file search procedure does not try to copy it (i.e no infinite loop!}
{Version 3.1 - * Adds option to report list of files and sizes which would be copied
                 without copying.
               * File size calculation changed to report file sizes larger than
                 4GB.
               * Delphi "FileCtrl" unit was modified to include directories which
                 are flagged as system files as well as directories. This allows
                 "web site" folders to be listed and selected for file copying}


interface

uses
  Windows, Messages, Forms,SysUtils, Classes, Graphics, Controls,  Dialogs,
  StdCtrls, ExtCtrls, filectrl, masks, ComCtrls, ShellAPI, UCopyFolder3Test, DFFUtils;

type
  TForm1 = class(TForm)
    InputBtn: TButton;
    CopyBtn: TButton;
    StaticText1: TStaticText;
    MaskComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    StopBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    Memo1: TMemo;
    OutputGrp: TGroupBox;
    Label3: TLabel;
    DupNamesgrp: TRadioGroup;
    CopyToRoot: TCheckBox;
    OutputBtn: TButton;
    CreateDirBox: TCheckBox;
    AttribGrp: TRadioGroup;
    SubfolderBox: TCheckBox;
    ActionGrp: TRadioGroup;
    Label4: TLabel;
    Label5: TLabel;
    FirstFolderBox: TCheckBox;
    procedure InputBtnClick(Sender: TObject);
    procedure OutputBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ActionGrpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Inputdir, outputdir:string;
    prevpath:string;  {used to detect change in source folder when reporting}
    reportonly:boolean;
    function FileCopyExit(const inpath,outpath,infilename:string;
               lastfilesize:int64; var canclose:boolean):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



{************* InputBtnClick **********8}
procedure TForm1.InputBtnClick(Sender: TObject);
begin
  SelectDirectory(InputDir,[],0);
  label2.caption:='Input Folder: '+Inputdir;
  If (inputdir<>'') and  (outputdir<>'') then copybtn.enabled:=true;
end;

{***************** OutputbtnClick ********88}
procedure TForm1.OutputBtnClick(Sender: TObject);
var
  opts:TSelectDirOpts;
begin
  if createdirbox.checked then opts:=[sdAllowCreate, sdPerformCreate]
  else opts:=[];
  SelectDirectory(OutputDir,opts,0);
  label3.caption:='Output Folder: '+OutputDir;
  If (inputdir<>'') and (outputdir<>'') then copybtn.enabled:=true;
end;

{*************** FileCopyExit **********8}
function TForm1.FileCopyExit(const inpath,outpath,infilename:string;
                    lastfilesize:int64;  var canclose:boolean):boolean;
{Called for each "filename" copied from "inpath" to "outpath"
 "Filename" is an empty string for the final entry
  Set result to true to continue and  false to stop the copy process.
}
var
  msg:string;
begin

  result:=true;
  with memo1.lines do
  //if reportonly then
  begin
    if inpath<>prevpath then
    begin
      add('Folder '+inpath);
      prevpath:=inpath;
    end;
    if reportonly then msg:='' else msg:='Copied';
    add(format('   %s %s, size: %.0n bytes',[msg,infilename, lastfilesize+0.0]))
  end;
  application.ProcessMessages;
  if tag<>0 then result:=false; {user pressed the stop button, abort}
end;

{**************** CopybtnClick ***********8}
procedure TForm1.CopyBtnClick(Sender: TObject);
var
  mask:string;
  msg:string;
  copyFirstFolderRecord:boolean;
  copySubFolders:boolean;
  resetreadonly:boolean;
  Dupnames:integer;
begin
  tag:=0;
  pagecontrol1.ActivePage:=tabsheet1;
  memo1.Font.Size:=10;
  memo1.font.style:=[];  {reset bold font for file display}
  mask:=maskcombobox.text;
  reportonly:=actiongrp.itemindex=0;
  copyfirstfolderRecord:=FirstFolderBox.checked;
  copysubfolders:=subfolderbox.checked;
  resetreadonly:=Attribgrp.itemindex=1;
  Dupnames:=Dupnamesgrp.itemindex;
  prevpath:='';
  memo1.clear;
  screen.cursor:=crHourGlass;
  startcopyfolder(InputDir,OutputDir,mask, Dupnames,
             reportonly, copyfirstfolderRecord, copysubfolders, copytoroot.checked, resetreadonly,FileCopyExit);
  with memo1,lines do
  begin
    if not reportonly then
    begin
      if dupsoverwritten>0 then
      add(format('Includes %d duplicates overwritten = %d net files added',
           [dupsoverwritten, filescopied-dupsoverwritten]));
      if dupsnotcopied>0 then add(inttostr(dupsNotCopied)+' duplicates not copied');
      msg:='copied'
    end
    else msg:='found';
    add(format('%d files %s matching mask %s',[filescopied,msg,mask]));
    add(format('Total bytes in these files is %.0n',[filesizecopied+0.0]));
    add(format('%d files dropped by copy error',[DroppedByCopyError]));
    add(format('%d files dropped by user exit',[DroppedbyUserexit]));
    add(format('%d duplicate files not copied',[DupsNotCopied]));
    add(format('%d duplicate files overwritten',[DupsOverwritten]));
  end;
  screen.cursor:=crDefault;
end;

{************** FormActivate **********8}
procedure TForm1.FormActivate(Sender: TObject);
begin
  inputdir:='';
  outputdir:='';
  reformatmemo(memo1);
  ActionGrpclick(sender); {initialize output options visiblility}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{************* StopBtnClick *********8}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.ActionGrpClick(Sender: TObject);
begin
  if actiongrp.itemindex>0 then outputGrp.visible:=TRUE
  else
  begin
    outputGrp.visible:=false;
    copybtn.Enabled:=true;
  end;
end;

end.
