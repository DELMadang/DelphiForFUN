object Form1: TForm1
  Left = 192
  Top = 114
  Width = 870
  Height = 640
  Caption = '"Ones" Puzzles'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 432
    Top = 280
    Width = 130
    Height = 23
    Caption = 'how many contain '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 432
    Top = 248
    Width = 161
    Height = 23
    Caption = 'In numbers which are '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 432
    Top = 312
    Width = 180
    Height = 23
    Caption = 'occurrences of the digit '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 672
    Top = 312
    Width = 9
    Height = 23
    Caption = '?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 648
    Top = 248
    Width = 84
    Height = 23
    Caption = 'digits long, '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 432
    Top = 104
    Width = 215
    Height = 23
    Caption = 'how many times does the digit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 432
    Top = 72
    Width = 161
    Height = 23
    Caption = 'In numbers which are '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 696
    Top = 104
    Width = 49
    Height = 23
    Caption = 'occur?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 648
    Top = 72
    Width = 84
    Height = 23
    Caption = 'digits long, '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 432
    Top = 44
    Width = 305
    Height = 19
    Caption = 'Puzzle 1 - # of 1s in odometer numbers?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label11: TLabel
    Left = 432
    Top = 216
    Width = 327
    Height = 19
    Caption = 'Puzzle 2 - How many numbers with no 1s? '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 584
    Width = 854
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
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
    Top = 24
    Width = 361
    Height = 473
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Car Talk, my favorite National Public Radio program, has a '
      'weekly puzzler, mostly automotive or logic/mathematical. in '
      'nature.'
      ''
      'The latter do not require a computer program to solve but are '
      'usually quite easy to code for exhaustive search solutions.  '
      'Below are two variations of recent (June, 2009) puzzlers.  '
      'Generalized solution searches are implemented here.:'
      ''
      '')
    ParentFont = False
    TabOrder = 1
  end
  object Puzzle2Btn: TButton
    Left = 440
    Top = 440
    Width = 321
    Height = 25
    Caption = 'Search'
    TabOrder = 2
    OnClick = Puzzle2BtnClick
  end
  object Intlength: TSpinEdit
    Left = 600
    Top = 240
    Width = 41
    Height = 26
    MaxValue = 8
    MinValue = 1
    TabOrder = 3
    Value = 6
  end
  object Digit2: TSpinEdit
    Left = 616
    Top = 320
    Width = 41
    Height = 26
    MaxValue = 9
    MinValue = 1
    TabOrder = 4
    Value = 1
  end
  object IntNbr: TSpinEdit
    Left = 648
    Top = 280
    Width = 41
    Height = 26
    MaxValue = 9
    MinValue = 0
    TabOrder = 5
    Value = 0
  end
  object AtLeasrRBtn: TRadioButton
    Left = 568
    Top = 276
    Width = 81
    Height = 17
    Caption = 'at least'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
  end
  object ExactRBtn: TRadioButton
    Left = 568
    Top = 292
    Width = 81
    Height = 17
    Caption = 'exactly'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    TabStop = True
  end
  object Puzzle1Btn: TButton
    Left = 432
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 8
    OnClick = Puzzle1BtnClick
  end
  object IntLength1: TSpinEdit
    Left = 600
    Top = 72
    Width = 41
    Height = 26
    MaxValue = 8
    MinValue = 1
    TabOrder = 9
    Value = 6
  end
  object Digit1: TSpinEdit
    Left = 648
    Top = 104
    Width = 41
    Height = 26
    MaxValue = 9
    MinValue = 1
    TabOrder = 10
    Value = 1
  end
  object Memo2: TMemo
    Left = 40
    Top = 168
    Width = 329
    Height = 321
    BorderStyle = bsNone
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'RAY:  This is from my higher mathematics series and '
      'it'#39's a twist on a puzzler I gave some months ago. The '
      'idea for this puzzler was sent in by Tim Davis. '
      ''
      'He writes: '
      ''
      '"How many times does the mileage on an odometer not '
      'contain the number 1 at all?"'
      ''
      'For example 999,999 doesn'#39't have it. So the question '
      'is, how many times does the mileage appear going from '
      '000000 to all 9'#39's (999,999), with no 1s at all?'
      ''
      'To refresh your memories, we had a puzzler last Fall '
      'asking how many times the number 1 will appear on the '
      'odometer that goes from all zeroes, 000000, to all '
      'nines, 999999, once it completely turns over. For '
      'example at mile 000111, the number 1 appears three '
      'times.  '
      ''
      '')
    ParentFont = False
    TabOrder = 11
  end
  object TimingGrp: TRadioGroup
    Left = 440
    Top = 352
    Width = 321
    Height = 73
    Caption = 'Timing Tests'
    ItemIndex = 0
    Items.Strings = (
      'Use convert to string and count digits method'
      'Use " Mod" and "Div" loop method ')
    TabOrder = 12
  end
end
