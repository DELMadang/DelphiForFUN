object Form1: TForm1
  Left = 192
  Top = 107
  Width = 799
  Height = 495
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 335
    Top = 177
    Width = 3
    Height = 16
  end
  object Label2: TLabel
    Left = 335
    Top = 236
    Width = 3
    Height = 16
  end
  object Memo1: TMemo
    Left = 59
    Top = 49
    Width = 228
    Height = 297
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'When 5 digit integers '
      'between 10000 and 99999 '
      'are divided by the sum of '
      'their digits, some divide '
      'exactly and some do not. '
      ' '
      'For those that do, what '
      'quotient occurs most '
      'frequently?')
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 374
    Top = 59
    Width = 92
    Height = 31
    Caption = 'Solve'
    TabOrder = 1
    OnClick = Button1Click
  end
end
