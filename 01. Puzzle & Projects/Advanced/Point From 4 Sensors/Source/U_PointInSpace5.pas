unit U_PointInSpace5;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Given the 3D coordinate locations of four sensors and their reported distance
 from a target, calculate the location of the target. This program develops
 a set of linear equations based on 3D distance equations and solves the
 equartions using Gaussian Elimination}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Inifiles, UMatrix, ComCtrls, ExtCtrls, DFFUtils;

type

  TReal3DPoint= record
    x,y,z:extended;
  end;

  TReal3DLine=record
    p1,p2:TReal3DPoint;
  end;


  TRealSphere= record
    p:TReal3DPoint;
    R:extended;
  end;


  TSensorEdits= record
    XEdt,YEdt,ZEdt,DistEdt:TEdit;
    P:TReal3DPoint;
    R:extended;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    RandcaseBtn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Label7: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label8: TLabel;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Solvebtn: TButton;
    AnswerLbl: TLabel;
    Memo2: TMemo;
    GentestBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Label11: TLabel;
    TrilaterateBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo3: TMemo;
    Memo4: TMemo;
    Label9: TLabel;
    Caselbl: TLabel;
    VerboseBox: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RandcaseBtnClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure GentestBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure TargetKnownClick(Sender: TObject);
    procedure TrilaterateBtnClick(Sender: TObject);
  public
    {sensor values are in sensors[0] through [3]
     Sensors[4] is used for known solution location if known (for testing)}
    sensors:array[0..4] of TSensorEdits;

    target:TReal3DPoint;
    targetdist:extended;
    theta1,theta2,theta3,theta4:extended;
    N    : Integer;  { Matrix dimension }
    A    : TNMatrix;  { System matrix }
    B    : TNVector;  { Constant vector }
    X    : TNVector;  { Solution vector }

    procedure LoadValuesfromEdits;
    procedure LoadEditsFromValues;
    procedure resetResults;
    procedure SetSensorval(N:integer;xx,yy,zz:extended);
    //procedure showtarget(show:boolean);
    function  gaussSolve(Inputlabel:string):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  nearzero:extended=1e-5;

{********* Real3DPoint ***********}
function real3dpoint(a,b,c:extended):TReal3DPoint;
{make 3d point from 3 values}
begin
  with result do
  begin
    x:=a;
    y:=b;
    z:=c;
  end;
end;

{************ Dist3D ************}
function Dist3D(p1,p2:TReal3DPoint):extended;
{3D distance}
begin
  with p1 do result:=sqrt(sqr(p2.x-x)+sqr(p2.y-y)+sqr(p2.z-z));
end;

{*********** LoadvaluesFromEdits *********}
procedure TForm1.LoadValuesfromEdits;
{called from SolveBtn in case user has changed values}
var
  i:integer;
begin
  for i:=0 to 3 do
  with sensors[i] do
  begin
    P.x:=strtofloat(XEdt.text);
    P.y:=strtofloat(YEdt.text);
    P.z:=strtofloat(ZEdt.text);
    R:=strtofloat(DistEdt.text);
  end;
  target:=sensors[4].p;
end;

{********* LoadEditsFromvalues *******}
procedure TForm1.LoadEditsFromValues;
{Called after loading a case to make edits reflect current values}
var
  i:integer;
begin
  for i:=0 to 4 do
  with sensors[i] do
  begin
    Xedt.text:=format('%.3f',[P.x]);
    Yedt.text:=format('%.3f',[P.y]);
    Zedt.text:=format('%.3f',[P.z]);
    DistEdt.text:=format('%.3f',[R]);
 end;
end;

