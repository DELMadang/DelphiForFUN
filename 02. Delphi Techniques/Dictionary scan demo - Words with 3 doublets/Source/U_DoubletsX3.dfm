object Form1: TForm1
  Left = 103
  Top = 117
  Width = 744
  Height = 600
  Caption = 'Decrypt v2.0 - Dictionary scan demo:  Find words with 3 doublets'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Searchbtn: TButton
    Left = 424
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 0
    OnClick = SearchbtnClick
  end
  object Memo1: TMemo
    Left = 80
    Top = 32
    Width = 305
    Height = 465
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This week'#39's (June 23, 2007) CarTalk '
      'puzzler:'
      ''
      '"There is only one word in the English '
      'language which contains 3 consecutive '
      'set of double letters.  What is the '
      'word?"'
      ' '
      'Here'#39's a 15 minute Delphi demo '
      'program with about 35 user written lines '
      'of code.  (Not including the few hours it '
      'will taking to document and publish the '
      'code :>).  '
      ''
      'The program uses our TDict dictionary '
      'class to search for the word in our '
      '50,000 word dictionary (Full,dic). In fact, '
      'it lists all words with 3 sets of double '
      'letters and flags the one where the 3 '
      'sets are all adjacent.'
      ''
      ''
      ''
      ' ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 549
    Width = 736
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
end
