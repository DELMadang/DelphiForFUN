object Form1: TForm1
  Left = 118
  Top = 103
  AutoScroll = False
  AutoSize = True
  Caption = 'An Introduction to Pandigital Numbers  Version 3.1'
  ClientHeight = 635
  ClientWidth = 987
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 612
    Width = 987
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright 2002-2010  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 987
    Height = 612
    TabOrder = 1
    object Memo2: TMemo
      Left = 583
      Top = 30
      Width = 370
      Height = 555
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 10
      Top = 10
      Width = 551
      Height = 575
      ActivePage = TabSheet1
      TabOrder = 1
      OnChange = PageChangesExit
      object Introsheet: TTabSheet
        Caption = 'Introduction'
        object Memo1: TMemo
          Left = 15
          Top = 20
          Width = 514
          Height = 509
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '  ==>  Pandigital numbers contain all of the digits 0 through 9'
            'exactly once.  "Almost pandigital" numbers contain the digits 1'
            'through 9 exactly once.  As an  introduction to pandigital'
            'numbers,  here'#39's a program that solves sample 5 problems:'
            ''
            '  1. The smallest pandigtal number that is a perfect square.'
            ''
            '  2. A number and its square which together form an "Almost'
            'pandigital" number'
            ''
            
              '  3. A pandigital number in which each subset of the first N dig' +
              'its'
            'considered as an integer is exactly divisible by N.'
            ''
            
              '  4.  All  equations of the form a x b = c with the property tha' +
              't a, b,'
            'and c are integers and collectively they forrm an Almost'
            
              'pandigital number, i.e. they contain the digits 1 through 9 exac' +
              'tly'
            'once.'
            ''
            '  5.  Almost pandigital numbers, using digits 1 thru 9 only once'
            'each, whose square contain each digit 1 thru 9 twice.'
            ''
            
              '  6. Find integers X and Y which together form an Almost pandigi' +
              'tal'
            'number (between them they contain only the digits 1 through 9 '
            'exactly'
            'once)  and the sum of whose squares is also Almost pandigital,'
            '')
          ParentFont = False
          TabOrder = 0
        end
      end
      object Prob1Sheet: TTabSheet
        Caption = 'Problem 1'
        ImageIndex = 1
        object Memo3: TMemo
          Left = 15
          Top = 20
          Width = 341
          Height = 227
          Color = 7781118
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            ' Find the smallest pandigtal number '
            'that is a perfect square.'
            '  '
            'Just for the heck of it, lets find all '
            'pandigitals that are perfect squares.')
          ParentFont = False
          TabOrder = 0
        end
        object Problem1Btn: TButton
          Left = 17
          Top = 335
          Width = 248
          Height = 31
          Caption = 'Smallest pandigital that'#39's a square'
          TabOrder = 1
          OnClick = Problem1BtnClick
        end
        object LeadZeroBox: TCheckBox
          Left = 20
          Top = 281
          Width = 198
          Height = 21
          Caption = 'Allow leading zero'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
      object Prob2Sheet: TTabSheet
        Caption = 'Problem 2'
        ImageIndex = 2
        object Memo4: TMemo
          Left = 15
          Top = 20
          Width = 341
          Height = 227
          Color = 8454016
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            '  Find a number and it'#39's square which '
            'together form an "almost pandigital" '
            'number (digits 1 through 9  exactly '
            'once).'
            '')
          ParentFont = False
          TabOrder = 0
        end
        object Problem2Btn: TButton
          Left = 17
          Top = 271
          Width = 319
          Height = 31
          Caption = 'Split an "almost pandigital"  into N and N*N'
          TabOrder = 1
          OnClick = Problem2BtnClick
        end
      end
      object Prob3Sheet: TTabSheet
        Caption = 'Problem 3'
        ImageIndex = 3
        object Memo5: TMemo
          Left = 10
          Top = 20
          Width = 365
          Height = 257
          BorderStyle = bsNone
          Color = 16777088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            'Find all pandigital numbers with the '
            'property that for any N between 1 and 10, '
            'the first N digits form a number that is '
            'exactly  divisible by N.   '
            ''
            'I.E.  if the number is abcdefghijk then a is  '
            'divisible by 1, ab is divisible by 2,  abc is '
            'exactly divisible by 3, etc.  ')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object Problen3Btn: TButton
          Left = 10
          Top = 374
          Width = 92
          Height = 31
          Caption = 'Search'
          TabOrder = 1
          OnClick = Problen3BtnClick
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Problem4'
        ImageIndex = 4
        object Problem4Btn: TButton
          Left = 17
          Top = 335
          Width = 248
          Height = 31
          Caption = 'Find almost pandigital products'
          TabOrder = 0
          OnClick = Problem4BtnClick
        end
        object Memo6: TMemo
          Left = 15
          Top = 20
          Width = 370
          Height = 227
          Color = 8454143
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            ' Find all  equations of the form a x b = '
            'c with the property that a, b, and c are '
            'integers and collectively they forrm an '
            'almost pandigital number, i.e. they '
            'contain the digits 1 through 9 exactly '
            'once. ')
          ParentFont = False
          TabOrder = 1
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Problem 5'
        ImageIndex = 5
        object Memo7: TMemo
          Left = 15
          Top = 20
          Width = 370
          Height = 227
          Color = 13805311
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            'What is the smallest pandigital number, '
            'using digits 1 thru 9 only once each, '
            'whose square uses each digit 1 thru 9 '
            'twice?')
          ParentFont = False
          TabOrder = 0
        end
        object Problem5Btn: TButton
          Left = 7
          Top = 335
          Width = 457
          Height = 31
          Caption = 'Find  pandigital whose square is a double pandigital'
          TabOrder = 1
          OnClick = Problem5BtnClick
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Problem 6'
        ImageIndex = 6
        object Memo8: TMemo
          Left = 15
          Top = 20
          Width = 370
          Height = 165
          Color = 10282889
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Lines.Strings = (
            'Find integers X and Y which together form'
            'an Almost Pandigital number (between '
            'them they contain only the digits 1 through'
            '9 exactly once)  and the sum of whose '
            'squares is also Almost Pandigital, '
            '')
          ParentFont = False
          TabOrder = 0
        end
        object Problem6Btn: TButton
          Left = 7
          Top = 335
          Width = 457
          Height = 31
          Caption = 'Find  X, Y with X || Y and X^2 + Y^2 both Almost Pandigital'
          TabOrder = 1
          OnClick = Problem6BtnClick
        end
      end
    end
  end
end
