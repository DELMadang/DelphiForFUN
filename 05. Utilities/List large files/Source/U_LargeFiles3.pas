unit U_LargeFiles3;
{Copyright  © 2002,2007 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {List the largest files on a drive, regardless of folder}
 {Only works for files up to 4 GB, use XE version for larger files}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, FileCtrl, ShellAPI, ComCtrls;

type

  TForm1 = class(TForm)
    StopBtn: TButton;
    ListBtn: TButton;
    Label1: TLabel;
    NbrEdt: TSpinEdit;
    DriveComboBox1: TDriveComboBox;
    Label2: TLabel;
    Label3: TLabel;
    TimeLbl: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ListBtnClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure TimeLblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FileList:TStringList;
    drivesdisplayed:boolean;
    currentDrive:string;
    DriveComboBox:tdrivecombobox;
    nbrtolist:integer;
    minmax:int64;
    Filecount:integer;
    procedure GetLargeFiles(startpath:string);
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}
var
  filemask:string='*.*'; {retrieve all files}

procedure TForm1.GetLargeFiles(startpath:string);
{recursively read all file names from directory S and add them to FileList}
{this is a version tailored for performance by only saving a requested number of
 largest files found}
var
  F:TSearchrec;
  r:integer;
  size:int64;
  fszhi,fszlo,m:int64;
  maskext:string;
  UpFName:string;
  datestr:string;
begin
  application.processmessages;  {allow user interrupt (tag set to 1)}
  maskext:=extractfileext(filemask);
  r:= FindFirst(startpath+'*.*', FaAnyFile, F);
  while (r=0) and (tag=0) do
  begin
    UpFName:=Uppercase(F.name);
    If (length(f.name)>0) and (UpFname<>'RECYCLED')  and  (UpFname<>'$RECYCLE')
    and (F.name[1]<>'.') and ((F.Attr and FAVolumeId)=0){not a volume id record}
    then
    begin
      if ((F.Attr and FADirectory) >0) {directory - get files from the next level}
      then  GetLargeFiles(startpath+F.Name+'\')
      else
      begin
        inc(filecount); {count total files checked}
        {get an Int64 version of file size}
        {oops! - next line does not work for filesize > 4GB}
        //size:=f.finddata.nfilesizehigh shl 32 + f.finddata.nfilesizelow;
        {Here's the way to do it for large files}
        fszhi:=f.FindData.nfilesizehigh;
        fszlo:=f.FindData.nfilesizelow;
        m:=high(longword);
        inc(m,1);
        size:=fszhi*m+fszlo;
        if (size>minmax) or (filelist.count<nbrtolist) then
        begin {this size is larger than the smallest size added to the file list
               so far}
          {If required number have been found then delete the smallest to make
           room for this addition}
          If filelist.count>=nbrtolist then filelist.delete(0);

          datestr:=formatdatetime(shortdateformat+' hh:nn',filedatetodatetime(f.time));
          filelist.add(format('%.16d%17s%s',[size,DateStr,startpath+f.name]));
          minmax:=strtoint64(copy(filelist[0],1,12));{save the new smallest size}
        end;
      end;
    end;
    r:=Findnext(F);
  end;
  FindClose(f);
end;

{************* FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
{initialization}
begin
  FileList:=TStringList.create;
  filelist.sorted:=true; {add will be inserted in proper location}
end;

{************ StopBtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
{in case the user wants to abort a file search}
begin   tag:=1;  end;

{******************* ListBtnClick *********}
procedure TForm1.ListBtnClick(Sender: TObject);
{List largest files}
var
  i:integer;
  size:int64;
  dsname:string;
  datestr:string;
  starttime:TDateTime;
begin
  {setup for search}
  memo1.clear;
  screen.cursor:=crHourglass;
  stopbtn.visible:=true;
  tag:=0;
  minmax:=0;
  Filecount:=0;
  nbrtolist:=nbredt.value;
  starttime:=now;
  {now we have to read them all to select the largest}
  GetLargeFiles(DriveComboBox1.drive+':\');
  with memo1 do
  begin
    for i:=filelist.count-1 downto 0{filelist.count-nbredt.value+1} do
    begin  {add the specified number to the listbox display}
      {separate the fileist string into size and name fields}
      size:=strtoint64(copy(filelist[i],1,16));
      datestr:=copy(filelist[i],17,17);
      dsname:=copy(filelist[i],34,length(filelist[i])-33);
      lines.add(format('%16.0n,%17s,%s',[size+0.0, datestr, dsname]));
    end;
    lines.add('');
    lines.add(format('%.0n file sizes checked',[0.0+filecount]));
    selstart:=0;
    sellength:=0;
  end;
  timelbl.caption:=format('Run time: %6.1f seconds',[(now-starttime)*secsperday]);
  //filelist.clear; {done with the list for now, might as well free some memory}
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
end;


{************ Memo1Click **********}
procedure TForm1.Memo1Click(Sender: TObject);
{Click is request to open the folder containing the clicked file,
 so lets do it.}
var
  f, explorer:string;
  n:integer;
  msg:string;
  windir:array[0..144] of char;
begin
  with memo1 do
  begin
    {set parameters}
    f:='/select, '+copy(lines[caretpos.y],36,length(lines[caretpos.y])-35);
    GetWindowsDirectory(@windir,144);
    explorer:=windir+'\explorer.exe'; {set Explorer location}
    n:=ShellExecute(handle, 'open',pchar(explorer), pchar(f),  Nil, SW_SHOWNORMAL);
    case n of
      ERROR_FILE_NOT_FOUND: msg:='Explorer.exe not found';
      ERROR_PATH_NOT_FOUND: msg:='C:\Windows not found';
      ERROR_BAD_FORMAT: msg:='Program error, bad format';
      {there are lots more possible errors, but these were enough for debugging}
      else msg:='Unknown error';
    end;
    if (n>0) and (n<=32)  then showmessage('Explorer error code: '+inttostr(n)+' '+msg);
  end;
end;

procedure TForm1.TimeLblClick(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  f:textfile;
  s:string;
  line:string;
begin
  if savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    writeln(f,'Size,"Modified Date",Name');
    for i:=filelist.count-1 downto 0 do
    begin
      s:=filelist[i];
      line:=copy(s,1,16)+',"'+copy(s,17,17)+'","'
               +copy(s,34,length(s)-33)+'"';
      writeln(f,line);
    end;
    closefile(f);
  end;
end;

end.
