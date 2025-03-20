object Form1: TForm1
  Left = 192
  Top = 120
  Width = 696
  Height = 480
  Caption = 'All Words'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 88
    Top = 312
    Width = 119
    Height = 13
    Caption = 'Length being checked: 0'
  end
  object Label2: TLabel
    Left = 88
    Top = 336
    Width = 152
    Height = 13
    Caption = 'Permutation # being checked: 0'
  end
  object Label3: TLabel
    Left = 96
    Top = 168
    Width = 87
    Height = 13
    Caption = 'Show words from  '
  end
  object Label4: TLabel
    Left = 136
    Top = 184
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object StopBtn: TButton
    Left = 80
    Top = 224
    Width = 121
    Height = 65
    Caption = 'Stop'
    TabOrder = 6
    Visible = False
    OnClick = StopBtnClick
  end
  object Button1: TButton
    Left = 80
    Top = 224
    Width = 121
    Height = 25
    Caption = 'All permutations'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 88
    Top = 120
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 1
    Text = 'HORSE'
    OnChange = Edit1Change
  end
  object Button2: TButton
    Left = 80
    Top = 264
    Width = 121
    Height = 25
    Caption = 'Valid Words'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 88
    Top = 24
    Width = 185
    Height = 73
    Lines.Strings = (
      'List all subsets or all dictionary '
      'words that can be made from a '
      'given set of letters.'
      '')
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 418
    Width = 688
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object ListBox1: TListBox
    Left = 400
    Top = 24
    Width = 121
    Height = 377
    ItemHeight = 13
    TabOrder = 5
  end
  object Shortest: TUpDown
    Left = 112
    Top = 184
    Width = 12
    Height = 21
    Associate = Edit2
    Min = 1
    Position = 1
    TabOrder = 7
    Wrap = False
  end
  object Longest: TUpDown
    Left = 184
    Top = 184
    Width = 12
    Height = 21
    Associate = Edit3
    Min = 1
    Position = 1
    TabOrder = 8
    Wrap = False
  end
  object Edit2: TEdit
    Left = 96
    Top = 184
    Width = 16
    Height = 21
    TabOrder = 9
    Text = '1'
  end
  object Edit3: TEdit
    Left = 168
    Top = 184
    Width = 16
    Height = 21
    TabOrder = 10
    Text = '1'
  end
end
