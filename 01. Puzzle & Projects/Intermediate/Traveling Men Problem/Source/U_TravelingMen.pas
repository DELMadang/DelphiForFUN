unit U_TravelingMen;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This is a program which solves the following logic problem:

                                  TRAVELING MEN


Mr. Barclay and five of his friends, each of whom works in a different field,
just returned from business trips.  Each man used two different methods of
transportation during his trip.  All six traveled by either plane or train,
but not both, and all six also traveled by bus, boat, or trolley.  No two used
the same two methods of transportation.  From the information provided,
determine the first and last names of each man, his field (one deals in
precious gems), and the two methods of travel he used on his business trip.


1.  Mr. Rogers, who is not Vince or Russ, and Mr. Whitman together, used four
    different methods of transportation.

2.  Mr. Potter traveled by bus.  The oil company executive visited an area that
    can only be reached by a boat from the mainland.

3.  Neither Myron, nor Russ, nor Mr. Henley, nor the mining engineer traveled
    by trolley.

4.  Neither Leroy, who traveled by bus, nor Jeremy is the manufacturer.

5.  The agricultural representative did not fly to his destination.

6.  Vince, who is not Mr. Henley, traveled by boat.

7.  Dennis and Mr. Rogers traveled by train.  Mr. Strong traveled by plane.

8.  Both Mr. Whitman and the research scientist traveled by trolley
}

