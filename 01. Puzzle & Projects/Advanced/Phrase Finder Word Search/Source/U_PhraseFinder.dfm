object Form1: TForm1
  Left = 112
  Top = 106
  Width = 800
  Height = 600
  Caption = 'Phrase Finder'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 32
    Top = 48
    Width = 139
    Height = 16
    Caption = 'Enter a set of letters'
  end
  object Label2: TLabel
    Left = 40
    Top = 112
    Width = 208
    Height = 16
    Caption = 'Check for words of length from'
  end
  object countlbl: TLabel
    Left = 40
    Top = 416
    Width = 95
    Height = 16
    Caption = 'Item count = 0'
  end
  object Label3: TLabel
    Left = 312
    Top = 112
    Width = 18
    Height = 16
    Caption = 'to '
  end
  object Label4: TLabel
    Left = 40
    Top = 152
    Width = 125
    Height = 16
    Caption = 'Find phrases with '
  end
  object Label5: TLabel
    Left = 216
    Top = 152
    Width = 42
    Height = 16
    Caption = 'words'
  end
  object TimeLbl: TLabel
    Left = 200
    Top = 416
    Width = 84
    Height = 16
    Caption = '0.0 seconds'
  end
  object Label8: TLabel
    Left = 32
    Top = 192
    Width = 65
    Height = 16
    Caption = 'Solutions'
  end
  object Label6: TLabel
    Left = 442
    Top = 40
    Width = 143
    Height = 16
    Caption = 'Exclude these words'
  end
  object Label7: TLabel
    Left = 619
    Top = 40
    Width = 150
    Height = 16
    Caption = 'Start with these words'
  end
  object DicLbl: TLabel
    Left = 440
    Top = 336
    Width = 122
    Height = 16
    Caption = 'Current dictionary'
  end
  object DicCountLbl: TLabel
    Left = 440
    Top = 360
    Width = 177
    Height = 16
    Caption = 'Dictiionary word count      '
  end
  object Label9: TLabel
    Left = 440
    Top = 320
    Width = 122
    Height = 16
    Caption = 'Current dictionary'
  end
  object WordcountLbl: TLabel
    Left = 440
    Top = 392
    Width = 21
    Height = 16
    Caption = '.....'
  end
  object Label10: TLabel
    Left = 608
    Top = 208
    Width = 56
    Height = 16
    Caption = 'Checking'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Edit1: TEdit
    Left = 32
    Top = 72
    Width = 305
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 0
    Text = 'ABCDEEHIKLLOORRTWY'
    OnChange = EditChange
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 256
    Top = 108
    Width = 33
    Height = 24
    TabOrder = 1
    Text = '3'
    OnChange = EditChange
  end
  object UpDown1: TUpDown
    Left = 289
    Top = 108
    Width = 12
    Height = 24
    Associate = Edit2
    Min = 1
    Position = 3
    TabOrder = 2
    Wrap = False
  end
  object Edit3: TEdit
    Left = 344
    Top = 108
    Width = 33
    Height = 24
    TabOrder = 3
    Text = '6'
    OnChange = EditChange
  end
  object UpDown2: TUpDown
    Left = 377
    Top = 108
    Width = 15
    Height = 24
    Associate = Edit3
    Min = 1
    Position = 6
    TabOrder = 4
    Wrap = False
  end
  object Edit4: TEdit
    Left = 168
    Top = 148
    Width = 33
    Height = 24
    TabOrder = 5
    Text = '4'
    OnChange = EditChange
  end
  object UpDown3: TUpDown
    Left = 201
    Top = 148
    Width = 12
    Height = 24
    Associate = Edit4
    Min = 1
    Position = 4
    TabOrder = 6
    Wrap = False
  end
  object Phraselist: TMemo
    Left = 32
    Top = 208
    Width = 393
    Height = 193
    Lines.Strings = (
      'I happen to know, because I cheated and looked at '
      'the answer of this initial sample puzzle, that  the '
      'above letters are an anagram of "The yellow brick '
      'road".  '
      ''
      'This program will find that solution but it'#39's about 2500 '
      'solutions and a minute or two into the search. But at '
      'least the desired answer is hidden in a smaller '
      'haystack!   If you add the letters F,O,L,L,O,W and '
      'search for 5 words, the obvious solution is number '
      '29,275. '
      ' ')
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object ExcludeWords: TMemo
    Left = 440
    Top = 56
    Width = 153
    Height = 129
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 8
  end
  object FirstWords: TMemo
    Left = 616
    Top = 56
    Width = 153
    Height = 129
    Lines.Strings = (
      'abet')
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object ListBox1: TListBox
    Left = 608
    Top = 224
    Width = 161
    Height = 81
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 10
  end
  object SearchBtn: TButton
    Left = 440
    Top = 208
    Width = 113
    Height = 25
    Caption = 'Start search'
    TabOrder = 11
    OnClick = SearchBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 546
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 12
    OnClick = StaticText1Click
  end
  object SelectDicBtn: TButton
    Left = 440
    Top = 272
    Width = 145
    Height = 25
    Caption = 'Select dictionary'
    TabOrder = 13
    OnClick = SelectDicBtnClick
  end
end
