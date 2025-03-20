object Form1: TForm1
  Left = 192
  Top = 120
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 256
    Top = 128
    Width = 123
    Height = 13
    Caption = 'Unused Digits (a,b,c,d,e,f)'
  end
  object Label2: TLabel
    Left = 256
    Top = 72
    Width = 30
    Height = 13
    Caption = 'Result'
  end
  object Edit1: TEdit
    Left = 256
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '1,2,3,5,7,9'
  end
  object Edit2: TEdit
    Left = 256
    Top = 88
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '864'
  end
  object Button1: TButton
    Left = 256
    Top = 192
    Width = 75
    Height = 25
    Caption = 'abc+def'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 408
    Top = 40
    Width = 185
    Height = 249
    Lines.Strings = (
      'Solutions display here')
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 24
    Top = 24
    Width = 217
    Height = 225
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Find all solutions where the '
      'sum of two numbers equals '
      '864.  And by the way, the '
      'solution, including the "864" '
      'sum must contain all of the '
      'digits 1 through 9 exactly '
      'once.'
      ''
      'Other sums to try: 594, 783, '
      '675, 927 ')
    ParentFont = False
    TabOrder = 4
  end
end
