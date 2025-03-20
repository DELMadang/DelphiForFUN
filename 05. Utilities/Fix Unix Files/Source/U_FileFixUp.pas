unit U_FileFixUp;
 {Copyright 2001-2003, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved

 Phase 2, (Adjust Line Breaks), added by Steve Moller, CSIRO, Australia. 2003.

 }

{Linux and  even some Windows programs can generate line
ending character sequences which confuse Windows/DOS programs
(that expect a single CR/LF sequence to mark the end of a line).


This program has two phase that correct common errors:

Phase 1 scans a file looking for lines that end with a CR/CR/LF
sequence and optionally can fix the problem by eliminating one of the
CRs or by  deleting the entire CR/CR/LF sequence.  Some programs
mark "Soft" (word-wrap) line breaks by inserting CR/CR/LF into the file.

Note: (CR=Carriage return = 13 = hex 0D,   LF=LineFeed=10=hex 0A).

Phase 2 optionally corrects invalid line end sequences for three  types
of errors: It may insert a character for any CR not followed by a LF or
any LF characters not preceded by a CR to form a valid CR/LF pair.  It
also converts LF/CR pairs to CR/LF pairs.   Some editors corrupt PAS
files, causing problems with breakpoints  or in extreme cases,prevent
Delphi from loading source. (The whole file is one  line) The problem is
visually evident in Notepad, but not in the IDE.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls;

type
  TForm1 = class(TForm)
    FixBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    cbChangeName: TCheckBox;
    BrowseInBtn: TButton;
    BrowseOutBtn: TButton;
    CRCRLFGrp: TRadioGroup;
    Adjustbreaks: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FixBtnClick(Sender: TObject);
    procedure BrowseInBtnClick(Sender: TObject);
    procedure BrowseOutBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    procedure FixBreaks2(inname,outname:string);
  end;

const
  buf_size = 128*1024; {128K buffer}
var
  Form1: TForm1;

  SavePath: string;  //remember path between multiple saves
  buffer:array [0..buf_size-1] of  byte;
  bytesread: integer;
  bufstart:integer;

implementation

uses U_HexView;

{$R *.DFM}

procedure TForm1.FixBtnClick(Sender: TObject);

  const

  CR=$0D;
  LF=$0A;
var
  f_in,f_out:TFileStream;

  i:integer;

  Totalbytesread:integer;
  TotalBytesWritten:integer;
  Carryoverbytes:integer;  {# of bytes from each buffer to carry over to
                            start of next buffer in case the string we
                            are checking for spans 2 blocks}
   tempname:array[0..max_path] of Char;

begin

  if opendialog1.execute then
  begin
    if SavePath <> ''
      then SaveDialog1.FileName:=SavePath + ExtractFilename(OpenDialog1.FileName)
    else SaveDialog1.FileName:=OpenDialog1.FileName;
    if cbChangeName.Checked
    then SaveDialog1.FileName:=ChangeFileExt(OpenDialog1.FileName,'.FIX');
    if savedialog1.execute then
    begin
      gettempfilename('.','FFX',0,tempname);
      SavePath := ExtractFilePath(savedialog1.filename);  //keep for next time
      f_in:=TFileStream.create(opendialog1.filename,fmOpenread);
      f_out:=TFileStream.create(tempname, fmCreate);
      if CRCRLFGrp.itemindex=0 then {ignore CRCRLF}
      begin {just copy the file for the next phase}
        f_out.copyfrom(f_in,0);
        totalbytesread:=f_in.size;
        totalbyteswritten:=f_out.size;
        f_in.free;
        f_out.free;

      end
      else  {We will be doing some processing of CRCRLF}
      begin
        carryoverbytes:=2;
        Totalbytesread:=0;
        TotalBytesWritten:=0;

        bufstart:=0;
        repeat
          bytesread:=f_in.read(buffer[bufstart],buf_size-bufstart)+bufstart;
          if bytesread>carryoverbytes then
          begin
            i:=0;
            inc(TotalBytesRead,bytesread-carryoverBytes);
            while i<= bytesread-3 do
            begin
              if (buffer[i]=CR) and (buffer[i+1]=CR) and (buffer[i+2]=LF) then
              begin
                if  CRCRLFGrp.itemindex=1 then
                begin  {look for Cr-Cr-LF sequence and eliminate one CR if found}
                  move(buffer[i+1],buffer[i],bytesread-i-1);
                  dec(bytesread);

                end
                else
                if  CRCRLFGrp.itemindex=2 then {delete CRCRLF}
                begin
                  move(buffer[i+3],buffer[i],bytesread-i-3);
                  dec(bytesread,3);
                  dec(i);{backup so we check the character mover to position i next time}
                end;
              end;
              inc(i);
            end;
            {we won't count or write out those last couple of bytes yet
            because they might contain a CR to be eliminated}
            inc(TotalBytesWritten,bytesread-carryoverbytes);
            f_out.writebuffer(buffer,bytesread-carryoverbytes);
            {instead just move the last 2 bytes to the start of the buffer,
            and then we'll load the next block starting at buffer position 3}
            move(buffer[bytesread-carryoverbytes],buffer[0],carryoverbytes);
            bufstart:=2; {buffer start position for next block}
          end;
        until bytesread=carryoverbytes;

        {Done except for those last few bytes to write out and count}
        f_out.writebuffer(buffer,carryoverbytes);
        inc(totalByteswritten,carryoverbytes);
        inc(totalbytesread,carryoverbytes);

        F_in.free;
        f_out.free;
      end;
      label2.caption:='Phase 1: '+inttostr(TotalbytesRead)+' bytes read. '
                    +#13+'             '+ inttostr(TotalBytesWritten) +' bytes written. ';


      {Now do adjust linebreaks}
      if adjustbreaks.Checked then
      begin
        Fixbreaks2(tempname,savedialog1.filename);
      end
      else
      begin
        f_in:=TFileStream.create(tempname,fmOpenread);
        f_out:=TFileStream.create(savedialog1.filename, fmCreate);
        f_out.copyfrom(f_in,0);
        f_in.Free;
        f_out.free;
      end;
      deletefile(tempname);
      browseoutbtn.enabled:=true;
    end;
    browseinbtn.enabled:=true;

  end; {opendialog1}
end;

procedure TForm1.FixBreaks2(inname,outname:string);
{ Uses AdjustLineBreaks function to fix dodgy line ends.
AdjustLineBreaks adjusts all line breaks in the given string S
 to be true CR/LF sequences.
 The function changes any CR characters not followed by a LF
 and any LF characters not preceded by a CR into CR/LF pairs.
 It also converts LF/CR pairs to CR/LF pairs.}
var
  F_In,F_Out: TextFile;
  S,s2: string;
  inbytes,outbytes,linecount:integer;

begin
  inbytes:=0;
  outbytes:=0;
  linecount:=0;
  AssignFile(F_In, InName);
  Reset(F_In);
  try
    AssignFile(F_Out, outname);
    Rewrite(F_Out);
    try
      repeat
        // read a line
        Readln(F_In,S);
        inc(linecount);
        inc(inbytes,length(s)+2); {assunm the CRLF that ended the line}
        // fix it
        s2 := AdjustLineBreaks(s);
        inc(outbytes,length(s2)+2); {assume CR/LF that defined the line}
        // write it (or them) out
        Writeln(F_Out,S2);
      until EOF(F_In);
    finally
      CloseFile(F_Out);
    end;
  finally
    CloseFile(F_In);
  end;
  if linecount=1 then dec(inbytes,2);  {only 1 line in file, assume no CR/LF at eof} 
  label2.caption:=label2.caption
                    +#13+'Phase 2: '+inttostr(inbytes)+' bytes read. '
                    +#13+'            '+ inttostr(outbytes) +' bytes written. '
end;

procedure TForm1.BrowseInBtnClick(Sender: TObject);
begin
  form2.browsefilename:=opendialog1.filename;
  form2.showmodal;
end;


procedure TForm1.BrowseOutBtnClick(Sender: TObject);
begin
  form2.browsefilename:=savedialog1.filename;
  form2.showmodal;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  label2.caption:='';
end;

initialization
{===========================================================================
                    I N I T I A L I Z A T I O N
============================================================================}
begin

  SavePath := '';

end;    {initialization}

end.


