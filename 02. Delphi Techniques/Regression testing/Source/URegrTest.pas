unit URegrTest;
 {Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A unit to assist building  and executing regression test cases.

 Case information is contained in a TOprec record type.  All fields are in
 string format so the files exist as normal text files that can be viewed or
 edited outside of the program.

 The class TRegress contains the methods to assist in building or retrieveing
 cases.

 The Create constructor takes three parameters from the calling program:
   NewOnLoadrec: Address of an optional function in the user program called by
                 TRegress when a case is to be retrieved and tested by GetNextrec.
                 It gives the user a chance to move the input operands to his
                 edit areas. Calling sequence is defined in TEventRec although
                 any changes made to the passed Toprec are ignored.
                 Value may be Nil if not necessary in calling program.
   NewOnEvaluate:  Address of a user function called by GetNextrec and by Saverec
                 functions to evaluate the current case.  Any unused Oprec
                 fields are set to 0.
   NewMemo: Address of a TMemo used by TRegress to display results.


 Procedure Reset opens a new case file (mode=Write), adds to an existing file
 (mode=Append), or reads cases for execution (mode=Read).  Calling Reset with
 Mode=none just closes any open file.  For mode = append, case numbering begins
 with the number of cases in the file + 1;

 A TOprec record format is used to pass information.  It contains variables

        CaseID:  Case identifier.
        OpCode:  Numeric indicator of the operation performed.
        Op1,Op2, Op3:  Up to 3 input operands
        Result1, Result2:  1 or 2 results;  For boolean results, 1=true, 0=false.
        funcstr: A description of the operations.
        RunMuSecs: Exection time in microseconds.
 All variables are in text string format.

 Function GetNextrec returns the next case in a "TOprec" record. If no more cases
 are found, function returns false, otherwise true;

 Procedure Saverec saves a case passed in a TOprec when mode is Write or Append.
 }

 interface

 uses windows, stdctrls, dialogs, sysutils, forms;

 type
  TMode=(None,Write,Append,Read, Renumber);
  TOpRec=record
    CaseID: string;
    Funcstr:string;
    opcode:string;
    op1,op2,op3:string;
    result1,result2:string;
    runMuSecs:string;
  end;

  TRecEvent=function(var oprec:TOprec):boolean of object;

  TRegress=class(TObject)
    Opendialog1:TOpenDialog;

    filename:string;
    Title:string;
    f:Textfile;
    mode:Tmode;
    casecount:integer;
    OnEvaluate:TRecEvent;
    OnLoadrec:TRecEvent;
    freq:Int64;
    memo1:Tmemo;
    {close any open file and resets to read newfilename}
    constructor create(NewOnLoadrec,NewOnEvaluate:TRecEvent; Newmemo:TMemo);
    function reset(newmode:TMode):boolean;
    procedure saverec;
    function getnextrec(var Oprec,filerec:TOprec; {var caseid:string;}
                        var matched:boolean):boolean;
    procedure clear(var rec:TOprec);
  end;


implementation

{********** Create ************}
constructor TRegress.create(NewOnLoadrec,NewOnEvaluate:TRecEvent; Newmemo:TMemo);
begin
  inherited create;
  OnEvaluate:=NewOnEvaluate;
  OnLoadrec:=NewOnLoadrec;
  Memo1:=Newmemo;
  queryPerformanceFrequency(freq);
  opendialog1:= TOpendialog.create(application.mainform);
  OpenDialog1.Filter := 'Case text files (*.txt)|*.TXT|All files (*.*)|*.*';
  Opendialog1.initialdir:=extractfilepath(application.exename);
end;

{*********** Reset ************}
function TRegress.reset(newmode:TMode):boolean;
var line:string;
    filerec,oprec:TOprec;
    backname:string;
    fback:textfile;
    casefound:boolean;
