object Form1: TForm1
  Left = 138
  Top = 74
  Width = 706
  Height = 600
  Caption = 'Select balls with (or without) replacement'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 480
    Top = 24
    Width = 134
    Height = 16
    Caption = '# of balls in the box'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 480
    Top = 96
    Width = 127
    Height = 16
    Caption = '# of balls to select'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CountLbl: TLabel
    Left = 24
    Top = 456
    Width = 3
    Height = 13
  end
  object Label3: TLabel
    Left = 336
    Top = 48
    Width = 61
    Height = 13
    Caption = 'Ball "names"'
  end
  object ListBox1: TListBox
    Left = 344
    Top = 288
    Width = 329
    Height = 201
    ItemHeight = 13
    TabOrder = 0
  end
  object OrderBox: TCheckBox
    Left = 344
    Top = 160
    Width = 337
    Height = 17
    Caption = 'Order matters (Example - R,B,G and B,R,G ae dfferent outcomes)'
    TabOrder = 1
  end
  object RandomBtn: TButton
    Left = 344
    Top = 216
    Width = 153
    Height = 25
    Caption = 'Show a random outcome'
    TabOrder = 2
    OnClick = RandomBtnClick
  end
  object NamesEdt: TEdit
    Left = 336
    Top = 64
    Width = 305
    Height = 21
    TabOrder = 3
    Text = 'Red, Blue, Green, Yellow'
    OnExit = NamesEdtExit
  end
  object ClearBtn: TButton
    Left = 520
    Top = 216
    Width = 153
    Height = 25
    Caption = 'Clear list'
    TabOrder = 4
    OnClick = ClearBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 48
    Width = 281
    Height = 385
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Selecting balls from a container without '
      'replacing selected ball after each draw is '
      'modeled by  normal combination and '
      'permutation generators such as those already '
      'posted at DelphiForFun.org,  '
      ''
      'Selecting balls with replacement is slightly '
      'different since one item can be selected '
      'multple times in a single draw.  '
      ''
      'Here is a program that illustrates all outcomes '
      'from a single turn if we select R balls from a '
      'bag with N balls in it, with or without repaceing '
      'the ball after each draw and if the order of '
      'drawing the balls matters (permutations) or not '
      '(combinations) .'
      ''
      'If you define a  set of balls with integer values, '
      'the program can also report only outcomes '
      'that sum to a given value.')
    ParentFont = False
    TabOrder = 6
  end
  object Button3: TButton
    Left = 344
    Top = 256
    Width = 329
    Height = 25
    Caption = 'Show all possible outcomes of a single trial'
    TabOrder = 8
    OnClick = ShowAllBtnClick
  end
  object ReplaceBox: TCheckBox
    Left = 344
    Top = 136
    Width = 305
    Height = 17
    Caption = 'Replace ball after each draw'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object SumBox: TCheckBox
    Left = 344
    Top = 184
    Width = 265
    Height = 17
    Caption = 'Balls names are  integers, select balls than sum to:'
    TabOrder = 7
  end
  object SumEdit: TSpinEdit
    Left = 616
    Top = 184
    Width = 57
    Height = 22
    MaxValue = 100000
    MinValue = -100000
    TabOrder = 9
    Value = 25
  end
  object TotalEdit: TSpinEdit
    Left = 624
    Top = 24
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 10
    Value = 4
    OnChange = SelectEditChange
  end
  object SelectEdit: TSpinEdit
    Left = 624
    Top = 96
    Width = 49
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 11
    Value = 3
    OnChange = SelectEditChange
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
    Width = 698
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 12
    OnClick = StaticText1Click
  end
  object StopBtn: TButton
    Left = 344
    Top = 272
    Width = 329
    Height = 65
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    Visible = False
    OnClick = StopBtnClick
  end
end
