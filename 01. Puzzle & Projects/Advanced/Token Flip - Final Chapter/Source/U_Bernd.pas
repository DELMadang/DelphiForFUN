unit U_Bernd;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Thanks for this linear algebraic technique for quickly solving problems to:}

{ Author: Bernd Hellema       }
{ Email : B.Hellema@zonnet.nl }
{ Date  : 26/03/2003          }
{ File  : TokenFlip.p         }

{ This program finds a solution for the Token Flip    }
{ Puzzle (http://www.delphiforfun.org).               }
{ Input : Inp (Array[0..sqr(gameSize)-1])             }
{ Output: Sol (Array[0..sqr(gameSize)-1])             }

{ The puzzle can be viewed as a matrixequation Ax=b.    }
{ The program uses the specific form of the matrix to }
{ create a nxn-matrix. This matrix is transformed to  }
{ an upper triangle matrix with Gauss elimination.    }
{ The total matrix is now an upper triangle matrix,   }
{ and the solution can be calculated.                 }

{This version (version 2, "final, final") finds the minimal solution
 by searching all solutions for a particular board and returning the
 one  with shortest move path length}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSolveForm = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    {procedure FormActivate(Sender: TObject);}
  end;

function getsolution:boolean;

var SolveForm: TSolveForm;

implementation

{$R *.dfm}

Uses U_FlipitFinal;

Const NMax = 200;

Type
  SolveRow   = Array[0..NMax] Of Boolean;
  PSolveRow  = ^SolveRow;
  SolveBlock = Array[0..NMax-1] Of PSolveRow;
  RowT	     = Array[0..NMax*NMax] Of Boolean;
  SolT	     = Array[0..NMax*NMax-1] Of Boolean;

Var
  NrSol          : Integer;
  L,SL		 : SolveBlock;
  Inp,Sol	 : SolT;
  Vars: SolveRow;

Procedure InitInput;
{Initializing Inp}
{Sets the starting configuration}
Var  i,j : Integer;
Begin
  For i := 0 To BoardSize-1 do
  for j:= 0 to boardsize-1 Do Inp[j*boardsize+i]:=form1.board.b[i,j];
End; { InitInput }

{************* LastBlock *************}
Procedure LastBlock(Var L: SolveBlock);
{Creates the last nxn-block for linear eqaution}
Var  r,k,i: Integer;
     Row  : RowT;
Begin
  For r := 0 To BoardSize-1 Do Begin
    {Init}
    For i := 0 To BoardSize-1 Do Begin
      Row[i] := (Abs(r-i) <= 1);
      Row[i+BoardSize] := (r=i);
    End;
    For i := 2*BoardSize To sqr(BoardSize)-1 Do Row[i] := False;
    Row[sqr(BoardSize)] := Not(Inp[r]);
    {Calculate}
    {Block 1..n-2}
    For k := 0 To sqr(BoardSize)-2*BoardSize-1 Do Begin
      If Row[k] Then Begin
	For i := k+BoardSize-1 To k+BoardSize+1 Do Begin
	  If (Abs(k mod BoardSize - i mod BoardSize) <= 1) Then Row[i] := Not Row[i];
	End;
        Row[k + 2*BoardSize] := Not Row[k + 2*BoardSize];
	Row[sqr(BoardSize)] := Row[sqr(BoardSize)] Xor Not(Inp[k+BoardSize]);
      End;
    End;
    {Block n-1}
    For k := sqr(BoardSize)-2*BoardSize To sqr(BoardSize)-BoardSize-1 Do Begin
      If Row[k] Then Begin
	For i := k+BoardSize-1 To k+BoardSize+1 Do Begin
	  If (Abs(k mod BoardSize - i mod BoardSize) <= 1) Then Row[i] := Not Row[i];
	End;
	Row[sqr(BoardSize)] := Row[sqr(BoardSize)] Xor Not(Inp[k+BoardSize]);
      End;
    End;
    {Copy To SolveBlock}
    new(L[r]);
    For i := 0 To BoardSize Do L[r]^[i] := Row[i+sqr(BoardSize)-boardsize];
  End;
End; { LastBlock }

{****************** Sweep ***************}
Procedure Sweep(Var L, SL : SolveBlock; Var Err: Boolean);
{Gauss elimination}
Var
  r,k,i	: integer;
  Done	: Boolean;
Begin
  Err:=False;
  NrSol := BoardSize;
  For r := 0 To BoardSize-1 Do SL[r] := Nil;
  For r := 0 To BoardSize-1 Do Begin
    k := 0;
    Done := False;
    While Not Done And (k < BoardSize) Do Begin
      While (k < BoardSize) And Not(L[r]^[k]) Do k := k+1;
      If k < BoardSize Then Begin
	If SL[k] = Nil Then Begin
	  SL[k] := L[r];
	  Done := True;
	  NrSol:=NrSol-1;
	End Else Begin
	  For i := 0 To BoardSize Do If SL[k]^[i] Then L[r]^[i] := Not L[r]^[i];
	  k := k+1;
	End;
      End Else Begin
	If L[r]^[BoardSize] Then Err:=True;
      End;
    End;
  End;
End; { Sweep }

(*
{**************** Solve ***************}
Procedure Solve(Var SL: SolveBlock; Var Sol: SolT);
{Calculates solution with a upper triangle matrix}
Var
  r,i,rx : integer;
Begin
  {Block n}
  For r := 1 To BoardSize Do Begin
    If SL[BoardSize-r] = Nil Then Begin
      Sol[Sqr(BoardSize)-r] := False;
    End Else Begin
      Sol[Sqr(BoardSize)-r] := SL[BoardSize-r]^[BoardSize];
      For i := 1 To r-1 Do Begin
	If (SL[BoardSize-r]^[BoardSize-i] And Sol[Sqr(BoardSize)-i]) Then Sol[Sqr(BoardSize)-r] := Not Sol[Sqr(BoardSize)-r];
      End;
    End;
  End;
  {Block n-1}
  For r := BoardSize+1 To 2*BoardSize Do Begin
    rx := sqr(BoardSize)-r;
    Sol[rx] := Not(Inp[rx+BoardSize]);
    For i := rx+BoardSize-1 To rx+BoardSize+1 Do Begin
      If Sol[i] And (Abs(rx mod BoardSize - i mod BoardSize) <= 1) Then Sol[rx] := Not Sol[rx];
    End;
  End;
  {Block 1..n-1}
  For r := 2*BoardSize+1 To sqr(BoardSize) Do Begin
    rx := sqr(BoardSize)-r;
    Sol[rx] := Not(Inp[rx+BoardSize]);
    For i := rx+BoardSize-1 To rx+BoardSize+1 Do Begin
      If Sol[i] And (Abs(rx mod BoardSize - i mod BoardSize) <= 1) Then Sol[rx] := Not Sol[rx];
    End;
    If Sol[rx + 2*BoardSize] Then Sol[rx] := Not Sol[rx];
  End;
End; { Solve }
*)


Procedure Solve(Var SL: SolveBlock; Var Sol: SolT);
{Calculates solution with a upper triangle matrix}
Var
  r,i,rx,ix,n : integer;
  b	      : boolean;
Begin
  {Block n}
  n := 0;
  For r := 1 To BoardSize Do Begin
    If SL[boardSize-r] = Nil Then Begin
      Sol[Sqr(boardSize)-r] := Vars[n];
      n := n+1;
    End Else Begin
      Sol[Sqr(boardSize)-r] := SL[boardsize-r]^[boardsize];
      For i := 1 To r-1 Do Begin
	If (SL[boardSize-r]^[boardSize-i] And Sol[Sqr(boardSize)-i]) Then Sol[Sqr(boardsize)-r] := Not Sol[Sqr(boardsize)-r];
      End;
    End;
  End;
  {Block n-1}
  For r := boardsize+1 To 2*boardsize Do Begin
    rx := sqr(boardsize)-r;
    Sol[rx] := Not(Inp[rx+boardsize]);
    For i := rx+boardsize-1 To rx+boardsize+1 Do Begin
      If Sol[i] And (Abs(rx mod boardsize - i mod boardsize) <= 1) Then Sol[rx] := Not Sol[rx];
    End;
  End;
  {Block 1..n-1}
  For r := 2*boardsize+1 To sqr(boardsize) Do Begin
    rx := sqr(boardsize)-r;
    Sol[rx] := Not(Inp[rx+boardsize]);
    For i := rx+boardsize-1 To rx+boardsize+1 Do Begin
      If Sol[i] And (Abs(rx mod boardsize - i mod boardsize) <= 1) Then Sol[rx] := Not Sol[rx];
    End;
    If Sol[rx + 2*boardsize] Then Sol[rx] := Not Sol[rx];
  End;
End; { Solve }

Procedure BestSolution(SL : SolveBlock; Var MinSol : SolT; Var moves : Integer);
{Calculates all solutions and selects the best one}
Var
  c,esc	: Boolean;
  m,i	: Integer;
  Sol	: SolT;
Begin
  For i:=0 To NrSol-1 Do Vars[i]:=False;

  {first solution}
  Solve(SL,MinSol);
  moves:=0;
  For i:=0 To sqr(boardsize)-1 Do moves:=moves+Ord(MinSol[i]);

  {next solutions}
  esc:=False;
  While Not esc Do Begin
    c:=True;
    i:=0;
    While c And (i<NrSol) Do Begin
      c:=c And Vars[i];
      Vars[i]:=Not Vars[i];
      i:=i+1;
    End;
    If c Then esc:=True
    Else Begin
      Solve(SL,Sol);
      m:=0;
      For i:=0 To sqr(boardsize)-1 Do m:=m+Ord(Sol[i]);
      If m<moves Then Begin
	moves:=m;
	MinSol:=Sol;
      End;
    End;
  End;
End; { BestSolution }

{********** Getsolution ***********}
function Getsolution:boolean;
{"production" version of finding solution without display}
  Var
  Err : Boolean;
  i,n, moves   : Integer;
Begin
  InitInput;
  LastBlock(L);
  Sweep(L,SL,Err);
  If Err Then result:=false
  else
  begin
    {Solve(SL,Sol);}
    BestSolution(SL,Sol,moves);
    setlength(form1.board.path,boardsize*boardsize);
    n:=-1;
    for i:= 0 to boardsize*boardsize-1 do
    with form1.board do
    begin
      if sol[i] then
      begin
        inc(n);
        form1.board.path[n].x:=(i mod boardsize);
        form1.board.path[n].y:=(i div boardsize);
      end;
    end;
    setlength(form1.board.path,n+1);
    result:=true;
  end;
end;



(*
{************** FormActivate ************}
procedure TSolveForm.FormActivate(Sender: TObject);
{Solves and displays usage message - used for debugging}
Var
  Err : Boolean;
  i,n   : Integer;
  s:string;
Begin
  memo1.clear;
  memo1.lines.add('BoardSize = '+inttostr(BoardSize));
  memo1.lines.add('Initializing');
  InitInput;
  memo1.lines.add('Creating LastBlock');
  LastBlock(L);
  memo1.lines.add('Sweeping LastBlock');
  Sweep(L,SL,Err);

  If Err Then Begin
    memo1.lines.add('Configuration has no solutions');
    exit;
  End;
  memo1.lines.add('#solutions = 2^'+inttostr(NrSol));
  memo1.lines.add('Calculating Solution');
  Solve(SL,Sol);
  memo1.lines.add('Writing Solution');
  memo1.lines.add('Done');

  setlength(form1.board.path,boardsize*boardsize);
  n:=-1;
  s:='';
  for i:= 0 to boardsize*boardsize-1 do
  with form1.board do
  begin
    if sol[i] then
    begin
      inc(n);
      form1.board.path[n].x:=(i mod boardsize);
      form1.board.path[n].y:=(i div boardsize);
    end;
    s:=s+inttostr(ord(sol[i]));
    if i mod boardsize=boardsize-1 then
    begin
      memo1.Lines.add(s);
      s:='';
    end;
  end;

  setlength(form1.board.path,n+1);
  modalresult:=mrok;
end;
*)

end.

