object Form1: TForm1
  Left = 4
  Top = 12
  Width = 697
  Height = 493
  Caption = 'Fibonacci Sunflowers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 256
    Top = 8
    Width = 425
    Height = 425
  end
  object DrawBtn: TButton
    Left = 8
    Top = 432
    Width = 99
    Height = 25
    Caption = 'Draw Sunflower'
    TabOrder = 0
    OnClick = DrawBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 233
    Height = 329
    Color = clYellow
    Lines.Strings = (
      'A Fibonacci series of integers starts with 0,1 and '
      'each member thereafter is the sum of the '
      'previous two.  Thus 0,1,1,2,3,5,8,13,21.. etc.'
      ''
      'The ratio of any two consectutive Fibonacci '
      'numbers approaches the "Golden Ratio",  '
      '(1+sqrt(5))/2 = 1.618033... , commonly denoted '
      'by the Greek letter Phi (pronounced "fee").'
      ''
      'The Golden Ratio has the unique property that  '
      'Phi-1=1/Phi   and appears often in art and '
      'nature.'
      ''
      'In particular, sunflowers seeds tend to be '
      'displaced from each other by Phi (or identically, '
      'Phi-1, or 1/Phi) fraction of a circle, '
      'approximately 222.5 degrees.  For common '
      'sized sunflower heads, the approximations of phi '
      'represented by 21/34 and 34/55 are close '
      'enough to phi, (21/34  < phi and 34/55 >phi), '
      'that we see the optical illlusion of spirals '
      'overlapping and moving in opposite directions.'
      ''
      'Definitely worth further investigation.'
      ''
      '')
    TabOrder = 1
  end
  object RotateRBox: TRadioGroup
    Left = 8
    Top = 344
    Width = 145
    Height = 81
    Caption = 'Rotate for each seed'
    ItemIndex = 0
    Items.Strings = (
      '360*Phi degrees'
      '360*(21/34) degress '
      '360*(34/55) degrees')
    TabOrder = 2
  end
  object StyleBox: TRadioGroup
    Left = 160
    Top = 344
    Width = 89
    Height = 81
    Caption = 'Style'
    ItemIndex = 0
    Items.Strings = (
      'Fixed seed '
      'Increasing ')
    TabOrder = 3
  end
end
