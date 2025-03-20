object Form1: TForm1
  Left = 403
  Top = 205
  Width = 725
  Height = 750
  Caption = 'Digit Sums'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 144
  TextHeight = 20
  object Label1: TLabel
    Left = 16
    Top = 408
    Width = 154
    Height = 20
    Caption = 'Integer length to sum'
  end
  object SpinEdit1: TSpinEdit
    Left = 16
    Top = 440
    Width = 65
    Height = 31
    MaxValue = 5
    MinValue = 2
    TabOrder = 0
    Value = 2
  end
  object Memo1: TMemo
    Left = 336
    Top = 48
    Width = 185
    Height = 537
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object CalcBtn: TButton
    Left = 16
    Top = 488
    Width = 105
    Height = 25
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = CalcBtnClick
  end
  object Memo2: TMemo
    Left = 16
    Top = 56
    Width = 297
    Height = 321
    Lines.Strings = (
      'A recent Mensa puzzle calendar asked '
      '"How many 4 digit numbers are there '
      'whose digits sum to 34?"  That one is '
      'not too difficult since the sum cannot '
      'exceed 36 (for the integer 9999), but it '
      'started me thinking about other sums.'
      ' '
      'This program counts and lists the '
      'number of integers of given length '
      'which sum to any value.  About 25 lines '
      'of user written Delphi code answer the '
      'question for two through five digit '
      'integers.')
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 670
    Width = 703
    Height = 28
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
end
