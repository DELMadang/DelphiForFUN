program ClearBlankLinesCmd4A;
{$APPTYPE CONSOLE}
{Copyright © 2011,2012 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


uses
  Windows,
  SysUtils,
  masks,
  U_ProcessAFile4A;

var
  errflag:boolean;
  includesubs:boolean;
  backupprefix:string;
  filename:string;
  dirname:string;
  log:Textfile;
  processedCount,FilesChangedCount:integer;

procedure writemsg(s:string);
begin
  writeln(log,s);
  writeln(s); {write to console}
end;

function error(s:string):boolean;
  begin
    writemsg(s);
    errflag:=true;
    result:=false;
  end;

procedure showhelp;
begin
  writemsg('ClearBlankLines Parameters:');
  writemsg('[/D:Directory]');
  writemsg('    Directory ==> Starting directory for search');
  writemsg('    No /D ==> Use current directory');

  writemsg('/F:Filename or Filemask');
  writemsg(' Filename ==> file name of a file to fix');
  writemsg(' or Filemask ==> file mask of files to fix, e.g.: *.txt');

  writemsg('[/B][:backup prefix]');
  writemsg('    backup prefix ==> text to prepend to a backup of each file before changes are made');
  writemsg('   /B with no prefix ==> use "Copy of " as prefix');
  writemsg('   No /B parameter ==> make changes with no backup from this program');
  writemsg('[/S]  ==> Include subdirectories specified directory for a file mask search ');

  writemsg('[/R]  ==> Remove blank lines (containing only space characters');
  writemsg('    Note: Include Tabs parameter to delete tabs only or tabs & spaces lines');
  writemsg('/[L]  ==> Remove leading spaces of non-blank lines');
  writemsg('/[T]  ==> Remove trailing spaces of non-blank lines');
  writemsg('[/Tabs]  ==> Treat "Tab" charatcer as spaces');
  writemsg('[/C:str] ==> Delete lines containing string str, e.g. /C:[CLX]');
  writemsg('[/K:str] ==> Keep only lines containing string str');
  writemsg('[/M] ==> String match for /C or /K options is case sensitive');

  writemsg('[/Upper]  ==> Convert all text to upper case');
  writemsg('[/Lower]  ==> Convert all text to lower case');

end;

{*********** FixFiles ***********}
function Fixfiles(fromfolderIn,mask:string; copysubfolders:boolean):boolean;

var
  f:TSearchrec;
  r:integer;
  fromfolder:string;
  upFName:string;

  {----------- FixAFile ----------}
  procedure FixAFile(fromfolder,fromname:string);
  var
    infilename,outfilename, backupname, delfilename:string;
    ptemp:array[0..255] of char;
    s:string;
  begin

    writemsg('Fixing '+fromname);

    {copy input to temporary file}
    gettempfilename(pchar(fromfolder),'CPY',0,ptemp);
    outfilename:=ptemp;
    infilename:=fromfolder+fromname; {we will copy changes to a temporary file}
    delfilename:=infilename;
    s:=extractfileext(delfilename);
    delfilename:=stringreplace(delfilename,s,'',[rfReplaceAll])+'_Deleted'+s;
    ProcessAFile(infilename,outfilename,delfilename);
    writemsg('    Records in = '+inttostr(incount));
    writemsg('    Records out = '+inttostr(outcount));
    writemsg('    Records changed = '+inttostr(changedcount));
    writemsg('Records deleted = '+inttostr(delcount));
    if (delcount>0) and (delcount<>delblankcount)
       then writemsg('   (Deleted records were saved to "'+extractfilename(delfilename)+'")');

    if (incount<>outcount) or (changedcount>0) then
    begin
      inc(Fileschangedcount);
      if (backupPrefix<>'')
      then
      begin {make a backup of the input file if requested}
        backupname:=fromfolder+backupprefix+extractfilename(infilename);
        copyfile( pchar(infilename), pchar(backupname),false {=overwrite output}); {make the backup}
        writemsg('    Backed up "'+infilename + '" to "'+ backupname + '"')
      end;
      copyfile(pchar(outfilename), pchar(infilename),false{=overwrite output});

    end;
    deletefile(outfilename);
  end;

begin
  result:=TRUE;  {default}

  fromfolder:=includeTrailingBackslash(fromfolderIn); {The starting folder for this search}
  begin
    r:= FindFirst(fromfolder+'*.*', FaAnyFile, F);
    if r<>0 then error('No files in folder '+fromfolder)
    else
    while (r=0) and result do
    begin
      UpFName:=Uppercase(F.name);
      If (length(f.name)>0) and (UpFname<>'RECYCLED') and (UpFname<>'$RECYCLE.BIN')
      and (F.name[1]<>'.') and (F.Attr and FAVolumeId=0)
      then
      begin
        if ((F.Attr and FADirectory) >0) {get files from the next lower level}
        then
        begin {this is a folder name}
          if copysubfolders then
           {don't recurse if the tofolder is a subfolder of fromfolder}
            result:=FixFiles(fromfolder+F.Name, mask, copysubfolders);
        end
        else
        try
          if matchesmask(f.name,extractfilename(mask)) then
          begin
            inc(processedcount);
            FixAFile(fromfolder,f.name);
          end;{matchesmask}
        except
          result:=error('Invalid mask "'+ mask + ' " entered, see documentation');
        end; {try}
      end;
      r:=Findnext(F);
    end;
    FindClose(f);
  end;
  writemsg(format('%d Files processed', [processedCount]));
  writemsg(format('%d Files changed', [FilesChangedCount]));
end;


{************* GetParameters ********}
function getParameters:boolean;
var
  i,n:integer;
  s,s2:string;
begin
  result:=true;
  writemsg('');
  writemsg('********************');
  writemsg('Clear Blank Lines (Batch) V4.1');
  writemsg('Start: '+ datetimeToStr(now));
  backupprefix:='';
  dirname:='';
  includesubs:=false;
  errflag:=false;
  deleteblanks:=false;
  deleteleading:=false;
  deletetrailing:=false;
  deletetabs:=false;
  DeleteString:=false;
  NoDeleteString:=false;
  MatchCase:=false;
  newcase:=same;

  if paramcount>0 then
  for i:=1 to paramcount do
  begin
    s:=paramstr(i);
    if length(s)>1 then
    case upcase(s[2]) of
    'F':
      begin
        if length(s)>5 then
        begin
          writemsg('Parameter: '+s + ' (Name or mask for files to change)');
          filename:=copy(s,4,length(s)-3);
          writemsg('Debug: Start file name  is '+filename);
          if dirname='' then
          begin
            dirname:=extractfilepath(expandfilename(filename));
            writemsg('Debug: Start directory from file name is '+dirname);
          end;
          n:=pos('*',filename);
          if n=0 then pos('?',filename);
          if (n=0) and (not fileexists(filename)) then result:=error('Input file '+filename+' does not exist');
        end
        else result:=error('No input file specified in parameter "'+s+'"');
      end;
    'D':
      begin {starting directory (folder) name for input files}
        if length(s)>5 then
        begin
          writemsg('Parameter: "'+S + '" (Starting directory (folder) name)');
          dirname:=copy(s,4,length(s)-3);
          writemsg('Debug: Start directory is '+dirname);
        end
        else result:=error('No directory in parameter "'+s+'"');
      end;
    'B': {backup flag}
      begin
        if length(s)>3 then backupPrefix:=copy(s,4,length(s)-3)
        else backupPrefix:='Copy of ';
        writemsg('Parameter: '+s + ' (Backup files with prefix "'+backupPrefix+'"');
      end;
    'S': {include subdirectories}
      begin
        writemsg('Parameter: '+s + ' (Include subdirectories in search)');
        includesubs:=true;
      end;
    'R': {Delete all blank lines (tabs are treated as blanks)}
      begin
        writemsg('Parameter: '+s + ' (Remove blank lines {tabs treated as spaces}');
        deleteBlanks:=true;
      end;
    'L': {Delete only leading blanks}
      if length(s)=2 then
      begin
        writemsg('Parameter: '+s + ' (Remove leading blanks from non-blank lines)');
        deleteLeading:=true;
      end
      else if uppercase(s)='LOWER' then
      begin
        writemsg('Parameter: '+s + ' (Covert text to lower case)');
        Newcase:=Lower;
      end
      else writemsg('Parameter '+s + ' ignored, not recognized');
    'T':
      begin
        if length(s)=2 then
        Begin
          writemsg('Parameter: '+s + ' (Delete trailing blanks from non-blank lines)');
          deletetrailing:=true;
        end
        else if uppercase(s)='/TABS' then
        begin
          writemsg('Parameter: '+s + ' (Treat Tab characters as Spaces)');
          deletetabs:=true;
        end;
      end;
    'U':
      if uppercase(s)='/UPPER' then
      begin
        writemsg('Parameter: '+s + ' (Covert text to upper case)');
        Newcase:=Upper;
      end;
    'K': {Keep only lines with specified string}
      if length(s)>3 then
      begin
        s2:=copy(s,4,length(s)-3);
        writemsg('Parameter: '+ s  + ' (Keep only lines containing string '+s2+')');
        NodeleteString:=true;
        DeleteString:=false;
        delch:=s2;
      end
      else writemsg('Parameter '+s + ' ignored, /K: parameter must have string');
    'C': {Delete lines with specified character}
      if length(s)>3 then
      begin
        s2:=copy(s,4,length(s)-3);
        writemsg('Parameter: '+s  + ' (Delete lines containing string '+s2+')');
        NodeleteString:=false;
        DeleteString:=true;
        delch:=s2;
      end
      else writemsg('Parameter '+s + ' ignored, /C: parameter must have a string');
    'M':
      begin
        writemsg('Parameter: M (Match case for /C or /K string search)');
        Matchcase:=true;
      end;
    else writemsg('Parameter '+s + ' ignored, not recognized');
    end;  {case}
  end
  else
  begin
    showhelp;
    result:=false;
  end;
  If (not deleteblanks) and (not deleteleading) and (not deletetrailing)
     and (not deleteString) and (not NoDeleteString) and (newcase=same) then
  begin
    writemsg('Note: No change parameters found, /R parameter (remove blank lines) assumed');
    deleteblanks:=true;
  end;

end;

var
  logname:string;

begin
  logname:=extractfilepath(paramstr(0))+'ClearBlanksLog.txt';
  assignfile(log,logname);
  if fileexists(logname) then append(log) else rewrite(log);
  try
    ProcessedCount:=0;
    FilesChangedCount:=0;
    If getparameters then Fixfiles(dirname,extractfilename(filename),includesubs);
  except
    begin
    //Handle error condition
    WriteLn('Program terminated due to an exception');
    //Set ExitCode <> 0 to flag error condition (by convention)
    ExitCode := 1;
    end;
  end;
  writemsg(format('Total: %d Files processed', [processedCount]));
  writemsg(format('Total: %d Files changed', [FileschangedCount]));
  closefile(log);
end.