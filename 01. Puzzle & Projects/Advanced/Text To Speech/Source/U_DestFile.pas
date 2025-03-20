unit U_DestFile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  mSpeech, Speech, StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmChoose = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Memo1: TMemo;
    RadioGroup1: TRadioGroup;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    FileLbl: TLabel;

    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Speech: TMSpeech;
    filename:string;
    RealTime: integer;
  end;

var
  frmChoose: TfrmChoose;

implementation


{$R *.DFM}


procedure TfrmChoose.Button2Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmChoose.FormShow(Sender: TObject);
begin
   ComboBox1.Items.Assign(Speech.Engines);
   Combobox1.itemindex:=0;
   RealTime := $0100;
end;

procedure TfrmChoose.FormCreate(Sender: TObject);
begin
  speech:=TMSpeech.create(self);

end;

procedure TfrmChoose.RadioGroup1Click(Sender: TObject);
begin
  Case radioGroup1.itemindex of
    0: RealTime := $0100;
    1: RealTime := $0200;
    2: RealTime := $0400;
    3: RealTime := $0800;
  end;
end;

procedure TfrmChoose.Button3Click(Sender: TObject);
begin
  if savedialog1.execute
  then
  begin
    filename:=savedialog1.filename;
    filelbl.caption:=extractfilename(filename);
  end;  
end;

procedure TfrmChoose.Button4Click(Sender: TObject);
begin
  if filename<>'' then
  begin
   speech.output:=SOFile;
   Speech.SelectEngine(ComboBox1.Text);
   Speech.Filename := extractfilename(filename);
   IAudioFile(Speech.Interfaces[0]).RealTimeSet(RealTime);
  end
  else
  begin
    Speech.SelectEngine(ComboBox1.Text);
    speech.output:=SoGeneral;
  end;  
  Speech.Text.Assign(Memo1.Lines);
  screen.cursor:=crHourGlass;
  Speech.Speak;
  screen.cursor:=crDefault;
end;

end.
