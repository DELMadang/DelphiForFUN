object Form1: TForm1
  Left = 188
  Top = 124
  Width = 800
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object CountLbl: TLabel
    Left = 56
    Top = 416
    Width = 42
    Height = 13
    Caption = 'CountLbl'
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 473
    Height = 377
    Lines.Strings = (
      ' '
      'Comments:'
      ''
      'Hi! My name is Henryk'
      'I'#39'd like to ask you for how to search an open file for wodrs'
      'counting all of them and to copy each line of open text to'
      'a memo.  Do hope you understand my specific Englisch ...'
      ''
      'waiting for answer from you.')
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 616
    Top = 8
    Width = 161
    Height = 393
    ItemHeight = 13
    TabOrder = 1
  end
  object CountBtn: TButton
    Left = 504
    Top = 88
    Width = 97
    Height = 25
    Caption = 'Count words'
    TabOrder = 2
    OnClick = CountBtnClick
  end
  object SummarizeBtn: TButton
    Left = 504
    Top = 128
    Width = 97
    Height = 25
    Caption = 'Summarize words'
    TabOrder = 3
    OnClick = SummarizeBtnClick
  end
  object Button1: TButton
    Left = 504
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Load text  file'
    TabOrder = 4
    OnClick = Button1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = ' Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select text file to scan'
    Left = 456
    Top = 16
  end
end
