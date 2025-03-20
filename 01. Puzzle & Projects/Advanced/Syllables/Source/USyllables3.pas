unit USyllables3;
 {Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



{Defines a "TSyllables" class to syllabify or syllabize words}
interface
  uses Controls, Classes, SysUtils, Dialogs;

type


  TString = class  {used to add the syllabized word to the string list as an object}
  private
    fStr: String;
  public
    constructor Create(const AStr: String);
    property Str: String read FStr write FStr;
  end;

  TStringx3=array[1..3] of string; {3 part rule structure}
                              {1.letters to replace}
                              {2. replacement letters for word lookup}
                              {3. letters and hyphenation to reinsert if a match found}
  TSyllables=class(TObject)
  protected
    procedure savelist;
    procedure loadlist;
    procedure ClearSyllablesList;
    function applyrules(w:string;
               level:integer;  var w2:string; var sourcefromrule:integer):boolean;
  public
    Fileloaded:boolean;
    SyllablesFound:boolean;
    dir:string;
    syllablefilename:String;
    syllableUpdatename:String;
    SyllableListName:String;
    Hyphenname:string;
    syllablelist:TStringlist;

    maxrecurselevel:integer;  {maximum level to recurse when applying rules
                               currently fixed at 1 }
    constructor create(dir:string;
                rebuild, reapplyUpdates:boolean);
    Procedure free;
    procedure BuildSyllablelist(applyUpdates:boolean);
    procedure AddToList(filename:string);
    function getSyllables(w:string; var w2:string):boolean; overload;
    function getSyllables(w:string;
                          level:integer;
                          var w2:string;
                          var  sourcefromrule:integer):boolean; overload;
  end;


  function getPrefixrule(n:integer):TStringX3;
  function getSuffixrule(n:integer):TStringX3;
  var
    nbrprefixrules, nbrsuffixrules:integer;

implementation


const
  SH=char($b7);  {Soft Hyphen}

  (*
  Each rule[i] has 3 strings:
    [1] the word ending to remove
    [2] the replacement string for testing against Syllablelist
    [3] the text to re-insert if modified word is found
  *)


  suffixRules:array[1..77] of Tstringx3 =
             {obsolete and unused rules commented out}
              (
               ('ses','se','s'+sh+'es'), {nose  --> noses}
               ('zes','ze','z'+sh+'es'), {agonize --> agonizes}
               ('s','','s'),   {xxxxx  --> xxxxxs  (plural, no extra syllable)}

               {ed}
               ('ded','d','d'+sh+'ed'),
               ('ted','t','t'+sh+'ed'),
               ('mmed','m','mmed'),
               ('gged','g','gged'),
               //('lled','l','lled'),
               ('pped','p','pped'),
               ('nned','n','nned'),
               ('tted','t','t'+sh+'ted'),
               ('ed','','ed'),

               {er}
               ('mmier','mmy','m'+sh+'mi'+sh+'er'),
               ('ggier','g','g'+sh+'gi'+sh+'er'),
               ('ppier','p','p'+sh+'pi'+sh+'er'),
               //('nnier','n','n'+sh+'ni'+sh+'er'),
               ('ier','e',sh+'i'+sh+'er'),  {ache --> achier}
               ('ier','ey','i'+sh+'er'),
               ('ier','y','i'+sh+'er'),
               //('ier','',sh+'i'+sh+'er'),
               ('gger','g','g'+sh+'ger'),
               ('rrer','r','r'+sh+'rer'),
               ('ler','l',sh+'ler'),
               ('der','d',sh+'der'),
               ('dders','d','d'+sh+'ders'),
               //('lers','l',sh+'lers'),
               ('er','e',sh+'er'),
               ('er','',sh+'er'),

               {ed}
               ('ied','y','ied'),

               {es}
               ('es','',sh+'es'),
               ('iness','e',sh+'i'+sh+'ness'),  {ache --> achiness}
               ('mmies','m','m'+sh+'mies'),
               ('ggies','g','g'+sh+'gies'),
               //('ppies','p','p'+sh+'pies'),
               ('nnies','n','n'+sh+'nies'),
               ('ies','y','ies'),        {cry --> cries}   {33}
               //('oes','o','oes'),     {tomato --> tomatoes}
               ('ves','f','ves'),    {thief --> thieves}
               ('ses','sis','ses'), {thesis plural = theses}
               //('ces','ce',sh+'ces'),  {absence --> absences}


               {ous}
               //('tous','ty','tous'),
               ('ous','',sh+'ous'),

               {est}
               ('mmiest','mmy','m'+sh+'mi'+sh+'est'),
               ('iest','e',sh+'i'+sh+'est'),  {ache --> achiest}
               ('iest','ey','i'+sh+'est'),
               ('iest','y','i'+sh+'est'),   {zesty --> zestiest}

             //  ('iest','e','i'+sh+'est'),   {ache --> achiest}
             //  ('iest','',sh+'i'+sh+'est'), {trust --> trustiest}
               ('est','',sh+'est'),
               ('est','e',sh+'est'),

               {ing}
               ('tting','t','t'+sh+'ting'),
               ('ming','',sh+'ming'),
               ('ding','',sh+'ding'),
               ('ring','',sh+'ring'),
               ('ning','',sh+'ning'),
               ('ging','',sh+'ging'),
               ('ing','',sh+'ing'),
               ('ing','e',sh+'ing'),

               {ish}
               ('ish','',sh+'ish'),

               {ist}
               ('ist','e',sh+'ist'),
               ('ist','y','ist'),


               {y}
               ('ddy','dd','d'+sh+'dy'),
               ('dly','d','d'+sh+'ly'), {hard --> hardly}
               ('ggy','g',sh+'g'+'gy'),
               ('bby','b',sh+'b'+'by'),
               ('ly','','ly'),
               ('y','',sh+'y'),
               ('y','e',sh+'y'),

               {others}
               ('tion','',sh+'tion'),
               ('men','man','men'),
               ('sat','sit','sat'),
               ('ae','a','ae'),
               ('ese','a','ese'),
               ('up','',sh+'up'),
               ('able','e',sh+'a'+sh+'ble'),
               ('ible','e',sh+'i'+sh+'ble'),
               ('th','','th'),
               ('ncy','nt','n'+sh+'cy'), {stringent --> stringency}
               ('or','',sh+'or'),
               ('ial','y','i'+sh+'al'),
               ('al','','al'),  {logic =-> logical}
               ('d','','d'),   {plague --> plagued}

               ('a','um','a'),
               ('i','',sh+'i'),  {589}
               ('i','us','i'),
               ('l','','l'),
               ('x','','x')
               );

  prefixRules:array[1..10] of Tstringx3 =
               (
               ('co','','co'+sh),
               ('by','','by'+sh),
               ('bi','','bi'+sh),

               ('de','','de'+sh),
               ('non','','non'+sh),
               ('un','','un'+sh),
               ('up','','up'+sh),
               ('pre','','pre'+sh),
               ('mis','','mis'+sh),
               ('re','','re'+sh)
               );

   blankrule:TStringx3 = ('','','');

  {******************* ApplyRules ****************}
  function TSyllables.applyrules(w:string;
                                 Level:integer;
                                 var w2:string; var sourcefromrule:integer):boolean;
  var
    rule:array[1..3] of string;
    len,len2:integer;
    tempw,tempw2:string;

     {----------------- CheckSuffixRules ------------}
     function checksuffixrules:integer;
     var
      i,j:integer;
      tempr2, tempr3:string;
      usedRuleNbr:integer;
      begin
        result:=0;
        for i:=low(suffixrules) to high(suffixrules) do
        begin
          for j:=1 to 3 do rule[j]:=suffixrules[i,j];
          len2:=length(rule[1]);
          if
          (len>= len2+2) and (copy(w,len-len2+1,len2)=rule[1]) then
          begin
            tempw:=copy(w,1,len-len2)+rule[2];
            if
             (level<=maxrecurselevel) and
              getsyllables(tempw,level+1, tempw2, usedRuleNbr)
            then
            begin
              {Tempw2 may have had an extra soft hyphen inserted in the rule[2] changed
               portion of the word. We'll make new temp r[2] and r[3] field reflecting the
               changes in both and then replace temp r[2] and with temp r[3]}
              tempr2:=rule[2]; tempr3:=rule[3];
              begin
                w2:=copy(tempw2, 1, length(tempw2)-length(tempr2))+tempr3;
                result:=i;
              end;
              break;
            end;
          end;
        end;
      end;

    {-------------CheckPrefixRules ----------}
    function checkprefixrules:integer;
     var
      i,j:integer;
      usedRuleNbr:integer;
      begin
        result:=0;
        for i:=low(prefixrules) to high(prefixrules) do
        begin
          for j:=1 to 3 do rule[j]:=prefixrules[i,j];
          len2:=length(rule[1]);
          if (len>= len2+2) and (copy(w,1,len2)=rule[1]) then
          begin
            tempw:=rule[2]+copy(w,len2+1,len-len2);
            if
             (level<=maxrecurselevel) and
               getsyllables(tempw, level+1, tempw2,usedRuleNbr)
            then
            begin
              w2:=rule[3]+copy(tempw2, length(rule[2])+1, length(tempw2)-length(rule[2]));
              result:=100+i;
              break;
            end;
          end;
        end;
      end;

      {------------- CheckCompoundWords -------------}
      function checkcompoundwords:integer;
      var
        i:integer;
        tempw, tempw2,tempw3,tempw4:string;
        usedRuleNbr:integer;
      begin
        result:=0;
        {check for compound words}
        for i:=2 to length(w)-3 do
        begin
          tempw:=copy(w,1,i);
          usedruleNbr:=0;
          if getsyllables(tempw, level+1, tempw2,usedRuleNbr) then
          begin
            tempw3:=copy(w,i+1,length(w)-i);
            if getsyllables(tempw3, level+1, tempw4,usedRuleNbr) then
            begin
              w2:=tempw2+sh+tempw4;
              result:=1000+usedrulenbr;
              break;
            end;
          end;
        end;
      end;

  begin
    len:=length(w);
    sourcefromrule:=checkprefixrules;
    If sourcefromrule=0  then sourcefromrule:=checksuffixrules;
    if sourcefromrule=0  then sourcefromrule:=checkcompoundwords;
    result:=sourcefromrule>0;
  end;


{************ Tstring.Create ***********}
constructor TString.Create(const AStr: String) ;
 begin
    inherited Create;
    FStr := AStr;
 end;


{************** GetFileModDate ************}
function GetFileModDate(filename: string): TDateTime;
var
  fileDate: integer;
  begin
    Result := 0;
    fileDate := FileAge(filename);
    // Did we get the file age OK?
    if fileDate > -1
    then Result := FileDateToDateTime(fileDate);
  end;

{****************************************************}
{*            TSyllables Methods                    *)
{****************************************************}

{************* Create *************}
Constructor TSyllables.create(dir:string; rebuild,reapplyUpdates:boolean);
var
  dL,dS,dU:TDatetime;
begin
  inherited create;
  syllablefilename:=dir+'Syllables.txt';
  syllableUpdatename:=dir+'SyllablesUpdate.txt';
  SyllableListName:=dir+'SyllableList.txt';
  Hyphenname:='mhyph.txt';
  Syllablelist:=TStringList.create;
  if fileexists(Syllablefilename) then
  begin
    syllablesfound:=true;
    if not fileexists(SyllableUpdatename) then SyllableUpdatename:='';
    dL:=getfileModdate(SyllableListname);

    If (dL>0) then
    begin
      dS:=getfileModdate(SyllableFilename);
      if (ds>dL) and (not rebuild) then
      begin
        if messagedlg('Syllables.txt has been modified since SyllableList was built.'
        +#13+'Rebuild the list?', mtconfirmation, [mbyes,mbno],0)= mryes
        then rebuild:=true;
      end;
      dU:=getfileModdate(SyllableUpdateName);
      if (dU>dL) and ((not rebuild) or (not reapplyupdates)) then
      begin
        if messagedlg('SyllableUpdates.txt has been modified since SyllableList was built.'
        +#13+'Rebuild the list?', mtconfirmation, [mbyes,mbno],0)= mryes
        then
        begin
          rebuild:=true;
          reapplyupdates:=true;
        end;
      end;
    end;

    If rebuild or (not fileexists(Syllablelistname)) then
    begin
      BuildSyllableList(reapplyupdates);
    end
    else Loadlist;
  end
  else  {no syllables.txt file}
  if fileexists(Syllablelistname) then loadlist
  else showmessage('Cannot search because required file "SyllableList.txt" and the file required to rebuuild it, "Syllables.txt",  are both missing') ;
  maxrecurselevel:=1;
  nbrsuffixrules:=length(suffixrules);
  nbrprefixrules:=length(prefixrules);
end;

procedure TSyllables.free;
begin
  clearsyllableslist; {to free the string objects}
  Syllablelist.Free;
  inherited;
end;

{************* AddtoList ************}
procedure TSyllables.AddToList(filename:string);
{process text file of syllabilized words with format "word=hyphenated word"}
{On the hypenated side, embedded spaces or softhyphens($B7) count as syllable separators}
var
  index:integer;
  line:string;
  inf:Textfile;
  strObj:TString;
  i,n:integer;
  w,w2:string;
  begin
    assignfile(inf,FileName);
    reset(inf);
    with syllableList do
    while not eof(inf) do
    begin
      readln(inf,line);
      line:=trim(line);
      if (length(line)>2) and (line[1] in ['A'..'Z','a'..'z']) then
      begin
        n:=pos('=',line);
        if n>0 then
        begin
          w:=copy(line,1,n-1);
          w2:=copy(line,n+1,length(line)-n);
        end
        else
        begin {assume it was a single syllable word and user used the shortcut of
               not entering = plus the original word, we'll duplicate it for him}
          w:=line;
          w2:=line;
        end;
        if pos(' ',w2)>0 then
        begin
          for i:=length(w2)-1 downto 1 do
          begin
            if w2[i]=' ' then
            begin
              {if there happened to be multiple contiguous embedded blanks,
               then just remove the extras (we don't want multiple contiguous
               softhyphens!)}
              if w2[i+1]<>sh then w2[i]:=sh
              else system.delete(w2,i,1);
            end;
          end;
        end;
        {w2 has been punctuated with softhyphens}
        strObj:=TString.Create(w2);
        if not find(w,index)
        then addobject(w,strObj)
        else
        begin
        {the word already exists in the file, just replace the syllabization}

          if assigned(objects[index]) then TString(objects[index]).free;
          objects[index]:=TObject(strObj);
        end;
      end;
    end;
    closefile(inf);
  end;

{********** BuildSyllableList *********}
procedure TSyllables.BuildSyllablelist(applyupdates:boolean);
begin
  addtolist(SyllableFilename);
  syllablelist.duplicates:=dupignore;
  Syllablelist.sorted:=true;

  if applyupdates and (SyllableUpdatename<>'') then
  begin {merge the updates with syllables file}
    addtolist(SyllableUpdatename);
  end;
  Savelist;
end;

{*********** SaveList ************}
procedure TSyllables.savelist;
{Save internal stringlist to a file}
var
  i:integer;
  outf:textfile;
begin
  assign(outf, syllableListName);
  rewrite(outf);
  for i:=0 to syllablelist.count-1 do
  with syllableList do
  begin
    writeln(outf,strings[i]+'='+TString(objects[i]).str);
  end;
  closefile(outf);
end;

{************* LoadList *********8}
procedure TSyllables.loadlist;
begin
  clearSyllablesList;
  addToList(syllablelistname);
end;

{*********** ClearSyllablesList ***********}
procedure TSyllables.ClearSyllableslist;
var
  i:integer;
begin
  for i:=0 to syllableList.count-1 do TString(syllablelist.objects[i]).free;
end;

{**************** GetSyllables ***************}
 function TSyllables.GetSyllables(w:string; var w2:string):boolean;
 var
   fromrules:integer;
 begin
   {allow rules to be checked}
   result:=getsyllables(w,0, w2,fromrules);
 end;

 (**************** GetSyllables ***************)
 function TSyllables.GetSyllables(w:string;
                                  level:integer;
                                  var w2:string;
                                  var sourcefromrule:integer):boolean;
 {This version passes level to Applyrules which decide whether or not
  to recurse on the rules to try to syllabize the passed word}
  {Current deault is to allow 1 level of recursion}
  {If a rule is used to resolve the word, the rule number is returned
  in "SourceFromRule" field}
 var
   index:integer;
 begin
   result:=false;
   if SyllableList.find(w,index) then
   begin
     w2:=TString(Syllablelist.objects[index]).str;
     result:=true;
     sourcefromrule:=0;
   end
   else if (level<=maxrecurselevel)
     and applyrules(w,level,w2, sourcefromrule) then
   begin
     result:=true;
   end;
   if not result then begin w2:=''; sourcefromrule:=0; end;
 end;

 (**************** GetPrefixRule **********)
function getPrefixrule(n:integer):TStringX3;
{Retrieve the rule strings for a particular prefix rule}
begin
  if (n>=low(prefixrules)) and (n<=high(prefixrules)) then
  begin
    if (n>=low(prefixrules)) and (n<=high(prefixrules)) then result:=prefixrules[n]
    else result:=blankrule;
  end;
end;

(************** GetSuffixRule ***********)
function GetSuffixrule(n:integer):TStringX3;
{Retrieve the rule strings for a particular suffix rule}
begin
  if (n>=low(suffixrules)) and (n<=high(suffixrules)) then result:=suffixrules[n]
    else result:=blankrule;
end;

end.
