object Form1: TForm1
  Left = 206
  Top = 151
  Width = 709
  Height = 500
  Caption = 'Probability 5 twos in two rolls of 5 dice'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 64
    Top = 32
    Width = 569
    Height = 393
    ActivePage = TabSheet3
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'The Problem'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 561
        Height = 365
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'A recent feedback email to DFF:'
          ''
          'Contact requested'
          ''
          
            'My local bar has a game. 5 dice in a cup. You have to roll 5 Two' +
            #39's in two shakes and you '
          
            'can "farm".  i.e. Roll the first time, save any two'#39's, pick up t' +
            'he remaining dice and roll '
          'them.'
          ''
          
            'What are the odds that five two'#39's will be rolled this way?  The ' +
            'bet is $2 and the pot is '
          'currently over $2,800.00'
          ''
          'Just curious.'
          ''
          'Thanks.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object SolSheet1: TTabSheet
      Caption = 'Solution #1'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 561
        Height = 365
        Align = alClient
        Lines.Strings = (
          
            'First we'#39#39'll calculate all P(M,N): The probability of rolling M ' +
            'twos when N dice are thrown.'
          
            'For the first roll, N is always 5.  For the 2nd roll, N will be ' +
            'the number of dice that did not show a 2.'
          ''
          
            'P(M,N) is calculated as the probability that a single roll produ' +
            'ces M twos,(1/6)^M, times the probability that each of'
          
            'the others is not a two (5/6)^(N-M), times the number of ways th' +
            'e M twos could be selected from the N dice.  This'
          
            'last number is the number of combinations of N things taken M at' +
            ' a time.'
          ''
          
            'So, for example, the chance of 2 twos showing when 3 dice are th' +
            'rown is as follows:'
          'P(2,3)=(1/6)x(1/6)x(5/6)x3=15/216=0.069444.'
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object SolSheet2: TTabSheet
      Caption = 'Solution #2'
      ImageIndex = 2
      object Memo3: TMemo
        Left = 0
        Top = 0
        Width = 561
        Height = 365
        Align = alClient
        Lines.Strings = (
          
            'As a simpler way to check, we can reformulate the problem as fol' +
            'lows:'
          ''
          
            'Assume that we throw the 5 dice individually.  We'#39'll thow each d' +
            'ie once and if the result is not a 2 then we'#39'll throw it a '
          
            'second time.  In fact, their is no penalty for throwing the die ' +
            'a second time so for each die we can caclulate the '
          'probability of 1 or 2 twos on two throws of a die,  '
          ''
          
            'Using the definition of P from Solution #1, this equals P(1,2) +' +
            ' P(2,2) = 0.305556'
          ''
          '(It is also 1- P(0,2) = 1- 0.694444 = 0.305556)'
          ''
          
            'For 5 dice, the probability that all 5 show 1 or 2 twos when thr' +
            'own twice is the product of the individual probabilities = '
          '0.305556^5 = 0.0026635  which agrees with Solution #1')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Validate P(M,N)'
      ImageIndex = 3
      object Memo4: TMemo
        Left = 0
        Top = 0
        Width = 561
        Height = 365
        Align = alClient
        Lines.Strings = (
          
            'Since both solution methods depend on the value returned by the ' +
            'P(M,N) function, it seems prudent to somwhow'
          'validate the values returned by that function.'
          ''
          
            'P(M,N) returns the probability that a random thow of N dice will' +
            ' have exactly M twos.  We can validate this by'
          
            'generating all possible outcomes for N throws and tabulating the' +
            ' number of twos in each outcome. '
          ''
          
            'Below are the results listing the number of twos for all out pos' +
            'sible outcomes for each length.  The probabilities are'
          
            'calulated by dividing the count of outcomes for each M from 0 to' +
            ' N and dividing it by the total number of'
          
            'outcomes.  The result is subtracted from the P(M,N) function ret' +
            'urns and the error listed.'
          ''
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Simulation'
      ImageIndex = 4
      object Memo5: TMemo
        Left = 24
        Top = 72
        Width = 513
        Height = 265
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object SimBtn: TButton
        Left = 88
        Top = 32
        Width = 201
        Height = 25
        Caption = 'Simulate 1,000,000 additional rounds'
        TabOrder = 1
        OnClick = SimBtnClick
      end
      object ResetBtn: TButton
        Left = 320
        Top = 32
        Width = 75
        Height = 25
        Caption = 'Reset'
        TabOrder = 2
        OnClick = ResetBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 444
    Width = 693
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
