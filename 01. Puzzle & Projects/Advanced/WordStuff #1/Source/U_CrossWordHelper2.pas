unit U_CrossWordHelper2;
{Copyright 2001,2007 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A word completion program}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UDict, Menus, masks, ComCtrls, shellAPI, USearchAnagrams;

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
    Label2: TLabel;
    ExcludeEdt: TEdit;
    StaticText1: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure IncludeMenuItemClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    exclude:set of char;
    procedure solveit;
  end;

var
  WordCompleteForm: TWordCompleteForm;

implementation
{$R *.DFM}


Procedure TWordCompleteForm.Solveit;



      Procedure Doit(Dic:TDic; s:string);
      var
        validword,ss:string;
        i,minlen,maxlen:integer;
        error:boolean;
        a,f,caps:boolean;
        OK:Boolean;

        function missinglettercount:integer;
        var i:integer;
        begin
          result:=0;
          for i:=1 to length(s) do
            if (s[i]<>'*') and (not (s[i] in ['a'..'z'])) then inc(result);
        end;


      begin
        {if we have the first letter, search it only, otherwise search all}
        {Len:=length(s);}
        minlen:=0;
        for i:=1 to length(s) do
        begin
          if s[i]<>'*' then inc(minlen);
          if not(s[i] in ['a'..'z','*']) then s[i]:='?';
        end;
        if pos('*',s)>0 then maxlen:=dic.maxwordlength
        else maxlen:=minlen;
        if not (s[1] in (['*','?']+exclude)) then Dic.SetRange(s[1],minLen,s[1],maxLen)
        else  Dic.SetRange('a',minLen,'z',maxLen);
        while dic.getnextword(validword,a,f,caps) do  {get a word}
        if (( not a) and (not  f) and (not caps))
            or (a and useabbrevs.checked)
            or (f and useforeign.checked)
            or (caps and usecaps.checked)
        then
        begin
          ok:=true;
          ss:=lowercase(validword);
          for i:=1 to length(ss) do
          if ss[i] in exclude then
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
        if (listbox1.items.count=0) {no word found}
           and (missinglettercount=1) {and single letter missing}
           and (messagedlg('Search for anagrammed words with missing letter in any position?',
                           mtconfirmation,[mbyes,mbno],0)=mryes)
        then
        begin
          SearchAnagrams.findallwords(s, listbox1.items);
        end;
      end;

var
  s,ex:string;
  i,len:integer;
  error:boolean;
Begin
  listbox1.items.clear;
  s:=trim(lowercase(edit1.text));
  len:=length(s);
  error:=false;
  If len>0 then
  begin
    for i:= 1 to len do if not (s[i] in ['a'..'z','_','?',' ','-','*','/']) then error:=true;
    If not error then
    begin
       ex:=lowercase(excludeedt.text);
       exclude:=[];
       for i:=1 to length(ex) do if ex[i] in['a'..'z']
       then exclude:=exclude+[ex[i]];
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

procedure TWordCompleteForm.SolveBtnClick(Sender: TObject);
begin
  solveit;
end;

procedure TWordCompleteForm.LoadBtnClick(Sender: TObject);
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      caption:='Cross Word Helper - Current Dictionary:'+pubdic.dicname;
    end;
  end;
end;

procedure TWordCompleteForm.FormActivate(Sender: TObject);
begin

  If (application.mainform=self) then
  begin

    if (not assigned(pubdic)) then
    begin
      pubDic:=TDic.Create(false);
      pubDic.LoadDefaultDic; {load the last dictionary loaded}
    end
    else pubdic.loaddefaultdic;

    caption:='Cross Word Helper - Current Dictionary:'+pubdic.dicname;
    loadbtn.visible:=true;
  end
  else  {we are being called by a wrapper program}
  begin
    caption:='Cross Word Helper - Current Dictionary:'+pubdic.dicname;
    loadbtn.visible:=false;
  end;

end;

procedure TWordCompleteForm.IncludeMenuItemClick(Sender: TObject);
begin
  with sender as TmenuItem do checked := not checked;
end;

procedure TWordCompleteForm.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
