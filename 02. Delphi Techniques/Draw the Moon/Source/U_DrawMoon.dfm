object Form1: TForm1
  Left = 461
  Top = 87
  Width = 351
  Height = 375
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object PBox: TPaintBox
    Left = 16
    Top = 24
    Width = 314
    Height = 314
    OnPaint = PBoxPaint
  end
  object CloseBtn: TButton
    Left = 256
    Top = 0
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 0
    OnClick = CloseBtnClick
  end
  object MoonBtn: TButton
    Left = 16
    Top = 0
    Width = 107
    Height = 25
    Caption = 'Show moon image'
    TabOrder = 1
    Visible = False
    OnClick = MoonBtnClick
  end
end
