unit U_ResponseStats3;
{Copyright © 2001, 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, shellAPI, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Add1Btn: TBitBtn;
    Del1Btn: TBitBtn;
    Delbtn2: TBitBtn;
    Addbtn2: TBitBtn;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    CalcBtn: TButton;
    Memo2: TMemo;
    OpenBtn: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    procedure Add1BtnClick(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure Del1BtnClick(Sender: TObject);
    procedure Addbtn2Click(Sender: TObject);
    procedure Delbtn2Click(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    leftloc,midloc,rightloc:integer;
    filename:string;
    initialEntry:boolean;
    worklist:Tstringlist; {used to format strings, only need to create it once}
    procedure moveitem(lb1,lb2:Tlistbox;loc:integer);
    procedure getstats(lb:TListbox; var n:integer; var m,v:real);
    procedure formatitem(S:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses U_stats;

{********** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  initialentry:=true;

end;

{************** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  if not initialentry then exit;
  worklist:=TStringlist.create;
  opendialog1.initialdir:=extractfilepath(application.exename);

  {loc to align left of memo1 with listbox2}
  leftloc:=listbox2.left;
  {loc to center memo1 on listbox1}
  midloc:=listbox1.left-(memo1.width-listbox1.width) div 2;
  {loc to align right side memo1 with right side of listbox3}
  rightloc:=listbox3.left+listbox3.width-memo1.width;

  memo1.clear;
  memo1.lines.add('');
  openbtnclick(sender);

  initialentry:=false;
end;

{*************** Moveitem *************}
procedure TForm1.Moveitem(lb1,lb2:TListbox;loc:integer);
{arrow button was clicked to move an item}
var
  saveindex:integer;
begin
  if Lb1.itemindex < 0 then exit; {ignore if not a valid sender}
  with Lb1 do
  begin
    Lb2.items.add(items[itemindex]);
    saveindex:=itemindex;
    items.delete(itemindex);
    if items.count>0 then
    begin
      if saveindex>items.count-1 then dec(saveindex);
      itemindex:=saveindex;
      formatitem(lb1.items[itemindex]);
    end;
  end;
end;

{************ FormatItem **********}
Procedure TForm1.formatitem(S:string);
    var x:TStringList;
        n:integer;
        sum,sum2:extended;
        m,v:extended;
        str,nstr,mstr,vstr:string;
        errcode:integer;
    begin
      worklist.commatext:=s;
      x:=worklist; {just to use a shrter ane for worklist}
      if worklist.count>=8 then
      begin
        nstr:=x[3];
        mstr:=x[6];
        vstr:=x[7];
        {incase of error}
        x[3]:='???';
        x[6]:='???';
        x[7]:='???';
        val(nstr,n,errcode);
        if (errcode=0) and (n>0) then
        begin
          val(mstr,sum,errcode);
          if errcode=0 then
          begin
            val(vstr,sum2,errcode);
            if errcode=0 then
            begin
              m:=sum/n;
              v:= (sum2-sum*sum/n)/n;
              x[3]:=format('%3d',[n]);
              x[6]:=format('%5.3f',[m]);
              x[7]:=format('%5.3f',[v]);
            end;
          end;
        end
        else if errcode=0 then x[3]:='0';
        str:=format('%5s %13s %12s    %4s  %4s  %4s  %4s  %4s ',
                     [x[0], x[1],x[2],x[3],x[4],x[5],x[6],x[7]])
      end
      else str:='Format problem:'+s;
      memo1.lines[0]:=str;
    end;

{*********************** Listboxclick ****************}
procedure TForm1.ListBoxClick(Sender: TObject);
begin
  with tlistbox(sender) do
  begin
    formatItem(items[itemindex]);
  end;

  {de-select any previous selection in other listboxes}
  if sender<>listbox1 then listbox1.itemindex:=-1;
  if sender<>listbox2 then listbox2.itemindex:=-1;
  if sender<>listbox3 then listbox3.itemindex:=-1;

end;

{************ ListBoxDblClick *********8}
procedure TForm1.ListBoxDblClick(Sender: TObject);
begin
   with tlistbox(sender) do
  begin
    memo1.Lines[1]:=items[itemindex];
  end;
end;

{************** Add1BtnClick ****************}
procedure TForm1.Add1BtnClick(Sender: TObject);
begin
  moveitem(listbox1,listbox2,leftloc);
end;
{****************** Del1BtnClick **************}
procedure TForm1.Del1BtnClick(Sender: TObject);
begin
  moveitem(listbox2,listbox1, midloc);
end;
{****************** Addbtn2Click ****************}
procedure TForm1.Addbtn2Click(Sender: TObject);
begin
  moveitem(listbox1,listbox3,rightloc);
end;
{****************** DelBtn2Click *********************}
procedure TForm1.Delbtn2Click(Sender: TObject);
begin
  moveitem(listbox3,listbox1,midloc);
end;

{************************ GetStats ********************}
procedure Tform1.getstats(lb:TListbox; var n:integer; var m,v:real);
var
  list:TStringlist;
  sum,sum2:real;
  i, j, errcode, errcode2:integer;
  s:string;
  tn, nsum:integer;
  ts,ts2:real;
  inquotedstr:boolean;
begin
  nsum:=0; sum:=0; sum2:=0; n:=0; m:=0;   V:=0;
  list:=TStringlist.create;
  for i:=0 to lb.items.count-1 do
  begin
    list.clear;
    s:=lb.items[i]+' ';
    inquotedstr:=false;
    j:=1;
    repeat
      if s[j]='"' then begin inquotedstr:= not inquotedstr; inc(j); end;
      if (not inquotedstr) and (s[j]=' ') then
      begin
        list.add(copy(s,1,j-1));
        while s[j]=' ' do inc(j);
        delete(s,1,j-1); {delete the double space}
        j:=1;
      end
      else inc(j);
    until j>length(s);
    if list.count <>9 then showmessage(format('Error in item #%d (%s), ignored - must have 9 comma separated fields',[i+1,lb.items[i]]))
    else
    begin
      // val(list[3],tn,errcode);
      errcode:=0;
      try
        tn:=strtoint(list[3]);
        except  errcode:=1;
      end;
      if errcode=0 then
      begin
        inc(nsum,tn);
        errcode2:=0;
        //val(list[6],ts,errcode);
        try
          ts:=strtofloat(list[6]);
          except errcode:=1;
        end;
        //val(list[7],ts2,errcode2);
        try
          ts2:=strtofloat(list[7]);
          except errcode2:=1;
        end;
        if (errcode=0) and (errcode2=0) then
        begin
          sum:=sum+ts;
          sum2:=sum2+ts2;
        end
        else showmessage('Invalid sum or sumsquared field ('+list[7]+', '+list[8]+')');
      end
      else
      begin
        showmessage('Invalid count field ('+list[4]+')');
        break;
      end;
    end;
  end;
  n:=nsum;
  if n>0 then
  begin
    m:=sum/n;
    v:= (sum2-sum*sum/n)/n;
  end;
end;


procedure movetotop(memo:TMemo);
{Scroll "memo" so that the first line is in view}
begin
  with memo do
  begin
    selstart:=0;
    sellength:=0;
  end;
end;

{*********************** CalcBtnClick *****************}

const
  siglevels:array[0..3] of real =
               ( { 0.50, 0.60, 0.75,} 0.90, 0.95, 0.99, 0.999);
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  m1,v1, m2,v2:real;
  n1,n2:integer;
  t,tcrit, sdx:real;
  i:integer;
  f:real;
  s:string;
  accepted, rejected:integer;
begin
  //decimalseparator:=',';  {for testing European files}
  memo2.clear;
  if (listbox2.items.count>0)
  then
  begin
     getstats(listbox2,n1,m1,v1);
     memo2.lines.add(format('Sample 1: Samples: %d   Mean: %6.3f Std. Dev.: %6.3f',
     
                  [n1,m1,sqrt(v1)]));
  end
  else n1:=0;
  if (listbox3.items.count>0) then
  begin
    getstats(listbox3,n2,m2,v2);
    memo2.lines.add(format('Sample 2: Samples: %d   Mean: %6.3f Std. Dev.: %6.3f',
                             [n2,m2,sqrt(v2)]));
  end
  else n2:=0;

  If (n1>0) and (n2>0) then
  with memo2, lines do
  begin
    {t-test on difference of means}
    (*test data
    m1:=5.82;
    v1:=1.8769;
    n1:=27;
    m2:=4.89;
    v2:=1.1236;
    n2:=16;
    *)
    {sdx:=sqrt((n1*v1+n2*v2)/(n1+n2-2)*(N1+n2)/(n1*n2));}
    sdx:=sqrt(v1/n1+v2/n2);
    t:=(m1-m2)/sdx;
    {f:=N1+N2-2;} {degrees of freedom}
    f:=sqr(v1/n1+v2/n2)/(sqr(v1/n1)/(n1-1)+sqr(v2/n2)/(n2-1));
    {better estimate of deg freedom?  not much diffferent in the cases I checked
    c:=V1/(V1+v2);
    f:=(n1-1)*(n2-1)/((n2-1)*Sqr(c)+(n1-1)*sqr(1-c)) ;
    }

    add('Using Student''s t-test -'
                 +format(' the difference of the means is %6.3f, '
                  +' the std. error is  %6.3f',[m1-m2,sdx]));
    add(format('T value is %6.3f, Cumulative Density Function (CDF) for this T is %5.1f',
                       [t, sigt(t,(n1+n2)/2)]));

    add(' ');
    add('We can be "confidence interval" (CI%) sure that true difference in means lies between low and high values listed. '
    +'The significance level (1 - .01*CI%) is the probability that the true mean is outside of this interval and observed difference is due to chance.');
    add('');
    add('We can accept the hypothesis that the two samples means are different at the selected CI% (or reject the Null Hypothesis that the means are the same at the 100-CI% significance level) '
        + ' if the absolute T value for th sample mean difference is greater than the critical T value listed for that confidence.');
    add(' ');
    add('Difference of means ranges for several Confidence Intervals');
    add(' Confidence     Low      High      T-Critical  Abs(T Val)   Hyp: M1<>M2');
    t:=abs(T);
    Accepted:=-1; rejected:=-1;
    for i:= 0 to high(siglevels) do
    begin
      tcrit:=tinv(siglevels[i],f );
      if T>Tcrit then
      begin
        s:='Accept';
        Accepted:=i; {save up to last accepted}
      end
      else
      begin
        s:='Reject';
        {save level index for 1st rejection}
        if rejected<0 then Rejected:=i;
      end;
      add(format('     %5f%%       %6.3f    %6.3f   %6.2f          %6.2f           %S',
               [100*siglevels[i],m1-m2-tcrit*sdx, m1-m2+tcrit*sdx, tcrit, T , S]));
    end;
    add('');
    If (accepted>=0) and (rejected>=0) then
    begin
      s:='Hypothesis of unequal means is rejected at or above the '
      +inttostr(round(100*siglevels[rejected]))+'% level.'
      +'  Thus if you need to be only '+ inttostr(round(100*siglevels[accepted]))
      +'% sure that sample means are different, '
      +'you can accept the hypothesis.  If you need to be at least '
      +inttostr(round(100*siglevels[rejected]))+ '% sure, then you must reject it.';
      add('');
      add(s);
    end
    else if (accepted>=0) and (rejected<0) then
    begin
      s:='Hypothesis of unequal means is accepted at all levels.';
      if m1<m2 then
      add(s);
    end
    else if (accepted<0) and (rejected>=0) then
    begin
      s:='Hypothesis of unequal means is rejected at all levels.';
      add(s);
    end;
    movetotop(memo2);
  end;
end;

{********************** OpenBtnClick ****************}
procedure TForm1.OpenBtnClick(Sender: TObject);
var
  i:integer;
  s:string;
begin
  If opendialog1.Execute then filename:=opendialog1.filename
  else filename:='';
 If filename<>'' then
  with listbox1 do
  begin
    //decimalseparator:=',';  {for testing European data files}
    items.loadfromfile(filename);
    for i:=0 to items.count-1 do
    begin   {replace delimiters  with ' '  (double space)}
      s:=items[i];
      s:=stringreplace(s,'*',' ',[rfreplaceall]);
      s:=stringreplace(s,'?',' ',[rfreplaceall]);
      s:=stringreplace(s,';',' ',[rfreplaceall]);
      if decimalseparator='.'
      then s:=stringreplace(s,',','  ',[rfreplaceall]) {replace all comma with spaces}
      else s:=stringreplace(s,', ','  ',[rfreplaceall]); {replace comma space with spaces}
      items[i]:=s;
    end;
    items.delete(0); {delete header line}
    if trim(items[0])='' then items.delete(0);
    itemindex:=0;
    listboxclick(listbox1);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
