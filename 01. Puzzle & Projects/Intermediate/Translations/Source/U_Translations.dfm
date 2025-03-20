object Form1: TForm1
  Left = 465
  Top = 250
  AutoScroll = False
  Caption = 'Translations:  Demonstration of multiple language support '
  ClientHeight = 643
  ClientWidth = 1033
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
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 1033
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1033
    Height = 620
    Align = alClient
    Color = 14548991
    TabOrder = 1
    object Label1: TLabel
      Left = 234
      Top = 65
      Width = 436
      Height = 89
      Caption = 'Hello World!'
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -80
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 440
      Top = 336
      Width = 169
      Height = 23
      Caption = 'Locale language is '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 440
      Top = 376
      Width = 176
      Height = 23
      Caption = 'Current language is '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object ChangeBtn: TButton
      Left = 49
      Top = 259
      Width = 336
      Height = 29
      Caption = 'Change the message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ChangeBtnClick
    end
    object LanguageGrp: TRadioGroup
      Left = 40
      Top = 328
      Width = 353
      Height = 193
      Caption = 'Select a different language'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'English'
        'French'
        'German'
        'Spanish'
        'Southern USA')
      ParentFont = False
      TabOrder = 1
      OnClick = LanguageGrpClick
    end
    object Memo1: TMemo
      Left = 680
      Top = 488
      Width = 321
      Height = 113
      Cursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      Lines.Strings = (
        'Click this link to visit the DFF webpage '
        'with details about adding multi-language'
        'support to your Delphi programs.'
        '')
      ParentFont = False
      TabOrder = 2
      OnClick = Memo1Click
    end
  end
end
