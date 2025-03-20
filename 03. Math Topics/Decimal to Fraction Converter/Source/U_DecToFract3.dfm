object Form1: TForm1
  Left = 192
  Top = 119
  Width = 800
  Height = 549
  Caption = 'Decimal to Fraction  V3'
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
    Left = 392
    Top = 448
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
  object Label1: TLabel
    Left = 384
    Top = 16
    Width = 150
    Height = 13
    Caption = 'Input decimal or fractional value'
  end
  object Label3: TLabel
    Left = 384
    Top = 64
    Width = 78
    Height = 13
    Caption = 'Click to try these'
  end
  object RadioGroup2: TRadioGroup
    Left = 384
    Top = 240
    Width = 345
    Height = 145
    Caption = 'Report input as'
    ItemIndex = 0
    Items.Strings = (
      'Decimal -  up to '
      'Fraction (denominator up to specified max)'
      'Fraction (multiples of 1/16)'
      'Fraction (multiples of 1/32)'
      'Fraction (multiples of 1/64)')
    TabOrder = 6
    OnClick = RadioGroup2Click
  end
  object Edit1: TEdit
    Left = 384
    Top = 32
    Width = 177
    Height = 21
    TabOrder = 0
    Text = '.142857'
    OnKeyPress = Edit1KeyPress
    OnKeyUp = Edit1KeyUp
  end
  object SolveBtn: TButton
    Left = 384
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 1
    OnClick = SolveBtnClick
  end
  object SpinEdit1: TSpinEdit
    Left = 616
    Top = 280
    Width = 57
    Height = 22
    MaxValue = 1000000
    MinValue = 2
    TabOrder = 2
    Value = 100
    OnChange = RadioGroup2Click
  end
  object ListBox1: TListBox
    Left = 384
    Top = 88
    Width = 369
    Height = 121
    Columns = 2
    ItemHeight = 13
    Items.Strings = (
      '1.25'
      '3.063829787'
      '0.02'
      '.1538461538'
      '0.123456789'
      '.023255813953488372'
      '1/4'
      '2 3/32'
      '27/64'
      '1 5/8'
      '45 3/16')
    TabOrder = 3
    OnClick = ListBox1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 329
    Height = 441
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Version 3 of decimal to fraction enhances the '
      'previous version  by accepting  input in '
      'decimal or fractional format and displaying '
      'output in either format.  It was written as a '
      'test bed for routines which will be '
      'incorporated  in programs which need   '
      '"carpenter arithemtic".  Woodworking '
      'dimensions, at least in USA and UK are '
      'normally given in feet plus  inches and '
      'fractions of inches, typically no finer than '
      '1/32". '
      ''
      'Version 2 used the TInteger large integer '
      'class to exactly represent the digits in a  cycle '
      'of the repeating decimal for any rational '
      'number.   For version 3, that ability was '
      'removed on the basis that 18 digits is enough '
      'for practical purposes.'
      ''
      ' ')
    ParentFont = False
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
    Caption = 'Copyright  © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object SpinEdit2: TSpinEdit
    Left = 488
    Top = 257
    Width = 49
    Height = 22
    MaxValue = 18
    MinValue = 0
    TabOrder = 7
    Value = 6
    OnChange = RadioGroup2Click
  end
  object StaticText2: TStaticText
    Left = 544
    Top = 260
    Width = 103
    Height = 17
    Caption = 'decimal digits  (<=18)'
    TabOrder = 8
  end
end
