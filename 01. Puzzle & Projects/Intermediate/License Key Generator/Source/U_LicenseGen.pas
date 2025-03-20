unit U_LicenseGen;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, dialogs,strutils,dffUtils,
  u_Rules;

type



  TDefRec =record
    FieldName:string;
    FieldValue:string;
    FieldLength:integer;
    MaxFieldLength:integer;
    VariableFlag:boolean;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    MakeEncDecBtn: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    DecryptBtn: TButton;
    DataMemo: TMemo;
    EncryptMemo: TMemo;
    MakeLicenseKeyBtn: TButton;
    DecryptMemo: TMemo;
    EncryptKeyMemo: TMemo;
    Label3: TLabel;
    Label5: TLabel;
    Defmemo: TMemo;
    randomSeedRBtn: TRadioButton;
    TisSeedRBtn: TRadioButton;
    RandSeedEdt: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    NbrSegsEdt: TEdit;
    Label4: TLabel;
    SegSizeEdt: TEdit;
    Label6: TLabel;
    ShowRukesBtnCkick: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure MakeEncDecBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MakeLicenseKeyBtnClick(Sender: TObject);
    procedure DecryptBtnClick(Sender: TObject);
    procedure randomSeedRBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowRukesBtnCkickClick(Sender: TObject);
  public
    Definerecs, Datarecs:array of TDefrec;
    keylist:TStringlist;
    err:string;
    function MakeDatarecs:boolean;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Type
  char=ansichar;
var
  masterkey:ANSIString='ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  encryptkey:ANSIString;

procedure shuffle(var deck:AnsiString);
  var
    i,n:integer;
    temp:char;
  begin
    i:= length(deck);
    while i>1 do
    begin
      n:=random(i)+1;
      temp:=deck[i];
      deck[i]:=deck[n];
      deck[n]:=temp;
      dec(i);
    end;
  end;

