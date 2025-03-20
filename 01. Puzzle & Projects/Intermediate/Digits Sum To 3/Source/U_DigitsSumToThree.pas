unit U_DigitsSumToThree;
{Copyright © 2017, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, {Grids, strUtils,} UComboV2, DFFUtils,
  U_ExplainDlg
  ;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    GenerateAllBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    AgorithmBtn: TButton;
    Button1: TButton;
    Memo3: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure GenerateAllBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AgorithmBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    List:TStringList;
    procedure BuildNumberList;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  list:=TStringList.create;
end;

{************ BuildNumberList *********}
procedure TForm1.buildNumberList;
var
  i,j,sum:integer;
  s:string;
  begin
    list.clear;
    for i:=3 to 300000 do
    begin
      s:=inttostr(i);
      sum:=0;
      for j:=1 to length(s)do
      begin
        case s[j] of
         '0': begin end;
         '1': inc(sum);
         '2': inc(sum,2);
         '3': inc(sum,3);
         else sum:=4;
        end;
        if sum>3 then break;
      end;
      if sum=3 then  list.add(s);
    end;
  end;

  
{***************** GenerateAlBtnClick **************}
procedure TForm1.GenerateAllBtnClick(Sender: TObject);
var
  i:integer;
begin
  memo1.Clear;
  BuildNumberList;
  For i:=0 to list.count-1do
  begin
    memo1.lines.add(format('#%d %s',[i+1,list[i]]));
  end;
  movetotop(memo1);
end;


{************** AlgorithmBtnClick ************}
procedure TForm1.AgorithmBtnClick(Sender: TObject);

  {------------- MakeNextNumber ------------}
  function MakeNextNumber(var list:TStringlist; startat:integer):Boolean;
  {Generate next level solution digits based on previous level}
  var
    i,j,size,stopat:integer;
    s,snew:string;
  begin
    result:=false;

    if length(list[list.count-1])>=6 then
    begin
      result:=true;
      exit;
    end
    else

    begin
      stopat:=list.count;
      for i:=startat to stopat-1 do {The previous level index range}
      begin
        s:=list[i];  {get the  next number}
        if s[1]<>'D' then  {if not a duplicate}
        begin
          snew:=s;  {initialize the number to have a zero inserted after each nonzero digit}
          size:=length(s);
          for j:=1 to size do {look for non-zero digits in this number}
          begin
            if s[j]<>'0' then   {found one}
            begin
              insert('0',snew,j+1); {Insert the zero}
              if list.indexof(snew)>=0 {has this number aredy been generatedf?}
              then Snew:='Duplicate:'+snew; {if yes, mark it a duplicate}
              list.Add(snew);  {add it to the new level group}
              snew:=s; {reset the number the previous level # we are processing on}
            end;
          end; {digits in number loop}
        end; {not a duplicate #}
      end; {For all number in previous level}
    end;
    if length(list[list.count-1])<6 then {not done yet,  do the next level}
    result:=MakenextNumber(List,stopat);
  end;



   {------------- ShowList -------------}
   procedure showlist(List:TStringList; Title:string);
   var
     i, duplicates:integer;
   begin   {Count the number  duplicates in the list soe we can show the user the unieque number count}
     duplicates:=0;
     for i:=0 to list.count-1 do if list[i][1]='D' then inc(duplicates);
     with memo1.Lines do
     begin
       add('');
       add(format('%s: %d Total, %d Dups, %d Unique',
               [title, list.count,duplicates, list.count-duplicates]));
       for i:=0 to list.count-1 do add(list[i]);
     end;
   end;


var
  i:integer;
  list3, List12, list21, list111:Tstringlist;
  s:string;
begin  {AlgorithmBtnClick}
  {Make a list for each digit group}
  List3:=Tstringlist.Create;
  List12:=Tstringlist.create;
  List21:=TStringlist.Create;
  List111:=TStringList.Create;

  {Apply algorithm to each group}
  List3.Add('3');
  MakenextNumber(List3,0);

  List12.Add('12');
  MakenextNumber(List12,0);

  List21.Add('21');
  MakenextNumber(List21,0);

  List111.Add('111');
  MakenextNumber(List111,0);

  memo1.Clear;
  {show the result lists}
  with memo1.lines do
  begin
    showlist(List3,'"3" only numbers');
    showlist(List12, '"12" numbers');
    showlist(List21, '"21} numbers');
    showlist(List111, '"111" numbers');
    movetotop(memo1);
  end;


end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  Explaindlg.showmodal;
end;


end.
