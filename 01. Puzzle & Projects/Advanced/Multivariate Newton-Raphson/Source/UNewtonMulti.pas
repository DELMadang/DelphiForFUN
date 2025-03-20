unit UNewtonMulti;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses  SysUtils, StdCtrls, Dialogs, UMatrix;

type
  TGetResidualsAndJacobian=procedure(N:integer; X:TNVector; Var R:TNVector; var jac:TNMatrix);

  Function NewtonMulti(N, MaxIter:integer; Tolerance:extended;
                     var X:TnVector; var Iter:integer; memo1:TMemo;
                     CallbackRJ:TGetResidualsAndJacobian):boolean;

implementation

{************* NewtonMulti *************}
Function NewtonMulti(N, MaxIter:integer; Tolerance:extended;
                     var X:TnVector; var Iter:integer; memo1:TMemo;
                     CallbackRJ:TGetResidualsAndJacobian):boolean;
var
  i,j:integer;
  D:TnVector; {delta variable changes for each interation}
  {Jacobian and Inverse Jacobian matrices evaluated for current variable values}
  Jac,JacI:TNMatrix;
  R, MinusR:TNVector; {Current Residuals evaluating function with current X values}
  err:byte;
  loopcount:integer; {loop counter}
  tolmet:boolean;

     {--------- ShowVect ----------}
       procedure showvect(Title:string; dim:integer; Vec:TNVector);
       {display vector}
       var
         j:integer;
         s:string;
       begin
         if memo1=nil then exit;
         with memo1, lines do
         begin
           add(Title);
           begin
             s:='';
             for j:=1 to n do s:=s+format(' %6.3f',[Vec[j]]);
             add(s);
           end;
         end;
       end;

       {------------ ShowMat -----------}
       procedure showmat(Title:string; dim:integer; Vec:TNMatrix);
       {Display matrix values}
       var
         i,j:integer;
         s:string;
       begin
         if memo1=nil then exit;
         with memo1, lines do
         begin
           add(Title);
           for i:=1 to N do
           begin
             s:='';
             for j:=1 to n do s:=s+format(' %6.3f',[Vec[i,j]]);
             add(s);
           end;
         end;
       end;

       {------------ Multiply -----------}
      Procedure Multiply (dim:integer;a:TNMatrix; b:  TNVector; var M:TNvector; var Err:byte);
      Var
      i,j:  integer;
        temp :  extended;
      begin
        for i := 1 TO dim do
        begin
          temp := 0.0;
          for j := 1 to dim do  temp := temp + a[i,j]*b[j];
            M[i] := temp;
        end;
      end {MultiplyMatrices};


begin
  {clear the array, not necessary, just helps debugging}
  for i:=1 to TnArraySize do
  begin
    R[i]:=0;
    MinusR[i]:=0;
    for j:=1 to TnArraySize do
    begin
      Jac[i,j]:=0;
      JacI[i,j]:=0;
    end;
  end;
  {Now for the iteration loop}
  loopcount:=0;
  repeat
    inc(loopcount);
    if memo1<>nil then
    with memo1.lines do
    begin
      add('');
      add('Iteration '+inttostr(loopcount));
      add('--------------');
      showvect('Current trial X,Y',2,x); {show current x,y values}
    end;
    {residuals, R, are current function values and  should converge to 0 as we get
     closer to true X,Y values}
    {GetResidualsAndJacobian}CallbackRJ(N,X,R,Jac);
    Showvect('Residuals',N,r);
    showmat('Jacobian Matrix (Function partial derivatives with respect to each variable)',N,Jac);

    {The delta x,y values for next iteration can be calculated as -R/Jac
     or D=-R*JacInverse}
    Inverse(N,jac,jacI,Err);
    if err=0 then
    begin
      for i:=1 to n do MinusR[i]:=-R[i];
      multiply(N,JacI,MinusR,D,err);
      if err=0 then
      begin
        showmat('Inverse Jacobian Matrix',N,JacI);
        showvect('Change in variable values after multiplying Residuals by inverse Jacobian',N,D);
        {Get new variable value estimates}
        for i:=1 to N do x[i]:=x[i]+D[i];
        tolmet:=true;
        for i:=1 to N do if abs(r[i])>tolerance then tolmet:=false;
      end
      else showmessage('Matrix mutlipication failed');
    end
    else showmessage('Jacobian invverse calc failed');
  until (err>0) or  (tolmet) or (loopcount>=Maxiter);
  Iter:=loopcount;
  If tolmet then  result:=true else result:=false;
end;

end.
