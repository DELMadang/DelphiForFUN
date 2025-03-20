object Form1: TForm1
  Left = 283
  Top = 205
  Width = 1031
  Height = 614
  Caption = 'Clean blank lines from text  files  (Version 4.1)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 20
  object StaticText1: TStaticText
    Left = 0
    Top = 545
    Width = 1013
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2006, 2012  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1013
    Height = 545
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object SaveBtn: TButton
      Left = 104
      Top = 504
      Width = 201
      Height = 25
      Caption = 'Select file to process'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = SaveBtnClick
    end
    object Memo1: TMemo
      Left = 480
      Top = 16
      Width = 505
      Height = 481
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'This is a program to remove blank lines from specified input'
        'text files and write non-blank lines to specified output files.'
        ''
        'The original program was created when a subweb index page on'
        'my website somehow had 35,000 extra lines with 10 blank '
        'characters per line inserted among 136 valid code lines.  This '
        'expanded the HTML file from 12 Kbytes to 360KBytes and hung '
        'Frontpage, my web editor program. After a 20 minute effort at  '
        'manually deleting blank lines, the job was less than 10% '
        'complete with no assurance that I had not accidentally deleted '
        'valid lines, so the manual approach was abandoned.'
        ''
        
          'Version 2 allows selection of multiple files to be "deblanked" i' +
          'n a'
        
          'single run.  Input files are selected by using Ctrl-Click  on ea' +
          'ch '
        
          'file to be processed or to click to select the first of a list o' +
          'f files '
        
          'to be processed and Shift-Click on the last file to be processed' +
          '.  '
        
          'All files in between will be selected. Options allow you to save' +
          ' a '
        'back-up copy of each file before processing, update the files '
        'without taking a backup, or to specify a new out file name for '
        'each selected input file.'
        ''
        'Version 3 included the option to remove leading blanks from all'
        
          'lines in addition to deleting blank lines. Version 3.1 adds opti' +
          'ons'
        'to delete trailing spaces, treatingTabs as spaces, and changing'
        'text case. Version 3.2 retains user options between executions'
        'and saves deleted records in a separate file with an "_Deleted"'
        'name suffix.'
        ''
        'Version 4 allows deletion or keeping records containing a '
        
          'specified string, with or without case matching. V4.1 now honors' +
          ' '
        'the Tab parameter when removing blank lines.  Previously Tabs '
        'were alway treated as blanks when removing blank lines '
        
          'regardless of the "Tabs" setting.  Also the "Deleted lines" file' +
          ' is '
        'now only written if non-blank lines were deleted.'
        ''
        'THIS PROGRAM HAS NOT BEEN EXTENSIVELY TESTED.  I'
        'STRONGLY RECOMMEND THAT YOU MAKE A SEPARATE '
        'BACKUP OF FILES TO BE PROCESSED BEFORE RUNNING '
        'THIS PROGRAM. THE AUTHOR ASSUMES NO '
        'RESPONSIBILITY FOR RESULTS PRODUCED.'
        ''
        ''
        ' '
        ' ')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object ModeGrp: TRadioGroup
      Left = 8
      Top = 16
      Width = 457
      Height = 97
      Caption = 'Run options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Backup files then update input files'
        'Update input files  without  backup'
        'Do not change input files, get new names for output ')
      ParentFont = False
      TabOrder = 2
    end
    object a: TGroupBox
      Left = 8
      Top = 120
      Width = 441
      Height = 281
      Caption = 'Delete options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      object DeletetrailingBox: TCheckBox
        Left = 8
        Top = 77
        Width = 345
        Height = 17
        Caption = 'Delete trailing space characters.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = DelCharBoxClick
      end
      object DeleteLeadingBox: TCheckBox
        Left = 8
        Top = 50
        Width = 345
        Height = 17
        Caption = 'Delete leading space characters'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = DelCharBoxClick
      end
      object DeleteBlankBox: TCheckBox
        Left = 8
        Top = 24
        Width = 209
        Height = 17
        Caption = 'Delete blank lines.'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 2
      end
      object DelCharBox: TCheckBox
        Left = 8
        Top = 184
        Width = 377
        Height = 17
        Caption = 'Delete lines which contain  the above string:...................'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = DelCharBoxClick
      end
      object NoDelCharBox: TCheckBox
        Left = 8
        Top = 208
        Width = 321
        Height = 41
        Caption = 'Delete lines which do NOT contain  this string'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        WordWrap = True
        OnClick = DelCharBoxClick
      end
      object DelStringEdt: TEdit
        Left = 8
        Top = 140
        Width = 241
        Height = 40
        Color = clYellow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -27
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        Text = '@'
        OnKeyPress = DelStringEdtKeyPress
      end
      object DeleteTabsBox: TCheckBox
        Left = 8
        Top = 101
        Width = 385
        Height = 36
        Caption = 'Treat Tab characters as spaces for deletes'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 6
      end
      object CaseBox: TCheckBox
        Left = 280
        Top = 152
        Width = 129
        Height = 17
        Caption = 'Match case'
        TabOrder = 7
      end
    end
    object TextGrpBox: TRadioGroup
      Left = 16
      Top = 408
      Width = 369
      Height = 89
      Caption = 'Text options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'Leave text case unchanged.'
        'Change text to lower case.'
        'Change text to upper case. ')
      ParentFont = False
      TabOrder = 4
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Title = 'Select input file(s) to process'
    Left = 288
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select or enter output file name'
    Left = 336
    Top = 8
  end
end
