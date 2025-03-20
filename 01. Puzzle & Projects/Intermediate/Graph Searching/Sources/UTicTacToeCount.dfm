object Form1: TForm1
  Left = 220
  Top = 98
  Width = 544
  Height = 386
  Caption = 'Tic-tac-toe board generator'
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
  object Label1: TLabel
    Left = 240
    Top = 16
    Width = 112
    Height = 13
    Caption = 'First and last 100 nodes'
  end
  object Button1: TButton
    Left = 24
    Top = 88
    Width = 97
    Height = 25
    Caption = 'Generate boards'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 232
    Top = 40
    Width = 185
    Height = 265
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 24
    Top = 32
    Width = 185
    Height = 33
    Lines.Strings = (
      'Note: X'#39's are assumed to move first')
    ReadOnly = True
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 338
    Width = 536
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2000, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
end
