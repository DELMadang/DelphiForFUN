object Form1: TForm1
  Left = 140
  Top = 109
  Width = 806
  Height = 528
  ActiveControl = Edit1
  Caption = 'Taylor series '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 20
  object XLbl: TLabel
    Left = 248
    Top = 296
    Width = 72
    Height = 20
    Caption = 'X in e^X:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StepsLbl: TLabel
    Left = 248
    Top = 368
    Width = 98
    Height = 20
    Caption = 'Nbr steps: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 400
    Top = 8
    Width = 223
    Height = 20
    Caption = 'Step values of series expansion'
  end
  object Edit1: TEdit
    Left = 248
    Top = 320
    Width = 129
    Height = 28
    TabOrder = 0
    Text = '1.0'
    OnExit = Edit1Exit
  end
  object ListBox1: TListBox
    Left = 400
    Top = 32
    Width = 361
    Height = 409
    ItemHeight = 20
    TabOrder = 1
  end
  object EvalBtn: TButton
    Left = 8
    Top = 376
    Width = 185
    Height = 25
    Caption = 'Evaluate next step'
    TabOrder = 2
    OnClick = EvalBtnClick
  end
  object ResetBtn: TButton
    Left = 8
    Top = 416
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
  object FuncGrp: TRadioGroup
    Left = 8
    Top = 296
    Width = 185
    Height = 65
    Caption = 'Function'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'e^x'
      'sin(x)'
      'cos(x)')
    TabOrder = 4
    OnClick = FuncGrpClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 377
    Height = 273
    Color = 14548991
    Lines.Strings = (
      'Taylor power series or, more properly, a version '
      'known as a Maclaurin power series,  may be used to '
      'accurately evaluate a number of important functions. '
      ' '
      'Illustrated here are the  exponential function, e^x, '
      'and the trig function sine(x).  '
      '------------  e^x = 1+x + x^2/2! + x^3/3! + x^4/4! .... '
      '------------- sine(x) = x - x^3/3! + x^5/5! - x^7/7! ....   '
      ''
      'The symbol " ^ " means "raised to the power", and " '
      'N! ",  the factorial function, is the product of the '
      'numbers from 1 to N.  Evaluation is step by step until '
      'maximum internal accuracy is reached.')
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 473
    Width = 798
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
