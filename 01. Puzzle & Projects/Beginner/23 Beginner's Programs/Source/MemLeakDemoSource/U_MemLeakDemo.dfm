object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'Memory Leak Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 384
    Top = 16
    Width = 289
    Height = 345
    Lines.Strings = (
      'Allocated memory bytes')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 288
    Width = 249
    Height = 25
    Caption = 'Allocate 1 New record without Dispose '
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 24
    Top = 323
    Width = 249
    Height = 25
    Caption = 'Allocate 1 New record with Dispose '
    TabOrder = 2
    OnClick = Button2Click
  end
  object Memo2: TMemo
    Left = 16
    Top = 8
    Width = 321
    Height = 265
    Color = 14548991
    Lines.Strings = (
      
        'Even though the use of records and pointers is less critical tod' +
        'ay '
      
        'than in the pre-object days, some schools still teach their use.' +
        '  '
      ''
      
        'The cardinal rule when allocating memory within your program is ' +
        'to '
      'make sure that it gets released.  One common way to create a  '
      
        'memory leak if to allocate a record using the New function and n' +
        'ot '
      'releasing the memory (using Dispose).   '
      ''
      
        'Students are sometimes confused by the fact that local variables' +
        ' '
      'within functions and procedure are automatically released by '
      
        'Delphi when you exit.  This applies to all of the memory that De' +
        'lphi '
      
        'allocated on your behalf, but not to the memory you allocated.  ' +
        'If '
      
        'you have local varialble, P, and execute New(P) within the routi' +
        'ne, '
      
        ' Delphi will delete the 4 bytes occupied by P, but not the memor' +
        'y '
      'that P points to!   '
      ''
      'Here'#39's a program that allocates 1000 byte  records within a '
      
        'procedure with and without releasing them just to illustrate the' +
        ' '
      'problem.'
      ' ')
    TabOrder = 3
  end
  object Button3: TButton
    Left = 24
    Top = 357
    Width = 249
    Height = 25
    Caption = 'Allocate 10 New records without Dispose '
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 24
    Top = 392
    Width = 249
    Height = 25
    Caption = 'Allocate 10 New records with Dispose '
    TabOrder = 5
    OnClick = Button4Click
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 433
    Width = 688
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
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
