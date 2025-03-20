object Form1: TForm1
  Left = 206
  Top = 103
  Width = 707
  Height = 479
  Caption = 'Token Flip - The Final Chapter'
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
    Left = 256
    Top = 16
    Width = 433
    Height = 73
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
    Left = 16
    Top = 328
    Width = 49
    Height = 13
    Caption = 'Board size'
  end
  object MovesLbl: TLabel
    Left = 536
    Top = 120
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
  object ListBox1: TListBox
    Left = 536
    Top = 152
    Width = 153
    Height = 233
    ItemHeight = 13
    TabOrder = 1
  end
  object NewBoardBtn: TButton
    Left = 8
    Top = 395
    Width = 105
    Height = 25
    Caption = 'New random  board'
    TabOrder = 2
    OnClick = NewBoardBtnClick
  end
  object ResetBtn: TButton
    Left = 128
    Top = 356
    Width = 97
    Height = 25
    Caption = 'Restart'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 225
    Height = 297
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Tokens have a white side and a '
      'black side.  '
      ''
      'Objective is to turn all tokens so that '
      'the white side is showing.  Each click '
      'will turn over the clicked token plus '
      'up to 4 adjoining adjoining tokens '
      'located directly above, below, left or '
      'right of the clicked token.'
      ''
      'Board size can range from 2 to 10 '
      'tokens per side.  This version uses '
      'linear algebra to quickly find a '
      'solution if one exists  (Thanks to '
      'Bernd Hellema, '
      'b.hellema@zonnet.nl, for the solution '
      'technique and code implemented '
      'here.)'
      '')
    ParentFont = False
    TabOrder = 4
  end
  object ModeBtn: TButton
    Left = 128
    Top = 395
    Width = 201
    Height = 25
    Caption = 'Make a custom board'
    TabOrder = 5
    OnClick = ModeBtnClick
  end
  object SizeEdit: TSpinEdit
    Left = 72
    Top = 323
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = 2
    TabOrder = 6
    Value = 4
    OnChange = SizeEditChange
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 426
    Width = 699
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2001 - 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object New2Btn: TButton
    Left = 344
    Top = 395
    Width = 209
    Height = 25
    Caption = 'New board with max  moves to solve ='
    TabOrder = 8
    OnClick = New2BtnClick
  end
  object NbrMovesEdit: TSpinEdit
    Left = 552
    Top = 396
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 4
  end
  object SolveBtn: TButton
    Left = 8
    Top = 357
    Width = 105
    Height = 25
    Caption = 'Auto Solve'
    TabOrder = 10
    OnClick = SolveBtnClick
  end
end
