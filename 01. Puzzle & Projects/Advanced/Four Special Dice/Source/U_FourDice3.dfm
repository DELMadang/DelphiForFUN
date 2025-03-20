object Form1: TForm1
  Left = 114
  Top = 133
  Width = 800
  Height = 582
  Caption = 'Four Dice - I can always win! (Non-Transitive Dice Demo)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 531
    ActivePage = SolveSheet
    Align = alClient
    TabOrder = 0
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      ImageIndex = 1
      object Memo4: TMemo
        Left = 32
        Top = 32
        Width = 465
        Height = 449
        Color = 14548991
        Lines.Strings = (
          
            'Here'#39's a program which solves puzzles illustrating the non-trans' +
            'itive nature of probability.'
          ''
          
            'Transitivity is an important property of the "size" relationship' +
            ' that allows us to solve '
          
            'many algebra and logic puzzles.   Transitivity for relationship ' +
            '"R" says that if A "R" B is true and B '
          
            '"R" C is true then A "R" C is true.  For example:  If A=B and B=' +
            'C then A=C; If A>B and B>C then '
          'A>C.'
          ''
          
            'It does not hold true however for the more complex "defeats" rel' +
            'ationship. For example, in the '
          '"Rock, '
          
            'Scissors, paper" game:    "Rock defeats Scissors" and   "Scissor' +
            's defeats Paper" but "Rock  '
          'does not defeat Paper".   '
          ''
          
            'Here we look at another example using dice.  We are given a set ' +
            'of 4 special dice.  They are six '
          
            'sided dice but have between 1 and 7 dots per side and the number' +
            ' per side may be repeated.  '
          
            'The dice are "fair", i.e ., each side is equally likely to be th' +
            'e top face when the die is thrown.'
          ''
          
            'In this particular set one of the dice has 1,1,5,5,5,5 dots on i' +
            't'#39's sides.  The whole '
          
            'set has a peculiar property. If we label them appropriately as A' +
            ', B, C, and D, then roll '
          
            'them in pairs  and compare the number of dots on the top face,  ' +
            'we get the following '
          'results:'
          ''
          'A will  beat B 2/3 of  the time'
          'B will  beat C, 2/3 of the time,.'
          'C will  beat D, 2/3 of the time, and'
          'D will  beat A 2/3 of the time!!!'
          ''
          'Can you find the configuration of the other three dice?.'
          ''
          
            'Once a set is found, you can define a game where player 2 (you) ' +
            'has a definite advantage,  Just '
          
            'let player 1 select which die to roll and you can always choose ' +
            'one which will, on average, '
          'beat it.'
          ''
          ''
          ' ')
        TabOrder = 0
      end
    end
    object SolveSheet: TTabSheet
      Caption = 'Solve it'
      object Label1: TLabel
        Left = 224
        Top = 32
        Width = 64
        Height = 13
        Caption = 'Faces per die'
      end
      object Label2: TLabel
        Left = 224
        Top = 88
        Width = 97
        Height = 13
        Caption = 'Max number on face'
      end
      object Label3: TLabel
        Left = 224
        Top = 144
        Width = 111
        Height = 13
        Caption = 'Min prob  to win (0-100)'
      end
      object Label4: TLabel
        Left = 224
        Top = 272
        Width = 88
        Height = 13
        Caption = 'Begin search from:'
      end
      object Label5: TLabel
        Left = 224
        Top = 200
        Width = 108
        Height = 13
        Caption = 'Largest set  as solution'
      end
      object Label6: TLabel
        Left = 392
        Top = 432
        Width = 332
        Height = 16
        Caption = 'Click on a solution to view or print a playing card version '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object CheckLbl: TLabel
        Left = 392
        Top = 32
        Width = 369
        Height = 81
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Memo1: TMemo
        Left = 8
        Top = 32
        Width = 201
        Height = 417
        Color = 14548991
        Lines.Strings = (
          'The default parameters will solve the '
          'puzzle as stated on the Introduction '
          'page, but you can experiment to find '
          'other solutions.'
          ''
          'Run times  depend on the number of'
          'sides per die, the range of numbers'
          'allowed and the the maximum number of'
          'dice allowed in a set that forms the'
          'non-transitve loop, where the last die in'
          'the set defeats the first die.'
          ''
          'The Mininum Probability box sets your'
          'minimum chance of winning if played as a'
          'game where you let your opponent'
          'choose his die first and then you choose '
          'the die preceding his choice in the set.'
          ''
          '"Begin search from" box can be used to'
          'specify a starting die configuration in'
          'case a prior partial search was '
          'interrupted.'
          ''
          'Finally, since dice are difficult to'
          'physically produce, you can click on any '
          'solution line to view and/or print a set of '
          'cards representing a set of dice.'
          '')
        TabOrder = 0
      end
      object SpinEdit1: TSpinEdit
        Left = 224
        Top = 48
        Width = 41
        Height = 22
        MaxValue = 10
        MinValue = 2
        TabOrder = 1
        Value = 6
        OnExit = SpinEditChange
      end
      object SpinEdit2: TSpinEdit
        Left = 224
        Top = 104
        Width = 41
        Height = 22
        MaxValue = 12
        MinValue = 2
        TabOrder = 2
        Value = 7
        OnExit = SpinEditChange
      end
      object SpinEdit3: TSpinEdit
        Left = 224
        Top = 160
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 0
        TabOrder = 3
        Value = 66
        OnExit = SpinEditChange
      end
      object Edit1: TEdit
        Left = 224
        Top = 288
        Width = 121
        Height = 21
        TabOrder = 4
        Text = '1,1,5,5,5,5'
      end
      object Solvebtn: TButton
        Left = 224
        Top = 376
        Width = 75
        Height = 25
        Caption = 'Solve'
        TabOrder = 5
        OnClick = SolvebtnClick
      end
      object SpinEdit4: TSpinEdit
        Left = 224
        Top = 216
        Width = 41
        Height = 22
        MaxValue = 100
        MinValue = 3
        TabOrder = 6
        Value = 5
        OnExit = SpinEditChange
      end
      object Memo2: TMemo
        Left = 360
        Top = 120
        Width = 409
        Height = 305
        ScrollBars = ssBoth
        TabOrder = 7
        OnClick = Memo2Click
      end
      object Memo3: TMemo
        Left = 360
        Top = 24
        Width = 409
        Height = 89
        Color = clBtnFace
        Lines.Strings = (
          '')
        TabOrder = 8
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 531
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object PrintDialog1: TPrintDialog
    Left = 704
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 748
  end
end
