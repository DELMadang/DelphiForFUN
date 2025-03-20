object Form1: TForm1
  Left = 192
  Top = 114
  Width = 822
  Height = 500
  Caption = 'How many 1'#39's?'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 456
    Top = 32
    Width = 65
    Height = 16
    Caption = 'How many '
  end
  object Label2: TLabel
    Left = 552
    Top = 32
    Width = 65
    Height = 16
    Caption = #39's between '
  end
  object Label3: TLabel
    Left = 688
    Top = 32
    Width = 21
    Height = 16
    Caption = 'and'
  end
  object Label4: TLabel
    Left = 784
    Top = 32
    Width = 7
    Height = 16
    Caption = '?'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 444
    Width = 806
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 32
    Width = 417
    Height = 393
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'How many time does the digit 1 appear in all of the '
      'numbers between 0 and 999,999?'
      ''
      'This simple program with about 30 lines of user written '
      'code provides the generalized answer for all appearances '
      'of a specified digit, D, between any two given integers '
      'using two different techniques.'
      ''
      '"Method 1" uses the modulus ("mod") function as "N mod '
      '10" to get the units position digit to test and then uses the '
      'integer divide function ("div") to as in "N div 10" in a loop '
      'to shift N one digit to the right to test the next digit.'
      ''
      '"Method 2" uses the integer to string ("Inttostr") function to '
      'convert each number to be tested to a string value and '
      'then compares each character of the string against a '
      'character version of the digit being counted. The code to '
      'obtain a character version of the digit to be counted, D,  '
      'uses typecasting to add D to the ordinal value of the '
      'character zero, and treats the sum as a character. For '
      'example "D:=char(ord('#39'0'#39')+D)" .')
    ParentFont = False
    TabOrder = 1
  end
  object SearchBtrn: TButton
    Left = 456
    Top = 136
    Width = 129
    Height = 25
    Caption = 'Search'
    TabOrder = 2
    OnClick = SearchBtrnClick
  end
  object Memo2: TMemo
    Left = 456
    Top = 168
    Width = 337
    Height = 249
    TabOrder = 3
  end
  object SpinEdit1: TSpinEdit
    Left = 520
    Top = 28
    Width = 33
    Height = 26
    MaxValue = 9
    MinValue = 0
    TabOrder = 4
    Value = 1
  end
  object SpinEdit2: TSpinEdit
    Left = 616
    Top = 28
    Width = 65
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object SpinEdit3: TSpinEdit
    Left = 712
    Top = 28
    Width = 73
    Height = 26
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 999999
  end
  object CalcMethod: TRadioGroup
    Left = 456
    Top = 64
    Width = 313
    Height = 65
    Caption = 'Calculation method'
    ItemIndex = 0
    Items.Strings = (
      'Method 1- Mod and Div functions (slower)'
      'Method 2 - InttoStr  and  typecasting (faster)')
    TabOrder = 7
  end
end
