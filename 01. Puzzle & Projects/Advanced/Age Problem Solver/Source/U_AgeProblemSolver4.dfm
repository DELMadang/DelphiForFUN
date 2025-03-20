object Form1: TForm1
  Left = 308
  Top = 90
  Width = 1041
  Height = 786
  Caption = 'Age Problem Solver Version 4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object Label1: TLabel
    Left = 28
    Top = 234
    Width = 50
    Height = 18
    Caption = 'Names'
  end
  object ProblemLbl: TLabel
    Left = 243
    Top = 36
    Width = 214
    Height = 16
    Caption = 'Current Problem:  None loaded'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 28
    Top = 432
    Width = 180
    Height = 105
    AutoSize = False
    Caption = 
      'For debugging: Enable loading and back-testing  a trialt  versio' +
      'n of the parsing tables  used to convert text to equations.'
    WordWrap = True
  end
  object Solvebtn: TButton
    Left = 28
    Top = 90
    Width = 141
    Height = 28
    Caption = 'Solve it'
    TabOrder = 0
    OnClick = SolvebtnClick
  end
  object NameDisplay: TMemo
    Left = 28
    Top = 252
    Width = 143
    Height = 100
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 721
    Width = 1023
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object LoadIniBtn: TButton
    Left = 28
    Top = 548
    Width = 181
    Height = 28
    Caption = 'Load a tables file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = LoadIniBtnClick
  end
  object BacktestBtn: TButton
    Left = 28
    Top = 585
    Width = 181
    Height = 28
    Caption = 'Backtest all cases'
    TabOrder = 4
    OnClick = BacktestBtnClick
  end
  object PageControl1: TPageControl
    Left = 216
    Top = 79
    Width = 793
    Height = 618
    ActivePage = IntroSheet
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 785
        Height = 584
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            ' This is an experiment in writing a program to solve "age" type ' +
            'story problems by oaprsing the text into algebraic '
          
            'equations and then solving them. The "age" problem stories  defi' +
            'ne relationships between the ages of two people. '
          
            ' The sample used here appeared in recent editions of our 2007 "M' +
            'ensa Puzzle-A-Day" calendar.  Here'#39's an '
          'example:'
          ''
          
            '"A year ago, Gary was twice as old as Ron is now.  In four more ' +
            'years, Ron will be as old as Gary is now.  Neither '
          'one is yet a teenager. How old are Gary and Ron now?"'
          ''
          
            'The syntax analysis is not comprehensove but it is adequate to h' +
            'andle the 10 age probems in the 2007 year'#39's '
          
            'calendar.  The text were entered verbatim as "AgeTest1.txt" thro' +
            'ugh "Agetest10.txt" files which are included here.  The '
          
            'problems are converted in several stages and using a initializat' +
            'ion file, "AgeProblemTables.ini, containing several word '
          'conversion sections.  Briefly, the process is:'
          ''
          
            '1. Un-needed words and delimiters are removed based on "UnNeeded' +
            'Words" section.'
          ''
          
            '2. Names of the people are identified.  Common initial captializ' +
            'ed words to ignore are in "FirstWord"'
          
            'section.  Certain other words (e.g. grandfather), which are not ' +
            'capitalized, but should be treated as names, are '
          'treated as names based on the "Capitalized" section.'
          ''
          
            '3. Numbers are converted to a standard text form using the "Numb' +
            'ers" section; "one" to "1", "twice" to "2*", etc.'
          
            'Similarly fraction denominator words ("half", "third", "thirds",' +
            ' etc.) are idenified based on the'
          '"Denominators" section.'
          ''
          
            '4.Sentences are converted to a "canonical" form replacing names ' +
            'with "&V", whole numbers and fraction'
          
            'numerators with "&N", denominators with "&D".  Patterns in the "' +
            'OpWords" section are tested against the'
          
            'canonical  form and matches are replaced with a corresponding te' +
            'xt in equation form.'
          ''
          
            '5.Numeric and name identifers and then replaced with the origina' +
            'l values and the results displayed.'
          ''
          
            'For the restricted text forms represented by the included sample' +
            ' files, the program works quite well.'
          
            'The resulting 2 equations in 2 unknowns are easily solved algebr' +
            'aically.  Version 3 adds a search for '
          'numeric  solutions to the equations for each equation pair.'
          ''
          ''
          ''
          ''
          ' ')
        ParentFont = False
        TabOrder = 0
      end
    end
    object ProblemSheet: TTabSheet
      Caption = 'Problem'
      ImageIndex = 1
      object problem: TMemo
        Left = 69
        Top = 59
        Width = 582
        Height = 336
        TabOrder = 0
      end
    end
    object ParseSheet: TTabSheet
      Caption = 'Parsed results'
      ImageIndex = 2
      object SentenceDisplayMemo: TMemo
        Left = 20
        Top = 20
        Width = 661
        Height = 454
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object OpenBtn: TButton
    Left = 28
    Top = 33
    Width = 144
    Height = 30
    Caption = 'Load a problem'
    TabOrder = 6
    OnClick = OpenBtnClick
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
