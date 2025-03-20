object Form1: TForm1
  Left = 192
  Top = 110
  Width = 800
  Height = 600
  Caption = 'Card pair search for "perfect" deck'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Countlbl: TLabel
    Left = 24
    Top = 512
    Width = 31
    Height = 13
    Caption = 'Count:'
  end
  object Label1: TLabel
    Left = 448
    Top = 520
    Width = 68
    Height = 13
    Caption = 'Random Seed'
  end
  object StartBtn: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 120
    Width = 745
    Height = 369
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'Given two card rank values, the original question was:  What is ' +
        'the probability that there are one or '
      
        'more occurrences of the two values being adjacent or with only o' +
        'ne intervening card in a well shuffled '
      'standard 52 card deck?'
      ''
      
        'A previous program, "CardProbability",  answered the question ex' +
        'perimentally.  A followup question:  Is '
      
        'it possible to arrange a deck so that all 78 unique rank pairs m' +
        'eet the condition?  (In choosing pairs, we '
      
        'have 13 choices for the first card and 12 choices for the second' +
        ' or 156 altogether.  But since [a,b] and  '
      
        'b,a] are identical for our purposes, we'#39'll divide by 2 to get 78' +
        ' choices.)'
      ''
      
        'The "Check random decks" option generates random decks and count' +
        's the pairs that meet the '
      
        'condition.  It was not very successful;  no perfect decks found ' +
        'in 500,0000 decks checked.  The '
      
        '"random seed" displayed at the bottom of the form is the last on' +
        'e used, so if you interrupt a run and '
      
        'want to continue later, re-enter the seed before starting the ne' +
        'xt trial.  '
      ''
      
        'The second search type, "hill climbing", starts with a random de' +
        'ck and swaps pairs, keeping those that '
      
        'improve the score.  It finds solutions rapidly, so the trial sto' +
        'ps after 1000 are found. . '
      ' '
      ' ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object SeedEdt: TEdit
    Left = 528
    Top = 512
    Width = 121
    Height = 21
    TabOrder = 2
    Text = '-1335885824'
  end
  object StopBtn: TButton
    Left = 120
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 3
    OnClick = StopBtnClick
  end
  object ModeGrp: TRadioGroup
    Left = 24
    Top = 48
    Width = 225
    Height = 57
    Caption = 'Search type'
    ItemIndex = 0
    Items.Strings = (
      'Check random decks'
      'Hill climbing search (pair swapping}')
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 546
    Width = 792
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
