object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 160
    Top = 64
    Width = 249
    Height = 105
    Caption = 'Drag colors from here'
    TabOrder = 0
    object Shape4: TShape
      Left = 16
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clRed
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape5: TShape
      Left = 72
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clYellow
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape6: TShape
      Left = 128
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clLime
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape7: TShape
      Left = 184
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clBlue
      DragMode = dmAutomatic
      Shape = stCircle
    end
  end
  object GroupBox2: TGroupBox
    Left = 160
    Top = 184
    Width = 193
    Height = 89
    Caption = 'To a circle here'
    TabOrder = 1
    object Shape1: TShape
      Left = 120
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
    object Shape2: TShape
      Left = 64
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
    object Shape3: TShape
      Left = 8
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
  end
end
