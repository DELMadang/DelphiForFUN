object Form1: TForm1
  Left = 277
  Top = 180
  Width = 1457
  Height = 947
  Caption = 'Card Probability Question  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 792
    Top = 29
    Width = 81
    Height = 16
    Caption = 'Card 1 value'
  end
  object Label2: TLabel
    Left = 792
    Top = 63
    Width = 81
    Height = 16
    Caption = 'Card 2 value'
  end
  object Label4: TLabel
    Left = 41
    Top = 342
    Width = 94
    Height = 16
    Caption = 'First 50 results'
  end
  object Label5: TLabel
    Left = 555
    Top = 31
    Width = 98
    Height = 16
    Caption = 'Number of suits'
  end
  object Label6: TLabel
    Left = 526
    Top = 63
    Width = 127
    Height = 16
    Caption = 'Card values per suit'
  end
  object Memo1: TMemo
    Left = 31
    Top = 21
    Width = 479
    Height = 297
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Given two card rank values, the question is:  What is '
      'the probability that there are one or more '
      'occurrences of'
      'the two values being adjacent or with only one'
      'intervening'
      'card in a well shuffled standard 52 card deck?'
      ''
      'Version 1 finds the answer  experimentally.  The'
      'matching procedure is to move through random'
      'decks from'
      'cards 1 through 50,  checking each card against the'
      'two'
      'cards following for a match against the two test'
      'values,'
      'checked in either order. The card in position 51 is, of'
      'course, only checked against card 52 for a match in'
      'either order.'
      ''
      'If Card 1 value is the same as Card 2 value, the odds'
      'of occurrence are reduced considerably which is'
      'reasonable there are only "NbrSuits" cards which'
      'can be part of the solution compared to 2 x NbrSuits if '
      'the'
      'values are not the same.'
      ''
      'There'#39's an option to restrict "successes" to those with'
      'Card 2 is immediately adjacent to Card 1.'
      ''
      'Version 2 of the program adds adjustable deck size'
      'by specifying the number of suits in the deck and the'
      'number of card values per suit.  It also adds an'
      'analytical solution providing exact probabilities.'
      'These confirm the earlier experimental results.'
      'Thanks to programmer Mark Rickert for the algorithm'
      'which made the analytical solution feasible. ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SpinEdit1: TSpinEdit
    Left = 879
    Top = 24
    Width = 63
    Height = 26
    MaxValue = 13
    MinValue = 1
    TabOrder = 1
    Value = 1
    OnChange = SpinEdit1Change
  end
  object SpinEdit2: TSpinEdit
    Left = 879
    Top = 56
    Width = 63
    Height = 26
    MaxValue = 13
    MinValue = 1
    TabOrder = 2
    Value = 3
    OnChange = SpinEdit2Change
  end
  object Memo2: TMemo
    Left = 539
    Top = 265
    Width = 298
    Height = 84
    Lines.Strings = (
      'Results'
      ''
      '')
    TabOrder = 3
  end
  object Memo3: TMemo
    Left = 31
    Top = 363
    Width = 1168
    Height = 342
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object HitGrp: TRadioGroup
    Left = 969
    Top = 21
    Width = 204
    Height = 74
    Caption = 'Success definition'
    ItemIndex = 1
    Items.Strings = (
      'Adjacent cards only'
      'Adjacent or one intervening')
    TabOrder = 5
    OnClick = HitGrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 879
    Width = 1439
    Height = 25
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2006,2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object NbrSuitsEdt: TSpinEdit
    Left = 656
    Top = 24
    Width = 63
    Height = 26
    MaxValue = 4
    MinValue = 1
    TabOrder = 7
    Value = 4
    OnChange = NbrSuitsEdtChange
  end
  object NbrvaluesEdt: TSpinEdit
    Left = 656
    Top = 56
    Width = 63
    Height = 26
    MaxValue = 13
    MinValue = 1
    TabOrder = 8
    Value = 13
    OnChange = NbrvaluesEdtChange
  end
  object StatsBtn: TButton
    Left = 863
    Top = 194
    Width = 236
    Height = 31
    Caption = 'Calculate exact probabilities'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = StatsBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 539
    Top = 98
    Width = 256
    Height = 143
    Caption = 'Run random deck trials'
    TabOrder = 10
    object Label3: TLabel
      Left = 24
      Top = 33
      Width = 131
      Height = 16
      Caption = 'Nbr of random decks'
    end
    object SpinEdit3: TSpinEdit
      Left = 26
      Top = 48
      Width = 157
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 100000
    end
    object GoBtn: TButton
      Left = 25
      Top = 89
      Width = 77
      Height = 33
      Caption = 'Go'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = GoBtnClick
    end
    object ResetBtn: TButton
      Left = 130
      Top = 88
      Width = 113
      Height = 32
      Caption = 'Reset  Stats'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = ResetBtnClick
    end
  end
  object Memo4: TMemo
    Left = 863
    Top = 259
    Width = 336
    Height = 90
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Results'
      ''
      '')
    ParentFont = False
    TabOrder = 11
  end
  object Button2: TButton
    Left = 858
    Top = 155
    Width = 311
    Height = 22
    Caption = 'Test Mark Rickert'#39's original C code'
    TabOrder = 12
    Visible = False
    OnClick = Button2Click
  end
end
