object Form1: TForm1
  Left = 69
  Top = 73
  Width = 698
  Height = 480
  Caption = 'Click and drag to draw a path, click Start to make Robo eat it'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnMouseDown = Paintbox1MouseDown
  OnMouseMove = Paintbox1MouseMove
  OnMouseUp = Paintbox1MouseUp
  PixelsPerInch = 96
  TextHeight = 16
  object Robo: TShape
    Left = 608
    Top = 128
    Width = 41
    Height = 41
    Brush.Color = clLime
    Shape = stCircle
  end
  object StartBtn: TButton
    Left = 576
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartBtnClick
  end
end
