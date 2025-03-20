object Form1: TForm1
  Left = 263
  Top = 103
  Width = 696
  Height = 480
  Caption = 'Cupid'#39's Arrows'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object C1: TShape
    Left = 56
    Top = 328
    Width = 33
    Height = 30
    Shape = stCircle
  end
  object C2: TShape
    Left = 152
    Top = 264
    Width = 33
    Height = 30
    Shape = stCircle
  end
  object C3: TShape
    Left = 200
    Top = 328
    Width = 33
    Height = 30
    Shape = stCircle
  end
  object C4: TShape
    Left = 152
    Top = 392
    Width = 33
    Height = 30
    Shape = stCircle
  end
  object C5: TShape
    Left = 152
    Top = 328
    Width = 33
    Height = 30
    Shape = stCircle
  end
  object Label1: TLabel
    Left = 392
    Top = 16
    Width = 43
    Height = 13
    Caption = 'Solutions'
  end
  object SolveBtn: TButton
    Left = 376
    Top = 360
    Width = 209
    Height = 25
    Caption = 'Search for solutions'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object ListBox1: TListBox
    Left = 376
    Top = 40
    Width = 289
    Height = 313
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 337
    Height = 233
    Color = clYellow
    Lines.Strings = (
      
        'Selecting from the numbers 1 through 9, place one digit in each ' +
        'of the'
      'circles on Cupid'#39's bow according to the following rule:'
      ''
      
        'Each pair of digits connnected by a black line (the bow and arro' +
        'w) '
      
        'must form a 2-digit number that is evenly divisible by 7 or 13, ' +
        ' For '
      
        'example 7 and 8 connected by a line would be appropriate because' +
        ' '
      
        'the number 78 is divisible by 13.  You can consider the 2 digits' +
        ' in '
      'either order and each circle must contain a different digit.'
      ''
      
        '"For every solution you find" said Cupid before flying off, "you' +
        ' win'
      'someone'#39's heart. If you can find a solution in which the numbers'
      
        'connected by the bow string (the blue lines) qualify as well,  y' +
        'ou will '
      
        'always be in love!"   Try it yourself before clicking the "Searc' +
        'h" '
      'button!'
      ''
      'Adapted from "Wonders of Numbers", Clifford Pickover'
      ' '
      ' ')
    TabOrder = 2
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 427
    Width = 688
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