begin
  result:=true;
  casecount:=0;
  if not (mode in [none,renumber]) then closefile(f);
  case newmode of
    //none: 
    write:
      With OpenDialog1 do
      begin
        title:='Start a new case file';
        options:=options+[ofOverwritePrompt];
        if execute then
        begin
          assignfile(f,filename);
          rewrite(f);
        end
        else result:=false;;
      end;
    append:
      begin
        with OpenDialog1 do
        begin
          title:='Append new cases to existing case file';
          options:=options-[ofOverwritePrompt];
          If execute then
          begin
            assignfile(f,filename);
            {count existing cases}
            system.reset(f);
            while not eof(f) do
            begin
              readln(f,line);
              if (length(line)>=4) and (copy(line,1,4)='Case') then inc(casecount);
            end;
            closefile(f);
            system.append(f);
          end
          else result:=false;
        end
      end;
    read:
      with Opendialog1 do
      begin
        title:='Read  existing case file';
        options:=options-[ofOverwritePrompt];
        if execute then
        begin
          assignfile(f,filename);
          system.reset(f);
        end
        else result:=false;
      end;
    renumber:
      begin
        if not (mode in [none,renumber]) then closefile(f);
        with Opendialog1 do
        begin
          title:='Update Case numbers and descriptions';
          if execute then
          begin
            memo1.clear;
            {Copy file to backup location}
            backname:=changefileext(filename,'.bak');
            assignfile(f,filename);
            assignfile(fback,backname);
            system.reset(f);
            rewrite(fback);
            while not eof(f) do
            begin
              readln(f,line);
              writeln(fback,line);
            end;
            closefile(f);
            closefile(fback);
            system.Reset(fback);
            system.rewrite(f);
            while not eof(fback) do
            with Filerec do
            begin
              repeat
                casefound:=false;;
                readln(fback,CaseID);
                if length(caseid) >=4 then
                  if copy(caseid,1,4)='Case' then casefound:=true;
              until  eof(fback) or  casefound;
              if eof(fback) then
              begin
                clear(oprec);
                break;
              end
              else
              begin
                readln(fback,funcstr);
                readln(fback,OpCode);
                readln(fback,Op1);
                readln(fback,op2);
                readln(fback,op3);
                readln(fback,result1);
                readln(fback,result2);
                readln(fback,runmusecs);
                result:=true;
                Oprec:=filerec;
                If  onEvaluate(Oprec) then
                with oprec do
                begin
                  inc(casecount);
                  CaseId:='Case ' +inttostr(casecount);
                  writeln(f,'');
                  writeln(f,CaseId);
                  writeln(f,funcstr);
                  writeln(f,OpCode);
                  writeln(f,Op1);
                  writeln(f,op2);
                  writeln(f,op3);
                  writeln(f,result1);
                  writeln(f,result2);
                  writeln(f,runmusecs);
                  with memo1.lines do
                  begin
                    if filerec.caseid<>oprec.caseid then
                    begin
                      add('Old CaseID '+filerec.caseid);
                      add('New CaseID '+oprec.caseid);
                    end
                    else add('For '+filerec.caseid);
                    if filerec.funcstr<>oprec.funcstr then
                    begin
                      add('Old Description '+filerec.funcstr);
                      add('New Description '+oprec.funcstr);
                    end;
                    if filerec.result1 <> oprec.result1 then
                    begin
                      add('Old Result1 '+filerec.result1);
                      add('New Result1 '+oprec.result1);
                    end;
                    if filerec.result2 <> oprec.result2 then
                    begin
                      add('Old Result2 ' + filerec.result2);
                      add('New Result2 ' + oprec.result2);
                    end;
                    add('Old Runtime ' + filerec.runmusecs);
                    add('New Runtime ' + oprec.runmusecs);
                  end;
                end;
              end;
            end;
            closefile(f);
            closefile(fback);
           end;
         end;
       end;
  end; {case}
  If result then mode:=newmode;
end;

