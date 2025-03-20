unit U_GaussianElim;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Adapted from Borland Toolbox
   - Numerical Methods,  Copyright © 1987 Borland International}
{
 A program illustrating a technique for solving a system of linear equations
 using Gaussian Elimination with Partial Pivoting as described in
 "Numerical Analysis" Bunden & Faires, 1985 pp 291-304 & 324-327.

  Inputs are from a file containing  the number of variables on the first line,
  a matrix of equation coefficients, one equation per line, ,
  and a vector containing the constant terms, one value per line.

The provided sample data file, SAMPLE6A.TXT, solves this set of equations:

w + 2x - z =10
-w + 4x + 3y - 0.5z = 21.5
2w + 2x + y - 3z = 26
3y - 4z = 37

}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Matrix, ShellAPI;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Label1: TLabel;
    ReadBtn: TButton;
    Label2: TLabel;
    StaticText1: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure ReadBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    fileloaded:Boolean;
    procedure GetDataFromFile(var Dimen        : integer;
                          var Coefficients : TNmatrix;
                          var Constants    : TNvector);
    procedure Results(Dimen        : integer;
              var Coefficients : TNmatrix;
              var Constants    : TNvector;
              var Solution     : TNvector;
                  Error        : byte);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


var
  Dimen : integer;          { Dimen of the square matrix }
  Coefficients : TNmatrix;  { The matrix }
  Constants : TNvector;     { Constant terms in the equations }
  Solution : TNvector;      { Solution to the set of equations }
  Error : byte;             { Flags if something went wrong }

{********* Initial ***********}
procedure Initial(var Dimen        : integer;
                  var Coefficients : TNmatrix;
                  var Constants    : TNvector);

{----------------------------------------------------------}
{- Output: Dimen, Coefficients, Constants                 -}
{-                                                        -}
{- This procedure intializes the above variables to zero. -}
{----------------------------------------------------------}

begin
  Dimen := 0;
  FillChar(Coefficients, SizeOf(Coefficients), 0);
  FillChar(Constants, SizeOf(Constants), 0);
end; { procedure Initial }

{************ GetdataFromFile **********8}
procedure TForm1.GetDataFromFile(var Dimen        : integer;
                          var Coefficients : TNmatrix;
                          var Constants    : TNvector);

{--------------------------------------------------}
{- Output: Dimen, Coefficients, Constants         -}
{-                                                -}
{- This procedure sets the value of Dimen,        -}
{- Coefficients and Constants from file input     -}
{--------------------------------------------------}

var
  InFile : textfile;
  Row, Column : integer;

begin
  if opendialog1.execute then
  begin
    fileloaded:=true;
    memo3.Clear;
    memo3.lines.loadfromfile(opendialog1.filename);
    assignfile(Infile,opendialog1.filename);
    reset(infile);
    Read(InFile, Dimen);
    Row := 0;
    while (not eof(Infile)) and (Row < Dimen) do
    begin
      Row := Succ(Row);
      Column := 0;
      while (not eof(Infile)) and (Column < Dimen) do
      begin
        Column := Succ(Column);
        Read(InFile, Coefficients[Row, Column]);
      end;
    end;
    if not eof(Infile) then
    begin
      Row := 0;
      while (not eof(infile)) and (Row < Dimen) do
      begin
        Row := Succ(Row);
        Read(InFile, Constants[Row]);
      end;
    end;
    Closefile(InFile);
  end;
  
end; { procedure GetDataFromFile }

{*********** Results ************}
procedure TForm1.Results(Dimen        : integer;
              var Coefficients : TNmatrix;
              var Constants    : TNvector;
              var Solution     : TNvector;
                  Error        : byte);

{------------------------------------------------------------}
{- This procedure outputs the results to the device OutFile -}
{------------------------------------------------------------}

var
  Column, Row : integer;
  s:string;
begin
  with memo1.lines do
  begin
    clear;
    add('');
    add('The coefficients: ');

    for Row := 1 to Dimen do
    begin
      s:='';
      for Column := 1 to Dimen do
        s:=s+ format('%10.4f', [Coefficients[Row, Column]]);
      add(s);
    end;
    add('');
    add('The constants:');
    for Row := 1 to Dimen do
      add(format('%10.4f',[Constants[Row]]));
    add('');
    if Error >= 1 then  add('ERROR: ');
    case Error of
      0 : begin
          add('The solution:');
          for Row := 1 to Dimen do
            add(format('%10.4f',[Solution[Row]]));
          add('');
        end;

      1 : add('The dimension of the matrix must be greater than 1.');

      2 : Add('There is no solution to this set of equations.');

    end; { case }
  end;
end; { procedure Results }


{********** SolveBtnClick *********}
procedure TForm1.SolveBtnClick(Sender: TObject);
begin
  if fileLoaded then
  begin
    memo1.clear;
    Partial_Pivoting(Dimen, Coefficients, Constants, Solution, Error);
    Results(Dimen, Coefficients, Constants, Solution, Error);
  end;
end;

{****** ReadBtnClick ******8}
procedure TForm1.ReadBtnClick(Sender: TObject);
begin
  Initial(Dimen, Coefficients, Constants);
  GetDataFromFile(Dimen, Coefficients, Constants);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{***********  FormActivate ********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  FileLoaded:=false;
end;

end.
