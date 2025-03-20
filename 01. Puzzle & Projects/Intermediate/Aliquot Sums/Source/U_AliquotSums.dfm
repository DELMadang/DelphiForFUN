object Form1: TForm1
  Left = 176
  Top = 106
  Width = 748
  Height = 523
  Caption = 'Aliquot Sums'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 28
    Top = 380
    Width = 31
    Height = 16
    Caption = 'From'
  end
  object Label2: TLabel
    Left = 178
    Top = 380
    Width = 17
    Height = 16
    Caption = 'To'
  end
  object Label3: TLabel
    Left = 24
    Top = 416
    Width = 99
    Height = 16
    Caption = 'Max cycle length'
  end
  object ClickLbl: TLabel
    Left = 368
    Top = 392
    Width = 364
    Height = 16
    Caption = 
      'Click on any number in the list above to see its aliquot divisor' +
      's'
    Visible = False
  end
  object Label4: TLabel
    Left = 176
    Top = 416
    Width = 100
    Height = 16
    Hint = 'Higher slows computation, max is 18'
    Caption = 'Max Value =  10^'
    ParentShowHint = False
    ShowHint = True
  end
  object LowIntEdt: TIntEdit
    Left = 80
    Top = 376
    Width = 81
    Height = 24
    TabOrder = 0
    Text = '10'
    Value = 10
  end
  object HighIntEdt: TIntEdit
    Left = 216
    Top = 374
    Width = 81
    Height = 24
    TabOrder = 1
    Text = '10000'
    Value = 10000
  end
  object MaxCycleLengthEdt: TIntEdit
    Left = 128
    Top = 412
    Width = 33
    Height = 24
    TabOrder = 2
    Text = '10'
    Value = 10
  end
  object SocialBtn: TButton
    Left = 24
    Top = 456
    Width = 137
    Height = 25
    Caption = 'Check for sociables'
    TabOrder = 3
    OnClick = SocialBtnClick
  end
  object Memo1: TMemo
    Left = 368
    Top = 8
    Width = 361
    Height = 369
    Lines.Strings = (
      '')
    ScrollBars = ssBoth
    TabOrder = 4
    OnClick = Memo1Click
  end
  object StopBtn: TButton
    Left = 224
    Top = 456
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 5
    Visible = False
    OnClick = StopBtnClick
  end
  object Memo2: TMemo
    Left = 24
    Top = 8
    Width = 321
    Height = 345
    Color = clYellow
    Lines.Strings = (
      ''
      
        'The aliquot divisors of a number are all of its divisors except ' +
        'the number itself.  The aliquot sum is the sum of the aliquot di' +
        'visors.  '
      ''
      
        'A number whose aliquot sum equals its value is a PERFECT number.' +
        '  Lets denote this as ASum(N)=N'
      ''
      
        'Numbers A and B with the property that  ASum(A)=B and ASum(B)=A ' +
        'are called  AMICABLE numbers.'
      ''
      
        'Longer cycles exist, these are sometimes called SOCIABLE numbers' +
        '.   For example ASum(A)=B,  ASum(B)=C,  ASum(C)=A would be a cyc' +
        'le of length 3 - I wonder of a cycle of length 3 really exists. ' +
        'Longer cycles (including one containing 28 numbers!) can be foun' +
        'd here.    ')
    TabOrder = 6
    WordWrap = False
  end
  object MaxValEdt: TIntEdit
    Left = 280
    Top = 412
    Width = 25
    Height = 24
    Hint = 'Higher slows computation, max is 18'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Text = '9'
    OnChange = MaxValEdtChange
    Value = 9
  end
end
