object Form1: TForm1
  Left = 309
  Top = 139
  AutoScroll = False
  AutoSize = True
  Caption = ' Sound Generator  Version 3.0'
  ClientHeight = 559
  ClientWidth = 1073
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1073
    Height = 535
    ActivePage = DTMFSheet
    Align = alClient
    TabOrder = 0
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 49
        Top = 20
        Width = 888
        Height = 437
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Atial'
        Font.Style = []
        Lines.Strings = (
          
            'Signal Generator generates complex wave forms and sends then to ' +
            'the PC sound card as '#39'wav'#39' formatted streams.'
          
            'Named sounds may have many frequency components, each component ' +
            'with a unique frequency, phase, amplitude'
          
            'and waveshape.  Sound files may be created, modified and deleted' +
            '.   Predefined sample definitions are provided for'
          '  > Composite Square Wave:  Sum(1/N* sin(N*wt)) for all odd N,'
          '  > Composite Sawtooth Wave: Sum(1/N* sin(N*wt)) for all N,'
          '  > and  a few others.'
          ''
          
            'The frequency and amplitude of sounds may be scaled for playback' +
            ' using the "Volume" and "Frequency" track bars.  '
          
            'These affect the playback only and do not change the sound file ' +
            'definitions.'
          ''
          
            'Left click on a sound name (the left-most list) to select a new ' +
            'sound.  Right click to bring up a menu of available actions.'
          ''
          
            'For a selected sound, the right most list shows a list of the fr' +
            'equency components of the sound.  Click to select a '
          
            'component, use Enter (or double click)  to modifiy, "Insert" to ' +
            'create, or "Delete" key  delete  frequency components.  '
          
            'Click the check box to included/exclude a particular component i' +
            'n the composite sound.'
          ''
          
            'Version 2 adds a simple metronome playing a "click" sound at the' +
            ' specified tempo.'
          ''
          
            'Version 3 adds ability to generate, play and save strings of "To' +
            'uch-tone" beeps for the 16 defined characters.')
        ParentFont = False
        TabOrder = 0
      end
    end
    object SoundSheet: TTabSheet
      Caption = 'Sounds'
      ImageIndex = 1
      object Label2: TLabel
        Left = 453
        Top = 59
        Width = 96
        Height = 16
        Caption = 'Defined Sounds'
      end
      object Label3: TLabel
        Left = 30
        Top = 98
        Width = 82
        Height = 16
        Hint = 'Set 1st freq value, rescale others'
        Caption = 'ReScale freq.'
        ParentShowHint = False
        ShowHint = True
      end
      object VolLbl: TLabel
        Left = 325
        Top = 20
        Width = 46
        Height = 16
        Caption = 'Volume'
      end
      object FreqLbl: TLabel
        Left = 325
        Top = 79
        Width = 94
        Height = 16
        Caption = 'Base frequency'
      end
      object Label1: TLabel
        Left = 30
        Top = 39
        Width = 93
        Height = 16
        Caption = 'Master Volume:'
      end
      object CompLbl: TLabel
        Left = 620
        Top = 10
        Width = 144
        Height = 16
        Caption = 'Components for  -----------'
      end
      object Label5: TLabel
        Left = 618
        Top = 39
        Width = 299
        Height = 41
        AutoSize = False
        Caption = 
          '(Click to select, Dbl click to change,  Ins to add new freq, Del' +
          '  to delete'
        WordWrap = True
      end
      object Label6: TLabel
        Left = 39
        Top = 226
        Width = 50
        Height = 16
        Caption = 'Duration'
      end
      object Label7: TLabel
        Left = 118
        Top = 266
        Width = 166
        Height = 16
        Caption = '(Enter 0 for continuious play)'
      end
      object PlayBtn: TButton
        Left = 20
        Top = 389
        Width = 92
        Height = 31
        Caption = 'Start'
        TabOrder = 0
        OnClick = PlayBtnClick
      end
      object StopBtn: TButton
        Left = 128
        Top = 389
        Width = 92
        Height = 31
        Caption = 'Stop'
        TabOrder = 1
        OnClick = StopBtnClick
      end
      object VolBar: TTrackBar
        Left = 128
        Top = 30
        Width = 185
        Height = 40
        Max = 127
        Position = 64
        TabOrder = 2
        OnChange = VolBarChange
      end
      object ListBox1: TCheckListBox
        Left = 620
        Top = 89
        Width = 317
        Height = 326
        Hint = 'Clcik to add or change, Del to delete'
        OnClickCheck = ListBox1ClickCheck
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        Sorted = True
        TabOrder = 3
        OnDblClick = ListBox1Click
        OnKeyUp = ListBox1KeyUp
      end
      object ListBox2: TListBox
        Left = 453
        Top = 89
        Width = 149
        Height = 326
        Hint = 'Right click for options'
        ItemHeight = 16
        ParentShowHint = False
        PopupMenu = PopupMenu2
        ShowHint = True
        TabOrder = 4
        OnClick = ListBox2Click
        OnContextPopup = ListBox2ContextPopup
      end
      object Freqbar: TTrackBar
        Left = 128
        Top = 89
        Width = 185
        Height = 40
        Max = 4000
        Min = 10
        Position = 10
        TabOrder = 5
        OnChange = FreqbarChange
      end
      object RateRgrp: TRadioGroup
        Left = 30
        Top = 138
        Width = 375
        Height = 60
        Caption = 'Samples per second'
        Columns = 4
        ItemIndex = 1
        Items.Strings = (
          '8,000'
          '11,025'
          '22,050'
          '44,100')
        TabOrder = 6
        OnClick = RateRgrpClick
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 485
        Width = 1065
        Height = 19
        Panels = <
          item
            Text = 'Message:'
            Width = 400
          end
          item
            Alignment = taRightJustify
            Width = 50
          end>
      end
      object VolEdit: TEdit
        Left = 315
        Top = 39
        Width = 90
        Height = 24
        Hint = 'Key new master volume and press "Enter"Enter '
        TabOrder = 8
        Text = 'VolEdit'
        OnClick = VolEditChange
        OnExit = VolEditChange
      end
      object FreqEdit: TEdit
        Left = 315
        Top = 98
        Width = 90
        Height = 24
        Hint = 'Enter new freq value and press "Enter" '
        TabOrder = 9
        Text = 'FreqEdit'
        OnClick = FreqEditChange
        OnExit = FreqEditChange
        OnKeyPress = FreqEditKeyPress
      end
      object Edit1: TEdit
        Left = 118
        Top = 231
        Width = 80
        Height = 24
        TabOrder = 10
        Text = '100'
      end
      object Unitsgrp: TRadioGroup
        Left = 226
        Top = 209
        Width = 110
        Height = 51
        ItemIndex = 0
        Items.Strings = (
          'milliseconds'
          'seconds')
        TabOrder = 11
      end
      object Duration: TUpDown
        Left = 198
        Top = 231
        Width = 15
        Height = 24
        Associate = Edit1
        Max = 1000
        Position = 100
        TabOrder = 12
      end
      object Button2: TButton
        Left = 236
        Top = 389
        Width = 198
        Height = 31
        Caption = 'Save sound as  .wav file...'
        TabOrder = 13
        OnClick = Button2Click
      end
      object PinkNoiseBtn: TCheckBox
        Left = 39
        Top = 305
        Width = 120
        Height = 21
        Caption = 'Add "pink" noise '
        TabOrder = 14
      end
    end
    object ImageSheet: TTabSheet
      Caption = 'Wave view'
      ImageIndex = 2
      OnEnter = ImageSheetEnter
      object Image1: TImage
        Left = 20
        Top = 39
        Width = 917
        Height = 315
      end
      object Label4: TLabel
        Left = 20
        Top = 10
        Width = 216
        Height = 16
        Caption = 'A few cycles of the current waveform,'
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Metronome'
      ImageIndex = 3
      object Label8: TLabel
        Left = 217
        Top = 49
        Width = 100
        Height = 16
        Caption = 'Beats per minute'
      end
      object Edit2: TEdit
        Left = 217
        Top = 69
        Width = 70
        Height = 24
        TabOrder = 0
        Text = '96'
        OnChange = Edit2Change
      end
      object UpDown1: TUpDown
        Left = 287
        Top = 69
        Width = 15
        Height = 24
        Associate = Edit2
        Min = 40
        Max = 180
        Position = 96
        TabOrder = 1
      end
      object MetroBtn: TButton
        Left = 217
        Top = 118
        Width = 92
        Height = 31
        Caption = 'Start'
        TabOrder = 2
        OnClick = MetroBtnClick
      end
    end
    object DTMFSheet: TTabSheet
      Caption = '  DTMF Generator  '
      ImageIndex = 4
      object Label9: TLabel
        Left = 32
        Top = 408
        Width = 162
        Height = 24
        Caption = 'Tone Duration (ms)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 216
        Top = 408
        Width = 152
        Height = 24
        Caption = 'Gap Duration (ms)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 488
        Top = 40
        Width = 337
        Height = 24
        Caption = 'Click grid or enter tone characters below'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 32
        Top = 24
        Width = 240
        Height = 24
        Caption = 'DTMF Tone Frequency Grid'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object DTMFGrid: TStringGrid
        Left = 32
        Top = 56
        Width = 337
        Height = 337
        DefaultRowHeight = 64
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = DTMFGridClick
      end
      object ToneLenEdt: TSpinEdit
        Left = 56
        Top = 432
        Width = 89
        Height = 35
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxValue = 1000
        MinValue = 10
        ParentFont = False
        TabOrder = 1
        Value = 100
      end
      object GapLenEdt: TSpinEdit
        Left = 240
        Top = 432
        Width = 89
        Height = 35
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxValue = 1000
        MinValue = 10
        ParentFont = False
        TabOrder = 2
        Value = 50
      end
      object InputEdt: TEdit
        Left = 488
        Top = 80
        Width = 425
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object GenerateDTMFBtn: TButton
        Left = 496
        Top = 168
        Width = 289
        Height = 25
        Caption = 'Play DTMF tones'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = GenerateDTMFBtnClick
      end
      object SaveDTMFBtn: TButton
        Left = 496
        Top = 208
        Width = 289
        Height = 25
        Caption = 'Save as WAV file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = SaveDTMFBtnClick
      end
      object Memo2: TMemo
        Left = 504
        Top = 248
        Width = 513
        Height = 217
        Color = 13172735
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Lines.Strings = (
          'Dual Tone Multi-Frequency (DTMF) signaling, aka "Touch-'
          'Tone" dialing, is the system which replaced pulse dialing for '
          'telephone connections in the 1960'#39's.'
          ''
          'This section generates the 16 dual-frequency characters '
          'defined in the DTMF system.  Strings of characters of '
          'specified length and gaps between  tones can be generated , '
          'played, and saved in "wave" format as .wav files.  These files '
          'may be used in testing posssoble future DTMF Decoder '
          'projects.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 6
      end
      object ClearBtn: TButton
        Left = 496
        Top = 128
        Width = 289
        Height = 25
        Caption = 'Clear tone string'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        OnClick = ClearBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 535
    Width = 1073
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  '#169' 2003..2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'snd'
    Filter = 'Sound (*.snd)|*.snd|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 944
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'snd'
    Filter = 'Sound (*.snd)|*.snd|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofCreatePrompt, ofEnableSizing]
    Left = 872
    Top = 24
  end
  object PopupMenu2: TPopupMenu
    Left = 1000
    Top = 24
    object Applyfreqscalingtodefinition1: TMenuItem
      Caption = 'Apply freq scaling to definition'
      OnClick = Applyfreqscalingtodefinition1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Startnewsound1: TMenuItem
      Caption = 'New...'
      OnClick = StartnewsoundClick
    end
    object Loadsound1: TMenuItem
      Caption = 'Load...'
      OnClick = LoadsoundClick
    end
    object Savesound1: TMenuItem
      Caption = 'Save '
      OnClick = SavesoundClick
    end
    object Savesoundas1: TMenuItem
      Caption = 'Save as...'
      OnClick = SavesoundasClick
    end
    object Deletesoundfile1: TMenuItem
      Caption = 'Delete '
      OnClick = Deletesoundfile1Click
    end
  end
end
