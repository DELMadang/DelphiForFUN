unit U_MagicCube;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Fill in the numbers 1 through 27 in a 3x3x3 cube so that the sum of the
  following 31 sets of 3 numbers each are all identical:

  1. Sum of each row within each layer, (9  sums)
  2. Sum of each column within  each layer, (9 sums)
  3.  Sum of each vertical column across layers,  (9 sums)
  4.  Sum of each diagonal crossing layers and including the center square
  of the middle layer (4 sums).

  There are 192 solutions, but only four are unique.  The rest are rotations and
  reflections of these four.  (48 per solution).
}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ComCtrls, ExtCtrls;

type
  Tnumset=record
    rows:array[1..3] of integer;
    key:integer; {bit position corresponding to each number is on, others are off}
  end;
  TLayerRec=record  {layers of a cube}
    cols:array[1..3] of TNumset;
    layerkey:integer;
  end;
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    ListBox1: TListBox;
    TrackBar1: TTrackBar;
    ProgressLbl: TLabel;
    Label1: TLabel;
    ResetBtn: TButton;
    Image1: TImage;
    Button1: TButton;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    { Public declarations }
    sum:integer;
    data:array of TNumSet;
    layers:array of TLayerRec;
    triplecount,layercount:integer;
    starti, startj,startk:integer; {initial index values for solution search}
    fname:string; {file name for solutions}
    firsttime:boolean;  {true until formactivate code has run once}
    searching:boolean;  {a search is underway}
    unique:array of TPoint; {x= key for corners of type, y=# of repeats found}
    ucount:integer; {count of unique cubes found (size of unique array)}
    function  findSet(testkey:integer):boolean;
    procedure sort3(a,b,c:integer; var aa,bb,cc:integer);
    function  getpermute(input:TNumset; n:integer):TNumSet;
    function  commonelement(d1,d2:TNumset):boolean;
    procedure ExtractIJK(s:string; var i,j,k:integer);
    procedure drawcube(Image:TImage; i,j,k:integer);
    procedure makelayers;
    function  gettype(i,j,k:integer):integer;
  end;

var
  Form1: TForm1;


implementation

uses U_Startup, UMakeCaption;

{$R *.DFM}

const
  start=1;

{*************************************************************************}
{************                 Utility Routines              **************}
{*************************************************************************}

{**************** Sort3 ****************}
procedure TForm1.sort3(a,b,c:integer; var aa,bb,cc:integer);
{Sort integers a,b,c in increasing value and return as aa,bb,cc}
   var temp:integer;
   begin
     aa:=a; bb:=b; cc:=c;
     if (aa>bb) then
     begin
       temp:=aa;
       aa:=bb;
       bb:=temp;
     end;
     if bb>cc then
     begin
       temp:=bb;
       bb:=cc;
       cc:=temp;
       if (aa>bb) then
       begin
         temp:=aa;
         aa:=bb;
         bb:=temp;
       end;
     end;
   end;

{******************* ExtractIJK **************}
procedure TForm1.ExtractIJK(s:string; var i,j,k:integer);
{extract 3 integer values separated by commas from a string}
var n,p,errcode:integer;
begin
  i:=-1; j:=-1; k:=-1;
  p:=pos(')',s);
  if p>0 then delete(s,1,p);
  p:=pos(',',s);
  if p>0 then
  begin
    val(copy(s,1,p-1), n, errcode);
    if errcode=0 then i:=n;
    delete(s,1,p);
    p:=pos(',',s);
    if p>0 then
    begin
      val(copy(s,1,p-1), n, errcode);
      if errcode=0 then j:=n;
      delete(s,1,p);
      val(s,n,errcode);
      if errcode=0 then k:=n;
    end;
  end;
end;


const
  permutes:array[1..6, 1..3] of integer =  {the 6 possible permutations of the 3
                                            numbers in a row or column}
    ((1,2,3),(1,3,2),(2,1,3),(2,3,1),(3,1,2),(3,2,1));

{*************** GetPermute ***************}
function TForm1.getpermute(input:TNumset; n:integer):TNumSet;
{return the nth permutation of the 3 numbers in a row or column}
var i:integer;
begin
  for i:=1 to 3 do result.rows[i]:=input.rows[permutes[n,i]];
end;

{******************* FindSet ************}
function TForm1.findSet(testkey:integer):boolean;
{do these three numbers already exist in a set?}
var i:integer;
begin
  result:=false;
  for i:= 0 to triplecount-1 do
  with data[i] do
  begin
    If testkey=key then
    begin
      result:=true;
      break;
    end;
  end;
end;

{************** CommonElement *************}
function TForm1.commonelement(d1,d2:TNumset):boolean;
begin
  result:=(d1.key and d2.key)>0;
end;

{******************* GetType **************}
function  TForm1.gettype(i,j,k:integer):integer;
{return index of unique type array for cube with layers i,j,k}
var n:integer;
    newkey:integer;
begin
  newkey:=0;
  with layers[i] do
  begin   {add four corners from the top layer}
    newkey:=newkey or (1 shl (cols[1].rows[1]-1))
                   or (1 shl (cols[1].rows[3]-1))
                   or (1 shl (cols[3].rows[1]-1))
                   or (1 shl (cols[3].rows[3]-1));
  end;
  with layers[k] do {add 4 corners from the bottom layer}
  begin
    newkey:=newkey or (1 shl (cols[1].rows[1]-1))
                   or (1 shl (cols[1].rows[3]-1))
                   or (1 shl (cols[3].rows[1]-1))
                   or (1 shl (cols[3].rows[3]-1));
  end;
  n:=0;

  while (n<=ucount-1) and (unique[n].x<>newkey) do inc(n);
  if n=ucount then
  begin
    if ucount>length(unique) then setlength(unique,ucount+10);
    unique[n].x:=newkey;
    unique[n].y:=1;
    inc(ucount);
  end
  else inc(unique[n].y);
  result:=n;
end;


{******************* MakeLayers **************}
procedure TForm1.makelayers;
{generate all valid 1x3 triples and 3x3 layers for use in
 search for cubes}
var i,j,k, ni, nj, nk:integer;
    c1,c2,c3:TNumSet;
    newkey, mask:integer;
begin
  {set up and show startup form}
  form2.top:=top;
  form2.left:=left+ (width-form2.width) div 2;
  form2.show;
  triplecount:=0;
  sum:=(start+start+26)*3 div 2;
  {make cols of 3 numbers totaling sum (42 if start=1) }
  for i:= start to start+26 do
  for j:= start to start+26  do
  if i<>j then
  for k:= start to start+26 do
  if (i<>k) and (j<>k) and (i+j+k=sum) then
  begin
    newkey:=0;
    mask:=1 shl (i-1); newkey:=newkey or mask;
    mask:=1 shl (j-1); newkey:=newkey or mask;
    mask:=1 shl (k-1); newkey:=newkey or mask;
    if not findset(newkey) then
    with data[triplecount-1] do
    begin
      inc(triplecount);
      if triplecount>length(data) then setlength(data,length(data)+100);
      with data[triplecount-1] do
      begin
        sort3(i,j,k,rows[1],rows[2],rows[3]);
        key:=newkey;
      end;
    end;
  end;

  {now generate all possible valid layers}
  screen.cursor:=crHourGlass;
  layercount:=0;
  for i:=0 to triplecount-1 do
  for ni:=1 to 6 do {we'll test all 6 permutations of the 3 numbers}
  begin
    c1:=getpermute(data[i],ni);
    for j:=0 to triplecount-1 do
    begin
      if (i<>j) and (not commonelement(data[i],data[j])) then
      for nj:= 1 to 6 do
      begin
        c2:=getpermute(data[j],nj);
        for k:=0 to triplecount-1 do
        if (not commonelement(data[i],data[k])) and
           (not commonelement(data[j],data[k]))
        then
        for nk:=1 to 6 do
        begin
          c3:=getpermute(data[k],nk);
          {check columns}
          if (c1.rows[1]+c2.rows[1]+c3.rows[1]=sum)
          and (c1.rows[2]+c2.rows[2]+c3.rows[2]=sum)
          and (c1.rows[3]+c2.rows[3]+c3.rows[3]=sum)
          then
          begin
            inc(layercount);
            if layercount>length(layers) then setlength(layers,layercount+1000);
            layers[layercount-1].cols[1]:=c1;
            layers[layercount-1].cols[2]:=c2;
            layers[layercount-1].cols[3]:=c3;
            layers[layercount-1].layerkey:=(data[i].key)or (data[j].key) or (data[k].key);
            application.processmessages;
            if tag<>0 then break;
          end;
        end;
      end;
      if tag<>0 then break;
    end;
  end;
  screen.cursor:=crDefault;
  showmessage(inttostr(triplecount)+' triples summing to '+inttostr(sum)+' were found'
             +#13+'(with 6 permutations of the numbers in each, there are '
                 + inttostr(6*triplecount) + ' possible rows or columns).'
             +#13 +'There are '+ inttostr(layercount)
                  + ' layers with rows and columns summing to '
                  + inttostr(sum));
  form2.hide;
end;

{************** DrawCube ****************}
Procedure TForm1.drawcube(image:TImage; i,j,k:integer);

    procedure drawlayer(layerindex:integer; layerloc:char);
    {draw a layer of the cube with "3D" effect}
    var
      x,y:integer;
      xw,yw, tx,ty :integer;
      i,j:integer;
    begin
      with image, canvas  do
      begin
        font.style:=[fsbold];
        case layerloc of
        'T': y:= trunc(0.37*image.height); {top layer}
        'M': y:= trunc(0.63*image.height); {middle}
        'B': y:= trunc(0.9*image.height);  {bottom}
        end;
        x:=image.width div 10;
        xw:=image.width div 2;
        yw:=trunc(0.707*xw/3);
        for i:= 0 to 3 do
        begin
          moveto(x+i*yw, y-i*yw); {horizontal lines}
          lineto(x+i*yw+xw,y-i*yw);
          moveto(x+i*xw div 3,y); {vertical lines}
          lineto(x+i*xw div 3+3*yw, y-3*yw);
        end;
        for i:=0 to 2 do {now display the numbers}
        for j:=0 to 2 do
        begin
          tx:=x+i*xw div 3 +(3-j)*yw;
          ty:=y-(3-j)*yw+3;
          if layerindex>=0 then
          textout(tx,ty, format('%2d',[layers[layerindex].cols[i+1].rows[j+1]]))
          else textout(tx,ty,'?');
        end;
      end;
    end; {drawlayer}


begin  {drawcube}
  with image.canvas do
  begin
    brush.color:=$CEFFA4; {light green}
    fillrect(image.clientrect);
    drawlayer(i,'T');
    drawlayer(j,'M');
    drawlayer(k,'B');
    brush.color:=self.color {clwhite};
    floodfill(1,1,clblack,fsborder); {change non-cube areas back to white}
  end;
end;


{*************************************************************************}
{************                   Control Exits               **************}
{*************************************************************************}

{************* FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{since we have multiple forms, we need a firsttime flag to
 tell FormActivate when to do its thing}
begin    firsttime:=true;  end;

{******************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
var n,i,j,k:integer;
begin
  if firsttime then
  begin
    makecaption('Magic Cubes', #169+' 2002 G Darby, www.delphiforfun.org', self);
    firsttime:=false;
    searching:=false;
    setlength(unique,10);
    ucount:=0;
    makelayers;
    {See if there is a prebuilt file of solutions}
    fname:=extractfilepath(application.exename)+'MagicCubes.strm';
    if fileexists(fname) then
    with listbox1 do
    begin
      items.loadfromfile(fname);
      extractijk(items[items.count-1], starti,startj,startk);
      if (starti<0) or (startj<0) or (startk<0) {check for screwed up conversion}
         or (starti>layercount) or (startj>layercount) or (startk>layercount)
      then
      begin  {something's wrong, reset to make a fresh start}
        starti:=0; startj:=0; startk:=0;
        clear;
      end
      else
      begin
        inc(startk);
        for n:=0 to items.count-1 do
        begin {restore unique types information}
          extractijk(items[n],i,j,k);
          gettype(i,j,k);
        end;
        itemindex:=items.count-1;
        if items.count<192 then
        begin
          showmessage('Partial set of solutions loaded,'
                         +#13+'Search will contiue');
          drawcube(image1,starti, startj, startk-1);

          solvebtnclick(sender);
        end;
      end;
    end
    else
    begin
       starti:=0; startj:=0; startk:=0;
       drawcube(image1,-1,-1,-1);
    end;
  end;
end;


{***************** SolveBtnClick **********}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Search layers for  solutions}
var i,j,k,n:integer;
    c,r:integer;
    ok:boolean;
    center:integer;
    starttime:TDateTime;
begin
  tag:=0;
  if listbox1.items.count=0 then
  begin
    starti:=0;
    startj:=0;
    startk:=0;
  end;
  if searching then exit; {user hit search button while search was underway, ignore}
  searching:=true;
  screen.cursor:=crhourglass;
  {do center layer first, index J, to preselect those with sum/3 in center cell
   of center row}
  center:=sum div 3;
  trackbar1.max:=layercount;
  starttime:=now;
  for j:=startj to layercount-1 do
  begin
    if tag<>0 then
    begin
      startj:=j;
      break;
    end;
    if layers[j].cols[2].rows[2]=center then
    begin
      trackbar1.position:=j;

      for i:=starti to layercount-1 do
      if (i<>j) then
      begin
        {check that layers i and j have no numbers in common}
        ok:=true;
        if (layers[i].layerkey and layers[j].layerkey)>0 then ok:=false;
        if i mod 1024=0 then
        begin
          progresslbl.caption:=format('%6.1f seconds',[ secsperday*(now-starttime)])
                               + #13+inttostr(listbox1.items.count)+' solutions found'
                               +#13+ inttostr(ucount) +' unique types';
          application.processmessages;
          if tag<>0 then
          begin
            starti:=i;
            break;
          end;
        end;
        if ok  then {layers are unique}
        begin
          for k:=startk to layercount-1 do
          if (i<>k) and (j<>k) then
          begin
           {check that layers i and k have no numbers in common}
            ok:=true;
            if (layers[i].layerkey and layers[k].layerkey) <>0 then ok:=false;
            if OK then {check that layers j and k have no numbers in common}
            if (layers[j].layerkey and layers[k].layerkey) <>0 then ok:=false;
            if OK then
            begin
              {we have 3 layers with all different integers, now see
              if columns and main diagonals add to magic number}
              for c:=1 to 3 do {for each column in a layer}
              begin
                for r:= 1 to 3 do {for each row in a layer}
                begin {check the vertical column sum}
                  if layers[i].cols[c].rows[r]+layers[j].cols[c].rows[r]
                     +layers[k].cols[c].rows[r]<>sum then
                  begin
                    ok:=false;
                    break;
                  end;
                end;
                if not OK then break;
              end;
              if ok then {check 4 main triagonals}
              begin
                if (layers[i].cols[1].rows[1]+layers[j].cols[2].rows[2]+layers[k].cols[3].rows[3]=sum)
                    and (layers[i].cols[3].rows[1]+layers[j].cols[2].rows[2]+layers[k].cols[1].rows[3]=sum)
                    and (layers[i].cols[1].rows[3]+layers[j].cols[2].rows[2]+layers[k].cols[3].rows[1]=sum)
                    and (layers[i].cols[3].rows[3]+layers[j].cols[2].rows[2]+layers[k].cols[1].rows[1]=sum)
                then
                with listbox1 do
                begin
                  drawcube(image1, i,j,k);
                  {find type}
                  n:=gettype(i,j,k);
                  items.add('(Type '+inttostr(n+1)+') '
                              +inttostr(i)+','+inttostr(j)+','+inttostr(k));
                  items.savetofile(fname);
                  itemindex:=items.count-1; {select item we just drew}
                  application.processmessages;
                end;
              end;
            end;
          end; {for k loop}
          startk:=0; {after 1st time through}
        end;
      end; {for i loop}
      if tag=0 then starti:=0; {after 1st time through}
    end;
  end;
  screen.cursor:=crdefault;
  searching:=false;
end;

{************** FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;
  canclose:=true;
end;



{************* ListBox1Click *********}
procedure TForm1.ListBox1Click(Sender: TObject);
{Draw the cube that user clicked}
var i,j,k:integer;
begin
  with listbox1 do
  begin
    extractIJK(items[itemindex],i,j,k);
    drawcube(image1, i,j,k);
  end;
end;



{************** ResetBtnClick ********}
procedure TForm1.ResetBtnClick(Sender: TObject);
{start over}
begin
  tag:=1; {to stop any ongoing search}
  starti:=0; startj:=0; startk:=0;
  listbox1.clear;
  drawcube(image1,-1,-1,-1);
end;






end.
