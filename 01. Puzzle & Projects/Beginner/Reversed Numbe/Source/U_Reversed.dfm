object Form1: TForm1
  Left = 29
  Top = 40
  Width = 363
  Height = 480
  Caption = 'Reversed Numbers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SolveBtn: TButton
    Left = 24
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 336
    Width = 185
    Height = 89
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 16
    Top = 16
    Width = 297
    Height = 257
    Color = clYellow
    Lines.Strings = (
      'Find a six digit number which, when multiplied by an integer '
      'between 2 and 9 inclusive, gives the original six digit number '
      'with it'#39's digits reversed.'
      ''
      'Thus, for example, if the original number was 123456, and the '
      'chosen integer was 8, then 123456 X 8 should equal 654321, '
      'which of course it doesn'#39't.    It is possible to find more than '
      'one  solution to the problem, but I'#39'll accept any one that '
      'meets the  required condition.'
      ''
      'Source:  Math and Logic Puzzles for PC Enthusiasts, '
      '              J. J.  Clessa.  Problem # 34.')
    TabOrder = 2
  end
end
