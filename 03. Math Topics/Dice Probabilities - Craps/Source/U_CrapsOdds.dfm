object Form1: TForm1
  Left = 192
  Top = 114
  Width = 1026
  Height = 735
  Caption = 'Dice Probabilities - Craps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 667
    Width = 1008
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1008
    Height = 667
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Label1: TLabel
        Left = 648
        Top = 48
        Width = 294
        Height = 16
        Caption = '36 possible outcomes of sums of 2 thrown dice'
      end
      object Label2: TLabel
        Left = 600
        Top = 432
        Width = 298
        Height = 16
        Caption = 'Frequency distribution of sums of 2 dice thrown'
      end
      object Label3: TLabel
        Left = 560
        Top = 464
        Width = 28
        Height = 16
        Caption = 'Sum'
      end
      object Label4: TLabel
        Left = 496
        Top = 504
        Width = 94
        Height = 16
        Caption = 'Times it occurs'
      end
      object Memo1: TMemo
        Left = 28
        Top = 12
        Width = 412
        Height = 604
        Lines.Strings = (
          'Craps is a dice game with scoring based sum of rolling 2 dice.  '
          
            'A game ends in a single roll if the player wins if he rolls a 7 ' +
            'or '
          '11 (a Natural), or loses  if he rolls a 2, 3, or 12 (Craps).'
          ''
          
            'If the first roll is one of the other possibilities, 4, 5, 6, 8,' +
            ' 9, or '
          '10, that sum is called the "point". and the game continues with '
          
            'additional rolls until the point is rolled again (a win) or a 7 ' +
            'is '
          'rolled (a loss).'
          ''
          'This program calculates the theoretical chances of winning or'
          'losing for each of the eleven initial roll possible outcomes (2 '
          'through 12). It also has a page which simulates a million games '
          'to veify that the theroretical results are valid.'
          ''
          'The top table at right shows the 36 possible sum outcomes'
          'when two dice are rolled.  The lower table shows the '
          '"frequency distribution" of sums, the number of ways that each '
          'sum can occur.  These values allow us to calculate the'
          'probability of any particular sum occurring on any single roll.'
          'For example, a 4 sum can occur in 3 ways so the chances of a '
          '4 on any roll is 3 out of 36 or 3/36 = 1/12.'
          '')
        TabOrder = 0
      end
      object StringGrid1: TStringGrid
        Left = 648
        Top = 72
        Width = 241
        Height = 241
        ColCount = 7
        DefaultColWidth = 32
        DefaultRowHeight = 32
        RowCount = 7
        TabOrder = 1
      end
      object StringGrid2: TStringGrid
        Left = 600
        Top = 456
        Width = 369
        Height = 73
        ColCount = 11
        DefaultColWidth = 32
        DefaultRowHeight = 32
        FixedCols = 0
        RowCount = 2
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Odds of Winning'
      ImageIndex = 1
      object WinBth: TButton
        Left = 51
        Top = 51
        Width = 278
        Height = 28
        Caption = 'Theoretical  ways to win'
        TabOrder = 0
        OnClick = WinBthClick
      end
      object Memo2: TMemo
        Left = 344
        Top = 48
        Width = 617
        Height = 505
        Lines.Strings = (
          
            'All scoring is based on the sum of the face-up numbers when two ' +
            'dice are thrown.'
          ''
          'A player wins in one of two ways:'
          ''
          '1.) On his first roll, rolls a "Natural" by rolling 7 or 11 or'
          
            '2.) on his first roll thows 4, 5, 6, 8, 9, 10 (his point), and t' +
            'hen continues to roll and rolls his '
          'point a second time befopre rolling a 7.'
          ''
          'Click the button at left to analyze the odds of all ways to win.'
          ''
          '')
        TabOrder = 1
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Odds of losing'
      ImageIndex = 2
      object LoseBtn: TButton
        Left = 51
        Top = 51
        Width = 278
        Height = 28
        Caption = 'Theoretical  ways to lose'
        TabOrder = 0
        OnClick = LoseBtnClick
      end
      object Memo3: TMemo
        Left = 392
        Top = 48
        Width = 569
        Height = 465
        Lines.Strings = (
          
            'All scoring is based on the sum of the face-up numbers when two ' +
            'dice are thrown.'
          ''
          'A player loses in one of two ways:'
          ''
          'On his first roll, "craps out" by rolling 2, 3, or 12 or'
          
            'on his first roll thows 4, 5, 6, 8, 9, 10 (his point), and then ' +
            'continues to roll and rolls a 7 '
          'before he rolls his point a second time.'
          ''
          
            'Click the button at left to analyze the odds of all ways to lose' +
            '. '
          '')
        TabOrder = 1
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Experimental results'
      ImageIndex = 3
      object Memo4: TMemo
        Left = 8
        Top = 80
        Width = 977
        Height = 513
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          
            'Click buuton above to play a million random games and report res' +
            'ults'
          ' ')
        ParentFont = False
        TabOrder = 0
      end
      object ExperimentBtn: TButton
        Left = 56
        Top = 32
        Width = 257
        Height = 25
        Caption = 'Play 1,000,000 random games'
        TabOrder = 1
        OnClick = ExperimentBtnClick
      end
    end
  end
end
