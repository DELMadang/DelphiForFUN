object Form1: TForm1
  Left = 134
  Top = 95
  Width = 680
  Height = 480
  Caption = 'Technology breakthrough!'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 12
    Top = 8
    Width = 649
    Height = 305
    Color = clYellow
    TabOrder = 1
    object Label3: TLabel
      Left = 16
      Top = 16
      Width = 593
      Height = 57
      AutoSize = False
      Caption = 
        'I'#39'm sorry  - that was garbled, can you please speak a little lou' +
        'der and speak three distinct words describing your card.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 16
      Top = 72
      Width = 593
      Height = 81
      AutoSize = False
      Caption = 
        'The first word should be "King", "Queen" or "Jack";  the second ' +
        'word should be "of";  and the third word should be "Hearts",  "D' +
        'iamonds",  "Spades" or "Clubs".'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label8: TLabel
      Left = 24
      Top = 168
      Width = 437
      Height = 23
      Caption = 'Speak again and then press the Next button below'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object Next2Btn: TButton
      Left = 287
      Top = 248
      Width = 75
      Height = 25
      Caption = 'Next'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 0
      OnClick = Next2BtnClick
    end
  end
  object Panel3: TPanel
    Left = 12
    Top = 8
    Width = 649
    Height = 305
    Color = clYellow
    TabOrder = 2
    object Label5: TLabel
      Left = 24
      Top = 24
      Width = 73
      Height = 33
      AutoSize = False
      Caption = 'Got it!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label6: TLabel
      Left = 24
      Top = 56
      Width = 505
      Height = 33
      AutoSize = False
      Caption = 'Your card has been removed from the display!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label9: TLabel
      Left = 24
      Top = 88
      Width = 505
      Height = 73
      AutoSize = False
      Caption = 
        'Please help us improved the accuracy of this program by register' +
        'ing whether the program answer was correct or incorrect'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Thankslbl: TLabel
      Left = 104
      Top = 184
      Width = 70
      Height = 23
      Caption = 'Thanks!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object LiarLbl: TLabel
      Left = 200
      Top = 184
      Width = 130
      Height = 23
      Caption = 'I don'#39't think so!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object AnswerGrp: TRadioGroup
      Left = 100
      Top = 168
      Width = 417
      Height = 49
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      Items.Strings = (
        'Correct'
        'Incorrect')
      ParentFont = False
      TabOrder = 2
      OnClick = AnswerGrpClick
    end
    object ReplayBtn: TButton
      Left = 147
      Top = 240
      Width = 123
      Height = 32
      Caption = 'Play again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 0
      OnClick = ReplayBtnClick
    end
    object ExitBtn: TButton
      Left = 427
      Top = 240
      Width = 75
      Height = 32
      Caption = 'Exit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 1
      OnClick = ExitBtnClick
    end
  end
  object Panel1: TPanel
    Left = 12
    Top = 8
    Width = 649
    Height = 305
    Color = clYellow
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 16
      Width = 593
      Height = 73
      AutoSize = False
      Caption = 
        'Due to recent advances, is now possible to sense the vibrations ' +
        'caused by the human voice as the sound impacts the speakers atta' +
        'ched to your PC.  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 32
      Top = 96
      Width = 593
      Height = 105
      AutoSize = False
      Caption = 
        'To illustrate this "magical" effect,  try the following :  Selec' +
        't a card from those shown below.  Do NOT point to it with the mo' +
        'use.  Instead speak the name of the card slowly and clearly towa' +
        'rds your speakers.  Then click the "Next"  button. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Label4: TLabel
      Left = 32
      Top = 200
      Width = 553
      Height = 57
      AutoSize = False
      Caption = 
        'The program will attempt to recognize the named card and remove ' +
        'it from the display.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
    object Next1Btn: TButton
      Left = 287
      Top = 264
      Width = 75
      Height = 25
      Caption = 'Next'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 0
      OnClick = Next1BtnClick
    end
  end
end
