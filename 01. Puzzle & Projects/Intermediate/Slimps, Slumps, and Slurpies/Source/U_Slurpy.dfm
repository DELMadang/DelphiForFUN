object Form1: TForm1
  Left = 114
  Top = 111
  Width = 640
  Height = 480
  Caption = 'Slurpies - from the 1996 Mid-Atlantic ACM Programming Contest'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 368
    Top = 8
    Width = 249
    Height = 345
    ItemHeight = 13
    Items.Strings = (
      '*These should be Slumps:  '
      'DFG'
      'EFG'
      'DFFFFFG'
      'DFEFFFFFFG'
      'DFDFDFDFG'
      ''
      '*These should be Slimps'
      'ABAHC'
      'ABABAHCC'
      'ADFGC'
      'ADFFFGC'
      'ABAEFGCC'
      'ADFDFGC'
      ''
      '*These should be Slurpies:'
      'AHDFG'
      'ADFGCDFFFFFG'
      'ABAEFGCCDFEFFFFFG'
      ''
      '*These are the test inputs from the contest'
      'AHDFG'
      'AEFGCDFDFG'
      'ABABABAHCCCDFG'
      'AHEFEFEFEFEFEFG'
      'AHDFEFG'
      'ABADFGCCEFEFG'
      'ABABAEFEFEFEFGCCCDFEFG'
      'QRST'
      'ABABABCCDFG'
      'ADFGCDFGC'
      'AHDFDFDFGGG'
      'ABCDFG'
      'ABABABCCCDFGG')
    TabOrder = 0
  end
  object TestBtn: TButton
    Left = 504
    Top = 408
    Width = 113
    Height = 25
    Caption = 'Test text'
    TabOrder = 1
    OnClick = TestBtnClick
  end
  object Edit1: TEdit
    Left = 368
    Top = 408
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 2
    Text = 'ABAHCEFEFEFEFG'
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 345
    Height = 417
    Color = clYellow
    Lines.Strings = (
      
        'A Slurpy is a string of  characters that has certain properties.' +
        '  Your'
      
        'program will read in strings of characters and output whether or' +
        ' not'
      'they are Slurpys (Slurpies?) .'
      ''
      
        'A Slump is a character string that has the following  properties' +
        ':'
      '1.   Its first character is either a '#39'D'#39' or an '#39'E'#39'.'
      
        '2.   The first character is followed by a string of one or more ' +
        #39'F'#39's.'
      
        '3.   The string of one or more '#39'F'#39's is followed by either a Slum' +
        'p or a'
      
        '      '#39'G'#39'.  The Slump or '#39'G'#39' that follows the F'#39's ends the Slump' +
        '.  '
      ''
      
        'A Slimp is a character string that has the following  properties' +
        ':'
      '1.   Its first character is an '#39'A'#39'.'
      
        '2.   If it is a two character Slimp then its second  and last ch' +
        'aracter is '
      '      an '#39'H'#39'.'
      
        '3.   If it is not a two character Slimp then it is in one of the' +
        'se two'
      '      forms:'
      
        '     a. '#39'A'#39' followed by '#39'B'#39' followed by a Slimp followed by a '#39'C' +
        #39'.'
      '     b. '#39'A'#39' followed by a Slump (see above)  followed by a '#39'C'#39'.'
      ''
      
        'A Slurpy is a character string that consists of a Slimp followed' +
        ' by a '
      'Slump.'
      ''
      
        'Recognizing strings that obey defined rules is one of the major ' +
        'tasks of '
      
        'a compiler.  So what we have here is the start of a "Slurpy" com' +
        'piler!'
      ''
      ''
      ''
      ''
      ''
      
        'Copyright 2002,  G. Darby,                          http://delph' +
        'iforfun.org')
    TabOrder = 3
  end
  object InitialTestBtn: TButton
    Left = 504
    Top = 368
    Width = 113
    Height = 25
    Caption = 'Test initial values'
    TabOrder = 4
    OnClick = InitialTestBtnClick
  end
end
