object Form1: TForm1
  Left = 403
  Top = 192
  Width = 1114
  Height = 745
  Caption = 'Euler'#39's "Sum of Powers" Conjecture'
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
    Top = 677
    Width = 1096
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1096
    Height = 677
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 616
      Top = 32
      Width = 152
      Height = 23
      Caption = 'Power to test (N)'
    end
    object Label3: TLabel
      Left = 872
      Top = 32
      Width = 110
      Height = 23
      Caption = 'Nbr of terms'
    end
    object Label4: TLabel
      Left = 801
      Top = 408
      Width = 146
      Height = 23
      Caption = 'Search progress'
    end
    object Label2: TLabel
      Left = 616
      Top = 304
      Width = 128
      Height = 23
      Caption = 'Max Solutions:'
    end
    object StopBtn: TButton
      Left = 832
      Top = 360
      Width = 86
      Height = 25
      Caption = 'Stop'
      TabOrder = 7
      OnClick = StopBtnClick
    end
    object Memo5: TMemo
      Left = 24
      Top = 21
      Width = 561
      Height = 300
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'In the 18th century, mathematician Leonhard Euler conjectured'
        
          'that if the sum of the kth powers of two or more  positive integ' +
          'ers is'
        
          'itself the kth power of a positive integer, then the number of t' +
          'erms'
        
          'must be at least k.  For example, the sum of 2 cubes can not be ' +
          'a'
        'cube, the sum of two or three 4th powers cannont be a 4th power'
        'etc.'
        ''
        
          'It turns out that the conjecture is not true.  There exists thre' +
          'e 4th powers'
        'which sum to a 4th power and four 5th powers which sum to a 5th'
        
          'power!  This program will find the smallest counterexample of th' +
          'e 5th'
        
          'power case in a couple of minutes using direct search with the i' +
          'nitial'
        'program defaults. The 4th'
        
          'power counterexample has values too large to be found by this me' +
          'thod.'
        
          'The jury is still out on whether the conjecture is true for 6th ' +
          'and higher'
        'powers since no counterexamples have been found.'
        ''
        'The current program can find many examples of two or more'
        'squared terms which sum to a square (These are the "Pythagorean'
        
          'Triples" you learned about in high school.)  Euler'#39's Conjecture ' +
          'is an'
        
          'extension of "Fermat'#39's Last Theorem" which says that there are n' +
          'o'
        
          'solutions to a^n+b^n=c^n for any n>2.  I believe that it has als' +
          'o been'
        
          'proven that there are no two cubes which sum to a cube but we ca' +
          'n'
        'quickly generate many examples with 3 cubes summing to a cube.'
        'Run time problems begin with the higher powers even'
        
          'though the program checks several million terms per second.  The' +
          ' first '
        'four term'
        '4th power sum is found in 140 seconds and the first'
        'five term 5th power sum takes 1240 seconds (5.5 billion terms'
        
          'checked!).  The next program version will try to confirm the 4th' +
          ' term'
        
          'counterexample by incorporating the more efficient Lander-Parkin' +
          ' '
        'Algorithm described in a'
        'paper at'
        'http://www.ams.org/journals/mcom/1967-21-097/S0025-5718-1967-'
        '0220669-3/S0025-5718-1967-0220669-3.pdf'
        '}')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object GoBtn: TButton
      Left = 831
      Top = 359
      Width = 86
      Height = 28
      Caption = 'Go!'
      TabOrder = 1
      OnClick = GoBtnClick
    end
    object PowerEdt: TSpinEdit
      Left = 616
      Top = 56
      Width = 65
      Height = 34
      MaxValue = 10
      MinValue = 1
      TabOrder = 2
      Value = 5
    end
    object MaxNGrp: TRadioGroup
      Left = 872
      Top = 112
      Width = 201
      Height = 113
      Caption = 'Upper term limit'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        '10'
        '100'
        '250'
        '500'
        '1,000')
      TabOrder = 3
    end
    object NbrtermsEdt: TSpinEdit
      Left = 872
      Top = 56
      Width = 65
      Height = 34
      MaxValue = 10
      MinValue = 2
      TabOrder = 4
      Value = 4
    end
    object Memo1: TMemo
      Left = 24
      Top = 360
      Width = 753
      Height = 305
      Lines.Strings = (
        'Solutions:')
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object MinNGrp: TRadioGroup
      Left = 608
      Top = 112
      Width = 193
      Height = 113
      Caption = 'Lower term limit'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        '1'
        '10'
        '100'
        '250'
        '500')
      TabOrder = 6
    end
    object AllowDupsBox: TCheckBox
      Left = 616
      Top = 240
      Width = 217
      Height = 17
      Caption = 'Allow duplicate terms'
      TabOrder = 8
    end
    object MaxSolutionsEdt: TEdit
      Left = 752
      Top = 304
      Width = 57
      Height = 31
      TabOrder = 9
      Text = '100'
    end
    object HideDupsBox: TCheckBox
      Left = 616
      Top = 264
      Width = 441
      Height = 33
      Hint = '(GCD = Greatest Common Denominator)'
      Caption = 'Hide multiples of solutions (GCD of roots>1)'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 10
      WordWrap = True
    end
  end
end
