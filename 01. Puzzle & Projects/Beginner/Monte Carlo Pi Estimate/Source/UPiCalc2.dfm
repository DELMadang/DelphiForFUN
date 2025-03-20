object Form1: TForm1
  Left = 179
  Top = 104
  Width = 488
  Height = 480
  Caption = 'Yet Another Monte Carlo Estimate of PI'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 212
    Width = 34
    Height = 13
    Caption = 'Check '
  end
  object Label2: TLabel
    Left = 152
    Top = 212
    Width = 98
    Height = 13
    Caption = 'random integer pairs '
  end
  object CalcBtn: TButton
    Left = 48
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Calculate'
    TabOrder = 1
    OnClick = CalcBtnClick
  end
  object StopBtn: TButton
    Left = 16
    Top = 288
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    Visible = False
    OnClick = StopBtnClick
  end
  object Edit1: TEdit
    Left = 80
    Top = 208
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '100,000'
  end
  object Memo1: TMemo
    Left = 43
    Top = 16
    Width = 393
    Height = 169
    Color = clYellow
    Lines.Strings = (
      
        'The other day someone told me  that the probability that randoml' +
        'y chosen pairs of '
      'integers are relatively prime  is an interesting number.  '
      ''
      
        '"In fact," she said, " if we divide that probability into 6 and ' +
        'take the square root, '
      'the result is Pi!"'
      ''
      'Let'#39's check and see if that could be true.'
      ''
      
        '(Numbers are relatively prime if the have no common factors grea' +
        'ter than 1.  Pi is '
      'the ratio of the circumference of a circle to its diameter.) '
      '    ')
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 51
    Top = 288
    Width = 385
    Height = 137
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ResetBtn: TButton
    Left = 168
    Top = 248
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 4
    OnClick = ResetBtnClick
  end
  object ProgressBar1: TProgressBar
    Left = 288
    Top = 248
    Width = 150
    Height = 25
    BorderWidth = 1
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 5
  end
end
