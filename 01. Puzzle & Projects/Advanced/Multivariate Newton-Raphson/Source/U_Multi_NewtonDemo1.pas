unit U_Multi_NewtonDemo1;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This is an intial version to test a our NewtonMulti procedure which  finds
zeros of a system of non-linear (or linear) equations using the
Newton_Raphson algorithm}

{For simplicity, this program only solves only quadratic polynomal systems with
 1 to 4  variables and equations


 We must provide 3 items for the NewtomMulti procedure:

 1. Initial guesses for variable values which wil satisfy the equations.
 2. Code to calculate the partial derivatives of each function with respect to
    the variables. This is the NxN Jacobian matrix.
 3. Code to evaluate the residual values for each new "guess" made by NewtobMulti

 The users provides the required the Step1 values for the call to Newtonmulti.
 Step2 and Step 3 values are calculated in a callback function whose address is
 provided to NewtonMulti.


 For this demo we'll semi-generalize the representations by limiting the
 equations to quadratics which have linear derivatives (Ax+B) so that we can calculate
 the Jacobian from an array of A coefficients and and vector of B constant terms.
}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  StdCtrls, ShellAPI, Inifiles, {uMatrix,} UNewtonMulti, Spin;

type

  TForm1 = class(TForm)
    Solvebtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Xedt: TEdit;
    XLbl: TLabel;
    YEdt: TEdit;
    YLbl: TLabel;
    MaxiterEdt: TEdit;
    Label3: TLabel;
    MaxTolEdt: TEdit;
    Label5: TLabel;
    Label4: TLabel;
    StaticText1: TStaticText;
    VerboseBox: TCheckBox;
    SetCoeffBtn: TButton;
    ZLbl: TLabel;
    WLbl: TLabel;
    ZEdt: TEdit;
    WEdt: TEdit;
    NbrVar: TSpinEdit;
    Label8: TLabel;
    LoadBtn: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CurrentLbl: TLabel;
    DescLbl: TLabel;
    Button1: TButton;
    procedure SolvebtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SetCoeffBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NbrVarChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
  public
    Ininame:string;
    Procedure SetEditsFromCoefficients;
    Procedure SetCoefficientsFromEdits;
    function formatequation(i:integer):string;
  end;

var
  Form1: TForm1;

implementation

uses Math, U_CoeffDlg1;

{$R *.dfm}

var
  Dim:integer;
  JacX2Coeff, JacXCoeff:TNMatrix;  {Values required calculate Jacobian}
  JacConst:TNVector;
  varname:array[1..4] of char =('X','Y','Z','W');

