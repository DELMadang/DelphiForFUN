object Form1: TForm1
  Left = 192
  Top = 122
  Width = 906
  Height = 600
  Caption = 'Conway'#39's Game of Life   V2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 890
    Height = 540
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 24
        Top = 8
        Width = 833
        Height = 489
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'This is Version 2 of Conway'#39's Game of Life.'
          ''
          'From the Wikipedia entry for Conway'#39's Life:'
          '--------------------------'
          
            'The Game of Life is a cellular automaton devised by the British ' +
            'mathematician John Horton Conway in 1970. It is the best-known e' +
            'xample of a '
          'cellular automaton.'
          ''
          
            'The "game" is actually a zero-player game, meaning that its evol' +
            'ution is determined by its initial state, needing no input from ' +
            'human players. '
          
            'One interacts with the Game of Life by creating an initial confi' +
            'guration and observing how it evolves.'
          '--------------------------'
          ''
          
            'From each board there are two basic rules for forming the next g' +
            'eneration.  For each square, count the "neighbors", number of ad' +
            'joining '
          'sqaures (in all 8 directions) that are occupied.'
          ''
          
            'Rule 1: If an occupied square has less than 2 or more than 3 nei' +
            'ghbors, it "dies" (the square becomes unoccupied).'
          
            'Rule 2: if an unoccupied square has exactly 3 neighbors, a "birt' +
            'h" occurs (it becomes occupied).'
          ''
          
            'Click a square to switch its state to set up a new pattern.  Pat' +
            'terns which expand beyond the current board "wrap" around vertic' +
            'ally and '
          
            'horizontally (as if the board were printed on a doughnut).  When' +
            ' this occurs, the wrapped cells may interact with non-wrapped an' +
            'd change the '
          'final result.'
          ''
          'In addition to manual setup and play, Version 2 adds:'
          ''
          
            '* The abiity to automatically generate generations at a user spe' +
            'cified rate'
          '* Buttons to load and save patterns.'
          '* A generation counter'
          '* Board sizes of 25x25, 50x50 or 100x100.'
          
            '* Several sample patterns that I found interesting - there are h' +
            'undreds of others available on the Internet.'
          ''
          ''
          ' '
          ' ')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Play'
      ImageIndex = 1
      object GenLbl: TLabel
        Left = 776
        Top = 488
        Width = 64
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Generation: 0'
      end
      object RateGrp: TRadioGroup
        Left = 688
        Top = 16
        Width = 185
        Height = 137
        Anchors = [akTop, akRight]
        Caption = 'Step rate'
        ItemIndex = 0
        Items.Strings = (
          'Single step'
          '1 generation per second'
          '2 per second'
          '5 per second'
          '10 per second'
          '20 per second'
          'Max')
        TabOrder = 0
        OnClick = RateGrpClick
      end
      object StartBtn: TButton
        Left = 544
        Top = 216
        Width = 129
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Start'
        TabOrder = 1
        OnClick = StartBtnClick
      end
      object StringGrid1: TStringGrid
        Left = 24
        Top = 16
        Width = 497
        Height = 473
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 21
        DefaultColWidth = 16
        DefaultRowHeight = 16
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 21
        FixedRows = 0
        TabOrder = 2
        OnClick = StringGrid1Click
        OnDrawCell = StringGrid1DrawCell
      end
      object SizeGrp: TRadioGroup
        Left = 544
        Top = 24
        Width = 129
        Height = 97
        Anchors = [akTop, akRight]
        Caption = 'Board size'
        ItemIndex = 0
        Items.Strings = (
          '25x25'
          '50x50'
          '100x100')
        TabOrder = 3
        OnClick = SizeGrpClick
      end
      object SaveBtn: TButton
        Left = 552
        Top = 288
        Width = 121
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Save pattern...'
        TabOrder = 4
        OnClick = SaveBtnClick
      end
      object LoadBtn: TButton
        Left = 552
        Top = 328
        Width = 121
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Load pattern...'
        TabOrder = 5
        OnClick = LoadBtnClick
      end
      object Clearbtn: TButton
        Left = 720
        Top = 216
        Width = 153
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Clear'
        TabOrder = 6
        OnClick = ClearbtnClick
      end
      object RestoreBtn: TButton
        Left = 720
        Top = 256
        Width = 153
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'Restore start postion '
        TabOrder = 7
        OnClick = RestoreBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 540
    Width = 890
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Patterns (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 764
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Pattern files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 812
    Top = 24
  end
end
