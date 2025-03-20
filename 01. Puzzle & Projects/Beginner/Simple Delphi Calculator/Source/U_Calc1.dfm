object Form1: TForm1
  Left = 199
  Top = 279
  Width = 544
  Height = 108
  Caption = 'A simple calculator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Btn7: TButton
    Tag = 7
    Left = 232
    Top = 40
    Width = 25
    Height = 25
    Caption = '7'
    TabOrder = 3
    OnClick = Btn0Click
  end
  object Btn6: TButton
    Tag = 6
    Left = 200
    Top = 40
    Width = 25
    Height = 25
    Caption = '6'
    TabOrder = 4
    OnClick = Btn0Click
  end
  object Btn5: TButton
    Tag = 5
    Left = 168
    Top = 40
    Width = 25
    Height = 25
    Caption = '5'
    TabOrder = 5
    OnClick = Btn0Click
  end
  object Btn4: TButton
    Tag = 4
    Left = 136
    Top = 40
    Width = 25
    Height = 25
    Caption = '4'
    TabOrder = 6
    OnClick = Btn0Click
  end
  object Btn3: TButton
    Tag = 3
    Left = 104
    Top = 40
    Width = 25
    Height = 25
    Caption = '3'
    TabOrder = 7
    OnClick = Btn0Click
  end
  object Btn2: TButton
    Tag = 2
    Left = 72
    Top = 40
    Width = 25
    Height = 25
    Caption = '2'
    TabOrder = 8
    OnClick = Btn0Click
  end
  object Btn1: TButton
    Tag = 1
    Left = 40
    Top = 40
    Width = 25
    Height = 25
    Caption = '1'
    TabOrder = 9
    OnClick = Btn0Click
  end
  object Btn0: TButton
    Left = 8
    Top = 40
    Width = 25
    Height = 25
    Caption = '0'
    TabOrder = 10
    OnClick = Btn0Click
  end
  object Btn8: TButton
    Tag = 8
    Left = 264
    Top = 40
    Width = 25
    Height = 25
    Caption = '8'
    TabOrder = 2
    OnClick = Btn0Click
  end
  object Btn9: TButton
    Tag = 9
    Left = 296
    Top = 40
    Width = 25
    Height = 25
    Caption = '9'
    TabOrder = 1
    OnClick = Btn0Click
  end
  object BtnPlus: TButton
    Left = 360
    Top = 40
    Width = 25
    Height = 25
    Caption = '+'
    TabOrder = 11
    OnClick = BtnPlusClick
  end
  object BtnMinus: TButton
    Left = 392
    Top = 40
    Width = 25
    Height = 25
    Caption = '-'
    TabOrder = 12
    OnClick = BtnMinusClick
  end
  object BtnMult: TButton
    Left = 424
    Top = 40
    Width = 25
    Height = 25
    Caption = '*'
    TabOrder = 13
    OnClick = BtnMultClick
  end
  object BtnDiv: TButton
    Left = 456
    Top = 40
    Width = 25
    Height = 25
    Caption = '/'
    TabOrder = 14
    OnClick = BtnDivClick
  end
  object BtnEq: TButton
    Left = 488
    Top = 40
    Width = 25
    Height = 25
    Caption = '='
    TabOrder = 15
    OnClick = BtnEqClick
  end
  object Result: TEdit
    Left = 8
    Top = 8
    Width = 281
    Height = 24
    TabOrder = 16
  end
  object BtnClear: TButton
    Left = 312
    Top = 8
    Width = 49
    Height = 25
    Caption = 'Clear'
    TabOrder = 0
    OnClick = BtnClearClick
  end
  object BtnDot: TButton
    Left = 328
    Top = 40
    Width = 25
    Height = 25
    Caption = '.'
    TabOrder = 17
    OnClick = BtnDotClick
  end
end
