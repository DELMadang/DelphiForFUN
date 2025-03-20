object Form1: TForm1
  Left = 192
  Top = 107
  Width = 640
  Height = 480
  Caption = 'Pandigital Fractions'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 488
    Top = 16
    Width = 119
    Height = 25
    AutoSize = False
    Caption = 'Minimum integer values as found'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 488
    Top = 48
    Width = 107
    Height = 13
    Caption = 'f(A,B,C,D,E,F,G,H,I)=X'
  end
  object Button1: TButton
    Left = 16
    Top = 272
    Width = 241
    Height = 25
    Caption = 'A/BC+D/EF+G/HI=?'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 312
    Width = 241
    Height = 25
    Caption = 'A/(B*C)+D/(E*F)+G/(H*I)=?'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 488
    Top = 72
    Width = 129
    Height = 345
    ItemHeight = 13
    TabOrder = 2
  end
  object Button3: TButton
    Left = 16
    Top = 352
    Width = 241
    Height = 25
    Caption = '(A/B)*C+(D/E)*F+(G/H)*I=?'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 392
    Width = 241
    Height = 25
    Caption = '(A/B)^C+(D/E)^F+(G/H)^I=?'
    TabOrder = 4
    OnClick = Button4Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 441
    Height = 241
    Color = clYellow
    Lines.Strings = (
      'I recently received this email:'
      ''
      'Dear Delphiforfun,'
      ''
      
        'I have been investigating some variations on a classical problem' +
        ' involving pandigital '
      'fractions and wonder if you have seen solutions.'
      ''
      
        'Classical Problem -- I solved this one.  If each of the first 9 ' +
        'letters represents a different '
      
        'number--1 through 9, the smallest integer represented by: A/BC +' +
        ' D/EF + G/HI = 1; this '
      
        'assumes that the denominators are two-digit numbers and NOT mult' +
        'iplied.'
      ''
      'My Variations -- Need Verification of Solutions:'
      ''
      
        'I have modified the classical equation so that the denominators ' +
        'are multiplied as follows: '
      
        'A/(B*C)  + D/(E*F) + G/(H*I) and believe the smallest integral a' +
        'nswer is 2. Can you verify '
      'that?'
      ''
      
        'For (A/B)*C + (D/E)*F + (G/H)*I, I think the smallest integral a' +
        'nswer is 5.'
      ''
      
        'For (A/B)^C + (D/E)^F + (G/H)^I. the smallest ntegral answer I h' +
        'ave found is 1,100, but I '
      
        'suspect there is a smaller solution.  (The symbol "^" here repre' +
        'sents exponentiation, '
      'raised to a power.)'
      ''
      'Regards, Jerry'
      ''
      
        'Well Jerry, assuming that you are not a programmer and were doin' +
        'g this by hand,  1 '
      'correct out of 3 isn'#39't bad!'
      ''
      ' ')
    ScrollBars = ssVertical
    TabOrder = 6
  end
end
