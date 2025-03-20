object Form1: TForm1
  Left = 1
  Top = 5
  Width = 527
  Height = 344
  Caption = 'T-Shirt Candidate #3'
  Color = clInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 267
    Top = 280
    Width = 3
    Height = 13
  end
  object SearchBtn: TButton
    Left = 16
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 0
    OnClick = SearchBtnClick
  end
  object ListBox1: TListBox
    Left = 272
    Top = 24
    Width = 217
    Height = 233
    ItemHeight = 13
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 233
    Height = 193
    Color = clYellow
    Lines.Strings = (
      'A palindrome is a number that reads the same '
      'backwards or forwards.  The T-shirt back reads'
      ''
      '"The only known integer that is not a '
      'palindrome, but whose cube is a palindrome."'
      ''
      'What number is on the front?'
      ''
      'More information at:'
      'http://delphiforfun.org/programs/Tshirt3.html'
      ''
      'Copyright 2002, Gary Darby')
    TabOrder = 2
  end
  object StopBtn: TButton
    Left = 144
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    Visible = False
    OnClick = StopBtnClick
  end
end
