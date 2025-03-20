object Form1: TForm1
  Left = 289
  Top = 193
  Width = 800
  Height = 500
  Caption = 'Expression Evaluator V1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 120
    Top = 168
    Width = 79
    Height = 13
    Caption = 'Variable Values  '
  end
  object Label2: TLabel
    Left = 392
    Top = 168
    Width = 56
    Height = 13
    Caption = 'Expressions'
  end
  object Label3: TLabel
    Left = 223
    Top = 328
    Width = 35
    Height = 13
    Caption = 'Results'
  end
  object Variables: TMemo
    Left = 120
    Top = 184
    Width = 233
    Height = 89
    Lines.Strings = (
      'Gary=2'
      'Ron=7'
      'Pete=2.4')
    TabOrder = 0
  end
  object Expressions: TMemo
    Left = 392
    Top = 184
    Width = 249
    Height = 89
    Lines.Strings = (
      '2*Ron'
      'Gary'
      '2*(Ron+4)'
      '2/3*(Ron-4)'
      '2*(Pete+1.5)*(gary+9.3)+27/8*(ron-1.1)')
    TabOrder = 1
  end
  object Results: TMemo
    Left = 223
    Top = 344
    Width = 345
    Height = 89
    TabOrder = 2
  end
  object EvaluateBtn: TButton
    Left = 336
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Evaluate'
    TabOrder = 3
    OnClick = EvaluateBtnClick
  end
  object Verbosebox: TCheckBox
    Left = 464
    Top = 296
    Width = 225
    Height = 17
    Caption = 'Show solving steps'
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 453
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 753
    Height = 145
    Color = 14548991
    Lines.Strings = (
      
        'This is a program illustrating techniques to evaluate arithmetic' +
        ' expressions using a "Postfix" list  to hold the operands and op' +
        'erators in '
      
        'just the right order so that the actual evaluation is quite simp' +
        'le.  The tricky part is getting the expression from "Infix" nota' +
        'tion (the way we usually write '
      
        'expressions with the operators between two operands),  to Postfi' +
        'x notation where each operation applies to the two operands prec' +
        'eding it.  The expression 2*'
      
        '(Ron+4) for example becomes {2,Ron,4,+,*}.  When evaluating, wor' +
        'k fom left to right , replacing each operation and the two opera' +
        'nds preceding it with the '
      
        'result of the operation.   Click the "Show solving steps" checkb' +
        'ox and then "Evaluate" to see a more detailed illustration of th' +
        'e process.'
      ''
      
        'For this demo version, only low resolution floating point values' +
        ' are used and only the basic arithemtic operations (+.-.*/)  and' +
        ' parentheses have been '
      'implemented. '
      ''
      
        'Enter variable names and values in the left side box below, one ' +
        'per line,  and expressions in the right side box.')
    TabOrder = 6
  end
end
