unit U_DriveDemo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    RandomBtn: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    CDROMBox: TCheckBox;
    FixedDiskBox: TCheckBox;
    NetworkBox: TCheckBox;
    DrivesBtn: TButton;
    StopBtn: TButton;
    procedure RandomBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TypeBtnClick(Sender: TObject);
    procedure DriveBoxClick(Sender: TObject);
    procedure DrivesBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileList:TStringList;
    procedure GetFileList(NbrDrives:integer; filemask:string);
    procedure ReadAllFileNames(NbrDrives:integer; filemask:string);
    function GetDriveList:TStringlist;
    procedure GetFiles(s, filemask:string; FileList:TStringList);
    procedure disablebuttons(mode:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


uses masks;

procedure TForm1.RandomBtnClick(Sender: TObject);
{Select a random file}
begin
  If filelist.count=0 then
  begin
    tag:=0;
    listbox1.Items.clear;
    GetFileList(99,'*.*');
  end;
  listbox1.items.add('File to be checked is '+filelist[random(filelist.count)]);
end;


procedure TForm1.GetFiles(s, filemask:string; FileList:TStringList);
{recursively read all file names from directory S and add them to FileList}
var
  F:TSearchrec;
  r:integer;
begin
  r:= FindFirst(s+'*.*', FaAnyFile, F);
  while (r=0) and (tag=0) do
  begin
    If (length(f.name)>0) and (Uppercase(F.name)<>'RECYCLED')
    and (F.name[1]<>'.') and (F.Attr and FAVolumeId=0)
    then
    begin
      if ((F.Attr and FADirectory) >0)
      then  Getfiles(s+F.Name+'\', filemask, FileList)
      (*
       {use this code if masks unit is not available (i.e. Delphi Standard)}
       {mask test is only for *.* or *.xxx extension test}

      else If  (filemask[length(filemask)]='*')
             or  (extractfileext(f.name)=extractfileext(filemask))
           then Filelist.add(s+F.name);
      *)
      {use next line if masks unit is available}
      else if matchesmask(f.name,filemask) then filelist.add(s+f.name);

      application.processmessages;
    end;
    r:=Findnext(F);
  end;
  FindClose(f);
end;

function TForm1.GetDriveList:TStringlist;
{make a list of all drives of selected types}
  var
    s:string;
    i:integer;
    DriveStr:array[1..255] of char;
    t:integer;
  begin
    GetLogicalDriveStrings(255,@DriveStr);
    result:=TStringList.create;
    i:=1;
    repeat
      s:='';
      while (i<=255) and (DriveStr[i]<>#00) do
      begin
        s:=s+char(drivestr[i]);
        inc(i);
      end;
      inc(i); {step over #00}
      t:=getdrivetype(Pchar(s));
      if (length(s)>0) and
        (
            ((t=DRIVE_CDROM) and CDROMBox.checked)
          or ((t=DRIVE_FIXED) and FixedDiskBox.checked)
          or ((t=DRIVE_REMOTE) and NetworkBox.checked)
        )

        then result.add(s);
    until length(s)=0;
 end;


procedure TForm1.readAllFilenames(nbrdrives:integer;filemask:string);
{Get a list of all local fixed disk drives and read all files from each}
var
  s:string;
  i:integer;
  n:integer;
  drivelist:TStringList;
  prevcount:integer;
  begin
    driveList:=getdriveList;
    if nbrdrives<drivelist.count then n:=nbrdrives else n:=drivelist.count;
    prevcount:=0;
    tag:=0;
    for i:= 0 to n-1 do
    begin
      s:=Drivelist[i];
      Getfiles(s,filemask,FileList);
      drivelist[i]:=drivelist[i]+ ' : '+ inttostr(filelist.count-prevcount) +' Files';
      prevcount:=filelist.count;
    end;
    for i:=n-1 downto 0 do listbox1.items.insert(0,drivelist[i]);
  end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileList:=TStringList.create;
  randomize;
end;

procedure Tform1.disablebuttons(mode:boolean);
var
  i:integer;
begin
  for i:= 0 to componentcount-1 do
  if (components[i] is TButton) and TButton(components[i]).visible
  then TButton(components[i]).enabled:=not mode;
end;

Procedure TForm1.GetFileList(Nbrdrives:integer; filemask:string);
{Build the list of file names either by reading a previously built file
 of file names or by reading directories - if no file or it's not today's}

(*
var
  FilenamesFile:string;
  Usefile:boolean;
  d:TDateTime;
*)
begin
  FileList.clear;
  screen.cursor:=crHourGlass;
  disablebuttons(true);
  stopbtn.visible:=true;
  (*
  commented code - save file list to a file, select files from the saved file,
                  refesh list only if not created today

  FileNamesFile:=extractfilepath(application.exename)+'Filenames.txt';
  usefile:=false;
  If fileexists(FileNamesFile)then
  begin
     d:=Int(FileDateToDateTime(FileAge(FileNamesFile)));
     if d=date then usefile:=true;
  end;
  if usefile then FileList.loadfromfile(FileNamesFile)
  else
  *)
  begin
    ReadAllFilenames(Nbrdrives, filemask);
    {Filelist.savetofile(Filenamelist);  }
  end;
  screen.cursor:=crDefault;
  disablebuttons(false); {re-enable buttons}
  stopbtn.visible:=false;
end;

procedure TForm1.TypeBtnClick(Sender: TObject);
{display a list of all files matching a mask}
var
  starttime:TDateTime;
  secs:string;
  i:integer;

  function min(a,b:integer):integer;
    begin if a<=b then result:=a else result:=b; end;

begin
   starttime:=now;
   GetFileList(99,edit1.text);
   secs:=floattostr((now-starttime)*secsperday);
   listbox1.clear;
   for i:= 1 to min(100,filelist.count-1) do listbox1.Items.add(filelist[i-1]);
   showmessage(inttostr(filelist.count)+' '+edit1.text+' files found in '
               +secs +' seconds');
end;


procedure TForm1.DriveBoxClick(Sender: TObject);
begin
  filelist.clear;
  listbox1.clear;
end;

procedure TForm1.DrivesBtnClick(Sender: TObject);
{display a list of drives of selected types}
var
  drivelist:TStringlist;
begin
  listbox1.clear;
  drivelist:=getdrivelist;
  listbox1.items.assign(drivelist);
  drivelist.free;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

end.
