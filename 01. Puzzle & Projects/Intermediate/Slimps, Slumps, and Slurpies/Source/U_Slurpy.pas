unit U_Slurpy;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A fairly useless program from the 1996 Mid-Atlantic Regional ACM
  programming Contest}
 {"A Slurpy is a string of  characters that has certain properties.  Your
program will read in strings of characters and output whether or not
they are Slurpys (Slurpies?) .

A Slump is a character string that has the following  properties:
1.   Its first character is either a 'D' or an 'E'.
2.   The first character is followed by a string of one or more 'F's.
3.   The string of one or more 'F's is followed by either a Slump or a
      'G'.  The Slump or 'G' that follows the F's ends the Slump.  

A Slimp is a character string that has the following  properties:
1.   Its first character is an 'A'.
2.   If it is a two character Slimp then its second  and last character is 
      an 'H'.
3.   If it is not a two character Slimp then it is in one of these two
      forms:
     a. 'A' followed by 'B' followed by a Slimp followed by a 'C'.
     b. 'A' followed by a Slump (see above)  followed by a 'C'.

A Slurpy is a character string that consists of a Slimp followed by a 
Slump."}

{Recognizing strings that obey defined rules is one of the major tasks of
a compiler.  So what we have here is the start of a "Slurpy" compiler!
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    TestBtn: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    InitialTestBtn: TButton;
    procedure TestBtnClick(Sender: TObject);
    procedure InitialTestBtnClick(Sender: TObject);
  public
    function IsaSlimp(s:string; var rest:string):boolean;
    function IsaSlump(s:string; var rest:string):boolean;
    function ISaSlurpy(s:string; var rest:string):boolean;
    function TestString(text:string):string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 {******************* IsASlump ***************}
 function TForm1.IsASlump(s:string; var rest:string):boolean;
 {If S is a slump - return true and set rest =  S with the slump removed}
 {Implements a recursive definition by calling itself}
 var
   i:integer;
 begin
   result:=false;
   if length(s)=0 then exit;
   If ((s[1]='D') or (s[1]='E')) then
   begin
     i:=2;
     while (i<length(s)) and (s[i]='F') do inc(i);
     if (i>2) then
     begin
       if (isaSlump(copy(s,i,length(s)-i+1),rest))
       then result:=true
       else
       if (s[i]='G') then
       begin
         rest:=copy(s,i+1,length(s)-i);
         result:=true;
       end;
     end;
   end;
 end;

 {********************* IsASlump *****************}
 function TForm1.IsASlimp(s:string; var rest:string):boolean;
 {If S is a slimp - return true and set rest =  S with the slimp removed}
 begin
   result:=false;
   If s[1]='A' then
   begin
     delete(s,1,1);
     if length(s)=0 then exit;
     if  (s[1]='H')
     then
     begin
       result:=true;
       rest:=copy(s,2,length(s)-1);
     end
     else
     if (length(s)>1) then
     if (s[1]='B') then
     begin
       s:=copy(s,2,length(s)-1);
       if IsaSlimp(s,rest) and (length(rest)>0) and (rest[1]='C') then
       begin
         delete(rest,1,1);
         result:=true;
      end;
     end
     else
     if isAslump(s,rest) and (length(rest)>0) and (rest[1]='C') then
     begin
       delete(rest,1,1);
       result:=true;
     end;
   end;
 end;

 {******************* IsASlurpy ****************}
 function TForm1.IsASlurpy(s:string; var rest:string):boolean;
{If S is a slurpy - return true and set rest =  S with the slurpy removed}
 var
   rest2:string;
 begin
   result:=false;
   if isaslimp(s,rest2)
   and IsASlump(rest2,rest)
   then result:=true;
 end;

{******************** TestString ***************}
 function TForm1.TestString(text:string):string;
 {test a string and return message saying what it is}
 var
   s,rest:string;
  begin
    if isaslump(text,rest)  and (rest='')
    then s:='Is a Slump' else s:='';
    if isaslimp(text,rest)  and (rest='')
    then s:=s+', Is a Slimp';
    if isaslurpy(text,rest) and (rest='')
    then s:=s+', Is a Slurpy';
    while (length(s)>0) and (s[1] in [',',' ']) do delete(s,1,1);
    if length(s)>0 then result:=' ('+s+')'
    else result:=' (Is not recognized)';
  end;


{********************* TestBtnClick ****************}
procedure TForm1.TestBtnClick(Sender: TObject);
{Test edit1.text to see if it is a Slimp, Slump, or Slurpy}
begin
  listbox1.items.add(edit1.text+teststring(edit1.text));
  listbox1.itemindex:=listbox1.items.count-1; {force item to scroll into view}
End;

{********************** InitialTextBtnClick *************}
procedure TForm1.InitialTestBtnClick(Sender: TObject);
{Process initial list of test strings looking for Slumps, Slimps and Slurpies}
var
  I:integer;
begin
  with listbox1 do
  for i:=0 to items.count-1 do
  if (items[i]<>'') and (items[i][1]<>'*')
  then  items[i]:=items[i]+ teststring(items[i]);
end;

end.
