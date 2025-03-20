object Form1: TForm1
  Left = 272
  Top = 110
  Width = 696
  Height = 480
  Caption = 'AniFileDemo -  Loads animated cursors from files'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GlobeBtn: TButton
    Left = 56
    Top = 40
    Width = 153
    Height = 25
    Caption = 'Globe Cursor'
    TabOrder = 0
    OnClick = GlobeBtnClick
  end
  object CoffeeBtn: TButton
    Left = 56
    Top = 88
    Width = 153
    Height = 25
    Caption = 'Coffee Cursor'
    TabOrder = 1
    OnClick = CoffeeBtnClick
  end
  object DefaultBtn: TButton
    Left = 56
    Top = 136
    Width = 153
    Height = 25
    Caption = 'Default Cursor'
    TabOrder = 2
    OnClick = DefaultBtnClick
  end
end
