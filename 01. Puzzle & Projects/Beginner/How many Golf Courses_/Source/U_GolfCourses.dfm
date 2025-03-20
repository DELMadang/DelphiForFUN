object Form1: TForm1
  Left = 35
  Top = 58
  Width = 590
  Height = 480
  Caption = 'How many golf courses?'
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
    Left = 384
    Top = 32
    Width = 77
    Height = 13
    Caption = 'Number of holes'
  end
  object Label2: TLabel
    Left = 488
    Top = 32
    Width = 42
    Height = 13
    Caption = 'Total par'
  end
  object Label3: TLabel
    Left = 384
    Top = 240
    Width = 145
    Height = 33
    AutoSize = False
    Caption = 'Copyright 2002, Gary  Darby      www.delphiforfun.org'
    WordWrap = True
  end
  object SolveBtn: TButton
    Left = 384
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 288
    Width = 561
    Height = 153
    ItemHeight = 13
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 353
    Height = 265
    Color = clYellow
    Lines.Strings = (
      
        'A championship 18 hole golf course  has holes with a par scores ' +
        'of 3, 4, '
      'or 5 strokes and a total par for the couse of 72 strokes.'
      ''
      
        'So how many different combinations of holes could there be that ' +
        'meet '
      
        'these conditions?  (For extra credit, how many arrangements of e' +
        'ach of '
      'the possible combinations?)'
      ''
      
        'For example: some of the  courses would have one par 3, sixteen ' +
        'par 4'#39's '
      
        'and one par 5 holes.  The par 3 could be at any of the 18 holes ' +
        'and the  '
      
        'par 5 at any of the remaining 17, for a total of 18X17 or 306 ar' +
        'rangements '
      'of this combination.'
      ''
      
        'In general if we have A par 3'#39's and B par 4'#39's then the number of' +
        ' '
      
        'arrangements is the number of unique ways we could select A of t' +
        'he 18 '
      
        'holes times the number of unique ways we could select B from the' +
        ' '
      
        'remaining 18-A holes.  Then the remaining 18-A-B holes are the p' +
        'ar 5'#39's of '
      
        'course..  (A and B could represent the counts of any two par val' +
        'ues,  '
      'answer will be the same)'
      ' '
      ''
      '')
    TabOrder = 2
  end
  object HolesEdt: TSpinEdit
    Left = 384
    Top = 56
    Width = 49
    Height = 22
    MaxValue = 19
    MinValue = 1
    TabOrder = 3
    Value = 18
  end
  object ParEdt: TSpinEdit
    Left = 488
    Top = 56
    Width = 57
    Height = 22
    MaxValue = 144
    MinValue = 1
    TabOrder = 4
    Value = 72
  end
end
