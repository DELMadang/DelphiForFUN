unit U_ProcessAFile4A;

interface
Uses Sysutils, strutils;

Type  Tnewcase=(Upper, Lower, Same);
var
  incount, outcount,changedcount,delcount,delblankcount:integer;
  deleteblanks:boolean;
  deleteLeading:boolean;
  deleteTrailing:boolean;
  DeleteTabs:boolean;
  DeleteString:boolean;
  NoDeleteChar:boolean;
  Matchcase:boolean;
  DelCh:string;
  Newcase:TNewcase;

procedure ProcessAFile(infilename, outfilename, delfilename:string);

implementation


procedure ProcessAFile(infilename, outfilename, delfilename:string);
var
  infile,outfile,delfile:textfile;
  line,origline,ext,s:string;
  i:integer;
  delline:boolean;
begin
  assignfile(infile,infilename);
  assignfile(outfile,outfilename);
  assignfile(delfile,delfilename);
  reset(infile);
  rewrite(outfile);
  rewrite(delfile);
  incount:=0;
  outcount:=0;
  changedcount:=0;
  delcount:=0;
  delblankcount:=0;
  {the deblanking loop starts here}
  while not eof(infile) do
  begin
    readln(infile,line);
    origline:=line;
    inc(incount);
    delLine:=false;
    //if length(line)>0 then
    begin

      //if (deleteblanks or deletetabs) and (trim(line)='') then delLine:=true;
      if (deleteblanks) then
      begin
        s:=stringreplace(line,#9,'',[rfreplaceAll]); {remove tabs}
        if trim(s)='' then
        begin
          delLine:=true;
          inc(delblankcount);
        end;
      end;
      If DeleteString then
      begin
        If matchCase then
        begin
          if ansicontainsStr(line,Delch) then Delline:=true;
        end
        else if ansicontainstext(line,Delch) then Delline:=true;
      end
      else
      if nodeletechar then
      begin
        if matchCase then
        begin
          if not ansicontainsStr(line,Delch) then Delline:=true;
        end
        else if not ansicontainstext(line,Delch) then Delline:=true;
      end;

      if not delline then
      begin
        if deletetabs then
        begin
          if deleteLeading  then line:=trimleft(line);
          if deleteTrailing then line:=trimright(line);
        end
        else
        begin
          If (deleteleading) and (length(line)>0) then
          begin
            i:=1;
            if  (line[1]=' ') then
            begin {we can't use "trimleft" here because it always treats tabs as blanks}
              while (i<=length(line)) and (line[i]=' ') do inc(i);
              delete(line,1,i-1); {i points to the first character to keep}
            end;
          end;
          If deleteTrailing then
          begin
            i:=length(line);

            if (length(line)>0) and (line[length(line)]=' ') then
            begin
              while (i>=1) and (line[i] = ' ') do dec(i);
              delete(line,i+1,length(line)-i); {i points to last char to keep}
            end;
          end;
        end;
        if Newcase=Lower then line:=lowercase(line)
        else if newcase=Upper then line:=uppercase(line);
        writeln(outfile,line);
        if origline<>line then inc(changedcount);
        inc(outcount);
      end
      else
      begin
        writeln(delFile, origline);
        inc(delcount);
      end;
    end;
  end;
  closefile(infile);
  closefile(outfile);
  closefile(delfile);

  {if no non-blank lines were deleted, no need for a deleted file}
  If delblankcount=delcount then deletefile(delfilename);
end;

end.