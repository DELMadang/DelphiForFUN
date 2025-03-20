object Form1: TForm1
  Left = 45
  Top = 62
  Width = 657
  Height = 480
  Caption = 'Klingon Paths'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 240
    Top = 8
    Width = 206
    Height = 206
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
  end
  object SearchBtn: TButton
    Left = 304
    Top = 240
    Width = 99
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = SearchBtnClick
  end
  object ListBox1: TListBox
    Left = 456
    Top = 8
    Width = 185
    Height = 385
    ItemHeight = 13
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 217
    Height = 393
    Color = clYellow
    Lines.Strings = (
      'Klingon Paths is an implemention of the '
      'problem presented by Clifford Pickover in his '
      'book "Wonders of Numbers",   Oxford '
      'University press, 2001.'
      ''
      '"This grid of numbers is Klingon City and it'#39's '
      'a tough place to live.  Each Klingon '
      'inhabiting this world carries a bomb on his  '
      'hip as a testament to his courage.  As a '
      'Klingon walks through the grid of squares, '
      'his bomb records the number of each square '
      'visited; if the bomb is  exposed to that '
      'number a second time, the bomb explodes '
      'and the Klingon dies.'
      ''
      'A Klingon can traverse squares horizontally '
      'or vertically, but not diagonally.  What is the '
      'longest path a Klingon can take without  '
      'dying?"'
      ''
      'The "Search" button will show find the '
      'longest Klingon path for any grid.   I also '
      'added a "Print" button which prints the grid '
      'to the default printer in case you want to '
      'work on it on you own.')
    TabOrder = 3
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 649
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object NewBtn: TButton
    Left = 304
    Top = 320
    Width = 99
    Height = 25
    Caption = 'Random Board'
    TabOrder = 5
    OnClick = NewBtnClick
  end
  object ResetBtn: TButton
    Left = 304
    Top = 280
    Width = 99
    Height = 25
    Caption = 'Reset'
    TabOrder = 6
    OnClick = ResetBtnClick
  end
  object PrintBtn: TButton
    Left = 304
    Top = 360
    Width = 99
    Height = 25
    Caption = 'Print Grid'
    TabOrder = 7
    OnClick = PrintBtnClick
  end
end
