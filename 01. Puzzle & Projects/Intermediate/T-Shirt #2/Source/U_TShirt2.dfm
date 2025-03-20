object Form1: TForm1
  Left = 81
  Top = 49
  Width = 587
  Height = 480
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'T-Shirt #2 Problem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 288
    Top = 42
    Width = 97
    Height = 16
    Caption = 'Number of digits'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 32
    Top = 32
    Width = 217
    Height = 377
    Color = clYellow
    Lines.Strings = (
      'Find the smallest n digit number that equals '
      'the sum of the nth powers of each of it'#39's '
      'digits .'
      ' '
      'For example  371=3^3+7^3+1^3  (but that'#39's '
      'not the smallest).'
      ''
      '"Brute Force"  tries increasing n digit '
      'numbers until it finds one that meets the test.'
      ''
      '"Faster Brute Force" takes advantage of the '
      'fact that there are onlly 10 nth powers of the '
      'digits.  We can put these in a table and look '
      'them up instead of recalulating each time,  '
      'About 3 times faster,   '
      ''
      'Donald Knuth has described this "toy '
      'problem" * and gives results for n up to 12 or '
      '13.  (And in 1977!)  How did '
      'he do it?'
      ''
      '* Selected Papers on Computer Science, '
      'Donald E. Knuth, Cambridge Press')
    TabOrder = 0
  end
  object UpDown1: TUpDown
    Left = 425
    Top = 40
    Width = 9
    Height = 21
    Associate = Edit1
    Min = 1
    Max = 20
    Position = 3
    TabOrder = 1
    Wrap = False
  end
  object Edit1: TEdit
    Left = 400
    Top = 40
    Width = 25
    Height = 21
    TabOrder = 2
    Text = '3'
  end
  object Memo2: TMemo
    Left = 288
    Top = 192
    Width = 185
    Height = 105
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Brute1Btn: TButton
    Left = 288
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Brute Force'
    TabOrder = 4
    OnClick = Brute1BtnClick
  end
  object Brute2btn: TButton
    Left = 392
    Top = 80
    Width = 121
    Height = 25
    Caption = 'Faster Brute Force'
    TabOrder = 5
    OnClick = Brute2btnClick
  end
  object StopBtn: TButton
    Left = 288
    Top = 128
    Width = 225
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    OnClick = StopBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 579
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org'
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
