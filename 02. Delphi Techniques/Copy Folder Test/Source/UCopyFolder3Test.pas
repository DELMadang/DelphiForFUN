unit UCopyFolder3Test;
{Copyright © 2006-2012  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{CopyFolder procedure copies files matching a given mask from one folder to
 another.  Parameters are;
 FromFolder:  Tha path to the folder containing the files to be copied
 ToFolder:    The path to the folder to receiver the files
 Mask: A file mask to cntol which files are selected ('*.* = All files)
 DupFileOpts:  Four options are available when the file already exists:
             1  ==> skip the file
             2   ==> always copy the file
             3   ==> copy the file if it is newer than the exitising copy
             4   ==> ask the user what actoion to take
                 CopyFirstFolderRecord: The original FromFolder record will be the
                 first record in the  output path.
                  CopySubFolders: Files in subfolders of the specified input folder will also be
                 copied if this parameter is true.
 ResetreadOnly:  If input files marked as "Readonly" will have that attribute
                 removed in the target location.
 FileExit:  The address of optional method (function of object) specifying a
            user procedure to be called before each file is copied.

            If the callback procedure is specified, it receives 4 parameters:
            Inpath: Path to the input file.
            OutputPath: path where the fle will be copied.
            Filename:  Name of the file to be copied.
            Cancopy: Boolean parameter defaulting to true. Set "Cancopy" to
                     false to skip copying this file.

            The FileExit function must return true if copying is to continmue,
            and false to abort the copy procedure without copying that file.

 }

 {For version 2, initial function entries were given unique names {StartCopyFile)
  to enable parameters (FilesCopied, DupsOverWritten, DupsNotCopied,
  YesToAll, NoToAll), to be initialized.
  The first 3 track actions taken for each eligible file found. The last 2
  are new switches set when user asks about a duplicate and replies "Yes to all"
  or "No to all" in order to spevify a duplicate action for future duplicates
  found

  A new "CopyToRoot" boolean switch in the calling sequence ignores source file
   subfolder structure and attempts to copy each eligible file to the output
   directory specified.
  }

 {Version 3 switches date test for overwriting from "creation date" to "last modified date".
  Also test to ensure that if the target folder is a subfolder of the source folder,
  the resursive file search procedure does not try to copy it (i.e no infinite loop!}

interface

Uses windows,sysutils,dialogs,controls, forms, filectrl,masks, DFFUtils;

type
  TCopyFolderExit = function(const inpath,outpath,infilename:string;
                             filesize:int64; var Cancopy:boolean):boolean of object;



  {for compatibility with existing code w/o copyfromfile option or file exit}
  function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                        reportonly,copysubfolders, CopytoRoot,ResetReadOnly:boolean):boolean;  overload;

   {for compatibility with existing code w/o copyfromfile option}
  function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                       reportonly, copysubfolders, CopyToRoot,ResetReadOnly:boolean;
                        FileExit:TCopyFolderExit):boolean;  overload;

  function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                       reportonly, CopyFirstFolderRecord, copysubfolders, CopyToRoot,ResetReadOnly:boolean;
                        FileExit:TCopyFolderExit):boolean;  overload;
  var
    Filescopied:integer;
    FileSizeCopied:int64;
    DupsOverWritten:integer;
    DupsNotCopied:integer;
    DroppedbyUserExit:integer;
    DroppedByCopyError:integer;
implementation




var
  yesToAll,Notoall:boolean;



{Define a  Dummyclass to hold a dummfileexit method to provide a way for
 the overloaded CopyFolder version without the file exit to pass this
 function as a parameter to the overloaded verion that does the work}
type Tdummyclass = class(TObject)
  function dummyfileexit(const inpath,outpath,Infilename:string;
                         lastfilesize:int64; var Cancopy:boolean):boolean;
end;
{Dummy class to provide a instance of the dummyFileExit method required for the
 overloaded version of CopyFolder}
var  dummyclass:TDummyclass;

function Tdummyclass.dummyfileexit(const inpath,outpath,infilename:string;
                        lastfilesize:int64; var Cancopy:boolean):boolean;
begin  {code doesn't matter since it will never be called}
  result:=true;
end;


  (*
  {for compatibility with existing code w/o copyfromfile option or file exit}
  function copyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                       reportonly ,copysubfolders, CopytoRoot,ResetReadOnly:boolean):boolean;  overload; forward;

   {for compatibility with existing code w/o copyfromfile option}
  function copyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                       reportonly ,copysubfolders, CopyToRoot,ResetReadOnly:boolean;
                        FileExit:TCopyFolderExit):boolean;  overload; forward;
   *)
  function copyfolder(fromfolderIn, tofolderIn,mask, Firstfolder:string; dupfileopts:integer;
                       reportonly , copysubfolders, CopyToRoot,
                       ResetReadOnly:boolean; FileExit:TCopyFolderExit):boolean;  {overload; }forward;


