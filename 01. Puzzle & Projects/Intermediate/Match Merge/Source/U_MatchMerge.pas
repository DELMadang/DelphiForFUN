unit U_MatchMerge;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
MatchMerge merges two files and optionally
writes the output to a new file.

Input files are checked to ensure that they are
in sequence and may be sortedf if not.

Duplicates may be eliminated or retained in the
output.

Potential enhancements include the ability to merge
more than 2 files and to select fields from the
record for comparison.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    MergeBtn: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    Size1lbl: TLabel;
    Size2Lbl: TLabel;
    Size3Lbl: TLabel;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    DupsBox: TCheckBox;
    DupsLbl: TLabel;
    procedure MergeBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    file1,file2:text;
    line1,line2:string;
    function  GetNext(var LineOut:string):integer;
    Procedure CheckFile(filename:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* TForm1.GetNext **********}
function  TForm1.GetNext(var LineOut:string):integer;
{return the next record in sequence from 2 files}
{Return values:0 = done, 1 = record from file1, 2 = record from file2}
var eofrec:string; {end of file flag}
begin
  eofrec:=stringofchar(char(255),10);
  result:=0;   lineout:='';
  if (line1=eofrec) and (line2=eofrec) then exit;
  {Ansicomparetext will not compare properly against our eofrec,
   but Uppercase function will}
  If uppercase(Line1)<=uppercase(Line2) then  {line1 is not high, return line1}
  begin
    result:=1; lineout:=Line1;
    {read ahead for next time}
    if not eof(file1) then readln(File1,line1)
    else line1:=Eofrec;
  end
  else {return line2}
  begin
    result:=2;  lineout:=Line2;
    {read ahead for next time}
    If not eof(file2) then  readln(File2,line2)
     else line2:=Eofrec;
  end;
end;

{************** CheckFile **********}
procedure TForm1.checkfile(filename:string);
   {check if files are in sequence and sort if needed and requested }
   var
     list:Tstringlist;
     newname:string;
     i:integer;
   begin
     list:=Tstringlist.create;
     list.loadfromfile(filename);
     if list.count>0 then
     begin
       for i:=0 to list.count-2 do
       if ansicomparetext(list[i],list[i+1])>0 then
       begin
         if messagedlg('File '+filename+' is not in sequence, sort it now?'
                  +#13+list[i]+' before '+list[i+1] ,
                            mtconfirmation,[mbyes,mbno],0)=mryes then
         begin
           newname:=changefileext(filename,'.~txt');
           list.savetofile(newname);
           list.sort;
           list.savetofile(FileName);
         end;
         break;
       end;
     end;
     list.free;
   end; {checkfile}


{************ MergeBtnClick **********}
procedure TForm1.MergeBtnClick(Sender: TObject);
{Get names of two files and merge them}
var
  flag, dups3:integer;
  line, where:string;
begin
  if opendialog1.execute and opendialog2.Execute then
  begin
    {Sort input files if necessary}
    checkfile(opendialog1.filename);
    checkfile(opendialog2.filename);
    {load the files into listboxes}
    listbox1.items.loadfromfile(Opendialog1.filename);
    Size1Lbl.caption:=inttostr(listbox1.items.count)+' records';
    listbox2.items.loadfromfile(Opendialog2.filename);
    Size2Lbl.caption:=inttostr(listbox2.items.count)+' records';
    listbox3.clear;
    {Open files and initialize Line1 and Line2 by reading the 1st record from each}
    assignfile(file1,opendialog1.filename);
    assignfile(file2,opendialog2.filename);
    reset(File1);  reset(file2);
    readln(file1,line1);  readln(file2,line2);
    dups3:=0;
    {loop getting records in sequence until all records have been retrieved}
    while getnext(line)>0 do
    with listbox3.items do
    begin
      If (count>0) and  (ansicomparetext(line,strings[count-1])=0) then inc(dups3);
      if (not (dupsbox.checked))
        or (count=0)
        or ((dupsbox.checked) and (ansicomparetext(line,strings[count-1])<>0))
      then add(line);
    end;
    size3lbl.caption:=inttostr(listbox3.items.count)+' records';
    If dupsbox.checked then dupslbl.caption:=inttostr(dups3)+' duplicates dropped.'
    else dupslbl.caption:='including '+inttostr(dups3)+' duplicates.';
    closefile(File1);
    closefile(file2);
  end;
  if savedialog1.execute then listbox3.items.savetofile(savedialog1.filename);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
