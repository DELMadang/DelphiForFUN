object Form1: TForm1
  Left = 154
  Top = 31
  Width = 1078
  Height = 767
  Caption = 'Syllables Version 3.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 714
    Width = 1070
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
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1070
    Height = 714
    ActivePage = TestSheet
    Align = alClient
    TabOrder = 1
    object Introsheet: TTabSheet
      Caption = '  Introduction  '
      object Label4: TLabel
        Left = 424
        Top = 357
        Width = 66
        Height = 19
        Caption = 'The Files'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 27
        Top = 357
        Width = 114
        Height = 19
        Caption = 'The Vocabulary'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Memo5: TMemo
        Left = 27
        Top = 31
        Width = 809
        Height = 307
        Color = 14483455
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Like many of the projects developed here at DFF, this one starte' +
            'd as the result of a user inquiry.  This one asking how to '
          'count '
          
            'the number of syllables in a text document.  I didn'#39't even ask w' +
            'hy this might be important but just wondering the problem '
          'could '
          'be'
          
            'solved. It turns out it'#39's a hard problem because speech is a hum' +
            'an endeavor.   The phoneticists frequently'
          
            'disgaree with print publishers.  The phonics guys would prefer t' +
            'o divide "HARDER" AS "HAR-DER" based on '
          'pronunciation but'
          
            'the publishers prefer "HARD-ER" based on easier understanding if' +
            ' the word gets split across two lines.'
          ''
          
            'The pure "rules" approach for syllabizing is complex with the ma' +
            'ny exceptions in English affecting accuracy, so I chose '
          'the'
          
            'data-based approach augmented with internal rules for words not ' +
            'found in the words file.  There is a large publicly '
          'available file '
          'of syllabified English words (details on'
          'the "Setup" page).'
          ''
          
            'For various reasons, I decided to "prune" the master file to inc' +
            'lude only those'
          
            'words which appear in "Full.dic", the largest dictionary of my D' +
            'FF dictionary'
          
            'proccessing unit which contains about 63,000 words. About 41,000' +
            ' of those can be'
          
            'resolved using the "mhyph.txt" master file and are saved as file' +
            ' "Syllables.txt".'
          
            'Another 22,000 are resolved using internal rules.  The final 500' +
            ' or so are resolved'
          
            'by manually created entries which merge missing  words with the ' +
            '"Syllables.txt" '
          'file to produce the final "SyllablesList.txt" file used'
          'by the program in its syllabization.'
          ''
          ''
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Memo7: TMemo
        Left = 27
        Top = 377
        Width = 365
        Height = 232
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Nouns for the process: '
          ' "syllabication" or "syllabification"'
          ''
          'Verbs for the act: '
          '"syllabify",  "syllabicate", or  "syllabize"'
          ''
          'Adjectives for words after undergoing syllabication:  '
          '"syllabified", "syllabicated",  or "syllabized"'
          '')
        ParentFont = False
        TabOrder = 1
      end
      object Memo8: TMemo
        Left = 418
        Top = 377
        Width = 438
        Height = 240
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            '"Mhyph.txt" - Mark Ward'#39's file of 180,000 syllabized words and p' +
            'hrases from '
          'Gutenberg.com.'
          ''
          
            '"Syllables.txt" contains the words from "mhyph.txt" which, with ' +
            'the "soft hyphens" '
          
            'removed, match our 62,000 "full.dic" dictionary file.  Format is' +
            ' "original  word = '
          'syllabized word".'
          ''
          
            '"SyllablesUpdate.txt" contains local additions for words which d' +
            'o not exist on '
          
            '"Syllables.txt" an cannot be syllabized by internal program rule' +
            's.'
          ''
          
            '"SyllablesList.txt" is the merged version of "Syllables.txt" and' +
            ' "SyllablesUpdate.txt".')
        ParentFont = False
        TabOrder = 2
      end
    end
    object SetupSheet: TTabSheet
      Caption = 'Setup tasks   '
      ImageIndex = 1
      object CountLbl: TLabel
        Left = 687
        Top = 222
        Width = 114
        Height = 17
        Caption = 'Word entries built'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 34
        Top = 222
        Width = 501
        Height = 18
        Caption = 
          'Requires Mhyph.txt and DFF Full.dic dictionary to build Syllable' +
          's.txt file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 27
        Top = 411
        Width = 647
        Height = 18
        Caption = 
          'Requires Syllables.txt  and optionally SyllablesUpdate.txt file ' +
          'files to rebuild SyllablesList.txt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Memo6: TMemo
        Left = 20
        Top = 445
        Width = 836
        Height = 95
        Lines.Strings = (
          'Run statistics')
        TabOrder = 4
      end
      object Memo3: TMemo
        Left = 7
        Top = 0
        Width = 870
        Height = 216
        Lines.Strings = (
          
            'The syllabication performed by this program is based on the open' +
            ' source file mhyph.txt which is available from Project Gutenberg' +
            ' web '
          'page '
          
            'http://www.gutenberg.org/ebooks/3204.  "This eBook is for the us' +
            'e of anyone anywhere at no cost and with almost no restrictions '
          
            'whatsoever. You may copy it, give it away or re-use it under the' +
            ' terms of the Project Gutenberg License included with this eBook' +
            ' or '
          'online at '
          'www.gutenberg.org."'
          ''
          
            'The file syllabifies about 180,000 words and phrases, far too ma' +
            'ny to use "as is".  There are many foreign words, mult-word phra' +
            'ses '
          'which '
          
            'make if diggiult to use witoiut pruning.  he button below prunes' +
            ' the file to match words against the 62,000 word in our full.dic' +
            ' dictionary '
          'file '
          
            'from which a look-up list will be built.  The "Testing" page tes' +
            'ts the files by:'
          
            '1. Allowing the user to enter words and displaying the syllabica' +
            'tion form, and '
          
            '2.  Passing one of the DFF dictionary files, Small, Medium, or L' +
            'arge against the Syllables list file and reporting a summary of ' +
            'results.'
          ''
          
            'The unzipped "mhyph.txt" file from Gutenberg should be saved in ' +
            'the same folder as this program.  File "Syllables.txt" will be s' +
            'aved in '
          'the '
          
            'same folder with the each line having the format [original word]' +
            '=[syllabized word] for each word matched.'
          ''
          ''
          ''
          '')
        TabOrder = 0
      end
      object Memo4: TMemo
        Left = 20
        Top = 263
        Width = 836
        Height = 142
        Lines.Strings = (
          
            'Phase two, which may be run multiple times  merges Syllables.txt' +
            ' with locally generated SyllableUpdates.txt to build the '
          'SyllablesList.txt '
          
            'file.  This file is converted to an internal look-up list struct' +
            'ure which is accessed randomly by a  "GetSyllables" function to ' +
            'return '
          
            'syllabized versions of words passed to it.   This is the functio' +
            'n used by the  "Testing" page operations.  '
          ''
          
            'Additions and corrections are made by editing the updates file a' +
            'nd rerunning the "BuildSyllableList" procedure.  The button belo' +
            'w '
          
            'performs this operation.   It is also automatically called by bu' +
            'ttons on the Testing page whenever timestamp on either of the in' +
            'put '
          'files is '
          'later than the timestamp of the SyllablesList file.'
          ''
          ''
          ''
          ''
          ''
          '')
        TabOrder = 1
      end
      object ReBuildBtn: TButton
        Left = 653
        Top = 408
        Width = 203
        Height = 21
        Caption = 'ReBuild "SyllablesList.txt"'
        TabOrder = 2
        OnClick = ReBuildBtnClick
      end
      object BuildBtn: TButton
        Left = 531
        Top = 218
        Width = 123
        Height = 24
        Caption = 'Build "Syllables.txt"'
        TabOrder = 3
        OnClick = BuildBtnClick
      end
    end
    object TestSheet: TTabSheet
      Caption = '    Testing  '
      ImageIndex = 2
      object Label2: TLabel
        Left = 337
        Top = 7
        Width = 149
        Height = 34
        AutoSize = False
        Caption = 'Match DFF dictionary file to SyllablesList file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label1: TLabel
        Left = 74
        Top = 27
        Width = 174
        Height = 18
        Caption = 'Enter word to hyphenate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LookupLbl: TLabel
        Left = 20
        Top = 121
        Width = 260
        Height = 82
        AutoSize = False
        Caption = '--------------------------------------------'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 579
        Top = 12
        Width = 136
        Height = 17
        Caption = 'Words not syllabized'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label6: TLabel
        Left = 579
        Top = 243
        Width = 159
        Height = 17
        Caption = 'Words syllabized by rule'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label7: TLabel
        Left = 47
        Top = 263
        Width = 513
        Height = 34
        AutoSize = False
        Caption = 
          'Rule process: "Replace" letters with "Insert " letters and if re' +
          'sulting word matches word list, "Reinsert " letters with correct' +
          '  hyphen marks.'
        WordWrap = True
      end
      object ChooseDicGrp: TRadioGroup
        Left = 337
        Top = 47
        Width = 169
        Height = 75
        Caption = 'Select dictionary to scan'
        ItemIndex = 0
        Items.Strings = (
          'Small '
          'General'
          'Large')
        TabOrder = 0
      end
      object ScanDicBtn: TButton
        Left = 337
        Top = 182
        Width = 129
        Height = 21
        Caption = 'Scan dictionary'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = ScanDicBtnClick
      end
      object Edit1: TEdit
        Left = 74
        Top = 47
        Width = 102
        Height = 27
        TabOrder = 2
        Text = 'silverfish'
        OnKeyUp = Edit1KeyUp
      end
      object LookupBtn: TButton
        Left = 74
        Top = 81
        Width = 102
        Height = 21
        Caption = 'Look up word'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = LookupBtnClick
      end
      object Memo2: TMemo
        Left = 579
        Top = 256
        Width = 298
        Height = 284
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object Memo1: TMemo
        Left = 579
        Top = 27
        Width = 291
        Height = 189
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object RuleBox: TCheckBox
        Left = 337
        Top = 155
        Width = 223
        Height = 28
        Caption = 'Display  words syllabized by rules'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 6
        WordWrap = True
      end
      object CheckBox1: TCheckBox
        Left = 337
        Top = 128
        Width = 210
        Height = 35
        Caption = 'Display  words syllabized by lookup'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        WordWrap = True
      end
      object RuleGrid: TStringGrid
        Left = 47
        Top = 296
        Width = 500
        Height = 237
        TabOrder = 8
        ColWidths = (
          64
          115
          92
          95
          204)
      end
      object Memo9: TMemo
        Left = 579
        Top = 27
        Width = 291
        Height = 203
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Unrecognized words from either the single '
          'word look-up or a dictionay scan appear '
          'in this list as unknownword=unknownword. '
          ' To add this word to SyllableList ,txt file, '
          'syllabilize the righthand side of the '
          'equation by inserting  blank space '
          'characters between syllables '
          '(e.g. croatia=cro a tia) . Then  copy and paste '
          'the new line(s) to the SyllablesUpdate.txt file '
          'using Notepad or other text editor.The changes '
          'will be automatically incoprporated when the '
          'next search is performed.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 9
      end
      object ScanTextBtn: TButton
        Left = 337
        Top = 222
        Width = 129
        Height = 21
        Caption = 'Scan a text file'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        OnClick = ScanTextBtnClick
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files  (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select tyext file to scan'
    Left = 1000
  end
  object SaveDialog1: TSaveDialog
    Left = 1032
  end
end
