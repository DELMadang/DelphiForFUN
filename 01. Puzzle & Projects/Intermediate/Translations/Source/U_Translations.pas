unit U_Translations;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Elements of multi-language support:
1. Use Dxgettext GNU freeware to translate and PoEdit freeware to define string
   translations in defualt.po files (one file per language)
2. Add gnuGetText unit to Uses clauses.
3. Add gettext('xxx') to translate all 'xxx' constant strings.
   Use alias _ for gettext i.e. _('xxx')
4. Install DXGettext to add "template" building folder menu context file.  Will
   scan .pas, .dfm, .dpr, .res files in that folder to vuild "deault.po" file of
   most strings found.
5. Define folders for translations within the project folder:
   default folder names "project/locale/xx/LC_Messages/" where'xx' is the two letter
   language id.
6. Copy default.po from step 4 to a specific language folder fdefined in step 5.
7. Run poEdit on the step 6 file to  manually translate strings. Double click
   .po file to start poEdit.  To avoid error message, under
   "catalog/settings/projects" tab, define a project/version name.     Select a
   string in upper window, enter translation in window at the bottom of
   the form.  Make sure "Windows" line separator option is checked under "File/
   Preferences/Editor" and you will be able fine tune editing with Notepad.
8. Closing PoEdit will create .mo file used at run-time.
9. To avoid reentering translations after program changes are made,  new .po file
   can be merged woth old by rught click old .po file and slecting "Merge" option.
10. poEdit doesn't allow deletions of old strings as far as I could tell, so I
    used Notepad for that kind of cleanup.  Right click file and select
    "Create .mo file" after editing with Notpad.  (poEdit will automatically
    rebuild .mo file when closing).  If rebuild .mo give an error, rerun poEdit
    for detail error and fixup.
}    

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, gnuGetText;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    ChangeBtn: TButton;
    Label1: TLabel;
    LanguageGrp: TRadioGroup;
    Label2: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure LanguageGrpClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    msgindex:integer;
    localename:string;
    languagecodes:TStringlist;
    Languagetable:TStringlist;
    procedure setmsg;
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}



var
  {This is way we say it in the South!}
  Southernmsg: array[0..1] of string= ('Hey Y''all!', 'Y''all come with us');

(************ FormCreate ****************)
procedure TForm1.FormCreate(Sender: TObject);
var i,n:integer;
    buf:array[1..100] of char;
    codename:string;
begin
  msgindex:=0;

  // Put the 2 letter language codes & language names into a stringlist
  Languagetable:=TStringlist.create;
  Languagetable.loadfromfile('ISO639V1Codes.txt');

  {Get language codes for the currently defined translations}
  LanguageCodes:=TStringlist.create;
  DefaultInstance.GetListOfLanguages ('default',LanguageCodes);
  LanguageCodes.insert(0,'en');  {we don't have an English translation file, but
                                  it is the default, so add the code anyway}

  {Translate the English language name to a localized language name}
  with LanguageGrp do
  begin
    items.clear;
    for i:=0 to languageCodes.count-1 do
      items.add(_(languagetable.values[languagecodes[i]]));
    items.add(_('Southern USA'));  {OK, not a real language, added "just for fun"}
  end;

  TranslateComponent(self);  {Translate form strings}

  {Get current locale language user name}
  i:=getlocaleinfo(LOCALE_USER_DEFAULT,LOCALE_SENGLANGUAGE,@Buf,100);
  localename:=copy(string(buf),1,i-1);
  i:=getlocaleinfo(LOCALE_USER_DEFAULT,LOCALE_SISO639LANGNAME,@Buf,100);
  codename:=copy(string(buf),1,i-1);
  with Languagegrp do
  begin
    itemindex:=languagecodes.indexof(codename);
    if itemindex<0 then itemindex:=0;
  end;

  {Define the text this way so that translation process will reformat the display
   by inserting line breaks as required for the current language}
  memo1.Text:=_('Click this link to visit the DFF webpage with details about'
            + ' adding multiple language support to your Delphi programs.');
end;


(***************** LanguageGrpClick **********)
procedure TForm1.LanguageGrpClick(Sender: TObject);
var
  index:integer;
begin
  //setmsg;
  with LanguageGrp do
  begin
    {Use LanguageGrp.itemindex to indicate location of language id in LanuageCode
     stringlist (except for Southern USA entry then force use of 'en' entry}
    If itemindex<items.count-1 then index:=itemindex else index:=0;
    uselanguage(languagecodes[index]);
    Retranslatecomponent(self);
    setmsg;
    {Retranslate the text that overrides forms text}
    label2.caption:=_('Locale language is ')+ _(localename);
    label4.caption:=_('Current language is ')+ items[itemindex];
    memo1.Text:=_('Click this link to visit the DFF webpage with details about'
            + ' adding multiple language support to your Delphi programs.');
  end;
end;

(************  ChangeBtnClick *************)
procedure TForm1.ChangeBtnClick(Sender: TObject);
begin
  msgindex:=(msgindex+1) mod 2;
  setmsg;
end;

procedure TForm1.setmsg;
begin
  with LanguageGrp do
  if itemindex<items.count-1 then
  with label1 do
  begin
    if msgindex=0 then Caption:=_('Hello World!')
    else caption:=_('Goodbye!');
  end
  else label1.Caption:=southernmsg[msgindex];
  with label1 do left:=(panel1.Width-label1.width) div 2;  {re-center the greeting}
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Memo1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/programs/delphi_techniques/translations.htm',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
