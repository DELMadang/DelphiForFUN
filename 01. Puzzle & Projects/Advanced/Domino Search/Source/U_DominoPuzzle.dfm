object Form1: TForm1
  Left = 192
  Top = 98
  Width = 800
  Height = 629
  Caption = 'Domino Puzzle'
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 144
    Top = 208
    Width = 409
    Height = 353
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Label1: TLabel
    Left = 568
    Top = 8
    Width = 97
    Height = 41
    AutoSize = False
    Caption = 'Remaining domino values to add (Possible locations)'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 680
    Top = 16
    Width = 105
    Height = 33
    AutoSize = False
    Caption = '           Added                  (Click to remove)'
    WordWrap = True
  end
  object CreateBtn: TBitBtn
    Left = 16
    Top = 336
    Width = 113
    Height = 25
    Caption = 'Make a Puzzle'
    TabOrder = 0
    OnClick = CreateBtnClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 529
    Height = 185
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'The board below contains set a set of dominoes whose outlines ha' +
        've been removed.'
      
        'The dominoes in the list at right exactly fill the board. Your t' +
        'ask is to replace the domino'
      
        'outlines by "clicking and draging" between two numeric values on' +
        ' the board. Dominoes'
      
        'may be oriented vertically or horizontally and with  numbers in ' +
        'either order. If you make a'
      
        'mistake,any domino may be removed from the board by clicking on ' +
        'it or clicking the entry'
      'in the "added" list.'
      ''
      
        '"Make a Puzzle" creates a new random puzzle.  "Restart" removes ' +
        'any dominoes you'
      
        'have added. "Show possible counts" checkbox will add the number ' +
        'of valid locations'
      
        'for each remaining domino in the list (a good idea unless you wa' +
        'nt a much harder'
      'challenge!).')
    ParentFont = False
    TabOrder = 1
  end
  object SolutionBtn: TButton
    Left = 16
    Top = 456
    Width = 113
    Height = 25
    Caption = 'Show a solution'
    TabOrder = 2
    OnClick = SolutionBtnClick
  end
  object SizeGrp: TRadioGroup
    Left = 24
    Top = 200
    Width = 97
    Height = 121
    Caption = 'Board size'
    ItemIndex = 0
    Items.Strings = (
      '6 X 5'
      '7 X 6'
      '8 X 7'
      '9 X 8'
      '10 X 9')
    TabOrder = 3
    OnClick = SizeGrpClick
  end
  object AvailListBox: TListBox
    Left = 568
    Top = 48
    Width = 97
    Height = 481
    Columns = 2
    ItemHeight = 13
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 574
    Width = 792
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object RestartBtn: TButton
    Left = 16
    Top = 376
    Width = 113
    Height = 25
    Caption = 'Restart'
    TabOrder = 6
    OnClick = RestartBtnClick
  end
  object ShowCountsBox: TCheckBox
    Left = 16
    Top = 416
    Width = 105
    Height = 25
    Caption = 'Show Counts'
    TabOrder = 7
    OnClick = ShowCountsBoxClick
  end
  object SaveBtn: TButton
    Left = 16
    Top = 496
    Width = 113
    Height = 25
    Caption = 'Save Puzzle...'
    TabOrder = 8
    OnClick = SaveBtnClick
  end
  object LoadBtn: TButton
    Left = 16
    Top = 536
    Width = 113
    Height = 25
    Caption = 'Load Puzzle...'
    TabOrder = 9
    OnClick = LoadBtnClick
  end
  object AddedListBox: TListBox
    Left = 680
    Top = 48
    Width = 97
    Height = 481
    ItemHeight = 13
    TabOrder = 10
    OnClick = AddedListBoxClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Puzzle file (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 608
    Top = 216
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Puzzle file (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 600
    Top = 136
  end
end
