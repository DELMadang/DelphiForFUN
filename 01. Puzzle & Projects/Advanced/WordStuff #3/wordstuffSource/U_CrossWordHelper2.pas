unit U_CrossWordHelper2;
{Copyright 2001,2007, 2009, 2015 Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A word completion program}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UDict, Menus, masks, ComCtrls, shellAPI, USearchAnagrams,
  ExtCtrls;

type
  TWordCompleteForm = class(TForm)
    SolveBtn: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    LoadBtn: TButton;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    Useabbrevs: TMenuItem;
    Useforeign: TMenuItem;
    Usecaps: TMenuItem;
    IncExcLetters: TEdit;
    StaticText1: TStaticText;
    IncExcGrp: TRadioGroup;
    Label2: TLabel;
    AnagramBox: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure IncludeMenuItemClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure IncExcGrpClick(Sender: TObject);
  public
    { Public declarations }
    procedure solveit;
    function missinglettercount(s:string):integer;
  end;

var
  WordCompleteForm: TWordCompleteForm;

implementation
{$R *.DFM}

{*********** FormActivate ********}
procedure TWordCompleteForm.FormActivate(Sender: TObject);
var
  n:word;
begin
  If (application.mainform=self) then
  begin
    if (not assigned(pubdic)) then
    begin
      pubDic:=TDic.Create(false);
      pubDic.LoadDefaultDic; {load the last dictionary loaded}
    end
    else pubdic.loaddefaultdic;
    caption:='Cross Word Helper 2.3 - Current Dictionary:'+pubdic.dicname;
    loadbtn.visible:=true;
  end
  else  {we are being called by a wrapper program}
  begin
    caption:='Cross Word Helper 2.3 - Current Dictionary:'+pubdic.dicname;
    loadbtn.visible:=false;
  end;
  {In case initial defaut edit1 value changes, reset anagrambox enabled value}
  n:=ord(edit1.text[1]);
  edit1keyup(self, n,[]);
end;

{.......... MissingLetterCount ........}
function TWordCompleteForm.missinglettercount(s:string):integer;
var i:integer;
begin
  result:=0;
  for i:=1 to length(s) do
    if (s[i]<>'*') and (not (s[i] in ['a'..'z'])) then inc(result);
end;


{*********** SolveIt *********}
Procedure TWordCompleteForm.Solveit;
var
  Include:charset;

      {-------- DoIt --------}
      Procedure Doit(Dic:TDic; s:string);
      var
        validword,ss:Ansistring;
        i,minlen,maxlen:integer;
        error:boolean;
        a,f,caps:boolean;
        OK:Boolean;

      begin  {DoIt}

        If anagrambox.checked then
        begin
          SearchAnagrams.findallwords(s, {include,} listbox1.items);
        end
        else
        begin
          {if we have the first letter, search it only, otherwise search all}
          minlen:=0;
          for i:=1 to length(s) do
          begin
            if s[i]<>'*' then inc(minlen);
            if not(s[i] in ['a'..'z','*']) then s[i]:='?';
          end;
          if pos('*',s)>0 then maxlen:=dic.maxwordlength
          else maxlen:=minlen;
          if not (s[1] in (['*','?'])) then Dic.SetRange(s[1],minLen,s[1],maxLen)
          else  Dic.SetRange('a',minLen,'z',maxLen);
          while dic.getnextword(validword,a,f,caps) do  {get a word}
          if (( not a) and (not  f) and (not caps))
              or (a and useabbrevs.checked)
              or (f and useforeign.checked)
          then
          begin
            ok:=true;
            ss:=lowercase(validword);
            for i:=1 to length(ss) do
            if (s[i]='?') and (not (ss[i] in include)) then
            begin
              ok:=false;
              break;
            end;
            {if so, show it}
            if OK and matchesmask(validword,s) then
            begin
              if caps then validword[1]:=upcase(validword[1]);
              listbox1.items.add(validword);
            end;
          end;
        end;
      end;

var
  s,ex:string;
  i,len:integer;
  error:boolean;
Begin   {Solveit}
  listbox1.items.clear;
  s:=trim(lowercase(edit1.text));
  len:=length(s);
  error:=false;
  If len>0 then
  begin
    for i:= 1 to len do if not (s[i] in ['a'..'z','_','?',' ','-','*','/']) then error:=true;
    If not error then
    begin
      include:=['a'..'z'];
      ex:=lowercase(incexcLetters.text);
      if length(ex)>0 then
      begin
        case incexcGrp.itemindex of
        0:    {fill only with given letters}
          begin
            include:=[];
            for i:=1 to length(ex) do
            if ex[i] in ['a'..'z'] then include:=include+[ex[i]];
          end;
        1: {do not fill with the given letters}
          begin
            for i:=1 to length(ex) do
            include:=include-[ex[i]];
          end;
        end; {case}
      end;
      if application.mainform=self then
      begin
        If pubdic.dicloaded then Doit(pubdic,s);
      end
      else
      begin
        if pubdic.dicloaded then Doit(Pubdic,s);
        if privdic.dicloaded then
        begin
          listbox1.Items.add('Searching private dictionary');
          Doit(Privdic,s);
        end;
      end;
      if listbox1.items.count=0 then listbox1.items.add('No words found');
    end
    else showmessage('Words may contain only letters or ''_ - / ? "space" or *'' characters');
  end;
end;

{*********** SolveBtnClick **********}
procedure TWordCompleteForm.SolveBtnClick(Sender: TObject);
begin
  solveit;
end;

{************ LoadBtnClick ***********}
procedure TWordCompleteForm.LoadBtnClick(Sender: TObject);
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      caption:='Cross Word Helper V2.3 - Current Dic:'+pubdic.dicname;
    end;
  end;
end;

{*********** IncludeMenuIteClick ***********}
procedure TWordCompleteForm.IncludeMenuItemClick(Sender: TObject);
begin
  with sender as TmenuItem do checked := not checked;
end;

{************ Edit1KeyPress **********8}
procedure TWordCompleteForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key)=13 then {treat Enter key as Search button click}
  begin
    key:=char(0);   {null out the key}
    SolveBtnClick(sender); {call the search button click routine}
  end;
end;

{********* Edit1KeyUp *************}
procedure TWordCompleteForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin  {Enable/disable "anagram" option based on missing letter count =1}
  if missinglettercount(edit1.text)=1 then Anagrambox.enabled:=true
  else
  begin
    anagrambox.checked:=false;
    anagrambox.enabled:=false;
  end;  
end;

{************* IncExcGrpClick ************}
procedure TWordCompleteForm.IncExcGrpClick(Sender: TObject);
begin {Clear the included/excluded  letters edit box}
  if incexcgrp.itemindex=2 then  incexcLetters.text:='';  {clear text if no filtering}
end;

procedure TWordCompleteForm.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
