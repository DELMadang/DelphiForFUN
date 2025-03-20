unit U_Demo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, mSpeech, ExtCtrls;

type
  TfrmMain = class(TForm)
    GroupBox1: TGroupBox;
    lbEngines: TListBox;
    GroupBox2: TGroupBox;
    TextPad: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    GroupBox3: TGroupBox;
    PitchBar: TTrackBar;
    PitchMax: TLabel;
    SpeedBar: TTrackBar;
    VolumeBar: TTrackBar;
    PitchMin: TLabel;
    Label2: TLabel;
    SpeedMax: TLabel;
    SpeedMin: TLabel;
    VolumeMin: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    
    Button3: TButton;
    Button4: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PitchBarExit(Sender: TObject);
    procedure SpeedBarExit(Sender: TObject);
    procedure VolumeBarExit(Sender: TObject);
    procedure SpeechStart(Sender: TObject);
    procedure SpeechStop(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Speech: TMSpeech;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

procedure TfrmMain.FormShow(Sender: TObject);
begin
   If assigned(speech.engines) then lbEngines.Items.Assign(Speech.Engines);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
   Speech.Text.Assign(TextPad.Lines);
   Speech.Speak;
   Button3.Enabled := True;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
var I: Integer;
begin
   if lbEngines.SelCount = 0 then Exit;

   for I := 0 to lbEngines.Items.Count - 1 do
   begin
      if lbEngines.Selected[I] then
      begin
         Speech.SelectEngine(lbEngines.Items[I]);

         GroupBox3.Enabled := True;
         Button2.Enabled := True;

         Break;
      end;
   end;

   PitchBar.Max := Speech.Info.MaxPitch;
   PitchBar.Min := Speech.Info.MinPitch;
   PitchBar.Position := Speech.Pitch;
   PitchMax.Caption := IntToStr(Speech.Info.MaxPitch);
   PitchMin.Caption := IntToStr(Speech.Info.MinPitch);

   SpeedBar.Max := Speech.Info.MaxSpeed;
   SpeedBar.Min := Speech.Info.MinSpeed;
   SpeedBar.Position := Speech.Speed;
   SpeedMax.Caption := IntToStr(Speech.Info.MaxSpeed);
   SpeedMin.Caption := IntToStr(Speech.Info.MinSpeed);

   VolumeBar.Position := Speech.Volume;
   VolumeBar.Max := Speech.Info.MaxVolume;
   VolumeBar.Min := Speech.Info.MinVolume;

   PitchBar.Hint := IntToStr(PitchBar.Position);
   SpeedBar.Hint := IntToStr(SpeedBar.Position);
   VolumeBar.Hint := IntToStr(VolumeBar.Position);
end;

procedure TfrmMain.PitchBarExit(Sender: TObject);
begin
   PitchBar.Hint := IntToStr(PitchBar.Position);
   Speech.Pitch := PitchBar.Position;
end;

procedure TfrmMain.SpeedBarExit(Sender: TObject);
begin
   SpeedBar.Hint := IntToStr(SpeedBar.Position);
   Speech.Pitch := SpeedBar.Position;
end;

procedure TfrmMain.VolumeBarExit(Sender: TObject);
begin
   VolumeBar.Hint := IntToStr(VolumeBar.Position);
   Speech.Pitch := VolumeBar.Position;
end;

procedure TfrmMain.SpeechStart(Sender: TObject);
begin
   Caption := 'Text-to-Speech (Speaking)';
   Button3.Caption := '&Pause';
   Button4.Enabled := True;
end;

procedure TfrmMain.SpeechStop(Sender: TObject);
begin
   Caption := 'Text-to-Speech';
   Button4.Enabled := False;
   if Speech.Paused then
      Button3.Caption := '&Resume'
   else
      Button3.Enabled := False;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
   if Speech.Paused then
      Speech.Resume
   else
      Speech.Pause;
end;

procedure TfrmMain.Button4Click(Sender: TObject);
begin
   Speech.Stop;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Speech:=TMSpeech.create(self);

end;

end.
