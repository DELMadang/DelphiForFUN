unit U_ProbabilityDist;

{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Investgate a few kinds of probability distributions by generating random samples
  from a population and comparing the results to the theoretical distribution.

  Included are: Uniform, Posiion, Normal, and Exponential distributions}

{There is also a page to illustrate the Central Limit Theorem by drawing samples
 from a uniform distribution and summing subsets to produce a normally distributed
 population}


{Uses Tchart component}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, TeeFunci, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, ComCtrls
  ,ShellAPI;

type
  TProbType=(Uniform, Normal, Poisson, Exponential,None);
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    NbDieEdt: TEdit;
    Label2: TLabel;
    SidesEdt: TEdit;
    Label3: TLabel;
    TrialsEdt: TEdit;
    GenCBtn: TButton;
    NbrDieUD: TUpDown;
    SidesUD: TUpDown;
    TrialsUD: TUpDown;
    Memo2: TMemo;
    Label4: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label5: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Label6: TLabel;
    Edit3: TEdit;
    UpDown3: TUpDown;
    GenUBtn: TButton;
    PlotType: TRadioGroup;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Edit5: TEdit;
    GenNBtn: TButton;
    Label9: TLabel;
    Edit6: TEdit;
    UpDown4: TUpDown;
    NormPlotType: TRadioGroup;
    Memo3: TMemo;
    Label10: TLabel;
    Edit7: TEdit;
    UpDown5: TUpDown;
    Memo4: TMemo;
    Label11: TLabel;
    Edit8: TEdit;
    GenPBtn: TButton;
    Label13: TLabel;
    Edit10: TEdit;
    UpDown8: TUpDown;
    PlotTypeP: TRadioGroup;
    Memo5: TMemo;
    Label12: TLabel;
    Edit9: TEdit;
    Label14: TLabel;
    Edit11: TEdit;
    UpDown6: TUpDown;
    Label15: TLabel;
    Edit12: TEdit;
    UpDown7: TUpDown;
    ExpPlotType: TRadioGroup;
    GenEBtn: TButton;
    Memo6: TMemo;
    StaticText1: TStaticText;
    procedure GenCBtnClick(Sender: TObject);
    procedure GenUBtnClick(Sender: TObject);
    procedure GenNBtnClick(Sender: TObject);
    procedure DrawChartU(sender:TObject);
    procedure DrawChartN(sender:TObject);
    procedure DrawChartP(sender:TObject);
    procedure DrawChartE(sender:TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenPBtnClick(Sender: TObject);
    procedure GenEBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    filename:string;

    {variables used by generate and drawchart routines for each dist type}
    mean,sigma,minx,maxx:double;
    value:array of double;
    interval:double;
    freqcount:array of integer;
    nbrsamps:integer;
    nbrbuckets:integer;
    probtype:TProbtype;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math, u_ProbChart;

{****************** DrawChartU *************}
procedure TForm1.DrawChartU(sender:TObject);
{Draw Uniform dist charts}
var i:integer;
    sum:integer;

  begin
    If probtype<>uniform then
    begin
      Showmessage('Generate a set of data first');
      exit;
    end;
    with chartform do
    begin
      series1.clear;
      series2.clear;
      chart1.bottomaxis.title.caption:='Value';
      chart1.leftaxis.increment:=0;
      case plottype.itemindex of
      0:   {freq}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+i,freqcount[i]);
            series2.addxy(minx+i, nbrsamps /nbrbuckets);
          end;
          chart1.leftaxis.title.caption:='Frequency of Values';
        end;
      1: {cumulative freq}
        begin
          sum:=0;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+i,sum);
            series2.addxy(minx+i, (i+1)*nbrsamps /nbrbuckets);
          end;
          chart1.leftaxis.title.caption:='Cumulative Frequency of Values';
        end;

      2: {probability}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+i,freqcount[i]/nbrsamps);
            series2.addxy(minx+i, 1/nbrbuckets);
          end;
          chart1.leftaxis.title.caption:='Probability Density of Values';
       end;

      3: {cumulative probability}
        begin
          sum:=0;
          series2.addxy(minx-1, 0);
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+i,sum/nbrsamps);
            series2.addxy(minx+i, (i+1)/nbrbuckets);
          end;
          chart1.leftaxis.title.caption:='Cumulative Probability of Values';
          chart1.leftaxis.increment:=0.1;
        end;
      end; {case}
      chart1.title.text[0]:='Uniform Distribution';
      show;
    end;
  end;


{**************** GenUbtnClick ************}
procedure TForm1.GenUBtnClick(Sender: TObject);
{Generate Uniform distribution data}
var i:integer;
begin
  minx:=Updown1.position;
  maxx:=Updown3.position+1;
  nbrbuckets:=trunc(maxx-minx);
  nbrsamps:=updown2.position;
  setlength(freqcount,nbrbuckets);
  for i:=0 to nbrbuckets-1 do freqcount[i]:=0;
  for i:= 1 to nbrsamps do inc(freqcount[random(nbrbuckets)]);
  probtype:=uniform;
  DrawchartU(self);
