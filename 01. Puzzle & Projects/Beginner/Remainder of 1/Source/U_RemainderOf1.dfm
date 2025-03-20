object Form1: TForm1
  Left = 271
  Top = 91
  Width = 290
  Height = 443
  Caption = 'Remainder of 1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo3: TMemo
    Left = 16
    Top = 216
    Width = 257
    Height = 129
    Lines.Strings = (
      'Method 2:  Next number after LCM (lowest common '
      'multiple) of integers 2 through 12 will leave a '
      'remainder of 1 when divided by 2 through 12.  But it '
      'may not be a multiple of 13.  If not, we can add 1 to '
      'successive multiples of LCM until we find one that is '
      'a multiple of 13.'
      '')
    TabOrder = 4
  end
  object Memo2: TMemo
    Left = 16
    Top = 104
    Width = 249
    Height = 97
    Lines.Strings = (
      'Method 1: Check all odd mutliples of 13 up to '
      '100,000 looking for one leaving a remainder of 1 '
      'when divided by integers 2 through 12.')
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 249
    Height = 73
    Color = clYellow
    Lines.Strings = (
      'What is the smallest multiple of 13 which leaves a '
      'remainder of 1 when divided by each of the '
      'numbers 2 through 12?')
    TabOrder = 0
  end
  object SearchBtn1: TButton
    Left = 103
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Search #1'
    TabOrder = 1
    OnClick = SearchBtn1Click
  end
  object SearchBtn2: TButton
    Left = 103
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Search #2'
    TabOrder = 2
    OnClick = SearchBtn2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 377
    Width = 282
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright 2002, Gary Darby'
        Width = 50
      end>
    SimplePanel = False
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 396
    Width = 282
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'www.delphiforfun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
