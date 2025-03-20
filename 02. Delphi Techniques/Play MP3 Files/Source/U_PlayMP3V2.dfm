object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'PlayMP3 V2.0 - Play audio from text'
  ClientHeight = 700
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 677
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
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
    Width = 888
    Height = 665
    TabOrder = 1
    object MediaPlayer1: TMediaPlayer
      Left = 88
      Top = 512
      Width = 57
      Height = 30
      VisibleButtons = [btPlay, btStop]
      Visible = False
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 886
      Height = 663
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 1
      OnChange = PageControl1Change
      object TabSheet1: TTabSheet
        Caption = 'Introduction and text test'
        object Testtext: TRichEdit
          Left = 16
          Top = 0
          Width = 841
          Height = 617
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'This is a programming illustrating some techniques for playing a' +
              'udio files based on user'
            
              'actions.  Click on a sentence to play the associated MP3 or WAV ' +
              'file (11:1).   The file is'
            
              'identified by the text in parentheses at the end of the sentence' +
              ' (11:2). Sentences with invalid '
            'or missing file indicator text will ignore clicks.'
            ''
            
              'The "Setup" page allows you to maintain this text and to load ot' +
              'her text files for testing.  '
            
              'You may also save, load, and maintain a file which associtates t' +
              'he file identification text '
            
              'with the actual audio file names. Each line of the File Assciati' +
              'on table has the formeat '
            
              '"Text=Filename" where "Text" is the text string which appears wi' +
              'thin the parentheses at '
            
              'the end of the sentence to trigger the playback and "Filename" i' +
              's the name of the file to '
            'play.')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
          OnMouseUp = TesttextMouseUp
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Setup'
        ImageIndex = 1
        object Label1: TLabel
          Left = 488
          Top = 464
          Width = 280
          Height = 16
          Caption = 'Text file identifiers and associated file names'
        end
        object Label2: TLabel
          Left = 48
          Top = 8
          Width = 58
          Height = 16
          Caption = 'Body text'
        end
        object InputText: TRichEdit
          Left = 0
          Top = 32
          Width = 857
          Height = 409
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          HideScrollBars = False
          Lines.Strings = (
            
              'This is a program illustrating some techniques for playing audio' +
              ' files based on user'
            
              'actions.  Click on this or the next sentence to play the associa' +
              'ted MP3 or WAV file '
            
              '(Test1).  The file is identified by the text in parentheses at t' +
              'he end of the sentence and is '
            
              'associated with the file name to play as described below (Test2)' +
              '. Clicks will be ignored '
            'for sentences with invalid or missing file indicator text.'
            ''
            
              'The "Setup" page allows you to maintain this text and to load ot' +
              'her text files for testing.  '
            
              'You may also save, load, and maintain a "File Association" table' +
              ' which connects the file'
            
              'identification text with the actual audio file names. Each line ' +
              'of the File Association table'
            
              'has the format "FileId=Filename" . "FileId" is the text string w' +
              'hich appears within the last set of '
            
              'parentheses in the sentence to trigger the playback.  "Filename"' +
              ' is the name of the file to play.'
            ''
            'The code to trigger audio playback has these tasks to perform:'
            ''
            
              '1: Recognize the user click.  A RichEdit "OnMouseUp" event exit ' +
              'performs the search.'
            
              '2: The "SelStart" property identifies the location within the te' +
              'xt where the click occurred.'
            
              '3: Uses "PosEx" function to find the period at the end of the se' +
              'ntence.'
            
              '4: Scans back character by character looking for a ")" character' +
              '.  If found scan, back from'
            
              'there to the open paren "(" and copy the enclosed text to a "Tag' +
              'Id" string.'
            
              '5: We use the "Name=Value" stringlist facility to look for the T' +
              'agId as a Name field and'
            'verify that the Value field name an existing file.'
            
              '6: If we have a valid filename,  use the RichEdit "SelAttributes' +
              '" property to highlight the'
            
              '"TagId" text, play "Filename" file using a "TMediaPlayer" contro' +
              'l, and then reset the text '
            'attributes back to the "DefAttribute" values.')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object Memo1: TMemo
          Left = 488
          Top = 480
          Width = 297
          Height = 113
          Lines.Strings = (
            'Test1=Ding_Dong.mp3'
            'Test2=Dog_Barking.mp3'
            '.')
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object LoadListBtn: TButton
          Left = 488
          Top = 592
          Width = 75
          Height = 25
          Caption = 'Load...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = LoadListBtnClick
        end
        object SaveListBtn: TButton
          Left = 688
          Top = 592
          Width = 75
          Height = 25
          Caption = 'Save...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = SaveListBtnClick
        end
        object LoadTextBtn: TButton
          Left = 32
          Top = 440
          Width = 75
          Height = 25
          Caption = 'Load...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = LoadTextBtnClick
        end
        object SavetextBtn: TButton
          Left = 128
          Top = 440
          Width = 75
          Height = 25
          Caption = 'Save...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = SavetextBtnClick
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select the file association table to load'
    Left = 853
    Top = 548
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text (*.txt)|*.txt|All files (*.*) |*.*'
    Title = 'Select or enter a name for  File Association table to save'
    Left = 853
    Top = 604
  end
  object OpenDialog2: TOpenDialog
    Title = 'Select the text file to load'
    Left = 853
    Top = 572
  end
  object SaveDialog2: TSaveDialog
    Filter = 'Rich text (*.rtf)|*.rtf|All files (*.*)|*.*'
    Title = 'Select orenter a name to save the rich text file'
    Left = 853
    Top = 628
  end
end
