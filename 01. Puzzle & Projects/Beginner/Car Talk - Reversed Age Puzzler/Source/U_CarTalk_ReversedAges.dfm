object Form1: TForm1
  Left = 202
  Top = 208
  Width = 826
  Height = 500
  Caption = 'Car Talk Puzzler - Reversed Ages'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Memo1: TMemo
    Left = 24
    Top = 24
    Width = 337
    Height = 385
    Color = 14811135
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      '"Car Talk" Puzzler March 29, 2008:'
      ''
      ''
      'Flipping Ages'
      ''
      ''
      'RAY:  This was sent in many weeks ago by Wendy'
      'Gladstone, and as usual I tweaked it a little bit. '
      ''
      'She writes: "Recently I had a visit with my mom and we '
      'realized that the two digits that make up my age when'
      'reversed resulted in her age.  For example, if she'#39's 73,'
      'I'#39'm 37. We wondered how ften this has happened over'
      'the years but we got sidetracked with other topics and'
      'we never came up with an answer.'
      ''
      '"When I got home I figured out that the digits of our'
      'ages have been reversible six times so far. I also figured'
      'out that if we'#39're lucky it would happen again in a few'
      'years, and if we'#39're really lucky it would happen one'
      'more time after that. In other words, it would have'
      'happened 8 times over all. So the question is, how old'
      'am I now?"'
      ' ')
    ParentFont = False
    TabOrder = 0
    OnChange = Memo1Change
  end
  object Button1: TButton
    Left = 392
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo2: TMemo
    Left = 528
    Top = 24
    Width = 257
    Height = 345
    Lines.Strings = (
      'Solutions:')
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 444
    Width = 810
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
  end
end
