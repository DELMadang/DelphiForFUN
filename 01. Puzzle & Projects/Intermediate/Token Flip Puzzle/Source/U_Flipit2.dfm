object Form1: TForm1
  Left = 86
  Top = 77
  Width = 707
  Height = 489
  Caption = 'Token Flip #2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Instruction: TLabel
    Left = 40
    Top = 16
    Width = 457
    Height = 89
    AutoSize = False
    Caption = 'Click token to flip'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label1: TLabel
    Left = 24
    Top = 304
    Width = 49
    Height = 13
    Caption = 'Board size'
  end
  object MovesLbl: TLabel
    Left = 512
    Top = 8
    Width = 72
    Height = 20
    Caption = 'Moves: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object StopBtn: TButton
    Left = 8
    Top = 336
    Width = 225
    Height = 97
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Visible = False
    OnClick = StopBtnClick
  end
  object DrawGrid1: TDrawGrid
    Left = 256
    Top = 120
    Width = 265
    Height = 265
    Color = clGreen
    DefaultRowHeight = 64
    DefaultDrawing = False
    FixedCols = 0
    FixedRows = 0
    Options = [goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 0
    OnClick = DrawGrid1Click
    OnDrawCell = DrawGrid1DrawCell
  end
  object SolveBtn: TButton
    Left = 16
    Top = 340
    Width = 105
    Height = 25
    Caption = 'Auto solve'
    TabOrder = 1
    OnClick = SolveBtnClick
  end
  object ListBox1: TListBox
    Left = 536
    Top = 120
    Width = 137
    Height = 145
    ItemHeight = 13
    TabOrder = 2
  end
  object NewBoardBtn: TButton
    Left = 16
    Top = 371
    Width = 105
    Height = 25
    Caption = 'New random  board'
    TabOrder = 3
    OnClick = NewBoardBtnClick
  end
  object ResetBtn: TButton
    Left = 128
    Top = 340
    Width = 97
    Height = 25
    Caption = 'Restart'
    TabOrder = 4
    OnClick = ResetBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 120
    Width = 225
    Height = 169
    Color = clYellow
    Lines.Strings = (
      'Tokens have a white side and a black side.  '
      ''
      'Objective is to turn all tokens so that the white '
      'side is showing.  Each click will turn over the '
      'clicked token plus up to 4 adjoining adjoining '
      'tokens located directly above, below, left or '
      'right of the clicked token.'
      ''
      'This version allows board size to be increased. '
      '  Most boards larger than 5X5 however will not '
      'be solved via the "Autosolve" button in your '
      'lifetime')
    TabOrder = 5
  end
  object ModeBtn: TButton
    Left = 128
    Top = 371
    Width = 97
    Height = 25
    Caption = 'Customize a board'
    TabOrder = 7
    OnClick = ModeBtnClick
  end
  object SizeEdit: TSpinEdit
    Left = 80
    Top = 304
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = 2
    TabOrder = 8
    Value = 4
    OnChange = SizeEditChange
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 436
    Width = 699
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  '#169' 2001, 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
  end
  object New2Btn: TButton
    Left = 16
    Top = 402
    Width = 161
    Height = 25
    Caption = 'New with max  moves to solve ='
    TabOrder = 10
    OnClick = New2BtnClick
  end
  object NbrMovesEdit: TSpinEdit
    Left = 184
    Top = 402
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 11
    Value = 4
  end
end
