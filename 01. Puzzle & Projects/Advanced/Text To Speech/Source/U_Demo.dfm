object frmMain: TfrmMain
  Left = 205
  Top = 108
  Width = 544
  Height = 375
  BorderIcons = [biSystemMenu]
  Caption = 'Text-to-Speech'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 169
    Height = 169
    Caption = 'Available Speaker'
    TabOrder = 0
    object lbEngines: TListBox
      Left = 8
      Top = 16
      Width = 153
      Height = 145
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 248
    Top = 8
    Width = 281
    Height = 329
    Caption = 'Text to Speak'
    TabOrder = 1
    object TextPad: TRichEdit
      Left = 8
      Top = 15
      Width = 264
      Height = 306
      Lines.Strings = (
        'Good morning everyone!')
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 180
    Top = 40
    Width = 64
    Height = 25
    Caption = '&Select'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 180
    Top = 72
    Width = 64
    Height = 25
    Caption = 'S&peak'
    Enabled = False
    TabOrder = 3
    OnClick = Button2Click
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 184
    Width = 233
    Height = 155
    Caption = 'Attributes'
    Enabled = False
    TabOrder = 4
    object PitchMax: TLabel
      Left = 40
      Top = 120
      Width = 18
      Height = 13
      Caption = '100'
    end
    object PitchMin: TLabel
      Left = 40
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label2: TLabel
      Left = 8
      Top = 136
      Width = 24
      Height = 13
      Caption = 'Pitch'
    end
    object SpeedMax: TLabel
      Left = 120
      Top = 120
      Width = 18
      Height = 13
      Caption = '100'
    end
    object SpeedMin: TLabel
      Left = 120
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
    end
    object VolumeMin: TLabel
      Left = 200
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label1: TLabel
      Left = 200
      Top = 120
      Width = 20
      Height = 13
      Caption = 'Max'
    end
    object Label3: TLabel
      Left = 88
      Top = 136
      Width = 31
      Height = 13
      Caption = 'Speed'
    end
    object Label4: TLabel
      Left = 168
      Top = 136
      Width = 35
      Height = 13
      Caption = 'Volume'
    end
    object PitchBar: TTrackBar
      Left = 8
      Top = 16
      Width = 33
      Height = 121
      LineSize = 12
      Orientation = trVertical
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsManual
      OnExit = PitchBarExit
    end
    object SpeedBar: TTrackBar
      Left = 88
      Top = 16
      Width = 33
      Height = 121
      LineSize = 20
      Orientation = trVertical
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      TickMarks = tmBottomRight
      TickStyle = tsManual
      OnExit = SpeedBarExit
    end
    object VolumeBar: TTrackBar
      Left = 168
      Top = 16
      Width = 33
      Height = 121
      Orientation = trVertical
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 2
      TickMarks = tmBottomRight
      TickStyle = tsManual
      OnExit = VolumeBarExit
    end
  end
  object Button3: TButton
    Left = 180
    Top = 104
    Width = 64
    Height = 25
    Caption = '&Pause'
    Enabled = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 180
    Top = 136
    Width = 64
    Height = 25
    Caption = 'S&top'
    Enabled = False
    TabOrder = 6
    OnClick = Button4Click
  end
end
