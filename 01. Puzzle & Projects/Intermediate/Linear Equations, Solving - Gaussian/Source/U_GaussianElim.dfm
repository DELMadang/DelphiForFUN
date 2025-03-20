object Form1: TForm1
  Left = 192
  Top = 120
  Width = 739
  Height = 600
  Caption = 
    'Solving a set of linear equations  (Gaussian Elimination w/ Part' +
    'ial Pivoting)'
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
  object Label1: TLabel
    Left = 24
    Top = 248
    Width = 61
    Height = 20
    Caption = 'Input file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 344
    Top = 248
    Width = 54
    Height = 20
    Caption = 'Results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SolveBtn: TButton
    Left = 344
    Top = 200
    Width = 153
    Height = 25
    Caption = 'Solve equations'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object Memo1: TMemo
    Left = 336
    Top = 272
    Width = 337
    Height = 265
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 24
    Top = 8
    Width = 561
    Height = 177
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'A program illustrates a technique for solving a system of linear' +
        ' equations using Gaussian Elimination with Partial'
      
        'Pivoting as described in  "Numerical Analysis" Bunden & Faires, ' +
        '1985 pp 291-304 & 324-327.'
      ''
      
        'Inputs are from a file containing  the number of variables on th' +
        'e first line, a matrix of equation coefficients, one'
      
        'equation per line, ,  and a vector containing the constant terms' +
        ', one value per line.'
      ''
      'The sample data SAMPLE6A.TXT file solves this set of equations:'
      ''
      'w + 2x - z =10'
      '-w + 4x + 3y - 0.5z = 21.5'
      '2w + 2x + y - 3z = 26'
      '3y - 4z = 37'
      ''
      ''
      '')
    ParentFont = False
    TabOrder = 2
  end
  object Memo3: TMemo
    Left = 16
    Top = 272
    Width = 305
    Height = 265
    TabOrder = 3
  end
  object ReadBtn: TButton
    Left = 24
    Top = 200
    Width = 153
    Height = 25
    Caption = 'Read the file'
    TabOrder = 4
    OnClick = ReadBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 549
    Width = 731
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text data files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 608
    Top = 32
  end
end
