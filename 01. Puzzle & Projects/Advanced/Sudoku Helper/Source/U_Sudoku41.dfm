object Form1: TForm1
  Left = 90
  Top = 17
  Width = 1117
  Height = 927
  Caption = 'Sudoku Helper/Solver V4.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object Pagecontrol1: TPageControl
    Left = 0
    Top = 0
    Width = 1099
    Height = 854
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '  Introduction  '
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1091
        Height = 816
        Align = alClient
        Caption = 'Panel1'
        Color = 14548991
        TabOrder = 0
        object Memo2: TMemo
          Left = 1
          Top = 1
          Width = 1089
          Height = 814
          Align = alClient
          BorderStyle = bsNone
          Color = 14548991
          Lines.Strings = (
            
              'This version of a Sudoku solver was written while on a cruise wi' +
              'th family and no online or downloadable solver '
            
              'versions were available.  The cruise line handed out puzzles dai' +
              'ly and we are a family of puzzle solvers.  So '
            'on sea '
            
              'days, while they worked on solving the puzzles, I worked on solv' +
              'ing the puzzle of how to solve the puzzles (i.e. '
            'this '
            
              'program). The family generally finished their problems, I didn'#39't' +
              ' complete mine until we got home but decided '
            'to '
            'clean it up an post it anyway.'
            ''
            
              'Sudoku requires completing a 9x9 grid of cells with the digits 1' +
              ' through 9 in such a way that all 9 values are'
            
              'included in each column, row, and 3x3 block. Some initial values' +
              ' are provided as clues.'
            ''
            
              'A few sample puzzles are included and you can create additional ' +
              'puzzles by entering initial values and saving '
            'them.'
            
              'The "Hint" checkbox will display numbers which may be placed in ' +
              'each cell without duplicating a number in that '
            
              'column, row, or block. These are the values which may be placed ' +
              'without violating the "No duplicates" rule '
            'described below.'
            ''
            
              'There are also buttons to fill one or all cells where there is o' +
              'nly a single choice for the value. Two tests are '
            'applied '
            'to determine if there is only one choice:'
            
              '1. The "No Duplicates" rule eliminates numbers which already exi' +
              'st in the cell'#39's column, row, or block.'
            
              '2. The "Completeness" rule which requires that every value occur' +
              ' in every column, row, and block.  If one of '
            'the '
            
              'values which can be placed in a cell cannot be placed in any oth' +
              'er cell without violating rule 1, then that must '
            'be the '
            'value placed in this cell.'
            ''
            
              'Applying these rules repeatedly will solve most, but not all, pu' +
              'zzles that you run across.  The next solver '
            'phase, not'
            
              'yet yet posted, requires "trial and error" solving.  This is muc' +
              'h easier for computers than for humans to '
            'accomplish '
            
              'since it can try thousands of paths per second.  One of the incl' +
              'uded samples, rated as "Evil" difficulty at '
            
              'www.websoduko.com requires this technique.  Making a correct gue' +
              'ss in the correct cell and clicking the "Fill '
            
              'single possibilities" button will find a solution. Use the "Rese' +
              't Puzzle" button to try a new guess. This is a '
            'manual '
            
              'way to implement what computer guys call "Depth First Search wit' +
              'h backtracking".'
            ''
            'Update:'
            
              ' Version 2 added the Trial and Error solution search button. Ver' +
              'sion 3 adds ability to create random '
            
              'puzzles. V3.1 = minor update to correct display when system text' +
              ' size is enlarged.'
            
              'V4.0 changes the way that random puzzles are created when cells ' +
              'are being subtracted (Method 2).  The '
            'previous'
            
              'technique generated a random completed and then removed the requ' +
              'ested number of values from random '
            'locations '
            
              'and checked to see if the puzzle had a unique solution. Solution' +
              's with more than 53 empty cells were likely to '
            'fail '
            
              'even after hours of searching.  The enhanced version finds solut' +
              'ions for 52 or ,more empty cells by finding a '
            'puzzle '
            
              'with 51 empty cells the old way and then removes values one at a' +
              ' time, checking to see if the puzzle has a '
            'unique '
            
              'solution after each removal.  The uniqeness test replaces the ce' +
              'll to be removed with each other possible and '
            'checks '
            
              'that no other value in that location produces a solvable puzzle.' +
              '  If that is the case, solution with the original '
            'value is '
            
              'unique.  Puzzles with 58 empty cells are now found in 5 or 10 mi' +
              'nutes and with as many as 59 empty cells in '
            'an hour '
            
              'or so.  Future tuning should be able to reduce this by an order ' +
              'of magnitude.'
            '')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '   Play/Solve  '
      ImageIndex = 1
      object PuzzlefileLbl: TLabel
        Left = 18
        Top = 572
        Width = 157
        Height = 23
        Caption = 'Puzzle: Default.txt'
      end
      object Label1: TLabel
        Left = 12
        Top = 10
        Width = 477
        Height = 63
        AutoSize = False
        Caption = 
          'Maroon text cells are starting values.  Click or use arrow keys ' +
          'to select cells for your guesses'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object StringGrid1: TStringGrid
        Left = 10
        Top = 72
        Width = 503
        Height = 505
        ColCount = 9
        DefaultColWidth = 54
        DefaultRowHeight = 54
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 9
        FixedRows = 0
        ScrollBars = ssNone
        TabOrder = 0
        OnClick = StringGrid1Click
        OnDrawCell = StringGrid1DrawCell
        OnKeyPress = StringGrid1KeyPress
      end
      object HintBox: TCheckBox
        Left = 544
        Top = 18
        Width = 440
        Height = 22
        Caption = 'Hints (Show non-conflicting values for empty cells)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = CheckBoxClick
      end
      object LoadCaseBtn: TButton
        Left = 18
        Top = 615
        Width = 145
        Height = 32
        Caption = 'Load a puzzle'
        TabOrder = 2
        OnClick = LoadCaseBtnClick
      end
      object SavecCaseBtn: TButton
        Left = 172
        Top = 615
        Width = 195
        Height = 32
        Caption = 'Save current puzzle'
        TabOrder = 3
        OnClick = SaveCaseBtnClick
      end
      object RestartBtn: TButton
        Left = 18
        Top = 658
        Width = 349
        Height = 32
        Caption = 'Restart the current puzzle'
        TabOrder = 4
        OnClick = RestartBtnClick
      end
      object VerboseBox: TCheckBox
        Left = 544
        Top = 49
        Width = 440
        Height = 22
        Caption = 'Verbose (Display all board changes}'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 5
        OnClick = CheckBoxClick
      end
      object PageControl2: TPageControl
        Left = 519
        Top = 88
        Width = 562
        Height = 718
        ActivePage = Randomsheet
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Style = tsButtons
        TabOrder = 6
        OnChange = PageControl2Change
        object SolveSheet: TTabSheet
          Caption = '   Solve  '
          object Memo1: TMemo
            Left = 0
            Top = 226
            Width = 513
            Height = 423
            Color = 14548991
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              '* The initial  puzzle at left is from the file "default.txt".  '
              'Successive runs will reopen the last puzzle loaded from the '
              'previous run,'
              '* Starting puzzle values are Maroon, other   entries will be '
              'Black.'
              '* To enter a number, select a cell using mouse click or '
              'arrow '
              'keys and enter a number 1 through 9.  Enter a space or 0 '
              'character to clear a cell.'
              '* Starting values may only br changed in "Create" mode '
              'which is set when the "Modify/Create" button is clicked.'
              ' * Click the "Hints" text box to display "no conflict" choices '
              'for each cell.'
              '* Moves made by you or by clicking the "Fill" button are '
              'remembered and may be undone or redone as you please.'
              '* The "Trial and Error Search" button performs a depth first '
              'solution search with backtracking when a dead end is '
              'reached.')
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object FillOneBtn: TButton
            Left = 20
            Top = 10
            Width = 453
            Height = 32
            Hint = 
              'Fill next cell with lone non-conflicting value or only choice to' +
              ' complete a row, column or block'
            Caption = 'Fill next single possibility cell'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = FillBtnClick
          end
          object FillAllBtn: TButton
            Left = 20
            Top = 55
            Width = 453
            Height = 32
            Caption = 'Fill all single possibility cells'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = FillBtnClick
          end
          object UndoBtn: TButton
            Left = 20
            Top = 100
            Width = 186
            Height = 32
            Caption = 'Undo last move'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = UndoBtnClick
          end
          object UndoAllBtn: TButton
            Left = 20
            Top = 144
            Width = 453
            Height = 32
            Caption = 'Undo program moves back to last user move'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 4
            OnClick = UndoBtnClick
          end
          object SearchBtn: TButton
            Left = 20
            Top = 189
            Width = 453
            Height = 32
            Caption = 'Trial && Error backtracking solution search'
            TabOrder = 5
            OnClick = SearchBtnClick
          end
          object RedoBtn: TButton
            Left = 282
            Top = 100
            Width = 191
            Height = 32
            Caption = 'Redo last move'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 6
            OnClick = RedoBtnClick
          end
        end
        object Modifysheet: TTabSheet
          Caption = '  Modify/Enter New  '
          ImageIndex = 2
          OnEnter = ModifysheetEnter
          object Memo4: TMemo
            Left = 31
            Top = 20
            Width = 420
            Height = 206
            Color = 14548991
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              'For manual changes, enter or change initial cell '
              'values with 1 through 9. No duplicates allowed in '
              'the same column, row, or block. Enter 0 or a space '
              'character to remove a value.'
              ''
              'All changes made here become part of the puzzle '
              'definition when the puzzle is saved.'
              ''
              'Click the "Solvie" tab to return to "Play" mode.'
              ''
              '')
            ParentFont = False
            TabOrder = 0
          end
          object Modifygrp: TRadioGroup
            Left = 41
            Top = 286
            Width = 400
            Height = 104
            Caption = 'Select build option'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -20
            Font.Name = 'Arial'
            Font.Style = []
            Items.Strings = (
              'Manually modify  current puzzle'
              'Manually key in a new puzzle')
            ParentFont = False
            TabOrder = 1
            OnClick = ModifygrpClick
          end
        end
        object Randomsheet: TTabSheet
          Caption = '   Create Random   '
          ImageIndex = 1
          object StatusLbl: TLabel
            Left = 51
            Top = 695
            Width = 313
            Height = 26
            Caption = 'Checking random board  0 of 0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -22
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Label4: TLabel
            Left = 31
            Top = 581
            Width = 246
            Height = 73
            AutoSize = False
            Caption = 'Method 2 - # to leave empty (Not mch luck above 53)'
            WordWrap = True
          end
          object Label3: TLabel
            Left = 28
            Top = 480
            Width = 247
            Height = 53
            AutoSize = False
            Caption = 'Method 1 - # cells to fill  (Not much luck below  28)'
            WordWrap = True
          end
          object Label2: TLabel
            Left = 140
            Top = 421
            Width = 121
            Height = 23
            Caption = 'Max Attempts'
          end
          object Memo3: TMemo
            Left = 0
            Top = 0
            Width = 554
            Height = 361
            Align = alTop
            Color = 14548991
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -18
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              'Two methods are implemented here for creating '
              
                'puzzles Method 1 is "bottom up", filling an empty board with the' +
                ' '
              
                'specified number of  values, leaving the rest empty.  Method 2: ' +
                '"Top '
              
                'down", starts with a full board and takes entries away until the' +
                ' '
              'given number of values are removed.'
              ''
              
                'In both cases, puzzles may be restricted to those with exactly o' +
                'ne '
              'solution but the algorithm may not succeed with puzzles having '
              
                'fewer than 28 cell values defined  (53 empty).   With Version 4.' +
                '1  '
              
                'feasible limit for givens with Method 2 is 21 (60 empty) usually' +
                ' '
              'found in a few minutes.  ')
            ParentFont = False
            TabOrder = 0
          end
          object StopBtn: TButton
            Left = 20
            Top = 400
            Width = 472
            Height = 275
            Caption = 'Stop'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -23
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            Visible = False
            WordWrap = True
            OnClick = StopBtnClick
          end
          object UniqueBox: TCheckBox
            Left = 7
            Top = 364
            Width = 410
            Height = 22
            Caption = 'Return only puzzles with a unique solution'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object MaxTriesSpinEdt: TSpinEdit
            Left = 281
            Top = 410
            Width = 104
            Height = 34
            MaxValue = 1000000
            MinValue = 10
            TabOrder = 3
            Value = 1000000
          end
          object M1SpinEdt: TSpinEdit
            Left = 300
            Top = 469
            Width = 63
            Height = 34
            MaxValue = 80
            MinValue = 1
            TabOrder = 4
            Value = 30
          end
          object M1Btn: TButton
            Left = 300
            Top = 513
            Width = 114
            Height = 32
            Caption = 'M1 create '
            TabOrder = 5
            OnClick = CreateRandomClick
          end
          object M2SpinEdt: TSpinEdit
            Left = 294
            Top = 581
            Width = 63
            Height = 34
            MaxValue = 80
            MinValue = 1
            TabOrder = 6
            Value = 51
          end
          object M2Btn: TButton
            Left = 294
            Top = 625
            Width = 114
            Height = 31
            Caption = 'M2 create'
            TabOrder = 7
            OnClick = CreateRandomClick
          end
        end
      end
      object Memo5: TMemo
        Left = 16
        Top = 704
        Width = 489
        Height = 89
        Lines.Strings = (
          'Status:')
        TabOrder = 7
        Visible = False
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 854
    Width = 1099
    Height = 28
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, 2013  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Possible Sudoku cases (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 528
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Soduko type (*.txt) |*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 608
    Top = 8
  end
end
