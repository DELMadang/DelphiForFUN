unit U_HighScores;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls, inifiles, contnrs, ShellAPI;


{Default values for this test}
var
  DefaultScorefilename:string='Topscores.scr';  {Default scores filename}
  maxScoresToKeep:integer=5;

type
  TScoreObj=class(TObject)
    name:string;
    score:integer;
  end;

  TScores=class(TObjectList)
     scoresToKeep:integer; {# of scores to track}
     constructor create;
     procedure loadscores(scoreFilename:string);
     procedure savescores(ScoreFileName:string);
     function setscore(newscore:integer; newname:string):integer;
     procedure getscores(list:TStrings);
     function addrec(rec:TScoreObj):integer;
  end;


  TForm1 = class(TForm)
    ListBox1: TListBox;
    ClearBtnl: TButton;
    MaxScoresEdt: TSpinEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    AddScoreBtn: TButton;
    Label3: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Label4: TLabel;
    MaxBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure AddScoreBtnClick(Sender: TObject);
    procedure ClearBtnlClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure MaxBtnClick(Sender: TObject);
  public
    scores:TScores;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ TScores.create ********}
  constructor TScores.create;
  begin
    inherited;
    scorestokeep:=maxscorestokeep;
  end;

 {*************  TScores.AddRec **********}
  function Tscores.addrec(rec:TScoreObj):integer;
  {insert a record in the list in descending "score" order}
  var i:integer;
  begin
    result:=-1;
    for i:=0 to count-1 do
    begin
      if rec.score>TScoreObj(items[i]).score then
      begin {insert rec at first location that has a lower score}
        insert(i,rec);
        result:=i;
        break;
      end;
    end;
    If result<0  then
    begin {there was no lower score, just add it to the end}
      add(rec);
      result:=count-1;
    end;
  end;


{************* LoadScores ***********}
  procedure TScores.loadscores(scoreFileName:string);
  {Load initial set of scores from "topscores" file}
  var
    Ini:TInifile;
    i:integer;

     procedure addinitrec(section:string);
     {add the record from section "Section" in init file to scoreList}
     var
       rec:TScoreObj;
       index:integer;
     begin
        rec:=TScoreObj.create;
        rec.score:=ini.readinteger(section,'Score',0);
        rec.Name:=ini.readstring(section, 'Name',' ');
        index:=addrec(rec);
        if index>=scorestokeep then delete(index);
     end;
  begin
    clear;
    ini:=TInifile.create(scorefilename);
    with ini DO
    for i:=1 to scorestokeep do addinitrec('Rank '+inttostr(i));
    ini.free;
  end;

{************ Savescores ***********}
 procedure TScores.savescores(scorefilename:string);
  var
    ini:TInifile;
    i:integer;

     procedure savescore(i:integer);
     var section:string;
     begin
        section:='Rank '+inttostr(i+1);
        if i<count then
        with TScoreObj(items[i]) do
        begin
          ini.writeinteger(section,'Score',score);
          ini.writestring(section, 'Name',Name);
        end
        else {new entry}
        begin
          ini.writeinteger(section,'Score',0);
          ini.writestring(section, 'Name','');
        end;

     end;


  begin
    deletefile(scorefilename);
    ini:=TIniFile.CREATE(scorefilename);
    for i:=0 to scorestokeep-1 do savescore(i);
    ini.free;
  end;

{************** Setscore *************}
  function TScores.setscore(newscore:integer;newname:string):integer;

  {add the newscore and return rank of new score if it is among the top "scorestokeep",
   otherwise, do not add and return zero}
 var rec:TScoreObj;
     index:integer;
  begin
    rec:=TScoreObj.create;
    rec.score:=newscore;
    rec.name:=newname;
    index:=addrec(rec);
    if index>=scorestokeep then
    begin {If inserted after the 1st "scoretokeep" records}
      result:=0;
      {rec.free;}
      delete(index); {then just free it}
    end
    else
    begin   {otherswise, delete the last record}
      result:=index+1;
      {TScoreObj(scorelist.objects[scorestokeep]).free;}
      delete(scorestokeep);
    end;
  end;


{*********** GetScores ************}
  procedure TScores.getscores(list:TStrings);
  {Fill a TStrings list with current high scores}
  var
    s:string;
    i:integer;
  begin
    list.clear;
    for i:= 0 to scorestokeep-1 do
    with TScoreObj(items[i]) do
    begin
      s:=format('%6d  %s',[score,name]);
      list.add(s);
    end;
  end;


{*************  FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  scores:=TScores.create;
  defaultscorefilename:=extractfilepath(application.exename)+defaultscorefilename;
  scores.loadscores(DefaultScoreFilename);
  scores.getscores(listbox1.items);

end;

{************ AddScoreBtnClick **********}
procedure TForm1.AddScoreBtnClick(Sender: TObject);
begin
  scores.setscore(spinedit1.value, edit1.text);
  scores.getscores(listbox1.items);
  scores.savescores(DefaultScoreFilename);
end;

{************** ClearbtnClick ***********}
procedure TForm1.ClearBtnlClick(Sender: TObject);
var i:integer;
begin
  with scores do
  begin
    for i:=0 to count-1 do
    with TScoreobj(items[i]) do
    begin
      score:=0;
      name:='';
    end;
    savescores(defaultScoreFilename);
    getscores(listbox1.items);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

{******************* MaxBtnClick ***********}
procedure TForm1.MaxBtnClick(Sender: TObject);
{Check if max scores to save value changed, if so make the change}
begin
 If maxscoresedt.value<> scores.scorestokeep then
  with scores do
  begin
    scorestokeep:=maxscoresedt.value;
    savescores(defaultScoreFilename);
    loadscores(defaultScoreFilename);
    getscores(listbox1.items);
  end;
end;

end.
