object Form1: TForm1
  Left = 316
  Top = 256
  Width = 1103
  Height = 760
  Caption = 'Weighting Watermelons (the hard way)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 704
    Width = 1095
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2014, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1095
    Height = 704
    Align = alClient
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 1093
      Height = 702
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = '   The puzzle   '
        object Memo3: TMemo
          Left = 112
          Top = 72
          Width = 857
          Height = 345
          Color = 13172735
          Lines.Strings = (
            
              'A farmer tells his son to select five wateremelons to take to ma' +
              'rket.  Because the watermelons '
            'are sold by weight, they '
            
              'must be put on a scale before the trip to town, but the son make' +
              ' a small mistake and weighs '
            'them in  (all possible) pairs.  '
            'Here are the  weights he comes up with, in pounds:'
            ''
            
              '                                20, 22, ,23, 24, 25, 26, 27, 28,' +
              ' 30, 31'
            ''
            'How much does each of the watermelons weigh?'
            ''
            
              'Source: "Sit & Solve Brain Teasers", Derrick Niederman,  2011 Ha' +
              'llmark Gift Books')
          TabOrder = 0
        end
      end
      object TabSheet2: TTabSheet
        Caption = '   Strategy for Solving   '
        ImageIndex = 1
        object Label1: TLabel
          Left = 288
          Top = 352
          Width = 59
          Height = 23
          Caption = 'Label1'
        end
        object Label2: TLabel
          Left = 712
          Top = 112
          Width = 220
          Height = 23
          Caption = 'Candidate melon weights'
        end
        object Memo1: TMemo
          Left = 32
          Top = 16
          Width = 657
          Height = 585
          Color = 13172735
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Lines.Strings = (
            
              'To solve, we'#39'll use the fact that the two lightest melons must h' +
              'ave'
            
              'a combined weight of 20 lbs, and the two heaviest combine for 31' +
              ' '
            'lbs.'
            'Mathematically, there are indeed exactly 10 ways to choose two'
            
              'objects from a set of 10.  Actually there are 20 ways (5 choices' +
              ' '
            
              'for the 1st object and, for each of these, 4 choices for the 2nd' +
              ').'
            'These are the "permutations", but if, as in our case, the order'
            'of choosing doesn'#39't matter, then half the pairs contain the same'
            'objects'
            'as the other half, just chosen in reverse order.  The 10 pairs'
            
              'under these conditions are the "combination" results for choosin' +
              'g 2'
            'of 10.'
            ''
            'If we labwl the melons A,B,C,D,E by increasing weight, then'
            'combined weights reflect the 10 results from weighing A+B, A+C,'
            'A+D, A+E, B+C, B+D, B+E, C+D, C+E, and D+E.  Under our naming'
            'convention, we'
            
              'now know that A+B must = 20 lbs and D + E must = 31 lbs.  We als' +
              'o know'
            'that the sum of all'
            'the weighings (256 lbs) contains each of the melons weighed 4'
            'times, so the'
            
              'total weight of the melons weighed one time is 64 lbs and theref' +
              'ore'
            'the weight of melon C must be 64 - 20 - 31 = 13 lbs.'
            ''
            
              'By assigning letter names in increasing weight order, we also ha' +
              've'
            'additional constraints on the other melon weights: B must'
            'be at most 13 lbs and D must be at least 13 pounds.'
            ''
            
              'With this background, we can enumerate the possible individual w' +
              'eights for'
            
              'pairs AB and DE and then test each candidate set of weights to f' +
              'ind'
            
              'the one (or more) sets that can provide the 10 given pair weight' +
              's.'
            ''
            
              'You can now work out the solution for yourself in less than an h' +
              'our'
            
              'or click the buttons at right to let the program do the trial an' +
              'd error grunt'
            'work in less than a millisecond!!')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object SearchBtn: TButton
          Left = 712
          Top = 24
          Width = 281
          Height = 25
          Caption = 'Find candidate weight sets'
          TabOrder = 1
          OnClick = SearchBtnClick
        end
        object Memo2: TMemo
          Left = 712
          Top = 136
          Width = 361
          Height = 465
          Lines.Strings = (
            '')
          TabOrder = 2
        end
        object ShowBtn: TButton
          Left = 712
          Top = 64
          Width = 281
          Height = 25
          Caption = 'Find solution from these'
          Enabled = False
          TabOrder = 3
          OnClick = ShowBtnClick
        end
      end
    end
  end
end
