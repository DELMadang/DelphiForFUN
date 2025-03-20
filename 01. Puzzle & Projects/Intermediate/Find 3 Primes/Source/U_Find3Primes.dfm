object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Find 3 Primes'
  ClientHeight = 379
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 356
    Width = 737
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 737
    Height = 356
    Align = alClient
    TabOrder = 1
    object SearcBtn: TButton
      Left = 500
      Top = 51
      Width = 86
      Height = 29
      Caption = 'Search'
      TabOrder = 0
      OnClick = SearcBtnClick
    end
    object Memo1: TMemo
      Left = 41
      Top = 54
      Width = 413
      Height = 227
      Lines.Strings = (
        'Find three different 2 digit primes wih the mean values of any '
        'two and of all three are also prime.'
        ''
        'The program builds a table of l two digit prime numbers and '
        'then checks all sets of 3 numbers from that table looking for a '
        'set that meets the given conditions.')
      TabOrder = 1
    end
  end
end
