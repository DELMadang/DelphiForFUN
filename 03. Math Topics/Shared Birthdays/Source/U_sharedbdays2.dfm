object Form1: TForm1
  Left = 134
  Top = 88
  Width = 800
  Height = 600
  Caption = 'Shared birthday probabilities'
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
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 433
    Height = 489
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'Here'#39's a Delphi program that lists the probability that at least' +
        ' two '
      'people share a common birthday in a room containing N people.'
      ''
      
        'There are two columns of probabilities listed at right.  The fir' +
        'st column '
      'ignores leap years, the second column does consider Feb. 29th '
      
        'birthdays - changing the statistics only slightly, but making th' +
        'e solution '
      'considerably more difficult to understand.'
      ''
      'First the "No leap years" case:'
      ''
      
        'The phrase "at least" in probability problems is a cue to comput' +
        'e the '
      
        'probability of none and subtract that number rom 1.  In our case' +
        ', the '
      
        'probability that no 2 people share the same birthday out of  2, ' +
        'people '
      
        '[let'#39's call it P(2)],  is 364/365.  (My birthday is on one of th' +
        'e days, if you '
      'are not to share my day, you have 364 choices.)  Recall that by '
      
        'definition, probability of an outcome is the  number of cases wh' +
        'ere that '
      
        'outcome occurs divided by the total possible outcomes. For three' +
        ' '
      
        'people the probability of none shared  is P(3)=(364/365)*(363/36' +
        '5).  '
      
        'For 4 the probability is P(4)=P(3)*362/365. The first three guys' +
        ' '
      
        'eliminated 3 choices so I have to choose one of the 362 remainin' +
        'g '
      
        'days if I'#39'm not to share a birthday with any of them.  Etc, etc.' +
        ' etc.'
      ''
      
        'And again, the probability of shared birthdays is 1 - probabilit' +
        'y of no '
      'shared birthdays.'
      ''
      'If we want to acknowledge the existence of leap years the plot '
      'thickens considerably.  See  '
      
        'http://delphiforfun.org/programs/math_topics/shared_birthdays2.h' +
        'tm '
      'for more details.'
      ''
      ''
      ''
      ''
      ''
      '')
    ParentFont = False
    TabOrder = 0
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 792
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 
      'Copyright 2001, Gary Darby, Intellitech Systems Inc., www.Delphi' +
      'ForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object Memo2: TMemo
    Left = 488
    Top = 16
    Width = 289
    Height = 481
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      ' #      Prob. of shared b'#39'days'
      ' of     ************************'
      'people   No Leap Yr    Leap Year'
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
