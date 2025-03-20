object Form1: TForm1
  Left = 818
  Top = 120
  Width = 881
  Height = 557
  Caption = 'Chinese Remainders'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Answerlbl: TLabel
    Left = 498
    Top = 400
    Width = 5
    Height = 24
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
  end
  object mensamemo3: TMemo
    Left = 32
    Top = 48
    Width = 425
    Height = 265
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Christine has a number of flowers that she wants to put '
      'into arrangements.'
      ''
      'If she puts them in groups of 2 she has 1 left over.'
      'If she puts them in groups of 3 she has 2 left over.'
      'If she puts them in groups of 4 she has 3 left over.'
      'If she puts them in groups of 5 she has 4 left over.'
      'If she puts them in groups of 6 she has 5 left over.'
      'If she puts them in groups of 7 she has 0 left over.'
      ''
      'What is the smallest number opf flowers that Christina '
      'could have?')
    ParentFont = False
    TabOrder = 8
    Visible = False
  end
  object Memo4th: TMemo
    Left = 30
    Top = 49
    Width = 336
    Height = 189
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '"We have a number of things, but we do not '
      'know exactly how many. If we count them '
      'by threes we have two left over. If we count '
      'them by fives we have three left over. If we '
      'count them by sevens we have two left over. '
      'How many things are there?" '
      ''
      '(Quoted from Sun Tze Suan Ching).')
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
  object Mensamemo: TMemo
    Left = 30
    Top = 49
    Width = 336
    Height = 110
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serarialif'
    Font.Style = []
    Lines.Strings = (
      'Find a number which, when divided by  6, '
      'leaves a remainder of 5, when divided by 5 '
      'leaves a remanider of 4, and when divided '
      'by 4 has a remaninder of 3.')
    ParentFont = False
    TabOrder = 6
    Visible = False
  end
  object Memo7th: TMemo
    Left = 30
    Top = 49
    Width = 336
    Height = 307
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'An old woman goes to market and a horse '
      'steps on her basket and crushes the eggs. '
      'The rider offers to pay for the damages and '
      'asks her how many eggs she had brought. '
      ''
      'She does not remember the exact number, '
      'but when she had taken them out two at a '
      'time,  there was one egg left. The same '
      'happened when she  picked them out three, '
      'four, five, and six at a time, but  when she '
      'took them seven at a time they came out '
      'even.'
      ''
      'What is the smallest number of eggs she '
      'could have had?')
    ParentFont = False
    TabOrder = 5
    Visible = False
  end
  object StringGrid1: TStringGrid
    Left = 486
    Top = 10
    Width = 217
    Height = 346
    ColCount = 2
    FixedCols = 0
    RowCount = 11
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    OnKeyDown = StringGrid1KeyDown
    OnSetEditText = StringGrid1SetEditText
    ColWidths = (
      104
      104)
  end
  object SolveBtn: TButton
    Left = 730
    Top = 325
    Width = 92
    Height = 31
    Caption = 'Solve it'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object SelectionBox: TComboBox
    Left = 30
    Top = 10
    Width = 326
    Height = 24
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 3
    OnChange = SelectionBoxChange
    Items.Strings = (
      'Sample puzzles'
      'Introduction'
      'Chinese (Author: Sun Zi) 4th century'
      'Indian (Author: Brahmagupta) 7th century'
      'Mensa Puzzle Calendar for October 18, 2001'
      'Mensa Puzzle Calendar for August 6, 2003 '
      'Mensa Puzzle Calendar for November 3, 2010')
  end
  object MensaMemo2: TMemo
    Left = 30
    Top = 49
    Width = 336
    Height = 200
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Jim was arranging his identically sized '
      'stamps '
      'on a page. When he put 8 to a page, he '
      'had 1 left over; with 9 to a page, he had 4 '
      'left over; with 10 to a page, he had 1 left '
      'over; and with 12 to a page, he had 1 left '
      'over.'
      ''
      'What is the smallest numberthat will allow '
      'him to fill each page with the same number '
      'of stamps?')
    ParentFont = False
    TabOrder = 7
    Visible = False
  end
  object Intromemo: TMemo
    Left = 30
    Top = 49
    Width = 427
    Height = 424
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Problems which specify remainders when an unknown '
      'number is divided by a given set of numbers are called '
      '"Chinese Remainder" problems.'
      ''
      'The Chinese Remainder theorem proves that if each pair '
      'of divisors are relatively prime (i.e. have no common '
      'divisors) , then there is a unique smallest solution.  The '
      'Chinese reference stems from the earliest known '
      'example of such problems published in the text "Sun Tze '
      'Suan Ching" around the 4th century.'
      ''
      'In this program, we solve such problems by trial and '
      'error, i.e. we'#39'll just try numbers until we find one that '
      'satisfies the given conditions or we have tried all integers '
      'up to 10,000,000.'
      ''
      'You can select a problem from the drop down "Sample '
      'problems" list, or enter your own.  Insert (Ins) and '
      'Delete (Del) keys may be used to add or delete rows '
      'from the grid.'
      '')
    ParentFont = False
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 485
    Width = 863
    Height = 27
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 9
    OnClick = StaticText1Click
  end
end
