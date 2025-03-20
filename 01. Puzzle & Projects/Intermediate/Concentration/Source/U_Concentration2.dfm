object Form1: TForm1
  Left = 164
  Top = 114
  Width = 800
  Height = 600
  Caption = 'Concentration  V2.0  (Advanced Concentration)'
  Color = 14548991
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 16
    Top = 448
    Width = 150
    Height = 48
    Caption = 
      'Click 2 or 3 cards to find as a matched set.  A match earns an e' +
      'xtra turn,'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 504
    Top = 440
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Number of Sets'
    WordWrap = True
  end
  object TurnLbl: TLabel
    Left = 16
    Top = 416
    Width = 67
    Height = 19
    Caption = 'Player 1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 496
    Top = 512
    Width = 42
    Height = 18
    Caption = 'Score'
  end
  object Score1Lbl: TLabel
    Left = 592
    Top = 512
    Width = 9
    Height = 18
    Caption = '0'
  end
  object Score2Lbl: TLabel
    Left = 680
    Top = 512
    Width = 9
    Height = 18
    Caption = '0'
  end
  object NewGameBtn: TButton
    Left = 16
    Top = 512
    Width = 105
    Height = 25
    Caption = 'New game'
    TabOrder = 0
    OnClick = NewGameBtnClick
  end
  object PlayerGrp: TRadioGroup
    Left = 624
    Top = 440
    Width = 137
    Height = 49
    Caption = 'Number of players'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      '1'
      '2')
    TabOrder = 1
    OnClick = NewGameBtnClick
  end
  object PairsEdt: TSpinEdit
    Left = 536
    Top = 464
    Width = 49
    Height = 28
    MaxValue = 20
    MinValue = 1
    TabOrder = 2
    Value = 10
    OnChange = NewGameBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object CardsGrp: TRadioGroup
    Left = 192
    Top = 440
    Width = 113
    Height = 73
    Caption = 'Cards per set'
    ItemIndex = 0
    Items.Strings = (
      'Pairs'
      'Triplets')
    TabOrder = 4
    OnClick = CardsGrpClick
  end
  object MatchTypeGrp: TRadioGroup
    Left = 328
    Top = 440
    Width = 153
    Height = 73
    Caption = 'Match type'
    ItemIndex = 0
    Items.Strings = (
      'Vaues and Suits'
      'Values only')
    TabOrder = 5
    OnClick = NewGameBtnClick
  end
end
