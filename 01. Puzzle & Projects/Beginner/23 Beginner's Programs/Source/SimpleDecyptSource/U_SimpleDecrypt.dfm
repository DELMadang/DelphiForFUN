object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 458
  Caption = 'Simple "Caesar'#39's Cipher" Encryption'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object InputLbl: TLabel
    Left = 336
    Top = 40
    Width = 24
    Height = 13
    Caption = 'Input'
  end
  object Label1: TLabel
    Left = 336
    Top = 232
    Width = 32
    Height = 13
    Caption = 'Output'
  end
  object Memo1: TMemo
    Left = 40
    Top = 40
    Width = 249
    Height = 185
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's a program that decrypts messages '
      'encrypted using  shift or  Caesar cipher encryption '
      'named for Julius Ceasar who used it a couple of '
      'thousand years ago. .  '
      ''
      'Enter you own encrypted text to decode it, or just '
      'use the sample provided.  Clcik Search to try all 25 '
      'decodng patterns.'
      ''
      'You can also enter (or paste) plain text into the '
      'input area and see 25 choices for encrypted '
      'messages. Encrypted text can copied and pasted '
      'into an email or letter to your friends.')
    ParentFont = False
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 336
    Top = 56
    Width = 337
    Height = 121
    Lines.Strings = (
      'XIBU HPFT VQ DPNFT EPXO,  FYDFQU  QSJDFT')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 336
    Top = 248
    Width = 329
    Height = 129
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object SearchBtn: TButton
    Left = 336
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 3
    OnClick = SearchBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 411
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
end
