unit U_DiscreteSim2;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A discrete simulator program }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Menus, ComCtrls, ExtCtrls, Buttons;

type

  TStatsrec=class(TObject)
    total,min,max:real;
    count:integer;
    constructor Create;
    Procedure accum(const v:real);
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CaseSheet: TTabSheet;
    SummarySheet: TTabSheet;
    DetailSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Servergrid: TStringGrid;
    Custgrid: TStringGrid;
    RunBtn: TButton;
    RunTimeEdt: TEdit;
    StatusBar1: TStatusBar;
    AnimateBox: TCheckBox;
    Memo2: TMemo;
    UnitsGrp: TRadioGroup;
    ServerUpBtn: TBitBtn;
    ServerDownBtn: TBitBtn;
    PopupMenu1: TPopupMenu;
    Modifyselectedentry1: TMenuItem;
    Insertnewentry1: TMenuItem;
    Delete1: TMenuItem;
    Label4: TLabel;
    Label5: TLabel;
    GeneralSumryGrid: TStringGrid;
    JobSumryGrid: TStringGrid;
    ServerSumryGrid: TStringGrid;
    DetailGrid: TStringGrid;
    Panel1: TPanel;
    Label8: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Label11: TLabel;
    Label10: TLabel;
    RichEdit1: TRichEdit;
    procedure RunBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CustgridClick(Sender: TObject);
    procedure CustgridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ServergridClick(Sender: TObject);
    procedure ServergridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Exit1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Save1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ServerUpBtnClick(Sender: TObject);
    procedure ServerDownBtnClick(Sender: TObject);
    procedure Modifyselectedentry1Click(Sender: TObject);
    procedure Insertnewentry1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure UnitsGrpClick(Sender: TObject);
    procedure SetModified(Sender: TObject);
  private
    { Private declarations }
    Procedure setUpSim;
  public
    { Public declarations }
    casename:string;
    modified:boolean;
    procedure setupJobSumryGrid;
    procedure setupGeneralSumryGrid;
    procedure SetupServerSumryGrid;
    procedure ShowJobDetail;
    Procedure initstatgrids;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses Inifiles, SimUnit, UAnimate, DefClassUnit, DefServerUnit;


{**********  TStatsRec.Create ***************}
Constructor TStatsRec.Create;
Begin
  inherited;
  min:=1e30;
  max:=0;
  total:=0;
  count:=0;
end;

{********** TStatsRec.Accum ***********}
Procedure TStatsrec.accum(const v:real);
{add "V"  to accumulated statistics}
Begin
    inc(count);
    total:=total+v;
    if min>v then min:=v;
    if max<v then max:=v;
end;


type
  PTProbRec = ^TProbrec;  {record type used when accumulating statistics}
  Tprobrec=record
    rectype:TEventType;
    time:real;
    custrec:TCustQueueObj;
  end;

{**************** SortFUnc ***************}
 function SortFunc(Item1, Item2: Pointer): Integer;
 {Called from SetupGeneralSumryGrid in to sort the detail event recs in time sequence}
  begin
      if PTProbrec(item1)^.time<PTProbrec(item2)^.time then result:=-1
      else
        if PTPRobrec(item1)^.time>PTProbrec(item2)^.time then result:=+1
        else
        begin {equal times - compare types}
           If (PTProbrec(item1)^.rectype) = (PTProbrec(item2)^.rectype)
           then result:=0
           else
          if PTProbrec(item1)^.rectype=arrival then result:=-1
          else
          If (PTProbrec(item1)^.rectype=startprocess)
            and (PTProbrec(item2)^.rectype=departure)
          then result:=-1
          else result:=+1;
        end;
  end;



{******************** SetUpSim ************}
Procedure TForm1.SetupSim;
{Transfer case definition data from screen components to sim class}
var
  i:integer;
  CustClass:TCustomerclass;
  Server:TServer;
  newclass:char;
  newname:string;
  newarrivaldist:TDistType;
  newarrivalmeantime, newMaxWaitTime:real;
  newjobprofit, NewWaitCostRate, newgiveupcost:real;
