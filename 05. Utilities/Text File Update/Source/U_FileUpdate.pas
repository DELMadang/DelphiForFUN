unit U_FileUpdate;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A text file Match-merge update program presented as-is and without warranty of
  any kind. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ShellAPI, UTSyncMemo;


type

  TForm1 = class(TForm)
    UpdateBtn: TButton;
    OpenDialog1: TOpenDialog;
    M_and_U_Grp: TRadioGroup;
    Memo1: TMemo;
    DupMasterGrp: TRadioGroup;
    DupUpdateGrp: TRadioGroup;
    MatchingGrp: TRadioGroup;
    SaveDialog1: TSaveDialog;
    U_NotMGrp: TRadioGroup;
    Memo3: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo2: TMemo;
    StatusBar2: TStatusBar;
    StaticText1: TStaticText;
    SelmasterBtn: TButton;
    SelUpdateBtn: TButton;
    SumryLbl: TLabel;
    OpenDialog2: TOpenDialog;
    USumryLbl: TLabel;
    NoCase: TCheckBox;
    Trimbox: TCheckBox;
    Label5: TLabel;
    procedure UpdateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DupMasterGrpClick(Sender: TObject);
    procedure DupUpdateGrpClick(Sender: TObject);
    procedure SelmasterBtnClick(Sender: TObject);
    procedure SelUpdateBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure NoCaseClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    master,update:string; {file names}
    mastercount1, updatecount1:integer; {initial file counts}
    mastercount2:integer; {final master file count}
    deletedcount, deletedtranscount,addedcount, ignoredcount, mdupsdeletedcount:integer;
    smemo3:TSyncMemo;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var nocasecheck:boolean;  {for use in compare routine, compare cannot be a method of form1
                      because it is also called by TStringlist's Customsort and must
                      be a normal function, not a method.}



procedure TForm1.FormCreate(Sender: TObject);
begin
  smemo3:=TSyncmemo.create(self);
  Smemo3.assignmemo(memo3);
  Smemo3.SetSynch(memo1); Smemo3.SetSynch(memo2);
  memo3.free;
  opendialog1.initialdir:=extractfilepath(application.exename);
  master:=''; update:='';
  nocasecheck:=nocase.checked;
end;

function compare(const s1,s2:string):integer;
begin
  if nocasecheck then result:= ANSIComparetext(s1,s2)
  else result:=ANSICompareStr(s1,s2);
end;

function ListCompare(list:TStringlist; I1, i2:integer):integer;
begin
  result:=compare(list[i1],list[i2]);
end;



{*************** UpDateBtnClick ************}
procedure TForm1.UpdateBtnClick(Sender: TObject);
var
  Mlist,UList:TStringlist;
  eofrec,blankrec:string;
  i, Mi,Ui:integer;
  s1,s2,s3,s4,s5:STRING;

