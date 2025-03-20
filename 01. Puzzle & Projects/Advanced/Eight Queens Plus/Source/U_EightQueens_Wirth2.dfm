object Form1: TForm1
  Left = 71
  Top = 38
  Width = 696
  Height = 538
  Caption = 'Eight Queens Wirth'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 200
    Width = 55
    Height = 13
    Caption = 'All solutions'
  end
  object WirthBtn: TButton
    Left = 16
    Top = 16
    Width = 209
    Height = 25
    Caption = 'Find all solutions'
    TabOrder = 0
    OnClick = WirthBtnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 216
    Width = 129
    Height = 265
    Hint = 'Click a solution to view it'
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object CoexistingBtn: TButton
    Left = 16
    Top = 64
    Width = 209
    Height = 25
    Caption = 'Find largest set of co-existing solutions'
    TabOrder = 2
    OnClick = CoexistingBtnClick
  end
  object StringGrid1: TStringGrid
    Left = 192
    Top = 208
    Width = 161
    Height = 265
    ColCount = 2
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 20
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StringGrid2: TStringGrid
    Left = 400
    Top = 208
    Width = 273
    Height = 265
    ColCount = 8
    DefaultColWidth = 32
    DefaultRowHeight = 32
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 4
  end
  object StopBtn: TButton
    Left = 16
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    OnClick = StopBtnClick
  end
  object CoveringBtn: TButton
    Left = 16
    Top = 112
    Width = 209
    Height = 25
    Caption = 'Find smallest set of covering solutions'
    TabOrder = 6
    OnClick = CoveringBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 492
    Width = 688
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002-2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object Memo1: TMemo
    Left = 240
    Top = 8
    Width = 433
    Height = 177
    Color = clYellow
    Lines.Strings = (
      
        'Eight Queens is a classic chessboard problem requiring that you ' +
        'place eight queens on a '
      
        'standard 8x8 chessboard with no queen threatening another.  Quee' +
        'ns can move many '
      'spaces  in a vertical, horizontal, or diagonal direction.'
      ''
      
        'This program uses an efficient algortihm discovered by Niklaus W' +
        'irth which finds  all 92 '
      
        'solutions very rapidly. (Niklaus Wirth, Algorithms and Data Stru' +
        'ctures, 1978, 1986).    The '
      'program also answers two other questions:'
      ''
      
        '"What is the largest subset of eight queens solutions that can c' +
        'o-exist on the board '
      'without overplapping?"'
      ''
      
        'And "What is the smallest set of solutions which can occupy ever' +
        'y square on the board?"'
      ' ')
    ReadOnly = True
    TabOrder = 8
  end
end
