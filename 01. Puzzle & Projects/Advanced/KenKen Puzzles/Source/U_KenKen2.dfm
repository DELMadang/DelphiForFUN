object Form1: TForm1
  Left = 265
  Top = 67
  AutoScroll = False
  Caption = 'KenKen Puzzle Version 2.1'
  ClientHeight = 725
  ClientWidth = 1118
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 700
    Width = 1118
    Height = 25
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1118
    Height = 700
    Align = alClient
    AutoSize = True
    TabOrder = 1
    object Label1: TLabel
      Left = 592
      Top = 23
      Width = 267
      Height = 21
      Caption = 'Current puzzle:  No puzzle loaded'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ErrLbl: TLabel
      Left = 600
      Top = 360
      Width = 231
      Height = 32
      Hint = 'Use Check button for details'
      Caption = 'ERRORS FOUND!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -27
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      Visible = False
    end
    object BoardGrid: TStringGrid
      Left = 592
      Top = 63
      Width = 264
      Height = 265
      BorderStyle = bsNone
      ColCount = 4
      DefaultColWidth = 48
      DefaultRowHeight = 48
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 4
      FixedRows = 0
      TabOrder = 0
      OnDrawCell = BoardGridDrawCell
      OnKeyPress = BoardGridKeyPress
    end
    object Memo2: TMemo
      Left = 24
      Top = 23
      Width = 544
      Height = 529
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'KenKen puzzles are similar to Sudoku except with a little math'
        'thrown in!  The board is divided into sections called "cages".  '
        'Each cage has an operator and a target value in the upper '
        
          'corner.  The numbers filled into the cell in the cage must combi' +
          'ne '
        
          'in any order using the given operation to form the target value.' +
          '  '
        'The values to use are in the range of 1 through the number of '
        'columns (or rows) in the puzzle.  Each unique value(for example '
        
          '1,2,3,4,5 in the 5x5 puzzle), must occur exactly once in each ro' +
          'w '
        'and column. .'
        ''
        'Use mouse or arrow keys to select cells and enter a value for'
        'each one.'
        ''
        'The "Check"  button will validate the case defintion and the'
        
          'values entered.   When all cells have been filled, it will be ca' +
          'lled '
        
          'after every number entered.  (Note:: Version 2,1 removes this ac' +
          'tion.) '
        ' You can click the button anytime to check progress so far.'
        ''
        'This initial version was a testbed for development of a'
        
          'computerized "solver" algorithm.  Additonal cases may be defined' +
          ' '
        
          'using formatting information included in the test files "aarp1.t' +
          'xt'#39' or '
        '"medium6x6.txt".'
        ''
        
          'Version 2 adds the computer solve button and one additional samp' +
          'le,'
        
          '"hard9x9.txt".  The program takes a second or two to solve this ' +
          'one.'
        ''
        'Version 2,1 improves user play by removing the default error '
        
          'messages when all cells are filled but the solution is incorrect' +
          '.  '
        
          'Indication is now displayed that  an error exists without stoppi' +
          'ng play.  '
        
          'Use the "Check" button to see specific errors. Also, entries may' +
          ' now '
        'be removed using the space bar.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object LoadBtn: TButton
      Left = 23
      Top = 576
      Width = 161
      Height = 24
      Caption = 'Load case'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = LoadBtnClick
    end
    object CheckBtn: TButton
      Left = 223
      Top = 576
      Width = 160
      Height = 24
      Caption = 'Check'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = CheckBtnClick
    end
    object SolveBtn: TButton
      Left = 23
      Top = 624
      Width = 168
      Height = 24
      Caption = 'Solve it'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = SolveBtnClick
    end
    object Verbosebox: TCheckBox
      Left = 229
      Top = 626
      Width = 270
      Height = 15
      Caption = 'Show recursive search steps'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'KenKen Cases (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 1108
    Top = 331
  end
end
