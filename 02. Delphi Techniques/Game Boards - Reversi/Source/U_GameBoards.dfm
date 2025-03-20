object Form1: TForm1
  Left = 192
  Top = 120
  Width = 696
  Height = 480
  Caption = '3 Gameboard styles - all play Reversi'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 32
    Width = 34
    Height = 13
    Caption = 'Board1'
  end
  object Label2: TLabel
    Left = 288
    Top = 32
    Width = 34
    Height = 13
    Caption = 'Board2'
  end
  object Label3: TLabel
    Left = 464
    Top = 32
    Width = 34
    Height = 13
    Caption = 'Board3'
  end
  object Label1B: TLabel
    Left = 96
    Top = 56
    Width = 3
    Height = 13
  end
  object Label2b: TLabel
    Left = 296
    Top = 56
    Width = 3
    Height = 13
  end
  object Label3B: TLabel
    Left = 464
    Top = 56
    Width = 3
    Height = 13
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object ResetBtn1: TButton
    Left = 80
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Reset 1'
    TabOrder = 1
    OnClick = ResetBtn1Click
  end
  object ResetBtn2: TButton
    Left = 280
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Reset 2'
    TabOrder = 2
    OnClick = ResetBtn2Click
  end
  object ResetBtn3: TButton
    Left = 488
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Reset 3'
    TabOrder = 3
    OnClick = ResetBtn3Click
  end
end
