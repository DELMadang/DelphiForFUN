object Form1: TForm1
  Left = 456
  Top = 257
  Width = 1084
  Height = 745
  Caption = 'Knuth'#39's "Toy" Problem  V1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 677
    Width = 1066
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
    Width = 1065
    Height = 673
    TabOrder = 1
    object Label1: TLabel
      Left = 872
      Top = 32
      Width = 153
      Height = 23
      Caption = 'Power (N=2...15)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 40
      Top = 424
      Width = 83
      Height = 23
      Caption = 'Run time:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo5: TMemo
      Left = 32
      Top = 16
      Width = 817
      Height = 401
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Knuth'#39's "Toy Problem" (From an article "Are Toy Problems Useful?' +
          '" by Donald Knuth, published in 1977 in '
        
          '"Popular Computing")  " Find integers whose sum of the given pow' +
          'er, N, of its digits equals the number. "  '
        
          'For example: if N=3, one solution is 370 = 3^3 + 7^3 + 0^3 = 27 ' +
          '+ 343 + 0 = 370.  Donald Knuth made the '
        
          'point that "useless" problems can be useful in developing proble' +
          'm solving skills.  It was true in this case for '
        
          'me, The Buttons at right demostrate 3  of the 5 methods develope' +
          'd (2 were complete flops).'
        ''
        
          'Button 1 tests all permutations with repeats for N digit integer' +
          's. We'#39'll call this "Brute Force 1"and it works '
        
          'well up  to about N=8 (sum of 8th powers of digits equal to the ' +
          'number being tested).   Button 1 checks only '
        'N digit numbers.'
        ''
        
          'Button 2 tried a second way to generate all permutations with re' +
          'peats, simply check all numbers from the '
        
          'starting point up to some limit.  All of Knuth'#39's examples showed' +
          ' N digit solutions for a given exponent.  I '
        
          'spent several hours without success trying to prove that this wa' +
          's always true.   Button 2 reveals that in fact '
        
          'there is at least one case where it is not so. Button 2 checks n' +
          'umbers with N-1 to N+1 digits.'
        ''
        
          'Button 3 is the best solution so far.  It solves the N=10 case l' +
          'ess than 2 seconds compared to 30 minutes '
        
          'for Button 1 and about 2 hours for Button 2.  I will leave the d' +
          'escription to be revealed in a separate form in '
        
          'case you would like to work on the puzzle yourself. Like Button ' +
          '2, Button 3 checks numbers with N-1 to N+1 '
        'digits.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Button1: TButton
      Left = 887
      Top = 103
      Width = 86
      Height = 28
      Caption = 'Button1'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Memo1: TMemo
      Left = 40
      Top = 456
      Width = 793
      Height = 201
      Lines.Strings = (
        ' ')
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object SpinEdit1: TSpinEdit
      Left = 896
      Top = 56
      Width = 49
      Height = 26
      MaxValue = 15
      MinValue = 2
      TabOrder = 3
      Value = 2
    end
    object Button2: TButton
      Left = 887
      Top = 143
      Width = 86
      Height = 28
      Caption = 'Button2'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 888
      Top = 184
      Width = 89
      Height = 25
      Caption = 'Button3'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Stopbtn: TButton
      Left = 944
      Top = 408
      Width = 113
      Height = 137
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Visible = False
      OnClick = StopbtnClick
    end
    object View3Btn: TButton
      Left = 888
      Top = 232
      Width = 105
      Height = 65
      Caption = 'Explain  "Button 3" Method'
      TabOrder = 7
      Visible = False
      WordWrap = True
      OnClick = View3BtnClick
    end
  end
end
