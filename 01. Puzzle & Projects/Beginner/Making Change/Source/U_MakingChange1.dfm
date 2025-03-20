object Form1: TForm1
  Left = 23
  Top = 56
  Width = 640
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 20
  object MakeChangeBtn: TButton
    Left = 8
    Top = 352
    Width = 121
    Height = 25
    Caption = 'Make Change'
    TabOrder = 0
    OnClick = MakeChangeBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 209
    Height = 281
    Color = clYellow
    Lines.Strings = (
      'It is common knowledge that '
      'there are 293 ways to make '
      'change for a dollar bill. '
      ''
      'Click the button to see them '
      'all.'
      ''
      'I have  doubts about #293, '
      'making change for a $1 bill '
      'with a $1 coin, but I guess '
      'technically it was changed.'
      '')
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 240
    Top = 16
    Width = 385
    Height = 417
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 18
    ParentFont = False
    TabOrder = 2
  end
end
