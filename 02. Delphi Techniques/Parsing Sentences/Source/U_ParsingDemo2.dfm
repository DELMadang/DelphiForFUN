object Form1: TForm1
  Left = 225
  Top = 150
  Width = 1023
  Height = 551
  Caption = 'Sentence Parsing Demo   Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 102
    Height = 16
    Caption = 'Sample input text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 504
    Top = 8
    Width = 308
    Height = 16
    Caption = 'Parsed paragraphs, sentences, words, and delimiters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 24
    Top = 24
    Width = 457
    Height = 409
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'This demo for Delphi programmers is an extension of a previously' +
        ' posted '
      'Parsing Strings program.'
      ''
      
        'It'#39's a text parser which helps identify paragraphs, sentences, w' +
        'ords and '
      
        'delimiters in plain text files. Paragraphs are defined by blank ' +
        'lines. '
      
        'Sentences in this demo are identified by trailing period (.),  e' +
        'xclamation '
      'point (!),or  question mark (?) as ending delimiters.'
      ''
      
        'It was written to help a teacher in Indonesia who teaches Englis' +
        'h as a '
      
        'foreign language and is working on an automated translator to pr' +
        'ovide '
      
        'sample material for some Computer Based Training he is developin' +
        'g.  I '
      'wished him luck but warned him that identifying sentences and '
      'paragraphs is likely to be the easiest part of the job.'
      ''
      
        'The "GetNextWord" function takes a string as input and returns a' +
        ' Boolean '
      
        'result: "True" if a word was found and "False" when there are no' +
        ' more '
      
        'words in the string.  In addition to the word found, this versio' +
        'n returns the '
      
        'trailing delimiters of the word, an index of the starting point ' +
        'of the next '
      
        'location to check and   Boolean flags indicating whether the cur' +
        'rent word '
      
        'is End-of-Sentence (EOS) and End-of-Paragraph (EOP). Single Carr' +
        'iage '
      
        'Return (CR) and Linefeed (LF) pairs indicating the end of a line' +
        ' are '
      'ignored. Double CR-LF pairs indicate the EOP condition.'
      ''
      
        'Buttons allow selection of the  text file to process loading a n' +
        'ew '
      
        'abbreviation file, or starting the parsing operation that  displ' +
        'ays the parsed '
      'results in a separate display area.'
      ''
      
        'Version 2 adds abbreviation checking. One of the problems with c' +
        'hecking '
      
        'periods as sentence delimiters is that abbreviations containing ' +
        'periods will '
      
        'be treated as EOS.  Pass a sorted TStringlist list containing ab' +
        'breviations '
      
        'along with the results of GetNextWord to the "IsAbbreviation" fu' +
        'nction and '
      
        'it will reconstruct matching entries with the proper parameters.' +
        ' With the '
      
        'provided sample abbreviation list, such entries as "Mr.",Dr.", "' +
        'e.g.", "vs." '
      
        'etc. will be detected correctly. A real application would probab' +
        'ly build the '
      
        'list from an input text file to allow future additions. Ambiguou' +
        's conditions '
      
        'when a sentence ends with an abbreviation that is not the end of' +
        ' a '
      'paragraph may not be handled properly in all cases.'
      ''
      
        'The results of the parsing operation are displayed in color-code' +
        'd form in a '
      
        'TRichEdit control.  The technique required to use colored text o' +
        'n part of a '
      
        'line (e.g. the delimiters displayed in red) is not obvious.  It ' +
        'can be '
      
        'accomplished by setting Selstart property to the desired text in' +
        'sertion '
      
        'point, setting SelAttribs to the desired  attributes and then se' +
        'tting Seltext '
      'to the text to be inserted.'
      ''
      
        'Also, the TMemo trick of setting SelStart and Sellength to 0 to ' +
        'force the '
      
        'first line of he display to scroll into view, does not work with' +
        ' TRichEdit. '
      'Instead we need to generate a EM_SCROLLCARET windows message.'
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object ParseBtn: TButton
    Left = 360
    Top = 440
    Width = 121
    Height = 25
    Caption = 'Parse text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = ParseBtnClick
  end
  object OutText: TRichEdit
    Left = 504
    Top = 24
    Width = 473
    Height = 409
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'arialf'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 495
    Width = 1007
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object LoadBtn: TButton
    Left = 24
    Top = 440
    Width = 145
    Height = 25
    Caption = 'Select a file to parse'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = LoadBtnClick
  end
  object Abbrevbtn: TButton
    Left = 192
    Top = 440
    Width = 145
    Height = 25
    Caption = 'Select Abbreviation file'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = AbbrevbtnClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select a text file to parse'
    Left = 424
    Top = 8
  end
end
