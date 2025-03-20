unit U_VolumeControlDemo;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, Dialogs,
  activex, MMDevAPI;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    PlayBtn: TButton;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    procedure StaticText1Click(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  public
    endpointVolume: IAudioEndpointVolume;
    LastBeepTime:TDatetime;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
begin
  EndpointVolume:=nil;
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
  lastbeeptime:=now;
end;

{************* PlayBtnClick **********}
procedure TForm1.PlayBtnClick(Sender: TObject);
var
  VolumeLevel: Single;
begin
  if endpointVolume = nil then Exit;
  //VolumeLevel := 0.50;
  //VolumeLevel:=StrtoFloatDef(edit1.text,0.5);
  with Trackbar1 do volumeLevel:= Position/max;
  endpointVolume.SetMasterVolumeLevelScalar(VolumeLevel, nil);
  messagebeep(MB_IconExclamation); {48}
  //messagebeep(MB_IconAsterisk); {64}
  //messagebeep('MB_IconHand);  {16}
  //messagebeep(0);
  Memo2.lines.add(format('Master Volume: %.1f', [Volumelevel]));
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  if (now-lastbeeptime)*secsperday<0.5 then exit;  {prevent "double beeping"}
  PlayBtnclick(sender);
  lastbeeptime:=now;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

(*Ref:
   1. https://social.msdn.microsoft.com/Forums/en-US/5ce74d5d-2b1e-4ca9-a8c9-2e27eb9ec058/vista-volume-control-using-delphi-5?forum=windowspro-audiodevelopment
   MMDevAPI used in this program is from the bottom of this long discussion

   2. http://mencrang.blogspot.com/2011/01/volume-control-using-delphi.html
   Not tested:  MMDevAPI.pas & sample program - no attribution

   3. http://www.codenewsfast.com/cnf/article/0/permalink.art-ng1942q10169
   Not tested: MMDevAPI.pas "found on net" + sample program

   4. http://www.delphipraxis.net/159184-setmastervolume-failure-2.html
   Not tested: Defines TMixer class
 *)

(*  Code from from Reference 1 used to create for MMDevApi unit used in this program
  ==================================================================================
 it's work in Delphi 7
//////////////////////////

unit MMDevApi;

interface

uses
  Windows, ActiveX, ComObj;

const
  CLASS_IMMDeviceEnumerator             : TGUID = '{BCDE0395-E52F-467C-8E3D-C4579291692E}';
  IID_IMMDeviceEnumerator               : TGUID = '{A95664D2-9614-4F35-A746-DE8DB63617E6}';
  IID_IMMDevice                         : TGUID = '{D666063F-1587-4E43-81F1-B948E807363F}';
  IID_IMMDeviceCollection               : TGUID = '{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}';
  IID_IAudioEndpointVolume              : TGUID = '{5CDF2C82-841E-4546-9722-0CF74078229A}';
  IID_IAudioMeterInformation            : TGUID = '{C02216F6-8C67-4B5B-9D00-D008E73E0064}';
  IID_IAudioEndpointVolumeCallback      : TGUID = '{657804FA-D6AD-4496-8A60-352752AF4F89}';

  DEVICE_STATE_ACTIVE                   = $00000001;
  DEVICE_STATE_UNPLUGGED                = $00000002;
  DEVICE_STATE_NOTPRESENT               = $00000004;
  DEVICE_STATEMASK_ALL                  = $00000007;

type
  EDataFlow = TOleEnum;

const
  eRender                               = $00000000;
  eCapture                              = $00000001;
  eAll                                  = $00000002;
  EDataFlow_enum_count                  = $00000003;

type
  ERole = TOleEnum;

const
  eConsole                              = $00000000;
  eMultimedia                           = $00000001;
  eCommunications                       = $00000002;
  ERole_enum_count                      = $00000003;

type
  IAudioEndpointVolumeCallback = interface(IUnknown)
  ['{657804FA-D6AD-4496-8A60-352752AF4F89}']
  end;

  IAudioEndpointVolume = interface(IUnknown)
  ['{5CDF2C82-841E-4546-9722-0CF74078229A}']
    function RegisterControlChangeNotify(AudioEndPtVol: IAudioEndpointVolumeCallback): Integer; stdcall;
    function UnregisterControlChangeNotify(AudioEndPtVol: IAudioEndpointVolumeCallback): Integer; stdcall;
    function GetChannelCount(out PInteger): Integer; stdcall;
    function SetMasterVolumeLevel(fLevelDB: single; pguidEventContext: PGUID): Integer; stdcall;
    function SetMasterVolumeLevelScalar(fLevelDB: single; pguidEventContext: PGUID): Integer; stdcall;
    function GetMasterVolumeLevel(out fLevelDB: single): Integer; stdcall;
    function GetMasterVolumeLevelScaler(out fLevelDB: single): Integer; stdcall;
    function SetChannelVolumeLevel(nChannel: Integer; fLevelDB: double; pguidEventContext: PGUID): Integer; stdcall;
    function SetChannelVolumeLevelScalar(nChannel: Integer; fLevelDB: double; pguidEventContext: PGUID): Integer; stdcall;
    function GetChannelVolumeLevel(nChannel: Integer; out fLevelDB: double): Integer; stdcall;
    function GetChannelVolumeLevelScalar(nChannel: Integer; out fLevel: double): Integer; stdcall;
    function SetMute(bMute: Boolean; pguidEventContext: PGUID): Integer; stdcall;
    function GetMute(out bMute: Boolean): Integer; stdcall;
    function GetVolumeStepInfo(pnStep: Integer; out pnStepCount: Integer): Integer; stdcall;
    function VolumeStepUp(pguidEventContext: PGUID): Integer; stdcall;
    function VolumeStepDown(pguidEventContext: PGUID): Integer; stdcall;
    function QueryHardwareSupport(out pdwHardwareSupportMask): Integer; stdcall;
    function GetVolumeRange(out pflVolumeMindB: double; out pflVolumeMaxdB: double; out pflVolumeIncrementdB: double): Integer; stdcall;
  end;

  IAudioMeterInformation = interface(IUnknown)
  ['{C02216F6-8C67-4B5B-9D00-D008E73E0064}']
  end;

  IPropertyStore = interface(IUnknown)
  end;

  IMMDevice = interface(IUnknown)
  ['{D666063F-1587-4E43-81F1-B948E807363F}']
    function Activate(const refId: TGUID;
                      dwClsCtx: DWORD;
                      pActivationParams: PInteger;
                      out pEndpointVolume: IAudioEndpointVolume): Hresult; stdCall;
    function OpenPropertyStore(stgmAccess: DWORD; out ppProperties: IPropertyStore): Hresult; stdcall;
    function GetId(out ppstrId: PLPWSTR): Hresult; stdcall;
    function GetState(out State: Integer): Hresult; stdcall;
  end;


  IMMDeviceCollection = interface(IUnknown)
  ['{0BD7A1BE-7A1A-44DB-8397-CC5392387B5E}']
  end;

  IMMNotificationClient = interface(IUnknown)
  ['{7991EEC9-7E89-4D85-8390-6C703CEC60C0}']
  end;

  IMMDeviceEnumerator = interface(IUnknown)
  ['{A95664D2-9614-4F35-A746-DE8DB63617E6}']
    function EnumAudioEndpoints(dataFlow: EDataFlow; deviceState: SYSUINT; DevCollection: IMMDeviceCollection): Hresult; stdcall;
    function GetDefaultAudioEndpoint(EDF: SYSUINT; ER: SYSUINT; out Dev :IMMDevice ): Hresult; stdcall;
    function GetDevice(pwstrId: pointer; out Dev: IMMDevice): HResult; stdcall;
    function RegisterEndpointNotificationCallback(pClient: IMMNotificationClient): Hresult; stdcall;
  end;

implementation

end.

///////////////////////
simple sample :)
///////////////////////

//...... other code

uses ... ActiveX, MMDevApi, ...;

//...... other code

var
  endpointVolume: IAudioEndpointVolume = nil;

procedure TForm1.FormCreate(Sender: TObject);
var
  deviceEnumerator: IMMDeviceEnumerator;
  defaultDevice: IMMDevice;
begin
  CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator, deviceEnumerator);
  deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
  defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  VolumeLevel: Single;
begin
  if endpointVolume = nil then Exit;
  VolumeLevel := 0.50;
  endpointVolume.SetMasterVolumeLevelScalar(VolumeLevel, nil);
  Caption := Format('%1.8f', [VolumeLevel])
end;

/////////////////////////////////////

// with best regards ToxicDream
*)


















