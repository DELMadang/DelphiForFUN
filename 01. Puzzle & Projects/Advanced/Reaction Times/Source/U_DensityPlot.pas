unit U_DensityPlot;
{Copyright 2007, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Plot reaction time intervals vs pct of total in each interval}
{Uses Tchart component}
{Input is reactiondetail.rsd file as created by ReactiomTime program}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, TeeFunci, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, shellapi,
  ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    Series1: TBarSeries;
    TeeFunction1: TAddTeeFunction;
    SaveBmpBtn: TButton;
    PtintBtn: TButton;
    GetFileBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MaxTimeEdt: TEdit;
    IntvEdt: TEdit;
    TitleEdit: TEdit;
    ShowValues: TCheckBox;
    Coloredbars: TCheckBox;
    SaveWMFBtn: TButton;
    ShowItBtn: TButton;
    ChartType: TRadioGroup;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure ShowItBtnClick(Sender: TObject);
    procedure GetFileBtnClick(Sender: TObject);
    procedure PtintBtnClick(Sender: TObject);
    procedure SaveBmpBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure TitleEditChange(Sender: TObject);
    procedure SaveWMFBtnClick(Sender: TObject);
  public
    filename:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{***************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  opendialog1.initialdir:=extractfilepath(application.exename);
  getfilebtnclick(sender);
 // showitbtnclick(sender);
  intvedt.setfocus;
  application.processmessages;
end;

{****************** ShowitBtnClick ******************}
procedure TForm1.ShowItBtnClick(Sender: TObject);
{build and display a density plot of the data}
var
  f:textfile;
  line:string;
  x:real;
  errcode:integer;
  samps:array of integer; {array of counts in each bar}
  i:integer;
  increment,maxtime:real; {width of bar and highest value to be charted (in seconds)}
  maxindex:integer;  {max # of bars}
  totcount,sum:integer;  {total records in chart}
  SaveDecimalSeparator:char;
begin
  increment:=strtofloat(intvedt.text); {second range to summarize in a each bar}
  maxtime:=strtofloat(maxtimeedt.text);
  maxindex:=trunc(maxtime/increment+0.01); {max # of bars}
  setlength(samps,maxindex+1);
  series1.clear;
  if not fileexists(filename)  then
  begin
    showmessage('Select a valid rsd file first');
    exit;
  end
  else
  begin
    for i:= 0 to maxindex do samps[i]:=0;
    totcount:=0;
    assignfile(f,opendialog1.filename);
    reset(f);

    while not eof(f) do
    begin
      readln(f,line);
      if (length(line)>2) and (copy(line,1,2)='ID') then {skip Id records}
      else  {it's a data record}
      begin
        if totcount=0 then
        begin
          savedecimalseparator:=decimalseparator;
          if pos(',',line)>0 then decimalseparator:=','
          else decimalseparator:='.';
        end;
         //val(trim(line),x,errcode); {convert reaction time to nbr}
         errcode:=0;
        try
          x:=strtofloat(trim(line));
          except errcode:=1;
        end;
        if (errcode=0) and (x>0)and(x<=maxtime)
        then
        begin
         inc(samps[round(maxindex*x)]); {increment the count for the bar for x}
         inc(totcount);
       end;
      end;
    end;
    closefile(f);
    decimalSeparator:=SaveDecimalSeparator;

    with series1 do
    begin
      If coloredbars.checked then coloreachpoint:=true
      else coloreachpoint:=false;

      If showvalues.checked then
      begin
        marks.visible:=true;
      end
      else marks.visible:=false;

      case ChartType.itemindex of
        0:
        begin {assign time to chart x as mid-time of the bar, y value is the count}
          for i:= 0 to maxindex do
          if samps[i]>0 then
          begin
            addxy(i/maxindex+increment/2,  {midpoint time of bar}
                       samps[i]); {nbr of samples per bar}
          end;
          chart1.LeftAxis.title.caption:='Number of samples';
           ValueFormat:='#,##0.#';
        end;
        1:
        begin  {assign time to chart x as mid-time of the bar, y value is the %}
          for i:= 0 to maxindex do
          if samps[i]>0 then
          begin
            addxy(i/maxindex+increment/2,  {midpoint time of bar}
                  100*samps[i]/totcount);  {pct of total}
          end;
          chart1.LeftAxis.title.caption:='Percent of samples';
           ValueFormat:='##0.#%';
        end;
        2:
        begin
          sum:=0;
          for i:= 0 to maxindex do
          begin
            inc(sum, samps[i]);
            addxy(i/maxindex+increment/2,  {midpoint time of bar}
                       sum); {cuumulative nbr of samples }
          end;
          chart1.LeftAxis.title.caption:='Cumulative number of samples';
           ValueFormat:='#,##0.#';
        end;
        3:
        begin  {assign time to chart x as mid-time of the bar, y value is cumulative %}
          sum:=0;
          for i:= 0 to maxindex do
          begin
            inc(sum,samps[i]);
            addxy(i/maxindex+increment/2,  {midpoint time of bar}
                  100*sum/totcount);  {cumulative pct of total }
                        //int(1000*sum/totcount)/10);  {pct of total to 1 decimal}
          end;
          chart1.LeftAxis.title.caption:='Cumulative percent of samples';
          ValueFormat:='##0.#%';
        end;

      end; {case}
    end;
    chart1.title.text[0]:=titleedit.text;

  end;
end;

{*********************** GetFileBtnClick *****************}
procedure TForm1.GetFileBtnClick(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    filename:=opendialog1.filename;
     titleedit.text:='Frequency Chart of reaction times for '+extractfilename(opendialog1.filename);
    showItBtnclick(sender);
  end
  else filename:='';
end;

{************ PrintBtnClick ***********}
procedure TForm1.PtintBtnClick(Sender: TObject);
begin
  chart1.print;
end;

{************ SvaeBMPBtnClick ***************}
procedure TForm1.SaveBmpBtnClick(Sender: TObject);
var
  s:string;
begin
  s:=changefileext(opendialog1.filename,'.BMP');
  chart1.saveToBitmapfile(s);
  showmessage('Chart saved as "'+s+'"');
end;

{************ SaveWMFBtnClick **********}
procedure TForm1.SaveWMFBtnClick(Sender: TObject);
var
  s:string;
begin
  s:=changefileext(opendialog1.filename,'.WMF');
  chart1.saveTometafileEnh(s);
  showmessage('Chart saved as "'+s+'"');
end;

{************ TitleEditChange *****}
procedure TForm1.TitleEditChange(Sender: TObject);
begin
  chart1.title.text[0]:=titleedit.text;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
