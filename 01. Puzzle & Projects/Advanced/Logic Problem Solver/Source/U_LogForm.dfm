object Logform: TLogform
  Left = 303
  Top = 120
  Width = 1142
  Height = 744
  Caption = 'Logform'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object InfoMemo: TMemo
    Left = 20
    Top = 8
    Width = 748
    Height = 64
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The log file display shows all program decisions leading to to t' +
        'ruth table changesin the order they were made. '
      ''
      
        ' It'#39's intended for advanced debugging and not for the faint of h' +
        'eart!')
    ParentFont = False
    TabOrder = 0
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 689
    Width = 1134
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, 2012  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object LogMemo: TRichEdit
    Left = 0
    Top = 179
    Width = 1134
    Height = 510
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Decisions made during the solution searches are displayed here.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object FindBtn: TButton
    Left = 774
    Top = 52
    Width = 130
    Height = 20
    Caption = 'Find text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = FindBtnClick
  end
  object FindDialog1: TFindDialog
    Options = [frDown, frHideUpDown]
    OnFind = FindDialog1Find
    Left = 1085
    Top = 17
  end
end
