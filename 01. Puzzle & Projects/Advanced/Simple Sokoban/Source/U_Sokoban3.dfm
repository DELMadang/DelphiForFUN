object Form1: TForm1
  Left = 210
  Top = 110
  Width = 950
  Height = 640
  Caption = 'Sokoban Version 3'
  Color = 8766176
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 584
    Width = 934
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 934
    Height = 584
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 32
        Top = 16
        Width = 865
        Height = 513
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          ''
          
            'Here'#39's a simple Delphi version of "Sokoban", a warehouse puzzle ' +
            'where you use the arrow keys to'
          
            'control the warehouseman, ( the "Sokoban"), as he completes his ' +
            'task of pushing the yellow "Boxes"'
          
            'onto the green "Targets".  There is much information  It was dev' +
            'eloped as possible test bed for '
          'devloping a Delphi version of a Sokoban solver.'
          ''
          'Factors are:'
          
            '*    Boxes may only be pushed, never pulled. This is the key fac' +
            'tor that makes the puzzles '
          '     challenging.'
          '*    The gray squares are immovable walls.'
          '*    You win when all of the targets are covered with boxes.'
          
            '*    In addition to the 4 arrow keys, you can use "Z", "U", or B' +
            'ackspace keys to undo the latest'
          '     last move made.'
          '*    The R key restarts the puzzle.'
          
            '*    The Load button allows you to load one of the supplied puzz' +
            'les. The four sample puzzle files '
          
            '      included range from simple to very hard (at least for me :' +
            '>).'
          
            '*    Solutions are automatically saved and may be retrieved and ' +
            'replayed.'
          
            '*    View any of the included text  puzzle files to see how you ' +
            'can enter addiional puzzles.  On '
          
            '     website  http://www.sourcecode.se/sokoban/levels.php you ca' +
            'n view and copy the text version of'
          
            '     thousands of additional puzzles and make new text files whi' +
            'ch this program can read.  Website'
          
            '     http://www.joriswit.nl/sokoban/ also contains a downloadabl' +
            'e program (Sokoban++) and level files.')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Puzzles'
      ImageIndex = 1
      object Label1: TLabel
        Left = 528
        Top = 239
        Width = 44
        Height = 19
        Caption = 'Steps'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StepLbl: TLabel
        Left = 584
        Top = 237
        Width = 22
        Height = 22
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 752
        Top = 239
        Width = 112
        Height = 19
        Caption = 'Boxes in place'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object InPlaceLbl: TLabel
        Left = 880
        Top = 237
        Width = 22
        Height = 22
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 536
        Top = 416
        Width = 123
        Height = 18
        Caption = 'No saved solution'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object LoadBtn: TButton
        Left = 24
        Top = 16
        Width = 145
        Height = 25
        Caption = 'Load puzzle'
        TabOrder = 0
        OnClick = LoadBtnClick
      end
      object BoardGrid: TStringGrid
        Left = 13
        Top = 55
        Width = 490
        Height = 490
        BorderStyle = bsNone
        ColCount = 10
        DefaultColWidth = 47
        DefaultRowHeight = 47
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 10
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnDrawCell = BoardGridDrawCell
      end
      object LoadSolBtn: TButton
        Left = 536
        Top = 448
        Width = 145
        Height = 25
        Caption = 'Load saved moves'
        TabOrder = 2
        OnClick = LoadSolBtnClick
      end
      object Memo2: TMemo
        Left = 528
        Top = 272
        Width = 385
        Height = 129
        Lines.Strings = (
          'Moves display here '
          ''
          'l, r, u, or d for moves of the warehouseman (the Sokoban) one '
          'square in a left, right, up, or down direction.'
          ''
          'Moves are denoted  in capital letters (L, R, U, D) if the move '
          'pushes a box.')
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object ReplayBtn: TButton
        Left = 768
        Top = 448
        Width = 145
        Height = 25
        Caption = 'Replay moves'
        TabOrder = 4
        OnClick = ReplayBtnClick
      end
      object Memo3: TMemo
        Left = 528
        Top = 56
        Width = 377
        Height = 169
        Lines.Strings = (
          'Shortcut keys'
          '     Left, Right, Up, Down arrow keys : Move that direction'
          '     U, Z, Backspace keys: Undo previous move'
          '     R: Restart'
          ''
          'Colors codes'
          '    Gray = wall'
          '    Blue = Floor'
          '    Green = Target'
          '    Yellow = Box')
        TabOrder = 5
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select a case'
    Left = 888
    Top = 536
  end
end
