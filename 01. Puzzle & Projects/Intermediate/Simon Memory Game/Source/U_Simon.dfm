object frmMain: TfrmMain
  Left = 324
  Top = 197
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Simon'
  ClientHeight = 365
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblCount: TLabel
    Left = 155
    Top = 296
    Width = 42
    Height = 13
    Caption = 'Count :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblCount2: TLabel
    Left = 203
    Top = 296
    Width = 8
    Height = 13
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 104
    Top = 144
    Width = 95
    Height = 13
    Caption = 'Top 5 High Scores :'
  end
  object Label3: TLabel
    Left = 200
    Top = 8
    Width = 23
    Height = 13
    Caption = 'Slow'
  end
  object Label1: TLabel
    Left = 104
    Top = 8
    Width = 20
    Height = 13
    Caption = 'Fast'
  end
  object Speedbar: TTrackBar
    Left = 112
    Top = 24
    Width = 102
    Height = 25
    LineSize = 50
    Max = 1000
    Min = 100
    Orientation = trHorizontal
    PageSize = 50
    Frequency = 1
    Position = 500
    SelEnd = 0
    SelStart = 0
    TabOrder = 6
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = SpeedbarChange
  end
  object btnStart: TButton
    Left = 163
    Top = 264
    Width = 55
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object pnlLights: TPanel
    Left = 8
    Top = 8
    Width = 89
    Height = 297
    BorderStyle = bsSingle
    Color = clWhite
    TabOrder = 1
    object shpRedLight: TShape
      Tag = 1
      Left = 8
      Top = 8
      Width = 65
      Height = 65
      Brush.Color = clMaroon
      Pen.Width = 5
      Shape = stCircle
      OnMouseDown = shpMouseDown
    end
    object shpPurpleLight: TShape
      Tag = 2
      Left = 8
      Top = 80
      Width = 65
      Height = 65
      Brush.Color = clPurple
      Pen.Width = 5
      Shape = stCircle
      OnMouseDown = shpMouseDown
    end
    object shpGreenLight: TShape
      Tag = 3
      Left = 8
      Top = 152
      Width = 65
      Height = 65
      Brush.Color = clGreen
      Pen.Width = 5
      Shape = stCircle
      OnMouseDown = shpMouseDown
    end
    object shpBlueLight: TShape
      Tag = 4
      Left = 8
      Top = 224
      Width = 65
      Height = 65
      Brush.Color = clNavy
      Pen.Width = 5
      Shape = stEllipse
      OnMouseDown = shpMouseDown
    end
  end
  object cbxSound: TCheckBox
    Left = 104
    Top = 56
    Width = 57
    Height = 17
    Caption = 'Sound'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object cbxLights: TComboBox
    Left = 104
    Top = 88
    Width = 113
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'Circle'
    OnChange = cbxLightsChange
    Items.Strings = (
      'Square'
      'RoundRect'
      'Circle')
  end
  object lbxScores: TListBox
    Left = 104
    Top = 160
    Width = 105
    Height = 73
    ItemHeight = 13
    Items.Strings = (
      '')
    TabOrder = 4
  end
  object btnClear: TButton
    Left = 102
    Top = 264
    Width = 55
    Height = 25
    Caption = 'Clear'
    TabOrder = 5
    OnClick = btnClearClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 349
    Width = 278
    Height = 16
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = 'www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 7
    OnClick = StaticText1Click
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 332
    Width = 278
    Height = 17
    Align = alBottom
    Caption = 'Copyright  © 2004, Gary Darby, Shane A. Holmes'
    TabOrder = 8
  end
end
