object Form1: TForm1
  Left = 194
  Top = 106
  Width = 696
  Height = 457
  Caption = 'Random Matching'
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
  object Label1: TLabel
    Left = 392
    Top = 32
    Width = 51
    Height = 13
    Caption = '# to match'
  end
  object TrialsBtn: TButton
    Left = 384
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Run trials'
    TabOrder = 0
    OnClick = TrialsBtnClick
  end
  object Memo1: TMemo
    Left = 376
    Top = 160
    Width = 305
    Height = 169
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Showdetail: TCheckBox
    Left = 384
    Top = 128
    Width = 185
    Height = 17
    Caption = 'Show first 100 trial results'
    TabOrder = 2
  end
  object TrialsBox: TRadioGroup
    Left = 536
    Top = 16
    Width = 129
    Height = 105
    Caption = 'Nbr of trials to run'
    ItemIndex = 0
    Items.Strings = (
      '100'
      '1,000'
      '10,000'
      '100,000')
    TabOrder = 3
  end
  object Memo2: TMemo
    Left = 24
    Top = 24
    Width = 337
    Height = 353
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's a problem published by Marilyn vos Savant in '
      'her "Ask Marilyn" column in Parade magazine of July 25, '
      '2004:'
      ''
      '"A clueless student faced a pop quiz - a list of 24 '
      'Presidents of the 19th century and another list of their '
      'terms of office, but scrambled.  The object was to match '
      'the President with his term.  He had to guess every time.  '
      'On average, how many terms would he guess '
      'correctly?"'
      ''
      'This program simulates the quiz results by checking and '
      'averaging scores for a large number of  random '
      'matching trials.  Values are reshuffled befoe each trial.'
      ''
      'By the way, is the number of items to be matched  '
      'significant?    Just for kicks you can change that value '
      'as well as the number of trials to run.'
      ''
      '(This program contains less than 40 lines of user written  '
      'Delphi code!)'
      ' ')
    ParentFont = False
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 403
    Width = 688
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
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object SpinEdit1: TSpinEdit
    Left = 448
    Top = 27
    Width = 49
    Height = 22
    MaxValue = 50
    MinValue = 1
    TabOrder = 6
    Value = 24
  end
end
