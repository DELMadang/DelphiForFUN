unit U_DecimalSep2;
 {Copyright  © 2005, 2007  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {How to handle decimal separators for International applications}
 {Version 2 handles Thousands separator as well.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Edit1: TEdit;
    SetDotBtn: TButton;
    SetCommaBtn: TButton;
    Label1: TLabel;
    TestSysValBtn: TButton;
    ReadTestBtn: TButton;
    WritetestBtn: TButton;
    Memo2: TMemo;
    SetDefaultBtn: TButton;
    TestMyValBtn: TButton;
    Label2: TLabel;
    StaticText1: TStaticText;
    procedure SetCommaBtnClick(Sender: TObject);
    procedure SetDotBtnClick(Sender: TObject);
    procedure SetDefaultBtnClick(Sender: TObject);
    procedure TestSysValBtnClick(Sender: TObject);
    procedure TestMyValBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure WritetestBtnClick(Sender: TObject);
    procedure ReadTestBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 {************** Val  (my version) **************}
  procedure val(const s:string; var v:extended; var errcode:integer);
  {version of Val function that handles decimalseparator correctly,
   One difference: after an error, "errcode" points to last character in string
   rather than the error character}
  var
    digits:set of char;
    test:string;

  begin
    try
      digits:=['0'..'9'];
      errcode:=0;
      test:=stringreplace(s,thousandseparator,'',[rfreplaceall]);
      v:=strtoFloat(test);
    except
        On econverterror do
        begin  {there is an error, let's find it and point to it}
          errcode:=1;
          if s[errcode] in ['+','-'] then inc(errcode);
          while (errcode<=length(s)) and (s[errcode] in digits+[decimalseparator]) do inc(errcode);
          if (errcode<length(s)) and (s[errcode] in ['e','E']) then
          begin
            inc(errcode);
            if (errcode<length(s)) then
            begin
              if s[errcode] in ['+','-'] then inc(errcode);
              while (errcode<=length(s)) and (s[errcode] in digits) do inc(errcode);
            end;
          end;
        end;
    end; {try}
  end;

{************* SetDotBtnClick **********}
procedure TForm1.SetDotBtnClick(Sender: TObject);
begin
  //setlocaleInfoA(getUserDefaultLCID, LOCALE_SDECIMAL,'.');
  //setlocaleInfoA(getUserDefaultLCID, LOCALE_STHOUSAND,',');
  decimalseparator:='.';
  Memo2.Lines.add('Decimal separator set to dot "'+decimalSeparator+'"');
  thousandseparator:=',';
  Memo2.Lines.add('Thousands separator set to comma "'+thousandSeparator+'"');
end;

{************* SetCommaBtnClick *********}
procedure TForm1.SetCommaBtnClick(Sender: TObject);
begin
  //setlocaleInfoA(getUserDefaultLCID, LOCALE_SDECIMAL,',');
  //setlocaleInfoA(getUserDefaultLCID, LOCALE_STHOUSAND,'.');
  decimalseparator:=',';
  Memo2.Lines.add('Decimal separator set to comma "'+decimalseparator+'"');
  Thousandseparator:='.';
  Memo2.Lines.add('Thousands separator set to dot "'+thousandseparator+'"');
end;

{************* SetDefaultBtnClick **********}
procedure TForm1.SetDefaultBtnClick(Sender: TObject);
var s:array[0..1] of char;
begin
  getlocaleInfoA(LOCALE_User_DEFAULT,LOCALE_NOUSEROVERRIDE+LOCALE_SDECIMAL,s,2);
  decimalseparator:=s[0];
  setlocaleInfoA(getUserDefaultLCID, LOCALE_SDECIMAL,s);
  Memo2.Lines.add('Decimal separator reset to "'+ decimalseparator+'"');
  getlocaleInfoA(LOCALE_User_DEFAULT,LOCALE_NOUSEROVERRIDE+LOCALE_STHOUSAND,s,2);
  thousandseparator:=s[0];
  setlocaleInfoA(getUserDefaultLCID, LOCALE_STHOUSAND,s);
  Memo2.Lines.add('Thousands separator reset to "'+ thousandseparator+'"');
end;

{************ TestSysValBtnClcik **********}
procedure TForm1.TestSysValBtnClick(Sender: TObject);
var x:extended;
    errcode:integer;
begin
  system.val(edit1.text,x,errcode);
  if errcode>0 then memo2.lines.add('Old Val test: Invalid character "' + edit1.text[errcode]
                       +'" in input at position '+inttostr(errcode))
  else memo2.lines.add(format('Old Val test: Number converted successfully to %g',[x]));
end;

{************ TestMyValBtnClick ***********}
procedure TForm1.TestMyValBtnClick(Sender: TObject);
var x:extended;
    errcode:integer;
begin
  val(edit1.text,x,errcode);
  if errcode>0 then memo2.lines.add('New Val test: Invalid character "' + edit1.text[errcode]
                       +'" in input at position '+inttostr(errcode))
  else memo2.lines.add(format('New Val Test: Number converted successfully to %g',[x]));
end;

{************** FormActivate *********}
Procedure TForm1.FormActivate(Sender: TObject);
begin
  Memo2.clear;
  memo2.lines.add('Current decimal separator is '+decimalseparator);
  memo2.lines.add('Current thousands separator is '+thousandseparator);

end;

{*********** WritetestBtnClick ***********}
procedure TForm1.WritetestBtnClick(Sender: TObject);
{Write the current decimal and thousands separators in the first line of the
 new test file}
var
  f:textfile;
  n:extended;
  errcode:integer;
begin
  assignfile(f,extractfilepath(application.exename)+'Test.txt');
  rewrite(f);
  writeln(f,'DecimalSeparator'+decimalseparator+thousandseparator);
  val(edit1.text,n,errcode);
  if (errcode=0) or (messagedlg('Write Test: '+ Edit1.text +' is not a valid number, write file anyway?',
                   mtconfirmation, [mbyes,mbno],0)=mryes)
  then  writeln(f,edit1.text)
  else writeln(f,'Error in number: '+edit1.text);
  closefile(f);
end;

{************* ReadTestBtnClick *********}
procedure TForm1.ReadTestBtnClick(Sender: TObject);
{read the test file and check for line specifying the decimal and thousands
 separators used.  For computer generated files, the thousands
 separator will probably not be present but could be handled if it is present}
var
  f:textfile;
  x:extended;
  errcode:integer;
  line, newline:string;
  d,c:char;
  i:integer;
begin
  assignfile(f,extractfilepath(application.exename)+'Test.txt');
  reset(f);
  readln(f,line);
  line:=trim(line);
  if (length(line)>16)
     and (uppercase(copy(line,1,16))='DECIMALSEPARATOR')
  then
  begin
    d:=line[17];
    if length(line)>17 then c:=line[18]
    else c:=thousandseparator;
  end
  else
  begin
    d:=decimalseparator;
    c:=thousandseparator;
  end;
  readln(f,line);
  newline:=line;
  for i:=1 to length(newline) do
  begin
    if newline[i]=c then newline[i]:=thousandseparator
    else if newline[i]=d then newline[i]:=decimalseparator;
  end;
  val(trim(newline),x,errcode);  {call replacement val procedure}
  if errcode>0 then memo2.lines.add('Read test: Invalid numberic character in input file line '+line )
  else memo2.lines.add(format('Read Test: Number from file '+line+' converted successfully to %g',[x]));
  closefile(f);
end;

(*
procedure TForm1.Button1Click(Sender: TObject);
var
  s:array[0..1] of char;
begin
  getlocaleInfoA(LOCALE_User_DEFAULT,LOCALE_SDECIMAL,s,2);
  memo2.lines.add('User_Default decimal='+s[0]);
  getlocaleInfoA(LOCALE_System_DEFAULT,LOCALE_SDECIMAL,s,2);
  memo2.lines.add('System_Default decimal='+s[0]);
  setlocaleInfoA(LOCALE_User_DEFAULT,LOCALE_SDECIMAL,',');
  memo2.lines.add('User_Default decimal set to ","');
  getlocaleInfoA(LOCALE_User_DEFAULT,LOCALE_SDECIMAL,s,2);
  memo2.lines.add('User_Default decimal='+s[0]);
  getlocaleInfoA(LOCALE_System_DEFAULT,LOCALE_SDECIMAL,s,2);
  memo2.lines.add('System_Default decimal='+s[0]);
end;
*)


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
