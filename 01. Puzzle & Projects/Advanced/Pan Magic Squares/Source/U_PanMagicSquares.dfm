object Form1: TForm1
  Left = 95
  Top = 82
  Width = 983
  Height = 700
  Caption = '5x5 PanMagic Square Generator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 967
    Height = 644
    ActivePage = Introsheet
    Align = alClient
    TabOrder = 0
    object Introsheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 40
        Top = 8
        Width = 801
        Height = 561
        Color = 14811135
        Lines.Strings = (
          
            'I recently  needed some magic squares for another project and re' +
            'alized that I did not have a generator.  In fact, there did not ' +
            'seem'
          
            'to be a Delphi version available online, so here is my first att' +
            'empt at one.'
          ''
          
            'A "Magic Square" of odd order N is an square array of integers 1' +
            ' through N^2 with the the property that the sum of integers in e' +
            'ach'
          'row, each column, and each of the 2 diagonals are all equal.'
          ''
          
            'There does not seem to be an algorithm for generating all magic ' +
            'squares, even of odd order which are more amenable to'
          
            'solution. Two methods of generating 5x5 magic squares are implem' +
            'ented here.  Neither one is very complete even for 5x5 squares'
          
            '(of which there are apparently several million).  This program c' +
            'an generate 115,000 or so with the "panmagic" property.'
          ''
          
            'There is a discussion and generalization of the common De La Lou' +
            'bere'#39's algorithm for generating squares of odd order in Bell and' +
            ' '
          
            'Coxeter'#39's "Mathematical Recreations and Essays ".   Starting wit' +
            'h an array of blank cells, there are two rules for generating en' +
            'tries.'
          
            'Starting with "1", apply a specified V1=(a,b) increment to it'#39's ' +
            'column and row to get the cell for the next sequential integer. ' +
            ' If the '
          
            'target cell is already occupied, an alternate "jump" V2=(a+a'#39', b' +
            '+b'#39') increment rule is applied.'
          ''
          
            'These rules only generate a small subset of all possible magic s' +
            'quares. The 625 possible rules (5 choices each for column/row'
          
            'increments for the primary rule and for the jump rule) generate ' +
            ' 1472 squares.  32 of these are "panmagic" magic squares with th' +
            'e'
          
            'additional property that the broken diagonals also add to the co' +
            'mmon sum.  These Panmagic squares have the characteristic'
          
            'that a magic square can be generated for every starting cell.  I' +
            'n other words,  each of the 32 rule sets can generate 25 squares' +
            ' with'
          
            'every integer appearing in very location for some square, 800 in' +
            ' total.'
          ''
          
            'The second algorithm uses the fact that 2 Latin squares can be c' +
            'ombined to form a Greco-Latin square which is panmagic.  See'
          
            'the GL page of this program or look online for more information.' +
            ' I found 576 squares, all panmagic, with 1 in the top-left corne' +
            'r.'
          
            'Since 24 more (with the other 24 digits in the top left corner) ' +
            'can be generated for each of these, there are 14,400 (576 x 25)'
          
            'squares before considering the effect of rotating and "mirroring' +
            '" which, in theory, should make 8x14,400 or 115,200.  The "Gener' +
            'ate'
          
            'all Panmagic" page does this, checking for duplicates as the squ' +
            'ares are generated.  I found 61 duplicates, which leaves 115,139' +
            ' '
          
            'different 5x5 panmagic squares.  These numbers do not match any ' +
            'that I'#39've seen published elsewhere, so I may have a bug or '
          
            'overlooked something obvious.  The generate page allows the gene' +
            'rated squares to be saved in a text file format for further stud' +
            'y.'
          ''
          ''
          ' ')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Loubere Rule Squares'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Label2: TLabel
        Left = 48
        Top = 8
        Width = 237
        Height = 64
        Caption = 
          'Enter a number from 1 through 25 in any square, then click "Gene' +
          'rate" button..  Green text=Panmagic, Yellow=not Panmagic, Red=no' +
          't Magic'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label1: TLabel
        Left = 544
        Top = 8
        Width = 315
        Height = 33
        AutoSize = False
        Caption = 
          'Generating vectors: Enter X,Y incerments to investigate  whether' +
          ' they generate  magic squares'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label4: TLabel
        Left = 320
        Top = 8
        Width = 175
        Height = 80
        Caption = 
          'Click an entry below to select generating vectors for  pammagic ' +
          'squares. V1= X &&  Y increments for normal move .  "Jump" move i' +
          's V2. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label7: TLabel
        Left = 864
        Top = 48
        Width = 81
        Height = 81
        AutoSize = False
        Caption = 'Label7'
        WordWrap = True
      end
      object Vectors: TStringGrid
        Left = 544
        Top = 48
        Width = 313
        Height = 81
        ColCount = 3
        DefaultColWidth = 100
        RowCount = 3
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
        OnSetEditText = VectorsSetEditText
      end
      object Magic: TStringGrid
        Left = 48
        Top = 80
        Width = 249
        Height = 249
        DefaultColWidth = 48
        DefaultRowHeight = 48
        FixedCols = 0
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        ParentFont = False
        TabOrder = 1
        OnSelectCell = MagicSelectCell
      end
      object GenerateBtn: TButton
        Left = 48
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Generate'
        TabOrder = 2
        OnClick = GenerateBtnClick
      end
      object ResetBtn: TButton
        Left = 160
        Top = 336
        Width = 75
        Height = 25
        Caption = 'Reset'
        TabOrder = 3
        OnClick = ResetBtnClick
      end
      object ListBox1: TListBox
        Left = 320
        Top = 88
        Width = 201
        Height = 513
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 4
        OnClick = ListBox1Click
      end
      object Chk576btn: TButton
        Left = 48
        Top = 472
        Width = 249
        Height = 25
        Caption = 'Check Loubere Panmagic against 576 GL '
        TabOrder = 5
        OnClick = Chk576btnClick
      end
      object Memo3: TMemo
        Left = 536
        Top = 144
        Width = 401
        Height = 409
        Color = 14811135
        Lines.Strings = (
          'The "De La Loubere" rule for generating odd order magic squares'
          
            'requires a "1'#39' in the middle of the top row and consecutive move' +
            's '
          'generated by moving forward and up one square so long as the '
          
            'target cell is empty (Normal move vector V1=(1,-1)).  If the tar' +
            'get '
          
            'cell is already occupied, place the number one cell below the la' +
            'st '
          'placed number (jump vector V2=(0,1)).  You can enter these or '
          
            'other values values in the vector cells above, enter a number on' +
            ' the'
          'magic square grid at left, and click the Generate button to '
          'investigate  move results.'
          ''
          'If all possible move combinations are checked 160 of them will '
          'generate one or more magic squares depending on where the '
          'number 1 is placed. The resulting magic square is generally not '
          '"panmagic", a type where the broken diagonals also add to the '
          'magic sum. Panmagic squares may be cut between any two rows '
          
            'or columns and the pieces reversed producing a new magic square.' +
            ' '
          ' This allows any of the N^2 numbers to appear in the upper left '
          'corner (or any other desired position) in the square.'
          ''
          'The list at left identifies the 32 move combinations which will '
          'generate panmagic squares. Click one of the vector lines to '
          'generate a square.  You can click on any cell of the square and '
          'enter any number from 1 to 25 to allow the Generate button to '
          'create the magic square with that value in that position.')
        TabOrder = 6
      end
      object Chk144btn: TButton
        Left = 48
        Top = 512
        Width = 249
        Height = 25
        Caption = 'Check Loubere Panmagic against 144 GL '
        TabOrder = 7
        OnClick = Chk576btnClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Greco-Latin Squares'
      ImageIndex = 2
      object Label3: TLabel
        Left = 632
        Top = 104
        Width = 130
        Height = 18
        Caption = 'Radix Table  (A=0)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 800
        Top = 104
        Width = 114
        Height = 18
        Caption = 'Units table (a=0)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 8
        Top = 24
        Width = 121
        Height = 16
        Caption = 'Master Pattern Table'
      end
      object Label9: TLabel
        Left = 8
        Top = 224
        Width = 228
        Height = 16
        Caption = 'PanMagic Square for current selections'
      end
      object GLTableb: TStringGrid
        Left = 800
        Top = 136
        Width = 153
        Height = 441
        DefaultColWidth = 24
        RowCount = 25
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnClick = GLTableClick
        ColWidths = (
          24
          24
          24
          24
          24)
      end
      object GLTablea: TStringGrid
        Left = 632
        Top = 136
        Width = 161
        Height = 441
        DefaultColWidth = 24
        RowCount = 25
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 1
        OnClick = GLTableClick
      end
      object GLMaster: TStringGrid
        Left = 8
        Top = 48
        Width = 249
        Height = 129
        DefaultColWidth = 48
        FixedCols = 0
        FixedRows = 0
        TabOrder = 2
      end
      object GLSquare: TStringGrid
        Left = 8
        Top = 248
        Width = 249
        Height = 129
        DefaultColWidth = 48
        FixedCols = 0
        FixedRows = 0
        TabOrder = 3
      end
      object GLMakeAllBtn: TButton
        Left = 8
        Top = 432
        Width = 201
        Height = 25
        Caption = 'Make 576 Unique'
        TabOrder = 4
        OnClick = GLMakeAllBtnClick
      end
      object Memo2: TMemo
        Left = 264
        Top = 24
        Width = 353
        Height = 553
        Color = 14811135
        Lines.Strings = (
          'This page is based largely on information provided by'
          'Alan Grogono at found at '
          'www.grogono.com/magic/5x5.php.  A Latin square of '
          'size N contains N different symbols placed so that each '
          'symbol occurs only once in each column and each row. '
          ' In a Greco-Latin square, two Latin squares, each with '
          'different symbols are overlapped so that each of the N*N '
          'combinations of the symbols appears once in each of '
          'the cells. Historically, investigations used Roman (Latin) '
          'letters for one of the squares and Greek letters for the '
          'others,  hence the name Greco-Latin squares. '
          ''
          'If we consider the numbers in a magic square running '
          'from 0 to N^2-1, they can be expressed in base N as 2 '
          'digit numbers 00, 01,... (N-1)(N-1).  Eg. 00 to 44 a 5x5 '
          'square.  (44 base 5 = 24 base 10).  If the left digits are '
          'arranged into a Latin square and the rightmost digts in '
          'another Latin square, the concatenation of the two into'
          'a Greco-Latin square defines a magic square!'
          'Translating back to base 10 and adding 1 to each value'
          'display the traditional style magic square from with'
          'numbers from 1 to N^2.'
          ''
          'Grogono uses capital letters for the radix (leftmost)'
          'digits and lower case for the rightmost digit.  He says'
          'that the Pattern Table at left will generate all'
          'panmagic squares of which there are 144.  Each will '
          'have 25'
          'variants with a different number in the top left corner and'
          '8 variants for rotations producing 144*25*8=28,800'
          'different squares.  I have not verified that his 144 are all'
          'of the primitive squares, but I think not.  He keeps A=0 '
          'and B=1 and perrmutes C, D, and E values (the first 6 '
          'entries in Radix Table at right.  Incldung B values in the '
          'permutaion generates 576 squares which are not '
          'identical and in fact do not seem to be isomorphic to  '
          'the 144 in his original set.  I have pre-multiplied the '
          'radix values by 5 so that cell values can be gereated by '
          'adding Capital Letter value + Small Letter value + 1.'
          'See the "Generate All Panmagic" page for more'
          'information.'
          ''
          '')
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object GLMake144Btn: TButton
        Left = 8
        Top = 392
        Width = 193
        Height = 25
        Caption = 'Make 144 Unique'
        TabOrder = 6
        OnClick = GLMake144BtnClick
      end
      object Memo5: TMemo
        Left = 632
        Top = 24
        Width = 313
        Height = 73
        Lines.Strings = (
          'Click a row from each table below to see the '
          'panmagic square generated from those values '
          'and the pattern table ar lwft.  The value of each cell '
          'is Capital letter value+Small letter value+1. ')
        TabOrder = 7
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Generate all Panmagic'
      ImageIndex = 3
      object Label6: TLabel
        Left = 424
        Top = 56
        Width = 49
        Height = 16
        Caption = 'Count: 0'
      end
      object GenAllBtn: TButton
        Left = 120
        Top = 48
        Width = 265
        Height = 25
        Caption = 'Generate all 5x5 PanMagic Squares'
        TabOrder = 0
        OnClick = GenAllBtnClick
      end
      object Memo4: TMemo
        Left = 120
        Top = 104
        Width = 401
        Height = 233
        Color = 14548991
        Lines.Strings = (
          'Click the button above to generate all of the order 5 pan-magic '
          'squares that I can find.  The 576 Greco-Latin squares with 1 in'
          
            'the upper left corner are translated so that each of the other 2' +
            '4 '
          'numbers appear there.   Those squares are then rotated 90 '
          'degrees three times, "flipped over" and and rotated three more '
          'times creatring 7 additional squares for each.'
          ''
          'The process generates 115,200 (576x25x8) squares.  From this '
          'total, 61 duplicates generated by flippinmg and rotating are '
          
            'eliminated, leaving 115,139 squares.  The squares may be save in' +
            ' '
          
            'a text file with one 75 character record per square.  Each recor' +
            'ed '
          'contains the 25 numbers by row, each 2 digit number preceded by '
          'a blank character.')
        TabOrder = 1
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 644
    Width = 967
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt) |*.txt|All files (*.*)|*.*'
    Left = 844
    Top = 11
  end
end
