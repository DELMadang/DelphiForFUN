object AniForm: TAniForm
  Left = -8
  Top = 24
  Width = 809
  Height = 567
  Caption = 'Animation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 152
    Top = 16
    Width = 138
    Height = 20
    Caption = 'Job Wait Queues'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 464
    Top = 16
    Width = 62
    Height = 20
    Caption = 'Servers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 480
    Top = 456
    Width = 88
    Height = 14
    Caption = 'Time Compression'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object CloseBtn: TBitBtn
    Left = 680
    Top = 472
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = CloseBtnClick
    Kind = bkClose
  end
  object Timebar: TTrackBar
    Left = 472
    Top = 472
    Width = 150
    Height = 25
    Max = 5
    Orientation = trHorizontal
    Frequency = 1
    Position = 1
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TimebarChange
  end
  object CompressTxt: TStaticText
    Left = 624
    Top = 472
    Width = 16
    Height = 17
    Caption = '10'
    TabOrder = 2
  end
  object SimTimeTxt: TStaticText
    Left = 176
    Top = 480
    Width = 75
    Height = 24
    Caption = '00:00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object StaticText2: TStaticText
    Left = 176
    Top = 456
    Width = 77
    Height = 17
    Caption = 'Simulator Clock'
    TabOrder = 4
  end
end
