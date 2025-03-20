object Form1: TForm1
  Left = 164
  Top = 114
  Width = 800
  Height = 532
  Caption = 'Concentration'
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 20
  object Label2: TLabel
    Left = 432
    Top = 328
    Width = 113
    Height = 20
    Caption = 'Number of Pairs'
  end
  object Label3: TLabel
    Left = 432
    Top = 384
    Width = 279
    Height = 20
    Caption = 'Number of games to play (1 to 100,000)'
  end
  object Label1: TLabel
    Left = 440
    Top = 72
    Width = 102
    Height = 20
    Caption = 'Games played'
  end
  object Label4: TLabel
    Left = 392
    Top = 112
    Width = 151
    Height = 20
    Caption = 'Average game length'
  end
  object Label5: TLabel
    Left = 352
    Top = 152
    Width = 194
    Height = 20
    Caption = 'Avg. game length/ Nbr pairs'
  end
  object Label6: TLabel
    Left = 384
    Top = 192
    Width = 175
    Height = 20
    Caption = 'Minimum game guesses '
  end
  object Label7: TLabel
    Left = 384
    Top = 232
    Width = 175
    Height = 20
    Caption = 'Maximum game guesses'
  end
  object StartBtn: TButton
    Left = 584
    Top = 416
    Width = 105
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object PairsEdt: TSpinEdit
    Left = 432
    Top = 352
    Width = 49
    Height = 30
    MaxValue = 20
    MinValue = 1
    TabOrder = 1
    Value = 10
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 478
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 313
    Height = 417
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'While completing a Delphi verson of the memory'
      'game of Concentration, the question of expected'
      'game length came to mind.'
      ''
      'In Concentration, two cards are turned from face '
      'down to face up in each move with the objective of '
      'finding two matching cards.  If a match is found, the '
      'cards are removed from the field.  If no match is '
      'found, the two cards are turned back to face'
      'down.'
      ''
      'A game that begins with N facedown pairs will'
      'require at least N moves to find the pairs.  If a player'
      'were exceptionally unlucky, it might take a many'
      'as 2N-1 moves to find all of the pairs, even with'
      'perfect memory of the locations of cards already '
      'viewed.  The simple view is that the mean "perfect '
      'memory" game length should be slightly less than '
      '1.5N (half way between N and 2N-1).  It looks from '
      'the results here that the number is slightly  more than '
      '1.5N.  Logic error or programming bug?  There must '
      'be more ways to be perfectly unlucky than there are '
      'ways to be perfectly lucky.   I'#39'm waiting for someone '
      'to analyze the game and let me know.'
      '.'
      '  '
      ' ')
    ParentFont = False
    TabOrder = 3
  end
  object GamesEdt: TSpinEdit
    Left = 432
    Top = 408
    Width = 81
    Height = 30
    MaxValue = 100000
    MinValue = 1
    TabOrder = 4
    Value = 10000
  end
  object Edit1: TEdit
    Left = 576
    Top = 64
    Width = 89
    Height = 28
    ReadOnly = True
    TabOrder = 5
    Text = '0'
  end
  object Edit2: TEdit
    Left = 576
    Top = 104
    Width = 89
    Height = 28
    ReadOnly = True
    TabOrder = 6
    Text = '0'
  end
  object Edit3: TEdit
    Left = 576
    Top = 144
    Width = 89
    Height = 28
    ReadOnly = True
    TabOrder = 7
    Text = '0'
  end
  object Edit4: TEdit
    Left = 576
    Top = 184
    Width = 89
    Height = 28
    ReadOnly = True
    TabOrder = 8
    Text = '0'
  end
  object Edit5: TEdit
    Left = 576
    Top = 224
    Width = 89
    Height = 28
    ReadOnly = True
    TabOrder = 9
    Text = '0'
  end
end
