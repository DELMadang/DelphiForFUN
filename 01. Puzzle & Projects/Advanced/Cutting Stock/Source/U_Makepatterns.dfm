object Form1: TForm1
  Left = 328
  Top = 187
  Width = 870
  Height = 427
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 448
    Top = 360
    Width = 90
    Height = 16
    Caption = 'Pattern count ='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object PartsGrid: TStringGrid
    Left = 40
    Top = 80
    Width = 161
    Height = 145
    ColCount = 2
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    TabOrder = 0
  end
  object SupplyGrid: TStringGrid
    Left = 40
    Top = 248
    Width = 177
    Height = 120
    ColCount = 2
    FixedCols = 0
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 448
    Top = 24
    Width = 385
    Height = 329
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object PatternBtn: TButton
    Left = 272
    Top = 88
    Width = 129
    Height = 25
    Caption = 'Generate patterns'
    TabOrder = 3
    OnClick = PatternBtnClick
  end
  object LoadcaseBtn: TButton
    Left = 272
    Top = 40
    Width = 129
    Height = 25
    Caption = 'Load a case'
    TabOrder = 4
    OnClick = LoadcaseBtnClick
  end
  object Showcollapsed: TCheckBox
    Left = 240
    Top = 152
    Width = 177
    Height = 17
    Caption = 'Show collapsed partitions'
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    Left = 816
    Top = 16
  end
end
