object Form1: TForm1
  Left = 374
  Top = 86
  Width = 1082
  Height = 825
  Caption = 'Word Search Version 2.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1064
    Height = 755
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo3: TMemo
        Left = 0
        Top = 0
        Width = 1056
        Height = 717
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Here'#39's a "wordsearch" puzzle solver motivated by a Mensa Puzzle ' +
            'Calendar entry which asks viewers to find five '
          
            '7-letter words in the given grid by following "crooked" paths.  ' +
            'The search rules require moving from each letter to '
          
            'an adjacent letter horizontally, vertically, or  diagonally to t' +
            'he next letter and no letter may be revisited within a'
          'single word.'
          ''
          
            'This is the only puzzle of the "crooked path" type I know of, bu' +
            't I added program features to include:'
          ''
          
            '1. Tradtional word search "straight path" type puzzles requiring' +
            ' that words lie in a straight line horizontally,'
          'vertically, or diagonal.'
          '2: Inclusion of a "Target word" list for the given grid.'
          '3. Setting a range of word lengths for words to be found.'
          '4. Allowing users to find words by clicking in the grid.'
          
            '5. Letting the program find words according to the given paramet' +
            'ers.'
          '6. Clicking on found words to replay them on the grid.'
          
            '7. Allowing users to modify or define puzzles by specifying grid' +
            ' size, grid contents and other parameters.'
          '8. Saving and reloading puzzles to text files.'
          ''
          
            'Version 2.1 adds a "Revisit OK" checkbox to allow revisiting gri' +
            'd letters within a word.  Puzzle "RevisitTest.txt" is a '
          
            'Mensa Calendar Puzzle which requires the enhancement to manually' +
            ' solve.  The program search finds all words that '
          
            'can be formed within a given length range when letter revisits a' +
            're allowed.  The two  solution words are contained in '
          'the words the program finds.')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Play'
      ImageIndex = 1
      object Label6: TLabel
        Left = 592
        Top = 520
        Width = 374
        Height = 19
        Caption = 'Found words (Click a found word below to replay it)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object UserModeGrp: TRadioGroup
        Left = 16
        Top = 0
        Width = 409
        Height = 57
        Caption = 'User mode'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Find words'
          'Modify puzzle')
        TabOrder = 0
        OnClick = UserModeGrpClick
      end
      object Grid: TStringGrid
        Left = 616
        Top = 16
        Width = 425
        Height = 481
        Color = 12255231
        ColCount = 7
        DefaultColWidth = 58
        DefaultRowHeight = 64
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 7
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -33
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 1
        OnClick = GridClick
        OnDblClick = GridDblClick
        OnDrawCell = GridDrawCell
        OnKeyDown = GridKeyDown
        OnKeyPress = GridKeyPress
        OnKeyUp = GridKeyUp
      end
      object SaveBtn: TButton
        Left = 440
        Top = 120
        Width = 169
        Height = 41
        Caption = 'Save  puzzle...'
        TabOrder = 2
        WordWrap = True
        OnClick = SaveBtnClick
      end
      object LoadBtn: TButton
        Left = 440
        Top = 72
        Width = 169
        Height = 41
        Caption = 'Load a puzzle...'
        TabOrder = 3
        WordWrap = True
        OnClick = LoadBtnClick
      end
      object Search2Btn: TButton
        Left = 440
        Top = 16
        Width = 169
        Height = 41
        Caption = 'Program search'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        WordWrap = True
        OnClick = Search2BtnClick
      end
      object FoundWordList: TListBox
        Left = 592
        Top = 544
        Width = 449
        Height = 145
        Columns = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        Items.Strings = (
          '')
        ParentFont = False
        TabOrder = 5
        OnClick = FoundWordMemoClick
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 240
        Width = 529
        Height = 473
        BiDiMode = bdLeftToRight
        Caption = 'Current puzzle'
        Color = 12320767
        Ctl3D = True
        ParentBackground = False
        ParentBiDiMode = False
        ParentColor = False
        ParentCtl3D = False
        TabOrder = 6
        object Label1: TLabel
          Left = 24
          Top = 272
          Width = 161
          Height = 21
          Caption = 'Word sizes between'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 264
          Top = 272
          Width = 30
          Height = 21
          Caption = 'and'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 360
          Top = 272
          Width = 49
          Height = 21
          Caption = 'letters'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 160
          Top = 232
          Width = 96
          Height = 21
          Caption = 'Columns  X '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label15: TLabel
          Left = 328
          Top = 232
          Width = 45
          Height = 21
          Caption = 'Rows'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label4: TLabel
          Left = 24
          Top = 232
          Width = 75
          Height = 21
          Caption = 'Grid size '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 16
          Top = 304
          Width = 92
          Height = 19
          Caption = 'Target words'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object AllowedRGrp: TRadioGroup
          Left = 16
          Top = 120
          Width = 417
          Height = 65
          Caption = 'Allowed paths within a word'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Straight and crooked word paths'
            'Only straight word paths')
          ParentFont = False
          TabOrder = 0
          OnClick = SetModified
        end
        object TargetWordlist: TListBox
          Left = 16
          Top = 320
          Width = 425
          Height = 137
          Color = 12255231
          Columns = 4
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ItemHeight = 16
          Items.Strings = (
            '')
          ParentFont = False
          TabOrder = 1
          OnClick = TargetWordlistClick
        end
        object MinLettersEdt: TSpinEdit
          Left = 208
          Top = 269
          Width = 49
          Height = 32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 0
          MinValue = 0
          ParentFont = False
          TabOrder = 2
          Value = 0
          OnChange = MinLettersEdtChange
        end
        object MaxLettersEdt: TSpinEdit
          Left = 304
          Top = 269
          Width = 49
          Height = 32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 0
          MinValue = 0
          ParentFont = False
          TabOrder = 3
          Value = 0
          OnChange = MaxLettersEdtChange
        end
        object ColcountEdt: TSpinEdit
          Left = 104
          Top = 229
          Width = 49
          Height = 32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 18
          MinValue = 3
          ParentFont = False
          TabOrder = 4
          Value = 7
          OnChange = GridSizeChange
        end
        object RowCountEdt: TSpinEdit
          Left = 272
          Top = 229
          Width = 49
          Height = 32
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 18
          MinValue = 3
          ParentFont = False
          TabOrder = 5
          Value = 7
          OnChange = GridSizeChange
        end
        object IntroMemo: TMemo
          Left = 16
          Top = 24
          Width = 489
          Height = 89
          Color = 14614244
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 4194432
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'Find five 7-letter words with letters connected in any direction' +
              ' '
            'and no letter revisited within a word.   Word  definitions are: '
            
              'dart-shooting tube, cattle tender,   dictionary, a little bit ba' +
              'd, '
            'and male spell caster.')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 6
          OnChange = SetModified
        end
        object Revisitbox: TCheckBox
          Left = 24
          Top = 200
          Width = 417
          Height = 17
          Caption = 'Letter revisits allowed'
          TabOrder = 7
        end
      end
      object Memo1: TMemo
        Left = 16
        Top = 64
        Width = 409
        Height = 177
        Color = 12910032
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Identify a word by clicking its letters in sequence '
          'according to the placement rule. Press "Enter" key or '
          'Space" bar to check the fully formed word.  Double click a '
          'letter to unselect from that cell to the end of current letter '
          'selections. For puzzles where revisiting is allowed, '
          'double clicking a revisited letter will deselect from the first '
          'occurence of that letter.'
          ''
          'Target words may be provided in the puzzle text or, if '
          'none, by a dictionary provided in the program.  Click '
          '"Modify puzzle" to change puzzle grid letters or target '
          'words.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object ResetBtn: TButton
        Left = 440
        Top = 184
        Width = 169
        Height = 41
        Caption = 'Reset'
        TabOrder = 8
        WordWrap = True
        OnClick = ResetBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 755
    Width = 1064
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BiDiMode = bdLeftToRight
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
    Color = clBtnFace
    FocusControl = StaticText1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentBiDiMode = False
    ParentColor = False
    ParentFont = False
    ShowAccelChar = False
    TabOrder = 1
    Transparent = False
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Puzzle file (*.txt)|*.txt|Any file (*.*)|*.*'
    Title = 'Select puzzle file to load'
    Left = 1128
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Puzle file (*,txt)|*.txt|All files  (*.*) |*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select or enter file name to save as'
    Left = 808
    Top = 8
  end
end
