object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  Caption = 'Word Squares Search'
  ClientHeight = 620
  ClientWidth = 802
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
  object StaticText1: TStaticText
    Left = 0
    Top = 597
    Width = 802
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
    Width = 802
    Height = 597
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 592
      Top = 80
      Width = 145
      Height = 41
      AutoSize = False
      Caption = 'Enter  the 1st word of  word squares to build'
      WordWrap = True
    end
    object SearchBtn: TButton
      Left = 596
      Top = 155
      Width = 86
      Height = 29
      Caption = 'Search'
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object Memo1: TMemo
      Left = 41
      Top = 30
      Width = 528
      Height = 491
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '"Word Squares" are square word arrays which read '
        'the same horizontally and vertically.  According '
        'to Wikipedia, they have likely existed for more '
        'than 2000 years.'
        ''
        'In English, here are few small examples:.'
        ''
        'A       NO      CAT'
        '        OF      AGE'
        '                TEA'
        ''
        'Puzzles larger than 8x8 are rare and frequently '
        'must include foreign or obscure words.  This '
        'program, writtern as a programming exercise, uses '
        'our 62,000 word dictionary to search for word '
        'squares based on an intial word provided by the '
        'user.  It takes a few minutes to search for '
        'squares of 8x8.  I haven'#39't had any luck finding '
        '8x8 squares and have not tried any larger sizes.'
        ''
        'Program "DicMaint" found on our website can be '
        'used to add additional words to the dictionary '
        'file included here.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 592
      Top = 120
      Width = 121
      Height = 24
      CharCase = ecUpperCase
      TabOrder = 2
      Text = 'BIT'
      OnClick = SearchBtnClick
    end
    object StopPanel: TPanel
      Left = 592
      Top = 192
      Width = 161
      Height = 121
      Caption = 'STOP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Visible = False
      OnClick = StopPanelClick
    end
  end
end
