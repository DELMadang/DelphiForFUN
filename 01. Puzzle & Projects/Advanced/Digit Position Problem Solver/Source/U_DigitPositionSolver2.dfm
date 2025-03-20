object Form1: TForm1
  Left = 308
  Top = 90
  Width = 818
  Height = 620
  Caption = 'Digit Relationships Problem Solver Version 2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 16
    Top = 184
    Width = 169
    Height = 41
    AutoSize = False
    Caption = 'Variables (AA=First, BB=Second, etc.)'
    WordWrap = True
  end
  object ProblemLbl: TLabel
    Left = 216
    Top = 32
    Width = 214
    Height = 16
    Caption = 'Current Problem:  None loaded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 384
    Width = 82
    Height = 16
    Caption = 'For debugging'
  end
  object OpenBtn: TButton
    Left = 8
    Top = 56
    Width = 89
    Height = 25
    Caption = 'Open a case'
    TabOrder = 0
    OnClick = OpenBtnClick
  end
  object Solvebtn: TButton
    Left = 16
    Top = 136
    Width = 89
    Height = 25
    Caption = 'Solve it'
    TabOrder = 1
    OnClick = SolvebtnClick
  end
  object PageControl1: TPageControl
    Left = 208
    Top = 64
    Width = 577
    Height = 481
    ActivePage = TabSheet1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 569
        Height = 450
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            ' This is another experiment in writing a program to convert a ce' +
            'rtain type of story problem to'
          
            'algebraic equations. A previous "age problem" program solves pro' +
            'blems describing the'
          
            'relationship between the ages of two people.  The current projec' +
            't applies similar techniques '
          
            'to solving "digit relatioship" problems like this one from my cu' +
            'rrent "Mensa Puzzle-A-Day"'
          'calendar:'
          ''
          
            '"Find a six-digit number in which the first digit is two less th' +
            'an the fifth, the second digit is '
          
            'one more than the fourth, and the fifth digit is four less than ' +
            'the last.  The sum of the first and '
          
            'fourth digits equals the second, the sum of the third and last d' +
            'igits equals the second, and '
          'the sum of all the digits is 30."'
          ''
          
            'The syntax analysis is not very generalized but it is adequate t' +
            'o handle most of the age '
          
            'probems in this year'#39's calendar which were entered verbatim as "' +
            'Problem00.txt" through'
          '"Problem11.txt and included in the download file.'
          ''
          
            'The problems are converted in several stages and using an initia' +
            'lization file,'
          
            '"DigitProblemTables.ini",containing several word conversion sect' +
            'ions.  Briefly:'
          ''
          
            '1. Un-needed words and delimiters are removed based on "UnNeeded' +
            'Words" section.'
          
            '2. Names for the digits are identified.  Common initial captiali' +
            'zed words to ignore are in'
          
            '"FirstWord" section.  Digit position words ("first", "second", e' +
            'tc. which are not normally'
          
            'capitalized, but should be treated as variable names, are treate' +
            'd as such based on the'
          '"Capitalized" section.'
          
            '3. Numbers are converted to a standard text form using the "Numb' +
            'ers" section; "one" to "1",'
          
            '"twice" to "2*", etc. Similarly fraction denominator words ("hal' +
            'f", "third", "thirds", etc.) are'
          'idenified based on the "Denominators" section.'
          
            '4.Sentences are converted to a "canonical" form replacing names ' +
            'with "&V", whole numbers'
          
            'and fraction numerators with "&N", denominators with "&D".  Patt' +
            'erns in the "OpWords"'
          
            'section are tested against the canonical form and matches are re' +
            'placed with a corresponding'
          'text in equation form.'
          
            '5. Numeric and name identifers and then replaced with the origin' +
            'al values and the results'
          'displayed.'
          ''
          
            'There are some syntax/vocabulary problems which are solved by ha' +
            'rd coding rather than via '
          'table entries.'
          
            'The word "last", for example appears in the contexts of "equals ' +
            'the first plus the last" and'
          
            'also in the context of "equals the sum of the last 3 digits".  C' +
            'urrently "sum", "same" and '
          '"product" are hard coded.'
          ''
          
            'There are some unresolved parsing problems.   One is in identify' +
            'ing the beginning and ending '
          
            'of phrases which define equations.  The program uses comma ('#39','#39')' +
            ' as a reliable separator, but '
          
            'humans frequently omit the comma. So a phrase like "The first is' +
            ' the sum of the second and '
          
            'the third and the fourth equals the fifth" will not be correctly' +
            ' parsed unless the second "and" '
          
            'is preceded by a comma.  Another problem is our use of postion w' +
            'ords like "third" and '
          
            '"fourth" to indicate both position and as denominators in fracti' +
            'ons.  So a phrase like "The '
          
            'fourth digit is one fourth of the fifth" is much harder for a co' +
            'mputer to understand than it is for '
          'a human. '
          ''
          
            'For the restricted text forms represented by the included sample' +
            ' files, the program works'
          
            'quite well.  The resulting equations in 2 unknowns are easily so' +
            'lved algebraically.  Version 2'
          'added a search for numeric solutions to the equations found.'
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ' '
          ' ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object ProblemSheet: TTabSheet
      Caption = 'Problem'
      ImageIndex = 1
      object problem: TMemo
        Left = 56
        Top = 48
        Width = 473
        Height = 273
        TabOrder = 0
      end
    end
    object ParseSheet: TTabSheet
      Caption = 'Parsed results'
      ImageIndex = 2
      object SentenceDisplayMemo: TMemo
        Left = 16
        Top = 16
        Width = 537
        Height = 369
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object NameDisplay: TMemo
    Left = 16
    Top = 224
    Width = 169
    Height = 89
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 564
    Width = 802
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object LoadIniBtn: TButton
    Left = 32
    Top = 416
    Width = 161
    Height = 25
    Caption = 'Load a tables file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = LoadIniBtnClick
  end
  object BacktestBtn: TButton
    Left = 32
    Top = 456
    Width = 161
    Height = 25
    Caption = 'Backtest all cases'
    TabOrder = 6
    OnClick = BacktestBtnClick
  end
  object Stopfirst: TCheckBox
    Left = 16
    Top = 104
    Width = 185
    Height = 17
    Caption = 'Stop search at first solution'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Problems (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select a problem'
    Left = 680
    Top = 16
  end
  object OpenDialog2: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Tables files (*.ini*|*.ini|All files (*.*)|*.*'
    Title = 'Select a "Tables" file to load'
    Left = 720
    Top = 16
  end
end
