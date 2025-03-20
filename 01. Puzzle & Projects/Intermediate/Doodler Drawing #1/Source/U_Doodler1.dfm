object Form1: TForm1
  Left = 59
  Top = 96
  Width = 640
  Height = 480
  Caption = 'Form1'
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
  object PaintBox1: TPaintBox
    Left = 176
    Top = 8
    Width = 441
    Height = 441
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    OnPaint = PaintBox1Paint
  end
  object Label1: TLabel
    Left = 8
    Top = 152
    Width = 88
    Height = 20
    Caption = 'Pen Width:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ResetBtn: TButton
    Left = 16
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object WidthUD: TUpDown
    Left = 137
    Top = 152
    Width = 9
    Height = 21
    Associate = Edit1
    Min = 1
    Max = 10
    Position = 3
    TabOrder = 1
    Wrap = False
  end
  object Edit1: TEdit
    Left = 104
    Top = 152
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '3'
  end
  object PenColor: TStaticText
    Left = 8
    Top = 104
    Width = 149
    Height = 24
    BorderStyle = sbsSunken
    Caption = ' Select Pen Color '
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    OnClick = PenColorClick
  end
  object NumDivsGrp: TRadioGroup
    Left = 16
    Top = 200
    Width = 113
    Height = 81
    Caption = 'Number of Divisions'
    ItemIndex = 1
    Items.Strings = (
      '1'
      '4'
      '8')
    TabOrder = 4
    OnClick = NumDivsGrpClick
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 120
  end
end
