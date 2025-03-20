object Form1: TForm1
  Left = 318
  Top = 114
  Width = 827
  Height = 624
  Caption = '"Numbrix" (TM)'
  Color = 11531194
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object CaseNameLbl: TLabel
    Left = 360
    Top = 16
    Width = 145
    Height = 19
    Caption = 'Case name loaded '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 568
    Width = 811
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 337
    Height = 529
    Cursor = crArrow
    Color = 14548991
    Lines.Strings = (
      '"Numbrix" (Tradmearked) is a puzzle game currently '
      'appearing in the "Ask Marilyn" column of Parade '
      'Magazine.  The puzzles are satisfyingly solvable, some '
      'would say "too easy".   New Numbrix puzzles are '
      'currently (Sept, 08) being posted frequently on the '
      'www.parade.com web site. '
      ''
      'Given a square grid, fill the cells with a chain of integers '
      'from 1 to the number of cells (81 in a 9x9 grid, for '
      'example),  with each number adjoining the preceding '
      'one vertically or horizontally.  Some of the numbers are '
      'pre-filled, so your entries must of course match up to '
      'the pre-filled ones.'
      ''
      'You can solve the puzzle yourself by entering numbers '
      'in available squares (any that are not prefilled).  The '
      '"Check" button will verify any trial solution.  If you want '
      'some help, the "Fill forced locations" button will fill in '
      'all numbers which have only one valid location based '
      'the geometry of pre-filled values.  Each click will make '
      'one pass through the board filling additional numbers if '
      'possible. '
      ''
      'The "Solve" button does a depth-first search seach for a '
      'solution, backtracking for each dead-end path it tries.  '
      'Solve time is displayed in seconds or milliseconds so '
      'you can observe the  effect of pre-filling the forced '
      'locations on solution times if desired.   '
      ''
      'Controls used for debugging were left in place for future '
      'changes/fixes.  Users may use these to watch the '
      'search process if desired. ')
    TabOrder = 1
  end
  object Solvebtn: TButton
    Left = 360
    Top = 176
    Width = 132
    Height = 25
    Caption = 'Solve'
    TabOrder = 2
    OnClick = SolvebtnClick
  end
  object StringGrid1: TStringGrid
    Left = 504
    Top = 24
    Width = 289
    Height = 289
    ColCount = 9
    DefaultColWidth = 26
    DefaultRowHeight = 26
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 9
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goVertLine, goHorzLine, goEditing]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 3
    OnDrawCell = StringGrid1DrawCell
    OnSetEditText = StringGrid1SetEditText
  end
  object DebugBox: TGroupBox
    Left = 360
    Top = 328
    Width = 401
    Height = 217
    Caption = 'Debugging controls'
    Color = 11253240
    ParentColor = False
    TabOrder = 4
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 99
      Width = 142
      Height = 16
      Caption = 'Start show progress at #'
    end
    object Label2: TLabel
      Left = 9
      Top = 131
      Width = 141
      Height = 16
      Caption = 'Stop show progress at #'
    end
    object Label3: TLabel
      Left = 4
      Top = 179
      Width = 61
      Height = 16
      Caption = 'Stop when'
    end
    object Label4: TLabel
      Left = 115
      Top = 179
      Width = 113
      Height = 16
      Caption = 'is placed at column'
    end
    object Label5: TLabel
      Left = 281
      Top = 179
      Width = 20
      Height = 16
      Caption = 'row'
    end
    object Label6: TLabel
      Left = 139
      Top = 40
      Width = 90
      Height = 16
      Caption = ' Show progress'
    end
    object Label7: TLabel
      Left = 40
      Top = 40
      Width = 49
      Height = 16
      Caption = '<-slower'
    end
    object Label8: TLabel
      Left = 328
      Top = 40
      Width = 48
      Height = 16
      Caption = 'faster ->'
    end
    object SpinEdit1: TSpinEdit
      Left = 144
      Top = 95
      Width = 41
      Height = 26
      MaxValue = 81
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object SpinEdit2: TSpinEdit
      Left = 144
      Top = 127
      Width = 41
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 81
    end
    object SpinEdit3: TSpinEdit
      Left = 72
      Top = 175
      Width = 41
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 81
    end
    object SpinEdit4: TSpinEdit
      Left = 236
      Top = 175
      Width = 41
      Height = 26
      MaxValue = 9
      MinValue = 1
      TabOrder = 3
      Value = 1
    end
    object SpinEdit5: TSpinEdit
      Left = 304
      Top = 175
      Width = 41
      Height = 26
      MaxValue = 9
      MinValue = 1
      TabOrder = 4
      Value = 1
    end
    object Speedbar: TScrollBar
      Left = 40
      Top = 56
      Width = 345
      Height = 17
      Cursor = crArrow
      Max = 1000
      PageSize = 0
      Position = 999
      TabOrder = 5
      OnChange = SpeedbarChange
    end
    object Button3: TButton
      Left = 285
      Top = 80
      Width = 92
      Height = 25
      Cursor = crArrow
      Caption = 'Stop'
      TabOrder = 6
      OnClick = Button3Click
    end
  end
  object Loadbtn: TButton
    Left = 360
    Top = 56
    Width = 132
    Height = 25
    Caption = 'Load case'
    TabOrder = 5
    OnClick = LoadbtnClick
  end
  object ForceFillBtn: TButton
    Left = 360
    Top = 136
    Width = 132
    Height = 25
    Caption = 'Fill forced locations'
    TabOrder = 6
    OnClick = ForceFillBtnClick
  end
  object ReloadBtn: TButton
    Left = 360
    Top = 96
    Width = 132
    Height = 25
    Caption = 'Reload current case'
    TabOrder = 7
    OnClick = ReloadBtnClick
  end
  object Checkbtn: TButton
    Left = 360
    Top = 224
    Width = 129
    Height = 25
    Caption = 'Check'
    TabOrder = 8
    OnClick = CheckbtnClick
  end
  object DebugCheckBox: TCheckBox
    Left = 360
    Top = 304
    Width = 145
    Height = 17
    Caption = 'Show debug controls'
    TabOrder = 9
    OnClick = DebugCheckBoxClick
  end
  object PauseMemo: TMemo
    Left = 160
    Top = 320
    Width = 185
    Height = 105
    Color = clRed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      ' '
      '   Program paused.'
      ''
      'Click here to continue ')
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = PauseMemoClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 824
    Top = 464
  end
end
