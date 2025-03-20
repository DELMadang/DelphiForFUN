object Form2: TForm2
  Left = 137
  Top = 79
  Width = 640
  Height = 480
  Caption = 'Balance Beam Scale'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDragDrop = WeightDragDrop
  OnDragOver = WeightDragOver
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 16
    Top = 160
    Width = 505
    Height = 265
    Visible = False
  end
  object Label1: TLabel
    Left = 216
    Top = 32
    Width = 87
    Height = 16
    Caption = 'Known weights'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 440
    Top = 16
    Width = 177
    Height = 49
    AutoSize = False
    Caption = 'Unknown weight (drag to a weight pan if it'#39's not already there)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 185
    Height = 113
    Color = clYellow
    Lines.Strings = (
      'Now that we have the best set of '
      'weights, try some weighings.  Drag  '
      'and drop the unknown weight and '
      'the known weights onto either pan of '
      'the balance beam scale until it '
      'balances.')
    TabOrder = 0
  end
  object W1: TStaticText
    Tag = 1
    Left = 224
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '1'
    Color = 15130267
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object Unknownweight: TStaticText
    Tag = 4
    Left = 520
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSingle
    Caption = '?'
    Color = 8453888
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object W2: TStaticText
    Tag = 3
    Left = 266
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '3'
    Color = 15130267
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 3
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object UnknownWeightBtn: TButton
    Left = 488
    Top = 120
    Width = 129
    Height = 25
    Caption = 'Get new unknown weight'
    TabOrder = 4
    OnClick = UnknownWeightBtnClick
  end
  object W3: TStaticText
    Tag = 9
    Left = 308
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '9'
    Color = 15130267
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 5
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object W4: TStaticText
    Tag = 27
    Left = 350
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '27'
    Color = 15130267
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 6
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object W5: TStaticText
    Tag = 81
    Left = 392
    Top = 64
    Width = 27
    Height = 28
    Alignment = taCenter
    AutoSize = False
    BorderStyle = sbsSunken
    Caption = '81'
    Color = 15130267
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 7
    OnDragDrop = WeightDragDrop
    OnDragOver = WeightDragOver
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 433
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright 2002, Gary Darby,  www.delphiforfun.org'
        Width = 250
      end>
    SimplePanel = False
  end
end