begin
  eofrec:=stringofchar(char('Z'),64);
  blankrec:=' ';
  memo1.clear;
  memo2.clear;
  smemo3.clear;
  if master='' then Selmasterbtnclick(sender);
  if update='' then SelUpdatebtnclick(sender);
  if fileexists(master) and fileexists(update) then
  begin
    deletedcount:=0;
    deletedtranscount:=0;
    addedcount:=0;
    ignoredcount:=0;
    mdupsdeletedcount:=0;
    {load and sort master file}
    Mlist:=TStringList.create;
    Mlist.loadfromfile(master);
    mastercount1:=mlist.count;
    Mlist.add(eofrec);
    Mlist.Customsort(Listcompare);
    {load and sort update file}
    UList:=TStringList.create;
    UList.loadfromfile(update);
    updatecount1:=Ulist.count;
    Ulist.add(eofrec);
    Ulist.CustomSort(ListCompare);
    Mi:=0;   Ui:=0;     {initialize index pointers}
    if trimbox.checked then
    begin
      for i:=0 to mlist.count-1 do mlist[i]:=trim(mlist[i]);
      for i:=0 to ulist.count-1 do ulist[i]:=trim(ulist[i]);
    end;
    if (M_and_U_Grp.itemindex=0) and  (U_NotMgrp.itemindex=0)
    then i:=messagedlg('You have selected to both add and delete Master records based on Update transactions'
           +#13+'Do you really want to do this?',mtconfirmation,[mbyes,mbno],0)
     else i:=mryes;

    {processing loop}
    if i=mryes then
    begin

      while (Mlist[Mi]<>eofrec) and (Ulist[Ui]<>eofrec) do
      begin
        {check and deleted duplicate master rec if requested}
        if (mi>0) and (dupmasterGrp.itemindex=1) and (Compare(mlist[mi],mlist[mi-1])=0) then
        repeat
          memo1.Lines.add('*'+mlist[mi]);
          memo2.lines.add(blankrec);
          smemo3.lines.add('Duplicate Master rec deleted');
          inc(mdupsdeletedcount);
          mlist.delete(mi);
        until (Compare(mlist[mi],mlist[mi-1])<>0) or (mlist[mi]=eofrec);
        {check and delete duplicate Update recs is requested}
        if (ui>0) and (dupUpdateGrp.itemindex=1) and (Compare(ulist[ui],ulist[ui-1])=0) then
        repeat
          memo1.Lines.add(blankrec);
          memo2.lines.add('*'+ulist[ui]);
          smemo3.lines.add('Duplicate Update rec ignored');
          ulist.delete(ui);
          inc(ignoredcount);
        until (Compare(ulist[ui],ulist[ui-1])<>0) or (ulist[ui]=eofrec);
        {Master rec is low}
        if Compare(MList[mi],UList[Ui])<0 then
        begin  {In master and not in update}
          memo1.Lines.add(mlist[mi]);
          memo2.lines.add(blankrec);
          smemo3.lines.add('No action');
          Inc(Mi);
        end
        else
        {Master rec is high}
        if Compare(UList[Ui],MList[Mi])<0 then
        begin  {In update and not in master}
          if U_NotMGrp.itemindex=0 then
          begin
            memo1.Lines.add(ulist[ui]);
            memo2.lines.add(ulist[Ui]);
            sMemo3.lines.add('Added ');
            inc(addedcount);
            mlist.insert(mi,ulist[ui]);
            inc(mi);
          end
          else
          begin
            memo1.Lines.add(blankrec);
            memo2.lines.add(ulist[Ui]);
            sMemo3.lines.add('No action');
            inc(ignoredcount);
          end;
          inc(UI);
        end
        else
        {Match!}
        Begin
          if Compare(mlist[Mi],eofrec)<>0 then {not both at eof}
          begin  {not EOF}
            if M_AND_U_Grp.itemindex=0 then {Delete matches}
            begin
              memo1.Lines.add('* '+mlist[mi]);
              memo2.lines.add(ulist[Ui]);
              smemo3.lines.add('Deleted');
              MList.delete(mi);
              inc(deletedcount); {count a deleted master rec}
              if matchinggrp.itemindex=0 then
              begin
                inc(ui); {one transaction can only delete one master}
                inc(deletedtranscount);
              end
              else {one update rec should delete all matching recs}
                if Compare(mlist[mi],ulist[ui])<>0 then
                begin
                  inc(ui);{no more matches, inc ulist}
                  inc(deletedtranscount); {and count the trsaction as a delete}
                end;
            end
            else
            begin
              memo1.Lines.add(mlist[mi]);
              memo2.lines.add(ulist[Ui]);
              smemo3.lines.add('No action');
              inc(Ignoredcount);
              inc(mi);
            end;
          end
          else break;
        end;
      end;

      memo1.selstart:=0;  {force displays to move back to top}
      memo1.sellength:=1;
      memo2.selstart:=0;
      memo2.sellength:=1;
      smemo3.selstart:=0;
      smemo3.sellength:=1;

      {Display summary labels}
      mastercount2:=mlist.count-1;  {don't count the eof rec we added}
      s1:='Master start count: '+inttostr(mastercount1)+#13;
      if addedcount>0 then s2:='Added: '+inttostr(addedcount)+#13 else s2:='';
      If deletedcount>0 then s3:='Deleted by transaction: '
                + inttostr(deletedcount)+#13 else s3:='';
      If mDupsdeletedcount>0 then s4:='Duplicates deleted by option: '
                + inttostr(mDupsdeletedcount)+#13 else s4:='';
      s5:='Master Final Count: '+inttostr(mastercount2);
      SumryLbl.caption:=s1+s2+s3+s4+s5;
      s1:='Update file count: '+inttostr(updatecount1)+#13;
      if addedcount>0 then s2:='Added by transaction: '+inttostr(addedcount)+#13 else s2:='';
      If deletedtranscount>0 then s3:='Delete transactions: '
                + inttostr(deletedtranscount)+#13 else s3:='';
      s5:='Ignored: '+inttostr(Ignoredcount);
      UsumryLbl.caption := s1+s2+s3+s5;

      {get Save file name}
      savedialog1.initialdir:=extractfilepath(opendialog1.filename);
      if savedialog1.execute then
      begin
        with mlist do
        if  mlist[count-1]=eofrec then
        begin
          delete(count-1);
          savetofile(savedialog1.filename);
        end
        else showmessage('System error, EOF record out of place, file not saved');
      end;
    end;
    Mlist.free;
    Ulist.free;
  end;
end;


{********** DupMasterGrpCLick **********}
procedure TForm1.DupMasterGrpClick(Sender: TObject);
begin
  if DupmasterGrp.itemindex=1 then {duplicate master records will be deleted}
  begin
    DupUpdateGrp.visible:=false; {so might as well ignore duplicate updates}
    DupUpdateGrp.ItemIndex:=1;
    Matchinggrp.itemindex:=0;  {and one update rec willupdate at most one master rec}
    Matchinggrp.visible:=false;
  end
  else
  begin    {otherwise master roecirds are being retained}
     DupUpdateGrp.visible:=true;  {so can select what to do with dupicate updates}
     Matchinggrp.visible:=true;   {and may be able to select 1-1 or 1-many processing}
   end;
end;

{************ DupUpdateGrpClick **********}
procedure TForm1.DupUpdateGrpClick(Sender: TObject);
begin
  {if master records are being retained and duplicate update records are
   being deleted then matching can be 1-1 or 1-many}
   if DupUpdateGrp.itemindex=1 then MatchingGrp.visible:=true
   else
   begin
     Matchinggrp.itemindex:=0;
     Matchinggrp.visible:=false;
   end;
end;

{************** SelmasaterBtnClick *********}
procedure TForm1.SelmasterBtnClick(Sender: TObject);
begin
  opendialog1.title:='Enter Master file name';
  if opendialog1.execute then master:=opendialog1.filename else master:='';
  statusbar2.panels[0].text:='Master file: '+extractfilename(master);
end;

{************* SelUpdateBtnClick ************}
procedure TForm1.SelUpdateBtnClick(Sender: TObject);
begin
  opendialog2.title:='Enter Update file name';
  if opendialog2.execute then update:=opendialog2.filename else update:='';
  statusbar2.panels[1].text:='Update file: '+extractfilename(update);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.NoCaseClick(Sender: TObject);
begin
  nocasecheck:=nocase.checked;
end;

end.
