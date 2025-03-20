unit U_InstantInsanity;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TCubeset=array[0..3] of string[6];
  TFaces=array[1..6] of integer; {Indices of target locations to tranform the
                                  faces of a cube as it is rotated}

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    CubeList: TRadioGroup;
    Label1: TLabel;
    SearchBtn: TButton;
    Memo2: TMemo;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure CubeListClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    public
    origcubes:TCubeset; //array[0..3] of string;  {Currently selected set of cubes}
    filecube:TCubeset;
    cubes:array[0..3] of string;   {working version of cubes}
    link:string;  {source url for current set of cubes}
    solutioncount:integer;
    ConfigsChecked:integer;
    list,list2:Tstringlist;

    {"Targets" values index the  face numbers to move to top of cube (position 1
    in the cube string). TFace arrays specify the target positions for each face
    of the source cube. So Targets[2] specifies the target loacations for each
    face if face 2 is rotated to the top of the cube.  Values are initialized
    by the InitFacetargets procedure which applies successive rotations to move
    the specified face to position 1}
    targets :array[2..6] of  TFaces;

    procedure checknext(const i:integer);
    procedure checkSolved;
    function  IsUniqueSolution:boolean;
    procedure InitFaceTargets;
    procedure RotateCubeRight(N:integer);
    procedure movefacetotop(const N,F:integer);
    procedure showcubes;


  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  {Cube strings represent cube faces in this order: Top, Left, Front, Right, Back, Bottom}

  {        Top                   1          }
  { Left  Front  Right  Back   2 3 4 5      }
  {       Bottom                 6          }


  cubedata:array[0..3,0..3] of string =
       (
         {0: http://www.csulb.edu/~fnewberg/PCTMSummary/FinalPDFs/francine.PDF}
         ('BRYRGG','BYYYRG','BYYBGR','BBYGRR'),
         {1: http://www.jaapsch.net/puzzles/insanity.htm}
         ('BRRRGY','RGYGBB','RBGRYY','GBRYGY'),{Golyok}
         {2: http://www.maa.org/mathland/mathtrek_8_9_99.html}
         ('BRYRGG','BYYYRG','BYYBGR','BBYGRR'),
         {3:http://academics.smcvt.edu/jellis-monaghan/combo2/Archive/Combo%20s03/special%20topics%2003/The%20Instant%20Insanity%20Game.ppt}
         ('GBRYRB','RYYBYY','BBRGRY','GGBRGY')
       );

       Links:array[0..3] of string = (
              'http://www.csulb.edu/~fnewberg/PCTMSummary/FinalPDFs/francine.PDF',
              'http://www.jaapsch.net/puzzles/insanity.htm',
              'http://www.maa.org/mathland/mathtrek_8_9_99.html',
              'http://academics.smcvt.edu/jellis-monaghan/combo2/Archive/Combo%20s03/special%20topics%2003/The%20Instant%20Insanity%20Game.ppt'
              );
  facelabel:array[1..6] of string=('Top','Left','Front','Right','Back','Bottom');



{********** SearchBtnClick *********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  i:integer;
  s:string;
begin  {SearchBtnClick}

  {Initialize}
  list.Clear;
  solutioncount:=0;
  
  configschecked:=0;
  initFaceTargets; {Set up data used to get 24 positions foir each cube}
  for i:= 0 to 3 do cubes[i]:=origcubes[i];    {set up initial cubes}
  showcubes;
  checknext(0);     {start recursive search with cube 0}

  {display results}
  memo1.lines.add('');
  if solutioncount=1 then s:=' solution found.'
  else s:=' solutions found.';
  memo1.lines.add(inttostr(solutioncount) +s);
  memo1.lines.add(inttostr(configsChecked) +' cube arrangements checked');

end;

{********** CheckNext ************}
procedure TForm1.checknext(const i:integer);
{Recursive routine to check all configurations of the 4 cubes for solutions}
var
  j,k:integer;
begin
  if i>3 then
  begin
    checksolved;
    inc(configsChecked);
  end
  else
  begin
    if i>0 then
    begin
      for j:=1 to 6 do
      begin
        movefacetotop(i,j);
        for k:=1 to 4 do
        begin
          checknext(i+1);
          rotateCubeRight(i);
        end;
      end;
    end
    else
    begin  {for the 1st cube, put one face of each axis on top,  no need to rotate}
      checknext(i+1);  {check current top face}
      movefacetotop(0,2); {rotate cube so the current left face is on top}
      checknext(i+1);
      cubes[0]:=origcubes[0];
      movefacetotop(0,3); {rotate fronmt face to top}
      checknext(i+1);
    end;
    cubes[i]:=origcubes[i]; {set up for next time}
  end;
end;


{************* IsUniqueSolution ********}
function TForm1.IsUniqueSolution:boolean;
var
  i:integer;
  s:string;
begin
  result:=false;
  list2.Clear;
  for i:=0 to 3 do
  begin
    s:=copy(cubes[i],2,4);
    list2.Add(s);
  end;
  s:=list2.Text;
  if not list.find(s,i) then
  begin  {it is a new unique solution}
    list.add(s);
    result:=true;
  end;
end;


{***********  CheckSolved **********}
procedure Tform1.checkSolved;
{Check a set of cube arrangemebnts to see if they form a new unique solution}
var
  i,j,k:integer;
  face: string;
  solved:boolean;
  s:string;
begin
  solved:=true;
  {exposed faces are in cube positions 2,3,4, and 5}
  for i:= 2 to 5 do {pick a column}
  begin
    face:=cubes[0][i];
    for j:=1 to 3 do {for each other cube}
    begin
      for k:=1 to j do{check face j against already checked faces in column i}
      if cubes[j][i] =face[k] then
      begin
        solved:=false;
        break;
      end;
      if not solved then break
      else face:=face+cubes[j][i];
    end;
    if not solved then break;
  end;
  if solved and IsUniqueSolution then
  begin
    inc(solutioncount);
    If solutioncount<=10 then
    with memo1.lines do
    begin
      add('');
      add('Solution:' + inttostr(solutioncount));
      for i:=0 to 3 do
      begin
        s:='Cube '+inttostr(i+1);
        for j:=1 to 6 do s:=s+format('  %s: %s  ',[faceLabel[j],cubes[i,j]]);
        add(s);
      end;
    end;
  end;
end;   {checkSolved}


{*********** RotateCubeRight *********}
procedure TForm1.rotateCubeRight(N:integer);
{rotate cube N right by 90 degrees}
var s1,s2:string;
begin
  s1:=cubes[n];
  setlength(s2,6);
  s2[1]:=s1[1];
  s2[3]:=s1[2];
  s2[4]:=s1[3];
  s2[5]:=s1[4];
  s2[2]:=s1[5];
  s2[6]:=s1[6];
  cubes[n]:=s2;
end;


{************* ShowCubes ********}
procedure TForm1.showcubes;
{display cubes}
var i:integer;
begin
  with memo1,lines do
  begin
    clear;
    add('Cubes: Top   Left  Front Right Back  Bottom');
    for i:=0 to 3 do add(Format('   %6s%6s%6s%6s%6s%6s',
              [origcubes[i][1],origcubes[i][2], origcubes[i][3],
              origcubes[i][4],origcubes[i][5],origcubes[i][6]]));
    add('');
  end;
end;  


{*********** InitfaceTargets *********}
procedure Tform1.InitFaceTargets;

var
  i:integer;
  startpositions, nextpositions:TFaces;

      {....... RotateIndexRight ........}
      procedure rotateIndexRight(startpos:Tfaces; var endpos:TFaces);
      {Define position moves to rotate a cube 90 degrees left to right about the top/bottom faces}
      var
        s1,s2:Tfaces;
      begin
        s1:=startpos;
        s2[1]:=s1[1];
        s2[3]:=s1[2];
        s2[4]:=s1[3];
        s2[5]:=s1[4];
        s2[2]:=s1[5];
        s2[6]:=s1[6];
        endpos:=s2;
      end;

      {.......... RotateIndexBack ..........}
       procedure rotateIndexBack(startpos:Tfaces; var endpos:TFaces);
       {Define position moves to rotate a cube 90 degrees  front to back about the left/rightf faces}
      var
        s1,s2:Tfaces;
      begin
        s1:=startpos;
        s2[4]:=s1[1];
        s2[1]:=s1[2];
        s2[3]:=s1[3];
        s2[6]:=s1[4];
        s2[5]:=s1[5];
        s2[2]:=s1[6];
        endpos:=s2;
      end;

      {............ RotateIndexCW ............}
      procedure rotateIndexCW(startpos:Tfaces; var endpos:TFaces);
      {Define position moves to rotate a cube 90  degrees clockwise about the front face}
      var
        s1,s2:Tfaces;
      begin
        s1:=startpos;
        s2[4]:=s1[1];
        s2[1]:=s1[2];
        s2[3]:=s1[3];
        s2[6]:=s1[4];
        s2[5]:=s1[5];
        s2[2]:=s1[6];
        endpos:=s2;
      end;


begin  {InitfaceTargets}
  for i:=1 to 6 do startpositions[i]:=i;
  {face 2;}
  RotateIndexCW(startpositions,targets[2]);
  {face 3}
  rotateIndexback(startpositions, targets[3]);
  {face 4}
  rotateIndexCW(startpositions,nextpositions);
  rotateIndexCW(nextpositions,nextpositions);
  rotateIndexCW(nextpositions,targets[4]);
  {face 5}
  rotateIndexback(startpositions,nextpositions);
  rotateIndexback(nextpositions,nextpositions);
  rotateIndexback(nextpositions,targets[5]);
  {face 6}
  rotateIndexback(startpositions,nextpositions);
  rotateIndexback(nextpositions,targets[6]);
  {Could also use}
  //rotateIndexCW(startpositions,nextpositions);
  //rotateIndexCW(nextpositions,targets[6]);
end;


{********** MovefacetoTop ***********}
procedure TForm1.movefacetotop(const N,F:integer);
{Rotate cube N so that face F is in position 1 (on top facing up)}
  var
    s1,s2:string;
    i:integer;
  begin
    if f=1 then exit;
    s1:=cubes[n];
    setlength(s2,6);
    for i:=1 to 6 do
    s2[targets[f,i]]:=s1[i];
    cubes[n]:=s2;
  end;





procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.CubeListClick(Sender: TObject);
var
  i:integer;
begin
  with cubelist do
  begin
    for i:=0 to 3 do origcubes[i]:=cubedata[itemindex,i];
    link:=links[itemindex];
    showcubes;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  cubelistclick(sender);
  list:=TStringlist.Create;
  list.sorted:=true;
  list2:=TStringList.create;
  list2.Sorted:=true;
  opendialog1.initialdir:=extractfilepath(application.exename);
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  f:textfile;
  i,n:integer;
  line,msg:string;
  newcube:array[0..3] of string;
begin
  If opendialog1.Execute then
  begin
    msg:='Cube definition must contain 4 lines with six color abbreviation letters in each line. The letter represent  the cube face in this order: Top, Left, Front, Right, Back, and Bottom';
    assignfile(f, opendialog1.filename);
    reset(f);
    n:=0;
    while not eof(f) do
    begin
      readln(f,line);
      line:=uppercase(stringreplace(line,' ','',[rfreplaceall]));
      line:=stringreplace(line,',','',[rfreplaceall]);
      if (length(line)>0) and (line[1]<>';') then
      begin
        if length(line)<>6
        then showmessage(msg)
        else
        begin
          newcube[N]:=line;
          inc(n);
        end;
      end;
    end;
    if n<>4 then showmessage(msg)
      else
      begin
        for i:=0 to 3 do origcubes[i]:=newcube[i];
        cubelist.itemindex:=-1;
        showcubes;
      end;
  end;
end;

end.