{*********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  keylist:=tStringlist.Create;;
  randomseedRBtnClick(Sender);
  SetmemoMargins(RulesForm.rulesmemo, 10,10,10,10);
  reformatMemo(RulesForm.rulesmemo);
end;

{****************** FormCreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
end;

{**********  MakeEncDecKeysBtnClick *********}
procedure TForm1.MakeEncDecBtnClick(Sender: TObject) ;
Var
  i:integer;
begin
  encryptkey:=masterkey;
  for i:=1 to 3 do shuffle(encryptKey);
  keylist.clear;
  for i:=1 to length(encryptkey) do keylist.add(masterkey[i]);
  with encryptkeymemo do
  begin
    clear;
    lines.add(masterkey);
    lines.add(encryptkey);
  end;
end;

{****************  MakeDataRecs **************}
function TForm1.MakeDatarecs:boolean;

    {------------ IsValidDef --------------}
    function IsvalidDef(var err:string):boolean;
    var
      i,vspace:integer;
      s2:string;
      list:TStrings;
    begin
      err:='';
      list:=DefMemo.lines;
      result:=true;
      setlength(definerecs,list.count);
      for i:=0 to list.Count-1 do
      with list, definerecs[i] do
      begin
        if (length(names[i])=0) or (length(values[names[i]])=0) then
        begin
          err:='Invalid field definition:'+list[i];
          result:=false;
          exit;
        end;
        fieldname:=names[i];
        s2:=values[fieldname];
        if s2[1]='V' then
        begin
          Vspace:=1;
          VariableFlag:=true;
          system.delete(s2,1,1);
        end
        else
        begin
          VariableFlag:=false;
          Vspace:=0;
        end;
        maxfieldlength:=strtointdef(s2, 0);

        if (maxfieldLength=0) or (upcase(s2[1])='X')
        {a leading "X" would have converted the number as hexadecimal!}
        then
        begin
          err:=format('Invalid field length: %s',[s2]);
          result:=false;
          exit;
        end;
        inc(maxFieldlength,VSpace);
      end;
    end; {IsValidDef}
var
  i,j:integer;
  list:TStrings;
  s:string;
  err:string;
  OK:boolean;
begin
  if (not isvalidDef(err)) then
  begin
    showmessage(err);
    result:=false;
    exit;
  end;
  result:=true;
  {defs look OK, continue}
  list:=datamemo.lines;
  setlength(datarecs,list.count);
  s:='';
  for i:=0 to list.Count-1 do
  with list, datarecs[i] do
  begin
    fieldname:=names[i];
    {find the defrec entry}
    OK:=false;
    for j:=0 to high(definerecs) do
    begin
      if Uppercase(definerecs[j].fieldname)=uppercase(fieldname) then
      begin
        maxfieldlength:=definerecs[j].maxfieldlength;
        VariableFlag:=definerecs[j].VariableFlag;
        OK:=true;
        break;
      end;
    end;
    if not OK then
    begin
      showmessage('Data field line: "' + list[i] + '" not defined.');
      result:=false;
      exit;
    end;


    FieldValue:=uppercase(values[fieldname]);
    for j:=length(fieldvalue) downto 1 do
    begin
      if not (fieldvalue[j] in ['A'..'Z','0'..'9']) then
      begin
        if not variableflag then
        begin
          showmessage(Format('Note: Fixed length field %s contains illegal character "s"'
                     +#13+'Replaced with "X"',[fieldname,fieldvalue[j]]));
        end
        else
        begin
          s:='"'+fieldvalue[j]+'", '+s;
          system.delete(fieldvalue,j,1);
        end;
      end;
    end;
    fieldlength:=length(FieldValue);
    if fieldlength>maxfieldlength then
    begin {truncate long fields}
      fieldlength:=maxfieldlength;
      fieldvalue:=copy(fieldvalue,1,fieldlength);
    end
    else if (not Variableflag) and (fieldlength<maxfieldlength) then
    begin {pad fixed length fields to fieldlength}
      fieldvalue:=fieldvalue+DupeString('X',maxfieldlength-fieldlength);
      fieldlength:=maxfieldlength;
    end;
  end;
  (*
  If s<>'' then showmessage
  ('Note: Special character(s) '+s+' deleted from variable length fields');
  *)
  result:=true;
end;

{************ MakeLicenseBtnClick **************}
procedure TForm1.MakeLicenseKeyBtnClick(Sender:TObject);
var
  i,j,index:integer;
  //list:TStrings;
  s:string;
  encrypteddata:string;
  segs,size:integer;
begin
  if not makedatarecs then exit; {errors found and reported}
  keylist.clear;
  if length(encryptkey)<>36 then
  begin
    Showmessage('Make encryption key first');
    exit;
  end;
  for i:=1 to length(encryptkey) do keylist.add(masterkey[i]);
  for i:=0 to high(Datarecs) do
  with datarecs[i] do
  begin
    If VariableFlag then
    begin
      index:=maxfieldlength-length(fieldvalue); {this is where to continue with the real data}
      {index is also 1 greater than the number of ranm "filler" characxters to insert}
      encrypteddata:=encrypteddata+char(ord('A')+index-1);
      {fill unused with random characters}
      for j:=1 to index-1 do encrypteddata:=encrypteddata+encryptKey[random(36)+1];
    end;
    for j:=1 to length(fieldvalue) do
    begin
      index:=keylist.indexof(fieldvalue[j]);
      if index>=0 then encrypteddata:=encrypteddata+encryptkey[index+1];
    end;
  end;
  encryptmemo.clear;
  segs:=strtointdef(nbrsegsedt.text,0);
  size:=strtointdef(segsizeEdt.text,0);
  s:='';
  if segs*size=length(encrypteddata) then
  begin
    for i:= 0 to segs-1 do
    begin
      s:=s+copy(encryptedData,i*size+1, size)+'-';
    end;
    delete(s,length(s),1);  {delete te extra [-]}
    encryptmemo.lines.add(s);
    decryptmemo.clear;
  end
  else
  if length(definerecs)=0 then
      showmessage('Make Encryption key first!')
  else showmessage(format('Sum of field lengths plus count of variable fields (%d) '
          +'must = nbr. of segments X segement size (%d)',[length(encrypteddata),segs*size]));
end;

{************* DecryptBtnClick **********}
procedure TForm1.DecryptBtnClick(Sender: TObject);
var
  decryptdata,s:string;
  i,j,index,len:integer;
begin
  with encryptmemo do
  begin
    s:=lines[0];
    for i:=1 to lines.count-1 do  s:=s+lines[i];
  end;

  s:=stringreplace(s,'-','',[rfreplaceall]);
  keylist.clear;
  for i:=1 to length(encryptkey) do keylist.add(encryptkey[i]);
  decryptmemo.clear;
  decryptdata:='';
  for i:=0 to high(datarecs) do
  with Datarecs[i] do
  begin
    decryptdata:='';
    if VariableFlag then
    begin
      len:=(ord(s[1])-ord('A')+1);
      delete(s,1,len);
      fieldlength:=maxfieldlength-len;
    end
    else fieldlength:=maxfieldlength;
    for j:=1 to fieldlength do
    begin
      index:=keylist.indexof(s[j]);
      if index>=0 then decryptdata:=decryptdata+masterkey[index+1];
    end;
    decryptmemo.lines.add(decryptdata);
    delete(s,1,fieldlength);
  end;
  scrolltotop(Decryptmemo);
end;

{************ RandomSeedRBtnClick ************}
procedure TForm1.randomSeedRBtnClick(Sender: TObject);
begin
  If RandomSeedRBtn.checked then
  begin
    RandseedEdt.text:=inttostr(randSeed);
    TisSeedRbtn.checked:=true;
  end
  else Randseed:=StrtoInt(randseedEdt.Text);
end;

{************** ShowRulesBtnClick *************}
procedure TForm1.ShowRukesBtnCkickClick(Sender: TObject);
begin
  rulesform.show;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

