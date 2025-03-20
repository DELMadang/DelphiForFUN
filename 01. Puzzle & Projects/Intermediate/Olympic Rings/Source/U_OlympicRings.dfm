object Form1: TForm1
  Left = 89
  Top = 84
  Width = 638
  Height = 451
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Olympic Rings'
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
  object Image1: TImage
    Left = 80
    Top = 176
    Width = 473
    Height = 241
  end
  object Solvebtn: TButton
    Left = 376
    Top = 16
    Width = 179
    Height = 25
    Caption = 'Solve'
    TabOrder = 0
    OnClick = SolvebtnClick
  end
  object Memo1: TMemo
    Left = 80
    Top = 16
    Width = 273
    Height = 145
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'The five Olympic rings overlap to create 9 '
      'separate  areas.  Assign one of the digits 1 '
      'through 9 to each of the areas so that the '
      'numbers in each ring sum to the same value.'
      ''
      'There are several unique solutions.  Try to '
      'find at least one on your own before pressing '
      'the "Solve" button.'
      '.')
    ParentFont = False
    TabOrder = 1
  end
  object PrintBtn: TButton
    Left = 376
    Top = 56
    Width = 177
    Height = 25
    Caption = 'Print'
    TabOrder = 2
    OnClick = PrintBtnClick
  end
end
