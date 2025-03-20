object Form1: TForm1
  Left = 436
  Top = 158
  Width = 1203
  Height = 755
  Caption = 'How many squares?  Version 2.2'
  Color = 15790320
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1195
    Height = 695
    ActivePage = IntroSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 40
        Top = 16
        Width = 1057
        Height = 601
        Color = 13172735
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Here'#39's an investigation from the latest addition to my library o' +
            'f math & puzzle books: "Challenging Math '
          'Problems", Terry Stickels, Dover Publications, 2015.'
          ''
          
            'Problem #12 in the book shows 24 matchsticks formed into a 3x3 g' +
            'rid and asks about the fewest sticks that can '
          
            'be removed to eliminate all complete squares of any size.  Actua' +
            'lly one solution is given and the real question is '
          
            '"What is the minimum number matchsticks that need to be removed ' +
            'from a 4x4 gtid of 40 matchsticks to leave no '
          
            'squares of any size?"  This program will not tell you directly, ' +
            'but will let you play around by adding and removing '
          
            'sticks from the grid with feedback at each step about the number' +
            ' of squares remaining.'
          ''
          
            'As regular viewers know, mathematics is among my interests thus ' +
            'I decided to look into the properties of integer '
          
            'sequences formed by increasing grid sizes.  An excellent resourc' +
            'e for this is the Online Encyclopedia of Integer '
          
            'Sequences"  (link below).  I tracked "Number of matchsticks", "N' +
            'umber of squares of all sizes", and "Minmum '
          
            '# of matchsticks removed for a zero square solution".  It'#39's easy' +
            ' to get values for 1x1, 2x2, and 3x3 grids and the '
          
            'program will provide values for the Matchstick and Square counts' +
            ' for larger sizes.  Surprisingly, all three '
          
            'sequences exist and have names in the OEIS library.  A search on' +
            ' the first few terms will find them with an large '
          'amount of additional detail.'
          ''
          'Check it out and have fun!'
          ''
          
            'Version 2.0 adds the ability to view remaining squares after eac' +
            'h move or on request.  Also grids can now be '
          
            'saved and restored in configuration file "HowManySquares.ini"  B' +
            'oth features are helpful when working on larger'
          
            'grids.  V2.1 changes the way that fewest removals solutions ae c' +
            'alculated.  Best 4x4 solution can be found with 9'
          'matchstick removals!'
          ''
          
            'Version 2.2 changes the formauls for the "best" solution (the mi' +
            'nimum number of matchstick removals to leave no '
          
            'squares of any size).  The old formula for an N x N grid was (N*' +
            '(N-1))/2. The new formula is Ceiling((N*(N-1/2))/2).  '
          
            '("Ceiling(X)" is the smallest integer > X).  This is an experima' +
            'ntal formula wich returns the lowest locally known '
          'solution values for 4x4 (9) and 5x5 (14) grids.')
        ParentFont = False
        ParentShowHint = False
        ScrollBars = ssVertical
        ShowHint = False
        TabOrder = 0
      end
      object StaticText2: TStaticText
        Left = 0
        Top = 639
        Width = 1187
        Height = 23
        Cursor = crHandPoint
        Align = alBottom
        Caption = ' Online Encyclopedia of Integer Sequences'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        TabOrder = 1
        OnClick = StaticText2Click
      end
    end
    object CreateSheet: TTabSheet
      Caption = ' Play  '
      ImageIndex = 2
      object CountLbl: TLabel
        Left = 24
        Top = 496
        Width = 401
        Height = 81
        AutoSize = False
        Caption = 'CountLbl'
        Color = 15790320
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        WordWrap = True
      end
      object Image1: TImage
        Left = 512
        Top = 32
        Width = 609
        Height = 617
        OnMouseDown = Image1MouseDown
      end
      object Memo4: TMemo
        Left = 24
        Top = 16
        Width = 425
        Height = 289
        Color = 13172735
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          '24 match sticks can be used form a square'
          '3x3 grid containing 14 squares of all sizes.'
          'All squares can be be eliminated by removing'
          'just 6 matchsticks (edges).   If that is too'
          'easy, what is the minimum number to remove'
          'to eliminate all squares in a 4x4 grid?'
          ''
          'Click matchsticks or edge markers to remove '
          'or add them.'
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          ''
          '')
        ParentFont = False
        TabOrder = 0
      end
      object AddEdgesBtn: TButton
        Left = 248
        Top = 328
        Width = 177
        Height = 25
        Caption = 'Add all matchsticks'
        TabOrder = 1
        OnClick = AddEdgesBtnClick
      end
      object GroupBox1: TGroupBox
        Left = 24
        Top = 320
        Width = 201
        Height = 97
        Caption = 'Grid size (2x2 to 8x8)'
        Color = 13172735
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        object Label3: TLabel
          Left = 88
          Top = 50
          Width = 13
          Height = 23
          Caption = 'X'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label1: TLabel
          Left = 24
          Top = 26
          Width = 50
          Height = 23
          Caption = 'Width'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 112
          Top = 26
          Width = 55
          Height = 23
          Caption = 'Height'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object HeightEdt: TSpinEdit
          Left = 120
          Top = 48
          Width = 41
          Height = 34
          MaxValue = 8
          MinValue = 2
          TabOrder = 0
          Value = 3
          OnChange = AddEdgesBtnClick
        end
        object WidthEdt: TSpinEdit
          Left = 24
          Top = 48
          Width = 41
          Height = 34
          MaxValue = 8
          MinValue = 2
          TabOrder = 1
          Value = 3
          OnChange = AddEdgesBtnClick
        end
      end
      object BuildBtn: TButton
        Left = 240
        Top = 392
        Width = 177
        Height = 25
        Caption = 'Restore empty grid'
        TabOrder = 3
        OnClick = BuildBtnClick
      end
      object CountBtn: TButton
        Left = 24
        Top = 448
        Width = 169
        Height = 25
        Caption = 'Count Squares'
        TabOrder = 4
        OnClick = CountBtnClick
      end
      object ShowBtn: TButton
        Left = 240
        Top = 448
        Width = 177
        Height = 25
        Caption = 'Show Squares'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = CountBtnClick
      end
      object SaveBtn: TButton
        Left = 24
        Top = 592
        Width = 153
        Height = 25
        Caption = 'Save current grid'
        TabOrder = 6
        OnClick = SaveBtnClick
      end
      object LoadBtn: TButton
        Left = 232
        Top = 592
        Width = 177
        Height = 25
        Caption = 'Retrieve a saved grid'
        TabOrder = 7
        OnClick = LoadBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 695
    Width = 1195
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2018, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
