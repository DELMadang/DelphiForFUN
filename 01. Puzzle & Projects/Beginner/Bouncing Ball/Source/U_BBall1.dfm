object Form1: TForm1
  Left = 245
  Top = 141
  Width = 572
  Height = 540
  Caption = 'Bouncing Ball'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poPrintToFit
  Scaled = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 30
    Top = 305
    Width = 51
    Height = 13
    Caption = 'Time scale'
  end
  object Label1: TLabel
    Left = 30
    Top = 207
    Width = 106
    Height = 13
    Caption = 'Coefficient of Elasticity'
  end
  object Panel1: TPanel
    Left = 257
    Top = 14
    Width = 224
    Height = 473
    Color = 16777088
    TabOrder = 0
    object Shape1: TShape
      Left = 98
      Top = 32
      Width = 31
      Height = 31
      Brush.Color = clBlue
      Shape = stCircle
    end
  end
  object DropBtn: TButton
    Left = 30
    Top = 98
    Width = 91
    Height = 31
    Caption = 'Drop the ball'
    TabOrder = 1
    OnClick = DropBtnClick
  end
  object ResetBtn: TButton
    Left = 30
    Top = 148
    Width = 92
    Height = 30
    Caption = 'Reset the ball'
    TabOrder = 2
    OnClick = ResetBtnClick
  end
  object TimescaleBar: TTrackBar
    Left = 30
    Top = 335
    Width = 148
    Height = 44
    Max = 50
    Orientation = trHorizontal
    PageSize = 5
    Frequency = 1
    Position = 25
    SelEnd = 0
    SelStart = 0
    TabOrder = 3
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object CEBar: TTrackBar
    Left = 30
    Top = 236
    Width = 150
    Height = 45
    Orientation = trHorizontal
    Frequency = 1
    Position = 8
    SelEnd = 0
    SelStart = 0
    TabOrder = 4
    TickMarks = tmBottomRight
    TickStyle = tsAuto
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 496
    Width = 564
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2000, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