{******** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
{Zero out matrices, just to make debugging easier}
var
  i,j:integer;
begin
  {clear all matrices, not required -just helps in debugging}
  for i:=1 to TnArraySize do
  begin
    JacConst[i]:=0;
    for j:=1 to TNArraySize do
    begin
      JacX2Coeff[i,j]:=0;
      JacXCoeff[i,j]:=0;
    end;
  end;
  dim:=nbrvar.Value;
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
end;

{******** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
   NbrVarChange(Sender); {Set up inital equation displays}
  setcoefficientsfromedits; {load initial set of coefficients}
end;


{------------ GetresidualsAndJacobian --------------}
  procedure getResidualsAndJacobian(N:integer; X:TNVector; Var R:TNVector; var jac:TNMatrix);
  {This is the callback procedure so we can provide  NewtonMulti procedure with
  Residual (R) and Jacobian (Jac) values for the current variable (X) estimates
  as it does its thing}
  var
    i,j:integer;
    begin
      {Evaluate the functions}
      for i:=1 to N do  {need changes here if n<>2}
      begin
         r[i]:=JacConst[i];
         for j:=1 to Dim do
         R[i]:=R[i]+ jacx2coeff[i,j]*x[j]*x[j] +jacxcoeff[i,j]*x[j];
       end;

      {Evaluate the current Jacobian matrix}
      for i:=1 to N do
      for j:= 1 to N do
        jac[i,j]:=2*JacX2Coeff[i,j]*x[j]+jacxCoeff[i,j];
    end;

{************* FormatEquation ************}
function TForm1.formatequation(i:integer):string;
{Format equation "i" for display by eliminating 0 value terms,
 and coefficients with value of 1}
var
  j:integer;
  s:string;
  signsqr,sign:string;{array[1..4] of char} {used for equation formatting}
  varstr, var2str, val2str, valstr:string;
begin
  s:='';
  for j:=1 to dim do
  begin
    if jacx2coeff[i,j]<0 then signsqr:=' - '
    else if j=1 then signsqr:=' ' else signsqr:=' + ';
    if jacxcoeff[i,j]<0 then sign:=' - '
    else sign:=' + ';
    val2str:=format( '%f ',[abs(jacx2coeff[i,j])]);
    valstr:=format( '%f ',[abs(jacxcoeff[i,j])]);
    var2str:=varname[j]+'^2';
    varstr:=varname[j];
    if jacx2coeff[i,j]=0 then
    begin
      val2str:='';
      signsqr:='';
      var2str:='';
    end
    else if abs(jacx2coeff[i,j])=1.0 then val2str:='';
    if jacxcoeff[i,j]=0 then
    begin
      valstr:='';
      sign:='';
      varstr:='';
    end
    else if abs(jacxcoeff[i,j])=1.0 then valstr:='';
    s:=s+signsqr+val2str+var2str+sign+valstr+varstr;
  end;
  if jacconst[i]<0 then s:=s+' - ' else s:=s+ ' + ';
  If jacConst[i]<>0 then s:=s+format('%f = 0',[abs(jacConst[i])])
  else s:=s+' = 0';
  result:=s;
end;


{************* SolvebtnClick ************}
procedure TForm1.SolvebtnClick(Sender: TObject);
var
  X:TNVector; {Current variable estimates}
  N:integer;
  maxiter, iter:integer;
  Tol:Extended;

  s:string;
  memo:TMemo;  {Set to Memo1 or Nil depending on verbose checkbox}
  i:integer;
  dec:integer;

        {--------- ShowVarVect ----------}
       procedure showVarVect(Title:string; dim:integer; Vec:TNVector);
       {display variable vector with variable names}
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
             dec:=-trunc(log10(Tol));
             for j:=1 to n do s:=s+format('  %s = %.*f',[varname[j], dec, Vec[j]]);
             add(s);
           end;
         end;
       end;

begin
  N:=nbrvar.value; {dimension}
  {Solving the non-linear system
     (Initially -
         f1(x,y)=x^2+y^2-4=0
         f2(x,y)=x^2-y+1=0

   The "Jacobian Matrix"  is the array fo partial derivatives of the functions
   with respect to the variables
   d(f1)/d(x)= 2x  d(f1)/d(y)= 2y
   d(f2)/d(x)= 2X  d(f2)/d(y)= -1

   For this application we'll semi-generalize the representations by separating
   J into to matrices JacX2Coeff, JacXCoeff for the coefficients and JacConst
   of a pair of quadratic equations}

   SetCoefficientsFromEdits;
   (*
   with memo1,lines do
   begin
     clear;
     add('Solving equations:');


     {make a decent display of the equations being solved}
     for i:=1 to nbrvar.value do
     begin
       s:=formatequation(i);

       add(format('Eq %d: ',[i]));
       add(s);
       add('');
     end;
   end;
   *)
   {We need an initial guess for each solution}
   x[1]:=StrToFloatDef(Xedt.text,1.0); {X value}
   x[2]:=StrtoFloatDef(YEdt.Text,2.0); {Y Value}
   x[3]:=StrToFloatDef(Zedt.text,1.0); {Z value}
   x[4]:=StrtoFloatDef(WEdt.Text,2.0); {W Value}

   {Now we can start the search for a solution}
   If verbosebox.checked then memo:=memo1 else memo:=nil;

   Maxiter:=StrtoIntDef(MaxIterEdt.Text,0);
   Tol:=StrToFloatDef(MaxTolEdt.text,0.0001);
   with memo1.lines do
   begin
     add('-----------------------------');
     If NewtonMulti(N,   {dimension}
                  MaxIter,  {max nbr of iterations}
                  Tol,      {max valua of residuals to call it a success}
                  X,        {the solution vextor}
                  Iter,     {the actual number of iterations before stopping}
                  Memo,     {set to a Tmemo to display intermediate result, nil othewise}
                  GetResidualsAndJacobian)  {the callback procedure to provide R and Jac valies}
     then
     begin
       add(format('Solved in %d iterations',[iter]));
       showVarVect('SOLUTION',N, X);
     end
     else if iter>1 then
     begin
       add(format('Residual tolerance not met in %d iterations',[iter]));
       showVarVect('SOLUTION',N, X);
     end
     else add('Singular matrix prevents finding solution');
   end;
end;



{************* SetCoefficientsFromEdits ***********}
procedure TForm1.setCoefficientsfromEdits;
var
  r:integer;
  s:string;
begin
  with CoeffDlg, memo1, lines  do
  begin
    clear;
    add('Current equations:');
    for r:=1 to dim do
    begin
      JacX2Coeff[r,1]:=edits[r,1].val;
      Jacxcoeff[r,1]:= edits[r,2].val;
      JacX2Coeff[r,2]:=edits[r,3].val;
      JacXCoeff[r,2]:=edits[r,4].val;
      JacX2Coeff[r,3]:=edits[r,5].val;
      Jacxcoeff[r,3]:= edits[r,6].val;
      JacX2Coeff[r,4]:=edits[r,7].val;
      JacXCoeff[r,4]:=edits[r,8].val;
      JacConst[r]:= edits[r,9].val;
      {make a decent display of the equations being solved}
      s:=formatequation(r);
      add(format('Eq %d: ',[r]));
      add(s);
      add('');
    end;  
  end;
end;

{************ SetEditFromCoefficients *********}
procedure TForm1.setEditsFromCoefficients;
var
  r,c:integer;
begin
  with CoeffDlg do
  begin
    for r:=1 to nbrvar.value do
    begin
      edits[r,1].val:=JacX2Coeff[r,1];;
      edits[r,2].val:=Jacxcoeff[r,1];
      edits[r,3].val:=JacX2Coeff[r,2];
      edits[r,4].val:=JacXCoeff[r,2];
      edits[r,5].val:=JacX2Coeff[r,3];;
      edits[r,6].val:=Jacxcoeff[r,3];
      edits[r,7].val:=JacX2Coeff[r,4];
      edits[r,8].val:=JacXCoeff[r,4];

      edits[r,9].val:=JacConst[r];
      for c:=1 to 5 do
      with edits[r,c].edit do
      begin
        text:=floattostr(edits[r,c].val);
        color:=clWindow;
      end;
    end;
  end;
end;

{********** SetCoeffBtnClick **********}
procedure TForm1.SetCoeffBtnClick(Sender: TObject);
{Set up and show the dialog to allow user to modify coefficients}
begin
  SetEditsFromCoefficients;
  if CoeffDlg.showmodal=mrOK
  then SetCoefficientsfromEdits
  else
  begin
    seteditsfromcoefficients;
    showmessage('Coefficients not changed');
  end;
end;


{************* NbrVarChange *********}
procedure TForm1.NbrVarChange(Sender: TObject);
{Numer of variable change, change visibility of terms and equations to match
 new dimension}
var
  i,j:integer;

     {----------- SetVis -------------}
     procedure setVis(Lbl:Tlabel; Edt:Tedit; showorhide:boolean);
     {Show or hide initial guess vaiable value fields}
     begin
       Lbl.Visible:=showorhide;
       Edt.Visible:=showOrHide;
     end;
begin {NbrVarChange}  Dim:=Nbrvar.Value;
  {hide all edits > dim}
  with CoeffDlg do
  for i:=1 to 4 do
  begin
    for j:=1 to 9 do
    with edits[i,j] do
    begin
      if (i<=dim) and (j<=2*dim) then
      begin
        edit.visible:=true;
        if j<=2*dim then IdLabel.visible:=true;
      end
      else if (i<=dim) and (j=9) then
      begin {show the constant}
        edit.visible:=true;
        IdLabel.visible:=true;
      end
      else
      begin
        edit.visible:=false;
        idlabel.visible:=false;
      end;
    end;
  end;
  If dim<4 then Setvis(Wlbl,Wedt,false) else setvis(WLbl,Wedt,true);
  If dim<3 then Setvis(Zlbl,Zedt,false) else setvis(ZLbl,Zedt,true);
  If dim<2 then Setvis(Ylbl,Yedt,false) else setvis(YLbl,Yedt,true);
  MEMO1.CLEAR;
  SetCoefficientsfromEdits;
  (*
  memo1.lines.add('Current equations');
  for i:=1 to dim do memo1.lines.add(formatequation(i));
  *)
end;

{************** SavebtnClick *********8}
procedure TForm1.SaveBtnClick(Sender: TObject);
{save a problem to file}
var
  i,j:integer;
  Ini:TInifile;
  Id:string;
  Desc:String;
begin
  desc:=InputBox('Enter/change case description if desired','',desclbl.caption);
  if savedialog1.execute then
  begin
    Opendialog1.filename:=savedialog1.filename;
    currentLbl.caption:='Current case: '+ extractfilename(savedialog1.FileName);
    ini:=TInifile.create(Savedialog1.filename);
    with ini do
    begin
      writeInteger('General','NbrVars',Dim);
      writestring('General','MaxIter',MaxiterEdt.text);
      writestring('General','MaxTol',MaxTolEdt.text);
      writestring('General','Description',Desc);
      Desclbl.Caption:=desc;

      for i:=1 to dim do
      begin
        id:='Eq'+ inttostr(i);
        for j:=1 to 2*dim do
        with CoeffDlg.edits[i,j] do writestring(Id,'VarNbr'+inttostr(j),edit.text);
        with CoeffDlg.edits[i,9] do writestring(Id,'Constant',edit.text);
      end;
    end;
    ini.free;
  end;
end;

{************ LoadBtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
{Load a problem from file}
var
  i,j:integer;
  Ini:TInifile;
  Id:string;
  Desc:string;
begin
  if opendialog1.execute then
  begin
    savedialog1.FileName:=opendialog1.FileName;
    ini:=TInifile.create(Opendialog1.filename);
    with ini do
    begin
      nbrvar.value:=readInteger('General','NbrVars',3);
      MaxiterEdt.text:=readstring('General','MaxIter','20');
      MaxTolEdt.text:=readString('General','MaxTol','1E-4');
      Desc:=readstring('General','Description','');
      Desclbl.Caption:=desc;
      dim:=nbrvar.value;
      for i:=1 to dim do
      begin
        id:='Eq'+ inttostr(i);
        for j:=1 to 2*dim do
        with CoeffDlg.edits[i,j] do edit.text:=readstring(Id,'VarNbr'+inttostr(j),'0.0');
        with CoeffDlg.edits[i,9] do edit.text:=readstring(Id,'Constant','0.0');
      end;
    end;
    ini.free;
    CoeffDlg.okbtnclick(sender);  {fills in "val" fields from edit text fields}
    setCoefficientsFromEdits;
    currentLbl.caption:='Current case: '+ extractfilename(opendialog1.FileName);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

(*
procedure TForm1.Button1Click(Sender: TObject);
{calculate coordinates for test set of 3D distance equations}
var
  x,y,z,d,k:double;
  sx,sy,sz,sd,sk:string;
begin
 //x:=1.0;  y:=1.0; z:=1.0; d:=1.0;
 sx:=inputbox ('Distance ', 'Enter X coordinate:', sx );  x:=strtofloat(sx);
 sy:=inputbox ('Distance ', 'Enter Y coordinate:', sy );  y:=strtofloat(sy);
 sz:=inputbox ('Distance ', 'Enter Z coordinate:', sz );  z:=strtofloat(sz);
 sd:=inputbox ('Distance ', 'Enter Distance:', sd );     d:=strtofloat(sd);
 sk:= inputbox ('Distance ', 'Enter Assumed Distance error:', sk);k:=strtofloat(sk);
 with memo1.lines do

   add(format('X^2 + %f X + y^2 + %f Y + Z^2 + %fZ +k^2 + %fK %f = 0',
          [-2*x, -2*y, -2*z, -2*k,  -d*d+x*x+y*y+z*z+k*k]));
end;
*)


end.