begin
  with sim do
  Begin
    clearall; {clear old sim stuff and setup displayed info}
    with custgrid do
    for i:= fixedrows to rowcount-1 do
    if  cells[0,i]<>'' then
    Begin
      newclass:=cells[0,i][1];
      newname:=cells[1,i];
      newarrivaldist:=DistStrToType(cells[2,i]);
      newarrivalmeantime:= strtofloat(cells[3,i]);
      newmaxWaitTime:=strtofloat(cells[4,i]);
      newJobProfit:=strtofloat(cells[5,i]);
      newGiveUpCost:=strtofloat(cells[6,i]);
      newWaitcostrate:=strToFloat(cells[7,i]);
      CustClass:=TCustomerClass.create(newclass,newname{'Class '+newclass},
                                 newarrivaldist,
                                 newarrivalmeantime,0,newmaxwaitTime,
                                 newjobprofit,NewWaitCostRate,newgiveupcost);
      Sim.AddCustomerType(CustClass);
    end;
    with servergrid do
    for i:=fixedrows to rowcount-1 do
    if cells[0,i]<>'' then
    Begin
      server:=sim.findserver(strtoint(cells[0,i]));
      if server=nil then
      Begin
        Server:=TServer.create(strtoint(cells[0,i]),cells[1,i]);
        Sim.AddServer(Server);
      end;
      newclass:=cells[2,i][1];
      Server.addclass(newclass,
                      DistStrToType(cells[3,i]),
                      strtofloat(cells[4,i]),0
                      ,strtofloat(cells[5,i]), cells[6,i]);
    end;
  end;
  case unitsgrp.itemindex of
    0: sim.timefactor:=24*3600; {24 hr days}
    1: sim.timefactor:=8*3600;  {8 hr days}
    2: sim.timefactor:=3600;    {hours}
    3: sim.timefactor:=60;      {minutes}
    4: sim.timefactor:=1;       {seconds}
  end;
end;

{***************** RunBtnClick ***********}
procedure TForm1.RunBtnClick(Sender: TObject);
var x:real;
    errcode:integer;
begin;
  SetupSim;
  if (sim.customerclasses.count=0) or (sim.servers.count=0)
  then showmessage('At least one Customer Class and one Server must be defined')
  else
  begin
    cursor:=CrHourGlass;
    val(runtimeEdt.text,x,errcode);
    If animatebox.checked
    then
    begin
      sim.callback:=Aniform.callback;
      aniform.show;
    end
    else sim.callback:=nil;
    Sim.Run(x);
    cursor:=CRDefault;
    aniform.hide;
    if sim.runtime>0 then
    begin
      setupJobSumryGrid;
      setupGeneralSumryGrid;
      SetupServerSumryGrid;
      ShowJobDetail;
      pagecontrol1.activepage:=SummarySheet;
    end
    else pagecontrol1.activepage:=Casesheet;
  end;
end;


