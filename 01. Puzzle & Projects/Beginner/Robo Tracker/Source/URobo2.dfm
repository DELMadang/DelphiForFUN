object Form1: TForm1
  Left = 52
  Top = 77
  Width = 698
  Height = 480
  Caption = 'Click and drag mouse to draw a track '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 16
  object Robo: TShape
    Left = 586
    Top = 98
    Width = 40
    Height = 41
    Brush.Color = clLime
    Shape = stCircle
  end
  object ResetBtn: TButton
    Left = 572
    Top = 26
    Width = 75
    Height = 24
    Caption = 'Reset'
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object StartBtn: TButton
    Left = 572
    Top = 57
    Width = 75
    Height = 24
    Caption = 'Start'
    TabOrder = 1
    OnClick = StartBtnClick
  end
end
