object Form1: TForm1
  Left = 227
  Top = 183
  Width = 998
  Height = 529
  Caption = 'Count Phrases '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 982
    Height = 469
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 400
      Width = 160
      Height = 16
      Caption = 'Delimiters separating words'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo1: TMemo
      Left = 9
      Top = 9
      Width = 473
      Height = 368
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        
          'This utility program was written to assist a developer investiga' +
          'ting "Search'
        
          'Engine Optimization", (SEO).  Without going into detail, counts ' +
          'of 2, 3, and 4 '
        
          'word phrases are apparently signficant in ranking search results' +
          '.'
        ''
        
          'There are nearly as many phrases of any given length as there ar' +
          'e words in '
        
          'any document since every word from the Nth word on forms a new N' +
          ' word '
        
          'phrase.  A large majority of these will not be useful in SEO stu' +
          'dies, but the '
        
          'program allows ignoring single occurrence phrases and sorting ph' +
          'rases in '
        'descending occurrence order.'
        ''
        
          'Click any of the "Show" buttons now to see the phrases in this i' +
          'ntroductory text.  '
        'Use the "Load" button to load any file of text for analysis.'
        ''
        
          'Here  is a repeat of the above paragraph just to guarantee some ' +
          'duplicate '
        
          'phrases for testing.  Click any of the "Show" buttons to see the' +
          ' phrases in this '
        
          'introductory text.  Use the "Load" button to load any file of te' +
          'xt for analysis.'
        ''
        
          'The default delimiters marking word separators are listed below.' +
          '  The list may '
        
          'be modified if necessary. Changes are retained across file loads' +
          ', but are not '
        
          'currently retained across program executions. Blanks were (and m' +
          'ay be)  '
        
          'inserted between delimiters for readability.  Blank is the only ' +
          'mandatory  '
        'delimiter.')
      ParentFont = False
      TabOrder = 0
      OnChange = Memo1Change
    end
    object ListBox1: TListBox
      Left = 705
      Top = 1
      Width = 257
      Height = 393
      ItemHeight = 13
      TabOrder = 1
    end
    object LoadBtn: TButton
      Left = 497
      Top = 273
      Width = 97
      Height = 25
      Caption = 'Load a text  file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = LoadBtnClick
    end
    object Show2Btn: TButton
      Left = 497
      Top = 129
      Width = 193
      Height = 25
      Caption = 'Show 2 word  phrase summary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = ShowPhraseList
    end
    object Show3Btn: TButton
      Left = 497
      Top = 169
      Width = 193
      Height = 25
      Caption = 'Show 3 word phrase summary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = ShowPhraseList
    end
    object Show4Btn: TButton
      Left = 497
      Top = 209
      Width = 193
      Height = 25
      Caption = 'Show 4 word phrase summary'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = ShowPhraseList
    end
    object CheckBox1: TCheckBox
      Left = 497
      Top = 97
      Width = 201
      Height = 17
      Caption = 'Show only counts > 1'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 6
    end
    object SortByGrp: TRadioGroup
      Left = 497
      Top = 25
      Width = 185
      Height = 57
      Caption = 'Sort order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Alpha'
        'Descending count')
      ParentFont = False
      TabOrder = 7
    end
    object DelimsEdt: TEdit
      Left = 32
      Top = 416
      Width = 433
      Height = 32
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = ' . , ? : - = { } [ ] ( ) > < ;'
      OnChange = DelimsEdtChange
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 469
    Width = 982
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = ' Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select text file to scan'
    Left = 456
    Top = 16
  end
end