{The program performsan exhaustive search examining all possible permutations
 of the digits 1 to 6 generated at 3 levels: Travel modes, last names, and
 occupations.  No need to permute first name since they can be associated with
 other characteristics based on the ordering of the digits (position 1 = Dennis,
 position 2 = Jeremy, etc.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UComboV2, CheckLst, ComCtrls, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    CheckBtn: TButton;
    CheckBox1: TCheckBox;
    CheckRule: TCheckListBox;
    totlbl: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    Panel1: TPanel;
    StaticText1: TStaticText;
    procedure CheckBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


var
 firstnames:array[1..6] of string =('Dennis, ','Jeremy, ', 'Leroy, ', 'Myron, ',
                                     'Russ, ', 'Vince, ');
 lastnames:array[1..6] of string =('Barclay, ','Henley, ', 'Potter, ', 'Rogers, ',
                                     'Strong, ', 'Whitman, ');
 Jobnames:array[1..6] of string =('Agriculture, ','Gems, ', 'Mfg., ', 'Mining, ',
                                     'Oil, ', 'Research, ');
 Travelnames:array[1..6] of string =('Plane/Boat','Plane/Bus', 'Plane/Trolley',
             'Train/Boat', 'Train/Bus', 'Train/Trolley');

Const
  {We will assume we are checking first names in this order}
  Dennis=1; Jeremy=2; Leroy=3; Myron=4; Russ=5; Vince=6;
  {Then we will permute these 6 travel mode combinations, filtering as we go}
  PlaneBoat=1; PlaneBus=2; PlaneTrolley=3; TrainBoat=4; TrainBus=5; TrainTrolley=6;

  {Any that pass First name  travel mode rules will get checked against last name
   rules with names permuted in this order}
  Barclay=1; Henley=2; Potter=3; Rogers=4; Strong=5;Whitman=6;

  {Finally remaining possibilities will get checked against rule that involve
   occupations in thisa oprder}
  Ag=1; Gems=2; Mfg=3; Mining=4; Oil=5; Research=6;


 {Since transportation mode numbers represent 2 modes each, we'll use these
 functions for testing in rules that involve only a single mode}
 Function Plane(n:integer):boolean;
        begin  result:= (n<=3); end;
 Function Train(n:integer):boolean;
        begin  result:= (n>3) end;
 Function Boat(n:integer):boolean;
        begin  result:= (n=1) or (n=4) end;
 Function Bus(n:integer):boolean;
        begin  result:= (n=2) or (n=5) end;
 Function trolley(n:integer):boolean;
        begin  result:= (n=3) or (n=6); end;

{********* CheckBtnClick ************}
procedure TForm1.CheckBtnClick(Sender: TObject);

var
  Lnames, jobs, travel:TComboset;
  n,i,n2,i2,j:integer;
  totcount:integer;

begin
  memo1.clear;
  Lnames:=TComboset.create;
  jobs:=TComboset.create;
  travel:=TComboset.create;
  totcount:=0;
  begin
    if tag>0 then
    begin
      Checkbtn.caption := 'Count possible outcoms';
      tag:=0;
      screen.cursor:=crDefault;
      memo1.lines.add('Search interrupted by user');
      exit;
    end;

    screen.cursor:=crHourGlass;
    checkbtn.caption:='Stop';
    tag:=1; {indicate the search is running}

     {*****************************}
     {****** Travel mode loop *****}
     {*****************************}
     Travel.setup(6,6,permutations);
     while (tag=1) and Travel.getnext do
     begin

        {Leroy is Bus (#4)}
       if checkrule.checked[15] then
       begin
         n:=Travel.selected[Leroy];
         if not  Bus(n) then continue;
       end;

       {Vince is Boat (#6)}
       if checkrule.checked[19] then
       begin
         n:=Travel.selected[Vince];
         if not Boat(n) then continue;
       end;

       {Dennis is Train (#7)}
       if checkrule.checked[21] then
       begin
         n:=Travel.selected[Dennis];
         if not train(n) then continue;
       end;

       {Myron not Trolley (#3) }
        if checkrule.checked[6] then
        begin
         n:=Travel.selected[Myron];
         if  Trolley(n)  then continue;
       end;

       {Russ not trolley (#3)}
        if checkrule.checked[7] then
        begin
         n:=Travel.selected[Russ];
         if  Trolley(n) then continue;
       end;

       


       {***************************}
       {***** Lastnames loop ******}
       {***************************}
       Lnames.setup(6,6,permutations);
       while (tag=1) and Lnames.Getnext do
       begin

         {Strong is Plane (#7)}
         if checkrule.checked[24] then
         begin
           i:=1;
           while lnames.selected[i]<>Strong do inc(i);
           n:=travel.selected[i];
           if  not  plane(n) then continue;
         end;

         {Rogers is Train (#7)}
         if checkrule.checked[25] then
         begin
            i:=1;
           while lnames.selected[i]<>Rogers do inc(i);
           n:=travel.selected[i];
           if not train(n) then continue;
         end;

        {Whitman is Trolley (#8)}
         if checkrule.checked[26] then
         begin
           i:=1;
           while lnames.selected[i]<>Whitman do inc(i);
           n:=travel.selected[i];
           if not Trolley(n) then continue;
         end;

         {Whitman and  Rogers must use 4 modes of travel (#1)}
          if checkrule.checked[2] then
         begin
           i:=1;
           while lnames.selected[i]<>Whitman do inc(i);
           n:=Travel.selected[i];  {Whitman's travel modes}
           i2:=1;
           while lnames.selected[i2]<>Rogers do inc(i2);
           n2:=Travel.selected[i2];  {Roger's travel modes}
           If (n<= 3) and  (n2<=3) then continue;  {both plane - skip}
           If (n>3) and  (n2>3) then continue; {both train - skip}
           If n>3 then dec(n,3)  else dec(n2,3); {Reduce train guy to plane}
           If n=n2 then continue; {if same [boat,bus,trolley] - skip}
         end;

          {Dennis is not Rogers (#7)}
          if checkrule.checked[22] then
          begin
           if LNames.selected[Dennis]=Rogers then continue;
         end;

         {Russ is not Rogers or Whitman(#1)}
         if checkrule.checked[0] then
         begin
           n:=LNames.selected[Russ];
           if (n=Rogers) or (n=Whitman) then continue;
         end;

          {Vince is not Rogers or Whitman (#1)}
          if checkrule.checked[1] then
         begin
           n:=LNames.selected[Vince];
           if (n=Rogers) or (n=Whitman) then continue;
         end;


         

         {Potter is Bus (#2)}
          if checkrule.checked[3] then
         begin
           i:=1;
           while lnames.selected[i]<>Potter do inc(i);
           n:=travel.selected[i];
           if not Bus(n) then continue;
         end;

         {Myron is not Henley (#3)}
         if checkrule.checked[8] then
         begin
           n:=LNames.selected[Myron];
           if (n=Henley) then continue;
         end;



         {Russ is not Henley (#3)}
         if checkrule.checked[9] then
         begin
           n:=LNames.selected[Russ];
           if (n=Henley) then continue;
         end;


         {Henley not trolley (#3)}
         if checkrule.checked[10] then
         begin
         i:=1;
           while lnames.selected[i]<>Henley do inc(i);
           n:=travel.selected[i];
           if  Trolley(n) then continue;
         end;


          {Vince is not Henley (#6)}
         if checkrule.checked[20] then
         begin
           n:=LNames.selected[Vince];
           if (n=Henley)then continue;
         end;


         {Dennis is not Strong (#7)}
         if checkrule.checked[23] then
         begin
           if LNames.selected[Dennis]=Strong then continue;
         end;

         
         {***************************}
         {****** Jobnames loop ******}
         {***************************}
         Jobs.setup(6,6,permutations);
         while Jobs.getnext do
         begin

           {Oil is Boat (#2)}
           if checkrule.checked[5] then
           begin
             i:=1;
             while Jobs.selected[i]<>Oil do inc(i);
             n:=travel.selected[i];
             if not Boat(n) then continue;
           end;

           {Research is  Trolley (#8)}
           if checkrule.checked[28] then
           begin
             i:=1;
             while Jobs.selected[i]<>Research do inc(i);
             n:=travel.selected[i];
             if not Trolley(n) then continue;
           end;

           {Potter is not Oil (#2)}
            if checkrule.checked[4] then
           begin
             i:=1;
             while lnames.selected[i]<>Potter do inc(i);
             n:=jobs.selected[i];
            if n=Oil then continue;
          end;

           {Russ is not Mining (#3)}
           if checkrule.checked[11] then
           begin
              If jobs.selected[Russ]=Mining then continue;
           end;


           {Myron is Not mining (#3)}
           if checkrule.checked[12] then
           begin
             If jobs.selected[Myron]=Mining then continue;
           end;


           {Henley is not mining (#3)}
           if checkrule.checked[13] then
           begin
             i:=1;
             while lnames.selected[i]<>Henley do inc(i);
             n:=jobs.selected[i];
             if n=Mining then continue;
           end;


           {Mining not Trolley (#3)}
           if checkrule.checked[14] then
           begin
             i:=1;
             while Jobs.selected[i]<>Mining do inc(i);
             n:=travel.selected[i];
             if  Trolley(n) then continue;
           end;

           {Jeremy is not Mfg (#4)}
           if checkrule.checked[16] then
           begin
             If jobs.selected[Jeremy]=Mfg then continue;
           end;

           {Leroy is not Mfg (#4)}
           if checkrule.checked[17] then
           begin
             If jobs.selected[Leroy]=Mfg then continue;
           end;

           {Agriculture not Plane (#5)}
           if checkrule.checked[18] then
           begin
             i:=1;
             while Jobs.selected[i]<>Ag do inc(i);
             n:=travel.selected[i];
             if Plane(n) then continue;
           end;

          {Whitman is not research (#8)}
          if checkrule.checked[27] then
          begin
            i:=1;
            while Lnames.selected[i]<>Whitman do inc(i);
            n:=Jobs.selected[i];
            if n=research then continue;
          end;

           inc(totcount);  {one more that passed all selected rules}

           if totcount and 1023 = 0 then {update search status once in awhile}
           begin
             totlbl.caption:= inttostr(totcount)+' cases checked';
             application.processmessages; {update totlbl and check for "stop" click}
           end;
           if (checkbox1.checked) and (totcount<=1000)  then
           with memo1.lines do
           begin
             add('');

             add('Possibility #'+inttostr(totcount));
             for n:=1 to 6 do
             add(firstnames[n]
              +lastnames[lnames.selected[n]]
              +jobnames[jobs.selected[n]]
              +travelnames[travel.selected[n]]
              );
              application.processmessages; {if displaying detail, recognizing stop
                              could take a while uless we let the system check here}
           end;
         end;
       end;
     end;
   end;

   memo1.Lines.add('');
   {count the number of rules applied}
   j:=0;
   for i:=0 to checkrule.items.count-1 do if checkrule.checked[i] then inc(j);
   if totcount>1 then memo1.lines.add('After applying '+inttostr(j) +' rules, '
           +  'there are '+inttostr(totcount)+' possible outcomes.')
   else memo1.lines.add('After applying '+inttostr(j) +' rules, '
           +  'there is only 1 possible outcome!');

   {reset everything for next time}
   jobs.free;
   lnames.free;
   travel.free;
   Checkbtn.caption := 'Count possible outcoms';
   tag:=0;
   screen.cursor:=crDefault;
end;

procedure TForm1.FormActivate(Sender: TObject);
var i:integer;
begin
  for i:= 0 to checkrule.items.count-1 do checkrule.checked[i]:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

