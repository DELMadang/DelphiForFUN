unit U_StringListToResource;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    ConvertBtn: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SelectBtn: TButton;
    Edit1: TEdit;
    Memo3: TMemo;
    RichEdit1: TRichEdit;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure ConvertBtnClick(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    FullPath:string;
    TextFilename,RcFilename, Resfilename:string;
    FullTextFilename,FullRCFilename, FullResfilename:string;
    function formaterror(err:integer):string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Textfilename:='';
  rcfilename:='';
  resfilename:='';
end;

{********** SelectBtnClick ************}
procedure TForm1.SelectBtnClick(Sender: TObject);
begin
  if opendialog1.Execute then
  begin
    Textfilename:=extractfilename(opendialog1.FileName);
    Fullpath:=extractfilepath(opendialog1.FileName);
    chdir(fullpath);
    edit1click(sender);
  end;
end;

{************ ConvertBtnCLick **************}
procedure TForm1.ConvertBtnClick(Sender: TObject);
var
  RCfile:textfile;
  errcode:integer;
begin
  if fileexists(textfilename) then
  begin
    screen.cursor:=crHourGlass;
    If fileexists(resfilename) then
    begin {rename the current RES file to have a "Prev_" prefix}
      deletefile('PREV_'+resfilename);
      renamefile(resfilename,'PREV_'+resfilename);
    end;
    {Build the new .rc script file}
    assignfile(rcfile,rcFileName);
    rewrite(rcfile);
    writeln(rcfile,edit1.text+ ' RCDATA ' + '"'+fullpath+Textfilename+'"');
    closefile(rcfile);
    {And compile it}
    errcode:=ShellExecute(Handle, 'open','brcc32.exe',
                                   PChar('"'+rcfilename+'"'), nil, 0) ;
    application.processmessages;
    screen.Cursor:=crDefault;
    if (errcode>32) and fileexists(Resfilename)
    then
    with memo3, lines do
    begin {compile was successful}
      clear;
      add('Resource build successful');
      add('To use include the resource with');
      add('{$R '+extractfilename(resfilename)+'}');
      add('card a start of Implementation section and a procedure like this to retrieve the stringlist');
      add('***************************************');
      Add('procedure TForm1.LoadStringList;');
      add('Var ResourceStream:  TResourceStream;');
      add('begin');
      add('  ResourceStream := TResourceStream.Create(hInstance, ''STRINGLIST'', RT_RCDATA);');
      add('  Try');
      add('    List.LoadFromStream(ResourceStream); ');
      add('  Finally  ResourceStream.Free');
      add('  end; ');
      add('end; ');
      showmessage('Resource file '+resfilename+' successfully built')
    end
    else  showmessage(formaterror(errcode));
  end
  else showmessage('Select a textfile to convert first');
end;


{************* FormatError *************}
function TForm1.formaterror(err:integer):string;
{Format the error code returned by shellexec of brcc32 resource compiler}
{Note: BRCC32.exe could produce other error message which I haven't yet figured out
 how to trap}
begin
  case err of
   0: result:='The operating system is out of memory or resources.';
   ERROR_FILE_NOT_FOUND: result:='The specified file was not found.';
   ERROR_PATH_NOT_FOUND: result:='The specified path was not found.';
   ERROR_BAD_FORMAT: result:='The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
   SE_ERR_ACCESSDENIED:	result:='The operating system denied access to the specified file.';
   SE_ERR_ASSOCINCOMPLETE:	result:='The filename association is incomplete or invalid.';
   SE_ERR_DDEBUSY:	result:='The DDE transaction could not be completed because other DDE transactions were being processed.';
   SE_ERR_DDEFAIL:	result:='The DDE transaction failed.';
   SE_ERR_DDETIMEOUT:	result:='The DDE transaction could not be completed because the request timed out.';
   SE_ERR_DLLNOTFOUND:	result:='The specified dynamic-link library was not found.';
   SE_ERR_NOASSOC:	result:='There is no application associated with the given filename extension.';
   SE_ERR_OOM:	result:='There was not enough memory to complete the operation.';
   SE_ERR_SHARE:	result:='A sharing violation occurred.';
   else Result:='Unknown error';
 end;
end;

{******************* Edit1Click *************}
procedure TForm1.Edit1Click(Sender: TObject);
{Use current textfile ane and current resource type value to build the resource
 script file to be compiled}
var
  RCDataLine:string;
  n:integer;
  {---------- SetSelAttributes -----------}
  procedure setselattributes(setsel:boolean);
  {set richedit atributes to identify results of user selected values}
  begin
    with richedit1 do
    begin
      if setsel then with selattributes do
      begin {set highlighting attributes}
        color:=clgreen;
        style:=[fsbold];
      end
      else selattributes:=defattributes; {reset default attributes}
    end;
  end;

begin
  If textfilename='' then showmessage('Select a text file first')
  else
  begin
    if sender=Edit1 then
    begin {User want to cahnge resource type identifier}
      edit1.Text:=trim(inputbox('Resource name',
             'Enter a new resource type name and click OK',edit1.text));
    end;
    with richedit1, lines do
    begin
      clear; {make final file names}
      RCFileName:=changefileext(textfilename,'.rc');
      RESFileName:=changefileext(RCfilename,'.res');
      RCDataline:=Edit1.text+ ' RCDATA "'+ TextFilename + '"';


      {Make result display highlighting fields specific to this run}
      add(format('In folder: "%s":', [fullpath]));
      selstart:=findtext(fullpath,0,200,[]);
      sellength:=length(fullpath);
      setselattributes(true);

      selstart:=selstart+sellength;
      setselattributes(false);//.color:=clblack;
      add(format('RC file %s will be built with parameter ',
                  [RcFilename]));
      setselattributes(true);//.color:=clred;
      add(RCDataLine);
      setselattributes(false); //.color:=clblack;
      add('as input to  BRCC32.exe to build resource file '+resfilename);

      n:=findtext(rcfilename,0,200,[]);
      if n>=0 then
      begin
        selstart:=n;
        sellength:=length(rcfilename);
        setselattributes(true);//.color:=clred;
      end;
      n:=findtext(resfilename,selstart+sellength,200,[]);
      if n>=0 then
      begin
        selstart:=n;
        sellength:=length(resfilename);
        setselattributes(true);//.color:=clred;
      end;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
