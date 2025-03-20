object Form1: TForm1
  Left = 1075
  Top = 157
  AutoScroll = False
  Caption = 'Paletto and Variations, Version 2.1'
  ClientHeight = 755
  ClientWidth = 577
  Color = 16577008
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 730
    Width = 577
    Height = 25
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 577
    Height = 730
    ActivePage = PalettoSheet
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    object Introsheet: TTabSheet
      Caption = 'Introduction'
      object Memo4: TMemo
        Left = 16
        Top = 72
        Width = 513
        Height = 577
        Color = 14483455
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          ''
          'Here is a software implementation of the board game, '
          'Paletto, and a puzzle derived from it.'
          ''
          'Paletto is a game designed by Dieter Stein and '
          'described on his website '
          'http://spielstein.com/games/paletto.  The rules are '
          'simple and play is easy but some strategic thinking is '
          'required to win.  The physical game is manufactured and '
          'marketed by Clemens Gerhards on eBay and along '
          'with many other attractive games on his website '
          'http://www.spiel-und-design.eu/en.  The games look to '
          'be of excellent construction and reasonably priced at '
          'around $25.  Unfortunately, shipping to the US adds $48 '
          'to that price!'
          ''
          'I became aware of the game because a long time '
          'viewer and fellow Delphian residing in Germany owns '
          'the game and had developed a puzzle idea based on it '
          'but wasn'#39't sure that it was solvable.  After a few '
          'iterations, we proved that it is solvable and is included '
          'here as "Puzzle 2", both as a user playable version and '
          'the solution search that proved it could be done.'
          '')
        ParentFont = False
        TabOrder = 0
      end
    end
    object PalettoSheet: TTabSheet
      Caption = 'Paletto Game'
      ImageIndex = 3
      object Player1Lbl: TLabel
        Left = 8
        Top = 256
        Width = 94
        Height = 24
        Caption = '^ Player 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object Player2Lbl: TLabel
        Left = 456
        Top = 256
        Width = 94
        Height = 24
        Caption = 'Player 2 ^'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object P1Rect: TShape
        Left = 16
        Top = 288
        Width = 36
        Height = 24
      end
      object P2rect: TShape
        Left = 512
        Top = 286
        Width = 36
        Height = 24
      end
      object Label1: TLabel
        Left = 16
        Top = 528
        Width = 9
        Height = 18
        Caption = '0'
      end
      object Label2: TLabel
        Left = 16
        Top = 552
        Width = 113
        Height = 129
        AutoSize = False
        Caption = 
          'Random decks tested to build an initial board with no matching c' +
          'olors for neighbors sharing a side'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object PalettoBtn: TButton
        Left = 312
        Top = 288
        Width = 121
        Height = 25
        Caption = 'New game'
        TabOrder = 0
        OnClick = PalettoBtnClick
      end
      object StringGrid3: TStringGrid
        Left = 6
        Top = 24
        Width = 59
        Height = 209
        ColCount = 2
        DefaultColWidth = 24
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnDrawCell = StringGrid3DrawCell
      end
      object StringGrid4: TStringGrid
        Left = 494
        Top = 24
        Width = 59
        Height = 209
        ColCount = 2
        DefaultColWidth = 24
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnDrawCell = StringGrid3DrawCell
      end
      object Memo3: TMemo
        Left = 72
        Top = 8
        Width = 409
        Height = 233
        Color = 14483455
        Lines.Strings = (
          'Paletto is won by the player who either takes'
          'all  pieces of any color or whoever takes the last piece '
          'from the board. Players take turns. In each turn a player '
          'chooses a color, then removes any number of same-'
          'colored pieces (not necessarily all) from the board by '
          'clicking on them.  A piece may be removed from the '
          'board if: '
          '1) There are  two or more open sides (board edges or '
          'sides touching an empty cell)  and'
          '2) all pieces remaining  after the move are orthogonallly '
          'connected (one could move from any cell to any other by '
          'moving vertically or horizontally).')
        TabOrder = 3
      end
      object Sizegrp: TRadioGroup
        Left = 136
        Top = 264
        Width = 161
        Height = 49
        Caption = 'Board Size'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          '6x6'
          '8x8')
        TabOrder = 4
        OnClick = SizegrpClick
      end
      object Memo5: TMemo
        Left = 41
        Top = 328
        Width = 505
        Height = 57
        Color = 16511165
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Lines.Strings = (
          
            'The player whose turn it is clicks on one or more eligible cells' +
            ' of  '
          
            'a single color to take tiles.    Click an empty cell to end the ' +
            'turn.')
        ParentFont = False
        TabOrder = 5
      end
      object PalettoGrid: TStringGrid
        Left = 152
        Top = 393
        Width = 300
        Height = 293
        ColCount = 8
        DefaultColWidth = 36
        DefaultRowHeight = 35
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        OnDrawCell = StringGridDrawCell
        OnMouseUp = PalettoGridMouseUp
      end
    end
    object Puzzle2Sheet: TTabSheet
      Caption = 'Puzzle 2'
      ImageIndex = 1
      object StockPileGrid: TStringGrid
        Left = 110
        Top = 224
        Width = 301
        Height = 77
        ColCount = 8
        DefaultColWidth = 36
        DefaultRowHeight = 35
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnDrawCell = StockPileGridDrawCell
        OnMouseUp = StockPileGridMouseUp
      end
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 569
        Height = 209
        Align = alTop
        Color = 14483455
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Fill board with 8 tiles for each of 8 colors in such a manner th' +
            'at tiles'
          
            'on each side horizontally and vertically are of different colors' +
            ' from '
          
            'each other and from the tile they surround.  Also, all 4 corners' +
            ' of the '
          'board must of different colors.'
          ''
          
            'Click a color to pick it up. Click an empty cell on the board to' +
            ' drop it '
          
            'there.  Numbers above the tiles reflect the number available to ' +
            'be '
          
            'placed.Click a filled cell on the board to move it to another em' +
            'pty cell '
          'or return it to the "available" pile.')
        ParentFont = False
        TabOrder = 1
      end
      object PuzzlePlayGrid: TStringGrid
        Left = 112
        Top = 329
        Width = 300
        Height = 293
        ColCount = 8
        DefaultColWidth = 36
        DefaultRowHeight = 35
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnDrawCell = StringGridDrawCell
        OnMouseUp = PuzzlePlayGridMouseUp
      end
    end
    object Solver2Sheet: TTabSheet
      Caption = 'Puzzle2 Solver'
      ImageIndex = 2
      object SolvedLbl: TLabel
        Left = 50
        Top = 665
        Width = 88
        Height = 21
        Caption = 'SolvedLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Visible = False
      end
      object RandomGrp: TRadioGroup
        Left = 27
        Top = 258
        Width = 278
        Height = 82
        Caption = 'Color style'
        Columns = 2
        ItemIndex = 3
        Items.Strings = (
          'Default #'
          'Random #'
          'Default Colors'
          'Random Colors')
        TabOrder = 0
      end
      object ProgressBox: TCheckBox
        Left = 330
        Top = 261
        Width = 145
        Height = 19
        Caption = 'Show progress'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object SearchBtn: TButton
        Left = 328
        Top = 308
        Width = 185
        Height = 24
        Caption = 'Search'
        TabOrder = 2
        OnClick = SearchBtnClick
      end
      object Memo1: TMemo
        Left = 24
        Top = 0
        Width = 529
        Height = 249
        Color = 14483455
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Programmed search to fill board with 8 tiles for each of 8 '
          'colors in such away that tiles on each side horizontally '
          'and vertically are of different colors from each other and from '
          'the tile they surround.  Also, all 4 corners of the board  must '
          'of different colors..'
          ''
          'The program performs a trial and error search to find a tile '
          'which can be placed without violating the rules,  If none can '
          'be found, the program "backtracks" to the previously placed '
          'tile and tries to find another valid choice.  Click the "Show '
          'progress" box to watch the process.. ')
        ParentFont = False
        TabOrder = 3
      end
      object PuzzleSearchgrid: TStringGrid
        Left = 144
        Top = 361
        Width = 300
        Height = 293
        ColCount = 8
        DefaultColWidth = 36
        DefaultRowHeight = 35
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 8
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnDrawCell = PuzzleSearchgridDrawCell
      end
    end
  end
end
