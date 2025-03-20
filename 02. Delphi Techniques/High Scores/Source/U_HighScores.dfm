object Form1: TForm1
  Left = 192
  Top = 133
  Width = 696
  Height = 480
  Caption = 'High Scores Test Program'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 376
    Top = 168
    Width = 141
    Height = 16
    Caption = 'Max # of scores to keep'
  end
  object Label4: TLabel
    Left = 24
    Top = 232
    Width = 71
    Height = 16
    Caption = 'Top Scores'
  end
  object ListBox1: TListBox
    Left = 24
    Top = 256
    Width = 177
    Height = 161
    ItemHeight = 16
    TabOrder = 0
  end
  object ClearBtnl: TButton
    Left = 376
    Top = 216
    Width = 75
    Height = 25
    Caption = 'Clear list'
    TabOrder = 1
    OnClick = ClearBtnlClick
  end
  object MaxScoresEdt: TSpinEdit
    Left = 528
    Top = 168
    Width = 41
    Height = 26
    MaxValue = 20
    MinValue = 1
    TabOrder = 2
    Value = 5
  end
  object GroupBox1: TGroupBox
    Left = 368
    Top = 24
    Width = 297
    Height = 121
    Caption = 'Enter score'
    TabOrder = 3
    object Label1: TLabel
      Left = 21
      Top = 20
      Width = 79
      Height = 16
      Caption = 'Player Name'
    end
    object Label2: TLabel
      Left = 21
      Top = 60
      Width = 36
      Height = 16
      Caption = 'Score'
    end
    object Edit1: TEdit
      Left = 104
      Top = 20
      Width = 177
      Height = 24
      TabOrder = 0
      Text = 'Player #1'
    end
    object SpinEdit1: TSpinEdit
      Left = 104
      Top = 51
      Width = 121
      Height = 26
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object AddScoreBtn: TButton
      Left = 72
      Top = 88
      Width = 121
      Height = 25
      Caption = 'Add  score'
      TabOrder = 2
      OnClick = AddScoreBtnClick
    end
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 289
    Height = 185
    Color = 14548991
    Lines.Strings = (
      'This is a test prgram for a "HighScores" object '
      'class.'
      ''
      'The specified number of highest scores are '
      'kept in descending order in a file and may be '
      'displayed as desired.'
      ''
      'In this sample, filename "Topscores.scr" is '
      'used to load and save scores in the same '
      'folder as the program executable.    ')
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 433
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object MaxBtn: TButton
    Left = 576
    Top = 168
    Width = 57
    Height = 25
    Caption = 'Go'
    TabOrder = 6
    OnClick = MaxBtnClick
  end
end
