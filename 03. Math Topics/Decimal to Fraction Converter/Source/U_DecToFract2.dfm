object Form1: TForm1
  Left = 192
  Top = 119
  Width = 800
  Height = 549
  Caption = 'Decimal to Fraction  V2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 384
    Top = 408
    Width = 170
    Height = 20
    Caption = 'Answer displays here'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 384
    Top = 296
    Width = 129
    Height = 25
    AutoSize = False
    Caption = 'Max denominator            (for terminating decimals)'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 384
    Top = 32
    Width = 92
    Height = 13
    Caption = 'Input decimal value'
  end
  object Label3: TLabel
    Left = 384
    Top = 80
    Width = 78
    Height = 13
    Caption = 'Click to try these'
  end
  object Edit1: TEdit
    Left = 384
    Top = 48
    Width = 177
    Height = 21
    TabOrder = 0
    Text = '.142857'
    OnKeyPress = Edit1KeyPress
  end
  object SolveBtn: TButton
    Left = 384
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 1
    OnClick = SolveBtnClick
  end
  object SpinEdit1: TSpinEdit
    Left = 384
    Top = 328
    Width = 81
    Height = 22
    MaxValue = 1000000
    MinValue = 2
    TabOrder = 2
    Value = 100
  end
  object ListBox1: TListBox
    Left = 384
    Top = 96
    Width = 177
    Height = 97
    ItemHeight = 13
    Items.Strings = (
      '1.25'
      '0.125'
      '3.063829787'
      '0.02'
      '.1538461538'
      '0.123456789'
      '.023255813953488372093')
    TabOrder = 3
    OnClick = ListBox1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 329
    Height = 457
    Color = 14548991
    Lines.Strings = (
      
        'A little program of little use unless you are a programmer curio' +
        'us'
      'about how to convert a decimal number to a fraction.'
      ''
      
        'We start by separating the integer part from the decimal part of' +
        ' the '
      
        'input number.  Multiply the fractional part by a power of 10 lar' +
        'ge '
      
        'enough to convert it to an integer, i.e. 10 raised to the power ' +
        'of the '
      
        'number of digits in the fractional part. (e.g. for 0.123, multip' +
        'ly by 10^3 '
      '= 123).'
      ''
      
        'So we now have our first try at a fraction form answer (123/1000' +
        '). '
      'We'#39'll reduce it to lowest terms by dividing numerator and '
      
        'denominator by the greatest common denominator of the two.  If t' +
        'he'
      
        'denominator is less than or equal to the sepcified max denominat' +
        'or'
      'size, we'#39're done.'
      ''
      
        'Otherwise, we'#39'll have to provide the closest possible estimate w' +
        'hose'
      
        'denominator is smaller than the maximum specified.  We'#39'll just t' +
        'ry all'
      'denominators from 2 to the max specified and calculate the'
      
        'numerator which produce a value closest to the original decimal ' +
        'part.'
      
        ' Numerator = ((original decimal part) x trial denominator) round' +
        'ed to'
      'the nearest integer.'
      ''
      
        'The error of this estimate is original decimal part - numerator ' +
        '/ trial '
      
        'denominator.  We'#39'll save the numerator and trial denominator whi' +
        'ch '
      
        'produces trhe smallest absolute error and report that as the sol' +
        'ution.'
      ''
      
        'Version 2 uses a large integer model to allow conversion of deci' +
        'mal '
      
        'representation for rational numbers with large cycless (decimal ' +
        'for '
      '1/43 repeats every 21 digits, 1/29 repeats every 28 digits)with '
      'largelarge  ')
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 502
    Width = 792
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
  object RadioGroup1: TRadioGroup
    Left = 384
    Top = 208
    Width = 177
    Height = 73
    Caption = 'Repeating pattern'
    ItemIndex = 0
    Items.Strings = (
      'Decimal part temrinates'
      'Decimal part repeats forever')
    TabOrder = 6
  end
end
