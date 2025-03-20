object Form1: TForm1
  Left = 3
  Top = 5
  Width = 696
  Height = 480
  Caption = 'Four-in-a-row'
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
  object MoveLbl: TLabel
    Left = 200
    Top = 16
    Width = 457
    Height = 49
    AutoSize = False
    Caption = 
      'Player 1: To move, drag the red token over  the selected column ' +
      'and realease.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object ResetBtn: TButton
    Left = 24
    Top = 312
    Width = 121
    Height = 25
    Caption = 'New Game'
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object Panel1: TPanel
    Left = 200
    Top = 72
    Width = 457
    Height = 329
    TabOrder = 1
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 455
      Height = 327
      Align = alClient
    end
    object NewChip: TShape
      Left = 0
      Top = 0
      Width = 65
      Height = 65
      Shape = stCircle
      Visible = False
      OnMouseDown = TokenMouseDown
      OnMouseMove = TokenMouseMove
      OnMouseUp = TokenMouseUp
    end
  end
  object RandomBtn: TButton
    Left = 24
    Top = 352
    Width = 121
    Height = 25
    Caption = 'Play Random Game'
    TabOrder = 2
    OnClick = RandomBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 72
    Width = 169
    Height = 193
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'The objective of '
      'Four-In-A-Row is to get 4 '
      'tokens in a row across, '
      'vertically, or diagonally.   '
      ''
      'Players take turns and the '
      'first to get four in a row is the '
      'winner. '
      ''
      'How hard can it be?')
    ParentFont = False
    TabOrder = 3
  end
  object RetractBtn: TButton
    Left = 24
    Top = 392
    Width = 121
    Height = 25
    Caption = 'Take back last move'
    TabOrder = 4
    OnClick = RetractBtnClick
  end
end
