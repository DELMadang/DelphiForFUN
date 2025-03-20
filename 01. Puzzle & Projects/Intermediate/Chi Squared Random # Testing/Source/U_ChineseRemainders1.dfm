object Form1: TForm1
  Left = 40
  Top = 47
  Width = 557
  Height = 285
  Caption = 'Chinese Remainders'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 328
    Top = 184
    Width = 3
    Height = 13
  end
  object SolveBtn: TButton
    Left = 328
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object StringGrid1: TStringGrid
    Left = 328
    Top = 8
    Width = 209
    Height = 113
    ColCount = 2
    FixedCols = 0
    RowCount = 4
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    ColWidths = (
      107
      95)
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 265
    Height = 233
    Color = clYellow
    Lines.Strings = (
      'From Mensa (c) Puzzle Calendar for October 18, '
      '2001'
      '"What is the smallest number which, when '
      'divided by 6, has a remainder of 5, when divided '
      'by 5 has a remainder of 4 and when divided by 4 '
      'leaves a remainder of 3?"'
      ''
      'This is one a class of problems called "Chinese '
      'Remainder Problems" .  The theorem which '
      'proves that a unique smallest solution exists is '
      'called the '#39'Chinese Remainder Theroem".  '
      ''
      'In this program, we'#39'll just solve it by trial and error.'
      '________________'
      'Gary Darby'
      'www.DelphiForFun.org'
      '________________')
    TabOrder = 2
  end
end
