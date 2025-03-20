unit U_SetOptions;
{modify the init file options}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, CheckLst, Spin, ExtCtrls;

type
  TForm2 = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    MaxValEdit: TSpinEdit;
    OpBox: TCheckListBox;
    Label2: TLabel;
    Label3: TLabel;
    ProbSetEdit: TSpinEdit;
    RewardEdit: TSpinEdit;
    Label4: TLabel;
    OkBtn: TBitBtn;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    procedure OkBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}
Uses Inifiles, U_EquationSearch;

procedure TForm2.OkBtnClick(Sender: TObject);
var
  Ini:TInifile;
begin
  ini:=TInifile.create(extractfilepath(application.exename)+'EquSearch.ini');
  with ini,opbox do
  begin
    Writebool('General','UsePlus',checked[0]);
    Writebool('General','UseMinus',checked[1]);
    Writebool('General','UseTimes',checked[2]);
    Writebool('General','UseDivide',checked[3]);
    WriteInteger('General','ProblemsPerSet',ProbSetEdit.value);
    WriteFloat ('General', 'RewardLevel',RewardEdit.value/100);
    WriteInteger('General','MaxVal',MaxValEdit.value);
  end;
  ini.free;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
  Probsetedit.value:=Problemsperset;
  MaxValEdit.value:=maxval;
  RewardEdit.value:=trunc(100*rewardlevel);
  with opbox do
  begin
    items[2]:=Times;
    items[3]:=Divide;
    if '+' in opset then checked[0]:=true;
    if '-' in opset then checked[1]:=true;
    if Times in opset then checked[2]:=true;
    if Divide in opset then checked[3]:=true;
    
  end;

end;

end.