{*********** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  index,ftype:integer;
begin
  randomize;
  reformatMemo(memo1);
  for i:=0 to controlcount-1 do
  if (controls[i] is TEdit) then
  with controls[i] do
  begin
    if (tag>0) and (tag<=20) then
    begin
      index:=(tag-1) div 4;
      ftype:=(tag-1) mod 4;
      with sensors[index] do
      case ftype of
        0: Xedt:=TEdit(controls[i]);
        1: YEdt:=TEdit(controls[i]);
        2: Zedt:=TEdit(controls[i]);
        3: DistEdt:=TEdit(controls[i]);
      end;
    end;
  end;
  for i:= low(sensors) to high(sensors) do
  with sensors[i] do
  begin
    xedt.text:='0.00';
    yedt.text:='0.00';
    zedt.text:='0.00';
    distedt.text:='0.00';
  end;
  opendialog1.InitialDir:=extractfilepath(application.exename);
  savedialog1.InitialDir:=opendialog1.InitialDir;
  GentestBtnClick(sender);
  pagecontrol1.ActivePage:=tabsheet1;
end;

{********** ResetResults *********8}
procedure TForm1.resetresults;
{Reset results display}
begin
  with memo2 do
  begin
    clear;
    lines.add('Results.display here');
  end;
end;

procedure TForm1.SetSensorval(N:integer;xx,yy,zz:extended);
begin
  with sensors[N],p do
  begin
    x:=xx;
    y:=yy;
    z:=zz;
    xedt.text:=format('%.3f',[x]);
    yedt.text:=format('%.3f',[y]);
    zedt.text:=format('%.3f',[z]);
    R:=dist3D(p,target);
    distedt.Text:=format('%.3f',[R]);
  end;
end;

{************ GenTestBtnClick *********}
procedure TForm1.GentestBtnClick(Sender: TObject);
{Make an initial test case}
begin
  resetresults;
  setsensorval(4,5,5,5);  {target point}
  target:=sensors[4].p;

  setsensorval(0,1,1,1);
  setsensorval(1,1,1,2);
  setsensorval(2,2,1,1);
  setsensorval(3,3,3,3);

  Caselbl.caption:='Simple case 1 (unsaved)';
end;

{********* RandCasebtn **********}
procedure TForm1.RandcaseBtnClick(Sender: TObject);
{Generate a random case}
var
  i:integer;
begin
  ResetResults;

  with target do
  begin
    x:=random(1000)/10-50;
    y:=random(1000)/10-50;
    z:=random(1000)/10-50;
    SetSensorVal(4,x,y,z);
  end;

  for i:=0 to 3 do
  with sensors[i],p do
    setsensorval(i,random(1000)/10-random(50),random(1000)/10-random(50),
                                  random(1000)/10-random(50));
  caselbl.caption:='Random case (unsaved)';
end;

(*
{******** ShowTarget **********}
procedure TForm1.showtarget(show:boolean);
{Show or hide target data}
  begin
    if show then
    begin
      with target do
      Answerlbl.caption:=format('Test case Target is at (%.3f,%.3f,%.3f)',[x,y,z]);
      Answerlbl.Visible:=true;
      //targetknown.checked:=true;
    end
    else
    begin
      answerlbl.Visible:=false;
      //targetknown.checked:=false;
    end;
  end;
*)



{************ EditChange *********}
procedure TForm1.EditChange(Sender: TObject);
{One of the values edits changed}
begin
  ResetResults;
  //if TEdit(sender).Tag <=16 then showtarget(false);
end;


{************ SolveBtnClick ************}
procedure TForm1.SolvebtnClick(Sender: TObject);

begin
  loadvaluesfromedits;
  memo2.clear;
  GaussSolve('Input');
end;


{*************** GaussSolve ***********}
function TForm1.GaussSolve(Inputlabel:string):boolean;
var
  I, J : Integer;  { Loop variables }
  p0x, p0y, p0z, r0sqr:extended;
  MathErr:byte;
  s:string;
  d:array[0..3] of extended;
  t:TReal3dPoint;

begin
  n:=3;
  with sensors[0],p do
  begin
    p0x:=x;
    p0y:=y;
    p0z:=z;
    r0sqr:=sqr(r)-sqr(x)-sqr(y)-sqr(z);
  end;
  for i:=1 to 3 do
  with sensors[i],p do
  begin
    a[i,1]:=-2*(x-p0x);
    a[i,2]:=-2*(y-p0y);
    a[i,3]:=-2*(z-p0z);
    b[i]:=sqr(r)-sqr(x)-sqr(y)-sqr(z)-r0sqr;
  end;

  { Display data }
  if verbosebox.Checked then
  with memo2,lines do
  begin

    add('Linear system:');

    add('                  Coefficients                 Constants');
    for I := 1 to N do
    begin
      s:='';
      for J := 1 to N do s:=s+'  '+format('%12.6f',[A[I,J]]);
      add(format('%s, %12.6f',[s,B[i]]));
    end;
    add('');

  end;


{ Solve system }
  Gaussian_Elimination(N,A,B,X,MathErr);
  //Partial_Pivoting(N,A,B,X,MathErr);
  result:=MathErr=0;
  { Write results }
  with memo2,lines do
  case MathErr of
    0   : begin
            add('Target coordinates (X, Y, Z)');
            add('----------------------------');
            add(format('Calculated: (%12.5f  %12.5f  %12.5f)',[X[1], X[2], X[3]]));
            (*
            If targetknown.checked then
            with target do
            add(format('Input:      (%12.3f  %12.3f  %12.3f)',[x,y,z]));
            *)
            {check target distances from specified values}
            t:=real3dpoint(x[1],x[2],x[3]);
            add('');
            add('Input vs Calculated Distance from Target');
            add('------------------------------------------');

            i:=9-length(Inputlabel) div 2;  {Center the label}
            s:=stringofchar(' ',i);
            s:=s+inputlabel+s;

            add('Sensor' + S + 'Calc     Difference');
            for i:=0 to 3 do
            begin
              d[i]:=dist3d(sensors[i].p,t);
              add(format('  %d  %12.5f  %12.5f %12.5f',
                         [i+1,sensors[i].R,d[i],sensors[i].r-d[i]]));
            end;
            selstart:=0;
            sellength:=0;
          end;
    2 : memo2.lines.add('Singular matrix - No solution exists!');
  end;

end;

{*********** SaveBtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  i:integer;
  ini:TInifile;
        {........... SaveSensor ..........}
        procedure savesensor(id:string;data:TSensorEdits);
        begin
          with ini, data do
          begin
            writefloat(id,'X',p.x);
            writefloat(id,'Y',p.y);
            writefloat(id,'Z',p.z);
            writefloat(id,'R',r);
          end;
        end;

begin {SavebtnClick}
  loadvaluesfromedits;
  If savedialog1.execute then
  begin
    ini:=TInifile.create(Savedialog1.filename);
    with Ini do
    begin
      writestring('General', 'DecimalSeparator',Decimalseparator);
      for i:=0 to 3 do savesensor('Sensor'+inttostr(i),sensors[i]);
      savesensor('Target',sensors[4]);
      free;

    end;
    caselbl.Caption:=extractfilename(savedialog1.FileName);
  end;
end;


{*********** LoadbtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  i:integer;
  ini:TInifile;
  savesep:char;
  decimalstring:string;

      {...... Loadsensor .......}
      procedure LoadSensor(id:string;var data:TSensorEdits);
      begin
        with ini, data do
        begin
          p.x:=readfloat(id,'X',0);
          p.y:=readfloat(id,'Y',0);
          p.Z:=readfloat(id,'Z',0);
          R:=readfloat(id,'R',0);
        end;
      end;

begin {LoadbtnClick}
  if opendialog1.execute then
  begin
    ini:=TInifile.create(Opendialog1.filename);
    with Ini do
    begin
      savesep:=decimalseparator;
      decimalstring:=readstring('General', 'DecimalSeparator',savesep);
      decimalseparator:=decimalstring[1];
      for i:=0 to 3 do loadsensor('Sensor'+inttostr(i),sensors[i]);
      loadsensor('Target',sensors[4]);

      //TargetKnown.checked:=readbool('Target','Known',false);
      target:=sensors[4].p;
      free;
      decimalseparator:=savesep;

    end;
    caselbl.caption:=extractfilename(opendialog1.FileName);
    loadeditsFromvalues;
    ResetResults;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.TargetKnownClick(Sender: TObject);
begin
  //showtarget(targetknown.checked); {show or hide target info}
end;

type
  Vec3D=record
    x,y,z:double;
  end;


  {Find the 2 possible solutions using the first 3 equations}
(*
   #include <stdio.h>
#include <math.h>

/* No rights reserved (CC0, see http://wiki.creativecommons.org/CC0_FAQ).
 * The author has waived all copyright and related or neighboring rights
 * to this program, to the fullest extent possible under law.
*/

/* Largest nonnegative number still considered zero */
#define   MAXZERO  0.0

typedef struct vec3d    vec3d;
struct vec3d {
        double  x;
        double  y;
        double  z;
};
/* Return the difference of two vectors, (vector1 - vector2). */
vec3d vdiff(const vec3d vector1, const vec3d vector2)
{
        vec3d v;
        v.x = vector1.x - vector2.x;
        v.y = vector1.y - vector2.y;
        v.z = vector1.z - vector2.z;
        return v;
}
*)

function vdiff(const vector1, vector2:vec3d ):vec3d;
begin
  with result do
  begin
    x := vector1.x - vector2.x;
    y := vector1.y - vector2.y;
    z := vector1.z - vector2.z;
  end
end;

(*
/* Return the sum of two vectors. */
vec3d vsum(const vec3d vector1, const vec3d vector2)
{
        vec3d v;
        v.x = vector1.x + vector2.x;
        v.y = vector1.y + vector2.y;
        v.z = vector1.z + vector2.z;
        return v;
}
*)

function vsum(const vector1, vector2:vec3d):vec3d;
begin
  with result do
  begin
    x := vector1.x + vector2.x;
    y := vector1.y + vector2.y;
    z := vector1.z + vector2.z;
  end;
end;

(*
/* Multiply vector by a number. */
vec3d vmul(const vec3d vector, const double n)
{
        vec3d v;
        v.x = vector.x * n;
        v.y = vector.y * n;
        v.z = vector.z * n;
        return v;
}
*)

function vmul(const vector:vec3d; const n:double):vec3d;
begin
  with result do
  begin
    x := vector.x * n;
    y := vector.y * n;
    z := vector.z * n;
  end;
end;

(*
//* Divide vector by a number. */
 vec3d vdiv(const vec3d vector, const double n)
{
        vec3d v;
        v.x = vector.x / n;
        v.y = vector.y / n;
        v.z = vector.z / n;
        return v;
}
*)

function vdiv(const vector:vec3d;  const n:double):vec3d;
begin
  with result do
  begin
    x := vector.x / n;
    y := vector.y / n;
    z := vector.z / n;
  end;
end;

(*
/* Return the Euclidean norm. */
double vnorm(const vec3d vector)
{
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
}
*)

function vnorm(const vector:vec3d):double;
begin
  result:=sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
end;

(*
/* Return the dot product of two vectors. */
double dot(const vec3d vector1, const vec3d vector2)
{
        return vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z;
}

*)

function dot(const vector1, vector2:vec3d):double;
begin
  result:=vector1.x * vector2.x + vector1.y * vector2.y + vector1.z * vector2.z;
end;


(*
/* Replace vector with its cross product with another vector. */
vec3d cross(const vec3d vector1, const vec3d vector2)
{
        vec3d v;
        v.x = vector1.y * vector2.z - vector1.z * vector2.y;
        v.y = vector1.z * vector2.x - vector1.x * vector2.z;
        v.z = vector1.x * vector2.y - vector1.y * vector2.x;
        return v;
}
*)
function cross(vector1,vector2:vec3d):vec3d;
begin
  with result do
  begin
    x := vector1.y * vector2.z - vector1.z * vector2.y;
    y := vector1.z * vector2.x - vector1.x * vector2.z;
    z := vector1.x * vector2.y - vector1.y * vector2.x;
  end;
end;


(*
/* Return zero if successful, negative error otherwise.
 * The last parameter is the largest nonnegative number considered zero;
 * it is somewhat analoguous to machine epsilon (but inclusive).
*/
int trilateration(vec3d *const result1, vec3d *const result2,
                  const vec3d p1, const double r1,
                  const vec3d p2, const double r2,
                  const vec3d p3, const double r3,
                  const double maxzero)
{
        vec3d   ex, ey, ez, t1, t2;
        double  h, i, j, x, y, z, t;

        /* h = |p2 - p1|, ex = (p2 - p1) / |p2 - p1| */
        ex = vdiff(p2, p1);
        h = vnorm(ex);
        if (h <= maxzero) {
                /* p1 and p2 are concentric. */
                return -1;
        }
        ex = vdiv(ex, h);

        /* t1 = p3 - p1, t2 = ex (ex . (p3 - p1)) */
        t1 = vdiff(p3, p1);
        i = dot(ex, t1);
        t2 = vmul(ex, i);

        /* ey = (t1 - t2), t = |t1 - t2| */
        ey = vdiff(t1, t2);
        t = vnorm(ey);
        if (t > maxzero) {
                /* ey = (t1 - t2) / |t1 - t2| */
                ey = vdiv(ey, t);

                /* j = ey . (p3 - p1) */
                j = dot(ey, t1);
        } else
                j = 0.0;

        /* Note: t <= maxzero implies j = 0.0. */
        if (fabs(j) <= maxzero)
        {
                /* p1, p2 and p3 are colinear. */

                /* Is point p1 + (r1 along the axis) the intersection? */
                t2 = vsum(p1, vmul(ex, r1));
                if (fabs(vnorm(vdiff(p2, t2)) - r2) <= maxzero &&
                    fabs(vnorm(vdiff(p3, t2)) - r3) <= maxzero)
                {
                        /* Yes, t2 is the only intersection point. */
                        if (result1)
                                *result1 = t2;
                        if (result2)
                                *result2 = t2;
                        return 0;
                }

                /* Is point p1 - (r1 along the axis) the intersection? */
                t2 = vsum(p1, vmul(ex, -r1));
                if (fabs(vnorm(vdiff(p2, t2)) - r2) <= maxzero &&
                    fabs(vnorm(vdiff(p3, t2)) - r3) <= maxzero)
                 {
                        /* Yes, t2 is the only intersection point. */
                        if (result1)
                                *result1 = t2;
                        if (result2)
                                *result2 = t2;
                        return 0;
                }

                return -2;
        }

        /* ez = ex x ey */
        ez = cross(ex, ey);

        x = (r1*r1 - r2*r2) / (2*h) + h / 2;
        y = (r1*r1 - r3*r3 + i*i) / (2*j) + j / 2 - x * i / j;
        z = r1*r1 - x*x - y*y;
        if (z < -maxzero) {
                /* The solution is invalid. */
                return -3;
        } else
        if (z > 0.0)
                z = sqrt(z);
        else
                z = 0.0;

        /* t2 = p1 + x ex + y ey */
        t2 = vsum(p1, vmul(ex, x));
        t2 = vsum(t2, vmul(ey,
         y));

        /* result1 = p1 + x ex + y ey + z ez */
        if (result1)
                *result1 = vsum(t2, vmul(ez, z));

        /* result1 = p1 + x ex + y ey - z ez */
        if (result2)
                *result2 = vsum(t2, vmul(ez, -z));

        return 0;
}

*)

function equal(p1,p2:vec3d):boolean;
begin
  result:=(p1.x=p2.x) and (p1.y=p2.y) and (p1.z=p2.z);
end;


// Return zero if successful, negative error otherwise.
// * The last parameter is the largest nonnegative number considered zero;
// * it is somewhat analoguous to machine epsilon (but inclusive).
///
function  trilateration(var result1, result2:vec3d;
                  const p1:vec3d; const r1:double;
                  const p2:vec3d; const r2:double;
                  const p3:vec3d; const r3:double;
                  const nearzero:double):integer;
var
  ex, ey, ez, t1, t2 : vec3d;
      h, i, j, x, y, z, t:double;

     // h = |p2 - p1|, ex = (p2 - p1) / |p2 - p1| */

begin
  result:=0;
  ex := vdiff(p2, p1);
  h := vnorm(ex);
  if (h <= nearzero) then
   //* p1 and p2 are concentric. */
  begin
    result:=-1;
    exit;
  end;
  ex := vdiv(ex, h);
  //* t1 = p3 - p1, t2 = ex (ex . (p3 - p1)) */
  t1 := vdiff(p3, p1);
  i := dot(ex, t1);
  t2 := vmul(ex, i);

  //* ey = (t1 - t2), t = |t1 - t2| */
  ey := vdiff(t1, t2);
  t := vnorm(ey);
  if (t > nearzero) then
  begin //* ey = (t1 - t2) / |t1 - t2| */}
    ey := vdiv(ey, t);
    //* j = ey . (p3 - p1) */
    j := dot(ey, t1);
  end
  else  j := 0.0;//* Note: t <= maxzero implies j = 0.0. */

  if (abs(j) <= nearzero) then
  begin
    //* p1, p2 and p3 are colinear. */

    //* Is point p1 + (r1 along the axis) the intersection? */
    t2 := vsum(p1, vmul(ex, r1));
    if (abs(vnorm(vdiff(p2, t2)) - r2) <= nearzero)and
              (abs(vnorm(vdiff(p3, t2)) - r3) <= nearzero) then
    begin
      //* Yes, t2 is the only intersection point. */
      //if {(result1) *} equal(result1,t2) then
      //if {(result2) *} equal(result2, t2)
      result1:=t2;
      result2:=t2;
      //result:=0;            ;
      exit;
    end
    else
    begin
      //* Is point p1 - (r1 along the axis) the intersection? */
      t2 := vsum(p1, vmul(ex, -r1));
      if (abs(vnorm(vdiff(p2, t2)) - r2) <= nearzero) and
            (abs(vnorm(vdiff(p3, t2)) - r3) <= nearzero) then
      begin
        //* Yes, t2 is the only intersection point. */
        //if {(result1) *}equal(result1,t2)
        result1:=t2;

        //then if {(result2)*} equal(result2,t2)
          //   then
          //   begin
        result2:=t2;
        //result:=0;
        exit;
      end

      //    (* ????
      else
      begin
        result:= -2;
        exit;
      end;
    end;
    //  *)
  end
  else
  begin

    //* ez = ex x ey */
    ez := cross(ex, ey);
    x := (r1*r1 - r2*r2) / (2*h) + h / 2;
    y := (r1*r1 - r3*r3 + i*i) / (2*j) + j / 2 - x * i / j;
    z := r1*r1 - x*x - y*y;
    if (z < -nearzero) then
    begin  //* The solution is invalid. */
      result:=-3;
      exit;
    end
    else
    if (z > 0.0) then z := sqrt(z)
    else z := 0.0;

    //* t2 = p1 + x ex + y ey */
    t2 := vsum(p1, vmul(ex, x));
    t2 := vsum(t2, vmul(ey, y));

    //* result1 = p1 + x ex + y ey + z ez */
    result1:=vsum(t2, vmul(ez, z));

    //* result1 = p1 + x ex + y ey - z ez */
    result2:=vsum(t2, vmul(ez, -z));
    //result:=0;
    exit;
  end;
end;


(*
int main(void)
{
        vec3d   p1, p2, p3, o1, o2;
        double  r1, r2, r3;
        int     result;

        while (fscanf(stdin, "%lg %lg %lg %lg %lg %lg %lg %lg %lg %lg %lg %lg",
                             &p1.x, &p1.y, &p1.z, &r1,
                             &p2.x, &p2.y, &p2.z, &r2,
                             &p3.x, &p3.y, &p3.z, &r3) == 12) {
                printf("Sphere 1: %g %g %g, radius %g\n", p1.x, p1.y, p1.z, r1);
                printf("Sphere 2: %g %g %g, radius %g\n", p2.x, p2.y, p2.z, r2);
                printf("Sphere 3: %g %g %g, radius %g\n", p3.x, p3.y, p3.z, r3);
                result = trilateration(&o1, &o2, p1, r1, p2, r2, p3, r3, MAXZERO);
                if (result)
                        printf("No solution (%d).\n", result);
                else {
                        printf("Solution 1: %g %g %g\n", o1.x, o1.y, o1.z);
                        printf("  Distance to sphere 1 is %g (radius %g)\n", vnorm(vdiff(o1, p1)), r1);
                        printf("  Distance to sphere 2 is %g (radius %g)\n", vnorm(vdiff(o1, p2)), r2);
                        printf("  Distance to sphere 3 is %g (radius %g)\n", vnorm(vdiff(o1, p3)), r3);
                        printf("Solution 2: %g %g %g\n", o2.x, o2.y, o2.z);
                        printf("  Distance to sphere 1 is %g (radius %g)\n", vnorm(vdiff(o2, p1)), r1);
                        printf("  Distance to sphere 2 is %g (radius %g)\n", vnorm(vdiff(o2, p2)), r2);
                        printf("  Distance to sphere 3 is %g (radius %g)\n", vnorm(vdiff(o2, p3)), r3);
                }
        }

        return 0;
}
*)



{*********** TrilaterateBtnClick ***********8}
procedure TForm1.TrilaterateBtnClick(Sender: TObject);
var

  r:integer;
  saved:array[1..4, 1..2] of vec3d;
  scount:integer;

   {---------- Loadvec ----------}
    function loadvec(p:TReal3DPoint):vec3d;
    {transfer sensor TReal3DPoint records ro vwc2D type records}
    begin
      result.x:=p.x;
      result.y:=p.y;
      result.z:=p.z;
    end;





{----------- TriLat --------}
procedure trilat(i,j,k:integer);
{Solve 3 spheres problem for sensors i, j, and k}
var
  p1,p2,p3:vec3d;
  r1,r2,r3:double;
  o1,o2:vec3d;
  temp:vec3d;
  msg:string;

  {------------- Loadtrilatdata ----------}
  procedure loadtrilatdata(i,j,k:integer);
  begin
    p1:=loadvec(sensors[i].p);
    p2:=loadvec(sensors[j].p);
    p3:=loadvec(sensors[k].p);
    r1:=sensors[i].R;
    r2:=sensors[j].R;
    r3:=sensors[k].R;
  end;

begin
  loadtrilatData(i,j,k);
  r:=trilateration(o1, o2, p1, r1, p2, r2, p3, r3, nearzero);
  if o1.x>o2.x then
  begin   {swap so that smaller x is first solution}
    temp:=o1;
    o1:=o2;
    o2:=temp;
  end;

  with memo2.lines do
  if r<>0 then
  begin
    case r of
      -1: msg:='Two spheres are concentric';
      -2: msg:='Spheres do not intersect';
      -3: msg:='Spheres do not intersect';
    end;
    add(format('No solution, result=%d: %s',[r,msg]))
  end  
  else
  begin
    if verbosebox.checked then
    begin
    {for debugging}
      add('');
      add(format('Solution 1: %f %f %f',[o1.x, o1.y, o1.z]));

      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [i+1,vnorm(vdiff(o1, p1)), r1]));
      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [j+1,vnorm(vdiff(o1, p2)), r2]));
      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [k+1,vnorm(vdiff(o1, p3)), r3]));

      add(format('Solution 2: %f %f %f',[o2.x, o2.y, o2.z]));

      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [i+1,vnorm(vdiff(o2, p1)), r1]));
      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [j+1,vnorm(vdiff(o2, p2)), r2]));
      add(format('  Distance to sphere %d is %.3f (radius %.3f)', [k+1,vnorm(vdiff(o2, p3)), r3]));
    end;

    inc(scount);
    saved[scount,1]:=o1;
    saved[scount,2]:=o2;
  end;