{*************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  With Custgrid do
  Begin
    cells[0,0]:='Class';
    colwidths[0]:=30;
    cells[1,0]:='Name';
    cells[2,0]:='Arrival';
    cells[2,1]:='dist. type';
    cells[3,0]:='Avg. time';
    cells[3,1]:='between arrivals';
    colwidths[3]:=90;
    cells[4,0]:='Max wait';
    cells[4,1]:='time';
    cells[5,0]:='Proft per';
    cells[5,1]:='processed job';
    cells[6,0]:='Cost of';
    cells[6,1]:='giveup';
    cells[7,0]:='Cost/time of';
    cells[7,1]:='waiting';

  end;
  With Servergrid do
  Begin
    cells[0,0]:='Server #';
    colwidths[0]:=50;
    cells[1,0]:='Name';
    cells[2,0]:='Class';
    colwidths[2]:=30;
    Cells[3,0]:='Process';
    Cells[3,1]:='Distribution';
    Cells[4,0]:='Mean process';
    colwidths[4]:=80;
    Cells[4,1]:='time';
    Cells[5,0]:='Cost per';
    Cells[5,1]:='time unit';
    colwidths[5]:=60;
    Cells[6,0]:='Selection';
    Cells[6,1]:='protocol';
    fixedrows:=2;
  end;
  longtimeformat:='hh:nn:ss';
  pagecontrol1.activepage:=Introsheet;
end;


{******************** CustGridClick *********}
procedure TForm1.CustgridClick(Sender: TObject);
{Add or Edit  a job class}


var
  i,index:integer;
begin

  With CustGrid , DefClassForm do
  Begin
    Setupsim;
    Initboxes;
    {Go through classes and eliminate from choices box any already existing
      (except current class}
    for i:= 0 to rowcount-1 do
    Begin
      if (cells[0,i]<>'') and (i<>row) then
      Begin
        index:=classbox.items.indexof(cells[0,i]);
        if index>=0 then classbox.items.delete(index);
        classbox.itemindex:=0;
      end;
    end;

    if cells[0,row]<>'' then
    Begin
      index:=classbox.items.indexof(cells[0,row]);
      Classnameedt.text:=cells[1,row];
      if index>=0 then ClassBox.Itemindex:=index;
      index:=DistTimeBox.items.indexof(cells[2,row]);
      If index>0 then DistTimeBox.itemindex:=index;

      ATimeEdt.text:=(cells[3,row]);
      MaxWaitEdt.text:=(cells[4,row]);
      jobProfitedt.text:=(cells[5,row]);
      giveupcostedt.text:=(cells[6,row]);
      WaitCostRateEdt.text:=(cells[7,row]);
    end;
    If DefClassForm.showmodal=mrOK then
    with DefClassForm do
    Begin
      {Update grid data}
       cells[0,row]:=classbox.text;
       cells[1,row]:=classnameedt.text;
       cells[2,row]:=DisttimeBox.text;
       cells[3,row]:=Atimeedt.text;
       cells[4,row]:=MaxWaitEdt.text;
       cells[5,row]:=JobProfitEdt.text;
       cells[6,row]:=GiveUpCostEdt.text;
       cells[7,row]:=WaitCostRateEdt.text;

       {If we just filled the last row, create a blank one}
       if row=rowcount-1 then rowcount:=rowcount+1;
       modified:=true;
       setupsim;
    End;
  end;
end;


{***************** CustGridKeyUp ************}
procedure TForm1.CustgridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Check for user request to delete a customer class}
var
  i:integer;
begin
  If key=vk_Delete then
  {Delete a row}
  with custgrid do
  Begin
    for i:=row to rowcount-2 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
    fixedrows:=2;
    modified:=true;
    setupsim;
  end
  else
  If key=vk_Insert then
  with custgrid do
  Begin
    row:=rowcount-1;
    if cells[0,row]<>'' then
    begin
      rowcount:=rowcount+1;
      row:=rowcount-1;
      {fixedrows:=2;}
    end;
    custgridclick(sender);
  end
  else if key=vk_return then custgridclick(sender);

end;

{***************** MakeNewBlankRow *********}
Procedure makeNewBlankRow(var grid:TStringGrid);
var
  i:integer;
  Begin
    with grid do
    begin
      rowcount:=rowcount+1;
      for i:= 0 to colcount-1 do cells[i,rowcount-1]:='';
    end;
  end;

{****************** ServerGridClick ***********}
procedure TForm1.ServergridClick(Sender: TObject);
{ Add or edit a server/class combination}
var   index,i:integer;
begin
  With ServerGrid, Defserverform do
  Begin
    Initboxes;
    {Now go through defined servers and eliminate from class choice box any that
      are not already defined}

    classbox.clear;
    with Custgrid do
    for i:= 1 to rowcount-1 do
    begin
      if (cells[0,i]<>'') then
      begin
        classbox.items.add(cells[0,i]);
        classbox.itemindex:=0;
      end;
    end;

    if cells[0,row]<>'' then
    Begin
      servernbredt.text:=(cells[0,row]);
      servernameedt.text:=cells[1,row];
      index:=classbox.items.indexof(cells[2,row]);
      if index>=0 then ClassBox.Itemindex:=index;
      index:=PDistBox.items.indexof(cells[3,row]);
      If index>0 then PDistBox.itemindex:=index;
      PTimeEdt.text:=(cells[4,row]);
      CostTimeEdt.text:=(cells[5,row]);
      ProtocolRgrp.itemindex:=ord(ProtocolStrToType(cells[6,row]));
    end;
    If showmodal=mrOK then
    begin
     {Update grid data}
      cells[0,row]:=ServerNbrEdt.text;
      cells[1,row]:=Servernameedt.text;
      cells[2,row]:=Classbox.text;
      cells[3,row]:=PDistBox.text;
      cells[4,row]:=Ptimeedt.text;
      cells[5,row]:=CostTimeEdt.text;
      cells[6,row]:= ProtocolStr[TSelectionprotocol(ProtocolRgrp.itemindex)];
      {make all other server/class records for this server have the same name}
      for i:= 0 to rowcount-1 do
      if (i<>row) and (cells[0,i]=cells[0,row])
      then cells[1,i]:=cells[1,row];
      {If we just filled the last row, create a blank one}
      if row=rowcount-1 then MakeNewBlankRow(ServerGrid);
      setupsim; {post change to sim object}
      modified:=true;
    end;
  end;
end;

{***************** ServerGridKeyUp ***************}
procedure TForm1.ServergridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Delete a server/class combination if Del key is pressed}
var
  i:integer;
begin
  If key=vk_Delete then
  {Delete a row}
  with servergrid do
  Begin
    for i:=row to rowcount-2 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
    fixedrows:=2;
    modified:=true;
    setupsim;  {post changr to sim}
  end
  else
  If key=vk_Insert then
  with ServerGrid do
  Begin
    row:=rowcount-1;
    if cells[0,row]<>'' then
    begin
      rowcount:=rowcount+1;
      row:=rowcount-1;
    end;
    ServerGridClick(sender);
  end
  else
  If key=vk_return then servergridclick(sender);

end;

{***************** Exit1Click ************}
procedure TForm1.Exit1Click(Sender: TObject);
{Menu Exit option}
begin
  close
end;

