object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Obfuscate Text   (e.g. Email Addresses and Passwords)'
  ClientHeight = 643
  ClientWidth = 1141
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
  object Label2: TLabel
    Left = 512
    Top = 376
    Width = 130
    Height = 16
    Caption = 'Initial word delimiters'
  end
  object Label4: TLabel
    Left = 800
    Top = 72
    Width = 130
    Height = 16
    Caption = 'Initial word delimiters'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 1141
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1141
    Height = 620
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 504
      Top = 31
      Width = 118
      Height = 19
      Caption = 'Words start with'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 504
      Top = 80
      Width = 119
      Height = 19
      Caption = 'Words end with '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 504
      Top = 128
      Width = 107
      Height = 19
      Caption = 'Word contains'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ProcessBtn: TButton
      Left = 508
      Top = 443
      Width = 213
      Height = 29
      Caption = 'Process file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ProcessBtnClick
    end
    object Memo1: TMemo
      Left = 17
      Top = 16
      Width = 464
      Height = 417
      Color = 13172735
      Lines.Strings = (
        
          'I recently needed to send a plain text mailing list log file con' +
          'taining'
        'several hundred subscriber'#39's email addresses and wrote this'
        
          'program to "obfuscate" the addresses.  "Obfuscate", from the Lat' +
          'in:'
        
          '"to darken", has come to mean "to hide" or "to make confusing". ' +
          ' I'
        'decided to generalize the program a bit to expand its potential'
        'usefulness in the future.'
        ''
        
          'The run options at right should be clear.  The sample cases belo' +
          'w'
        'set the options for three approaches to changing or hiding the'
        'original data.  To help understand the  parameters, here are the'
        
          'settings for these three cases. Note that since the space charac' +
          'ter '
        
          'is invisible, its inclusion  as a delimiter is specified separat' +
          'ely.'
        ''
        '1. Replace name part of email addresses with random word. (These'
        'are the settings used to solve my original problem.)'
        ''
        '  -Initial word delimiters: <(,: Space is a word start delimiter'
        '  -Final word delimiter: @    Space is NOT a word end delimiter'
        '  -No "Word must contain" string specified'
        
          '  -Obfuscate the qualifying word  (the name part of email addres' +
          's)'
        '  -Replace word with random lower case word'
        ''
        '2. Replace entire email addresses with "Email address removed"'
        ''
        '  -Initial word delimiters: <(,: Space is a word start delimiter'
        '  -Final word delimiter: <(,:   Space is a word end delimiter'
        '  -Word must contain the @ character'
        '  -Obfuscate the qualifying word  (the entire email address)'
        '  -Replace word with the phrase "Email address removed"'
        ''
        
          '3. Replace Passwords with ********** (Find the word "Password:" ' +
          'and '
        'replace the following word with asterisks.)'
        ''
        '  -Initial word delimiters: <(,: Space is a word start delimiter'
        '  -Final word delimiters: <(,:   Space is a word end delimiter'
        '  -Word must contain  the string "Password:"'
        '  -Obfuscate the word following "Password:"'
        '  -Replace word with string "******"')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object InitDelimEdt: TEdit
      Left = 632
      Top = 25
      Width = 113
      Height = 31
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '<(,:'
    end
    object ReplaceTypeGrp: TRadioGroup
      Left = 504
      Top = 256
      Width = 561
      Height = 169
      Caption = 'Replace word with'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Random word (lower case letters)'
        'Random word (upper case letters)'
        'Word length string of character '
        'Constant word')
      ParentFont = False
      TabOrder = 3
    end
    object ReplaceCharEdt: TEdit
      Left = 768
      Top = 352
      Width = 25
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = 'X'
    end
    object ReplaceWordEdt: TEdit
      Left = 648
      Top = 388
      Width = 313
      Height = 27
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '******'
    end
    object SampleGrp: TRadioGroup
      Left = 16
      Top = 448
      Width = 441
      Height = 153
      Caption = 'Sample setups'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Replace name part of email addresses with random word'
        'Replace entire email addresses with "Email address removed"'
        'Replace passwords with **********')
      ParentFont = False
      TabOrder = 6
      OnClick = SampleGrpClick
    end
    object EndSpaceDelim: TCheckBox
      Left = 760
      Top = 72
      Width = 305
      Height = 33
      Caption = 'Include space as end of word delimiter'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 7
      WordWrap = True
    end
    object StartSpaceDelim: TCheckBox
      Left = 760
      Top = 24
      Width = 353
      Height = 33
      Caption = 'Include space as start of word delimiter'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 8
      WordWrap = True
    end
    object WhichwordGrp: TRadioGroup
      Left = 504
      Top = 160
      Width = 505
      Height = 81
      Caption = 'Obfuscate  the '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Items.Strings = (
        'Qualifying word'
        'Word following the qualifying word')
      ParentFont = False
      TabOrder = 9
    end
    object Memo2: TMemo
      Left = 504
      Top = 496
      Width = 585
      Height = 105
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -20
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsItalic]
      Lines.Strings = (
        'Disclaimer: This program manipulates data which may be '
        'sensitive or confidential,.  It is the entirely the user'#39's '
        'responsibility to verify that program output is as expected.')
      ParentFont = False
      TabOrder = 10
    end
  end
  object FinalDelimEdt: TEdit
    Left = 632
    Top = 72
    Width = 113
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '@'
  end
  object MustHaveEdt: TEdit
    Left = 632
    Top = 120
    Width = 201
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select input file'
    Left = 840
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select or specity an output file'
    Left = 912
  end
end
