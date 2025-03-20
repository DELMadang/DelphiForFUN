unit U_StateAbbreviationSearch;
 {This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    DisplayLbl: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    states,abbrevs:TStringlist;
    procedure ShowInitial;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 const

    {The States TStringlist will contain this "Name"="Value" format data as an
     easy way to get both}
    data:array[0..49] of string=
    ('Alabama=AL','Alaska=AK','Arizona=AZ','Arkansas=AR','California=CA',
    'Colorado=CO','Connecticut=CT','Delaware=DE','Florida=FL','Georgia=GA',
    'Hawaii=HI','Idaho=ID','Illinois=IL','Indiana=IN','Iowa=IA',
    'Kansas=KS','Kentucky=KY','Louisiana=LA','Maine=ME','Maryland=MD',
    'Massachusetts=MA','Michigan=MI','Minnesota=MN','Mississippi=MS','Missouri=MO',
    'Montana=MT','Nebraska=NE','Nevada=NV','New Hampshire=NH','New Jersey=NJ',
    'New Mexico=NM','New York=NY','North Carolina=NC','North Dakota=ND','Ohio=OH',
    'Oklahoma=OK','Oregon=OR','Pennsylvania=PA','Rhode Island=RI','South Carolina=SC',
    'South Dakota=SD','Tennessee=TN','Texas=TX','Utah=UT','Vermont=VT',
    'Virginia=VA','Washington=WA','West Virginia=WV','Wisconsin=WI','Wyoming=WY');

{********** Formcreate *************}
procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin {Initialize the two lists used for diplaying and solving}
  states:=Tstringlist.create;
  abbrevs:=tstringlist.create;
  for i:=0 to 49 do
  begin
    States.add(data[i]);
    abbrevs.add(states.values[states.names[i]]);  {Make separate list of abbreviaitons}
  end;
  abbrevs.sort; {sort abbreviaitons so we can use "find" method for faster search}
  ShowInitial;
end;


{************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject) ;
var
  i,j:integer;
  s,test,found:string;
  count,index:integer;
begin
  if tag=1 then showinitial
  else
  begin
    memo2.clear;
    for i:=0 to 49 do {for each state}
    begin
      count:=0; {count of abbreviaitions in this state}
      s:=states.names[i];
      {make state name upper case and remove blanks in case abbreviation crosses words}
      s:=uppercase(stringreplace(s,' ','',[rfreplaceall]));
      j:=1; {abbrev search location index}
      found:='';  {string of found abbreviaitoins for this state}
      repeat
        test:=s[j]+s[j+1];  {test letter pair}
        if abbrevs.find(test,index) then
        begin {found a valid abbreviation}
          inc(count);
          found:=found+test+', '; {save it for display}
          inc(j,2); {jump 2 letters to avoid overlaps}
        end
        else inc(j); {otherwise move to next letter}
      until j>=length(s);
      if count>0 then delete(found,length(found)-1,2);
      memo2.lines.add(format('%s: %s (%d)',[states.names[i],found,count]));
    end;
    memo2.selstart:=0; memo2.sellength:=0;  {scroll memo2 back to top}
    displayLbl.caption:='State abbreviations embedded in names';
    searchbtn.caption:='Show standard state abbreviations list';
    tag:=1;
  end;
end;

{^^^^^^^^^^^^ ShowInitial ************}
procedure TForm1.ShowInitial;
var i:integer;
begin  {Display the inital state list with standard abbreviations }
  memo2.lines.clear;
  for i:=0 to 49 do  Memo2.lines.add(states[i]); {Make list of state names and abbreviaations}
  memo2.selstart:=0; memo2.sellength:=0;  {scroll memo2 back to top}
  displayLbl.caption:='Standard State name abbreviations';
  searchbtn.caption:='Search for embedded abbreviations';
  tag:=0;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
