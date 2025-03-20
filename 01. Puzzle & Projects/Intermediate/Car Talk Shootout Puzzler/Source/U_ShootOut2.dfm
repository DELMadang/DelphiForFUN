object Form1: TForm1
  Left = 161
  Top = 124
  Width = 800
  Height = 554
  Caption = 'Car Talk "Shootout" Puzzler  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 496
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2007,2012  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 784
    Height = 496
    ActivePage = IntroSheet
    Align = alClient
    TabOrder = 1
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 8
        Top = 0
        Width = 753
        Height = 425
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Adapted from a "Car Talk: radio show puzzler: '
          
            'http://www.cartalk.com/content/puzzler/transcripts/200704/index.' +
            'html).  Three men who are mutual enemies '
          
            'decide to settle things with a shootout.  Al is a poor shot only' +
            ' hitting his target 1/3 of the time.  Bob hits his '
          
            'target 2/3 of the time and Charlie hits what he aims at 100% of ' +
            'the time. To even the odds a bit, Al is given '
          
            'first shot. Bob is next, if he'#39's still alive. He'#39's followed by C' +
            'harlie, if he'#39's still alive.  They will continue '
          
            'shooting like this, in this order, until two of them are dead.  ' +
            'The question is: At whom should Al aim his first '
          'shot to maximize his chances of surviving?'
          ''
          
            'Version 2 adds a variation found in the book "Fifty Challenging ' +
            'Problems in Probability", Frederick '
          
            'Mosteller, Dover Books. In this versionA hits his target 30$ of ' +
            'the time, B always hits what he aims at and C '
          'hits his target 50% of the time.'
          ''
          
            'The rotation and the objective are the same: A, B, C shoot in th' +
            'at order and we want A'#39's best strategy.  It '
          'turns out that the best startegy is the same in both cases.'
          ''
          
            'You can also enter your own accuracy value for the 3 shooters if' +
            ' you choose.'
          ''
          
            'In use, select which problem to investigate, or enter your own c' +
            'hoice of accuracy probablilities, select a '
          
            'strategy, and click the button to see the result of simulating s' +
            'imulating 1,000,000 shootouts.'
          ''
          ' ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object ShootSheet: TTabSheet
      Caption = '   Conduct Shootouts   '
      ImageIndex = 1
      object StrategyGrp: TRadioGroup
        Left = 416
        Top = 244
        Width = 345
        Height = 125
        Caption = 'Strategy'
        ItemIndex = 0
        Items.Strings = (
          '1. Shoot at best remaining shooter'
          '2. Shoot at worst remianing shooter'
          '3. Shot at random remaining shooter'
          '4. The "CarTalk"/"Fifty Problems" strategy')
        TabOrder = 0
      end
      object Button1: TButton
        Left = 416
        Top = 380
        Width = 225
        Height = 25
        Caption = 'Play 1,000,000 games'
        TabOrder = 1
        OnClick = SolveBtnClick
      end
      object Memo2: TMemo
        Left = 16
        Top = 8
        Width = 385
        Height = 385
        Lines.Strings = (
          ''
          'Three shooters, Al, Bob, and Carl have mutual '
          'dislike for each other a decide to conduct a "Round '
          'Robin" shootout starting in alphabetical order and '
          'continiung according to some strategy until only one '
          'shooter remains.  Al is the poorest shot, but what '
          'strategy gives him the best chance for survival?'
          ''
          'Two versions of the problem are given, or you can '
          'enter your own accuracy probabilities for each '
          'shooter.'
          ''
          'To explore outcomes, select which problem to '
          'investigate (or enter your own accuracy '
          'probabilities) , select a strategy, and click the '
          'button to see the result of simulating simulating '
          '1,000,000 shootouts.'
          '')
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object GroupBox1: TGroupBox
        Left = 416
        Top = 104
        Width = 305
        Height = 129
        Caption = 'Probability of hitting target'
        TabOrder = 3
        object Label1: TLabel
          Left = 32
          Top = 24
          Width = 58
          Height = 18
          Caption = 'Player A'
        end
        object Label2: TLabel
          Left = 32
          Top = 56
          Width = 59
          Height = 18
          Caption = 'Player B'
        end
        object Label3: TLabel
          Left = 32
          Top = 88
          Width = 60
          Height = 18
          Caption = 'Player C'
        end
        object A_Edt: TEdit
          Left = 104
          Top = 24
          Width = 65
          Height = 26
          TabOrder = 0
          Text = '0.3333'
          OnChange = EdtOddsChange
        end
        object B_Edt: TEdit
          Left = 104
          Top = 56
          Width = 65
          Height = 26
          TabOrder = 1
          Text = '0.6667'
          OnChange = EdtOddsChange
        end
        object C_Edt: TEdit
          Left = 104
          Top = 88
          Width = 65
          Height = 26
          TabOrder = 2
          Text = '1.000'
          OnChange = EdtOddsChange
        end
      end
      object VersionGrp: TRadioGroup
        Left = 416
        Top = 8
        Width = 297
        Height = 73
        Caption = 'Predefined Versions'
        ItemIndex = 0
        Items.Strings = (
          '"Car Talk" puzzler'
          '"50 Probability Problems" book')
        TabOrder = 4
        OnClick = VersionGrpClick
      end
    end
  end
end
