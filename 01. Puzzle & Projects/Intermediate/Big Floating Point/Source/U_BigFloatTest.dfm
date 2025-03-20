object OpBox: TOpBox
  Left = 129
  Top = 114
  Width = 1436
  Height = 920
  Caption = 'BigFloat (Version 2.0)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBtnText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 30
    Top = 59
    Width = 44
    Height = 16
    Caption = 'Normal'
  end
  object Label2: TLabel
    Left = 30
    Top = 79
    Width = 53
    Height = 16
    Caption = 'Scientific'
  end
  object Label3: TLabel
    Left = 30
    Top = 167
    Width = 44
    Height = 16
    Caption = 'Normal'
  end
  object Label4: TLabel
    Left = 30
    Top = 197
    Width = 53
    Height = 16
    Caption = 'Scientific'
  end
  object Label5: TLabel
    Left = 20
    Top = 354
    Width = 44
    Height = 16
    Caption = 'Normal'
  end
  object Label6: TLabel
    Left = 10
    Top = 443
    Width = 53
    Height = 16
    Caption = 'Scientific'
  end
  object Result: TLabel
    Left = 20
    Top = 325
    Width = 59
    Height = 24
    Caption = 'Result'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 10
    Top = 30
    Width = 16
    Height = 24
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 10
    Top = 138
    Width = 14
    Height = 24
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 230
    Top = 266
    Width = 179
    Height = 31
    AutoSize = False
    Caption = 'Max digits to display'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label10: TLabel
    Left = 601
    Top = 30
    Width = 93
    Height = 24
    Caption = 'Operation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object AllocLbl: TLabel
    Left = 72
    Top = 696
    Width = 135
    Height = 19
    Caption = 'Allocated memory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object StopBtn: TButton
    Left = 20
    Top = 266
    Width = 109
    Height = 31
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    Visible = False
    OnClick = StopBtnClick
  end
  object Edit1: TEdit
    Left = 30
    Top = 30
    Width = 532
    Height = 24
    TabOrder = 0
    Text = '4.91234567891e-5'
  end
  object Edit2: TEdit
    Left = 30
    Top = 138
    Width = 532
    Height = 24
    TabOrder = 1
    Text = '41'
  end
  object TestBtn: TButton
    Left = 20
    Top = 256
    Width = 109
    Height = 31
    Caption = 'Do it'
    TabOrder = 2
    OnClick = TestBtnClick
  end
  object N1NormLbl: TStaticText
    Left = 98
    Top = 59
    Width = 25
    Height = 20
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
  end
  object N1SciLbl: TStaticText
    Left = 98
    Top = 79
    Width = 25
    Height = 20
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCaptionText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
  end
  object N2NormLbl: TStaticText
    Left = 108
    Top = 167
    Width = 25
    Height = 20
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
  end
  object N2SciLbl: TStaticText
    Left = 108
    Top = 197
    Width = 25
    Height = 20
    Caption = 'xxx'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
  end
  object Maxdigits: TSpinEdit
    Left = 414
    Top = 266
    Width = 70
    Height = 35
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MaxValue = 1000
    MinValue = 2
    ParentFont = False
    TabOrder = 7
    Value = 30
  end
  object Memo1: TMemo
    Left = 601
    Top = 414
    Width = 392
    Height = 237
    Color = 14548991
    Lines.Strings = (
      'This is an investigaton of algorithms to manipulate  large '
      'floating point numbers.   '
      ''
      'Internally,  additions and subtractions shift number to align '
      'virtual decimal points and the use "big integer" arithmetic to '
      'perform the  operation.'
      ''
      'Multiplications simply multiply the numbers as if they were big '
      'integers and then add the exponent values.'
      ''
      'Divide makes successive  guesses for quotient and compares '
      
        'quotient X divisor to the input dividend. until the difference i' +
        's '
      'less than the number of significant digits to be displayed .   ')
    TabOrder = 8
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 855
    Width = 1418
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2003-2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
  object OpList: TListBox
    Left = 591
    Top = 59
    Width = 405
    Height = 336
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 24
    Items.Strings = (
      'X + Y'
      'X - Y'
      'X * Y'
      'X / Y'
      'X^2'
      'Sqrt(X)'
      '1/X {Reciprocal}'
      'Yth Power X^Y   {Y integer}'
      'Yth Root  (X^1/Y)  {Y integer}'
      'Compare X to Y'
      'X^Y {Y floating point}'
      'Log(X) {Natural log}'
      'Log10(X)'
      'Exp(X)'
      'Pi'
      'X RoundToPrec(Y) {Y= signif. digits}'
      'X Round(Y) {Y = pos relative to dec. pt.}'
      'X Trunc(Y) {Y = pos relative to dec. pt.}'
      'X Floor(Y) {Y = pos relative to dec. pt.}'
      'X Ceiling(Y){Y = pos relative to dec. pt.}'
      ' ')
    ParentFont = False
    TabOrder = 11
    OnDblClick = OpListDblClick
  end
  object ResultN: TMemo
    Left = 69
    Top = 354
    Width = 495
    Height = 80
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object ResultS: TMemo
    Left = 69
    Top = 443
    Width = 495
    Height = 80
    ScrollBars = ssVertical
    TabOrder = 13
  end
  object MoveBtn: TButton
    Left = 69
    Top = 542
    Width = 129
    Height = 30
    Caption = 'Move result to X'
    Enabled = False
    TabOrder = 14
    OnClick = MoveBtnClick
  end
  object Button1: TButton
    Left = 58
    Top = 630
    Width = 279
    Height = 31
    Caption = 'Debug: Special Euro rounding test'
    TabOrder = 15
    Visible = False
    OnClick = Button1Click
  end
end
