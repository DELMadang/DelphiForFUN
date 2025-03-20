object Form1: TForm1
  Left = 365
  Top = 121
  Width = 863
  Height = 556
  Caption = 'Perfect Square Dance'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 528
    Top = 8
    Width = 289
    Height = 65
    AutoSize = False
    Caption = 
      'We'#39'll search in multiple passes for pairs that can form a perfec' +
      't square in only one way and eliminate them from other possible ' +
      'pairings'
    WordWrap = True
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 500
    Width = 847
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
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 361
    Height = 441
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '(From "Car Talk Puzzler" for October 19, 2008:'
      'http://www.cartalk.com/content/puzzler/)'
      ''
      '"RAY: Sally invited 17 guests to a dance party at her estate '
      'in the Hamptons. She assigned each guest a number from 2 '
      'to 18, keeping 1 for herself. '
      ''
      'At one point in the evening when everyone was dancing,'
      'Sally noticed the sum of each couple'#39's numbers was a'
      'perfect square. Everyone was wearing their numbers on their'
      'clothing.'
      ''
      'The question is, what was the number of Sally'#39's partner?'
      ''
      'Here'#39's a reminder: a perfect square is attained by squaring,'
      'or multiplying by itself, an integer. So four is a perfect'
      'square of two. Nine is a perfect square of three. Sixteen is a'
      'perfect square of four. So these numbers are adding up to'
      'either 4, 9, 16, 25, etc.'
      ''
      'And the question is, with the information you have available'
      'to you, what'#39's the number of her partner?"')
    ParentFont = False
    TabOrder = 1
  end
  object SolveBtn: TButton
    Left = 400
    Top = 16
    Width = 105
    Height = 25
    Caption = 'Search'
    TabOrder = 2
    OnClick = SolveBtnClick
  end
  object possiblepairs: TListBox
    Left = 528
    Top = 72
    Width = 297
    Height = 385
    ItemHeight = 16
    TabOrder = 3
  end
  object Verbose: TCheckBox
    Left = 400
    Top = 72
    Width = 121
    Height = 17
    Caption = 'Show progress'
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
