object Form1: TForm1
  Left = 215
  Top = 121
  Width = 380
  Height = 245
  Caption = 'Squares and Cubes 3'
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
    Left = 248
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object Memo1: TMemo
    Left = 32
    Top = 24
    Width = 185
    Height = 105
    Color = clYellow
    Lines.Strings = (
      'There is a number which, when '
      'cubed is 2,000,000 larger than a '
      'number which is the square of a '
      'factor of 2,000,000'
      ''
      'What is the number?')
    TabOrder = 1
  end
end
