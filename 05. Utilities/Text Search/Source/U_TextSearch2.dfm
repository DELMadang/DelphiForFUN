object Form1: TForm1
  Left = 225
  Top = 153
  Width = 1108
  Height = 738
  Anchors = [akLeft, akTop, akRight]
  Caption = 'Text Search Version 2.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object InFileLbl: TLabel
    Left = 208
    Top = 208
    Width = 321
    Height = 49
    AutoSize = False
    Caption = 'No file selected'
    WordWrap = True
  end
  object Button1: TButton
    Left = 23
    Top = 210
    Width = 170
    Height = 31
    Caption = '1. Select a file to search'
    TabOrder = 0
    OnClick = Button1Click
  end
  object GoBtn: TButton
    Left = 383
    Top = 602
    Width = 93
    Height = 31
    Caption = '5. Go'
    TabOrder = 1
    OnClick = GoBtnClick
  end
  object Memo1: TMemo
    Left = 10
    Top = 6
    Width = 479
    Height = 195
    Color = 14548991
    Lines.Strings = (
      'A  text search program with output options .'
      ''
      '1. Select a file to search'
      '2. Speciify a search string with conditions'
      '3. Decide parts of matched lines to keep.'
      
        '4. Decide whether to output matches, non-matches, (or both) and ' +
        '  '
      
        '   whether to display output on screen  write to a file, (or bot' +
        'h).   Note: '
      '   "Write to file" option wil get file name from user.'
      '.'
      '5. Click "Go" button '
      '')
    TabOrder = 2
  end
  object RichEdit1: TRichEdit
    Left = 512
    Top = 8
    Width = 561
    Height = 489
    Lines.Strings = (
      'Search outputs')
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WantReturns = False
    WordWrap = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 671
    Width = 1090
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2004, 2014  Gary Darby,  www.DelphiForFun.org'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 256
    Width = 473
    Height = 89
    Caption = '2. Search string setup'
    TabOrder = 5
    object Label1: TLabel
      Left = 31
      Top = 25
      Width = 84
      Height = 16
      Caption = 'Search string'
    end
    object WholeWords: TCheckBox
      Left = 31
      Top = 52
      Width = 162
      Height = 21
      Caption = 'Whole words only'
      TabOrder = 0
    end
    object CaseSensitive: TCheckBox
      Left = 239
      Top = 52
      Width = 179
      Height = 21
      Caption = 'Case sensitive '
      TabOrder = 1
    end
    object SearchString: TEdit
      Left = 125
      Top = 25
      Width = 276
      Height = 24
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 24
    Top = 360
    Width = 265
    Height = 105
    Caption = '3. Processing when string is found'
    TabOrder = 6
    object LeftBox: TCheckBox
      Left = 7
      Top = 20
      Width = 199
      Height = 21
      Caption = 'Keep text preceeding string'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object StringBox: TCheckBox
      Left = 7
      Top = 44
      Width = 179
      Height = 21
      Caption = 'Keep the string'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object RightBox: TCheckBox
      Left = 7
      Top = 68
      Width = 226
      Height = 21
      Caption = 'Keep text following  string '
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object GroupBox3: TGroupBox
    Left = 24
    Top = 480
    Width = 465
    Height = 105
    Caption = '4. Output actions'
    TabOrder = 7
    object OutputNonMatchedBox: TCheckBox
      Left = 7
      Top = 20
      Width = 218
      Height = 21
      Caption = 'Output non-matched records'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object OutputMatchedBox: TCheckBox
      Left = 7
      Top = 52
      Width = 202
      Height = 21
      Caption = 'Output matched parts'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
    object ShowLinesBox: TCheckBox
      Left = 231
      Top = 20
      Width = 162
      Height = 21
      Caption = 'Display outputs'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object SaveLinesBox: TCheckBox
      Left = 224
      Top = 52
      Width = 177
      Height = 25
      Caption = 'Write outputs to a file...'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object Memo2: TMemo
    Left = 312
    Top = 368
    Width = 185
    Height = 97
    Lines.Strings = (
      'Note: If the string occurs '
      'more than once in a single '
      'record, processing options '
      'are based on first  string '
      'match.')
    TabOrder = 8
  end
  object Memo3: TMemo
    Left = 512
    Top = 512
    Width = 561
    Height = 145
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16512
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Search statistics')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 9
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|Any file  (*.*)|*.*'
    Options = [ofEnableSizing]
    Title = 'Select an input file'
    Left = 968
    Top = 504
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select  or enter output filename'
    Left = 1032
    Top = 496
  end
end