{*********** Start CopyFolder w/o File Exit**********}
function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                        reportonly, copysubfolders, CopytoRoot,ResetReadOnly:boolean):boolean;  overload;
begin
  FilesCopied:=0;
  dupsOverWritten:=0;
  DupsNotCopied:=0;
  DroppedByUserExit:=0;
  DroppedbyCopyError:=0;
  Yestoall:=false;
  NoToAll:=false;

  result:=Copyfolder(fromfolderIn, tofolderIn,mask,'',dupfileopts,
                     reportonly, copysubfolders, CopytoRoot, ResetReadOnly,
                      dummyclass.DummyFileExit);
end;

{*********** StartCopyFolder (overloaded with File Exit taken)**********}
function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                        reportonly, copysubfolders, CopyToRoot,ResetReadOnly:boolean;
                        FileExit:TCopyFolderExit):boolean;  overload;
begin
  FilesCopied:=0;
  dupsOverWritten:=0;
  DupsNotCopied:=0;
  DroppedByUserExit:=0;
  DroppedByCopyError:=0;
  Yestoall:=false;
  NoToAll:=false;
  result:=copyfolder(fromfolderIn, tofolderIn,mask,'',dupfileopts,
                        reportonly,copysubfolders, CopyToRoot,ResetReadOnly,
                        FileExit);
end;

{*********** StartCopyFolder (overloaded with CopyFirstFolderRecord option and File Exit taken)**********}
function Startcopyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                        reportonly, CopyFirstFolderRecord, copysubfolders, CopyToRoot,ResetReadOnly:boolean;
                        FileExit:TCopyFolderExit):boolean;  overload;
var
  firstfolder:string;
  i:integer;
