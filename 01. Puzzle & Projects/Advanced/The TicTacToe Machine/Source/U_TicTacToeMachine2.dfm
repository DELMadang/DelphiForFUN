object Form1: TForm1
  Left = 280
  Top = 145
  AutoScroll = False
  AutoSize = True
  Caption = 'Tic-Tac-Toe Machine V2.0'
  ClientHeight = 825
  ClientWidth = 1352
  Color = clBtnFace
  Constraints.MinWidth = 890
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 160
    Top = 8
    Width = 409
    Height = 20
    Caption = '     Matchbox grid  patterns && weights(bead counts)'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 600
    Top = 0
    Width = 63
    Height = 13
    Caption = 'Run statistics'
  end
  object Label6: TLabel
    Left = 168
    Top = 48
    Width = 360
    Height = 16
    Caption = ' #      Pattern      Starting weights        Current Weights'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ResultLbl: TLabel
    Left = 16
    Top = 144
    Width = 81
    Height = 16
    Caption = 'No results yet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Intro: TMemo
    Left = 160
    Top = 8
    Width = 433
    Height = 577
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's an artificial intelligence demonstration of a "machine"'
      'that learns to play tic-tac-toe by trial and error. This is a'
      'computer model of the original machine, MENACE, invented by'
      'Donald Michie in 1961 using 300 matchboxes representing 300'
      'board positions.  Each box contains uniquely colored beads for'
      'each available cell in a specific board configuration.'
      ''
      'The machine always plays first.  It plays by selecting a bead'
      
        'randomly from the box representing the cell to play in the curre' +
        'nt'
      'board configuration.  When it wins or draws it is "rewarded" by'
      'adding beads of the winning move colors to each box used. Losses'
      'are punished by confiscating the selected beads.  The "Advanced'
      ''
      'Setup" in thus simulation button will let you adjust  Michie'#39's'
      'values  for intial setup and beads added or subtracted for good'
      'or bad results.You may use the  "Start" button to play and train'
      'the machine or use  the "AutoPlay" button to train the machine.'
      
        'It may take a  few thousand random games to train it well. If yo' +
        'u'
      
        'play manually, the machine will probably lose  most of the 1st 5' +
        '0'
      'games, but win most of the 2nd 50.'
      ''
      'Version 2.0 allows selection of Opponent strategies:'
      '1) Random - the original respnse,'
      
        '2) Smart Random - handle a couple of tricky boatd configuration ' +
        'on'
      'moves 2 and 4, then choose the center or and avilale corner.'
      '3) Block "X" winnig cell first, ,then random.'
      '4) Complete our ("O") wins if available then random.'
      
        '5)  (Most human-like?) Apply 4, 3, 2, 1 strategies in that order' +
        '.'
      ''
      'The AutoPlay button or Manual play now display information about'
      'the last 100  games played .  Clicking an entry in the list will'
      'animate a  playback of that game.'
      ''
      
        'The Pattern display now showsthe initial weights (# of beads in ' +
        'each cell '
      
        'of the board, one color per cell, in the real MENACE machine).  ' +
        '              '
      '                           .'
      ''
      '')
    ParentFont = False
    TabOrder = 5
  end
  object Panel1: TPanel
    Left = 0
    Top = 280
    Width = 161
    Height = 265
    Color = 16756398
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    object Label2: TLabel
      Left = 8
      Top = 176
      Width = 11
      Height = 18
      Caption = 'N'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AutoGrp: TRadioGroup
      Left = 0
      Top = 8
      Width = 161
      Height = 153
      Hint = '"Smat: randomly fills corners, then center, then edges '
      Caption = 'AutoPlay oppoent IQ'
      Color = 16756398
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        '1) Random move'
        '2) "Smart" random'
        '3) Stop "X" win'
        '4) Finish "O" win'
        '5) Try all (4,3,2,1)')
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object GameCount: TSpinEdit
      Left = 24
      Top = 176
      Width = 73
      Height = 30
      Color = 16756398
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 10000
      MinValue = 1
      ParentFont = False
      TabOrder = 1
      Value = 20
    end
    object AutoPlayBtn: TButton
      Left = 12
      Top = 214
      Width = 141
      Height = 25
      Caption = 'AutoPlay N games'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = AutoPlayBtnClick
    end
    object Verbose: TCheckBox
      Left = 32
      Top = 240
      Width = 97
      Height = 17
      Caption = 'Verbose'
      TabOrder = 3
    end
  end
  object Memo1: TMemo
    Left = 160
    Top = 64
    Width = 433
    Height = 521
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Lucida Sans Typewriter'
    Font.Style = []
    Lines.Strings = (
      ''
      ''
      ''
      ''
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 10
  end
  object StringGrid1: TStringGrid
    Left = 16
    Top = 16
    Width = 129
    Height = 129
    ColCount = 3
    DefaultColWidth = 40
    DefaultRowHeight = 40
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Comic Sans MS'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = StringGrid1Click
  end
  object IntroBtn: TButton
    Left = 8
    Top = 544
    Width = 129
    Height = 33
    Caption = 'Toggle Introduction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = IntroBtnClick
  end
  object Memo2: TMemo
    Left = 600
    Top = 16
    Width = 353
    Height = 137
    TabOrder = 8
  end
  object AdvancedBtn: TButton
    Left = 8
    Top = 592
    Width = 129
    Height = 25
    Caption = 'Advanced setup'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = AdvancedBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 805
    Width = 1352
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2002-2017, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 6
    Transparent = False
    OnClick = StaticText1Click
  end
  object ResetWeightsBtn: TButton
    Left = 88
    Top = 232
    Width = 57
    Height = 41
    Caption = 'Reset weights'
    TabOrder = 2
    WordWrap = True
    OnClick = ResetWeightsBtnClick
  end
  object StartBtn: TButton
    Left = 8
    Top = 168
    Width = 137
    Height = 41
    Caption = 'Start  a manual game'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    WordWrap = True
    OnClick = StartBtnClick
  end
  object ResetBtn: TButton
    Left = 8
    Top = 232
    Width = 65
    Height = 41
    Caption = 'Reset run statistics'
    TabOrder = 0
    WordWrap = True
    OnClick = ResetBtnClick
  end
  object DebugPanel: TPanel
    Left = 600
    Top = 160
    Width = 377
    Height = 425
    Constraints.MinWidth = 377
    TabOrder = 3
    object Memo5: TMemo
      Left = 0
      Top = 8
      Width = 353
      Height = 105
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Transforms: There are several thousand unique Tic-Tac_Toe '
        'boards.  Each can be transformed into one of the 304 unique '
        'boards by a combination of rotating and flipping the grid.  The'
        'Games history list below displays the original grid, the  '
        'transform required, and the "matchbox" number of the '
        'stadardized grid displayed at left.')
      ParentFont = False
      TabOrder = 1
    end
    object Memo3: TMemo
      Left = 1
      Top = 119
      Width = 375
      Height = 305
      Align = alBottom
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Information about the last 100 games played by "AutoPlay" '
        'button clicks will display here.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnClick = Memo3Click
    end
  end
end
