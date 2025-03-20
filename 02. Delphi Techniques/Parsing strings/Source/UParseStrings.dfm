object Form1: TForm1
  Left = 190
  Top = 111
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 392
    Top = 24
    Width = 66
    Height = 13
    Caption = 'Words counts'
  end
  object Button1: TButton
    Left = 48
    Top = 16
    Width = 177
    Height = 25
    Caption = 'Load a text file to parse'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 48
    Top = 56
    Width = 281
    Height = 377
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Wordlist: TListBox
    Left = 392
    Top = 56
    Width = 185
    Height = 377
    ItemHeight = 13
    Sorted = True
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 616
    Top = 32
  end
end
