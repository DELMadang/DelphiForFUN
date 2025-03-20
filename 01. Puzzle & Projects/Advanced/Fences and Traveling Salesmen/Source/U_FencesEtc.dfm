object Form1: TForm1
  Left = 51
  Top = 47
  Width = 719
  Height = 503
  Caption = 'Fences and Traveling Salesmen'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 208
    Top = 48
    Width = 313
    Height = 281
    OnMouseUp = PaintBox1MouseUp
    OnPaint = PaintBox1Paint
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 185
    Height = 13
    Caption = 'Click in rectangle to create some points'
  end
  object PathLengthLbl: TLabel
    Left = 280
    Top = 16
    Width = 102
    Height = 20
    Caption = 'Path length:  0'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object NbrpointsLbl: TLabel
    Left = 560
    Top = 64
    Width = 57
    Height = 20
    Caption = '0 Points'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object SimplePathBtn: TButton
    Left = 24
    Top = 48
    Width = 113
    Height = 25
    Caption = 'Draw Simple Path'
    TabOrder = 0
    OnClick = SimplePathBtnClick
  end
  object ConvexHullBtn: TButton
    Left = 24
    Top = 80
    Width = 113
    Height = 25
    Caption = 'Draw Convex Hull'
    TabOrder = 1
    OnClick = ConvexHullBtnClick
  end
  object ResetAllBtn: TButton
    Left = 24
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Reset Points'
    TabOrder = 2
    OnClick = ResetAllBtnClick
  end
  object ShortBtn: TButton
    Left = 24
    Top = 112
    Width = 113
    Height = 25
    Caption = 'Draw Shortest Path'
    TabOrder = 3
    OnClick = ShortBtnClick
  end
  object ShortPathGrpBox: TGroupBox
    Left = 208
    Top = 360
    Width = 313
    Height = 105
    Caption = 'Shortest path search'
    TabOrder = 4
    Visible = False
    object CountLbl: TLabel
      Left = 16
      Top = 28
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label2: TLabel
      Left = 112
      Top = 28
      Width = 9
      Height = 13
      Caption = 'of'
    end
    object Maxpathslbl: TLabel
      Left = 144
      Top = 28
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Stopbtn: TButton
      Left = 48
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 0
      OnClick = StopbtnClick
    end
  end
  object ResetLinesBtn: TButton
    Left = 24
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Reset Path'
    TabOrder = 5
    OnClick = ResetLinesBtnClick
  end
end
