unit U_Simon;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Original code by Shane A. Holmes.  Modified by Gary Darby with permission }

{Delphi version of the classic memory game, Simon}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, TypInfo, ComCtrls, shellAPI;

type
  TfrmMain = class(TForm)
    lblCount: TLabel;
    lblCount2: TLabel;
    btnStart: TButton;
    pnlLights: TPanel;
    shpRedLight: TShape;
    shpPurpleLight: TShape;
    shpGreenLight: TShape;
    shpBlueLight: TShape;
    cbxSound: TCheckBox;
    cbxLights: TComboBox;
    lbxScores: TListBox;
    Label2: TLabel;
    btnClear: TButton;
    Speedbar: TTrackBar;
    Label1: TLabel;
    Label3: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure btnStartClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure shpMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbxLightsChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
    procedure SpeedbarChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LightOn(Light: Integer);
    procedure LightsOn;
  end;

var
  frmMain: TfrmMain;

implementation

uses Math, U_Common, Bleeper;

var
 CurIdx, Delay: Integer;
 isActive: Boolean;

{$R *.dfm}

{************* LightsOn ***********}
procedure TfrmMain.LightsOn;
var  I: Integer;
begin
 for I:= 0 to Lights.Count-1 do
  LightOn(TIntObj(Lights[I]).Value);
end;

var scalesteps:array[1..4] of integer= (0,4,7,12);
{************** LightOn ************}
procedure TfrmMain.LightOn(Light: Integer);

    procedure DoSound;

    Begin
      Application.ProcessMessages;
      Sleep(Delay);
      if cbxSound.Checked then
      begin
        {if WinOpSys in [osWinNT, osWin2K, osWinXP] then}
        {Windows.Beep(100*(light+1),delay)}
        Beepex(trunc(200*power(2,scalesteps[light]/12)),delay);
      end;
    end;

begin
 IsActive :=false;
 case Light of
  1: begin
      shpRedLight.Pen.Color:= clYellow;
      shpRedLight.Brush.Color:= clRed;
      DoSound;
      shpRedLight.Brush.Color:= clMaroon;
      shpRedLight.Pen.Color:= clBlack;
     end;
  2:begin
      shpPurpleLight.Pen.Color:= clYellow;
      shpPurpleLight.Brush.Color:= clFuchsia;
      DoSound;
      shpPurpleLight.Brush.Color:= clPurple;
      shpPurpleLight.Pen.Color:= clBlack;
     end;
  3: begin
      shpGreenLight.Pen.Color:= clYellow;
      shpGreenLight.Brush.Color:= clLime;
      DoSound;
      shpGreenLight.Brush.Color:= clGreen;
      shpGreenLight.Pen.Color:= clBlack;
     end;
  4: begin
      shpBlueLight.Pen.Color:= clYellow;
      shpBlueLight.Brush.Color:= clBlue;
      DoSound;
      shpBlueLight.Brush.Color:= clNavy;
      shpBlueLight.Pen.Color:= clBlack;
     end;
 end;
 Application.ProcessMessages;
 Sleep(Delay);
 isactive:=true; {flag to say it is the user's turn}
end;

{************* btnStartClkick ************}
procedure TfrmMain.btnStartClick(Sender: TObject);
{Start a neww game}
var  IntObj: TIntObj;
begin
 btnStart.Enabled:= False;
 Sleep(Delay);
 IntObj:= TIntObj.Create(Random(4) + 1);
 Lights.Add(IntObj);
 LightsOn;
 CurIdx:= 0;
end;

{************** FormActivate ************}
procedure TfrmMain.FormActivate(Sender: TObject);
begin
 if FileExists(ExtractFilePath(Application.ExeName) + 'Scores.dat') then
  Scores.LoadScoresFromFile(ExtractFilePath(Application.ExeName)+ 'Scores.dat');
 Scores.GetScores(lbxScores.Items);
 Randomize;
 lblCount2.Caption:= IntToStr(Lights.Count);
 Delay:= Speedbar.position;
end;

{***************** shpMouseDown ************}
procedure TfrmMain.shpMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{Count this as a user click on a light}
var
 IntObj: TIntObj;
 Score: TScore;
 NameStr: String;
begin
 if (isActive) AND (Lights.Count >= 1) AND (CurIdx <> Lights.Count) then
 begin
  LightOn(TShape(Sender).tag);
  if TShape(Sender).tag = TIntObj(Lights[CurIdx]).Value then
  begin {correct light was clicked}
   Inc(CurIdx);
   if CurIdx = Lights.Count then
   begin  {player got that sequence right, add one more light and display again}
    IntObj:= TIntObj.Create(Random(4) + 1);
    Lights.Add(IntObj);
    lblCount2.Caption:= IntToStr(Lights.Count-1);
    sleep(750);  {delay a bit before next set of lights starts}
    LightsOn;
    CurIdx:= 0;
   end;
  end
  else
  begin {loser!}
   isActive:= False;
   ShowMessage('You''ve Lost!' +#10 +
               'Count = ' + Inttostr(Lights.Count-1));
   if Scores.isHighScore(Lights.Count-1) then
   begin {give credit for high score in the top 5 highest}
    NameStr:= InputBox('High Score', 'Enter Name :', 'Unknown');
    Score:= TScore.Create(NameStr,Lights.Count-1);
    Scores.AddScore(Score);
    Scores.GetScores(lbxScores.Items);
   end;
   Lights.Clear;
   lblCount2.Caption:= IntToStr(Lights.Count);
   btnStart.Enabled:= True;
  end;
 end;
end;

{************** cbxLightsChange ***************}
procedure TfrmMain.cbxLightsChange(Sender: TObject);
{User picked a new light shape}
 var  I: Integer;
begin
 for I:= 0 to PnlLights.ControlCount - 1 do
 begin
  if pnlLights.Controls[I] is TShape then
   TShape(pnlLights.Controls[I]).Shape:=
   TShapeType( GetEnumValue( TypeInfo( TShapeType),  'st' + cbxLights.Items[cbxLights.ItemIndex]));
 end;
end;

{************** FormClose ***************}
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Scores.SaveScoresToFile(ExtractFilePath(Application.ExeName)+ 'Scores.dat');
end;

{*************** btnClearClick *************}
procedure TfrmMain.btnClearClick(Sender: TObject);
begin
 if MessageDlg('Clear High Scores?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
 begin
  Scores.Clear;
  Scores.GetScores(lbxScores.Items);
 end;
end;

{************** SpeedBarChange ***********}
procedure TfrmMain.SpeedbarChange(Sender: TObject);
begin
  Delay:=Speedbar.position
end;

{************** StaticText1Click ***********}
procedure TfrmMain.StaticText1Click(Sender: TObject);
{tell default browser to display DelphiForFun home page}
begin
     ShellExecute(Handle, 'open', 'http://delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
