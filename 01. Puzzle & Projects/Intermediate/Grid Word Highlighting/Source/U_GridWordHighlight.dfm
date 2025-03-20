object Form1: TForm1
  Left = 507
  Top = 263
  Width = 1278
  Height = 768
  Caption = 'Highlight specified word in a grid cell (version 1.1)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 708
    Width = 1270
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1270
    Height = 708
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 664
      Top = 16
      Width = 342
      Height = 46
      Caption = 
        'Master phrase list (Text below may be edited for additional test' +
        'ing)'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 672
      Top = 400
      Width = 281
      Height = 73
      AutoSize = False
      Caption = 
        'Highlight (Enter word and click or press Enter key to highlight ' +
        'in grid)'
      WordWrap = True
    end
    object Memo1: TMemo
      Left = 16
      Top = 24
      Width = 601
      Height = 633
      Color = 15400959
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'A fellow Delphian recently asked if it was possible to highlight' +
          ' a particular '
        
          'word in a DBGrid. I gave him some suggestions but didn'#39't hear, b' +
          'ack so I '
        'decided to try it for myself.'
        ''
        
          'I used a StringGrid for this demo. The relevant feature exists i' +
          'n both -  the '
        
          'ability to control the drawing of each cell.  I have provided a ' +
          'sample '
        
          'phrase list from which grid cells are randomly selected. There'#39's' +
          ' also an '
        
          'edit box for entry of  the word or phrase to highlight. This all' +
          'ows testing '
        
          'the word to highlight in various locations, capitalization, deli' +
          'miters, etc. '
        
          'Buttons to save and load new Master phrase lists and a "Refill G' +
          'rid" '
        
          'button will load a new set of randomly selected phrases to the g' +
          'rid.'
        ''
        
          'Highlight formatting choices can change the length of the text d' +
          'isplay, e.g. '
        
          'font size or style. For demonstration purposes, I chose font col' +
          'or of Red '
        
          'with Bold style for the highlighted text.  Column width is autom' +
          'atically '
        'increased if the displayed text exceeds the current width.'
        ''
        
          'Additional options such as highlight text embedded in other word' +
          's, '
        
          'highlighting multiple occurrences within a phrase,  or requiring' +
          ' case '
        
          'matching were not implemented but could be.   As a cell is drawn' +
          ' we look '
        
          'for the "highlight  word" within the cell without worrying about' +
          ' case '
        
          'matching or word delimiters. When a match is found, then we test' +
          ' that the '
        
          'text is surrounded by delimiters. This allows single words or ph' +
          'rases with '
        
          'other embedded delimiters to be entered into the Highlight text ' +
          'box for '
        'highlighting.'
        ''
        
          'March 2018:  Version 1.1 removes a routine (Grid1SetEditText) th' +
          'at was '
        
          'unneeded and kept the program from running with TDBGrid.  The ro' +
          'utine '
        
          'was a "OnSetEditText"  event exit which is not available in the ' +
          'TDBGrid '
        
          'control.  Its purpose wast to ensure that column widths were adj' +
          'usted if '
        
          'necessary after highlighting. That is now done at the time that ' +
          'the '
        
          'highlighted text is generated.   The program should now handle b' +
          'oth '
        'DBGrids and StringGrids without major changes to the demo.'
        '')
      ParentFont = False
      TabOrder = 0
    end
    object Grid1: TStringGrid
      Left = 664
      Top = 488
      Width = 561
      Height = 201
      ColCount = 2
      DefaultRowHeight = 30
      DefaultDrawing = False
      FixedCols = 0
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
      ParentFont = False
      ScrollBars = ssHorizontal
      TabOrder = 1
      OnDrawCell = Grid1DrawCell
    end
    object FillWordsMemo: TMemo
      Left = 672
      Top = 80
      Width = 385
      Height = 257
      Lines.Strings = (
        'Blue ice'
        'Ice cream'
        'Icecream'
        'Banana blueberry split'
        'Very ripe banana'
        'Whipped cream?'
        'Yes! '
        'No icecream today'
        'Today I'#39'm very blue.'
        'Yes! no!, yes!, no? no! '
        'Blueberry icecream'
        'Best pie is blueberry'
        'blueberry is very blue ')
      ScrollBars = ssBoth
      TabOrder = 2
      WordWrap = False
      OnChange = FillWordsMemoChange
    end
    object RefillBtn: TButton
      Left = 672
      Top = 344
      Width = 281
      Height = 33
      Caption = 'Random grid refill'
      TabOrder = 3
      OnClick = RefillBtnClick
    end
    object LoadBtn: TButton
      Left = 1064
      Top = 88
      Width = 161
      Height = 25
      Caption = 'Load phrase list'
      TabOrder = 4
      OnClick = LoadBtnClick
    end
    object SaveBtn: TButton
      Left = 1064
      Top = 136
      Width = 161
      Height = 25
      Caption = 'Save phrase list'
      TabOrder = 5
      OnClick = SaveBtnClick
    end
    object FillWordEdt: TEdit
      Left = 960
      Top = 416
      Width = 121
      Height = 31
      TabOrder = 6
      Text = 'Blueberry'
      OnClick = FillWordEdtClick
      OnKeyPress = FillWordEdtKeyPress
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*,*)|*.*'
    Title = 'Load Plrase list'
    Left = 1072
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Save Phrase list'
    Left = 1176
    Top = 32
  end
end
