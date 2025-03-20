object Form1: TForm1
  Left = 185
  Top = 79
  Width = 478
  Height = 395
  Caption = 'Big factorials '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 30
    Top = 39
    Width = 194
    Height = 20
    Caption = 'Enter N between 1 and 999'
  end
  object TLabel
    Left = 85
    Top = 163
    Width = 4
    Height = 20
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 238
    Top = 35
    Width = 43
    Height = 28
    TabOrder = 0
    Text = '10'
  end
  object Factout: TMemo
    Left = 32
    Top = 85
    Width = 404
    Height = 228
    Lines.Strings = (
      '1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ComputeBtn: TButton
    Left = 317
    Top = 35
    Width = 116
    Height = 30
    Caption = 'Compute  N!'
    TabOrder = 2
    OnClick = ComputeBtnClick
  end
  object UpDown1: TUpDown
    Left = 281
    Top = 35
    Width = 12
    Height = 28
    Associate = Edit1
    Min = 1
    Max = 999
    Position = 10
    TabOrder = 3
    Wrap = False
  end
end