{************ SaveAs1Click ***********}
procedure TForm1.SaveAs1Click(Sender: TObject);
{Menu Save As option - save the current case definition and an init file}
begin
  {SetUpSim;}
  with savedialog1 do
  Begin
    Initialdir:=Extractfilepath(application.exename);
    Defaultext:='sim';
    if casename<>'' then
    Begin
      filename:=casename;
      Initialdir:=Extractfilepath(casename);
    end;
    if savedialog1.execute then
    Begin
      casename:=filename;
      caption:=extractfilename(casename);
      Save1Click(sender);
    end;
  end;
end;

{****************** Save1Click ************}
procedure TForm1.Save1Click(Sender: TObject);
{Menu save option, also call from SaveAs1Click}
var
  i,j:integer;
  Ini:TInifile;
  section,s:string;
begin
  SetupSim; {sim values are written so make sure latest grid values are in Sim}
  If fileexists(casename) then
  Begin
    s:=changefileext(casename,'.bak');
    deletefile(s);
    renamefile(casename,s);
  end;
  Ini:=TIniFIle.create(casename);
  {save customer class info}
  For i:= 0 to sim.customerclasses.count-1 do
  with TCustomerClass(sim.customerclasses[i]), Ini do
  Begin
    section:='Class '+ CustIdChar;
    writestring(Section,'Class',CustIdChar);
    writestring(section,'Classname',JobClassname);
    writeString(Section,'QDist',DistTypeToStr(QDist));
    writefloat(Section,'MeanInterArrivalTime',Qv1);
    writefloat(Section,'GiveUpCost',GiveUpCost);
    writefloat(Section,'JobProfit',JobProfit);
    writefloat(Section,'WaitCostRate',WaitCostRate);
    writefloat(Section,'MaxWait',MaxWaitBeforeLeaving);
  end;

  {save server info}
  For i:= 0 to sim.Servers.count-1 do
  with TServer(sim.Servers[i]), Ini do
  for j:= 0 to customertypes.count-1  do
  Begin
    section:='Server '+ format('%2d',[ServerNbr])+customertypes[j];
    writeinteger(Section,'ServerNbr',ServerNbr);
    writestring(section,'ServerName',Servername);
    writestring(Section,'Class',customertypes[j]);
    writeinteger(Section,'SelectionProtocol',ord(selectionprotocol));
    with TProcess(customertypes.objects[j]) do
    Begin
      writestring(section,'ProcessDist',DisttypeToStr(Pdist));
      writefloat(section,'MeanProcessTime',PV1);
      writefloat(section,'CostRate',CostRate);
    end;
  End;
  {save problem description}
  Ini.Writestring('General','Description',Memo1.lines.text);
  
  Ini.WriteString('General','RunTime', RuntimeEdt.text);
  Ini.WriteInteger('General','Timeunits',Unitsgrp.itemindex);
  Ini.free;
  modified:=false;
end;

{***************** Open1Click *********}
procedure TForm1.Open1Click(Sender: TObject);
{Menu open option - open a simulation case description file}
var
  i,j,n:integer;
  Ini:TInifile;
  section:string;
  Sections:TStringlist;
begin
  if modified
        and (messagedlg('Save current case first?',mtconfirmation,[mbyes,mbno],0)=mryes)
  then  Save1Click(sender);
  with opendialog1 do
  Begin
    Initialdir:=Extractfilepath(application.exename);
    Defaultext:='sim';
    if execute then
    Begin
      casename:=filename;
      caption:=extractfilename(casename);
      Ini:=TIniFIle.create(filename);
      Sections:=TStringList.Create;
      custgrid.rowcount:=custgrid.fixedrows;
      Servergrid.rowcount:=Servergrid.fixedrows;
      Ini.readsections(sections);
      for i:= 0 to sections.count-1 do
      Begin
        if Uppercase(copy(sections[i],1,5))='CLASS' then
        {load job class info}
        with custgrid, ini do
        Begin
          section:=sections[i];
          j:=rowcount;
          rowcount:=rowcount+1;
          cells[0,j]:=ReadString(section,'Class','*');
          cells[1,j]:=Readstring(section,'Classname','Class '+cells[0,j]);
          cells[2,j]:=ReadString(section,'Qdist','Exponential');
          cells[3,j]:=FloatToStr(ReadFloat(Section,'MeanInterArrivalTime',1));
          Cells[4,j]:=FloatToStr(Readfloat(Section,'MaxWait',10));
          cells[5,j]:=FloatToStr(Readfloat(Section,'JobProfit',10));
          cells[6,j]:=FloatToStr(Readfloat(Section,'GiveUpCost',0));;
          cells[7,j]:=FloatToStr(Readfloat(Section,'WaitCostRate',0));;
        end
        else if Uppercase(copy(sections[i],1,6))='SERVER' then
        {load server info}
        with servergrid, ini do
        Begin
          section:=sections[i];
          j:=rowcount;
          rowcount:=rowcount+1;
          cells[0,j]:=inttostr(readinteger(section,'ServerNbr',0));
          cells[1,j]:=readstring(section,'Servername',' Server #'+cells[0,j]);
          cells[2,j]:=readstring(section,'Class','*');
          cells[3,j]:=readstring(section,'ProcessDist','Exponential');
          cells[4,j]:=floattostr(readfloat(section,'MeanProcessTime',1));
          cells[5,j]:=FloatToStr(readfloat(section,'CostRate',0));
          n:=readinteger(section,'Protocol',0);
          cells[6,j]:=(ProtocolStr[TSelectionprotocol(n)]);

        end;
      end;
      {load description}
      Memo1.text:=Ini.readstring('General','Description','No description');

      RuntimeEdt.text:=Ini.readstring('General','RunTime','1440');
      UnitsGrp.itemindex:=Ini.readinteger('General','Timeunits',2);
      Ini.free;
      custgrid.rowcount:=custgrid.rowcount+1; {add a blank jobclass row}
      with custgrid do
      for i:=0 to colcount-1 do cells[i,rowcount-1] :='';
      custgrid.fixedrows:=2;
      servergrid.rowcount:=servergrid.rowcount+1; {add a blank server row}
      with servergrid do
      for i:=0 to colcount-1 do cells[i,rowcount-1] :='';
      servergrid.fixedrows:=2;
      sections.free;
      initstatgrids;
      modified:=false;
    end;
  end;
