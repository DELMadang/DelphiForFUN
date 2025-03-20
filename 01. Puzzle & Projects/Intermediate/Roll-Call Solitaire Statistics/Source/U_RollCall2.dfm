object Form1: TForm1
  Left = 192
  Top = 116
  Width = 917
  Height = 639
  Caption = '"Roll Call" solitaire simulation,  Version 2 '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object Memo2: TMemo
    Left = 32
    Top = 32
    Width = 425
    Height = 529
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Rules of Play (as submitted by Kevin S., who requested the odds ' +
        'of '
      'winning this solitaire card game.)'
      ''
      
        'Deal one card into the waste pile, calling "Ace" for the first c' +
        'ard, '
      
        '"Two" for the second, up to "King" for the thirteenth card and t' +
        'hen '
      
        'back to "Ace" again and so on through the deck.  If the card dea' +
        'lt is '
      
        'the of the rank you called, it is a "hit" and can be discarded t' +
        'o the '
      'foundation pile.'
      ''
      
        'Unlimited redeals--(iterations through the deck) are allowed, bu' +
        't '
      
        'continue calling where you left off each time (don'#39't start back ' +
        'at '
      
        '"Ace").  If Three Consecutive (Three Strikes & You'#39're Out) cycle' +
        's '
      
        'through the deck occur without moving a card to the foundation p' +
        'ile, '
      'the game is considered a loss.'
      ''
      'NOTE : Ten cards or fewer remaining when the game is "lost" can '
      'be considered a "Moral Victory".  The Moral Victory option came '
      'from a solitaire book from the early 1970'#39's, "150 ways to Play '
      'Solitaire".'
      '----------------------'
      ''
      'I implemented a simulation of a number of games to estimate the '
      
        'probability of winning for various versions.The  "infinite cycle' +
        's" option '
      
        'is called  "13 non-move cycles"  since that seems enough to be a' +
        ' '
      'stand-in for infinite  cycles.  '
      ''
      
        'After a set of games are "played",  you can "replay" any selecte' +
        'd '
      
        'wiinning games (up to the first 100) by clicking on the winning ' +
        'game '
      
        'deck.  A separate display will detail the cards  played or that ' +
        'game. '
      ''
      'Version 2 adds some game length statistics and a separate page '
      
        'showing the distribution of he number of strikes for winning gam' +
        'es.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object PlayBtn: TButton
    Left = 488
    Top = 200
    Width = 81
    Height = 25
    Caption = 'Play'
    TabOrder = 0
    OnClick = PlayBtnClick
  end
  object Modegrp: TRadioGroup
    Left = 488
    Top = 24
    Width = 393
    Height = 81
    Caption = 'Losing criteria'
    ItemIndex = 1
    Items.Strings = (
      '2 consecutive "Strikes" (non-move cycles)'
      '3 consecutive "Strikes" (non-move cycles)'
      '13 consecutive "Strikes" (non-move cycles)')
    TabOrder = 1
  end
  object GamesGrp: TRadioGroup
    Left = 488
    Top = 120
    Width = 193
    Height = 65
    Caption = 'Games to play'
    Columns = 2
    ItemIndex = 1
    Items.Strings = (
      '1000'
      '10,000'
      '100,000'
      '1,000,000')
    TabOrder = 2
  end
  object ResetBtn: TButton
    Left = 600
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Reset stats'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 583
    Width = 901
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, 2008 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object Memo4: TMemo
    Left = 32
    Top = 32
    Width = 425
    Height = 233
    Lines.Strings = (
      'Memo4')
    ScrollBars = ssVertical
    TabOrder = 7
    OnClick = Memo4Click
  end
  object PageControl1: TPageControl
    Left = 488
    Top = 256
    Width = 385
    Height = 305
    ActivePage = TabSheet3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    object TabSheet1: TTabSheet
      Caption = 'Latest run '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      object Memo1: TMemo
        Left = 16
        Top = 8
        Width = 345
        Height = 257
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Since last Reset'
      ImageIndex = 1
      object Memo5: TMemo
        Left = 16
        Top = 8
        Width = 345
        Height = 257
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      BorderWidth = 2
      Caption = 'Distribution of Strikes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ImageIndex = 2
      ParentFont = False
      object Memo6: TMemo
        Left = 16
        Top = 8
        Width = 345
        Height = 257
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Memo3: TMemo
    Left = 32
    Top = 280
    Width = 425
    Height = 281
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 6
    Visible = False
  end
  object GroupBox1: TGroupBox
    Left = 704
    Top = 120
    Width = 185
    Height = 105
    Caption = 'Show detail games for...'
    TabOrder = 9
    object Zerobox: TCheckBox
      Left = 24
      Top = 16
      Width = 121
      Height = 17
      Caption = 'Zero strike winners'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object OneBox: TCheckBox
      Left = 24
      Top = 35
      Width = 113
      Height = 17
      Caption = 'One srike winners'
      TabOrder = 1
    end
    object Allbox: TCheckBox
      Left = 24
      Top = 72
      Width = 97
      Height = 17
      Caption = 'All winners'
      TabOrder = 2
    end
    object Longbox: TCheckBox
      Left = 24
      Top = 53
      Width = 145
      Height = 17
      Caption = '>=50 strike winners '
      TabOrder = 3
    end
  end
end
