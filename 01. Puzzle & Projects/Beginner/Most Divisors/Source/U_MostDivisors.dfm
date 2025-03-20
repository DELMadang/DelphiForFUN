object Form1: TForm1
  Left = 66
  Top = 106
  Width = 427
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 24
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Find it'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 248
    Top = 8
    Width = 121
    Height = 321
    ItemHeight = 13
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 185
    Height = 97
    Color = clYellow
    Lines.Strings = (
      'Which 3 digit positive integer has the '
      'most factors?'
      ''
      '(The factors of a number are positive '
      'integers that divide it without a '
      'remainder.)  ')
    TabOrder = 2
  end
end
