object Form1: TForm1
  Left = 387
  Top = 30
  Width = 940
  Height = 647
  Align = alClient
  Caption = 'Akerue Version 4.4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseUp = FormMouseUp
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 932
    Height = 557
    ActivePage = TabSheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 924
        Height = 525
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Here is a version of Akerue that uses the keyboard or mouse for ' +
            'input.  Find as many words as you can that'
          
            'are formed from letters that are connected  vertically, horizont' +
            'ally, or diagonally.  Words must have  3 or'
          
            'more letters. The same letter square cannot be used twice within' +
            ' any single word.  No word may be'
          'repeated in a single game.'
          ''
          
            'You may choose board sizes at 4x4, 5x5, or 6x6 letters and use "' +
            'Small", "Medium" or "Large"  dictionaries.'
          ''
          
            'Click "Start" to begin, then, for keyboard input, type in as man' +
            'y words as you can find.  Press the "Enter"'
          
            'key to score each word.  For mouse input click letter squares th' +
            'at form the word.  Mouse input has the '
          
            'restriction that each letter clicked after the first, must be ad' +
            'jacent to the previous letter.  Click the final letter'
          
            'of the word a second time (or press the "Enter" key to indicate ' +
            'that you are through with that word). With the'
          
            'exception of using "Enter" to end mouse input, each word should ' +
            'be entered either by keyboard or by the'
          'mouse.  Input modes may not be mixed within a single word.'
          ''
          ''
          
            'When you have entered all of the words you can identify, click t' +
            'he button again and the computer will find'
          
            'the rest.  If  you find more than the computer, you win!  (Perha' +
            'ps you should declare yourself the winner if'
          'you score more than 10% of the total!!)'
          ''
          
            'There is an "Options" menu which can be used to activate a timer' +
            ' to limit the time available for finding words.'
          ''
          
            'Each dictionary level (Small, Medium, Large) may have an associa' +
            'ted word list of temporary modifications.'
          
            'These lists are maintained from run to run.  If you enter a word' +
            ' that you feel should be in a particular'
          
            'dictionary, but is not,  you can press "Enter" again after the r' +
            'ejection to add the word to the list. After the'
          
            'program makes its list of all words that you did not find, you c' +
            'an click any words in its list to exclude them'
          
            'from this and future games.   The files are ordinary text files ' +
            'and may be edited offline if so desired.   File '
          'names,'
          
            'if they exist, are: Added[size].txt and Ignored[size].txt, where' +
            ' [size] is Small, Medium, or Large depending on '
          'the'
          
            'dictionary in use at the time.  These word lists are mauntained ' +
            'from run-to-run but do not update the input '
          'dictionary'
          ' files.'
          ''
          ' '
          ' '
          ' '
          ' ')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Play'
      ImageIndex = 1
      object ScoreLbl: TLabel
        Left = 193
        Top = 7
        Width = 129
        Height = 50
        AutoSize = False
        Caption = 'ScoreLbl'
        WordWrap = True
      end
      object MaxScorelbl: TLabel
        Left = 193
        Top = 376
        Width = 129
        Height = 62
        AutoSize = False
        Caption = 'MaxScoreLbl'
        WordWrap = True
      end
      object WordActionLbl: TLabel
        Left = 496
        Top = 384
        Width = 84
        Height = 17
        Caption = 'Invalid Word:'
      end
      object StartBtn: TMemo
        Left = 3
        Top = 183
        Width = 185
        Height = 89
        Lines.Strings = (
          'StartBtn')
        TabOrder = 9
      end
      object DicGrp: TRadioGroup
        Left = 13
        Top = 12
        Width = 156
        Height = 77
        Caption = 'Dictionary'
        Color = clCream
        ItemIndex = 1
        Items.Strings = (
          'Small'
          'Medium'
          'Large')
        ParentColor = False
        TabOrder = 0
        OnClick = DicGrpClick
      end
      object BoardGrid: TStringGrid
        Left = 338
        Top = 56
        Width = 260
        Height = 261
        ColCount = 7
        DefaultColWidth = 46
        DefaultRowHeight = 46
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 7
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        GridLineWidth = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 1
        OnDrawCell = BoardGridDrawCell
        OnMouseUp = BoardGridMouseUp
        ColWidths = (
          46
          46
          46
          46
          46
          46
          46)
        RowHeights = (
          46
          46
          46
          46
          46
          46
          46)
      end
      object NewWordEdt: TEdit
        Left = 377
        Top = 16
        Width = 169
        Height = 32
        CharCase = ecUpperCase
        Color = clBlue
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clYellow
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnChange = NewWordEdtChange
        OnMouseUp = FormMouseUp
      end
      object ListBox1: TListBox
        Left = 193
        Top = 60
        Width = 123
        Height = 309
        ItemHeight = 17
        TabOrder = 3
        OnClick = ListBox1Click
      end
      object Memo2: TMemo
        Left = 16
        Top = 280
        Width = 145
        Height = 209
        Color = clCream
        Lines.Strings = (
          'Scoring:'
          ''
          'Word length   Score'
          '    3                     1'
          '    4                     2'
          '    5                     3'
          '    6                     4'
          '    7                     5'
          '   8                    10'
          '   9                    15'
          '  10                   20')
        TabOrder = 4
      end
      object NewBtn: TButton
        Left = 20
        Top = 188
        Width = 149
        Height = 25
        Caption = 'New game'
        TabOrder = 5
        Visible = False
        OnClick = BoardSizeGrpClick
      end
      object ReplayBtn: TButton
        Left = 20
        Top = 220
        Width = 149
        Height = 25
        Caption = 'Replay current game'
        TabOrder = 6
        Visible = False
        OnClick = ReplayBtnClick
      end
      object BoardSizeGrp: TRadioGroup
        Left = 13
        Top = 100
        Width = 156
        Height = 77
        Caption = 'Board size'
        Color = clAqua
        ItemIndex = 1
        Items.Strings = (
          '4X4'
          '5X5'
          '6X6')
        ParentColor = False
        TabOrder = 7
        OnClick = BoardSizeGrpClick
      end
      object Panel1: TPanel
        Left = 191
        Top = 408
        Width = 148
        Height = 80
        Caption = 'Panel1'
        TabOrder = 8
      end
    end
    object WordSheet: TTabSheet
      Caption = 'Added / Ignored Words'
      ImageIndex = 2
      OnEnter = WordSheetEnter
      object Label1: TLabel
        Left = 296
        Top = 64
        Width = 118
        Height = 17
        Caption = 'Added valid words'
      end
      object Label3: TLabel
        Left = 472
        Top = 64
        Width = 124
        Height = 17
        Caption = 'Ignore these words'
      end
      object ValidWordDisplayList: TMemo
        Left = 296
        Top = 80
        Width = 161
        Height = 393
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object IgnorewordDisplayList: TMemo
        Left = 472
        Top = 80
        Width = 153
        Height = 393
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Memo3: TMemo
        Left = 48
        Top = 80
        Width = 201
        Height = 153
        Color = 14024703
        Lines.Strings = (
          'These lists are treated as '
          'temporary additions to and '
          'deletions from the current '
          'dictionary.  The lists are '
          'automatically saved and '
          'restored with dictionary '
          'close and open actions.')
        TabOrder = 2
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 557
    Width = 932
    Height = 19
    Panels = <
      item
        Text = 'Current Dctionary: '
        Width = 350
      end
      item
        Text = 'Work Folder:'
        Width = 250
      end>
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 576
    Width = 932
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2003, 2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object MainMenu1: TMainMenu
    Left = 1008
    Top = 72
    object Dictionaries1: TMenuItem
      Caption = 'Dictionaries'
      object Setdefaultdictionaries1: TMenuItem
        Caption = 'Set default dictionary names'
        OnClick = Setdefaultdictionaries1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object TimeOption: TMenuItem
        Caption = 'Timer (click on/click off)'
        Checked = True
        OnClick = TimeOptionClick
      end
      object Sound1: TMenuItem
        Caption = 'Timer sound (click on/click off)'
        Checked = True
        OnClick = Sound1Click
      end
      object Set1: TMenuItem
        Caption = 'Set time limits...'
        OnClick = Set1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Colors1: TMenuItem
        Caption = 'Classic colors ((click on click off)'
        OnClick = Colors1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 1000
    Top = 136
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'dic'
    Filter = 'Dvctionary (*.dic)|*.dic|Text file (*.txt)|*.txt'
    Title = 'Select dictionary'
    Left = 1000
    Top = 192
  end
end
