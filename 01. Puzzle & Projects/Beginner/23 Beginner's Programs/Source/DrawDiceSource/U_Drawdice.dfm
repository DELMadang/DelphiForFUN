object Form1: TForm1
  Left = 192
  Top = 133
  Width = 696
  Height = 206
  Caption = 'Form1'
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
  object Image1: TImage
    Left = 320
    Top = 28
    Width = 249
    Height = 113
  end
  object DrawDiceBtn: TButton
    Left = 80
    Top = 72
    Width = 185
    Height = 25
    Caption = 'Draw pair of random dice'
    TabOrder = 0
    OnClick = DrawDiceBtnClick
  end
end
