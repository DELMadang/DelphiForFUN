unit U_Locales;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, shellapi; 

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
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

{**************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  buf:array[1..100] of char;
  n:integer;
begin
  memo1.clear;
  with memo1.lines do
  begin

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SENGCOUNTRY   ,@Buf,100);
   add('Country = '+string(buf));

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SENGLANGUAGE  ,@Buf,100);
   add('Language is '+string(buf));

    getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SDECIMAL,@Buf,100);
   add('Decimal point is '+buf[1]);

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_STHOUSAND,@Buf,100);
   add('Thousands Separator is '+buf[1]);

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SCURRENCY,@Buf,100);
   add('Currency Symbol is '+buf[1]);

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SDATE,@Buf,100);
   add('Date field separator is '+buf[1]);

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_STIME,@Buf,100);
   add('Time field separator is '+buf[1]);

   getlocaleinfo(LOCALE_SYSTEM_DEFAULT,LOCALE_SDAYNAME1,@Buf,100);
   add('First day of week is called  '+string(buf));

   add('... ');
   add(' ');

   add('Plus 90 more locale constants.  See complete list at "Locale Information" '
                  +'entry in Delphi Windows SDK Help file.  '
                  +'Delphi unit Windows.pas defines the constants.');
  end;
end;

{************* StaticText1Click ******}
procedure TForm1.StaticText1Click(Sender: TObject);
{ Browse DFF home page}
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
