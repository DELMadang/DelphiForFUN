unit U_Kirkman1;
 {Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {
 Fifteen young ladies of a school walk out three
abreast for seven days in succession: it is
required to arrange them daily so that no two
shall walk abreast more than once.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UTGraphSearch, shellapi;

type
  TForm1 = class(TForm)
    SearchBtn: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    SaveBtn: TButton;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    running:boolean;
    solcount:integer;
    startcount,freq:int64;
    solutions:array of TStringList;
    nbrunique:integer;
    List:TGraphlist;
    procedure goalfound;
    procedure Setsolutions(n:integer);
    function checksolution(Sol:Tstringlist):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{*************** SearchBtnClick ***********}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Start the search for solutions}
var i:integer;
begin
  if running then
  begin
    running:=false;
    searchbtn.caption:='Search for solution';
    list.stop:=true;
    exit;
  end;
  list.clear;
  listbox1.clear;
  screen.cursor:=crHourGlass;
  running:=true;
  solcount:=0;
  for i:=0 to high(solutions) do solutions[i].clear;
  searchbtn.caption:='Stop search';
  queryperformancefrequency(freq);
  queryperformancecounter(startcount);
  list.MakePathsToDF(Goalfound); {start the search}
  searchbtn.caption:='Search for solution';
  screen.cursor:=crDefault;
end;

{************ GoalFound ***********}
procedure TForm1.goalfound;
{Called by List when a solution is found}
var
  i:integer;
  s:string;
  time:double;
  counter:int64;

begin
  with list do
  begin
    inc(solcount);
    if solcount>=length(solutions) then setsolutions(50); {add 50 more solution lists}
    Listbox1.items.add(format('Soluton # %3d ',[solcount]));
    queryperformancecounter(counter);
    time:=(counter-startcount) /freq;
    listbox1.items.add(
        format('Nodes searched  %10.0n    Rate %10.0n nodes/sec, Time: %5.0n secs',
                     [nodessearched+0.0,nodessearched/time, time+0.0]));
     listbox1.items.add('[ABC,DEF,GHI,JKL,MNO]');
     solutions[solcount-1].add('ABC');
     solutions[solcount-1].add('DEF');
     solutions[solcount-1].add('GHI');
     solutions[solcount-1].add('JKL');
     solutions[solcount-1].add('MNO');

     s:='[';
     for i:=0 to QG.count-1 do
     begin
       s:=s+TGroup(Qg[i]).g+',';  {add a group}
       solutions[solcount-1].add(TGroup(Qg[i]).g);
       if i mod 5 = 4 then
       begin
         s[length(s)]:=']';
         listbox1.items.add(s);
         s:='['; {start a new block }
       end;
     end;
     if checksolution(solutions[solcount-1]) then listbox1.items.add('Validated')
     else listbox1.items.add('Invalid!!!!!!!!!!!!!');
     listbox1.items.add('');
   end;
end;


{**************** FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:=true;
  list.stop:=true; {set stop flag}
end;

{******************* FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  list:=TGraphlist.create;
  setlength(solutions, 0);
  setsolutions(10);
end;


{*************** SetSolutions *********}
procedure TForm1.Setsolutions(n:integer);
{Increase length of solutons array by "n"}
var
  oldlength:integer;
  i:integer;
begin
  oldlength:=length(solutions);
  setlength(solutions,oldlength+n);
  for i:= oldlength to oldlength+n-1 do solutions[i]:=TStringlist.create;
end;

{************* SaveBtnClick ************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save the current set of solutions to a file}
var
  i:integer;
  f:Textfile;
begin
  list.stop:=true;
  application.processmessages;
  sleep(1000);
  if (solcount>0) and  savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    for i:=0 to solcount-1 do
    begin
      writeln(f,'#'+inttostr(i+1));
      write(f,solutions[i].text);
    end;
    closefile(f);
  end;
end;

{*********** StaticText1Click ********}
procedure TForm1.StaticText1Click(Sender: TObject);
{Copyright notice clicked}
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{**************** CheckSolution ****************}
function TForm1.checksolution(Sol:Tstringlist):boolean;
{Return true if this list represents a valid solution, false otherwise}
{make sure that there are 35 entries
 also each girl must be paired with each of the other 14 girls.
 also each set of 5 groups must contain all 15 letters "A" through "O"}
var
  i,j:integer;
  s,ss:string;
  girls:array['A'..'O'] of boolean;
  pairs:array['A'..'O', 'A'..'O'] of boolean;
  ch1,ch2:char;

    function updatepairs(const g:string):boolean;
    begin
      if (not pairs[g[1],g[2]]) and
         (not pairs[g[1],g[3]]) and
         (not pairs[g[2],g[3]]) then
      begin
        pairs[g[1],g[2]]:=true;
        pairs[g[1],g[3]]:=true;
        pairs[g[2],g[3]]:=true;
        result:=true;
      end
      else result:=false;
    end;

begin
  result:=true;
  if sol.count=35 then
  begin
    for ch1:='A' to 'O' do
      for ch2:='A' to 'O' do pairs[ch1,ch2]:=false;
    for i:=0 to sol.count-1 do
    begin
      if i mod 5 =0 then for ch1:='A' to 'O' do girls[ch1]:=false; {new day}
      if length(sol[i])=3 then
      begin
        s:=sol[i];
        for j:= 1 to 3 do
        begin
          if (not girls[s[j]]) then girls[s[j]]:=true
          else result:=false; {duplicated girl in a day}
        end;
        if not result then break;
        if not updatepairs(s) then result:=false; {pair occurs more than once}
      end
      else result:=false; {group length <>3}
    end;
  end
  else result:=false;{not 35 entries}
end;

end.
