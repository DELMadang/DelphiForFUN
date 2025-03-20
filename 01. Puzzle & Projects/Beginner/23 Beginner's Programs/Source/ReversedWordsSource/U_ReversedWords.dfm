object Form1: TForm1
  Left = 314
  Top = 194
  AutoScroll = False
  AutoSize = True
  Caption = 'Reversed Words'
  ClientHeight = 794
  ClientWidth = 1004
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 144
  TextHeight = 23
  object Label1: TLabel
    Left = 608
    Top = 0
    Width = 89
    Height = 49
    AutoSize = False
    Caption = 'Word Length'
    WordWrap = True
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 766
    Width = 1004
    Height = 28
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 33
    Top = 25
    Width = 490
    Height = 280
    Lines.Strings = (
      'Here'#39's a simple program that performs quite a '
      'sophisticated test.  The puzzle is from the Mensa '
      'Puzzle-A-Day Calendar for September 23, 2009.'
      ''
      'It presents the text listed below requiring us to find '
      'the word that meets the requirements given and '
      'whose letters appear consecutively but in reverese '
      'order.'
      ''
      'Other similar puzzles could be solved by pasting text '
      'over the memo below and adjusting the word length '
      'appropriately.')
    TabOrder = 1
  end
  object ListBtn: TButton
    Left = 610
    Top = 118
    Width = 215
    Height = 34
    Caption = 'List possible words'
    TabOrder = 2
    OnClick = ListBtnClick
  end
  object Memo2: TMemo
    Left = 41
    Top = 409
    Width = 490
    Height = 280
    Lines.Strings = (
      ''
      'You don'#39't need to be phenomenally smart or have '
      'extrasensory perception to be able to uncover a '
      'seven-letter word in reverse sequential order in this '
      'sentence that may be defined as either a terrestrial '
      'flower of the buttercup family or an underwater '
      'creature armed with tentacles.')
    TabOrder = 3
  end
  object ListBox1: TListBox
    Left = 608
    Top = 169
    Width = 137
    Height = 536
    ItemHeight = 23
    TabOrder = 4
  end
  object WordLength: TSpinEdit
    Left = 608
    Top = 56
    Width = 65
    Height = 34
    MaxValue = 10
    MinValue = 2
    TabOrder = 5
    Value = 7
  end
  object ListBox2: TListBox
    Left = 816
    Top = 313
    Width = 137
    Height = 392
    ItemHeight = 23
    TabOrder = 6
  end
  object ValidWordBtn: TButton
    Left = 816
    Top = 265
    Width = 169
    Height = 33
    Caption = 'Find valid words'
    TabOrder = 7
    OnClick = ValidWordBtnClick
  end
end
