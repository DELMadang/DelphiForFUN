unit U_FastFileSearch;
 {Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FileCtrl, strUtils, ShellAPI, dffutils, Mask,
  contnrs, ExtCtrls;

type

  TLevelobj=class(TObject)
       level:integer;
       name:string;
  end;

  TForm1 = class(TForm)
    Edit1: TEdit;
    SelectedDriveLbl: TLabel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    Memo1: TMemo;
    TypeBtn: TButton;
    Label2: TLabel;
    Label1: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    CountLbl: TLabel;
    StaticText1: TStaticText;
    Label4: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    CountGrp: TRadioGroup;
    StopPnl: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure TypeBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure DirectoryListBox1Click(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StopPnlClick(Sender: TObject);
  public
    { Public declarations }
    FileList:TStringList;
    ObjectList:TObjectList;
    currentDrive:string;
    maxlevel:integer;
    maxcount:integer;  {max files to return}
    folderfillchar, FileFillChar:char;
    procedure GetFiles(s, filemask:string; currentlevel:integer);
    procedure disablebuttons(mode:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses masks;

{***************** GetFiles *****************}
procedure TForm1.GetFiles(s, filemask:string; currentlevel:integer);
{recursively read all file names from directory S and add them to FileList}
var
  F:TSearchrec;
  r:integer;
  levelobj:TLevelobj;
begin
  r:= FindFirst(s+'*.*', FaAnyFile, F);
  while (r=0) and (tag=0) do
  begin
    If (length(f.name)>0) and (Uppercase(F.name)<>'RECYCLED')
    and (F.name[1]<>'.') and (F.name<>'..') and (F.Attr and FAVolumeId=0)
    then
    begin

      if ((F.Attr and FADirectory) >0)
      then  Getfiles(s+F.Name+'\', filemask, currentlevel+1)
      (*
       {use this code if masks unit is not available (i.e. Delphi Standard)}
       {mask test is only for *.* or *.xxx extension test}

      else If  (filemask[length(filemask)]='*')
             or  (extractfileext(f.name)=extractfileext(filemask))
           then Filelist.add(s+F.name);
      *)
      {use next line if masks unit is available}
      else if matchesmask(f.name,filemask) then
      begin
        levelobj:=TLevelobj.create;
        with levelobj do
        begin
          level:=currentlevel;
          name:=f.Name;
        end;
        if currentlevel>maxlevel then maxlevel:=currentlevel;
        filelist.addobject(s+f.name,levelobj);
        //memo1.lines.add(f.name); {temporary to show progress}
        countlbl.Caption:=format('%.n files found',[0.0+filelist.count]);
        application.ProcessMessages;
        if filelist.count>maxcount then tag:=1;
      end;
    end;
    r:=Findnext(F);
  end;
  FindClose(f);
end;

{*********** CountBackSlash ************}
function countbackSlash(s:string):integer;
var
  i,n:integer;
begin
  result:=0;
  n:=0;
  repeat
    n:=posex('\', s,n+1);
    if n>0 then inc(result);
  until n=0;
end;

{************ TypeBtnClick *************}
procedure TForm1.TypeBtnClick(Sender: TObject);
{display a list of all files matching a mask}
var
  starttime:TDateTime;
  secs:string;
  i,j,n:integer;
  s,s2:string;
  savecurrentDir:string;
  levels:array of string; {used for final formatting}
  fullname,linkname:string;
  levelobj,linkobj:TLevelObj;
begin
   saveCurrentdir:=getCurrentDir;
   with countgrp do
   case itemindex of
     0,1,2: maxcount:=strtoint(items[itemindex]);
     3: maxcount:=1000000;
   end;
   disablebuttons(true);
   {Add trailing backslash if necessary}
   s:=IncludeTrailingPathDelimiter(directoryListBox1.directory);
   memo1.clear;
   for i:=0 to filelist.Count-1 do filelist.objects[i].free;
   filelist.clear;
   maxlevel:=countBackslash(s);
   countlbl.Caption:='0 files found';
   FolderFillChar:= LabeledEdit1.Text[1];
   FileFillChar:= LabeledEdit2.Text[1];
   tag:=0;
   starttime:=now;
   screen.cursor:=crHourGlass;

   getfiles(s,edit1.text,maxlevel); {recursive call to get all matching files}
   secs:=floattostr((now-starttime)*secsperday);
   setcurrentdir(savecurrentDir);
   screen.cursor:=crDefault;
   disablebuttons(false);

   {format the list}
   with memo1 do
   begin
     Clear;
     Objectlist.clear;
     setlength(levels,maxlevel);
     for i:=0 to high(levels) do levels[i]:='';
     for i:=0 to filelist.count-1 do
     with filelist, memo1 do
     begin
       levelobj:=TLevelobj(objects[i]);
       fullname:=strings[i];
       linkname:='';
       for j:=0 to levelobj.level -1 do
       begin
         n:=pos('\',fullname);
         s:=copy(fullname,1,n-1);
         linkname:=linkname+copy(fullname,1,n); {get the link to save}
         linkobj:=TLevelobj.create;
         linkobj.name:=linkname;
         linkobj.level:=1; {flag for folder name entry}
         system.delete(fullname,1,n);
         if s<>levels[j] then {for all except the last}
         begin
           objectlist.add(linkobj);
           lines.add(stringofchar(FolderFillChar,j*4)+s);
           levels[j]:=s;
         end;
       end;
       linkobj:=TLevelobj.create;
       linkobj.name:=linkname+fullname;
       linkobj.level:=0;  {flag for file name entry}
       objectList.add(linkobj);
       lines.Add(stringofchar(FileFillChar,levelobj.level*4)+' '+fullname);    {add the real file name }
     end;
   end;
end;

{************** Form1Create **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  filelist:=TStringlist.create;
  Objectlist:=TObjectlist.create;
  stopPnl.Top:=typebtn.Top;
  StopPnl.left:=typeBtn.Left;
  directoryListbox1.directory:='C:\';
  directorylistbox1click(sender);
end;

{************* DisableButtons ***********}
procedure Tform1.disablebuttons(mode:boolean);
{Disable or enable all buttons except Stop button opposite of others}
var
  i:integer;
begin
  for i:= 0 to componentcount-1 do
  if (components[i] is TButton) and TButton(components[i]).visible
  then TButton(components[i]).enabled:=not mode;
  stopPnl.Visible:=mode;
end;

{************* StopBtnClick ************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin   tag:=1;  end;


{************* DirectoryListBox1Click ***************}
procedure TForm1.DirectoryListBox1Click(Sender: TObject);
begin
  with directorylistbox1 do
  begin
    opencurrent; {Called too late in standard listbox processing.  This}
                 {forces the current clicked folder update to Directory property}
    edit2.Text:=Directory;
  end;
end;

{***************Memo1DblClick ***************}
procedure TForm1.Memo1DblClick(Sender: TObject);
var
  n,r:integer;
  obj:TLevelobj;
begin
  if filelist.count=0 then exit;
  n:=linenumberclicked(Memo1);
  obj:=TLevelObj(objectlist[n]);

  if obj.level=0 {file}
  then
  begin
    r:=ShellExecute(Handle, 'open', pchar(obj.name), nil, nil, SW_SHOWNORMAL);
    if r=se_ERR_NoAssoc then showmessage ('No program associated with this file type');
  end  
  else if obj.level=1
  then  ShellExecute(Handle, 'open', pchar(obj.name), nil, nil, SW_SHOWNORMAL) ;
end;
    //  showmessage(format('Level:%d, Name:%s',[obj.level, obj.name]));

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



procedure TForm1.StopPnlClick(Sender: TObject);
begin
  Tag:=1;
end;

end.
