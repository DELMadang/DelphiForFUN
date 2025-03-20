object Form1: TForm1
  Left = 270
  Top = 129
  Width = 900
  Height = 600
  Caption = 'Coin Flip Run Lengths'
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
  object Label1: TLabel
    Left = 400
    Top = 16
    Width = 457
    Height = 41
    AutoSize = False
    Caption = 'Number of "Runs" of length N'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 624
    Top = 392
    Width = 146
    Height = 14
    Caption = 'Count runs of exactly length N'
  end
  object Label3: TLabel
    Left = 624
    Top = 448
    Width = 241
    Height = 57
    AutoSize = False
    Caption = 
      'Count runs of exactly length N when each experiment consists of ' +
      ' throwing N coins  "Nbr of trials" times and counting occurences' +
      ' of all Heads or all Tails '
    WordWrap = True
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 884
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 361
    Height = 497
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Natalie Angier in her book "The Canon" has a chapter '
      'about probabilities which describes an experiment '
      'conducted by a math professor with new classes.  Each '
      'student flips a coin 100 times and records the results '
      'with the instructor out of the room.  '
      ''
      'The hook is that half of the class actually flips a coin, the '
      'other half "flips" mentally,  i.e. just records what they '
      'imagine the results of the next flip might be.  The '
      'instructor returns to the room and sorts the results '
      'according to whether they represent real or imagined '
      'tosses.'
      ''
      'The trick works because most minds do not appreciate '
      'the occurrence of "runs", sequences of tosses with the '
      'same result.  Almost every set of 100 tosses will have '
      'have one or more sets of 5 or more Heads or Tails in a '
      'row. (The expected number of such strings is slightly'
      'more than 3.0.)  Very few of the human-imagined results'
      'will have even one such string.This program verifies the'
      'result by mathematically flipping coins and comparing'
      'experimental with expected reults for a range of "same'
      'result" string lengths.'
      ''
      'Two buttons represent alternative experimental '
      'techniques. '
      ''
      'Button1 simulates the experiment described above,'
      'throw 100 coins per trial.for the number of trials specified'
      'and record number of runs of length N.'
      ''
      'The 2nd button reports runs of length N per 100 trials if'
      'only N are thrown at a time.   Until you think about it, it'#39's'
      'surprising that the second method produces results 4'
      'times larger than method 1.  This is because when'
      'throwing N coins per trial and counting runs of length N,'
      'the preceding and following coins do not matter.  If we'
      'throw 100 coins looking for runs of length N, the coins'
      'preceding and following a "success" must show the'
      'opposite side.  So runs of length 3 Heads require a "run"'
      'of length 5 with value THHHT which have a probability of'
      '1/32 compared to 1/8 for HHH results when only 3'
      'coins are thrown.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ThrowNBtn: TButton
    Left = 624
    Top = 512
    Width = 241
    Height = 25
    Caption = '2. Throw N per trial for a range of N'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = ThrowNBtnClick
  end
  object StringGrid1: TStringGrid
    Left = 400
    Top = 64
    Width = 460
    Height = 321
    ColCount = 7
    RowCount = 12
    FixedRows = 2
    TabOrder = 3
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object ThrowAllBtn: TButton
    Left = 624
    Top = 408
    Width = 241
    Height = 25
    Caption = '1. Throw 100 coins per trial'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ThrowAllBtnClick
  end
  object RadioGroup1: TRadioGroup
    Left = 400
    Top = 392
    Width = 185
    Height = 105
    Caption = 'Number of trials in each experiment'
    Columns = 2
    ItemIndex = 2
    Items.Strings = (
      '1'
      '10'
      '100'
      '1,000'
      '10,000'
      '100,000')
    TabOrder = 5
    OnClick = RadioGroup1Click
  end
end
