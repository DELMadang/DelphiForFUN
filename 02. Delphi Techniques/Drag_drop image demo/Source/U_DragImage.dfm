object Form1: TForm1
  Left = 199
  Top = 104
  Width = 696
  Height = 637
  Caption = 'Drag Image Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 41
    Width = 185
    Height = 549
    Align = alLeft
    TabOrder = 0
    object Shape1: TShape
      Left = 16
      Top = 368
      Width = 100
      Height = 90
      Brush.Color = clYellow
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape2: TShape
      Left = 24
      Top = 16
      Width = 50
      Height = 90
      Brush.Color = clMaroon
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape3: TShape
      Left = 16
      Top = 112
      Width = 100
      Height = 73
      Brush.Color = 16777088
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape4: TShape
      Left = 16
      Top = 208
      Width = 100
      Height = 90
      Brush.Color = clRed
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape5: TShape
      Left = 16
      Top = 312
      Width = 100
      Height = 40
      Brush.Color = clBlue
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape6: TShape
      Left = 16
      Top = 472
      Width = 50
      Height = 90
      Brush.Color = clPurple
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape7: TShape
      Left = 16
      Top = 576
      Width = 136
      Height = 90
      Brush.Color = 4227072
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
    object Shape8: TShape
      Left = 16
      Top = 679
      Width = 136
      Height = 70
      Brush.Color = 16744703
      DragMode = dmAutomatic
      OnDragDrop = Shape1DragDrop
      OnDragOver = Shape1DragOver
      OnStartDrag = Shape1StartDrag
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 41
    Align = alTop
    TabOrder = 1
    object SnapBox: TCheckBox
      Left = 424
      Top = 8
      Width = 185
      Height = 17
      Caption = 'Snap dropped panels up and  left'
      TabOrder = 0
      OnClick = SnapBoxClick
    end
  end
  object ScrollBox2: TScrollBox
    Left = 185
    Top = 41
    Width = 503
    Height = 549
    Align = alClient
    TabOrder = 2
    object Panel2: TPanel
      Left = 40
      Top = 24
      Width = 400
      Height = 193
      TabOrder = 0
    end
    object Panel3: TPanel
      Left = 56
      Top = 400
      Width = 425
      Height = 169
      TabOrder = 1
    end
    object Memo1: TMemo
      Left = 40
      Top = 240
      Width = 401
      Height = 137
      Color = 14548991
      Lines.Strings = (
        
          'Drag/Drop demo - drag colored shapes in the lefthand scrollbox t' +
          'o the panels in the '
        
          'righthand scrollbox.   Dropping is allowed only if the shape bei' +
          'ng dropped is wholly '
        
          'within the panel and does not overlap any other shape already pl' +
          'aced.'
        ''
        
          'Dropped shapes may be "snapped" into place  - moving as up and l' +
          'eft as possible '
        'without overlapping other shapes on the panel '
        ''
        ' ')
      TabOrder = 2
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 590
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object DragImageList: TImageList
    Left = 643
    Top = 211
  end
end
