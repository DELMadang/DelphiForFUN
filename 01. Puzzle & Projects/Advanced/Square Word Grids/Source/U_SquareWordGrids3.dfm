object Form1: TForm1
  Left = 497
  Top = 56
  AutoScroll = False
  Caption = 'Square Word Grids, Versiob 3.0'
  ClientHeight = 629
  ClientWidth = 738
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 609
    Width = 738
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2014, 2017  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 738
    Height = 609
    Align = alClient
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 736
      Height = 607
      ActivePage = PlayPage
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object IntroPage: TTabSheet
        Caption = '  Introduction  '
        object Memo2: TMemo
          Left = 24
          Top = 31
          Width = 697
          Height = 522
          Color = 15400959
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'Square Word Grids are an extension of our "Word Squares" program' +
              ' previously explored.'
            
              '"WordSquares" are square grids filled the same set of words in b' +
              'oth horizontal and vertical'
            
              'directions; 1st row same as 1st column, 2nd row matches 2nd colu' +
              'mn, etc.'
            ''
            
              '"Square Word Grids" still have words in every row and column, bu' +
              't not necessarily the same'
            
              'words.   These are harder to build and to solve because the sear' +
              'ch space for possible words is'
            
              'much larger.  Many results for smaller grids will also be "Word ' +
              'Squares"!'
            ''
            
              'The program provides your choice of two dictionary sizes. Grids ' +
              'can be 3x3, 4x4, or 5x5 letters'
            
              'in size.  An initial 3x3 default puzzle with one letter pre-fill' +
              'ed is presented.  Users are given the set'
            
              'of unplaced letters with which to complete the grid by selecting' +
              ' a grid cell with Mouse clicks or'
            
              'arrow keys and keying an available letter.   Pressing the "Del" ' +
              'or "Space" keys or typing over an'
            
              'already placed letter will return it to the "Unused" string.  If' +
              ' you get stuck, you can see more'
            'letters by increasing the "Prefilled Letters" box value.'
            ''
            
              'The "Generate" buttom will generate a new random puzzle using cu' +
              'rrent parameters.  Larger'
            
              'puzzles with the large dictionary may take a minute or two.  The' +
              ' "Let program solve" button may'
            
              'take a very long time to solve a large puzzle.  Once every minut' +
              'e it will offer  to "cheat" and'
            
              'display the solution found by the  Generate button.  Either "Gen' +
              'erate" or "Solve" operations may be'
            'interrupted by clicking on the "Stop" button.'
            ''
            
              'Version 2 adds the ability to manually enter a new puzzle.  Chan' +
              'ge the "Use these letters" area to'
            
              'change the current or define a new puzzle. Details are on the "P' +
              'lay" page.  This version also'
            
              'allows changed, generated, or manually entered puzzles to be sav' +
              'ed and restored.'
            ''
            
              'Version 3 is a major rewrite of the solution search algorithm. S' +
              'olutions for even 5x5 puzzles are'
            
              'now found in a few seconds.  Previous versions could only reprod' +
              'uce puzzles which were generated'
            
              'by the program.  An externally created large puzzle would likely' +
              ' have not been solved in a lifetime!'
            
              'Mensa puzzle "Mensa_Dec 27, 2016" is now included and can be sov' +
              'e quickly.  A new checkbox allows'
            
              'intermediate results to be displayed as the search progresses;ve' +
              'ry useful for debugging while the program was'
            
              ' being developed.  There is also an "Allow dulicate words" check' +
              'box whick will allow or deny Word Squares'
            ' being returned as solutions.')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object PlayPage: TTabSheet
        Caption = '  Play  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Label4: TLabel
          Left = 407
          Top = 381
          Width = 100
          Height = 16
          Caption = '0 Solutions found'
        end
        object CurrentLbl: TLabel
          Left = 25
          Top = 94
          Width = 94
          Height = 16
          Caption = 'Current Puzzle: '
        end
        object SolutionMemo: TMemo
          Left = 407
          Top = 400
          Width = 314
          Height = 153
          Lines.Strings = (
            '')
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object GenBtn: TButton
          Left = 408
          Top = 205
          Width = 313
          Height = 44
          Caption = 'Generate a new random puzzle. '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          WordWrap = True
          OnClick = genBtnClick
        end
        object Grid: TStringGrid
          Left = 19
          Top = 332
          Width = 190
          Height = 189
          ColCount = 3
          DefaultColWidth = 40
          DefaultRowHeight = 40
          DefaultDrawing = False
          FixedCols = 0
          RowCount = 3
          FixedRows = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -31
          Font.Name = 'Arial'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 3
          OnDrawCell = GridDrawCell
          OnKeyDown = GridKeyDown
          OnKeyPress = GridKeyPress
        end
        object UserPlayGrp: TGroupBox
          Left = 19
          Top = 175
          Width = 370
          Height = 145
          Caption = 'User play'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          object Label1: TLabel
            Left = 19
            Top = 88
            Width = 44
            Height = 19
            Caption = 'Show'
          end
          object Label2: TLabel
            Left = 113
            Top = 88
            Width = 90
            Height = 19
            Caption = ' hint letters'
          end
          object Label3: TLabel
            Left = 13
            Top = 25
            Width = 290
            Height = 19
            Caption = 'Use these letters to fill  in grid words'
          end
          object Prefill: TSpinEdit
            Left = 69
            Top = 84
            Width = 44
            Height = 29
            MaxValue = 9
            MinValue = 0
            TabOrder = 0
            Value = 1
            OnChange = PrefillChange
          end
          object Unused: TEdit
            Left = 13
            Top = 50
            Width = 276
            Height = 27
            CharCase = ecUpperCase
            TabOrder = 1
            Text = 'BAAENRTUY'
            OnKeyDown = UnusedKeyDown
          end
          object ResetBtn: TButton
            Left = 219
            Top = 113
            Width = 145
            Height = 19
            Caption = 'Restart current case'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = ResetBtnClick
          end
          object SetCurrentBtn: TButton
            Left = 219
            Top = 81
            Width = 139
            Height = 20
            Caption = 'Set as current case'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            Visible = False
            OnClick = SetCurrentBtnClick
          end
        end
        object DicGrp: TRadioGroup
          Left = 19
          Top = 6
          Width = 364
          Height = 76
          Caption = 'Select Dictionary'
          ItemIndex = 0
          Items.Strings = (
            'Medium (Faster searches with fewer word choices}'
            'Large (Slower searches but with more word choices) ')
          TabOrder = 6
          OnClick = DicGrpClick
        end
        object Sizegrp: TRadioGroup
          Left = 19
          Top = 119
          Width = 364
          Height = 51
          Caption = 'Puzzle size'
          Columns = 3
          ItemIndex = 0
          Items.Strings = (
            '3x3'
            '4x4'
            '5x5')
          TabOrder = 7
          OnClick = SizegrpClick
        end
        object SaveBtn: TButton
          Left = 237
          Top = 489
          Width = 139
          Height = 20
          Caption = 'Save current puzzle...'
          TabOrder = 8
          OnClick = SaveBtnClick
        end
        object LoadBtn: TButton
          Left = 235
          Top = 527
          Width = 139
          Height = 19
          Caption = 'Load a puzzle... '
          TabOrder = 9
          OnClick = LoadBtnClick
        end
        object Memo1: TMemo
          Left = 401
          Top = 13
          Width = 314
          Height = 188
          Lines.Strings = (
            'To enter a new puzzle manually:'
            ''
            '1. Select the size if different from current size.'
            '2. Into the "Use these letters" area, enter the 9, 16, '
            '   or  25 letters to be used to fill the grid.'
            '3. If one or more of the letters are to be pre-filled, '
            '   key them into the grid in their proper position.'
            '4.. Click the "Set as current puzzle" button.'
            '5. Solve manually or let the program search as with '
            'any other puzzle'
            '')
          TabOrder = 10
        end
        object Debug: TCheckBox
          Left = 408
          Top = 320
          Width = 153
          Height = 41
          Caption = 'Show intermediate solution search steps'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 11
          WordWrap = True
        end
        object SearchBtn: TButton
          Left = 399
          Top = 261
          Width = 314
          Height = 52
          Caption = 'Show or run a program search for  solution'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          WordWrap = True
          OnClick = SearchBtnClick
        end
        object StopPanel: TPanel
          Left = 392
          Top = -8
          Width = 313
          Height = 100
          BorderWidth = 2
          BorderStyle = bsSingle
          Caption = 'STOP'
          Color = clMoneyGreen
          UseDockManager = False
          FullRepaint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 5
          Visible = False
          OnClick = StopPanelClick
        end
        object Duplicates: TCheckBox
          Left = 568
          Top = 320
          Width = 145
          Height = 41
          Caption = 'Allow duplicate words in solutions'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 12
          WordWrap = True
        end
      end
    end
  end
end
