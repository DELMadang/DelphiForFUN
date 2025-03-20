object Form1: TForm1
  Left = 141
  Top = 130
  Width = 1192
  Height = 760
  Caption = 'Copy Folder Test V3.2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 621
    Top = 86
    Width = 163
    Height = 16
    Caption = 'Enter or select a file mask'
  end
  object Label2: TLabel
    Left = 613
    Top = 64
    Width = 93
    Height = 16
    Caption = ' Not selected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 613
    Top = 48
    Width = 86
    Height = 16
    Caption = 'Input folder:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InputBtn: TButton
    Left = 613
    Top = 11
    Width = 274
    Height = 29
    Caption = 'Select input folder '
    TabOrder = 0
    OnClick = InputBtnClick
  end
  object CopyBtn: TButton
    Left = 613
    Top = 656
    Width = 129
    Height = 29
    Caption = 'Process files'
    Enabled = False
    TabOrder = 1
    OnClick = CopyBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 691
    Width = 1174
    Height = 24
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2006-2012  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object MaskComboBox: TComboBox
    Left = 799
    Top = 81
    Width = 234
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 19
    ParentFont = False
    TabOrder = 3
    Text = '*.*'
    Items.Strings = (
      '*.*'
      '*.txt'
      '*.doc'
      '*.zip')
  end
  object StopBtn: TButton
    Left = 783
    Top = 656
    Width = 129
    Height = 29
    Caption = 'Stop'
    TabOrder = 4
    OnClick = StopBtnClick
  end
  object PageControl1: TPageControl
    Left = 9
    Top = 18
    Width = 586
    Height = 663
    ActivePage = TabSheet1
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 18
        Top = 5
        Width = 550
        Height = 604
        Color = 14483455
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'This program was written to test a "CopyFolder" function for use' +
            ' '
          'by Delphi programmers, but it has enough  features to perhaps '
          'serve as a useful utility.'
          ''
          'Usage is straight-forward:  Select an input folder and an output'
          'folder, which may be an existing folder or a new one.  Set the'
          'other options and click the "Copy" button to complete the'
          'operation.  The "File masks" tab above gives more information'
          'about defining  mask strings.'
          ''
          
            'This Introduction page will be replaced by a list of files copie' +
            'd'
          'and the total count will be displayed when the operation has'
          'been completed.'
          ''
          
            'You may interrupt the operation by clicking the "Stop" button bu' +
            't'
          'the copies of files already processed will remain in the output'
          
            'folder.  If you select "Ask" option for the Duplicate Files radi' +
            'o'
          'group, a reply of "Cancel" when asked will also stop the'
          'operation.'
          ''
          
            'Version 2 tests new features of file copy.  Counts of files copi' +
            'ed,'
          'duplicate files overwritten and duplicate files not copied are'
          'kept by the copyfolder functions and are reported by this'
          'program at job completion time.'
          ''
          
            'A new option allows user to specify that all files found be copi' +
            'ed'
          'to the same output folder, ignoring input subfolder directory'
          
            'structure. This increases the likleyhood that duplicate file nam' +
            'es'
          'will be found.  The "Ask" dialog when duplicates are found now'
          
            'has "Yes to all" and "No to all" buttons to specify a default ac' +
            'tion'
          'when additional duplicate file names are encountered}'
          ''
          'Version 3 changed the file date test to use "Last Modified Date"'
          'instead of "Creation Date" when deciding which file is newer for'
          'overwriting decisions.  It also now checks and ignores copying a'
          'source subfolder if it also happens to be the destination folder'
          'for the copy operation.'
          ''
          
            'Version3.1 adds an option to process input files without copying' +
            '.'
          
            'Selected files and total counts and sizes are listed.  Also, wit' +
            'h'
          
            'V3.1, Sytem directories are listed (e.g. web site folders) and f' +
            'ile sizes '
          'greater than 4GB are reported correctly.'#39
          ''
          
            'V3.2 adds an option to include the selected input folder (as wel' +
            'l as the '
          
            'the files contained in that folder) to the specified output fold' +
            'er.  '
          
            'Convenient if, for example, you have a general "Backups" folder ' +
            'and '
          'want to copy other folders to it retaining their identity.'
          ''
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '  File Masks Tutorial'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ImageIndex = 1
      ParentFont = False
      object Memo2: TMemo
        Left = 0
        Top = 8
        Width = 559
        Height = 601
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'File masks can be a useful way to select a set of files meeting ' +
            'specific '
          
            'criteria.A mask is a string of characters with defined meanings.' +
            '  Character '
          
            'matches are not case sensitive, upper and lower case versions of' +
            ' a letter '
          'will match.'
          ' '
          
            '*  (asterisk): a "wild card" indicating an unspecified number of' +
            ' characters in '
          'the file name.'
          ''
          
            '? (question mark) : a wild card which matches a single character' +
            ' position in '
          'the file name.'
          ''
          
            '[  (open bracket): beginning of a "set" definition, a set of alt' +
            'ernative '
          'characters for specific position.'
          ''
          '] (close bracket) : the end of a set defininition'
          ''
          
            '!  (exclamation point): may appear immediately following a [ to ' +
            'indicate that '
          'any character not in the set counts as a match.'
          ''
          
            '-  (hyphen): separating two characters in a set indicates a rang' +
            'e of '
          'character to test.'
          ''
          
            'Here are some examples: (In these examples double quotes (") are' +
            ' used to '
          
            'identify literals but are not part of the string being reference' +
            'd.)'
          ''
          '*.*    match any string that has a dot (.) in any position'
          ''
          '*.txt    match any string that ends with ".txt"'
          ''
          
            '2006*.doc    match any string that starts with "2006" and ends w' +
            'ith ".doc"'
          ''
          
            '??????[abc].log     match a flename that is 11 characters long, ' +
            ' has an "a", '
          '"b", or "c'#39' as its 7th character, and ends with ".log"'
          ''
          
            '*[0-9][0-9]*.*     match any file name that has a 2 digit number' +
            ' anywhere in '
          'the base part of the name.'
          ''
          
            '[!e][!x]*.*     match any file name that does not begin with "ex' +
            '"'
          '  '
          ' '
          ' ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object OutputGrp: TGroupBox
    Left = 624
    Top = 272
    Width = 521
    Height = 369
    Caption = 'Output options'
    TabOrder = 6
    object Label3: TLabel
      Left = 16
      Top = 111
      Width = 465
      Height = 42
      AutoSize = False
      Caption = ' Not selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label5: TLabel
      Left = 16
      Top = 95
      Width = 98
      Height = 16
      Caption = 'Output folder:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DupNamesgrp: TRadioGroup
      Left = 23
      Top = 191
      Width = 274
      Height = 74
      Caption = 'Duplicate file names'
      Columns = 2
      ItemIndex = 2
      Items.Strings = (
        'Skip'
        'Replace'
        'Replace if newer'
        'Ask')
      TabOrder = 0
    end
    object CopyToRoot: TCheckBox
      Left = 22
      Top = 155
      Width = 387
      Height = 30
      Caption = 'Drop subfolders in output. (Copy all to root output folder) '
      TabOrder = 1
      WordWrap = True
    end
    object OutputBtn: TButton
      Left = 15
      Top = 58
      Width = 274
      Height = 29
      Caption = 'Select output folder'
      TabOrder = 2
      OnClick = OutputBtnClick
    end
    object CreateDirBox: TCheckBox
      Left = 27
      Top = 31
      Width = 238
      Height = 19
      Caption = 'Allow new output folder'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object AttribGrp: TRadioGroup
      Left = 23
      Top = 279
      Width = 274
      Height = 74
      Caption = 'Output file attributes '
      ItemIndex = 0
      Items.Strings = (
        'Retain input file attributes'
        'Reset  "read only" attribute ')
      TabOrder = 4
    end
  end
  object SubfolderBox: TCheckBox
    Left = 624
    Top = 240
    Width = 393
    Height = 17
    Caption = 'Include files in subfolders of selected input folder'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 7
  end
  object ActionGrp: TRadioGroup
    Left = 624
    Top = 120
    Width = 345
    Height = 73
    Caption = 'Choose action'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'List  matching files (no copy)'
      'Copy and list matching files  ')
    ParentFont = False
    TabOrder = 8
    OnClick = ActionGrpClick
  end
  object FirstFolderBox: TCheckBox
    Left = 624
    Top = 208
    Width = 393
    Height = 17
    Caption = 'Include selected input folder record in output'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 9
  end
end
