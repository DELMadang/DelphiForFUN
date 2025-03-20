object Form1: TForm1
  Left = 390
  Top = 191
  AutoScroll = False
  Caption = '3n+1 Problem'
  ClientHeight = 759
  ClientWidth = 853
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 19
  object Label1: TLabel
    Left = 544
    Top = 48
    Width = 90
    Height = 19
    Caption = 'Low N Value'
  end
  object Label2: TLabel
    Left = 544
    Top = 80
    Width = 94
    Height = 19
    Caption = 'High N Value'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 736
    Width = 853
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
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
    Left = 24
    Top = 6
    Width = 489
    Height = 715
    Color = 13172735
    Lines.Strings = (
      'Here is Problem 1 of Volume 1 of a set of thousands of ACM '
      'programming contest problems viewable from the "Browse '
      'Problems" link at http://uva.onlinejudge.org/index.php'
      ''
      '----------------------------------------------------------'
      'Consider the following algorithm:'
      ''
      '       '#9'1.  input n'
      '       '#9'2.  print n'
      '       '#9'3.  if n = 1 then STOP'
      '       '#9'4.  if n is odd then n = 3n+1'
      '       '#9'5.  else n = n/2'
      '       '#9'6.  GOTO 2'
      ''
      'Given the input 22, the following sequence of numbers will be '
      'printed 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1'
      ''
      
        'It is conjectured that the algorithm above will terminate (when ' +
        'a '
      
        '1 is printed) for any integral input value. Despite the simplici' +
        'ty '
      
        'of the algorithm, it is unknown whether this conjecture is true.' +
        ' '
      
        'It has been verified, however, for all integers n such that 0 < ' +
        'n '
      '< 1,000,000 (and, in fact, for many more numbers than this.)'
      ''
      'Given an input n, it is possible to determine the number of '
      'numbers printed (including the 1). For a given n this is called '
      
        'the cycle-length of n. In the example above, the cycle length of' +
        ' '
      '22 is 16.'
      ''
      'For any two numbers i and j you are to determine the '
      'maximum cycle length over all numbers between i and j.'
      '--------------------------------------'
      ''
      'The "3n+1" problem is also known as the "Collatz Conjecture": '
      'of which more information is available at Wikipedia and '
      'elsewhere.on the Web')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object SeatchBtn: TButton
    Left = 540
    Top = 115
    Width = 277
    Height = 29
    Caption = 'Find max cycle length in this range'
    TabOrder = 2
    OnClick = SeatchBtnClick
  end
  object Edit1: TEdit
    Left = 640
    Top = 40
    Width = 121
    Height = 27
    TabOrder = 3
    Text = '1'
  end
  object Edit2: TEdit
    Left = 648
    Top = 80
    Width = 121
    Height = 27
    TabOrder = 4
    Text = '100'
  end
  object Memo2: TMemo
    Left = 536
    Top = 168
    Width = 305
    Height = 457
    ScrollBars = ssVertical
    TabOrder = 5
  end
end
