object Form1: TForm1
  Left = 118
  Top = 144
  Width = 428
  Height = 375
  Caption = 'Drag the trackbar pointer to rotate the square'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 20
  object Shape1: TShape
    Left = 256
    Top = 96
    Width = 65
    Height = 65
    Brush.Color = clAqua
    Shape = stCircle
  end
  object Label1: TLabel
    Left = 120
    Top = 152
    Width = 9
    Height = 20
    Caption = '0'
  end
  object Label2: TLabel
    Left = 48
    Top = 152
    Width = 41
    Height = 20
    Caption = 'Angle'
  end
  object TBar: TTrackBar
    Left = 40
    Top = 96
    Width = 150
    Height = 45
    Hint = #39'Drag bar to rotate the square'
    Max = 180
    Orientation = trHorizontal
    PageSize = 10
    Frequency = 10
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 0
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = TBarChange
  end
end
