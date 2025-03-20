object Form1: TForm1
  Left = 408
  Top = 225
  Width = 1144
  Height = 667
  Caption = 'Solitaire for Squares'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 120
  TextHeight = 16
  object HintBtn: TButton
    Left = 645
    Top = 187
    Width = 92
    Height = 31
    Caption = 'Hint'
    TabOrder = 0
    OnClick = HintBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 603
    Width = 1126
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright 2002, Gary Darby  www.delphiforfun.org'
        Width = 50
      end>
  end
end
