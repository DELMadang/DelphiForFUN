object Form1: TForm1
  Left = 231
  Top = 125
  Width = 922
  Height = 600
  Caption = 'Multivariate Newton-Raphson Demo V1.0 '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object XLbl: TLabel
    Left = 366
    Top = 128
    Width = 17
    Height = 19
    Caption = 'X:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object YLbl: TLabel
    Left = 446
    Top = 128
    Width = 16
    Height = 19
    Caption = 'Y:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 368
    Top = 200
    Width = 121
    Height = 33
    AutoSize = False
    Caption = 'Maximum # of iterations'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 368
    Top = 264
    Width = 137
    Height = 33
    AutoSize = False
    Caption = 'Stop when residuals are less than'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 368
    Top = 104
    Width = 137
    Height = 17
    AutoSize = False
    Caption = 'Initial Variable values'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object ZLbl: TLabel
    Left = 366
    Top = 160
    Width = 15
    Height = 19
    Caption = 'Z:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object WLbl: TLabel
    Left = 442
    Top = 160
    Width = 21
    Height = 19
    Caption = 'W:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label8: TLabel
    Left = 368
    Top = 32
    Width = 100
    Height = 16
    Caption = 'Nbr of variables'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CurrentLbl: TLabel
    Left = 392
    Top = 432
    Width = 124
    Height = 16
    Caption = 'Current Case: Default'
  end
  object DescLbl: TLabel
    Left = 384
    Top = 464
    Width = 417
    Height = 65
    AutoSize = False
    Caption = 'Circle intersects parabola opening upward'
    WordWrap = True
  end
  object Solvebtn: TButton
    Left = 392
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Solve'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = SolvebtnClick
  end
  object Memo1: TMemo
    Left = 528
    Top = 24
    Width = 369
    Height = 385
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Results display here')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 8
    Top = 16
    Width = 345
    Height = 433
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This is an intial version to test our NewtonMulti'
      'procedure which finds zeros of a system of non-linear '
      '(or linear) equations.  It works by successively '
      'estimating variable values which satisfy the equations.  '
      'Each estimate moves closer to the solution by '
      'calculating where the function would equal zero if it '
      'were on a straight line passing through the previous '
      'estimate and with a slope represented by the partial '
      'derivative of that variable at that point.'
      ''
      'For simplicity, this program solves a 1 to 4  variable '
      'systems with the same number of quadratic '
      'equations.  The initial equations are:  '
      ''
      '   f1(x,y) = x^2 + y^2 - 4 = 0  (A circle with radius 2 '
      '                                        centered at the origin)'
      ''
      '   f2(x,y) = x^2 - y - 1 = 0  (A parabola opening upward '
      
        '                                and crossing the Y axis at (0,-1' +
        ')'
      ''
      'This example is adapted from lecture notes found at'
      'http://clausius.engr.utk.edu/che301/pdf/systems.pdf.  '
      'The code was developed based largely on information '
      'contained there. '
      ''
      'The "Nbr of Variables" field  sets the size of the '
      'system '
      'to be solved.  A "Set Coefficients" button allows '
      'equation coeffiecients to be  set for the specified '
      'system size.'
      ''
      'For the above initial equations, the partial derivatives'
      'are:'
      ''
      '   d(f1)/d(x)= 2x  d(f1)/d(y) = 2y'
      '   d(f2)/d(x)= 2X  d(f2)/d(y))= -1'
      ''
      'This matrix, called the Jacobian matrix, is required to '
      'calculate the next guess for each variable as the '
      'Newton-Raphson method is applied.  For this demo '
      'the code to evaluate the Jacobian for quadratic '
      'equations is included in the code.  It is possible to '
      'define a set of coordinates for which no solution '
      'exists, specifically if the Jacobian is "singular", it '
      'determinant =0 which occurs if any row of column of '
      'coefficients is zero, or ant two row or columns of '
      'coefficients have matching values.   '
      ''
      'The user can set the maximum error for any variable '
      'value before terminatinbg the N-R search as well as '
      'the maximum number of iterations before stopping..')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object Xedt: TEdit
    Left = 384
    Top = 128
    Width = 49
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '1.0'
  end
  object YEdt: TEdit
    Left = 464
    Top = 128
    Width = 49
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = '2.0'
  end
  object MaxiterEdt: TEdit
    Left = 448
    Top = 216
    Width = 52
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = '10'
  end
  object MaxTolEdt: TEdit
    Left = 448
    Top = 280
    Width = 52
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = '0.0001'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 906
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 7
    OnClick = StaticText1Click
  end
  object VerboseBox: TCheckBox
    Left = 368
    Top = 328
    Width = 137
    Height = 41
    Caption = 'Show intermediate results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    WordWrap = True
  end
  object SetCoeffBtn: TButton
    Left = 360
    Top = 64
    Width = 161
    Height = 25
    Caption = 'Set coefficients'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = SetCoeffBtnClick
  end
  object ZEdt: TEdit
    Left = 384
    Top = 160
    Width = 49
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 10
    Text = '1.0'
  end
  object WEdt: TEdit
    Left = 464
    Top = 160
    Width = 49
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 11
    Text = '2.0'
    Visible = False
  end
  object NbrVar: TSpinEdit
    Left = 480
    Top = 32
    Width = 41
    Height = 26
    MaxValue = 4
    MinValue = 1
    TabOrder = 12
    Value = 2
    OnChange = NbrVarChange
  end
  object LoadBtn: TButton
    Left = 696
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Load...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = LoadBtnClick
  end
  object SaveBtn: TButton
    Left = 816
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Save...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 14
    OnClick = SaveBtnClick
  end
  object Button1: TButton
    Left = 152
    Top = 504
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 15
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Ini files (*.ini)|*.ini|All files(*.*)|*.*'
    Left = 32
    Top = 456
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Ini files (*.ini)|*.ini|All files(*.*)|*.*'
    Left = 80
    Top = 456
  end
end
