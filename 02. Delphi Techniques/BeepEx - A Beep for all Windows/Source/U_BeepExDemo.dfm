object Form1: TForm1
  Left = 192
  Top = 107
  Width = 600
  Height = 367
  Caption = 'BeepEx Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 240
    Top = 24
    Width = 50
    Height = 13
    Caption = 'Frequency'
  end
  object Label2: TLabel
    Left = 240
    Top = 72
    Width = 40
    Height = 13
    Caption = 'Duration'
  end
  object StopBtn: TButton
    Left = 240
    Top = 208
    Width = 305
    Height = 81
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    Visible = False
    OnClick = StopBtnClick
  end
  object BleepBtn: TButton
    Left = 512
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Beep'
    TabOrder = 0
    OnClick = BleepBtnClick
  end
  object TimeBar: TTrackBar
    Left = 296
    Top = 64
    Width = 150
    Height = 45
    Max = 1000
    Min = 1
    Orientation = trHorizontal
    Frequency = 1
    Position = 500
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TimeBarChange
  end
  object FreqBar: TTrackBar
    Left = 304
    Top = 16
    Width = 150
    Height = 45
    Max = 2000
    Min = 100
    Orientation = trHorizontal
    Frequency = 1
    Position = 400
    SelEnd = 0
    SelStart = 0
    TabOrder = 2
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = FreqBarChange
  end
  object FreqEdt: TEdit
    Left = 456
    Top = 20
    Width = 41
    Height = 21
    TabOrder = 3
    Text = 'FreqEdt'
  end
  object TimeEdt: TEdit
    Left = 456
    Top = 68
    Width = 41
    Height = 21
    TabOrder = 4
    Text = 'TimeEdt'
  end
  object MajorBtn: TButton
    Left = 248
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Major scale'
    TabOrder = 5
    OnClick = MajorBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 323
    Width = 592
    Height = 17
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 217
    Height = 273
    Color = 14548991
    Lines.Strings = (
      'Windows Beep function synchronously plays '
      'tones of specifired frequency for a specified '
      'duration..  For Windows 95, 98,and ME '
      'however, the function is replaced by a call to '
      'MessageBeep which does not honor '
      'frequency and duration parameters and '
      'which operates asynchronously (i.e. it returns '
      'before the tone has completed playing).'
      ''
      'BeepEx presented here imitates Windows '
      'Beep for all versions of Windows.'
      ''
      '2007 update - added minor and chromatic '
      'scales.   I also added a procedure to play a '
      'predefined tune.  A STOP button can now '
      'interrupt playing. The Freq bar sets the '
      'lowest tone and the Duration bar defines the '
      'duration of each tone (or for 4 beats for the '
      'tune). '
      ' ')
    TabOrder = 7
  end
  object BeepVer: TRadioGroup
    Left = 240
    Top = 120
    Width = 185
    Height = 65
    Caption = 'Beep version to test'
    ItemIndex = 1
    Items.Strings = (
      'Windows Beep'
      'BeepEx')
    TabOrder = 8
  end
  object MinorBtn: TButton
    Left = 352
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Minor Scale'
    TabOrder = 9
    OnClick = MinorBtnClick
  end
  object ChromaticBtn: TButton
    Left = 456
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Chromatic'
    TabOrder = 10
    OnClick = ChromaticBtnClick
  end
  object Button1: TButton
    Left = 248
    Top = 256
    Width = 129
    Height = 25
    Caption = 'HappyBirthday!'
    TabOrder = 11
    OnClick = Button1Click
  end
end
