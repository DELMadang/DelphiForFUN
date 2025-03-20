unit U_Speedtest;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, uintlist, ExtCtrls, mathslib,
  Spin;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    String1Btn: TButton;
    Memo1: TMemo;
    IntBtn: TButton;
    NbrEntriesEdt: TLabeledEdit;
    NbrTrialsEdt: TLabeledEdit;
    Memo2: TMemo;
    EntrysizeEdt: TSpinEdit;
    Label1: TLabel;
    SearchGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure StringBtnClick(Sender: TObject);
    procedure IntBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
     entrysize, Buildcount, Searchcount, Foundcount, Nbrtrials:integer;
      buildseconds, searchseconds: double;
     Maxvalue:int64;
     freq, startcount,endcount:int64;
     S_List:TStringlist;
     I_List:TIntlist;
     ProgramName:string;
     procedure Setup(listtype:string);
     procedure Buildlist(ListType:char);
     Procedure SearchList(Listtype:char);
     Procedure Showresults(ListType:char; TrialNbr:integer);
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

//var
{************** FormCreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
var   n:integer;
begin
  s_list:=TStringlist.create;
  I_List:=TIntList.create;
  ProgramName:=extractfilename(application.ExeName);
  n := pos('.EXE', uppercase(ProgramName));
  if n>0 then delete(ProgramName,n, 4);
  caption:= 'String and Integer lists timimg tests - Program: '+ ProgramName;
  memo2.Lines.Add('*********** '+ ProgramName +' ***********');
end;




{********* StringBtnClick ************}
 procedure TForm1.StringBtnClick(Sender: TObject) ;
 Var
   M:integer;

begin
  screen.cursor:=crhourglass;
  setup('String');
  for M:=1 to nbrtrials do
  begin
    Buildlist('S');
    SearchList('S');
    ShowResults('S',M);
  end;
  screen.cursor:=crDefault;
end;



  {*********** IntBtnClick ***********}
procedure TForm1.IntBtnClick(Sender: TObject);
  Var
   M:integer;
 begin
   screen.cursor:=crhourglass;
   setup('Integer');
   for M:=1 to nbrtrials do
   begin
     Buildlist('I');
     SearchList('I');
     Showresults('I',M);
   end;
   screen.cursor:=crDefault;
end;


{************** Procedure Setup **************}
procedure TForm1.setup(listtype:string);
begin
  buildcount:=strtointdef(NbrEntriesEdt.Text,100000);
  searchcount:=buildcount div 2;
  entrysize:=entrysizeedt.Value;
  nbrtrials:=strtointdef(Nbrtrialsedt.Text,3);
  maxvalue:=intpower(10,entrysize);
  memo2.lines.add('');
  memo2.lines.add(format('** %s List - %.0n records of with %d letters or digits **',
                         [ListType,0.0+buildcount,entrysize]));
  queryPerformanceFrequency(freq);
end;

{************ BuildList ************}
procedure TForm1.Buildlist(ListType:char);
var
   i,j:integer;
   n:int64;
   s:string;
begin

     If listType='S' then
     begin
       S_List.clear;
       S_List.Sorted:=false;
     end
     else
     begin
       I_List.clear;
       I_List.Sorted:=false;
     end;
     queryPerformanceCounter(startcount);
     screen.cursor:=crHourGlass;
     for i:=1 to buildcount do
     begin
       If listType='S' then
       begin
         s:='';
         {only use first 10 letters to keep universe of keys same as for integeer lists}
         for j:=1 to entrysize do s:=s+ char(ord('A')+random(10));
         S_list.add(s);
       end
       else
       begin
         n:=random(maxvalue);
         I_List.add(n);
       end;
     end;
      if listType='S' then s_List.sort else I_List.sort;
     queryperformanceCounter(endcount);
     buildseconds:=((endcount-startcount))/freq;
   end;

   {************ SearcjList **************}
   Procedure TForm1.SearchList(Listtype:char);
   var
     i,j,index:integer;
     n:int64;
     s:string;
   begin
     foundcount:=0;
     QueryPerformanceCounter(startcount);
     for i:=1 to searchcount do
     begin
       If listtype='S' then
       begin
         if searchgrp.itemindex=0 then
         begin  {random key within the list}
           j:=random(buildcount);
           s:=s_list[j];
         end
         else
         begin  {random key which may or may not be in list}
           s:='';
           for j:=1 to entrysize do s:=s+ char(ord('A')+random(10));
         end;
         if S_list.find(s,index) then inc(foundcount);
       end
       else
       begin
         if searchgrp.itemindex=0 then
         begin  {random key within the list}
           j:=random(buildcount);
           n:=I_list[j];
         end
         else
         begin  {random key which may or may not be in list}
           n:=random(maxvalue);
         end;
         if I_List.find(n,index) then inc(foundcount);
       end;
     end;
     queryperformanceCounter(endcount);
     searchseconds:=((endcount-startcount))/freq;
     if searchseconds=0 then searchseconds:=1e-6;
   end;

   {************ Showresults ***********8}
   Procedure TForm1.Showresults(ListType:char; TrialNbr:integer);
   var  s:string;
   begin
     if listtype='S' then s:='string' else s:='integer';
     memo2.lines.add(format('------- Trial %d ---------------',[TrialNbr]));
     memo2.Lines.Add(format(
     'Built %.0n %s records in %5.3f seconds.  Found %.0n random records in %5.3f seconds, %.0n searches/second',
                      [ 0.0+buildcount, s, buildseconds, 0.0+foundcount,  searchseconds, 0.0+searchcount/searchseconds]));
   end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;





end.
