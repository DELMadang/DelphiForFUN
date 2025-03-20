object Form1: TForm1
  Left = 363
  Top = 140
  AutoScroll = False
  Caption = 'Alphabet Grid, Version 3.0'
  ClientHeight = 530
  ClientWidth = 865
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 508
    Width = 865
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 865
    Height = 508
    Align = alClient
    AutoSize = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 61
      Height = 18
      Caption = 'Columns'
    end
    object Label2: TLabel
      Left = 216
      Top = 16
      Width = 39
      Height = 18
      Caption = 'Rows'
    end
    object Panel2: TPanel
      Left = 364
      Top = 16
      Width = 477
      Height = 441
      TabOrder = 0
      object ListBox1: TListBox
        Left = 16
        Top = 310
        Width = 161
        Height = 123
        ItemHeight = 18
        TabOrder = 0
        OnClick = ListBox1Click
      end
      object Memo3: TMemo
        Left = 232
        Top = 312
        Width = 233
        Height = 113
        TabOrder = 1
      end
      object PageControl1: TPageControl
        Left = 8
        Top = 16
        Width = 449
        Height = 281
        ActivePage = TabSheet1
        TabOrder = 2
        object TabSheet1: TTabSheet
          Caption = 'Introduction   '
          object Memo2: TMemo
            Left = 0
            Top = 0
            Width = 441
            Height = 248
            Align = alClient
            Color = 14548991
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              
                'The initial puzzle is from the February 22, 2011 Mensa Page-A-Da' +
                'y '
              
                'calendar. The program was originally written to explore how to s' +
                'earch a '
              'grid for words formed from adjacent letters.'
              ''
              'When the "Search" button is clicked, the program does a depth-'
              
                'first search for words in our "Full.dic" dictionary containing a' +
                'bout 65,000'
              
                'words.  These words should provide additional help in finding wo' +
                'rds'
              
                'satisfying the given clues.  User play is not yet supported so y' +
                'ou will have '
              'to use Prnt Scrn or manually copy the grid to solve it.'
              ''
              
                'Click the "Current puzzle clues" tab above to view clues. A new ' +
                'puzzle'
              
                'may be defined by adjusting the size parameters, filling in the ' +
                'letter grid'
              
                'manually or by clicking the "Generate random" button,  and filli' +
                'ng in clues'
              
                'on the "Clues" page.  Clues will be saved and restored with the ' +
                'puzzle.')
            ParentFont = False
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Current puzzle clues'
          ImageIndex = 1
          object Memo1: TMemo
            Left = 0
            Top = 0
            Width = 441
            Height = 248
            Align = alClient
            Color = 12908717
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -16
            Font.Name = 'Arial'
            Font.Style = []
            Lines.Strings = (
              
                ' In th alphabet grid at left, move from letter to adjacent lette' +
                'r '
              
                '-- horizontally, vertically, or diagonally, but never repeating ' +
                'a '
              'letter within the same word -- to spell ou a five-letter word '
              'for each of the following clues.'
              ''
              '1. Judges perch'
              '2. Eatery'
              '3. Hard to please'
              '4. Impassive'
              '5. Ceiling support'
              '6. Cornerstone')
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
      end
    end
    object Grid: TStringGrid
      Left = 22
      Top = 48
      Width = 300
      Height = 300
      DefaultColWidth = 36
      DefaultRowHeight = 36
      DefaultDrawing = False
      FixedCols = 0
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 1
      OnDrawCell = GridDrawCell
      OnSelectCell = GridSelectCell
    end
    object SearchBtn: TButton
      Left = 28
      Top = 345
      Width = 285
      Height = 32
      Caption = 'Search for candidate words'
      TabOrder = 2
      OnClick = SearchBtnClick
    end
    object SaveBtn: TButton
      Left = 39
      Top = 464
      Width = 130
      Height = 32
      Caption = 'Save puzzle as...'
      TabOrder = 3
      OnClick = SaveBtnClick
    end
    object LoadBtn: TButton
      Left = 200
      Top = 464
      Width = 121
      Height = 32
      Caption = 'Load a puzzle...'
      TabOrder = 4
      OnClick = LoadBtnClick
    end
    object ColUD: TUpDown
      Left = 129
      Top = 12
      Width = 16
      Height = 26
      Associate = Edit1
      Min = 2
      Max = 10
      Position = 5
      TabOrder = 5
      OnChangingEx = ColUDChangingEx
    end
    object RowUD: TUpDown
      Left = 297
      Top = 12
      Width = 16
      Height = 26
      Associate = Edit2
      Min = 2
      Max = 10
      Position = 5
      TabOrder = 6
      OnChangingEx = RowUDChangingEx
    end
    object LabeledEdit3: TLabeledEdit
      Left = 29
      Top = 404
      Width = 44
      Height = 26
      EditLabel.Width = 90
      EditLabel.Height = 15
      EditLabel.Caption = 'Word size to find'
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clWindowText
      EditLabel.Font.Height = -12
      EditLabel.Font.Name = 'Arial'
      EditLabel.Font.Style = []
      EditLabel.ParentFont = False
      TabOrder = 7
      Text = '5'
    end
    object SizeUD: TUpDown
      Left = 73
      Top = 404
      Width = 24
      Height = 26
      Associate = LabeledEdit3
      Min = 2
      Max = 10
      Position = 5
      TabOrder = 8
      OnChangingEx = SizeUDChangingEx
    end
    object RevisitBox: TCheckBox
      Left = 28
      Top = 437
      Width = 309
      Height = 15
      Caption = 'If checked, letters may be revisited  within a word'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = RevisitBoxClick
    end
    object RandomBtn: TButton
      Left = 134
      Top = 401
      Width = 199
      Height = 22
      Caption = 'Generate a random puzzle'
      TabOrder = 10
      OnClick = RandomBtnClick
    end
    object Edit1: TEdit
      Left = 88
      Top = 12
      Width = 41
      Height = 26
      TabOrder = 11
      Text = '5'
    end
    object Edit2: TEdit
      Left = 256
      Top = 12
      Width = 41
      Height = 26
      TabOrder = 12
      Text = '5'
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text puzzle files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select or enter  name for Alphabet Grid puzzle file to save'
    Left = 832
    Top = 352
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text puzzle files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select Alphabet Grid puzzle file to load '
    Left = 840
    Top = 408
  end
end
