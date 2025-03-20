unit U_ClearBlankLines4A;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI, DFFUtils, Inifiles;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SaveBtn: TButton;
    Memo1: TMemo;
    ModeGrp: TRadioGroup;
    a: TGroupBox;
    DeletetrailingBox: TCheckBox;
    DeleteLeadingBox: TCheckBox;
    DeleteBlankBox: TCheckBox;
    DelCharBox: TCheckBox;
    NoDelCharBox: TCheckBox;
    DelStringEdt: TEdit;
    DeleteTabsBox: TCheckBox;
    TextGrpBox: TRadioGroup;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CaseBox: TCheckBox;
    procedure SaveBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DelCharBoxClick(Sender: TObject);
    procedure DelStringEdtKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses U_ProcessAFile;


{*********** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
var
  Ini:TIniFile;
  s:string;
begin
  Setmemomargins(Memo1, 10,10,10,10);
  ReformatMemo(Memo1);
  Ini:=TInifile.create(extractfilepath(application.exename)+'ClearBlankLines.ini');
  with Ini do
  begin
    modegrp.itemindex:=readInteger('RunOptions','General',0);
    deleteBlankBox.checked:=readbool('DelBlanks','General',True);
    deleteLeadingBox.checked:=readbool('DelLeading','General',False);
    deleteTrailingBox.checked:=readbool('DelTrailing','General',False);
    deletetabsBox.checked:=readbool('DelTabs','General',true);
    DelCharBox.checked:=readbool('DelChar','General',false);
    NoDelCharBox.checked:=readbool('NoDelChar','General',false);
    s:=readstring('DelString','General', '@');
    If length(s)>=1 then DelStringEdt.text:=s else DelStringEdt.text:='@';
    TextGrpBox.itemindex:=readInteger('TextOptions','General', 0);
    savedialog1.initialdir:=readstring('InitialDirOut','General','');
    opendialog1.initialdir:=readstring('InitialDirIn','General','');
  end;

  ini.free;
end;




{************* SaveBtnClick ***********}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  i,j:integer;
  OK:boolean;
  tempname,infilename,outfilename,delfilename:string;
  ptemp:array[0..255] of char;
  s:string;

begin
  if opendialog1.execute then
  with opendialog1 do
  begin
    OK:=true;
    Savedialog1.Initialdir := extractfilepath(opendialog1.Filename);

    gettempfilename(pchar(extractfilepath(files[0])),'CPY',0,ptemp);
    tempname:= ptemp;
    {First files selected are last in the list, so process in reverse oreder}
    for i:=files.count-1 downto 0 do
    begin
      memo1.lines.add('');
      memo1.lines.add('Fixing '+files[i]);
      case modegrp.itemindex of
      0: {Backup, then change input}
        begin
          infilename:='Copy of '+extractfilename(files[i]);
          j:=0;
          while (j<10) and (not copyfile( pchar(files[i]), pchar(infilename),
                                     true ) )
          do
          begin
            inc(j);
            infilename:='Copy ('+inttostr(j)+') of '+extractfilename(files[i]);
          end;
          memo1.lines.add('Backed up to '+infilename);
          outfilename:=files[i];
        end;
      1: {Change inplace}
      begin
        infilename:=tempname;
        copyfile(pchar(files[i]),pchar(infilename),false);

        outfilename:=files[i];
      end;
      2: {Make new file for output}
      begin
        infilename:=files[i];
        savedialog1.title:='Select output for '+extractfilename( infilename);
        s:=extractfileext(infilename);
        if (length(s)>0) and (s[1]='.') then delete(s,1,1);
        Savedialog1.DefaultExt:=s;
        savedialog1.filename:='';
        if savedialog1.execute then
        begin
          if ansicomparetext(savedialog1.filename,infilename)<>0 then outfilename:=savedialog1.filename
          else
          repeat
            showmessage('Output file name must be different than input file name');
            OK:=savedialog1.execute;
          until (not OK) or (ansicomparetext(savedialog1.filename,infilename)<>0);
          if OK then
          begin
            outfilename:=savedialog1.filename;
          end;
        end
        else OK:=false;
      end;
      end;{case}

      if (not OK )then break
      else
      begin    {finally we're ready to process the file}
        deleteblanks:=DeleteBlankBox.Checked;
        deleteLeading:=DeleteLeadingBox.checked;
        deleteTrailing:=DeleteTrailingBox.Checked;
        DeleteTabs:=Deletetabsbox.checked;
        DeleteString:=DelCharBox.checked;
        Nodeletechar:=NoDelCharBox.checked;
        MatchCase:=CaseBox.checked;
        DelCh:= DelStringEdt.text;//[1];
        case textGrpBox.itemindex of
          0:newcase:=Same;
          1:newcase:=Lower;
          2:newcase:=Upper;
          else newcase:=same;
        end;
        with memo1,lines do
        begin
          clear;
          add('Out file: '+outfilename);
          delfilename:=outfilename;
          s:=extractfileext(delfilename);
          delfilename:=stringreplace(delfilename,s,'',[rfReplaceAll])+'_Deleted'+s;
          processAFile(infilename, outfilename, delfilename);
          add('Records read = '+inttostr(incount));
          add('Records written = '+inttostr(outcount));
          Add('Records written but changed ='+inttostr(changedcount));
          add('Records deleted = '+inttostr(delcount));
          if (delcount>0) and (delcount<>delblankcount)
           then add('   (Deleted records were saved to "'+extractfilename(delfilename)+'")');
        end;
      end;
    end; {  files loop}
    deletefile(tempname);
  end; {opendialog.execute OK}
end;


{************* DelCharBoxClick *********}
procedure TForm1.DelCharBoxClick(Sender: TObject);
begin
  {Make sure that at most one of the check boxes is selected}
  If (sender = delCharBox) and delcharbox.checked then NodelCharBox.checked:=false
  else
  If (sender = NoDelCharBox) and NoDelcharbox.checked
  then DelCharBox.checked:=false;
end;

procedure TForm1.DelStringEdtKeyPress(Sender: TObject; var Key: Char);
begin

end;

{************* FormClose *********}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini:TInifile;
begin
  Ini:=TInifile.create(extractfilepath(application.exename)+'ClearBlankLines.ini');
  with Ini do
  begin
    writeInteger('RunOptions','General',modegrp.itemindex);
    writebool('DelBlanks','General',deleteBlankBox.checked);
    writebool('DelLeading','General',deleteLeadingBox.checked);
    writebool('DelTrailing','General',deleteTrailingBox.checked);
    writebool('DelTabs','General',deletetabsBox.checked);
    writebool('DelChar','General',DelCharBox.checked);
    writebool('NoDelChar','General',NoDelCharBox.checked);
    writestring('DelString','General', DelStringEdt.text);
    writeinteger('TextOptions','General', TextGrpBox.itemindex);
    writestring('InitialDirIn','General', extractfilepath(opendialog1.FileName));
    writestring('InitialDirOut','General', extractfilepath(savedialog1.FileName));
  end;

  ini.free;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
