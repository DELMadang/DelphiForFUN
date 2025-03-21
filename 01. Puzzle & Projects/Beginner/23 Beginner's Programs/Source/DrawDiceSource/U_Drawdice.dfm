object Form1: TForm1
  Left = 192
  Top = 133
  Caption = 'Draw Random Dice'
  ClientHeight = 158
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 39
    Width = 249
    Height = 113
  end
  object DrawDiceBtn: TButton
    Left = 8
    Top = 8
    Width = 249
    Height = 25
    Caption = 'Draw pair of random dice'
    TabOrder = 0
    OnClick = DrawDiceBtnClick
  end
end
