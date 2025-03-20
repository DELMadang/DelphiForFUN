object Form1: TForm1
  Left = 563
  Top = 174
  Width = 986
  Height = 856
  Caption = 'Peg Solitaire   V4.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object FreqLabel: TLabel
    Left = 20
    Top = 315
    Width = 198
    Height = 41
    AutoSize = False
    Caption = 'FreqLabel'
    WordWrap = True
  end
  object Image1: TImage
    Left = 414
    Top = 108
    Width = 523
    Height = 523
    DragMode = dmAutomatic
    OnDragDrop = Image1DragDrop
    OnDragOver = Image1DragOver
    OnMouseUp = Image1MouseUp
    OnStartDrag = Image1StartDrag
  end
  object Label2: TLabel
    Left = 414
    Top = 20
    Width = 202
    Height = 24
    Caption = 'Click and drag to play'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 571
    Top = 79
    Width = 366
    Height = 16
    Caption = '(RIGHT CLICK LOCATIONS TO DEFINE A CUSTOM BOARD)'
  end
  object SolveBtn: TButton
    Left = 30
    Top = 278
    Width = 92
    Height = 30
    Caption = 'Auto-solve'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object Boardgrp: TRadioGroup
    Left = 28
    Top = 30
    Width = 365
    Height = 208
    Caption = 'Choose a board'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Cross'
      'Plus'
      'Fireplace'
      'Up Arrow'
      'Diamond'
      'Pyramid'
      'Solitaire'
      'Bart'#39's (~1 hour to solve!)'
      '"Cracker Barrel"'
      'Custom')
    TabOrder = 1
    OnClick = BoardgrpClick
  end
  object ResetBtn: TButton
    Left = 200
    Top = 279
    Width = 177
    Height = 31
    Caption = 'Reset to start positions'
    TabOrder = 2
    OnClick = ResetBtnClick
  end
  object SolveGrp: TRadioGroup
    Left = 20
    Top = 374
    Width = 158
    Height = 235
    Caption = 'Solution criteria'
    ItemIndex = 4
    Items.Strings = (
      '4  pegs left'
      '3  pegs left'
      '2 pegs left'
      '1 peg left anywhere'
      '1 peg left at hole ==>')
    TabOrder = 3
    OnClick = SolveGrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 790
    Width = 968
    Height = 21
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2010, Gary Darby,  http://DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object Diagonals: TCheckBox
    Left = 30
    Top = 246
    Width = 355
    Height = 21
    Caption = 'Allow "Cracker Barrel" (diagonal) moves'
    TabOrder = 5
    OnClick = DiagonalsClick
  end
  object ReplayPanel: TPanel
    Left = 22
    Top = 638
    Width = 365
    Height = 109
    TabOrder = 6
    Visible = False
    object Label1: TLabel
      Left = 39
      Top = 20
      Width = 41
      Height = 16
      Caption = 'Speed'
    end
    object ReplayBtn: TButton
      Left = 30
      Top = 69
      Width = 92
      Height = 31
      Hint = 'Replay solution moves'
      Caption = 'Replay'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = ReplayBtnClick
    end
    object Speedbar: TTrackBar
      Left = 112
      Top = 10
      Width = 224
      Height = 31
      Max = 200
      Position = 150
      TabOrder = 1
      OnChange = SpeedbarChange
    end
  end
  object Memo1: TMemo
    Left = 197
    Top = 384
    Width = 188
    Height = 121
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 192
    Top = 536
    Width = 121
    Height = 73
    Caption = 'Last Peg Location'
    TabOrder = 8
    object TargetXEdt: TLabeledEdit
      Left = 8
      Top = 41
      Width = 41
      Height = 24
      EditLabel.Width = 45
      EditLabel.Height = 16
      EditLabel.Caption = 'Column'
      TabOrder = 0
      Text = '4'
      OnChange = TargetEdtChange
    end
    object TargetYEdt: TLabeledEdit
      Left = 64
      Top = 41
      Width = 41
      Height = 24
      EditLabel.Width = 27
      EditLabel.Height = 16
      EditLabel.Caption = 'Row'
      TabOrder = 1
      Text = '4'
      OnChange = TargetEdtChange
    end
  end
  object Panel1: TPanel
    Left = 448
    Top = 656
    Width = 481
    Height = 113
    TabOrder = 9
    Visible = False
    object LoadBtn: TButton
      Left = 48
      Top = 24
      Width = 201
      Height = 25
      Caption = 'Load Custom Puzzle'
      TabOrder = 0
      OnClick = LoadBtnClick
    end
    object SaveBtn: TButton
      Left = 48
      Top = 72
      Width = 209
      Height = 25
      Caption = 'Save Custom Puzzle'
      TabOrder = 1
      OnClick = SaveBtnClick
    end
    object NewCustomBtn: TButton
      Left = 272
      Top = 64
      Width = 193
      Height = 25
      Caption = 'Start new Custom Puzzle'
      TabOrder = 2
      OnClick = NewCustomBtnClick
    end
  end
  object CrackerSizeBtn: TButton
    Left = 200
    Top = 320
    Width = 177
    Height = 25
    Caption = 'Set "CrackerBarrel" size'
    TabOrder = 10
    Visible = False
    OnClick = CrackerSizeBtnClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Puzzle text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select Custom puzzle to load '
    Left = 672
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Puzzle  text files (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select file or enter custom puzzle file name to save'
    Left = 736
    Top = 32
  end
end
