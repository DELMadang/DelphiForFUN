object Form1: TForm1
  Left = 196
  Top = 121
  Width = 800
  Height = 600
  Caption = 'Integer Partition Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 448
    Top = 384
    Width = 62
    Height = 16
    Caption = 'Integer (N)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ListLbl: TLabel
    Left = 384
    Top = 16
    Width = 123
    Height = 16
    Caption = 'Integer partitions of N'
  end
  object Label2: TLabel
    Left = 400
    Top = 416
    Width = 109
    Height = 16
    Caption = 'Number to display'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 600
    Top = 384
    Width = 97
    Height = 33
    AutoSize = False
    Caption = 'Show Partitions                  of  size: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object CountLbl: TLabel
    Left = 384
    Top = 40
    Width = 49
    Height = 16
    Caption = 'Count=0'
  end
  object Label4: TLabel
    Left = 600
    Top = 416
    Width = 114
    Height = 16
    Caption = '(Enter 0 to show all)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GenBtn: TButton
    Left = 392
    Top = 480
    Width = 185
    Height = 25
    Caption = 'Generate partitions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = GenBtnClickClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 345
    Height = 505
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'A partition of an integer, N,  is a set of postive integers'
      'which add up to N.'
      ''
      'The size of each partition set can range from a set '
      'containing one  member or part,  {N}, to the set '
      'containing '
      'N 1'#39's,    {1,1,1......1} .   One interesting note about '
      'partitions '
      '- the number of partitions with "k" parts is equal to the '
      'number of partitions whose largest part is "k".'
      ''
      'Many variations of partitions have been studied: partitions '
      'with prime numbers only, with distinct terms, with all odd '
      'terms, etc. Another interesting note : for the latter two '
      'cases,(odd terms and distinct terms), the number of '
      'partitions is always equal.'
      ''
      'The number of partitions grows rapidly. The current '
      'program can generate all or partitions of a specified '
      'length for integers up to 100, although, for N=100 there '
      'are '
      'over 190 million partitions!  The number of partitions '
      'displayed is limited to 1,000. '
      ''
      'A future version will allow support "ranking" (provide a '
      'partition and receive its rank) and "unranking" (provide a '
      'rank and receive the partition with that rank).'
      ''
      ' '
      ' '
      ' ')
    ParentFont = False
    TabOrder = 1
  end
  object NbrSpin: TSpinEdit
    Left = 512
    Top = 416
    Width = 57
    Height = 26
    MaxValue = 1000
    MinValue = 0
    TabOrder = 2
    Value = 100
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object UpDown1: TUpDown
    Left = 545
    Top = 384
    Width = 17
    Height = 24
    Associate = Edit1
    Min = 1
    Position = 5
    TabOrder = 4
  end
  object Edit1: TEdit
    Left = 512
    Top = 384
    Width = 33
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = '5'
    OnChange = SpinEdit1Change
  end
  object UpDown2: TUpDown
    Left = 737
    Top = 392
    Width = 17
    Height = 24
    Associate = Edit2
    TabOrder = 6
  end
  object Edit2: TEdit
    Left = 704
    Top = 392
    Width = 33
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = '0'
    OnChange = SpinEdit1Change
  end
  object CountBtn: TButton
    Left = 592
    Top = 480
    Width = 161
    Height = 25
    Caption = 'Show partition count'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = CountBtnClick
  end
  object Memo2: TMemo
    Left = 392
    Top = 72
    Width = 329
    Height = 289
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssVertical
    TabOrder = 9
  end
end
