unit U_ReactionTrialDefs4;
{Copyright 2001-2011 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This unit lets you to add, delete and change reaction-time trial definitions}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls, Inifiles, Grids, ComCtrls, Buttons, Menus, UdFFRegistry,
  CheckLst, StrUtils, JPEG;

type

  TtrialdefObj = class(TObject) {defines a trial}
    TrialDefId:string;
    Description:string;
    Active:boolean;
    mindelay,maxdelay:integer; {delay between response and next target}
    Audible:boolean;  {True = play wave file or resource with this case}
    Visual:boolean;  {True = use visual display with this case}
    {Visual parameters}
    FixedTargetPosition:boolean;
    Nbrsamples:integer;
    TargetShape:TShapeType;
    Xminsize,Xmaxsize:integer;  {percent of screen width}
    YMinsize,YMaxsize:integer;   {percent of screen width}
    TargetColor,BackGroundColor:TColor;
    Imagelist:TStringlist;
    {Audio parameters}
    ResourceName:string;
    SoundIndex:integer;
  end;

  TForm2 = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Nbrsampsedt: TEdit;
    NbrSampsUD: TUpDown;
    ColorDialog1: TColorDialog;
    DescEdt: TEdit;
    Label7: TLabel;
    OKBtn: TBitBtn;
    Label8: TLabel;
    Edit1: TEdit;
    MinDelayUD: TUpDown;
    Label9: TLabel;
    Edit2: TEdit;
    MaxDelayUD: TUpDown;
    ActiveBox: TCheckBox;
    PopupMenu1: TPopupMenu;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    Activate1: TMenuItem;
    Modify1: TMenuItem;
    DetailBox: TCheckBox;
    SumryBox: TCheckBox;
    DetailNameEdt: TEdit;
    SumryNameEdt: TEdit;
    DetailDialog: TSaveDialog;
    Delimiter: TRadioGroup;
    PageControl1: TPageControl;
    VisualSheet: TTabSheet;
    SoundSheet: TTabSheet;
    PosCBox: TCheckBox;
    ShapeGrp: TRadioGroup;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    XMinEdt: TEdit;
    XMinUD: TUpDown;
    XMaxEdt: TEdit;
    XMaxUD: TUpDown;
    YMinEdt: TEdit;
    YMinUD: TUpDown;
    YMaxEdt: TEdit;
    YMaxUD: TUpDown;
    TColorPnl: TPanel;
    BColorPnl: TPanel;
    SoundGrp: TRadioGroup;
    CaseIdLbl: TLabel;
    TrialsBox: TListBox;
    OpenDialog1: TOpenDialog;
    SumryDialog: TSaveDialog;
    EarlyGrp: TRadioGroup;
    UseStimulusGrp: TRadioGroup;
    Label10: TLabel;
    Edit3: TEdit;
    EarlyUD: TUpDown;
    LateUD: TUpDown;
    Edit4: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    OpenDialog2: TOpenDialog;
    Panel1: TPanel;
    FileCheckListBox: TCheckListBox;
    Memo1: TMemo;
    Label13: TLabel;
    DefaultName: TEdit;
    WriteAllDetail: TCheckBox;

    procedure TrialsBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure TColorPnlClick(Sender: TObject);
    procedure BColorPnlClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GroupBox1Exit(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Modify1Click(Sender: TObject);
    procedure TrialsBoxClick(Sender: TObject);
    procedure Activate1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure Casechanged(Sender: TObject);
    procedure DetailNameEdtClick(Sender: TObject);
    procedure SumryNameEdtClick(Sender: TObject);
    procedure EarlyUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure LateUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure ShapeGrpClick(Sender: TObject);
    procedure FileCheckListBoxClickCheck(Sender: TObject);
  public
    { Public declarations }
    Ininame:string;
    dir:string;
    HoldTColor,HoldBColor:TColor;
    modified:boolean;
    positionInlist:integer; {the itemindex of the currently active case}
    EarlyClickTime, LateClickTime:double;
    procedure MakeNewTrialDef(ID:string);
    procedure loadCases;
    procedure GetImageFiles(startpath:string);
  end;

  function GetWorkDir:string;
var
  Form2: TForm2;

implementation

uses U_ReactionTimes4;

{$R *.DFM}
{$R RTimeSounds.res}

{*********** GetWorkDir ********}
function GetWorkDir:string;
var
  s:string;
begin
   result:=extractfilepath(application.exename);
   s:=result+ 'Reactions.ini';
   if (fileexists(s) and ((filegetattr(s) and faReadOnly)>0))
   or  (getDriveType(pchar(result))=Drive_CDROM)
   then result:=GetDFFCommonPath(True);
end;

{************* FileChecklistBosClickCheck **************}
procedure TForm2.FileCheckListBoxClickCheck(Sender: TObject);
begin
  With filechecklistbox do {move check item to top of list}
    if checked[itemindex] then items.move(itemindex,0);
  modified:=true;
end;

{**************** TrialsBoxKeyDown ***********}
procedure TForm2.TrialsBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (sender is TEdit) then exit;
  If key=vk_Insert then
  begin
    Groupbox1Exit(sender);
    insert1click(sender);
    key:=0
  end
  else if key=vk_delete  then
  begin
    delete1click(sender);
    key:=0;
  end;
end;

{************ MakeNewTrialDef **********}
procedure Tform2.makeNewTrialDef(ID:string);
{make a new trial definition for item ID}
var
  t:TTrialDefObj;
  section:string;
begin
  t:=TTrialdefObj.create;
  trialsbox.items.addobject(ID,t);
  trialsbox.itemindex:=trialsbox.items.count-1;

  with t, trialsbox do
  begin
    section:=items[itemindex];
    nbrsamples:=10;
    trialdefid:=section;
    CaseIDLbl.caption:=TrialDefId;
    activebox.checked:=true;
    Description:='Small round blue target with white background';
    FixedTargetPosition:=true;
    TargetShape:=stCircle;
    Xminsize:=10;
    XMaxSize:=10;
    Yminsize:=10;
    YMaxSize:=10;
    TargetColor:=clblue;
    Mindelay:=1;
    Maxdelay:=5;
    BackGroundColor:=clwhite;
    items.objects[itemindex]:=t;
    audible:=false;
    visual:=true;
    resourcename:='';
    soundindex:=1;
    pagecontrol1.activepage:=VisualSheet;
  end;
end;

{************* Loadcases **********}
procedure TForm2.LoadCases;
var
  Ini:TInifile;
  i,n:integer;
  t:TTrialdefObj;
  section:string;
  dir:string;
  s:string;
  offset:Integer;
begin

  Ininame:=extractfilepath(application.exename)+'Reactions.ini';
  Ini:=Tinifile.create(Ininame);
  with ini do
  begin
    readsections(trialsbox.Items); {get trials definition section names}
    i:=trialsbox.items.indexof('Files'); {don't scan 'files' section as case}
    {load file parameters}
    if i>=0 then trialsbox.items.delete(i); {trialsbox.items.delete(i); }
    DetailBox.checked:=readbool('Files','MakeDetail',true);
    SumryBox.checked:=readbool('Files','MakeSummary',true);
    dir:=extractfilepath(application.exename);
    DetailNameEdt.text:=readstring('Files','DetailName',dir+'reactiondetail.rsd');
    SumryNameEdt.text:=readstring('Files','SummaryName','dir+reactiontimes.rsp');
    If extractfilepath(detailnameEdt.Text)=''
    then detailnameedt.text:=dir+detailnameedt.text;
    If extractfilepath(SumrynameEdt.Text)=''
    then SumrynameEdt.text:=dir+SumrynameEdt.text;

    delimiter.itemindex:=readinteger('Files','Delimiter',0);
    EarlyUD.position:=readinteger('Files','EarlyCLick',0);
    LateUD.position:=readinteger('Files','LateClick',2000);
    EarlyGrp.itemindex:=readinteger('Files','IgnoreEarly',0);
    EarlyClickTime:=Earlyud.Position/1000;
    LateClickTime:=LateUD.position/1000;
    Defaultname.text:=readstring('Files','DefaultName','Guest');
    WriteAllDetail.checked:=readbool('Files','WriteAllDetail',False);
    if trialsbox.items.count=0 then trialsbox.items.add('T1');
    for i:=0 to trialsbox.items.count-1 do
    begin
      t:=TTrialdefObj.create;
      with t do
      begin
        section:=trialsbox.items[i];
        nbrsamples:=readinteger(section,'NbrSamples',10);
        trialdefid:=section;
        active:=readbool(section,'Active',true);
        UseStimulusGrp.ItemIndex:=Readinteger(section,'StimulusType',0);
        audible:=true;
        visual:=true;
        Case UseStimulusGrp.itemindex of
          0: audible:=false;  {visual only}
          1: visual:=false;  {audible only}
        end;
        resourcename:=readstring(section,'Resourcename','');
        SoundIndex:=readinteger(section,'Soundindex',1);
        Description:=readstring(section,'Description','Circular target in a fixed position');
        FixedTargetPosition:=readbool(section,'FixedTargetPosition',true);
        TargetShape:=TShapetype(readinteger(section,'TargetShape',ord(stCircle)));
        Xminsize:=readinteger(section,'XMinsizePct',10);
        XMaxSize:=readinteger(section,'XmaxsizePct',10);
        Yminsize:=readinteger(section,'YMinsizePct',10);
        YMaxSize:=readinteger(section,'YmaxsizePct',10);
        TargetColor:=readinteger(section,'TargetColor',Integer(clblue));
        TColorPnl.color:=TargetColor;
        Mindelay:=readinteger(section,'MinDelay',1);
        Maxdelay:=readinteger(section,'MaxDelay',5);
        BackgroundColor:=readinteger(section,'BgColor',Integer(clwhite));
        BColorPnl.color:=BackGroundColor;

        if targetshape=stSquare then {stSquare = image list type}
        begin
          if not assigned(imagelist) then imagelist:=TStringlist.create;
          offset:=1;
          s:=readstring(section,'Images','');
          if length(s)>0 then
          begin
            if s[length(s)]<>',' then s:=s+',';
            n:=posex(',',s,offset);
           while n>1 do
            begin
              imagelist.addobject(copy(s,offset,n-offset),nil);
              offset:=n+1;
              n:=posex(',',s,offset);
            end;
          end;
        end;
      end;
      trialsbox.items.objects[i]:=t;
    end;
  end;
  ini.free;
end;


{************** FormActivate *********}
procedure TForm2.FormActivate(Sender: TObject);
begin
  {get trialdef info from ini file}
  loadcases;
  modified:=false;
  trialsbox.itemindex:=0;
  trialsbox.setfocus;
  trialsboxclick(sender);
end;

{************ TColorPnlClick *******}
procedure TForm2.TColorPnlClick(Sender: TObject);
begin
  colordialog1.color:=TColorPnl.color;
  If colordialog1.execute then
  begin
    with trialsbox do
    TTrialdefobj(items.objects[itemindex]).targetcolor:=colordialog1.color;
    TColorPnl.color:=colordialog1.Color;
    modified:=true;
  end;
end;

{***********  BColorPnlClick **********}
procedure TForm2.BColorPnlClick(Sender: TObject);
begin
  colordialog1.color:=BColorPnl.color;
  If colordialog1.execute then
  begin
    with trialsbox do
    TTrialdefobj(items.objects[itemindex]).backgroundcolor:=colordialog1.color;
    BColorPnl.color:=colordialog1.Color;
    modified:=true;
  end;
end;

{**************** FormClose ***********}
procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini:TInifile;
  i,j:integer;
  t:TTrialDefObj;
  section:string;
  index:integer;
  s:string;
begin
  groupBox1Exit(sender); {in case data has not been transferred to the trialfdefobject}
  if fileexists(ininame) and ((filegetattr(ininame) and faReadonly)>0)
  then ini:=tinifile.create(getworkdir+'Reactions.ini')
  else Ini:=Tinifile.create(Ininame);
  begin
    with ini do
    begin
      writebool('Files','MakeDetail',DetailBox.checked);
      writebool('Files','MakeSummary',SumryBox.checked);
      Writestring('Files','DetailName',extractfilename(DetailNameEdt.text));
      Writestring('Files','SummaryName',extractfilename(SumryNameEdt.text));
      Writeinteger('Files','Delimiter',Delimiter.itemindex);
      WriteInteger('Files','EarlyClick',EarlyUD.position);
      WriteInteger('Files','LateClick',LateUD.position);
      WriteInteger('Files','IgnoreEarly',EarlyGrp.itemindex);
      WriteString('Files','Defaultname',Defaultname.Text);
      WriteBool('Files','WriteallDetail', WriteAllDetail.Checked);
      for i:=0 to trialsbox.items.count-1 do
      with trialsbox.items do
      begin
        section:=strings[i];
        t:=TTrialdefObj(objects[i]);
        with t do
        begin
          writeinteger(section,'NbrSamples',nbrsamples);
          writebool(section,'Active',active);
          if visual and audible then index:=2
          else if visual then index:=0
          else index:=1;
          writeinteger(section,'StimulusType',Index);
          writestring(section,'Resourcename',resourcename);
          writeInteger(section,'SoundIndex',Soundindex);
          writestring(section,'Description',description);
          writebool(section,'FixedTargetPosition',fixedtargetposition);
          writeinteger(section,'TargetShape',ord(targetshape));
          writeinteger(section,'XMinsizePct',XMinSize);
          writeinteger(section,'XmaxsizePct',XMaxSize);
          writeinteger(section,'YMinsizePct',YMinSize);
          writeinteger(section,'YmaxsizePct',YMaxSize);
          writeinteger(section,'TargetColor',Targetcolor);
          writeinteger(section,'MinDelay',Mindelay);
          writeinteger(section,'MaxDelay',Maxdelay);
          writeinteger(section,'BgColor',Integer(backgroundcolor));
          if targetshape=stSquare then
          with imagelist do
          begin
            s:='';
            for j:= count-1 downto 0 do s:=strings[j]+','+s;
            writestring(section,'Images',s);
          end
          else writestring(section,'Images','');
        end;
      end;
    end;
    ini.free;
  end;
  action:=caHide;
end;

{************ GroupBox1Exit ***********}
procedure TForm2.GroupBox1Exit(Sender: TObject);
var
  i:integer;
begin
  If modified and (messagedlg('Save changes to case '+caseIdLbl.caption+' first?',
                               mtConfirmation,[mbYes,mbNo],0)=MrYes)
  then  with trialsbox, TTrialdefobj(items.objects[positionInList]) do
  begin
    trialdefid:=items[positioninlist];
    nbrsamples:=NbrsampsUD.position;
    Active:=Activebox.checked;
    Description:=DescEdt.text;
    audible:=true;
    visual:=true;
    Case UseStimulusGrp.itemindex of
      0: audible:=false;  {visual only}
      1: visual:=false;  {audible only}
    end;
    Mindelay:=MinDelayUD.position;
    Maxdelay:=MaxDelayUD.position;
    XMaxsize:=XMaxUD.position;
    XMinSize:=XMinUD.Position;
    YMaxSize:=YMaxUD.position;
    YMinSize:=YMinUD.position;
    resourceName:=soundgrp.items[soundgrp.itemindex];
    soundindex:=soundgrp.itemindex;
    FixedTargetPosition:=PosCBox.checked;
    TargetColor:=TColorPnl.color;
    BackgroundColor:=BColorPnl.color;
    if shapegrp.itemindex<3 then targetshape:=Tshapetype(shapegrp.itemindex * 2)
    else
    begin
      targetshape:=stSquare;
      {Now add the checked items back into imagelist}
      with Imagelist do
      begin
        for i:=0 to count-1 do if assigned(objects[i]) then TImage(objects[i]).free;
        clear;
      end;
      with filechecklistbox do
      for i:= 0 to count-1 do
      begin
        if checked[i] then imagelist.add(items[i]);
      end;
    end;
    XMinSize:=XMinUD.position;
    XMaxSize:=XMaxUD.position;
    YMinSize:=YMinUD.position;
    YMaxSize:=YMaxUD.position;
  end;
  modified:=false;
end;

{************* Insert1Click *************}
procedure TForm2.Insert1Click(Sender: TObject);
{Define a new trial definition}
var
  Id:string;
  index:integer;
begin
    ID:=InputBox('New Trial Definition', 'Enter Id for new definition','');
    Index:=trialsbox.items.indexof(ID);
    If index>=0 then
    begin
      showmessage(ID+' is already defined, please try again');
      ID:=''
    end;
    If ID<>'' then makenewTrialDef(ID);
end;

{**************** Delete1Click **************}
procedure TForm2.Delete1Click(Sender: TObject);
{delete a trial definition}
{don't forget to erase the section from the ini file too!
 otherwise when we update, the old section will still be there
 It would be better to set a "deleted" flag and only delete at
 exit time}
var
  ini:TInifile;
begin
  with trialsbox, items do
  begin
    if messagedlg('Delete tr1al definition ' +items[itemindex]+'?',
                  mtconfirmation,[mbyes,mbno],0)=mryes
    then
    begin
      TTrialdefObj(objects[itemindex]).free;
      ini:=Tinifile.create(Ininame);
      ini.erasesection(items[itemindex]);
      ini.free;
      items.delete(itemindex);
      if (itemindex<0) then itemindex:=count-1; {deleted last item}
      trialsboxclick(sender);
    end;
  end;
end;

{**************** Modify1Click *************}
procedure TForm2.Modify1Click(Sender: TObject);
begin
  messagedlg('Changing existing trial definition may invalidate previously recorded results',
              mtWarning,[mbOK],0);
end;

{************** TrialsBoxClick *************}
procedure TForm2.TrialsBoxClick(Sender: TObject);
var
  t:tTrialDefObj;
begin
  Groupbox1Exit(sender); {in case current displayed case was modified}

  with trialsbox do t:=TTrialdefobj(items.objects[itemindex]);
  with Trialsbox, t do
  begin
    PositionInList:=itemindex;
    CaseIdLbl.caption:=TrialDefId;
    NbrsampsUD.position:=nbrsamples;
    Activebox.checked:=active;
    DescEdt.text:=Description;
    MindelayUD.position:=Mindelay;
    MaxDelayUD.position:=Maxdelay;
    with UseStimulusGrp do
    if audible then
      if visual then itemindex:=2
      else itemindex:=1
    else itemindex:=0;
    if active then  activate1.caption:='Click to remove from user''s list'
    else activate1.caption:='Click to add to user''s list';
    if Audible then pagecontrol1.activepage:=Soundsheet
    else pagecontrol1.activepage:=VisualSheet;
    soundgrp.itemindex:=Soundindex;
    PosCBox.checked:=FixedTargetPosition;
    TColorPnl.color:=targetcolor;
    BColorPnl.color:=backgroundColor;
    XMinUD.position:=XMinSize;
    XMaxUD.position:=XMaxSize;
    YMinUD.position:=YMinSize;
    YMaxUD.position:=YMaxSize;
    If targetshape=stSquare then
    begin
      Shapegrp.itemindex:=3;
      Panel1.visible:=true;
      GetImageFiles(dir);
    end
    else
    begin
      shapegrp.itemindex:= ord(targetshape) div 2;
      Panel1.visible:=false;
    end;
  end;
  modified:=false;
end;

{************* Activate1Click ***********8}
procedure TForm2.Activate1Click(Sender: TObject);
begin
  with trialsbox do
  with TTrialdefobj(items.objects[itemindex]) do
  begin
    active:=not active;
    Activebox.checked:=active;
    if active then  activate1.caption:='Click to remove from user''ss list'
    else activate1.caption:='Click to add to user''s list';
  end;
end;

{************** DetailnameEdtClick ************}
procedure TForm2.DetailNameEdtClick(Sender: TObject);
begin
  with DetailDialog do
  begin
    filename:=Detailnameedt.text;
    If execute then DetailnameEdt.text:=FileName;
  end
end;

{******* SumrynameEdtClick ********}
procedure TForm2.SumryNameEdtClick(Sender: TObject);
begin
  with SumryDialog do
  begin
    filename:=Sumrynameedt.text;
    If execute then SumrynameEdt.text:=FileName;
  end
end;

{*********** OKBtnClick **************}
procedure TForm2.OKBtnClick(Sender: TObject);
begin
  groupbox1exit(sender);
  close;   {force ini file update, and hides the form}
end;

{************* CaseChanged **************8}
procedure TForm2.Casechanged(Sender: TObject);
{Called when user changes any case definition field to indicate that it needs
 to be updated before exiting or moving on to another case}
begin
  modified:=true;
end;

{************ EarlyUDChangeEx ******************}
procedure TForm2.EarlyUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  Allowchange:=true;
  EarlyClickTime:=NewValue/1000;
end;

{************* LateUDChangeEx **************}
procedure TForm2.LateUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
   Allowchange:=true;
  LateClickTime:=NewValue/1000;
end;

{************ ShapegrpClick **************}
procedure TForm2.ShapeGrpClick(Sender: TObject);
begin
  With Shapegrp do
  begin
    if itemindex =3 then
    begin  {JPEG Image List}
      groupbox2.visible:=false;
      Panel1.Visible:=true;
      Panel1.bringtofront;
      {fill list here?}
      If items.count>0 then
      begin  {preselect the files}
        {Get directory of program}
        dir:=extractfilepath(application.ExeName);
        {Load list with all jpg files}
        GetImageFiles(dir);
      end;
    end
    else
    begin
      groupbox2.visible:=true;
      Panel1.visible:=false;
    end;
  end;
  casechanged(sender);
end;

procedure TForm2.GetImageFiles(startpath:string);
{recursively read all file names from directory S and add them to FileList}
{this is a version tailored for performance by only saving a requested number of
 largest files found}
var
  F:TSearchrec;
  i,j,r:integer;
  t:TTrialDefObj;
begin
  with trialsbox do t:=TTrialdefobj(items.objects[itemindex]);
  FileCheckListBox.items.clear;
  r:= FindFirst(startpath+'*.jpg', FaAnyFile, F);
  while (r=0) do
  begin
    If (length(f.name)>0)
    and (F.name[1]<>'.') and ((F.Attr and FAVolumeId)=0){not a volume id record}
        and ((F.Attr and FADirectory) =0)
    then filechecklistbox.items.add(f.Name);
    r:=Findnext(F);
  end;
  FindClose(f);
  {Check the boxes for filechecklistbox items which are already in the
  trialdefobj imagelist.  Check boxes in reverse order and move to top of
  list as found so that the order of images in omage is preserved}
  if not assigned(t.Imagelist) then t.Imagelist:=TStringlist.create;
  With t.Imagelist do
  for i:= count-1 downto 0 do
  begin
    with FileCheckListBox do
    begin
      for j:=0 to items.count-1 do
      if strings[i]=items[j] then
      begin
        checked[j]:=true;
        items.move(j,0);
        break;
      end;
    end;
  end;
end;

end.
