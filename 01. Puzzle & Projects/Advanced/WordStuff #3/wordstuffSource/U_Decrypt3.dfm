object Decryptform: TDecryptform
  Left = 151
  Top = 113
  AutoScroll = False
  AutoSize = True
  Caption = 'Decrypt3 - A Code Finder'
  ClientHeight = 910
  ClientWidth = 1284
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 20
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1284
    Height = 881
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo4: TMemo
        Left = 25
        Top = 12
        Width = 1158
        Height = 753
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'This is an enhanced version of  the original  Decrypt program to' +
            ' solve cryptograms.  Decrypting, or deciphering, is the'
          
            'process of converting enciphered messages back into readable tex' +
            't.  Although there are many methods for encoding text,'
          
            'the simplest type are known as "monoalphabetic" meaning that the' +
            ' same plain text letter is always converted into the same'
          'enciphered letter.'
          ''
          'How it works'
          ''
          
            'A dictionary lookup provides a method for determining whether a ' +
            'particular decipherment is correct. The brute force'
          
            'approach, trying  all possible permutations of letters can be ve' +
            'ry lengthy, for example - if there are 20 different letters in t' +
            'he'
          
            'message,  then we need to check the number of ways in which  we ' +
            ' could choose 20 of 26 letters.  This number turns out to be'
          ' 5  X 10^23 arrangements (that'#39's a 5 with 23 zeros behind it).'
          ''
          
            'To reduce the number of patterns to search we start by looking a' +
            't the potential choices for the two longest words in the'
          
            'message.  The number of long words is fewer than the numbers of ' +
            'shorter words and we can use pattern information to further'
          
            'narrow the choices.  For example, the encoded word "gomzibjzgvc"' +
            ' is an 11-letter word with the 1st letter matching the 9th'
          
            'and the  4th matching the 8th.  There is only one such word in m' +
            'y dictionary "obligations".  So assuming that this is the proper'
          
            'word, we have 9 letters already known.   Again asusming that 20 ' +
            'letters are used, we know 9 of them and have "only" 40'
          
            'million or so arrangements to check.  We can reduce search times' +
            ' further by arranging the plaintext letters in sequence of'
          'their frequency in the English language.'
          ''
          
            'Searches stop and the next combination tried when a deciphered "' +
            'word" is found which has no dictionary entry.  The obvious'
          
            'shortcoming of this technique is that words not in our dictionar' +
            'y may reject an otherwise valid decipherment.   The "Hints'
          'and Tips" section below addresses this problem.'
          ''
          ''
          'Using the Program'
          ''
          ''
          
            'Program usage is straigtforward.  The "Setup Encrypted Message" ' +
            'page has buttons to "Load", "Save" encoded'
          
            'messages, Load a different dictionary, and "Suggest" decodings f' +
            'or specific words or letters.  With with Version 3 you can '
          
            'choose which words in the message to decode by checking (or unch' +
            'eking) the words in the "Select words..." list.  This is '
          
            'sometimes helpful if the search seems get stuck on a particular ' +
            'word (which may not be in the dictionary).  You can also add '
          
            'plaintext words to the "Ignored words" which the search finds, b' +
            'ut which you are quite sure are not correct.'
          ''
          
            'There is a "Get plaintext message" button which opens a dialog w' +
            'here plain text messages may be entered or loaded from '
          
            'any text file.  On exit from the dialog, the plain text messsage' +
            ' is randomly enciphered and passed to the main form.'
          ''
          
            'The "Decrypt" page is where to start the search and monitor its ' +
            'progress.'
          ''
          ''
          'Hints and Tips'
          ''
          ''
          
            '....If words contain '#39' (apostrophe marks), consider delecting th' +
            'ose words from the message.  These are probably'
          'contractions or possessives that will  not be in the dictionary.'
          ''
          
            '....Many cryptograms are quotations and include the authors name' +
            ' at the end of the message frequently preceded by a dash'
          
            '---.  It is unlikely that the name will be in our dictionary so ' +
            'it is best to uncheck this name field  before deciperhing the '
          'message.'
          ''
          
            '....If the program runs  more than a minute or two, the shortcut' +
            's have probably not been successful and the program has'
          
            'reverted to a brute force search.  This means that it will likel' +
            'y run for a very long time to decipher the messages.  It'
          
            'might be wise to stop the run and use another technique to help ' +
            'the program. For example:'
          ''
          
            '      --------Deselect some  words and decipher only part of the' +
            ' message.  Perhaps the first half or last half of the message.'
          ''
          
            '     --------Make a guess at the decipherment for some word and ' +
            'use the "Suggestions" button to force the program to try this'
          'first.'
          ''
          
            '     --------Look for the ""th" letter pair, as in "the", "then"' +
            ', "that".  Three letter words are apt to be "the" or "and" so ma' +
            'ke a guess'
          'suggestion based on those combinations that you identify.'
          ''
          
            '     -------If you hit the  "Stop" button during the search, the' +
            ' best partial decipherment will be displayed.  This can provvide'
          'further guesses for words that can be entered as suggestions.'
          ''
          ''
          ''
          ' '
          ' ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Setup encrypted message'
      ImageIndex = 2
      object Label6: TLabel
        Left = 49
        Top = 123
        Width = 402
        Height = 20
        Caption = 'Enciphered message (type or use '#39'"Load" button above'
      end
      object Label9: TLabel
        Left = 591
        Top = 123
        Width = 292
        Height = 20
        Caption = 'Select words from message to decipher'
      end
      object Label10: TLabel
        Left = 49
        Top = 468
        Width = 239
        Height = 20
        Caption = 'Ignore these as decrypted words'
      end
      object Label8: TLabel
        Left = 985
        Top = 369
        Width = 130
        Height = 20
        Caption = 'User suggestions'
      end
      object LoadMsgBtn: TButton
        Left = 62
        Top = 12
        Width = 210
        Height = 39
        Caption = 'Load coded message'
        TabOrder = 0
        OnClick = LoadMsgBtnClick
      end
      object SaveBtn: TButton
        Left = 283
        Top = 12
        Width = 211
        Height = 39
        Caption = 'Save coded message'
        TabOrder = 1
        OnClick = SaveBtnClick
      end
      object CheckListBox1: TCheckListBox
        Left = 591
        Top = 160
        Width = 321
        Height = 629
        ItemHeight = 20
        TabOrder = 2
      end
      object Memo5: TMemo
        Left = 49
        Top = 160
        Width = 469
        Height = 272
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
        OnChange = Memo5Change
      end
      object IgnoredWordsMemo: TMemo
        Left = 49
        Top = 492
        Width = 236
        Height = 297
        Lines.Strings = (
          'id'
          'ad'
          '')
        TabOrder = 4
      end
      object MakeMsgBtn: TButton
        Left = 517
        Top = 12
        Width = 211
        Height = 39
        Hint = 'Load or enter a plaintext message to encipher'
        Caption = 'Get plaintext message'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = MakeMsgBtnClick
      end
      object LoadDicBtn: TButton
        Left = 751
        Top = 12
        Width = 211
        Height = 39
        Caption = 'Load a dictionary'
        TabOrder = 6
        Visible = False
        OnClick = LoadDicBtnClick
      end
      object SuggestBtn: TButton
        Left = 985
        Top = 283
        Width = 210
        Height = 39
        Hint = 'Suggest a decipherment for some words or letters'
        Caption = 'Suggest '
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = SuggestBtnClick
      end
      object SuggestMemo: TMemo
        Left = 985
        Top = 406
        Width = 210
        Height = 371
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 8
      end
      object Memo3: TMemo
        Left = 985
        Top = 160
        Width = 235
        Height = 88
        Color = clYellow
        Lines.Strings = (
          'Use the button below to  force  '
          'decoding patterns for specific '
          'words or letters.')
        TabOrder = 9
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Decrypt'
      ImageIndex = 1
      OnEnter = TabSheet2Enter
      object Label1: TLabel
        Left = 357
        Top = 689
        Width = 50
        Height = 20
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 357
        Top = 714
        Width = 50
        Height = 20
        Caption = 'Label2'
      end
      object Label4: TLabel
        Left = 788
        Top = 62
        Width = 168
        Height = 20
        Caption = 'Trial deciphered words'
      end
      object Label7: TLabel
        Left = 357
        Top = 369
        Width = 158
        Height = 20
        Caption = 'Deciphered message'
      end
      object Timelbl: TLabel
        Left = 923
        Top = 689
        Width = 151
        Height = 20
        Caption = 'Run time: 0 seconds'
      end
      object Label5: TLabel
        Left = 357
        Top = 37
        Width = 50
        Height = 20
        Caption = 'Label5'
      end
      object StopBtn: TButton
        Left = 25
        Top = 62
        Width = 210
        Height = 186
        Caption = 'Stop'
        TabOrder = 0
        Visible = False
        OnClick = StopBtnClick
      end
      object Memo2: TMemo
        Left = 357
        Top = 406
        Width = 395
        Height = 260
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object SearchBtn: TButton
        Left = 25
        Top = 209
        Width = 210
        Height = 39
        Caption = ' Decrypt the message'
        TabOrder = 2
        OnClick = SearchBtnClick
      end
      object ListBox2: TListBox
        Left = 788
        Top = 98
        Width = 321
        Height = 568
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = []
        ItemHeight = 27
        ParentFont = False
        TabOrder = 3
      end
      object Memo1: TMemo
        Left = 345
        Top = 74
        Width = 395
        Height = 272
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -24
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 4
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 891
    Width = 851
    Height = 19
    Align = alNone
    Panels = <
      item
        Width = 350
      end
      item
        Alignment = taCenter
        Width = 400
      end>
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 881
    Width = 1284
    Height = 29
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -22
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = ' Text file (*.txt)|*.txt|Any file (*.*)|*.*'
    Left = 560
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Title = 'Save enciphered message'
    Left = 624
  end
end