end;

var
  i:integer;
  sumdiff1, sumdiff2:double;
  p1,p2,p3,p4:VEC3D;
  r1,r2,r3,r4:DOUBLE;
  o1,o2:vec3d;
begin
  loadvaluesfromedits;
  memo2.Clear;
  scount:= 0;
  trilat(0,1,2);
  trilat(0,1,3);
  trilat(0,2,3);
  trilat(1,2,3);

  if scount>0 then
  begin
    sumdiff1:=0;
    sumdiff2:=0;
    for i:=2 to scount do
    begin
      sumdiff1:=sumdiff1+abs(saved[1,1].x-saved[i,1].x)
                        +abs(saved[1,1].y-saved[i,1].y)
                        +abs(saved[1,1].z-saved[i,1].z);
      sumdiff2:=sumdiff2+abs(saved[1,2].x-saved[i,2].x)
                        +abs(saved[1,2].y-saved[i,2].y)
                        +abs(saved[1,2].z-saved[i,2].z)
    end;
    if verbosebox.Checked then
    begin
      memo2.lines.add('Sum of coordinate differences:');
      memo2.lines.add(format('  Solution 1: %.5f, Solution #2: %.5f',
                        [sumdiff1, sumdiff2]));
    end;
    P1:=loadvec(sensors[0].p);  r1:=sensors[0].r;
    p2:=loadvec(sensors[1].p);  r2:=sensors[1].r;
    P3:=loadvec(sensors[2].p);  r3:=sensors[2].r;
    p4:=loadvec(sensors[3].p);  r4:=sensors[3].r;
    o1:=saved[1,1]; o2:=saved[1,2];

    with memo2.lines do
    if sumdiff1<sumdiff2
    then
    begin
      Add('Using Solution 1 set');
      add(format('Solution 1: %f %f %f',[o1.x, o1.y, o1.z]));

      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [1,vnorm(vdiff(o1, p1)), r1]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [2,vnorm(vdiff(o1, p2)), r2]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [3,vnorm(vdiff(o1, p3)), r3]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [4,vnorm(vdiff(o1, p4)), r4]));
    end
    else
    begin
      Add('Use Solution 2 set');
      add(format('Solution 2: %f %f %f',[o2.x, o2.y, o2.z]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [1,vnorm(vdiff(o2, p1)), r1]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [2,vnorm(vdiff(o2, p2)), r2]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [3,vnorm(vdiff(o2, p3)), r3]));
      add(format('  Distance to sphere %d is %.5f (vs. measured %.5f)', [4,vnorm(vdiff(o2, p4)), r4]));
    end;
  end;
end;


end.
