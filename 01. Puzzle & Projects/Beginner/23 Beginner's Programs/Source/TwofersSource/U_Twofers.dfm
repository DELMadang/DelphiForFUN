object Form1: TForm1
  Left = 687
  Top = 195
  Width = 892
  Height = 594
  Caption = 'Twofers - "Two for the price of one"'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 19
  object Button1: TButton
    Left = 24
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 120
    Top = 136
    Width = 689
    Height = 121
    Lines.Strings = (
      
        'There are only two 2-digit Fahrenheit temperatures (i.e. between' +
        ' 10 and 99)  whose '
      
        'reversed digits give the rounded equivalent Centigrade value. Wh' +
        'at are they?'
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 120
    Top = 288
    Width = 689
    Height = 185
    Lines.Strings = (
      
        'What two pairs of positive integers,  K and M, satisfy the equat' +
        'ion 13K + 41M = 1000?     '
      ''
      
        '(This is from my Mensa Puzzle-A-Day calendar.  It had a note ind' +
        'icating that one '
      
        'solution was 13*58+41*6 and that there was a clever way  to dete' +
        'rmine the other'
      
        'solution.  Unfortunaltely my cat ate the page before I got aroun' +
        'd to turning it over '
      'to see the "clever" method.  Anyone have a clue?)')
    TabOrder = 2
  end
  object Button2: TButton
    Left = 24
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Memo3: TMemo
    Left = 120
    Top = 40
    Width = 689
    Height = 73
    Color = 14548991
    Lines.Strings = (
      
        'Here are two little problems each requiring only 10 to 15 lines ' +
        'of code to solve.  Each '
      'problem asks for the only two solutions to the given question.')
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 526
    Width = 874
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
