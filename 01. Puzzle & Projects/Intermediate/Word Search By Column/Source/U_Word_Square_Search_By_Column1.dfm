object Form1: TForm1
  Left = 196
  Top = 152
  Width = 1171
  Height = 642
  Caption = 'Square grid word search by column'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 23
  object Memo1: TMemo
    Left = 960
    Top = 16
    Width = 161
    Height = 497
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Solution '
      'word sets')
    ParentFont = False
    TabOrder = 0
  end
  object SearchBtn: TButton
    Left = 480
    Top = 424
    Width = 265
    Height = 25
    Caption = 'Search for solutions'
    Enabled = False
    TabOrder = 1
    OnClick = SearchBtnClick
  end
  object Memo2: TMemo
    Left = 768
    Top = 16
    Width = 185
    Height = 497
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Possible '
      'words')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object StringGrid1: TStringGrid
    Left = 496
    Top = 16
    Width = 249
    Height = 249
    DefaultColWidth = 48
    DefaultRowHeight = 48
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -33
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnDrawCell = StringGrid1DrawCell
  end
  object PossiblesBtn: TButton
    Left = 480
    Top = 368
    Width = 273
    Height = 25
    Caption = 'Find possible solution words'
    TabOrder = 4
    OnClick = PossiblesBtnClick
  end
  object Memo3: TMemo
    Left = 32
    Top = 16
    Width = 441
    Height = 513
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's an  interesting puzzle requiring the player'
      'to choose one letter fro each row in from top to '
      'bollom to form five 5-letter words. You may '
      'jump to any column to choose  he next letter in '
      'your word as you go down.  There is no need to '
      'rearrange the letters and every letter will be '
      'used exactly once. '
      ''
      'The clue for this puzzle from the Mensa'
      'Calendar is that all of the words describe items '
      'with stems.  '
      ''
      'The clue was not at all helpful for the'
      'programmed solution search presented here.   It'
      'does find two solutions, only one of which has'
      'all "stemmed" items.   There are 5x5x5x5x5 '
      '(3,125) ways  to select the letters but, of '
      'those,only 28 are words in our dictionary. The '
      'first button finds the 28 words.  The second '
      'button finds the 5-word subsets of these which '
      'cover all 25 letters - defined solution conditions.')
    ParentFont = False
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 582
    Width = 1163
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2017 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
