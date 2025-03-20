object Form1: TForm1
  Left = 134
  Top = 157
  Width = 777
  Height = 526
  Caption = 'Kirkman'#39's Schoolgirl Problem (V1.0)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 336
    Top = 424
    Width = 3
    Height = 13
  end
  object SearchBtn: TButton
    Left = 16
    Top = 424
    Width = 113
    Height = 25
    Caption = 'Search for solutions'
    TabOrder = 0
    OnClick = SearchBtnClick
  end
  object ListBox1: TListBox
    Left = 320
    Top = 8
    Width = 433
    Height = 401
    ItemHeight = 13
    TabOrder = 1
  end
  object SaveBtn: TButton
    Left = 192
    Top = 424
    Width = 113
    Height = 25
    Caption = 'Save solutions'
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 289
    Height = 401
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Fifteen young ladies of a school walk out three'
      'abreast for seven days in succession: it is'
      'required to arrange them daily so that no two'
      'shall walk abreast more than once.'
      ''
      'The problem was proposed and solved by '
      'Thomas Kirkman in 1850,  (All 7 unique solutions '
      '- without the assistance of a multi-gigherz '
      'computer!)'
      ''
      'This version finds solutions at about the rate of '
      'one per munte  but does not yet identify '
      'isomorphic solutions - those which are merely '
      'renamings of the girls in earlier solutions.  We '
      'need to have something to work on for the next '
      'few months!'
      ''
      'There is a button to save solutions for future '
      'work on sorting out those that are unique.   '
      ''
      'Watch for Kirkman V2.0 at some future date.')
    ParentFont = False
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 479
    Width = 769
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object SaveDialog1: TSaveDialog
    Left = 640
    Top = 24
  end
end