begin
  
  FilesCopied:=0;
  dupsOverWritten:=0;
  DupsNotCopied:=0;
  DroppedByUserExit:=0;
  DroppedByCopyError:=0;
  Yestoall:=false;
  NoToAll:=false;
  if CopyFirstFolderRecord
  then
  begin
    Firstfolder:=IncludeTrailingBackSlash(fromfolderIn);
    for i:=length(firstfolder)-1  downto 1 do  {check back from last backslash} 
    if (firstfolder[i]='\')or (firstfolder[i]=':') then
    begin
      delete(firstfolder,1,i);
      break;
    end;
  end
  else FirstFolder:='';
  result:=copyfolder(fromfolderIn, tofolderIn,mask,Firstfolder, dupfileopts,
                        reportonly,copysubfolders, CopyToRoot,ResetReadOnly,
                        FileExit);
end;



{*************** FileTimeToDateTime *************}
Function FileTimeToDateTime(FileTime : TFileTime) : TDateTime;
var
   LocalTime : TFileTime;
   SystemTime : TSystemTime;
begin
   Result := EncodeDate(1900,1,1);      // set default return in case of failure;
   if FileTimeToLocalFileTime(FileTime, LocalTime) then
   if FileTimeToSystemTime(LocalTime, SystemTime) then
   Result := SystemTimeToDateTime(SystemTime);
end;




{*********** CopyFolder ***********}
function copyfolder(fromfolderIn, tofolderIn,mask, FirstFolder:string; dupfileopts:integer;
               reportonly, copysubfolders, CopyToRoot,ResetReadOnly:boolean;
               FileExit:TCopyFolderExit):boolean; //overload;
{Copy files in "fromfolder" to "tofolder", creating tofolder if necessary.
  If file exists in "tofolder" then  action depends on value of "sync" parameter.
  If "sync" is false, always copy,  replacing existing file if necessary, if
  "sync" is true, copy file if it does  not exist in  "tofolder" or it exists
  in "tofolder" with an older date. }
var
  f:TSearchrec;
  r:integer;
  mr:integer;
  fromname,toname:string;
  fromfolder,tofolder:string;
  fromdate,todate:TDatetime;
  upFName:string;
    CreationTime, LastAccessTime, ToLastWriteTime, FromlastWriteTime: FileTime;
  HFile:integer;
  nexttofolder:string;
  filesize:int64;
  OK:boolean;

    {----------- CopyAFile ----------}
    procedure copyafile(FailExists:boolean);
    var cancopy:boolean;
    begin
      cancopy:=true;
      filesize:=GetFileSize(f);

      {This next line is a substitute for "nil" testing of a
       normal function  when the function is a method type}
      if @fileExit<>@tdummyclass.dummyfileexit {nil}
      then result:=fileExit(fromfolder,tofolder,f.name,filesize,cancopy);
      if cancopy then
      begin
        ok:=true;
        if not reportonly then
        begin
          if not copyfile(pchar(fromname),pchar(toname),FailExists) then
          begin
            showmessage('Copy from '+ fromname + ' to ' + toname + ' failed: '+ inttostr(getlasterror) );
            ok:=false;
          end
          else
          begin
            if resetreadonly and ((f.attr and faReadOnly)<>0)
            then filesetattr(toname, f.attr and (not FAReadonly));
          end;
        end;
        if OK then
        begin
          inc(filescopied);
          inc(fileSizeCopied,filesize);
        end
        else inc(droppedbyCopyError);
      end
      else inc(droppedbyUserExit);
    end;

begin
  result:=TRUE;  {default}
  fromfolder:=includeTrailingBackslash(fromfolderIn);
  if not reportonly then
  begin
    tofolder:=includeTrailingBackslash(tofolderIn)+firstfolder;
    if not directoryexists(tofolder)
    then
    if not createdir(tofolder) then
    begin
      raise Exception.Create('Cannot create '+tofolder);
      result:=false;
   end;
  end
  else result:=true;
  if  result then
  begin
    (*
    if CopyFirstFolderRecord then
      result:=Copyfolder(fromfolder+IncludetrailingpathDelimiter(F.Name),
                                  IncludetrailingpathDelimiter(nexttofolder),
                                  mask,Firstfolder,dupfileopts,
                                  reportonly, copysubfolders, copytoroot,
                                  resetreadonly,FileExit)
    else
    begin
    *)
    r:= FindFirst(fromfolder+'*.*', FaAnyFile, F);
    while (r=0) and result do
    begin
      UpFName:=Uppercase(F.name);
      If (length(f.name)>0) and (UpFname<>'RECYCLED') and (copy(UpFname,1,8)<>'$RECYCLE')
      and (F.name[1]<>'.') and ((F.Attr and FAVolumeId)=0)
      then
      begin
        if ((F.Attr and FADirectory) >0) {get files from the next lower level}
        then
        begin {this is a folder name}
          if copysubfolders {or reportonly} then
           {don't recurse if the tofolder is a subfolder of fromfolder}
          if fromfolder+F.name+'\'<> Tofolder then
          begin

            if not copytoroot then nexttofolder:=tofolder+f.name
            else nexttofolder:=tofolder;
            result:=Copyfolder(fromfolder+IncludeTrailingPathDelimiter(F.Name),
                                  IncludeTrailingPathDelimiter(nexttofolder),
                                  mask,Firstfolder,dupfileopts,
                                  reportonly, copysubfolders, copytoroot,
                                  resetreadonly,FileExit)
          end;
        end
        else
        try  {we found a data file, should we copy it?}
          if matchesmask(f.name,mask) then
          begin
            fromname:=fromfolder+f.name;
            toname:=tofolder+f.name;
            if (not reportonly) and fileexists(toname) then
            begin
              Hfile:=fileopen(toname, fmopenread);
              if (hfile>=0)
                and (GetFileTime(hFile, @CreationTime, @LastAccessTime, @ToLastWriteTime)) then
              begin
                 fileclose(HFile);
                 FromLastWriteTime:=f.finddata.ftLastWriteTime;
                case
                  dupfileopts of
                  1:{replace}
                    begin
                      copyafile(false);
                      inc(dupsoverwritten);
                    end;
                  2:{replace if newer}
                  begin
                    if comparefiletime(FromLastWriteTime,ToLastWriteTime)>0
                    then
                    begin
                      copyafile(false);
                      inc(dupsoverwritten);
                    end;
                  end;
                  3: {ask}
                  begin
                    if (not NoToall) and (Not yestoall) then
                    begin
                      todate:=FiletimeToDateTime(ToLastWriteTime);
                      fromdate:=FiletimeToDateTime(FromLastWriteTime);
                      mr:= messagedlg('Replace '+toname +' created '
                        +formatdatetime(shortdateformat +' '+shorttimeformat,todate)
                        +#13+ 'with '+fromname+' created '
                        +FORMATDATETIME(SHORTDATEFORMAT +' '+SHORTTIMEFORMAT,FROMDATE),
                        mtconfirmation, [mbyes,mbyestoall,mbno,mbnotoall,mbcancel],0);
                        if mr=mryestoall then YesToall:=true
                        else if mr = mrNotoall then NoToall:=true;
                    end
                    else mr:=0;

                    if YestoAll or (mr=mryes)then
                    begin
                      copyafile(false);
                      inc(dupsoverwritten);
                    end
                    else
                    begin
                      inc(dupsnotcopied);
                      if mr= mrcancel then result:=false
                    end;
                  end;
                end; {case}
              end
            end  {fileexists}
            else copyafile(false);
          end;{matchesmask}
        except
          showmessage('Invalid mask "'+mask+'" entered, see documentation');
          result:=false;
        end; {try}
      end;
      r:=Findnext(F);
    end;
    FindClose(f);
  end;
end;


(*
{************** CopyFolder (w/o Callback  ***********8}
function copyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
               reportonly, copysubfolders, CopyToRoot,ResetReadOnly:boolean):boolean; overload;
{Copyfolder version w/o callback call to fileExit, call a "do nothing" version}
begin
  result := copyfolder(fromfolderIn, tofolderIn,mask,'',dupfileopts,
              reportonly, false, copysubfolders, CopyToRoot, ResetReadOnly, dummyclass.DummyFileExit);
end;

function copyfolder(fromfolderIn, tofolderIn,mask:string; dupfileopts:integer;
                       reportonly ,copysubfolders, CopyToRoot,
                       ResetReadOnly:boolean; FileExit:TCopyFolderExit):boolean;  overload;
begin
  result := copyfolder(fromfolderIn, tofolderIn,mask,dupfileopts,
              reportonly, false, copysubfolders, CopyToRoot,
              ResetReadOnly, dummyclass.DummyFileExit);
end;
*)

//initialization
//  dummyclass:=TDummyClass.create;

end.