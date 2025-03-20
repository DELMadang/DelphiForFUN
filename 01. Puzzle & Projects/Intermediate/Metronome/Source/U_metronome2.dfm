object Form1: TForm1
  Left = 686
  Top = 162
  Caption = 'Metronome  Version 2.1'
  ClientHeight = 597
  ClientWidth = 847
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 21
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 847
    Height = 574
    Align = alClient
  end
  object Label1: TLabel
    Left = 511
    Top = 35
    Width = 135
    Height = 42
    AutoSize = False
    Caption = 'Beats per minute (40 to 240)'
    Color = clWhite
    ParentColor = False
    WordWrap = True
  end
  object PriorityGrp: TRadioGroup
    Left = 167
    Top = 463
    Width = 273
    Height = 105
    Caption = 'Set priority (Hidden - not working)'
    ItemIndex = 0
    Items.Strings = (
      'Normal Priority'
      'Above Normal Priority'
      'High Priority')
    TabOrder = 5
    Visible = False
    OnClick = PriorityGrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 574
    Width = 847
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2005-2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object StartBtn: TButton
    Left = 703
    Top = 400
    Width = 105
    Height = 75
    Caption = 'Start'
    TabOrder = 1
    OnClick = StartBtnClick
  end
  object SoundGrp: TRadioGroup
    Left = 511
    Top = 176
    Width = 314
    Height = 201
    Caption = 'Sound'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Click1'
      'Click2'
      'Click3'
      'Unused'
      'Unused')
    ParentFont = False
    PopupMenu = Popup1
    TabOrder = 2
    OnClick = SoundGrpClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 489
    Height = 537
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      ' A Metronome is an instrument that produces a'
      'steady beat for musicians at practice or, as in my'
      'case,  for performing certain fitness tests which'
      'require stepping on an off of a step for a'
      'predetermined number of steps at a predetermined'
      'rate.'
      ''
      'Rates may be varied from 40 to 240 beats per minute and'
      'three "click" sounds are initially available. There are two '
      'unused  slots where additional sound (.wav) file may be '
      'addded. Any of the files may be replaced by right clicking and '
      'browsing for a replacement.  File changes are retained from '
      'run to run.'
      ''
      'Metronome does not use much processor time, but it needs  it '
      'for each click.   On older processors, like my Core 2 Duo, '
      'two CPU hogs (like SkyDrive and Acronis Backup) running at '
      'the same time, can make the Metronome pretty useless.  I'#39'm '
      'working on allowing the program priority be increased by the '
      'user , but haven'#39't mastered the trick yet.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object BeatRate: TSpinEdit
    Left = 672
    Top = 32
    Width = 57
    Height = 32
    MaxValue = 240
    MinValue = 40
    TabOrder = 4
    Value = 120
    OnChange = BeatRateChange
    OnClick = BeatRateClick
  end
  object Memo2: TMemo
    Left = 511
    Top = 113
    Width = 314
    Height = 57
    Lines.Strings = (
      'Click the wave file to play.  Right click '
      'to replace a file. ')
    TabOrder = 6
  end
  object Memo3: TMemo
    Left = 511
    Top = 400
    Width = 186
    Height = 75
    Lines.Strings = (
      'Click the button to '
      'Start or Stop the '
      'metronome.')
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    Filter = 'wav files (*.wav)|*.wav'
    Title = 'Select a "tick-tock" file'
    Left = 792
    Top = 16
  end
  object Popup1: TPopupMenu
    Left = 808
    Top = 528
    object Open1: TMenuItem
      Caption = 'Open'
      OnClick = Open1Click
    end
    object Replace1: TMenuItem
      Caption = 'Replace'
      OnClick = Replace1Click
    end
  end
end
