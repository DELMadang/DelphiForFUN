object Form1: TForm1
  Left = 365
  Top = 126
  Width = 800
  Height = 600
  Caption = 'Form1'
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
    Left = 624
    Top = 16
    Width = 121
    Height = 25
    AutoSize = False
    Caption = 'Files to play for each sentence'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 384
    Top = 224
    Width = 165
    Height = 42
    Caption = 
      'For testing - display start and end character positions of each ' +
      'sentence'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 376
    Top = 32
    Width = 176
    Height = 14
    Caption = 'Click a sentence to play the MP3 filef'
  end
  object RichEdit1: TRichEdit
    Left = 376
    Top = 48
    Width = 233
    Height = 137
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This sentence will play a ding-'
      'dong sound when clicked .  This '
      'sentence will play the Morse '
      'Code  sound.')
    ParentFont = False
    TabOrder = 0
    OnMouseUp = RichEdit1MouseUp
  end
  object ListBox1: TListBox
    Left = 624
    Top = 48
    Width = 145
    Height = 97
    ItemHeight = 14
    Items.Strings = (
      'Ding_dong.MP3'
      'Morse.mp3')
    TabOrder = 1
  end
  object StringGrid1: TStringGrid
    Left = 384
    Top = 272
    Width = 201
    Height = 120
    ColCount = 2
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 2
    ColWidths = (
      64
      64)
  end
  object Memo1: TMemo
    Left = 32
    Top = 40
    Width = 329
    Height = 401
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This program illustrates Delphi code which '
      'will respond to clicks on a particular sentence '
      'in a Rich Edit control by playing the '
      'corresponding MP3 file name contained in '
      'another list.')
    ParentFont = False
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 544
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
end
