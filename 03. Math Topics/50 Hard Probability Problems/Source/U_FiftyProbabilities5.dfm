object Form1: TForm1
  Left = 135
  Top = 194
  AutoScroll = False
  Caption = 'Fifty Probability Problems,   Version 5.0'
  ClientHeight = 662
  ClientWidth = 1184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 640
    Width = 1184
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 640
    Align = alClient
    TabOrder = 1
    object ExperimentalBtn: TButton
      Left = 798
      Top = 229
      Width = 315
      Height = 25
      Caption = 'Experimental results (1,000,000 Trials)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ExperimentalBtnClick
    end
    object AnalyticalBtn: TButton
      Left = 792
      Top = 184
      Width = 313
      Height = 25
      Caption = 'Analytical Solution'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = AnalyticalBtnClick
    end
    object Memo2: TMemo
      Left = 24
      Top = 352
      Width = 1113
      Height = 289
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Memo2')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object Showbox: TCheckBox
      Left = 800
      Top = 264
      Width = 257
      Height = 17
      Caption = 'Display the first 10 trial results'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object PageControl1: TPageControl
      Left = 16
      Top = 0
      Width = 745
      Height = 337
      ActivePage = TabSheet20
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MultiLine = True
      ParentFont = False
      TabOrder = 4
      OnEnter = TabSheetEnter
      object IntroSheet: TTabSheet
        Caption = 'Introduction   '
        object Memo4: TMemo
          Left = 20
          Top = 2
          Width = 717
          Height = 255
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            ''
            
              'Here are some probability problems selected from the book "Fifty' +
              ' Challenging Problems in '
            'Probability" by Fredereck Mosteller, Dover Publications.'
            ''
            
              'Problems are described on separate pages selectable by clicking ' +
              'on the problem titles above.  The '
            
              'buttons at the far right will provide an analytical solution and' +
              ' an experimental simulation of the '
            
              'selected problem.   The analytical solution derives the answer u' +
              'sing the principles of probability '
            
              'theory and which hopefully is confirmed by running a million sim' +
              'ulated trials of the problem and '
            'counting the number of successful outcomes.'
            ''
            
              'This is Version 5.0 which has the 5th of the 50 problems from th' +
              'e book (problem #20 about a 3-way '
            'shootout).  More may be added in the future.')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet16: TTabSheet
        Caption = '  #16 && #17: Ladder Tournaments  '
        ImageIndex = 1
        OnEnter = TabSheetEnter
        object Memo1: TMemo
          Left = 20
          Top = 10
          Width = 717
          Height = 199
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              '#16: Assign 8 tennis players  randomly to start positions in a l' +
              'adder tournament. Player'
            
              'A wins against any of the others. Player B always beats any oppo' +
              'nent except'
            
              'player A.  In the initial round there are 4 matches:  position 1' +
              ' plays position 2, position 3 plays 4, 5 '
            'plays 6, and 7 plays 8.'
            ''
            
              'The second round has 2 matches: winner of  the (1,2) match plays' +
              ' winner of (3,4), and'
            
              'winner of (5,6) plays winner of (7,8).  The winners of the two 2' +
              'nd round matches '
            'play each in the final match.'
            ''
            
              'What is the probability that player B gets to the final  match a' +
              'nd therefore wins the runner-up trophy?')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Prob16_17Grp: TRadioGroup
          Left = 24
          Top = 232
          Width = 689
          Height = 44
          Caption = 'Select a problem'
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Problem 16: The runner-up'
            'Problem 17: The twins')
          ParentFont = False
          TabOrder = 1
          OnClick = Prob16_17GrpClick
        end
      end
      object TabSheet18: TTabSheet
        Caption = '  #18: P(50 Heads in 100)   '
        ImageIndex = 3
        object Label1: TLabel
          Left = 112
          Top = 248
          Width = 221
          Height = 16
          Caption = 'Number of coins to toss (even only)'
        end
        object Memo5: TMemo
          Left = -4
          Top = 2
          Width = 717
          Height = 226
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'If  100 coins are tossed, what is the probability that  exactly ' +
              '50 heads will be showing.?'
            ''
            
              'In this version of the problem, you can specify any even number ' +
              'of coins from  2 to 100. ')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object NbrCoinsEdt: TEdit
          Left = 360
          Top = 244
          Width = 36
          Height = 24
          TabOrder = 1
          Text = '100'
        end
        object NbrCoinsUD: TUpDown
          Left = 396
          Top = 244
          Width = 16
          Height = 24
          Associate = NbrCoinsEdt
          Min = 2
          Position = 100
          TabOrder = 2
        end
      end
      object TabSheet19: TTabSheet
        Caption = '  #19:  Newton helps Pepys '
        ImageIndex = 2
        OnEnter = TabSheetEnter
        object Memo3: TMemo
          Left = -4
          Top = 2
          Width = 717
          Height = 226
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            'The Newton-Pepys Problem'
            ''
            
              'Samuel Pepys wrote Isaac Newton to ask which of these events is ' +
              'more likely: that a person get (a) '
            
              'at least 1 six when 6 dice are rolled. (b) at least 2 sixes when' +
              ' 12 dice are rolled, or (c) at least 3 '
            'sixes when 18 dice are rolled. '
            ''
            'What is the answer?')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet20: TTabSheet
        Caption = '#20: A 3 Cornered Duel'
        ImageIndex = 4
        object Memo6: TMemo
          Left = 28
          Top = 18
          Width = 645
          Height = 135
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'A, B, and C are to fight a three cornered pistol duel.  All know' +
              ' that A'#39's chance of hitting his '
            
              'target is 0.3, C'#39's is 0.5 and B never misses.  They are to fire ' +
              'at their choice of target in '
            
              'succession in order A, B, C, cyclically (but a hit man is out of' +
              ' the contest, neither shooter '
            'nor shot at), until only one man remains.  '
            ''
            'What should A'#39's strategy be?')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object StrategyGrp: TRadioGroup
          Left = 32
          Top = 168
          Width = 625
          Height = 81
          Caption = 'Al'#39's strategy'
          ItemIndex = 0
          Items.Strings = (
            'Shoot at best remaining live oppoenent'
            
              'First shot deliberately misses, then shoot at best remainng shoo' +
              'ter ')
          TabOrder = 1
        end
      end
    end
  end
end
