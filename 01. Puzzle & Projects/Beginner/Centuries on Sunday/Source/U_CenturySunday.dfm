object Form1: TForm1
  Left = 117
  Top = 108
  Width = 609
  Height = 321
  Caption = 'Press the button to see century starting dates 1500-5100 '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object CalcBtn: TButton
    Left = 35
    Top = 14
    Width = 60
    Height = 20
    Caption = 'Start Calc'
    TabOrder = 0
    OnClick = CalcBtnClick
  end
  object Memo1: TMemo
    Left = 32
    Top = 39
    Width = 528
    Height = 196
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
