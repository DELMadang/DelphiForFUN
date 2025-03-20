unit U_DFFSpinEditDemo;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls,  ComCtrls,  UDFFSpinEdit, Commctrl, ShellAPI;

type

  TForm1 = class(TForm)
    Edit1: TEdit;
    UpDown1: TUpDown;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MinValEdt: TEdit;
    Label4: TLabel;
    MaxValEdt: TEdit;
    Label5: TLabel;
    MinvalBtn: TButton;
    MaxvalBtn: TButton;
    Min1Lbl: TLabel;
    Max1Lbl: TLabel;
    Max2Lbl: TLabel;
    Min2Lbl: TLabel;
    Max3Lbl: TLabel;
    Min3Lbl: TLabel;
    {$IFNDEF VER180} {if not Turbo Delphi Explorer}
    SpinEdit1: TSpinEdit;
    {$ENDIF}
    Val1Lbl: TLabel;
    Val2Lbl: TLabel;
    Val3Lbl: TLabel;
    StaticText1: TStaticText;
    FixSpinEdit: TCheckBox;
    FixUpDown: TCheckBox;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure MinvalBtnClick(Sender: TObject);
    procedure MaxvalBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FixSpinEditClick(Sender: TObject);
    procedure FixUpDownClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure Edit3Change(Sender: TObject);
  public
    MySpinEdit1:TDFFSpinEdit;
    procedure Initialize;
    procedure UpdateMinmaxLabels;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*********** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit3.font.size:=14;
  MySpinedit1:=TDFFSpinEdit.create(Edit3,0,0,100);
  Initialize;
end;

{*************** Initialize ***************}
procedure TForm1.Initialize;
begin

{$IFNDEF VER180}
  {For TSpinEdit, if spinedit maxvalue left at default 0, no value can ever be assigned by the program}
  spinedit1.maxvalue:= 100;  {a fix}
  spinedit1.value:=10;
{$ENDIF}

  {set min and max values for the 3 spinedits to the values that are in
   MinValEdt and MaxvalEdt}
  maxvalBtnClick(MaxValEdt); {set max fiirst}
  minvalBtnClick(Minvaledt);

end;

{************* MinValBtnClick ************}
procedure TForm1.MinvalBtnClick(Sender: TObject);
var
  s:string;
  n:integer;
  errcode:integer;
begin
  s:=MinValEdt.text;
  val(s,n,errcode);
  if errcode=0 then
  begin
   {$IFNDEF VER180}
    with spinedit1 do
    if (n<=maxvalue) then
    begin
      minvalue:=n;
      {fixup}
      If fixspinedit.checked and (value<minvalue) then value:=minvalue;
    end;
   {$ENDIF}

    with updown1 do
    if (n<=max) then
    begin
      min:=n;
      {fixup}
      if FixUpDown.checked
      then with updown1 do
        SendMessage(Handle, UDM_SETPos, 0, MakeLong(Position,0)); {a fix}
    end;

    with myspinedit1 do if (n<maxvalue) then minvalue:=n;

    UpdateMinmaxlabels;
  end;
end;



{************** MaxValBtnClick ************}
procedure TForm1.MaxvalBtnClick(Sender: TObject);
var
  s:string;
  n:integer;
  errcode:integer;
begin
  s:=MaxValEdt.text;
  val(s,n,errcode);
  if errcode=0 then
  begin
  {$IFNDEF VER180}
    with spinedit1 do if (n>=minvalue) then
    begin
      maxvalue:=n;
      If fixspinedit.checked and (value > maxvalue) then value:=maxvalue;
    end;
  {$ENDIF}

    with updown1 do if n>=min then max:=n;
    with myspinedit1 do if n>=minvalue then maxvalue:=n;

    UpdateMinmaxLabels;
  end;
end;

{*************** UpdateMinMaxlabels *************}
Procedure TForm1.UpdateMinMaxLabels;
begin
  {$IFNDEF VER180}
  min1lbl.caption:='Min='+inttostr(spinedit1.minvalue);
  val1lbl.caption:='Val='+inttostr(spinedit1.value);
  max1lbl.caption:='Max='+inttostr(spinedit1.maxvalue);
  {$ENDIF}

  min2lbl.caption:='Min='+inttostr(UpDown1.min);
  val2lbl.caption:='Val='+inttostr(UpDown1.position);
  max2lbl.caption:='Max='+inttostr(UpDown1.max);

  min3lbl.caption:='Min='+inttostr(Myspinedit1.minvalue);
  val3lbl.caption:='Val='+inttostr(Myspinedit1.value);
  max3lbl.caption:='Max='+inttostr(Myspinedit1.maxvalue);
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure TForm1.FixSpinEditClick(Sender: TObject);
begin
  {If setting MinValue or MaxValue properties forces Value to be out of range,
   TSpinEdit corrects Value but does not update the associated
   TEdit Control.  Setting the value to the closest range end value will
   force the update}

  {Call routines to recheck the values}
  maxvalBtnclick(sender);
  minvalBtnclick(sender);
end;


procedure TForm1.FixUpDownClick(Sender: TObject);
begin
  {If setting Min or Max properties forces the Position propery to be out of range,
   TUpDown corrects the Position property but does not update the associated
   TEdit Control.  Sending a UDM_SetPos message will force the update}
  {Call the routines to recheck the values}
  minvalBtnClick(sender);
  MaxValBtnClick(sender);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  UpdateMinmaxlabels;
end;

procedure TForm1.UpDown1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  UpdateMinMaxlabels;
  Allowchange:=true;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
  UpdateMinmaxlabels;
end;

end.