{*********** Saverec **************}
procedure TRegress.saverec;
{Call OnEvaluateRec to build a record to e saved to a file.  Not saved if
 mode = none}
var
  Rec:TOprec;
  starttime, stoptime:Int64;
begin
  if not (mode in [none, write,append])
  then  showmessage('File not reset for output')
  else
  begin
    clear(rec);
    QueryPerformanceCounter(starttime);
    If OnEvaluate(rec) then
    with rec do
    begin
      If runmusecs='' then  {user didn't fill in run time, so we'll do it}
      begin
        QueryPerformanceCounter(stoptime);
        runMuSecs:=Inttostr((stoptime-starttime)*1000000 div freq);
      end;
      if mode in [write,append] then
      begin
        inc(casecount);
        CaseId:='Case ' +inttostr(casecount);
        writeln(f,'');
        writeln(f,CaseId);
        writeln(f,funcstr);
        writeln(f,OpCode);
        writeln(f,Op1);
        writeln(f,op2);
        writeln(f,op3);
        writeln(f,result1);
        writeln(f,result2);
        writeln(f,runmusecs);
        memo1.lines.add('Case '+inttostr(casecount)+' added to file');
      end;
    end;
  end;
end;

{************ Clear *************}
procedure TRegress.clear(var rec:TOprec);
begin
  with rec do
  begin
    CaseId:='Case';
    funcstr:='';
    opcode:='';
    Op1:='';
    op2:='';
    op2:='';
    result1:='';
    result2:='';
  end;
end;


{*************** GetNextrec ***************}
function TRegress.getnextrec(var Oprec,Filerec:TOPrec; {var CaseId:string;}
                             var Matched:boolean):boolean;
{Retrieve a record from the current case file, callback to OnLoadrec so the calling
 program can fill in it's local fields. The OnEvaluate ios called to evaluate the
 finction. New results are comapred with file results and differences reported.}

  procedure showvalues;
  begin
    with memo1.lines do
    begin
      add('X='+filerec.op1);
      add('Y='+filerec.op2);
      add('Z='+filerec.op3);
      Add('File result1= '+filerec.result1);
      Add('File result2= '+filerec.result2);
      Add('New Result1= '+oprec.result1);
      Add('New Result2= '+oprec.result2);
    end;
  end;


begin   {Getnextrec}
  result:=false;
  if mode<>read then showmessage('File not reset for input')
  else
  begin
    if not eof(f) then
    begin
      with Filerec do
      begin
        repeat
          readln(f,CaseID);
        until  eof(f) or  ((length(caseID)>=4) and (copy(caseID,1,4)='Case'));
        if eof(f) then
        begin
          clear(oprec);
          exit;
        end
        else
        begin
          readln(f,funcstr);
          readln(f,OpCode);
          readln(f,Op1);
          readln(f,op2);
          readln(f,op3);
          readln(f,result1);
          readln(f,result2);
          readln(f,runmusecs);
        end;
      end;
      result:=true;
      Oprec:=filerec;
      If (@Onloadrec=nil) or OnLoadrec(Oprec) then
      with memo1.lines, filerec do
      begin
        OnEvaluate(Oprec);
        add('');
        add(Caseid);
        add(funcstr);
        if oprec.funcstr<>funcstr then add('Function description changed, now:'+oprec.funcstr);
        if oprec.result1<>result1
            then add('********** Result1 not matched ***********');
            if (oprec.result2<>result2)
            then add('********** Result2 not matched ***********');

            if (oprec.result1=result1) and  (oprec.result2=result2)
            then add('Results OK') else showvalues;
            add('File run time: '+filerec.runmusecs + ' Microseconds');
            add('New  run time: '+oprec.runMuSecs+ ' Microseconds');
            //Timelbl.caption:=inttostr(runtime)+' Microseconds';
          end;
    end
    else clear(oprec);
  end;
end;

end.
