object Form1: TForm1
  Left = 116
  Top = 116
  Width = 684
  Height = 375
  Caption = 'Form1'
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
  object listbox1: TListBox
    Left = 216
    Top = 32
    Width = 81
    Height = 145
    ItemHeight = 13
    TabOrder = 0
  end
  object ListBox2: TListBox
    Left = 312
    Top = 32
    Width = 89
    Height = 145
    ItemHeight = 13
    TabOrder = 1
  end
  object ListBox3: TListBox
    Left = 416
    Top = 32
    Width = 89
    Height = 145
    ItemHeight = 13
    TabOrder = 2
  end
  object ListBox4: TListBox
    Left = 520
    Top = 32
    Width = 89
    Height = 145
    ItemHeight = 13
    TabOrder = 3
  end
  object ShuffleBtn: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Shuffle'
    TabOrder = 4
    OnClick = ShuffleBtnClick
  end
  object deckbox: TListBox
    Left = 96
    Top = 32
    Width = 113
    Height = 281
    ItemHeight = 13
    TabOrder = 5
  end
  object DealBtn: TButton
    Left = 8
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Deal'
    TabOrder = 6
    OnClick = DealBtnClick
  end
end
