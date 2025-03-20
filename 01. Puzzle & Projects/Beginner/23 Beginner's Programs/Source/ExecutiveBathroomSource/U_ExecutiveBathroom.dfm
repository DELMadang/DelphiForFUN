object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  Caption = 'The Executive Bathroom Problem'
  ClientHeight = 633
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 610
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 41
    Top = 54
    Width = 664
    Height = 227
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The entry code for the executive bathroom is a three-digit odd n' +
        'umber '
      
        'with no repeated  digits.  If you want to try to break in, what ' +
        'is the '
      
        'maximum number of entry codes you'#39'll have to try?  (Remember tha' +
        't '
      'three-digit  numbers cannot start with zero.)'
      ''
      'Source: The Mensa Puzzle Page-A-Day Calender for April 12, 2010.'
      ''
      
        'Click the Solve it" button to run the program which examines all' +
        ' 3-digit '
      'integers and counts odd numbers with no repeated digits.')
    ParentFont = False
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 40
    Top = 304
    Width = 665
    Height = 273
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'The Mensa Calendar derives it like this:'
      ''
      
        'There are 5 odd number choices for the third digit (1,3,5,7, or ' +
        '9).'
      ''
      
        'For each of these, there are 8 choices for the 1st digit (not 0 ' +
        'and not the '
      'chosen final digit).'
      ''
      
        'For each 1st and 3rd chosen, there are 8 choices for the 2nd dig' +
        'it (not the '
      '1st and not the 3rd).'
      ''
      'So in total, there are 5 x 8 x 8 = 320 valid entry codes!'
      '')
    ParentFont = False
    TabOrder = 2
    Visible = False
  end
  object SolveBtn: TButton
    Left = 732
    Top = 51
    Width = 86
    Height = 29
    Caption = 'Solve it'
    TabOrder = 3
    OnClick = SolveBtnClick
  end
end
