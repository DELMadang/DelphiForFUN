object Form1: TForm1
  Left = 575
  Top = 210
  Width = 726
  Height = 566
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 72
    Top = 48
    Width = 561
    Height = 321
    Color = 15400959
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -20
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    Lines.Strings = (
      'Simple  demostration  program to copy text lines from an '
      'input file to an output file, deleting lines shorter than 40  '
      'characters.and truncating all others to 40 characters.  '
      'Input file name is "My Input file.txt" and out will be '
      'written to "My Output file.txt".'
      ''
      'Program has 25 lines of user written code, about half of  '
      'them for counting and displaying line counts.  The included '
      'input file is the Delphi source code for the program. '
      '============================='
      ' ')
    ParentFont = False
    TabOrder = 0
  end
  object Memo2: TMemo
    Left = 80
    Top = 400
    Width = 561
    Height = 57
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16711808
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsItalic]
    ParentFont = False
    TabOrder = 1
  end
end
