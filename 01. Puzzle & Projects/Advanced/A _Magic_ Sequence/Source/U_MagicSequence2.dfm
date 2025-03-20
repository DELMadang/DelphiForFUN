object Form1: TForm1
  Left = 168
  Top = 101
  Width = 800
  Height = 600
  Caption = 'Magic Sequence Generator'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 504
    Top = 16
    Width = 16
    Height = 24
    Caption = 'N'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TimeLbl: TLabel
    Left = 520
    Top = 376
    Width = 45
    Height = 13
    Caption = 'Run time:'
  end
  object Memo1: TMemo
    Left = 512
    Top = 240
    Width = 265
    Height = 113
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object SpinEdit1: TSpinEdit
    Left = 528
    Top = 16
    Width = 41
    Height = 22
    MaxValue = 20
    MinValue = 1
    TabOrder = 1
    Value = 5
  end
  object RadioGroup1: TRadioGroup
    Left = 504
    Top = 56
    Width = 273
    Height = 113
    Caption = 'Algortihms'
    ItemIndex = 0
    Items.Strings = (
      'Oiriginal method (length 7 only)'
      'Method 1 {Count in base N, checking each}'
      'Method 2 {Permute integer partitions + zeros}'
      'Method 3 {Insert integer partitions in all positions}  ')
    TabOrder = 2
  end
  object CalcBtn: TButton
    Left = 512
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 3
    OnClick = CalcBtnClick
  end
  object Memo2: TMemo
    Left = 16
    Top = 16
    Width = 473
    Height = 513
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'A viewer wrote asking about a program to generate "Magic Sequenc' +
        'es". A'
      
        'Magic Sequence of length N has the  property that each value in ' +
        'the series'
      
        'represents the number of times that its rank (position number) r' +
        'elative to zero,'
      
        'appears in the sequence.  If the elements are represented by X[i' +
        '],  0<=i<=N-1'
      'then X[i] = the number of occurrences of "i"  in the sequence.'
      ''
      
        'So for sequences of length 5, one example is [2,1,2,0,0], magic ' +
        'because x[0]'
      
        '= 2 and there are 2 zeroes in the sequence; X[1]=1 and there is ' +
        'only a single'
      
        '1 in the sequence; x[2]=2 and there are two "2"s,  X[3]=X[4]=0 a' +
        'nd there are'
      'no "3"s or "4"s.'
      ''
      
        'There does not seem to be much literature on sequences with this' +
        ' property'
      
        'and they appear to degenerate into a predictable pattern rather ' +
        'soon so are'
      
        'perhaps not so interesting from a mathematical standpoint but di' +
        'd make'
      'exercise for the brain and programming skills.'
      ''
      
        'In any event, the viewer sent code to find the sequence for N=7.' +
        '  I'
      
        'generalized the code to produce three additional ways to calcula' +
        'te'
      
        'sequences for a given N.  Each method is faster than the precedi' +
        'ng version.'
      ''
      
        'Method 1 simply counts in base N and checks each to see if it is' +
        ' "magic".'
      
        '[00001, 00002, 00003, 00004, 00010 ,..., 21200, ..., 44444, 4444' +
        '5] for N=5, for'
      'example.'
      ''
      
        'The next two methods take advantage of the fact that the sum of ' +
        'the non-zero'
      
        'elements of a sequence form an partition of N.  (Each value in t' +
        'he sequence'
      
        'represents the count of a particular value and there are N of  t' +
        'hese values'
      
        'altogether, so the sum must equal N.)  So we might as well start' +
        ' with the'
      'integer partitions of N.'
      ''
      
        'Method 2 generates integer partitions of N, checks that one of t' +
        'he values'
      'equals the number of zeros in the sequence  and then expands the'
      
        'sequence with zeros and permutes the last N-1 dgits looking for ' +
        'magic'
      'sequences.'
      ''
      
        'Method 3 improves on Method 2 permuting the potential position w' +
        'here the'
      'digits of each partition might appear in the sequence.'
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 784
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
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
