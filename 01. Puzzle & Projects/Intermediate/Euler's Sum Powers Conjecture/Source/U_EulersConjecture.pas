unit U_EulersConjecture;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


 {Lander, Parkin Algorithm
http://www.ams.org/journals/mcom/1967-21-097/S0025-5718-1967-0220669-3/S0025-5718-1967-0220669-3.pdf
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Spin;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo5: TMemo;
    GoBtn: TButton;
    PowerEdt: TSpinEdit;
    Label1: TLabel;
    MaxNGrp: TRadioGroup;
    Label3: TLabel;
    NbrtermsEdt: TSpinEdit;
    Label4: TLabel;
    Memo1: TMemo;
    MinNGrp: TRadioGroup;
    StopBtn: TButton;
    AllowDupsBox: TCheckBox;
    MaxSolutionsEdt: TEdit;
    Label2: TLabel;
    HideDupsBox: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    nbrterms, nbrvalues, minvalue, powerval:integer;
    powers:array of int64;

end;



var
  Form1: TForm1;

implementation

{$R *.DFM}

uses Mathslib, DFFUtils;




type
  Termrec=record
    N, NP:int64;
  end;

tTermsRec=record
  solterms:array of integer;

end;

var values:array[0..5] of integer=(1,10,100,250,500,1000);

{************ GoBtnClick ***********}
procedure TForm1.GoBtnClick(Sender: TObject);
var
  i:integer;
  terms:array of int64;
  roots:array of integer;  {"roots" are the integers and "terms" are the powers of the integers}
  starttime:TDatetime;
  //solutions:TStringlist; {string versions of the roots to help identify "solutions"
  //                        which are just multiples of terms already found}
  maxsolutions:integer;
  terminc:integer;  {term value increment, 0 allows duplicate terms}
  msg:string;
  loopcount:int64;
  uniquecount, duplicatecount:integer;

 (*
  {------------ UniqueSolution ------------}
  function uniquesolution:boolean;
  {Return true if this solution is not a duplicate of one already found}
  var   i,j:integer;
        s, news:string;
        oldroot:integer;

  begin
    news:='';
    for i:=0 to nbrterms-1 do news:=news+format('%4d',[roots[i]]);
    if solutions.count=0 then
    begin
      result:=true;
      solutions.add(news);
    end
    else
    for i:=0 to solutions.Count-1 do
    begin
      result:=false;
      s:=solutions[i];
      for j:= 0 to nbrterms-1 do
      begin
        oldroot:=strtoint(copy(s,4*j+1,4));
        if ((oldroot=1) and (roots[j]<>1)) {fixes a bug when  duplicates are allowed
                                            and all roots are "1"s in the first
                                            solutionin which case  mod always
                                            returns 0 and  all other  solutions
                                            were counted  as duplicates}
        or (roots[j] mod oldroot <> 0) then
        begin
          result:=true;
          break;  {one difference is enough to make solution unique}
        end;
      end;
      if not result then break {we processed an entire solution which was a multiple}
    end;
    if result then solutions.Add(news);   {at least one root is not a multiple so solution is unique}
  end;
*)

function UniqueSolution:boolean;
  {Return true if this solution is not a duplicate of one already found}
var
  i:integer;
  news:string;
begin
  result:=gcdmany(roots)=1;
  if result then inc(uniqueCount) else inc(duplicateCount);
end;


  {----------------- GetTerm ------------------}
  function getterm(termnbr, index:integer):boolean;
  {Recursive routine to try all values up to specified max for specified
   number of terms}
  var i,j:integer;
      sum:int64;
      s1,s2:string;
      dupmsg:string;
      secs:int64;
      unique:boolean;
  begin
    result:=true;
    inc(loopcount);
    if loopcount and $FFFFFF =0  then
    begin
       secs:=trunc((now-starttime)*secsperday);
       if secs>0 then
       begin
         label4.caption:= format('Checking from  value %d',[roots[0]])
         +#13+format('Tested %.0n terms', [0.0+loopcount])
         +#13+format('in %d seconds.', [secs])
         +#13+ format('Rate: %.0n per second', [loopcount/(secs)]);
         application.processmessages;
       end;
    end;
    //if termnbr=1 then application.processmessages;
    terms[termnbr]:=powers[index];
    roots[termnbr]:=index+minvalue;

    if termnbr<nbrterms-1 then
    begin
      for i:=index+terminc to high(powers)  do {terminc=0 if duplicates are allowed, 1 otherwise}
      begin
        result:=getterm(termnbr+1,i);
        if tag>0then break;
      end
    end
    else
    begin  {we have all the terms, check for solution}
      sum:=terms[0];
      for j:=1 to nbrterms-1 do inc(sum,terms[j]);
      j:=index+1;
      while powers[j]<sum do inc(j);
      if powers[j]=sum then
      begin
        if uniquecount>maxsolutions then
        begin
          tag:=2;
          exit;
        end;
        unique:=uniqueSolution;
        if  unique or (not hidedupsbox.checked) then
        begin
          if unique then dupmsg:='Unique' else dupmsg:='Duplicate';
          //s1:='('; {expanded version - unneccesary?}
          s2:='';
          for i:=0 to nbrterms-1  do
          begin
            //s1:=s1+format('%.0n + ',[0.0+terms[i]]);
            s2:=s2+format('%d^%d + ',[roots[i],powerval]);
          end;

          //s1[length(s1)-1]:='='; s1:=s1+format('%.0n)', [0.0+sum]);
          s2[length(s2)-1]:='='; s2:=s2+format('%d^%d',[j+minvalue,powerval]);
          with memo1.lines do
          begin
            add(format('%s Solution in %.0n seconds: %s',[dupmsg,(now-starttime)*secsperday,s2]));
            //add('     '+s1);
          end;
        end;
        exit;
      end;
    end;
  end;

begin {GoBtnClick}
  minvalue:=values[minNgrp.itemindex];
  nbrvalues:=values[maxNgrp.itemindex+1];
  nbrterms:=nbrtermsEdt.value;
  powerval:=poweredt.value;
  //solutions:=Tstringlist.create; {Hold a string version of each solution
  //                                so multiples can be eliminated}
  maxsolutions:=strtointdef(maxsolutionsEdt.text,100);
  if allowdupsbox.Checked then terminc:=0 else terminc:=1;
  setlength(powers, nbrvalues);
  setlength(roots, nbrterms);
  setlength(terms,nbrterms);
  for i:= 0 to high(powers) do powers[i]:=intpower(i+minvalue,powerval);
  memo1.clear;
  label4.caption:='';
  screen.cursor:=crHourGlass;
  tag:=0;
  stopbtn.BringToFront;
  loopcount:=0;
  uniquecount:=0;
  duplicatecount:=0;
  starttime:=now;
  for i:= 0 to nbrvalues-nbrterms do
  begin
    if tag>0 then break;
    getterm(0,i);
  end;
  if tag=1 then msg:='Search interrupted by user'

  else if tag=2 then msg:=format('Max number (%d) unique solutions found',[maxsolutions])
  else msg:=format('%d unique and %d duplicate solutions found',[uniquecount,duplicatecount]);
  showmessage(msg);
  stopbtn.SendToBack; {hide stop button}
  screen.cursor:=crdefault;
end;

{**************** Stopbtn ****************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1; {Non-zero tag will stop execution}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  reformatmemo(memo5);
end;

end.
