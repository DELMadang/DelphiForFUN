unit U_problem18;

(*
  By starting at the top of the triangle below and moving to adjacent numbers
  on the row below, the maximum total from top to bottom is 23.

   3
  7 5
 2 4 6
8 5 9 3

That is, 3 + 7 + 4 + 9 = 23.

Find the maximum total from top to bottom for the following triangle.

                                64
                               45 63
                              75 09 91
                             15 72 84 86
                            88 02 72 19 22
                          28 35 37 80 41 57
                         10 60 31 25 20 24 92
                        12 71 56 48 04 39 51 04
                       45 20 15 19 08 32 01 15 85
                      27 66 98 14 22 58 14 20 73 18
                    18 87 60 14 82 55 98 03 24 34 84
                   09 48 56 50 33 35 45 62 85 33 07 31
                  44 91 55 47 38 06 52 53 51 02 84 24 60
                30 53 87 92 96 95 59 02 13 32 11 85 74 37
               54 10 60 29 59 73 57 97 92 85 20 45 77 75 36
              56 88 29 37 96 64 39 20 29 43 95 01 63 30 86 91
            23 86 39 97 41 42 67 52 82 34 66 58 87 73 08 73 43
          33 84 07 75 58 60 47 76 13 55 16 41 36 53 38 45 37 38
         50 35 05 44 26 51 51 46 24 72 71 63 66 85 34 93 43 81 97
        70 32 76 47 46 59 55 57 01 67 43 83 72 21 01 77 17 35 44 22
      90 21 88 97 56 70 24 71 21 48 05 11 85 28 71 24 35 35 96 21 44
     32 58 05 09 12 29 87 03 30 01 24 65 52 28 80 05 36 01 21 32 26 36
   25 21 85 01 21 87 47 56 55 99 86 31 79 12 27 11 63 17 65 62 36 36 21
 80 48 22 17 54 63 93 79 65 68 92 61 05 17 68 98 25 88 83 83 02 84 47 69
36 32 74 93 70 36 68 30 37 30 25 67 27 75 69 11 83 70 16 06 26 89 43 90 92

NOTE: You are not expected to try every route to solve this problem, as there
are 16777216 altogether! If you could check 100 routes every second it would
take nearly 2 years to check them all. There is a clever way to solve it. ;o)
*)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var

  strdata:array[1..25] of string=(
    '64',
    '45 63',
    '75 09 91',
    '15 72 84 86',
    '88 02 72 19 22',
    '28 35 37 80 41 57',
    '10 60 31 25 20 24 92',
    '12 71 56 48 04 39 51 04',
    '45 20 15 19 08 32 01 15 85',
    '27 66 98 14 22 58 14 20 73 18',
    '18 87 60 14 82 55 98 03 24 34 84',
    '09 48 56 50 33 35 45 62 85 33 07 31',
    '44 91 55 47 38 06 52 53 51 02 84 24 60',
    '30 53 87 92 96 95 59 02 13 32 11 85 74 37',
    '54 10 60 29 59 73 57 97 92 85 20 45 77 75 36',
    '56 88 29 37 96 64 39 20 29 43 95 01 63 30 86 91',
    '23 86 39 97 41 42 67 52 82 34 66 58 87 73 08 73 43',
    '33 84 07 75 58 60 47 76 13 55 16 41 36 53 38 45 37 38',
    '50 35 05 44 26 51 51 46 24 72 71 63 66 85 34 93 43 81 97',
    '70 32 76 47 46 59 55 57 01 67 43 83 72 21 01 77 17 35 44 22',
    '90 21 88 97 56 70 24 71 21 48 05 11 85 28 71 24 35 35 96 21 44',
    '32 58 05 09 12 29 87 03 30 01 24 65 52 28 80 05 36 01 21 32 26 36',
    '25 21 85 01 21 87 47 56 55 99 86 31 79 12 27 11 63 17 65 62 36 36 21',
    '80 48 22 17 54 63 93 79 65 68 92 61 05 17 68 98 25 88 83 83 02 84 47 69',
    '36 32 74 93 70 36 68 30 37 30 25 67 27 75 69 11 83 70 16 06 26 89 43 90 92');
  
    (* {test data}
    strdata:array[1..25] of string =
       ('03 ',
        '07 05 ',
        '02 04 06 ',
        '08 05 09 03 ',
        '00','00','00','00','00','00','00','00','00','00',
        '00','00','00','00','00','00','00','00','00','00',
        '00');
      *)

procedure TForm1.Button1Click(Sender: TObject);
var
  data:array[1..25,1..25] of integer;
  path:array[1..25,1..25] of string;
  c,r,n:integer;
  s:string;
begin
  {here's the trick - starting at the next to last row, replace each entry with
   the largest valued path from there to the ned and delete the last row,
   back up a row and do it again, etc.}
  for c:=1 to 25 do for r:= 1 to 25 do data[c,r]:=0;
  for r:= 1 to 25 do
  begin
    s:=strdata[r];
    c:=1;
    while (c<=r) {and (3*c<=length(s))}  do
    begin
      data[c,r]:=strtoint(copy(s,3*c-2,2));
      inc(c);
    end;
  end;
  for c:=1 to 25 do path[c,25]:=inttostr(data[c,25]);
  for r := 24 downto 1 do
  begin
    for c:=1 to r do
    begin
      If data[c,r+1]>data[c+1,r+1] then n:=c else n:=c+1;
        path[c,r]:= inttostr(data[c,r])+','+path[n,r+1];
        {if r=1 then path[1,1]:=inttostr(data[c,r])+','+path[n,r+1];}
        data[c,r]:= data[c,r]+data[n,r+1];
    end;

  end;

  showmessage('Max path is '+path[1,1]+#13+'Sum is '+inttostr(data[1,1]));
end;

end.
