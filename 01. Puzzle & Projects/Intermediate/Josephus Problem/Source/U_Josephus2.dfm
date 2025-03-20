object Form1: TForm1
  Left = 148
  Top = 116
  Width = 847
  Height = 611
  Caption = 'The Josephus Problem  V2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 336
    Top = 16
    Width = 106
    Height = 14
    Caption = 'Number of  people (N)'
  end
  object Label2: TLabel
    Left = 328
    Top = 56
    Width = 121
    Height = 14
    Caption = 'Eliminate 1 of every (K=) '
  end
  object Image1: TImage
    Left = 328
    Top = 96
    Width = 449
    Height = 449
    OnMouseDown = Image1MouseDown
  end
  object Label3: TLabel
    Left = 528
    Top = 16
    Width = 281
    Height = 65
    AutoSize = False
    Caption = 
      'Left click on your selected final location to start the eliminat' +
      'ion process.  Right click on start location to check inverse sol' +
      'ution'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 289
    Height = 377
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'The "Josephus problem" is a counting '
      'elimination "game" named after the story '
      'that Josephus Flavius devised a "fair" way to '
      'kill off his troops who insisted on suicide '
      'rather than surrender to the enemy.  41 of '
      'them formed a circle and every third man '
      'was eliminated.  Maybe not so fair since '
      'Josephus, who was not too keen on the '
      'idea, selected a position which assured that '
      'he would be the last survior.  At that point he '
      'decided that perhaps it was best to '
      'surrender after all!   In fact, the last name '
      'Flavius is that of the Roman family that '
      'adopted him!'
      ' '
      'Version 2.0'
      'The box below will solve the inverse problem: '
      'Numbering from 1 and given the number of '
      'people, N, choosing every Kth person,, and '
      'the position of the last survivor,  A, find the '
      'location to start counting.  Right click a '
      'starting location to check.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SpinEdit1: TSpinEdit
    Left = 448
    Top = 11
    Width = 41
    Height = 23
    MaxValue = 50
    MinValue = 1
    TabOrder = 1
    Value = 41
    OnChange = SpinEdit1Change
  end
  object SpinEdit2: TSpinEdit
    Left = 448
    Top = 51
    Width = 41
    Height = 23
    MaxValue = 50
    MinValue = 1
    TabOrder = 2
    Value = 3
  end
  object ResetBtn: TButton
    Left = 680
    Top = 72
    Width = 97
    Height = 25
    Caption = 'Reset display'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 555
    Width = 831
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2005, 2008 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 408
    Width = 289
    Height = 129
    Caption = 'Inverse problem'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object Label4: TLabel
      Left = 8
      Top = 48
      Width = 100
      Height = 16
      Caption = 'Last survivor (A=)'
    end
    object Label5: TLabel
      Left = 8
      Top = 88
      Width = 81
      Height = 18
      Caption = 'Start at ???'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object SpinEdit3: TSpinEdit
      Left = 112
      Top = 44
      Width = 41
      Height = 26
      MaxValue = 50
      MinValue = 1
      TabOrder = 0
      Value = 3
    end
    object ISolvebtn: TButton
      Left = 168
      Top = 43
      Width = 65
      Height = 25
      Caption = 'Solve'
      TabOrder = 1
      OnClick = ISolvebtnClick
    end
  end
end