end;

{************* InvNorm **********}
function InvNorm (const P: Extended): Extended;
  {inverse normal function}
 {from http://www.adug.org.au/MathsCorner/MathsCornerNDist2.htm}
 {looks like a curve fit solution}
const
  C0: Extended = 2.515517;
  C1: Extended = 0.802853;
  C2: Extended = 0.010328;
  D1: Extended = 1.432788;
  D2: Extended = 0.189269;
  D3: Extended = 0.001308;
var
  T: Extended;
begin
  T := Sqrt (Ln (1.0 / Sqr (P)));
  Result := T - (C0 + C1 * T + C2 * Sqr (T)) /
    (1.0 + D1 * T + D2 * Sqr (T) + D3 * Sqr (T) * T);
end;

{******************* DrawChartN *************}
procedure TForm1.DrawChartN(sender:TObject);
{Draw Normal dist charts}
var
  InvPiEtc:double;
  p,probsum:double;
  i, sum:integer;

  function getnormp(i:integer):double;
  var x:double;
  begin
     x:=(minx+interval/2+i*interval-mean)/sigma; {normalize x}
     result:=invpietc*exp(-0.5*x*x)/sigma;  {density value at x}
  end;

begin
   if probtype<>normal then
   begin
     showmessage('Generate a set of data first');
     exit;
   end;
   with chartform do
  begin
      chart1.bottomaxis.title.caption:='Value';
      chart1.leftaxis.increment:=0;
      series1.clear;
      series2.clear;
      invPiEtc:=1.0/sqrt(2*Pi);
      case normplottype.itemindex of
      0:   {freq}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+interval/2+i*interval,freqcount[i]); {actual}
            p:=getnormP(i);  {density value at x}
            series2.addxy(minx+interval/2+i*interval, interval*nbrsamps*p); {expected # samps in interval}
          end;
          chart1.leftaxis.title.caption:='Frequency of Values';
        end;

      1: {cumulative freq}
        begin
          sum:=0;
          probsum:=0;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+interval/2+i*interval,sum);
            p:=getNormP(i); {density value at x}
            probsum:=probsum+p;  {Sum the probabilities}
            series2.addxy(minx+interval/2+i*interval, probsum*interval*nbrsamps); {<= this interval}
          end;
          chart1.leftaxis.title.caption:='Cumulative Frequency of Values';
        end;

      2: {probability density}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+interval/2+i*interval,freqcount[i]/nbrsamps);
            p:=getnormP(i); {density value at x}
            series2.addxy(minx+interval/2+i*interval, interval*p); {expected # samps in interval}
          end;
          chart1.leftaxis.title.caption:='Probability Density';
       end;

      3: {cumulative probability}
        begin
          sum:=0;
          probsum:=0;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+interval/2+i*interval,sum/nbrsamps);
            p:=getnormP(i); {density value at x}
            probsum:=probsum+p;
            series2.addxy(minx+interval/2+i*interval, interval*probsum); {expected # samps in interval}
          end;
          chart1.leftaxis.title.caption:='Cumulative Probability Distribution';
          chart1.leftaxis.increment:=0.1;
        end;
      end; {case}

      chart1.title.text[0]:='Normal Distribution' ;
      show;
    end;
  end;

{***************** GenBtnClick **********}
procedure TForm1.GenNBtnClick(Sender: TObject);
{Generate Normal distribution data}
var
  p,x:double;
  i, n, errcode :integer;
begin
    val(edit4.text,mean,errcode);
    if errcode<>0 then
         MessageDlg('Error in Mean', mtWarning, [mbOk], 0)
    else
    begin
      val(edit5.text,sigma,errcode);
      if errcode<>0 then
         MessageDlg('Error in Srd. Dev. ', mtWarning, [mbOk], 0);
    end;
    if errcode=0 then
    begin
      {generate a bunch of random values drawn from a population
       with specified mean and std deviation}
      nbrsamps:=updown4.position;
      setlength(value,nbrsamps);
      minx:=1e9;  maxx:=-1e9;
      for i:= 0 to nbrsamps-1 do
      begin
        p:=invnorm(random);
        x:=mean-p*sigma;
        value[i]:=x;
        if x<minx then minx:=x
        else if x>maxx then maxx:=x;
      end;

      {put the samples into buckets}
      nbrbuckets:=updown5.position;
      setlength(freqcount,nbrbuckets);
      for i:=0 to nbrbuckets-1 do freqcount[i]:=0;
      interval:=(maxx-minx)/(nbrbuckets-1);
      for i:= 0 to nbrsamps-1 do
      begin
        n:=trunc((value[i]-minx)/interval);
        inc(freqcount[n]);
      end;
      probtype:=normal;
      DrawChartN(sender);
  end;
end;

{************* FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  probtype:=none;
  pagecontrol1.activepage:=TabSheet1;
end;

{******************** DrawChartP **************}
procedure TForm1.DrawChartP(sender:TObject);
{Draw Poisson charts}

var i:integer;
    sum, totsum:integer;
    p, fact, sump:double;

    function getp(i:integer):double;
    {get poisson density for this bucket}
    begin
      result:=exp(-mean)*intpower(mean,i)/fact;
    end;

  begin
    If probtype<>poisson then
    begin
      Showmessage('Generate a set of data first');
      exit;
    end;
    with chartform do
    begin
      series1.clear;
      series2.clear;
      chart1.leftaxis.increment:=0;
      chart1.bottomaxis.title.caption:='Nbr Observations per Unit Measure (N)';
      case plottypeP.itemindex of
      0:   {freq}
        begin
        fact:=1;
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+i,freqcount[i]);
            If i>0 then fact:=fact*i;
            p:=getp(i);  {get theoretical}
            series2.addxy(minx+i, p*nbrsamps);
            {  debugging
            If i<high(freqcount) then listbox1.items.add(inttostr(i+1)+': '
                      + inttostr(freqcount[i+1])
                      +', '+ inttostr(trunc(p*nbrsamps)));
            }

          end;
          chart1.leftaxis.title.caption:='Nbr of Intervals with N Observarions';
        end;
      1: {cumulative freq}
        begin
          sum:=0; sump:=0;
          fact:=1;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+i,sum);
            If i>0 then fact:=fact*i;
            p:=getp(i); {get theoretical for this bucket}
            sump:=sump+p;
            series2.addxy(minx+i, sump*nbrsamps);
          end;
          chart1.leftaxis.title.caption:='Cumulative Nbr of Intervals with N Observations';
        end;

      2: {probability}
        begin
          totsum:=0;

          for i:= 0 to nbrbuckets-1 do inc(totsum,freqcount[i]);
          fact:=1;  {initialize factorial}
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(minx+i,freqcount[i]/totsum);
            If i>0 then fact:=fact*i;
            p:=getp(i); {get theoretical for this bucket}
            series2.addxy(minx+i, p);
          end;
          chart1.leftaxis.title.caption:='Probability of N Observations per unit Measure';
       end;

      3: {cumulative probability}
        begin
          sum:=0;
          sump:=0;
          totsum:=0;
          for i:= 0 to nbrbuckets-1 do inc(totsum,freqcount[i]);
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(minx+i,sum/totsum);

            If i>0 then fact:=fact*i else fact:=1;
            p:=getp(i); {get theoretical prob for this bucket}
            sump:=sump+p;
            series2.addxy(minx+i, sump);
          end;
          chart1.leftaxis.title.caption:='Cumulative Probability of N Observations';
          chart1.leftaxis.increment:=0.1;
        end;
      end; {case}
      chart1.title.text[0]:='Poisson Distribution';
      show;
    end;
  end;