end;


{************* New1Click ***************}
procedure TForm1.New1Click(Sender: TObject);
{Menu New option - Start new simulation case}
begin
  custgrid.rowcount:=custgrid.fixedrows+1;
  servergrid.RowCount:=custgrid.Fixedrows+1;
  memo1.clear;
  memo1.text:='Problem description here.';
  caption:='New problem' ;
  casename:='New problem';
  initstatgrids;
end;

{***************** FormClose ************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
{Form cloase exit - give user a chance save a modified case}
var
  r:integer;
begin
  action:=caFree;
  If modified then
  Begin
    r:=messagedlg('Save case '+extractfilename(casename)+'?',
                  mtConfirmation,[mbyes,mbno,mbcancel],0);
    If r=mrYes then
    Begin
      if casename<>'' then Save1click(sender)
      else SaveAs1click(sender);
    end
    else if r=mrcancel then action:=caNone;
  end;
end;

{*************** FormCloseQuery ************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  sim.tag:=1;
  canclose:=true;
end;

{***************** ServerUpBtnClick *************}
procedure TForm1.ServerUpBtnClick(Sender: TObject);
{Move a server/class row up  within this server in order to
 change the order in which jobs are procressed by this server}
var temp:TStringlist;
begin
  with servergrid do
  begin
    if (row>0) and (cells[0,row-1]=cells[0,row])
    then
    begin
      temp:=Tstringlist.create;
      temp.assign(rows[row-1]);
      rows[row-1].assign(rows[row]);
      rows[row].assign(temp);
      temp.free;
    end;
  end;
end;

{***************** ServerDownBtnClick **********}
procedure TForm1.ServerDownBtnClick(Sender: TObject);
{Move a server/class row down  within this server in order to
 change the order in which jobs are processed by this server}
var temp:TStringlist;
begin
  with servergrid do
  begin
    if (row<rowcount-1) and (cells[0,row]=cells[0,row+1]) then
    begin
      temp:=Tstringlist.create;
      temp.assign(rows[row+1]);
      rows[row+1].assign(rows[row]);
      rows[row].assign(temp);
      temp.free;
    end;
  end;
end;


{***************** ModifySelectedEntryClick ********}
procedure TForm1.Modifyselectedentry1Click(Sender: TObject);
{Call dialog to modify jobclass or server entry - called form popup menu}
var  g:TStringgrid;
begin
  if popupmenu1.popupcomponent is TStringgrid then
  begin
    g:=tstringgrid(popupmenu1.popupcomponent);
    with g do
    begin
      if (row>=2) and (cells[0,row]<>'') then g.ondblclick(sender);
    end;
  end;
end;

{*************** InsertNewEntry **********}
procedure TForm1.Insertnewentry1Click(Sender: TObject);
{Make a new jobclass or server entry - called from popup menu}
var  g:TStringgrid;
begin
  {Move to last row and call dblclick}
  if popupmenu1.popupcomponent is TStringgrid then
  begin
    g:=tstringgrid(popupmenu1.popupcomponent);
    with g do
    begin
      row:=rowcount-1;
      if (cells[0,row]='') then g.ondblclick(sender);
    end;
  end;
end;

{****************** Delete1Click **********}
procedure TForm1.Delete1Click(Sender: TObject);
{Delete a jobclass or server entry - called from popup menu}
var  g:TStringgrid;
     key:word;
begin
  { simulate Del key if on a deletable row}
   if popupmenu1.popupcomponent is TStringgrid then
  begin
    g:=tstringgrid(popupmenu1.popupcomponent);
    with g do
    begin
      key:=vk_delete;
      if (row>=2) and (cells[0,row]<>'')
      then
        if g=custgrid then CustgridKeyUp(g, key,[])
        else if g=servergrid then ServergridKeyUp(g, key,[]);
    end;
  end;
end;

procedure Tform1.initstatgrids;
var i:integer;
begin
  with GeneralSumryGrid do
  Begin
    colcount:=2;
    fixedcols:=1;
    colwidths[0]:=150;
    cells[0,0]:='Avg. # being processed';
    cells[0,1]:='Avg # waiting';
    cells[0,2]:='Avg # in system';
    cells[0,3]:='Avg process time';
    cells[0,4]:='Avg waiting time';
    cells[0,5]:='Avg time in system';
    cells[0,6]:='Prob of 0 customers being processed';
    cells[0,7]:='Prob of 0 customers waiting';
    cells[0,8]:='Total profit from processed jobs';
    cells[0,9]:='Total cost of give-ups';
    cells[0,10]:='Total cost of waiting for service';
    cells[0,11]:='Total server cost';
    cells[0,12]:='Total Profit/loss per unit time';
    for i:=2 to rowcount-1 do cells[1,i]:=''; {clear any previous stats}
  end;

  with JobSumryGrid do
  Begin
    cells[0,0]:='Class';
    Cells[1,0]:='Entered';
    cells[1,1]:='System';
    cells[2,0]:='Departed';
    cells[2,1]:='Processed';
    cells[3,0]:='Departed';
    cells[3,1]:='Gave Up';
    cells[4,0]:='Departed';
    cells[4,1]:='Total';
    cells[5,0]:='Waiting';
  end;
  With ServerSumryGrid do
  Begin
    cells[0,0]:='Server #';
    cells[1,0]:='Class';
    cells[2,0]:='Jobs';
    cells[3,0]:='Busy Time';
    cells[4,0]:='Utilization';
  end;
  With detailgrid do
  Begin
    colcount:=8;
    rowcount:=1;
    cells[0,0]:='Job #';
    cells[1,0]:='Class';
    cells[2,0]:='Arrival';
    cells[3,0]:='Wait';
    cells[4,0]:='Processed?';
    cells[5,0]:='Start';
    cells[6,0]:='Process';
    cells[7,0]:='End';
  end;
end;


{********************** SetupGeneralSumryGrid ********************}
Procedure TForm1.SetupGeneralSumryGrid;
{Build overall stats table}
var
  i,j,k:integer;
  pp0,wp0:real;
  probrec:PTProbrec;
  ProbRecList:TList;
  MySortFunc:TListSortCompare;
  totwait,totprocess,x, prevtime:real;
  njobswaitingtime, njobsprocesstime:array[0..1000] of real;
  wait,process,jprofit,givupcost,waitingcost,servercost:TStatsrec;
Begin

  wait:=TStatsrec.create;
  process:=TStatsrec.create;
  jprofit:=TStatsrec.create;
  givupcost:=TStatsrec.create;
  waitingcost:=TStatsrec.create;
  ServerCost:=TSTatsrec.create;
  with GeneralSumryGrid do
  Begin
    Probreclist:=TList.create;
    MySortfunc:=sortfunc;
    with sim.processedqueue do
    for i:=0 to count-1 do
    with TCustQueueObj(list[i]) do
    begin
      wait.accum(waittime);
      process.accum(processtime);
      if eventtype=departure then
      with custclassobj do
      Begin
        jprofit.accum(JobProfit);
        waitingcost.accum(waitcostrate*waitTime);
      end;
      If eventtype=maxwaitexceeded then
      with custclassobj do
      Begin
         givupcost.accum(GiveUpCost);
         waitingcost.accum(waitcostrate*waitTime);
      end;
      new(probrec);
      with probrec^ do
      begin
        rectype:=arrival;
        time:=arrivaltime;
        custrec:=TCustQueueObj(list[i]);
      end;
      probreclist.add(probrec);

      new(probrec);
      with probrec^ do
      begin
        rectype:=startprocess;
        time:=arrivaltime+waittime;
        custrec:=TCustQueueObj(list[i]);
      end;
      probreclist.add(probrec);

      new(probrec);
      with probrec^ do
      begin
        rectype:=departure;
        time:=arrivaltime+waittime+processtime;
        custrec:=TCustQueueObj(list[i]);
      end;
      probreclist.add(probrec);
    end;

    with sim do
    for i:= 0 to servers.count-1 do
      with TServer(servers[i]) do servercost.accum(defaultcostrate*runtime);
    Probreclist.sort(MySortFunc);
    j:=0;
    k:=0;
    totwait:=0;
    totprocess:=0;
    prevtime:=0;
    for i:= 0 to 100 do
    Begin
      njobswaitingtime[i]:=0;
      njobsprocesstime[i]:=0;
    end;
    with probreclist do
    for i:= 0 to count-1 do
    with PTProbrec(List[i])^ do
    Begin
      if i>0 then
      Begin
        x:=time-prevtime;
        njobswaitingtime[j]:=njobswaitingtime[j]+x;
        totwait:=totwait+x;
        if k>=0 then njobsProcessTime[k]:=nJobsProcessTime[k]+x;
        totprocess:=totprocess+x;
      end;

      prevtime:=time;
      case rectype of
       arrival : inc(j);
       startprocess:
         begin
           dec(j);
           inc(k);
         end;
       departure: dec(k);
       end; {case}
    end;

    if totwait>0 then pp0:=njobsWaitingtime[0]/totwait else pp0:=0;
    if totprocess>0 then wp0:=njobsProcessTime[0]/totprocess else wp0:=0;

    cells[1,0]:=floattostrf(process.total/sim.runtime,ffNumber,5,2);
    cells[1,1]:=floattostrf(wait.total/sim.runtime,ffNumber,5,2);
    cells[1,2]:=floattostrf((wait.total+process.total)/sim.runtime,ffNumber,5,2);
    cells[1,3]:=floattostrf(process.total/process.count,ffNumber,5,2);
    cells[1,4]:=floattostrf(wait.total/wait.count,ffNumber,5,2);
    cells[1,5]:=floattostrf((wait.total/wait.count+process.total/process.count),ffNumber,3,2);
    cells[1,6]:=floattostrf(pp0,ffNumber,5,1);
    cells[1,7]:=floattostrf(wp0,ffNumber,3,1);
    cells[1,8]:=floattostrf(jprofit.total,ffNumber,7,2);
    cells[1,9]:=floattoStrf(givupCost.total,ffNumber,7,2);
    cells[1,10]:=floattoStrf(waitingCost.total,ffNumber,7,2);
    cells[1,11]:=floattostrf(Servercost.total,ffNumber,7,2);
    cells[1,12]:=floattostrf((jprofit.total-givupcost.total-waitingcost.total-servercost.total)/sim.runtime,
                             ffNumber,7,2);
   end;
   wait.free;
   process.free;
   jprofit.free;
   givupcost.free;
   servercost.free;
   probreclist.free;
end;


{*************************** SetUpJobSumryGrid ********************}
Procedure TForm1.setupJobSumryGrid;
{Build summary statistics for jobs}
var
  counts:array[ord('A')..ord('Z'),1..5] of integer;
  i,j,r:integer;
  wait,process,inter:TStatsrec;

begin
  wait:=TStatsrec.create;
  process:=TStatsrec.create;
  inter:=TStatsrec.create;

  for i:= ord('A') to ord('Z') do for j:=1 to 5 do counts[i,j]:=0;
  with sim.processedqueue do
  Begin
    for i:= count-1 downto 0 do
    with TCustQueueObj(list[i]) do
    Begin
      j:=ord(TCustQueueObj(list[i]).CustUniqueId[1]);
      inc(counts[j,1]); {arrivals}
      if eventtype = departure then
      Begin
        inc(counts[j,4]); {departures}
        if processtime>0 then inc(counts[j,2]); {processed}
      end
      else if eventtype=MaxWaitExceeded then
      Begin
        inc(counts[j,3]);  {giveups}
        inc(counts[j,4]);  {departures}
      end;
    end;
  end;

  with sim.waitqueue do
  Begin
    for i:= count-1 downto 0 do
    Begin
      j:=ord(TCustQueueObj(list[i]).CustUniqueId[1]);
      inc(counts[j,1]); {arrivals}
      inc(counts[j,5]); {waiting}
    end;
  end;

  with JobSumryGrid do
  Begin
    rowcount:=2;

    For i:=ord('A') to ord('Z') do
    Begin
      If counts[i,1]>0 then
      Begin
        r:=rowcount;
        rowcount:=rowcount+1;
        cells[0,r]:=char(i);
        for j:=1 to 5 do cells[j,r]:=inttostr(counts[i,j]);
      end;
    end;
    if rowcount=2 then rowcount:=3;
    fixedrows:=2;
  end;
  wait.free;
  process.free;
  inter.free;
end;


{**************************** SetupServerSumryGrid ****************}
 procedure TForm1.SetUpServerSumryGrid;
 {build statistics for servers}
  type
    TStatsRec = record
      servernbr:integer;
      jobcount:integer;
      Process:real;
    end;
  var
  i,j:integer;
  job:TCustQueueObj;
  SStats:array of TStatsRec;
  statsreccount:integer;

  function findstatsrec(n:integer):integer;
  var
    i:integer;
  begin
    result:=-1;
    If statsreccount>0 then
    Begin
      i:=0;
      while (i<statsreccount)  and (n<>sStats[i].servernbr) do inc(i);
      if i<statsreccount then result:=i;
    end;
  end;

begin
  With ServerSumryGrid do
    Begin
      Setlength(SStats,sim.Servers.count); {set array of stats recs , one for each server}
      statsreccount:=0;
      for i:=0 to sim.servers.count-1  Do
      with (SStats[i]) do
      Begin
        jobcount:=0;
        process:=0;
      end;
      with sim.processedqueue do
      Begin
        for i:= 0 to count-1 do
        Begin
          job:=list[i];
          if assigned(job.serverobj) then
          begin
            j:=findstatsrec(job.serverobj.ServerNbr);
            If j<0 then
            begin
              inc(statsreccount);
              j:=statsreccount-1;
            end;
            with SStats[j] do
            begin
              servernbr:=job.ServerObj.servernbr;
              inc(jobcount);
              process:=process+job.processtime;
            end;
          end;
        end;
        {rowcount:=0;}
        for i:=0 to sim.servers.count-1 do
        with TStatsrec(SStats[i]) do
        Begin
          rowcount:=i+2;
          j:=fixedrows+i;
          cells[0,j]:=inttostr(servernbr);
          Cells[1,j]:='All';
          cells[2,j]:=inttostr(jobcount);
          cells[3,j]:=floattostrf(process,ffNumber,6,1);
          cells[4,j]:=floattostrf(process/sim.currenttime*100,ffNumber,6,1)+'%';
        end;
      end;
    end;
end;

{************* ShowJobDetail ***********}
Procedure TForm1.ShowJobDetail;
 var
  i,c:integer;
  job:TCustQueueObj;
  prevarrival:real;
  interarrival,wait,process:real;
begin

  With detailgrid do
  Begin
    with sim.processedqueue do
    Begin
      interarrival:=0;
      prevarrival:=0;
      wait:=0;
      process:=0;
      for i:= count downto 1 do
      Begin
        job:=list[i-1];
        If i<count
        then interarrival:=interarrival-job.arrivaltime+prevarrival;
        prevarrival:=job.arrivaltime;
        wait:=wait+job.waittime;

        process:=process+job.processtime;
        if i>=rowcount then rowcount:=i+1;
        cells[0,i]:=inttostr(i);
        cells[1,i]:=job.custclassobj.CustIDChar;
        cells[2,i]:=timetostr(job.arrivaltime/secsperday);
        cells[3,i]:=floattostrf(job.waittime,ffNumber,6,1);
        If job.eventtype=departure then cells[4,i]:='Y'
        else if job.eventType=MaxWaitExceeded then cells[4,i]:='N';
        cells[5,i]:=timetostr((job.arrivaltime+job.waittime)/secsperday);
        cells[6,i]:=floattostrf(job.processtime,ffNumber,6,1);
        cells[7,i]:=timetostr((job.arrivaltime+job.waittime+job.processtime)/secsperday);
      end;
    end;
    rowcount:=rowcount+1;
    fixedrows:=2;
    i:=rowcount-1;
    cells[0,i]:='Total';
    cells[1,i]:='Interarrival';
    cells[2,i]:=floattostrf(interarrival,ffNumber,6,1);
    cells[3,i]:=floattostrf(wait,ffNumber,6,1);
    cells[6,i]:=floattostrf(process,ffNumber,6,1);
    c:=sim.processedqueue.count;
    rowcount:=rowcount+1;
    i:=rowcount-1;
    cells[0,i]:='Average';
    cells[1,i]:='Interarrival';
    cells[2,i]:=floattostrf(interarrival/c,ffNumber,6,1);
    cells[3,i]:=floattostrf(wait/c,ffNumber,6,1);
    cells[6,i]:=floattostrf(process/c,ffNumber,6,1);
    fixedrows:=1;
  end;
end;


{************** PageControl1Change ****************}
procedure TForm1.PageControl1Change(Sender: TObject);
begin
  {give user a chance to open a case when none is loaded and we are going to
   the Case Definition page}
  if (pagecontrol1.activepage=CaseSheet) and (casename='') then open1click(sender);
end;

procedure TForm1.UnitsGrpClick(Sender: TObject);
begin
(*
  with unitsgrp do
  if itemindex=0 then aniform.hrsperday:=24
  else if itemindex=1 then aniform.hrsperday:=8;
  *)
end;

procedure TForm1.SetModified(Sender: TObject);
{called when description or runtime is changed}
begin
  modified:=true;
end;


end.
