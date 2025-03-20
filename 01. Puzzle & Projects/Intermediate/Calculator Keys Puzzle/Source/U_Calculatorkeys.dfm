object Form1: TForm1
  Left = 192
  Top = 107
  Width = 510
  Height = 490
  Caption = 'Calculator Keyboard'
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
  object AnsLbl: TLabel
    Left = 272
    Top = 208
    Width = 5
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 4194432
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 225
    Height = 409
    Lines.Strings = (
      'Adapted from '#39'Giant Book of Mensa Mind '
      'Challenges'#39
      ''
      'The professor noticed that the keys on his '
      'calculator formed an equation, but not one '
      'that was true.'
      ''
      '           7 8 9'
      '        -  4 5 6'
      '        =  1 2 3'
      ''
      'But if he interchanged  pairs of keys two times '
      'he could make a valid equation.   Can you find '
      'the  2 pairs of keys  to swap to  equation  '
      'true?  (Click the 1st key of each pair to swap, '
      'then the 2nd to perform the swap.)'
      ''
      'Hint: There are two solutions and each '
      'involves "borrowing" in the subtraction.'
      ' ---------------------------------------------------------------')
    TabOrder = 0
  end
  object SolveBtn: TButton
    Left = 280
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Solve'
    TabOrder = 1
    OnClick = SolveBtnClick
  end
  object Button1: TButton
    Tag = 7
    Left = 328
    Top = 40
    Width = 33
    Height = 33
    Caption = '7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = KeyBtnClick
  end
  object Button2: TButton
    Tag = 8
    Left = 376
    Top = 40
    Width = 33
    Height = 33
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = KeyBtnClick
  end
  object Button5: TButton
    Tag = 5
    Left = 376
    Top = 88
    Width = 33
    Height = 33
    Caption = '5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = KeyBtnClick
  end
  object ButtonM: TButton
    Left = 280
    Top = 88
    Width = 33
    Height = 33
    Caption = '-'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
  end
  object Button4: TButton
    Tag = 4
    Left = 328
    Top = 88
    Width = 33
    Height = 33
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = KeyBtnClick
  end
  object Button8: TButton
    Tag = 2
    Left = 376
    Top = 136
    Width = 33
    Height = 33
    Caption = '2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = KeyBtnClick
  end
  object ButtonE: TButton
    Left = 280
    Top = 136
    Width = 33
    Height = 33
    Caption = '='
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
  end
  object Button7: TButton
    Tag = 1
    Left = 328
    Top = 136
    Width = 33
    Height = 33
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = KeyBtnClick
  end
  object Button3: TButton
    Tag = 9
    Left = 424
    Top = 40
    Width = 33
    Height = 33
    Caption = '9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    OnClick = KeyBtnClick
  end
  object Button6: TButton
    Tag = 6
    Left = 424
    Top = 88
    Width = 33
    Height = 33
    Caption = '6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    OnClick = KeyBtnClick
  end
  object Button9: TButton
    Tag = 3
    Left = 424
    Top = 136
    Width = 33
    Height = 33
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    OnClick = KeyBtnClick
  end
  object ResetBtn: TButton
    Left = 384
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 13
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 443
    Width = 502
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 14
    OnClick = StaticText1Click
  end
end
