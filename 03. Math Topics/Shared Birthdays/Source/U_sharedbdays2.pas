unit U_sharedbdays2;
 { Copyright  © 2001-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    Memo2: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.FormActivate(Sender: TObject);
var
  p,PF1, PF2, PF2A, PF2B:extended;
  N:integer;
begin
  p := 1.0;
  pf2:=0.25/365.25; {probability that birthday is on Feb29}
  pf1:= 365/365.25; {probability that b'day is not on Feb 29}
  for N:= 2 to 100 do
  begin
    p  := p*(366-N)/365; {Probability of no share ignoring leap years}



    {pf2 =Probability that N birthdays are unique and one person is  Feb 29th
      mujst handled in 2 parts:}

     {a. When N enters, the N-1 are unique and have a single Feb29th which
         happens to be the previous Pf2 value and N can be any day except
         Feb 29th}
         PF2A :=PF2*(367-N)/365.25;

     {b. When N enters, then N-1 already there have unique birthdays and
         Feb 29th is not taken, just happens to be the previous PF1 value so
         N  must be a Feb 29th and  the probability is
         }
         PF2B:=PF1*(0.25/365.25);

     PF2:=PF2A+PF2B;

    {PF1 = probability that N birthdays are unique and none are Feb29th}
    PF1:=PF1*(366-N)/365.25;
    memo2.lines.add(format('%4d      %8.6f    %8.6f',[N,1-p,1-pf1-pf2]));
  end;
  memo2.selstart:=0;
  memo2.sellength:=1;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

end.
