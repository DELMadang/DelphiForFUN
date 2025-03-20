object Form1: TForm1
  Left = 196
  Top = 121
  Width = 800
  Height = 600
  Caption = 'Set Partition Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 432
    Top = 440
    Width = 89
    Height = 20
    Caption = 'Set size (N)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ListLbl: TLabel
    Left = 384
    Top = 16
    Width = 125
    Height = 13
    Caption = 'Set partitions for set size N'
  end
  object Label2: TLabel
    Left = 392
    Top = 472
    Width = 126
    Height = 20
    Caption = 'Number to display'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpinEdit1: TSpinEdit
    Left = 528
    Top = 440
    Width = 41
    Height = 22
    MaxValue = 25
    MinValue = 0
    TabOrder = 0
    Value = 4
    OnChange = SpinEdit1Change
  end
  object ListBox1: TListBox
    Left = 384
    Top = 40
    Width = 273
    Height = 385
    ItemHeight = 13
    TabOrder = 1
  end
  object GenBtn: TButton
    Left = 384
    Top = 504
    Width = 185
    Height = 25
    Caption = 'Generate all partitions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
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
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Enumerating all partitions of a set is one of the classic '
      'combinatoric problems in set theory.'
      ''
      
        'A set partition of a set of distinct objects, S,  is a collectio' +
        'n '
      'of disjoint subsets of S whose union is S.  For example, '
      'one of the 5 set partitions of the set {1,2,3,4} is '
      '({1},{2,3},{4}).  '
      ''
      'The number of set partitions of a set is called a Bell '
      'number after Eric T.   Bell, the mathematician who '
      'investigated them in depth. We'#39'll denote the number for '
      'sets of size N as B(N). '
      ''
      'Stirling numbers of the second kind describe the number '
      'of ways a set with n elements can be partitioned into k '
      'disjoint, non-empty subsets.  Let'#39's denote these as '
      'S2(N,K).'
      ''
      'It follows that the Bell number for set size N equals the '
      'sum of Stirling2 numbers for all values of K from 1 to N., i.e. '
      'B(N)=S2(N,1)+S2(N,2)...S2(N,N).'
      ''
      'This test program generates Bell numbers for set sizes '
      'up to 25 ( about 10^20) and displays up to 1000 set '
      'partitions for each set size.'
      ''
      ' '
      ' ')
    ParentFont = False
    TabOrder = 3
  end
  object NbrSpin: TSpinEdit
    Left = 528
    Top = 472
    Width = 41
    Height = 22
    MaxValue = 1000
    MinValue = 0
    TabOrder = 4
    Value = 100
  end
  object Button1: TButton
    Left = 584
    Top = 504
    Width = 145
    Height = 25
    Caption = 'Show Stirling2 #s'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button1Click
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
