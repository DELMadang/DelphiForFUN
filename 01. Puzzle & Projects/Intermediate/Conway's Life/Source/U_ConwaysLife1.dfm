object Form1: TForm1
  Left = 192
  Top = 122
  Width = 930
  Height = 600
  Caption = 'Conway'#39's Game of Life   V1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 448
    Top = 8
    Width = 433
    Height = 433
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 25
    DefaultColWidth = 16
    DefaultRowHeight = 16
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 25
    FixedRows = 0
    TabOrder = 0
    OnClick = StringGrid1Click
    OnDrawCell = StringGrid1DrawCell
  end
  object StartBtn: TButton
    Left = 456
    Top = 456
    Width = 129
    Height = 25
    Caption = 'Step'
    TabOrder = 1
    OnClick = StartBtnClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 24
    Width = 409
    Height = 385
    Lines.Strings = (
      
        'This is the simplest version of Conway'#39's Game of Life that I cou' +
        'ld come up with.'
      ''
      'From the Wikipedia entry for Conway'#39's Life":'
      '--------------------------'
      
        'The Game of Life is a cellular automaton devised by the British ' +
        'mathematician John '
      
        'Horton Conway in 1970. It is the best-known example of a cellula' +
        'r automaton.'
      ''
      
        'The "game" is actually a zero-player game, meaning that its evol' +
        'ution is determined '
      
        'by its initial state, needing no input from human players. One i' +
        'nteracts with the Game '
      
        'of Life by creating an initial configuration and observing how i' +
        't evolves.'
      '--------------------------'
      ''
      
        'From each board there are two basic rules for forming the next g' +
        'eneration:'
      ''
      
        'For each square, count the "neighbors", number of adjoining sqau' +
        'res (in all 8 '
      'directions) that are occupied.'
      ''
      
        'Rule 1: If an occupied square has less than 2 or more than 3 nei' +
        'ghbors, it "dies" (the '
      'square becomes unoccupied).'
      ''
      
        'Rule 2: if an unoccupied square has exactly 3 neighbors, a "birt' +
        'h" occurs (it becomes '
      'occupied).'
      ''
      
        'Click a square to switch its state.  Click the "Step" button to ' +
        'see the next generation.'
      ''
      '')
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 540
    Width = 914
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
    TabOrder = 3
    OnClick = StaticText1Click
  end
end