{**************** GenpBtnClick *************}
procedure TForm1.GenPBtnClick(Sender: TObject);
{Generate Poisson data}
var
  i:integer;
  count:integer;
  x, sumx: double;
  errcode:integer;
begin
  val(edit8.text,mean,errcode);
  if errcode<>0 then Showmessage('Generate a set of data first')
  else
  Begin
    minx:=0;
    maxx:=5*mean;
    nbrbuckets:=trunc(maxx-minx);
    nbrsamps:=updown8.position;
    setlength(freqcount,nbrbuckets);
    for i:=0 to nbrbuckets-1 do freqcount[i]:=0;
    for i:= 1 to nbrsamps do
    {use exponential distribution to generate "next arrival" times and
     count number per unit of time to generate counts}
    begin
      sumx:=-ln(random)/mean;
      count:=0;
      while sumx<1 do
      begin
        x:=-ln(random)/mean;  {exponential time until next arrival}
        sumx:=sumx+x; {add 'em up until we exceed 1 time unit}
        inc(count);  {increment the  arrival count}
      end;
      if count>high(freqcount) then setlength(freqcount,count+1);
      inc(freqcount[count]);
    end;
    {delete any unused buckets at high end of scale}
    i:=high(freqcount);
    while freqcount[i]=0 do dec(i);
    maxx:=i+1;
    nbrbuckets:=trunc(maxx-minx);
    setlength(freqcount,nbrbuckets);

    probtype:=poisson;
    DrawchartP(self);
  end;

end;

{****************** DrawChartE ************}
procedure TForm1.DrawChartE(sender:TObject);
{Draw Exponential distribution chart}
var
  p,probsum:double;
  i, sum:integer;

  function getp(i:integer):double;
  begin
    result:=exp(-(interval*(i) +interval/2)/mean)/mean; {density value for "i"th bucket}
  end;

begin
   if probtype<>exponential then
   begin
     showmessage('Generate a set of data first');
     exit;
   end;
   with chartform do
  begin
      chart1.leftaxis.increment:=0;
      chart1.bottomaxis.title.caption:='Time until next arrival';
      series1.clear;
      series2.clear;
      case expPlotType.itemindex of
      0:   {freq}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(interval/2+i*interval,freqcount[i]); {actual}
            p:=getp(i);  {get theoretical prob for this bucket}
            series2.addxy(interval/2+i*interval, interval*nbrsamps*p); {expected # samps in interval}
          end;
          chart1.leftaxis.title.caption:='Frequency of Values';
        end;

      1: {cumulative freq}
        begin
          sum:=0;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(interval/2+i*interval,sum);
            probsum:=1-exp(-((i+1)*interval)/mean); {get cum. distribution directly}
            series2.addxy(interval/2+i*interval, probsum*nbrsamps); {nbr <= this interval}
          end;
          chart1.leftaxis.title.caption:='Cumulative Frequency of Values';
        end;

      2: {probability density}
        begin
          for i:= 0 to nbrbuckets-1 do
          begin
            series1.addxy(interval/2+i*interval,freqcount[i]/nbrsamps);
            p:=getp(i); {get theoretical prob for this bucket}
            series2.addxy(interval/2+i*interval, interval*p); {expected # samps in interval}
          end;
          chart1.leftaxis.title.caption:='Probability Density';

       end;

      3: {cumulative probability}
        begin
          sum:=0;
          for i:= 0 to nbrbuckets-1 do
          begin
            inc(sum,freqcount[i]);
            series1.addxy(interval/2+i*interval,sum/nbrsamps);
            probsum:=1-exp(-((i+1)*interval)/mean);  {get distribution func directly}
            series2.addxy(interval/2+i*interval, probsum); {plot expected cumulative prob. }
          end;
          chart1.leftaxis.title.caption:='Cumulative Probability Distribution';
          chart1.leftaxis.increment:=0.1;
        end;
      end; {case}

      chart1.title.text[0]:='Expinential Distribution' ;
      show;
    end;
  end;

{*************** GenEBtnClick ********************}
 procedure TForm1.GenEBtnClick(Sender: TObject);
 {Generate Exponential data }
var
  x:double;
  i, n, errcode :integer;
begin
    val(edit9.text,mean,errcode);
    if errcode<>0 then
         MessageDlg('Error in Mean', mtWarning, [mbOk], 0)
    else
    begin
      {generate a bunch of random values drawn from a population
       with specified mean and std deviation}
      nbrsamps:=updown6.position;
      setlength(value,nbrsamps);
      minx:=0;  maxx:=-1e9;
      for i:= 0 to nbrsamps-1 do
      begin
        x:=-ln(random)*mean;
        value[i]:=x;
        if x>maxx then maxx:=x;
      end;

      {put the samples into buckets}
      nbrbuckets:=updown7.position;
      setlength(freqcount,nbrbuckets+1);
      for i:=0 to nbrbuckets-1 do freqcount[i]:=0;
      interval:=maxx/(nbrbuckets-1);
      for i:= 0 to nbrsamps-1 do
      begin
        n:=trunc((value[i])/interval);
        inc(freqcount[n]);
      end;
      probtype:=exponential;
      DrawChartE(sender);
  end;
end;

{****************** ShowitBtnClick ******************}
procedure TForm1.GenCBtnClick(Sender: TObject);
{Central limit theorem demo}
{build and display a density plot of the data}
var
  sums:array of integer;
  sum:double{integer};
  i,j, sampsize:integer;
begin
  nbrbuckets:=sidesud.position;
  nbrsamps:=trialsud.position;
  sampsize:=nbrdieud.position;
  setlength(sums, nbrbuckets);
  for i:=low(sums) to high(sums) do  sums[i]:=0;
  for i:= 1 to trialsUD.position do
  begin
    sum:=0;
    for j:= 1 to sampsize do  sum:=sum+random;
    j:=trunc(nbrbuckets*sum/sampsize);
    inc(sums[j]);
  end;

  chartform.series1.clear;
  chartform.series2.clear;
  for i:=0 to high(sums) do chartform.series1.addxy(sampsize*i/nbrbuckets, sums[i]);
  with chartform, chart1 do
  begin
    leftaxis.title.caption:='Frequency of Subset Sums';
    bottomaxis.title.caption:='Subset sums';
    title.text[0]:='Central Limit Theorem Demo' ;
    chartform.show;
  end;  
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
