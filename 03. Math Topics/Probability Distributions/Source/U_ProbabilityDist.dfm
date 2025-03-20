object Form1: TForm1
  Left = 99
  Top = 104
  Width = 862
  Height = 701
  Anchors = [akLeft, akBottom]
  Caption = 'Probability Distribution Charts and Functions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 844
    Height = 636
    ActivePage = TabSheet6
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo6: TMemo
        Left = 20
        Top = 10
        Width = 730
        Height = 572
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'Here'#39's a program which looks at some common distributions of ran' +
            'dom variables.   You will need a'
          
            'statistics course or at least a good text book to understand eve' +
            'rything here, but the the basic'
          'concepts are not that difficult.  First some terminology.'
          ''
          
            'Imagine that you place 500 dots randomly on a piece of paper tha' +
            't has been marked off into 100'
          
            'squares (10 x 10).  If you make a chart with "Number of dots per' +
            ' square" (N) as the X axis and'
          
            '"Number of squares" (F) as the Y axis, you will have created a f' +
            'requency distribution chart.'
          ''
          
            'If you further divide each value of F by 100, the total number o' +
            'f squares, the results become'
          
            'probabilities and the resulting chart is an approximation of the' +
            ' probability density chart for the'
          
            'random variable N.  For each value of N the probability density ' +
            'function will tell us the probability'
          'of that value if we perform a large  number of  experiements.'
          ''
          
            'If we sum the probability values from left to right, the chart (' +
            'or function) will tell us the probability of the'
          
            'number of dots in any square being  less than or equal to  N.  T' +
            'he is called the cumulative'
          
            'distribution function.  The random variable N is a "discrete ran' +
            'dom variable" since it can only '
          
            'assume discrete values and, for this example, the distribution i' +
            's "Poisson" with a mean value of 5.'
          ''
          
            'The distributions in this program have mathematical functions wh' +
            'ich describe them but you will have '
          
            'to search your statisitcs book (or the program source code) for ' +
            'the specifics.  In the'
          
            'following pages, we'#39'll generate some random samples as if they w' +
            'ere selected from a population'
          
            'with the specified characterisitcs. The plots will compare the d' +
            'istributions of the sample data (bar'
          
            'chart data), with the theroretical distribution for that variabl' +
            'e  (the line chart).'
          ''
          ''
          ''
          ' '
          ' '
          ' '
          ' ')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Uniform Distribution'
      ImageIndex = 1
      object Label4: TLabel
        Left = 20
        Top = 453
        Width = 53
        Height = 16
        Caption = 'Minimum'
      end
      object Label5: TLabel
        Left = 197
        Top = 453
        Width = 117
        Height = 16
        Caption = 'Number of samples'
      end
      object Label6: TLabel
        Left = 20
        Top = 492
        Width = 57
        Height = 16
        Caption = 'Maximum'
      end
      object Memo2: TMemo
        Left = 20
        Top = 20
        Width = 464
        Height = 336
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'All values from a uniform distribution are equally likely.'
          ''
          'Uniform distributions can occur in in discrete or '
          'continuous form,   Discrete as when we select '
          'integers randomly, or draw uniquely colored balls '
          'from  a bag, replacing each ball before drawing again.'
          ''
          'Or continuous as when computer languages generate '
          'uniformly distributed  real numbers between 0 and 1 as one '
          'of their standard functions.  The 20 or 30 digts of '
          'accuracy give a fair approximation of a continuous '
          'uniformly distributed random variable.'
          ''
          'In this example we will stick to uniformly distributed '
          'integers within a range.  ')
        ParentFont = False
        TabOrder = 0
      end
      object Edit1: TEdit
        Left = 89
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 1
        Text = '1'
      end
      object UpDown1: TUpDown
        Left = 139
        Top = 453
        Width = 19
        Height = 24
        Associate = Edit1
        Min = 1
        Position = 1
        TabOrder = 2
      end
      object Edit2: TEdit
        Left = 325
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 3
        Text = '1,000'
      end
      object UpDown2: TUpDown
        Left = 375
        Top = 453
        Width = 19
        Height = 24
        Associate = Edit2
        Min = 1
        Max = 10000
        Position = 1000
        TabOrder = 4
      end
      object Edit3: TEdit
        Left = 89
        Top = 492
        Width = 50
        Height = 24
        TabOrder = 5
        Text = '10'
      end
      object UpDown3: TUpDown
        Left = 139
        Top = 492
        Width = 19
        Height = 24
        Associate = Edit3
        Min = 2
        Position = 10
        TabOrder = 6
      end
      object GenUBtn: TButton
        Left = 20
        Top = 537
        Width = 92
        Height = 30
        Caption = 'Run a set'
        TabOrder = 7
        OnClick = GenUBtnClick
      end
      object PlotType: TRadioGroup
        Left = 482
        Top = 453
        Width = 228
        Height = 129
        Caption = 'Plot type'
        ItemIndex = 0
        Items.Strings = (
          'Frequency'
          'Cumulative Frequency'
          'Probability'
          'Cumulative Probability')
        TabOrder = 8
        OnClick = DrawChartU
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Poisson'
      ImageIndex = 3
      object Label11: TLabel
        Left = 20
        Top = 453
        Width = 100
        Height = 16
        Caption = 'Avg  Arrival Rate'
      end
      object Label13: TLabel
        Left = 20
        Top = 492
        Width = 109
        Height = 16
        Caption = 'Number of arrivals'
      end
      object Memo4: TMemo
        Left = 20
        Top = 20
        Width = 444
        Height = 296
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Many discrete natural processes have time or space '
          'related events measured as ocurrences per unit measure'
          'that occur in a distribution approximated by the Poisson '
          'Distribution,   The Frequency or Probability Distribution '
          'curves resemble the normal "bell" curve for if the mean '
          'observed rate is high, but definitely scewed to the left for '
          'smaller mean values. '
          ''
          'The data are not generated by outcomes of experiments, '
          'but by randomly occurring events.  Further we are interested '
          'in the occurrence of events rather than the non-occurrence.  '
          'The number of vehicles per hour arriving at the toll booth '
          'or the number of errors per printed page are  examples.'
          ''
          '')
        ParentFont = False
        TabOrder = 0
      end
      object Edit8: TEdit
        Left = 148
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 1
        Text = '2.5'
      end
      object GenPBtn: TButton
        Left = 20
        Top = 546
        Width = 92
        Height = 31
        Caption = 'Run a set'
        TabOrder = 2
        OnClick = GenPBtnClick
      end
      object Edit10: TEdit
        Left = 148
        Top = 492
        Width = 50
        Height = 24
        TabOrder = 3
        Text = '1,000'
      end
      object UpDown8: TUpDown
        Left = 198
        Top = 492
        Width = 19
        Height = 24
        Associate = Edit10
        Min = 1
        Max = 10000
        Position = 1000
        TabOrder = 4
      end
      object PlotTypeP: TRadioGroup
        Left = 482
        Top = 453
        Width = 228
        Height = 129
        Caption = 'Plot type'
        ItemIndex = 0
        Items.Strings = (
          'Frequency'
          'Cumulative Frequency'
          'Probability'
          'Cumulative Probability')
        TabOrder = 5
        OnClick = DrawChartP
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Normal '
      ImageIndex = 2
      object Label7: TLabel
        Left = 20
        Top = 453
        Width = 34
        Height = 16
        Caption = 'Mean'
      end
      object Label8: TLabel
        Left = 20
        Top = 492
        Width = 80
        Height = 16
        Caption = 'Std Deviation'
      end
      object Label9: TLabel
        Left = 197
        Top = 453
        Width = 117
        Height = 16
        Caption = 'Number of samples'
      end
      object Label10: TLabel
        Left = 197
        Top = 502
        Width = 119
        Height = 41
        AutoSize = False
        Caption = 'Number of buckets in plot'
        WordWrap = True
      end
      object Edit4: TEdit
        Left = 108
        Top = 453
        Width = 51
        Height = 24
        TabOrder = 0
        Text = '68'
      end
      object Edit5: TEdit
        Left = 108
        Top = 492
        Width = 51
        Height = 24
        TabOrder = 1
        Text = '2.5'
      end
      object GenNBtn: TButton
        Left = 20
        Top = 546
        Width = 92
        Height = 31
        Caption = 'Run a set'
        TabOrder = 2
        OnClick = GenNBtnClick
      end
      object Edit6: TEdit
        Left = 325
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 3
        Text = '1,000'
      end
      object UpDown4: TUpDown
        Left = 375
        Top = 453
        Width = 19
        Height = 24
        Associate = Edit6
        Min = 1
        Max = 10000
        Position = 1000
        TabOrder = 4
      end
      object NormPlotType: TRadioGroup
        Left = 482
        Top = 453
        Width = 228
        Height = 129
        Caption = 'Plot type'
        ItemIndex = 0
        Items.Strings = (
          'Frequency'
          'Cumulative Frequency'
          'Probability'
          'Cumulative Probability')
        TabOrder = 5
        OnClick = DrawchartN
      end
      object Memo3: TMemo
        Left = 20
        Top = 20
        Width = 464
        Height = 316
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'The "Normal" or Gaussian Distribution is  the most commonly '
          'used probability model  in economic and business modelling.  '
          'It'#39's density function is the famous (or infamous) Bell shaped '
          'curve which peaks at the mean of the distribution.  The width '
          'of the curve is determined by a measure of variablilty  called '
          'the Standard Deviation, often denoted and therefore named '
          'with the Greek letter "sigma".    (Standard deviation is the '
          'square root of the sum of the squares oft the deviations of the '
          'population samples from the mean, which proably won'#39't '
          'register unti, you compute a few by hand!)    '
          ''
          'In a normally distributed population, about 68% of the members '
          'fall within one sigma of the mean, 95%  fall within two sigma, '
          'and well over 99% within three sigma. ,  ')
        ParentFont = False
        TabOrder = 6
      end
      object Edit7: TEdit
        Left = 325
        Top = 502
        Width = 50
        Height = 24
        TabOrder = 7
        Text = '50'
      end
      object UpDown5: TUpDown
        Left = 375
        Top = 502
        Width = 19
        Height = 24
        Associate = Edit7
        Min = 1
        Max = 1000
        Position = 50
        TabOrder = 8
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Exponential'
      ImageIndex = 4
      object Label12: TLabel
        Left = 20
        Top = 453
        Width = 34
        Height = 16
        Caption = 'Mean'
      end
      object Label14: TLabel
        Left = 197
        Top = 453
        Width = 117
        Height = 16
        Caption = 'Number of samples'
      end
      object Label15: TLabel
        Left = 197
        Top = 502
        Width = 119
        Height = 41
        AutoSize = False
        Caption = 'Number of buckets in plot'
        WordWrap = True
      end
      object Memo5: TMemo
        Left = 20
        Top = 20
        Width = 483
        Height = 286
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'The Exxponential Distribution is a continuous distribuution rela' +
            'ted '
          
            'to the discrete Poisson distribution in the following manner.  I' +
            'f a '
          
            'discrete random variable has a Poisson Distribution, then he tim' +
            'e '
          '(or distance) between events is distributed Exponentially.'
          ''
          'The means are related by and inverse relationsship.  For '
          'example, if there are an average of 60 customers per hour at a '
          
            'facility, the mean time betweren arrivals is one minute (1/60 of' +
            ' an '
          'hour)'
          ''
          'Discrete simluation computer programs frequently use the '
          
            'exponential disttribution function to generate arrival patterns.' +
            '  ')
        ParentFont = False
        TabOrder = 0
      end
      object Edit9: TEdit
        Left = 108
        Top = 453
        Width = 51
        Height = 24
        TabOrder = 1
        Text = '1.25'
      end
      object Edit11: TEdit
        Left = 325
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 2
        Text = '1,000'
      end
      object UpDown6: TUpDown
        Left = 375
        Top = 453
        Width = 19
        Height = 24
        Associate = Edit11
        Min = 1
        Max = 10000
        Position = 1000
        TabOrder = 3
      end
      object Edit12: TEdit
        Left = 325
        Top = 502
        Width = 50
        Height = 24
        TabOrder = 4
        Text = '50'
      end
      object UpDown7: TUpDown
        Left = 375
        Top = 502
        Width = 19
        Height = 24
        Associate = Edit12
        Min = 1
        Max = 1000
        Position = 50
        TabOrder = 5
      end
      object ExpPlotType: TRadioGroup
        Left = 482
        Top = 453
        Width = 228
        Height = 129
        Caption = 'Plot type'
        ItemIndex = 0
        Items.Strings = (
          'Frequency'
          'Cumulative Frequency'
          'Probability'
          'Cumulative Probability')
        TabOrder = 6
        OnClick = DrawchartE
      end
      object GenEBtn: TButton
        Left = 20
        Top = 546
        Width = 92
        Height = 31
        Caption = 'Run a set'
        TabOrder = 7
        OnClick = GenEBtnClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Central Limit Theorem'
      ImageIndex = 5
      object Label1: TLabel
        Left = 20
        Top = 453
        Width = 74
        Height = 16
        Caption = 'Sample size'
      end
      object Label2: TLabel
        Left = 20
        Top = 492
        Width = 73
        Height = 16
        Caption = 'Nbr Buckets'
      end
      object Label3: TLabel
        Left = 246
        Top = 463
        Width = 93
        Height = 16
        Caption = 'Number of trials'
      end
      object Memo1: TMemo
        Left = 10
        Top = 10
        Width = 631
        Height = 415
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'The Central Limit theorem is one of the more amazing theorems in' +
            ' mathematics.'
          ''
          
            'The distribution of a random variable describes the way that the' +
            ' possible values'
          
            'of the variable are spread.   The Normal or Gaussian is one that' +
            ' occurs'
          
            'often in nature and appears as the familiar bell shaped curve - ' +
            'the values fall'
          
            'equally above and below the mean and most of the values lie near' +
            ' the mean.'
          ''
          
            'Other distributions inlclude uniform - each value equally likely' +
            ',  Poisson - values'
          'skewed toward the lower end, exponential, etc.'
          ''
          
            'The Central Limit Theorem says that if you take equal sized samp' +
            'les from any random '
          
            'distribution,sums (or means) of these samples will be normally d' +
            'istributed!'
          ''
          
            'We'#39'll illustrate that here sum summing groups of uniformly distr' +
            'ibuted random real '
          'numbers between 0 and 1. '
          ' '
          
            'The default values, samples summed in groups of 10 from a total ' +
            'population of 10,000 '
          
            'and charted in 50 intervals will illustate a reasonable approxim' +
            'ation of the normal '
          'distribution.'
          ''
          
            'As sample size decreased down towards 1, larger and larger sampl' +
            'e sizes are '
          
            'required to produce a smooth normal distribution curve.  At samp' +
            'le size 1 of course, '
          
            'the distribution reverts to unifor, no matter how large the popu' +
            'lation size.'
          '')
        ParentFont = False
        TabOrder = 0
      end
      object NbDieEdt: TEdit
        Left = 128
        Top = 453
        Width = 50
        Height = 24
        TabOrder = 1
        Text = '10'
      end
      object SidesEdt: TEdit
        Left = 128
        Top = 492
        Width = 50
        Height = 24
        TabOrder = 2
        Text = '50'
      end
      object TrialsEdt: TEdit
        Left = 364
        Top = 463
        Width = 51
        Height = 24
        TabOrder = 3
        Text = '10,000'
      end
      object GenCBtn: TButton
        Left = 20
        Top = 537
        Width = 92
        Height = 30
        Caption = 'Run a set'
        TabOrder = 4
        OnClick = GenCBtnClick
      end
      object NbrDieUD: TUpDown
        Left = 178
        Top = 453
        Width = 19
        Height = 24
        Associate = NbDieEdt
        Min = 1
        Position = 10
        TabOrder = 5
      end
      object SidesUD: TUpDown
        Left = 178
        Top = 492
        Width = 19
        Height = 24
        Associate = SidesEdt
        Min = 10
        Position = 50
        TabOrder = 6
      end
      object TrialsUD: TUpDown
        Left = 415
        Top = 463
        Width = 18
        Height = 24
        Associate = TrialsEdt
        Min = 1
        Max = 30000
        Position = 10000
        TabOrder = 7
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 636
    Width = 844
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSingle
    Caption = 'Copyright  '#169' 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    FileName = 'reactiondetail.rsd'
    Filter = 'Reaction detail (*.rsd)|*.rsd|All files (*.*)|*.*'
    Left = 568
    Top = 8
  end
end
