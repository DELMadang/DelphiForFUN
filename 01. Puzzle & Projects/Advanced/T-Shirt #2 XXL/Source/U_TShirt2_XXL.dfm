object Form1: TForm1
  Left = 136
  Top = 55
  Width = 765
  Height = 503
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
    Left = 352
    Top = 18
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
  object Countlbl: TLabel
    Left = 352
    Top = 400
    Width = 53
    Height = 13
    Caption = 'Run Stats: '
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 321
    Height = 425
    Color = clYellow
    Lines.Strings = (
      'Find the smallest N digit number that equals the sum of the Nth '
      
        'powers of each of it'#39's digits . For example  371=3^3+7^3+1^3  (b' +
        'ut '
      'that'#39's  not the smallest 3 digit number).'
      ''
      
        '"Brute Force"  tries increasing N digit numbers until it finds o' +
        'ne that '
      'meets the test.'
      ''
      '"Faster Brute Force" uses the fact that there are onlly 10 Nth '
      
        'powers of the digits.  We can put these in a table and look them' +
        ' '
      
        'up instead of recalculating each time,  About 2 times faster.   ' +
        ' '
      ''
      
        '"Multisets"  takes advantage of the fact that the order of the d' +
        'igits '
      
        'is not significant.  So if we have already computed the sum of 5' +
        'th '
      'powers for the number 12345, we don'#39't have to recompute it to '
      
        'check 54321 or any of the other 119 permutaions of these 5 digit' +
        's.'
      ''
      '"Big Numbers" uses an optimized Multisets technique for numbers '
      
        'over 19 digits, slower but it works.  It might take a day or so ' +
        'to find '
      
        'them all.  See the code or go to http://delphiforfun.org for mor' +
        'e '
      'details of the method.'
      ''
      'There are  88 of these numbers altogether, ranging from 1 to 39 '
      
        'digits in length. They are called Armstrong numbers or Pluperfec' +
        't '
      
        'Digital Invariants (PPDI'#39's).    At least one PPDI is a prime num' +
        'ber.  '
      'Want to find it?'
      ''
      
        'Donald Knuth has described this  problem in an article " Are Toy' +
        ' '
      
        'Problems Useful?"  and gives   results for N up to 12 or 13.  (A' +
        'nd in '
      
        '1977!)  How did he do it?  (Selected Papers on Computer Science,' +
        ' '
      ' Donald E. Knuth,  Cambridge Press)')
    TabOrder = 0
  end
  object UpDown1: TUpDown
    Left = 489
    Top = 40
    Width = 9
    Height = 21
    Associate = Edit1
    Min = 1
    Max = 40
    Position = 3
    TabOrder = 1
    Wrap = False
  end
  object Edit1: TEdit
    Left = 464
    Top = 16
    Width = 25
    Height = 21
    TabOrder = 2
    Text = '3'
  end
  object Memo2: TMemo
    Left = 352
    Top = 216
    Width = 393
    Height = 169
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Brute1Btn: TButton
    Left = 352
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Brute Force'
    TabOrder = 4
    OnClick = Brute1BtnClick
  end
  object Brute2btn: TButton
    Left = 456
    Top = 56
    Width = 193
    Height = 25
    Caption = 'Faster Brute Force'
    TabOrder = 5
    OnClick = Brute2btnClick
  end
  object StopBtn: TButton
    Left = 352
    Top = 176
    Width = 297
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    OnClick = StopBtnClick
  end
  object MultiSetsBtn: TButton
    Left = 352
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Multi-Sets'
    TabOrder = 7
    OnClick = MultiSetsBtnClick
  end
  object BigIntsBtn: TButton
    Left = 456
    Top = 96
    Width = 193
    Height = 25
    Caption = 'Big Numbers (up to 40 digits)'
    TabOrder = 8
    OnClick = BigIntsBtnClick
  end
  object SearchAllBtn: TButton
    Left = 352
    Top = 136
    Width = 297
    Height = 25
    Caption = 'Find all 88 Armstrong numbers  (1-39 digits in length) '
    TabOrder = 9
    OnClick = SearchAllBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 452
    Width = 757
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
end
