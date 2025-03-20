unit mSpeech;

{
  Monster Speech 1.1.0
  written by Chen Yu (monster)

  E-Mail: mftp@21cn.com   ICQ UIN: 6740755
  Homepage: http://homepages.msn.com/RedmondAve/mftp/

  Suggestions and bug reports are warm welcomed.

  This file used a Delphi translation of Speech API from
  Project JEDI, and full package of this translation can
  be found on JEDI's web page: http://www.delphi-jedi.org/
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, ActiveX, Speech;

{----$I mspeech.msg}
 Const { resourcestring}
   msgSENotFound   = 'Specified Speech Engine not found';
   msgSENotInited  = 'Speech Engine not initialized';
   msgSENotStarted = 'Speech Engine not selected';

type
   TMSpeechEngineInfo = record
      Name:             String;
      Language:         String;
      Manufacturer:     String;
      Product:          String;
      ModeID:           String;
      EngineID:         String;
      Speaker:          String;
      Style:            String;
      Gender:           String;
      Age:              Integer;
      Features:         Integer;
      Interfaces:       Integer;
      MaxPitch:         Word;
      MinPitch:         Word;
      MaxRealTime:      LongWord;
      MinRealTime:      LongWord;
      MaxSpeed:         LongWord;
      MinSpeed:         LongWord;
      MaxVolume:        LongWord;
      MinVolume:        LongWord;
   end;

   TSpeechDialog = (sdAbout, sdGeneral, sdLexicon, sdTranslate);
   TSpeechOutput = (soFile, soGeneral);
   TMSVisualEvent = procedure(Sender: TObject; Hints: LongWord; Mouth: PTTSMouth) of object;

type
   EMSpeechException = class(Exception);
   TMSpeech = class;

   TTSNotifySink = class(TInterfacedObject, ITTSNotifySink)
   private
      FOwner:                  TMSpeech;
   protected
      function AttribChanged(dwAttribute: DWORD): HResult; stdcall;
      function AudioStart(qTimeStamp: QWORD): HResult; stdcall;
      function AudioStop(qTimeStamp: QWORD): HResult; stdcall;
      function Visual(qTimeStamp: QWORD;
                      cIPAPhoneme: Char;
                      cEnginePhoneme: Char;
                      dwHints: DWORD;
                      apTTSMouth: PTTSMouth): HResult; stdcall;
   public
      constructor Create(AOwner: TMSpeech);
   end;

   TTSBufNotifySink = class(TInterfacedObject, ITTSBufNotifySink)
   private
      FOwner:                  TMSpeech;
   protected
      function TextDataDone(qTimeStamp: QWORD; dwFlags: DWORD): HResult; stdcall;
      function TextDataStarted(qTimeStamp: QWORD): HResult; stdcall;
      function BookMark(qTimeStamp: QWORD; dwMarkNum: DWORD): HResult; stdcall;
      function WordPosition(qTimeStamp: QWORD; dwByteOffset: DWORD): HResult; stdcall;
   public
      constructor Create(AOwner: TMSpeech);
   end;

   TMSpeech = class(TComponent)
   private
      FEngines:                TStrings;
      FEngineStarted:          Boolean;
      FFile:                   WideString;
      FIAF:                    IAudioFile;
      FIAMD:                   IAudioMultimediaDevice;
      FInfo:                   TMSpeechEngineInfo;
      FInit:                   Boolean;
      FITTSAttributes:         ITTSAttributes;
      FITTSCentral:            ITTSCentral;
      FITTSDialogs:            ITTSDialogs;
      FITTSEnum:               ITTSEnum;
      FKey:                    LongWord;
      FOutput:                 TSpeechOutput;
      FPaused:                 Boolean;
      FText:                   TStrings;
      FTTSNotifySink:          ITTSNotifySink;
      FTTSBufNotifySink:       ITTSBufNotifySink;
      FVersion, DummyS:        String;
      PModeInfo:               PTTSModeInfo;

      function GetInterface(Index: Integer): IUnknown;
      function GetPitch: Word;
      function GetRealTime: LongWord;
      function GetSpeed: LongWord;
      function GetVolume: LongWord;
      procedure SetText(const Value: TStrings);
      procedure SetPitch(const Value: Word);
      procedure SetRealTime(const Value: LongWord);
      procedure SetSpeed(const Value: LongWord);
      procedure SetVolume(const Value: LongWord);

      procedure BeforeSelectEngine;
      procedure Init;
      procedure InitAudio;
      procedure PostSelectEngine;
      procedure PostSelectEngine2(ModeInfo: TTSModeInfo);

      function GetAudioDevice: IUnknown;
   protected
      FOnStart, FOnStop:       TNotifyEvent;
      FOnVisual:               TMSVisualEvent;
      FPos:                    LongWord;

      procedure FlushFile;
   public
      constructor Create(AOwner: TComponent); {override;}
      destructor Destroy; override;
      procedure Inject(Command: String);
      procedure Pause;
      procedure Resume;
      procedure SelectEngine(EngineName: String); overload;
      procedure SelectEngine(EngineMode: TTSModeInfo); overload;
      procedure Show(DialogType: TSpeechDialog; ParentWnd: HWND = 0);
      procedure Speak;
      procedure Stop;

      function GetEngineInfo(EngineName: String; var Info: TMSpeechEngineInfo): Boolean;

      property Engines: TStrings read FEngines;
      property Info: TMSpeechEngineInfo read FInfo;
      property Interfaces[Index: Integer]: IUnknown read GetInterface;
      property Paused: Boolean read FPaused;
      property Pitch: Word read GetPitch write SetPitch;
      property Position: LongWord read FPos;
      property RealTime: LongWord read GetRealTime write SetRealTime;
      property Speed: LongWord read GetSpeed write SetSpeed;
      property Volume: LongWord read GetVolume write SetVolume;
   published
      property Filename: WideString read FFile write FFile;
      property Output: TSpeechOutput read FOutput write FOutput;
      property Text: TStrings read FText write SetText;
      property Version: String read FVersion write DummyS;

      property OnStart: TNotifyEvent read FOnStart write FOnStart;
      property OnStop: TNotifyEvent read FOnStop write FOnStop;
      property OnVisual: TMSVisualEvent read FOnVisual write FOnVisual;
   end;

implementation

{ TMSpeech: implementation of DirectTextToSpeech}

{ construction/deconstruction }

constructor TMSpeech.Create(AOwner: TComponent);
begin
   {inherited;}

   FEngines := TStringList.Create;
   FText := TStringList.Create;

   FKey := 0;
   FPos := 0;
   FOutput := soGeneral;
   FPaused := False;
   FVersion := 'Monster Speech 1.1.0';

   Init;
end;

destructor TMSpeech.Destroy;
begin
   FInit := False;
   FEngines.Free;
   FText.Free;

   if Assigned(PModeInfo) then Dispose(PModeInfo);

   inherited;
end;

{ Methods }

procedure TMSpeech.Init;
var ModeInfo: TTSModeInfo;
    EngineCount: Integer;
begin
   FInit := True;
   FEngineStarted := False;
   try
      { Enumerate engines }
      OleCheck(CoCreateInstance(CLSID_TTSEnumerator, Nil, CLSCTX_ALL, IID_ITTSEnum, FITTSEnum));
      OleCheck(FITTSEnum.Reset);
      OleCheck(FITTSEnum.Next(1, ModeInfo, @EngineCount));

      while EngineCount > 0 do
      begin
         FEngines.Add(String(ModeInfo.szModeName));
         OleCheck(FITTSEnum.Next(1, ModeInfo, @EngineCount));
      end;
   except
      FInit := False;
   end;
end;

procedure TMSpeech.InitAudio;
begin
   case Output of
      soFile:
         OleCheck(CoCreateInstance(CLSID_AudioDestFile, nil, CLSCTX_ALL,
                  IID_IAudioFile, FIAF));
      soGeneral:
         OleCheck(CoCreateInstance(CLSID_MMAudioDest, nil, CLSCTX_ALL,
                  IID_IAudioMultiMediaDevice, FIAMD));
   end;
end;

function TMSpeech.GetAudioDevice;
begin
   case Output of
      soFile:
         Result := FIAF;
      soGeneral:
         Result := FIAMD;
   end;
end;

procedure TMSpeech.FlushFile;
begin
   if FOutput = soFile then FIAF.Flush; // close file
end;

procedure TMSpeech.Inject;
begin
   FITTSCentral.Inject(PChar(Command));
end;

procedure TMSpeech.BeforeSelectEngine;
begin
   { Check if audio device is available }
   InitAudio;

   { Unregister old notify interface }
   if FKey > 0 then
   begin
      FITTSCentral.UnRegister(FKey);
      FKey := 0;
   end;

   { Create notify interfaces }
   FTTSBufNotifySink := TTSBufNotifySink.Create(Self);
   FTTSNotifySink := TTSNotifySink.Create(Self);
end;

procedure TMSpeech.SelectEngine(EngineName: String);
var Index, EngineCount: Integer;
    ModeInfo: TTSModeInfo;
begin
   if not FInit then
      raise EMSpeechException.Create(msgSENotInited);

   Index := Engines.IndexOf(EngineName);
   if Index < 0 then
      raise EMSpeechException.Create(msgSENotFound);

   { Select Engine }
   FEngineStarted := True;
   try
      BeforeSelectEngine;
      OleCheck(FITTSEnum.Reset);
      OleCheck(FITTSEnum.Skip(Index));
      OleCheck(FITTSEnum.Next(1, ModeInfo, @EngineCount));

      if Assigned(PModeInfo) then Dispose(PModeInfo);
      New(PModeInfo);
      PModeInfo^ := ModeInfo;

      OleCheck(FITTSEnum.Select(PModeInfo^.gModeID,
               FITTSCentral, GetAudioDevice));

      PostSelectEngine;
      PostSelectEngine2(ModeInfo);
   except
      FEngineStarted := False;
   end;
end;

procedure TMSpeech.SelectEngine(EngineMode: TTSModeInfo);
var FITTSFind: ITTSFind;
    ModeInfo: TTSModeInfo;
begin
   if not FInit then
      raise EMSpeechException.Create(msgSENotInited);

   { Find and Select Engine }
   FEngineStarted := True;
   try
      try
         BeforeSelectEngine;
         OleCheck(CoCreateInstance(CLSID_TTSEnumerator, nil, CLSCTX_ALL,
                  IID_ITTSFind, FITTSFind));
         OleCheck(FITTSFind.QueryInterface(IID_ITTSEnum, FITTSEnum));
         OleCheck(FITTSFind.Find(EngineMode, nil, ModeInfo));

         if Assigned(PModeInfo) then Dispose(PModeInfo);
         New(PModeInfo);
         PModeInfo^ := ModeInfo;

         OleCheck(FITTSFind.Select(PModeInfo^.gModeID,
                  FITTSCentral, GetAudioDevice));

         PostSelectEngine;
         PostSelectEngine2(ModeInfo);
      except
         FEngineStarted := False;
      end;
   finally
      FITTSFind._Release;
   end;
end;

procedure TMSpeech.PostSelectEngine;
begin
   OleCheck(FITTSCentral.QueryInterface(IID_ITTSAttributes, FITTSAttributes));
   OleCheck(FITTSCentral.QueryInterface(IID_ITTSDialogs, FITTSDialogs));
   OleCheck(FITTSCentral.Register(Pointer(FTTSNotifySink),
                                  IID_ITTSNotifySink, FKey));
end;

procedure TMSpeech.PostSelectEngine2;
var CurrentPitch: Word;
    CurrentRealTime, CurrentSpeed: LongWord;
begin
   { Retrieve Engine Information }
   FInfo.Language := StrPas(ModeInfo.Language.szDialect);
   with FInfo, ModeInfo do
   begin
      Name := StrPas(szModeName);
      Manufacturer := StrPas(szMfgName);
      Product := StrPas(szProductName);
      ModeID := GUIDToString(gModeID);
      EngineID := GUIDToString(gEngineID);
      Speaker := StrPas(szSpeaker);
      Style := StrPas(szStyle);

      case wGender of
         0: Gender := 'NEUTRAL';
         1: Gender := 'FEMALE';
         2: Gender := 'MALE';
      end;

      Age := wAge;
      Features := dwFeatures;
      Interfaces := dwInterfaces;

      with FITTSAttributes do
      begin
         PitchGet(CurrentPitch);
         PitchSet(TTSATTR_MAXPITCH);
         PitchGet(MaxPitch);
         PitchSet(TTSATTR_MINPITCH);
         PitchGet(MinPitch);
         PitchSet(CurrentPitch);

         RealTimeGet(CurrentRealTime);
         RealTimeSet(TTSATTR_MAXREALTIME);
         RealTimeGet(MaxRealTime);
         RealTimeSet(TTSATTR_MINREALTIME);
         RealTimeGet(MinRealTime);
         RealTimeSet(CurrentRealTime);

         SpeedGet(CurrentSpeed);
         SpeedSet(TTSATTR_MAXSPEED);
         SpeedGet(MaxSpeed);
         SpeedSet(TTSATTR_MINSPEED);
         SpeedGet(MinSpeed);
         SpeedSet(CurrentSpeed);

         { According to MS's help file }
         MaxVolume := 100;
         MinVolume := 0;
      end;
   end;
end;

procedure TMSpeech.Pause;
begin
   OleCheck(FITTSCentral.AudioPause);
   FPaused := True;
end;

procedure TMSpeech.Resume;
begin
   OleCheck(FITTSCentral.AudioResume);
   FPaused := False;
end;

procedure TMSpeech.Show;
begin
   case DialogType of
      sdAbout: OleCheck(FITTSDialogs.AboutDlg(ParentWnd, nil));
      sdGeneral: OleCheck(FITTSDialogs.GeneralDlg(ParentWnd, nil));
      sdLexicon: OleCheck(FITTSDialogs.LexiconDlg(ParentWnd, nil));
      sdTranslate: OleCheck(FITTSDialogs.TranslateDlg(ParentWnd, nil));
   end;
end;

procedure TMSpeech.Speak;
var SData : TSData;
begin
   if not FInit then
      raise EMSpeechException.Create(msgSENotInited);

   if not FEngineStarted then
      raise EMSpeechException.Create(msgSENotStarted);

   FPaused := False;
// OleCheck(FITTSCentral.AudioReset);

   try
      if FOutput = soFile then
         if FIAF.DoSet(PWideChar(Filename), 1) < 0 then
            raise EMSpeechException.Create('Cannot open file'{msgCannotOpenFile});

      SData.dwSize := Length(FText.Text) + 1;
      SData.pData := PChar(FText.Text);
      OleCheck(FITTSCentral.TextData (CHARSET_TEXT, 0,
               SData, Pointer(FTTSBufNotifySink), IID_ITTSBufNotifySink));
   except
   end;
end;

procedure TMSpeech.Stop;
begin
   FPaused := False;
   OleCheck(FITTSCentral.AudioReset);
end;

function TMSpeech.GetEngineInfo;
var Index, EngineCount: Integer;
    ModeInfo: TTSModeInfo;
begin
   Result := False;

   if not FInit then Exit;
   Index := Engines.IndexOf(EngineName);
   if Index < 0 then Exit;

   if FITTSEnum.Reset < 0 then Exit;
   if FITTSEnum.Skip(Index) < 0 then Exit;
   if FITTSEnum.Next(1, ModeInfo, @EngineCount) < 0 then Exit;

   { Retrieve Engine Information }
   FillChar(Result, Sizeof(Result), 0);
   Info.Language := StrPas(ModeInfo.Language.szDialect);
   with Info, ModeInfo do
   begin
      Name := StrPas(szModeName);
      Manufacturer := StrPas(szMfgName);
      Product := StrPas(szProductName);
      ModeID := GUIDToString(gModeID);
      EngineID := GUIDToString(gEngineID);
      Speaker := StrPas(szSpeaker);
      Style := StrPas(szStyle);

      case wGender of
         0: Gender := 'NEUTRAL';
         1: Gender := 'FEMALE';
         2: Gender := 'MALE';
      end;

      Age := wAge;
      Features := dwFeatures;
      Interfaces := dwInterfaces;

      MaxVolume := 100;
   end;
   Result := True;
end;

{ Setting/Getting properties }

{ Undocumented property, for advanced user only }
function TMSpeech.GetInterface;
begin
   case Index of
      0: Result := GetAudioDevice;
      1: Result := FITTSCentral;
      2: Result := FITTSAttributes;
      3: Result := FITTSDialogs;
   end;
end;

function TMSpeech.GetPitch;
begin
   FITTSAttributes.PitchGet(Result);
end;

procedure TMSpeech.SetPitch;
begin
   FITTSCentral.Inject(PChar('\Pit=' + IntToStr(Value) + '\'));
// FITTSAttributes.PitchSet(Value);
end;

function TMSpeech.GetRealTime;
begin
   FITTSAttributes.RealTimeGet(Result);
end;

procedure TMSpeech.SetRealTime;
begin
   FITTSAttributes.RealTimeSet(Value);
end;

function TMSpeech.GetSpeed;
begin
   FITTSAttributes.SpeedGet(Result);
end;


procedure TMSpeech.SetSpeed;
begin
   FITTSCentral.Inject(PChar('\Spd=' + IntToStr(Value) + '\'));
// FITTSAttributes.SpeedSet(Value);
end;

{$ifdef MANUAL_SET_AND_GET_VOLUME}
function TMSpeech.GetVolume;
begin
   FITTSAttributes.VolumeGet(Result);
end;

procedure TMSpeech.SetVolume;
begin
   FITTSCentral.Inject(PChar('\Vol=' + IntToStr(Volume) + '\'));
end;
{$else}
function TMSpeech.GetVolume;
var CurrentVolume: LongWord;
begin
   FITTSAttributes.VolumeGet(CurrentVolume);
   Result := LoWord(CurrentVolume) * 100 div 65535;
end;

procedure TMSpeech.SetVolume;
var TempVolume: LongWord;
begin
   TempVolume := 65535 * Value div 100;
   TempVolume := MakeWParam(TempVolume, TempVolume);
   FITTSCentral.Inject(PChar('\Vol=' + IntToStr(TempVolume) + '\'));
// OleCheck(FITTSAttributes.VolumeSet(TempVolume));
end;
{$endif}

procedure TMSpeech.SetText;
begin
   FText.Assign(Value);
end;

{ TTSNotifySink }

constructor TTSNotifySink.Create;
begin
   FOwner := AOwner;
end;

function TTSNotifySink.AttribChanged;
begin
   Result := 0;
end;

function TTSNotifySink.AudioStart;
begin
   if Assigned(FOwner.FOnStart) then FOwner.FOnStart(Self);
   Result := 0;
end;

function TTSNotifySink.AudioStop;
begin
   FOwner.FlushFile;
   if Assigned(FOwner.FOnStop) then FOwner.FOnStop(Self);
   Result := 0;
end;

function TTSNotifySink.Visual;
begin
   if Assigned(FOwner.FOnVisual) then FOwner.FOnVisual(Self, dwHints, apTTSMouth);
   Result := 0;
end;

{ TTSBufNotifySink }

constructor TTSBufNotifySink.Create;
begin
   FOwner := AOwner;
end;

function TTSBufNotifySink.BookMark;
begin
   Result := 0;
end;

function TTSBufNotifySink.TextDataDone;
begin
   Result := 0;
end;

function TTSBufNotifySink.TextDataStarted;
begin
   Result := 0;
end;

function TTSBufNotifySink.WordPosition;
begin
   FOwner.FPos := dwByteOffset;
   Result := 0;
end;

end.
