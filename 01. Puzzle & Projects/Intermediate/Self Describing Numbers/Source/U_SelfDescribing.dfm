object Form1: TForm1
  Left = 192
  Top = 133
  Width = 955
  Height = 664
  Caption = 'Self describing integers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  object countlbl: TLabel
    Left = 631
    Top = 212
    Width = 10
    Height = 24
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 542
    Top = 207
    Width = 80
    Height = 40
    AutoSize = False
    Caption = 'Value being checked'
    WordWrap = True
  end
  object SearchBtn: TButton
    Left = 630
    Top = 49
    Width = 129
    Height = 31
    Caption = 'Search this length'
    TabOrder = 0
    OnClick = SearchBtnClick
  end
  object Memo1: TMemo
    Left = 798
    Top = 39
    Width = 227
    Height = 336
    Lines.Strings = (
      'Results display here')
    TabOrder = 1
  end
  object StopBtn: TButton
    Left = 630
    Top = 148
    Width = 129
    Height = 30
    Caption = 'Stop'
    TabOrder = 2
    OnClick = StopBtnClick
  end
  object NbrLen: TSpinEdit
    Left = 551
    Top = 49
    Width = 51
    Height = 26
    MaxValue = 10
    MinValue = 1
    TabOrder = 3
    Value = 4
  end
  object SearchAllBtn: TButton
    Left = 630
    Top = 98
    Width = 129
    Height = 31
    Caption = 'Search All'
    TabOrder = 4
    OnClick = SearchAllBtnClick
  end
  object Memo2: TMemo
    Left = 20
    Top = 30
    Width = 454
    Height = 493
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Self-describing numbers:'
      ''
      'There are several versions of integers that may be '
      'called "self-describing".  Here is the definition for the '
      'type we are searching for in this program.'
      ''
      'Integers of a specified length, N,  with the property '
      'that,  when digit positions are labeled 0 to N-1, the '
      'digit in each position is equal to the number of times '
      'that that digit appears in the number.'
      ''
      'So, for example, 1210 is a four digit self describing '
      'number because position "0" has value 1 and there '
      'is one 0 in the number; position "1" has value 2 and '
      'there are two 1'#39' s in the number, position "2" has '
      'value 1 and there is one 2, and position "3" has '
      'value 0 and there are zero 3'#39's.'
      ''
      'Searching for the maximum length, 10 digits, may '
      'take several hours, but you should be able to '
      'recognize a pattern in the shorter results and '
      '"guess" the 10 digit answer!  (Hint: Start by guessing '
      'the number of zeros and filling in the rest of the digits '
      'from there.)'
      ' ')
    ParentFont = False
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 574
    Width = 1025
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
