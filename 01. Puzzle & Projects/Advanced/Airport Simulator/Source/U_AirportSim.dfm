object Form1: TForm1
  Left = 25
  Top = 30
  Width = 768
  Height = 546
  Caption = 
    'Airport SImulation (from  Data Structures in Pascal, Horowitz & ' +
    'Sahni)'
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
  object Label1: TLabel
    Left = 648
    Top = 64
    Width = 39
    Height = 13
    Caption = 'Runtime'
  end
  object LQLbl: TLabel
    Left = 16
    Top = 96
    Width = 105
    Height = 13
    Caption = 'Landing Queues'
    WordWrap = True
  end
  object RunwayLbl: TLabel
    Left = 24
    Top = 256
    Width = 105
    Height = 13
    Caption = 'Runways'
  end
  object TQLbl: TLabel
    Left = 24
    Top = 416
    Width = 113
    Height = 13
    Caption = 'Takeoff Queues'
  end
  object ListBox1: TListBox
    Left = 144
    Top = 64
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object ListBox2: TListBox
    Left = 232
    Top = 64
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object ListBox3: TListBox
    Left = 336
    Top = 64
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 2
  end
  object ListBox4: TListBox
    Left = 416
    Top = 64
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 3
  end
  object ListBox5: TListBox
    Left = 552
    Top = 376
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 4
  end
  object StartBtn: TButton
    Left = 648
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 5
    OnClick = StartBtnClick
  end
  object Edit1: TEdit
    Left = 648
    Top = 88
    Width = 73
    Height = 21
    TabOrder = 6
    Text = '100'
  end
  object ListBox6: TListBox
    Left = 192
    Top = 368
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 7
  end
  object ListBox7: TListBox
    Left = 384
    Top = 368
    Width = 65
    Height = 97
    ItemHeight = 13
    TabOrder = 8
  end
  object ResetBtn: TButton
    Left = 648
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 9
    OnClick = ResetBtnClick
  end
  object StepBtn: TButton
    Left = 648
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Step'
    TabOrder = 10
    OnClick = StepBtnClick
  end
  object ListBox9: TListBox
    Left = 385
    Top = 177
    Width = 64
    Height = 168
    Color = clBackground
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 11
  end
  object ListBox8: TListBox
    Left = 193
    Top = 177
    Width = 64
    Height = 168
    Color = clBackground
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 12
  end
  object ListBox10: TListBox
    Left = 553
    Top = 177
    Width = 64
    Height = 168
    Color = clBackground
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 13
  end
  object Button1: TButton
    Left = 592
    Top = 24
    Width = 131
    Height = 25
    Caption = 'Problem Description'
    TabOrder = 14
    OnClick = Button1Click
  end
end
