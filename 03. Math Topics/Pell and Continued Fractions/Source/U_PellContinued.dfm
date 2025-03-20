object Form1: TForm1
  Left = 192
  Top = 114
  Width = 806
  Height = 480
  Caption = 'Continued Fractions and Pell'#39's Equation'
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
    Left = 144
    Top = 144
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 384
    Top = 24
    Width = 23
    Height = 20
    Caption = 'N='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 337
    Height = 329
    Color = 14548991
    Lines.Strings = (
      'Continued Fractions have many applications including the two'
      'presented here:'
      ''
      '1. Square roots may be estimated to arbitrary accuracy by '
      'calculating successive "convergents", the numerator and '
      
        'denominator of the terms of the continued fraction calculated so' +
        ' '
      'far.  Large values of numerator and  enominaotr can produce '
      'estimates of irrational sqaure roots to any desired degree of '
      'accuracy.  (up to 100 digits in this version)'
      ''
      
        '2. Diophantine equations are those whose solutons are restricted' +
        ' '
      
        'to integer values.  One in particular, Pells'#39' Equation, has been' +
        ' '
      'studied since ancient times.  It asks for two postive nonsquare '
      'integers with some mutiple of the square of one being one less '
      'than the square of the other,  X^2 - NY^2 = 1.  For '
      'example, when N=13, the minimal solution in x is 649^2 - '
      '13 x 180^2 = 1.'
      ''
      'N may never be a square since then NY^2 would be square and '
      'the difference of two sqaiues can never = 1.'
      ''
      'Search http://mathworld.wolfram.com/  for "Continued fractions" '
      'oe "Pell'#39's Equation" for more information.')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object PellBtn: TButton
    Left = 512
    Top = 56
    Width = 249
    Height = 25
    Caption = 'Smallest integer soluion for x^2-Ny^2 = 1'
    TabOrder = 1
    OnClick = PellBtnClick
  end
  object SqrtBtn: TButton
    Left = 512
    Top = 24
    Width = 249
    Height = 25
    Caption = 'Successive approximations for sqrt of N'
    TabOrder = 2
    OnClick = SqrtBtnClick
  end
  object Memo2: TMemo
    Left = 368
    Top = 112
    Width = 417
    Height = 241
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
  object SpinButton1: TSpinButton
    Left = 736
    Top = 144
    Width = 20
    Height = 25
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 4
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
  end
  object NewValUpDown: TUpDown
    Left = 457
    Top = 24
    Width = 16
    Height = 21
    Associate = NewValEdt
    Min = 2
    Max = 10000
    Position = 2
    TabOrder = 5
    Wrap = False
    OnChangingEx = NewValUpDownChangingEx
  end
  object NewValEdt: TEdit
    Left = 408
    Top = 24
    Width = 49
    Height = 21
    TabOrder = 6
    Text = '2'
    OnKeyPress = NewValEdtKeyPress
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 798
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 7
    OnClick = StaticText1Click
  end
end
