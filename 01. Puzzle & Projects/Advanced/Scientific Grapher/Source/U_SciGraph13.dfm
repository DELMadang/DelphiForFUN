object Form1: TForm1
  Left = 113
  Top = 101
  Width = 849
  Height = 587
  Caption = 'Sci-Graph V1.3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 841
    Height = 512
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Dark3D = False
    BottomWall.Dark3D = False
    MarginLeft = 10
    MarginTop = 10
    Title.Text.Strings = (
      'TChart')
    Legend.ResizeChart = False
    Legend.TopPos = 4
    View3D = False
    Align = alClient
    TabOrder = 0
    OnClick = Chart1Click
    OnResize = Chart1Resize
    object Series1: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clGreen
      LinePen.Color = clGreen
      LinePen.Width = 3
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
    object Series2: TFastLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      LinePen.Color = clRed
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 512
    Width = 841
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2000-2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object MainMenu1: TMainMenu
    Left = 584
    Top = 216
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Caption = 'New'
        OnClick = New1Click
      end
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as...'
        OnClick = Saveas1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PrintSetup1: TMenuItem
        Caption = 'Print Setup...'
        OnClick = PrintSetup1Click
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = Print1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
      end
    end
    object ExpressionSets1: TMenuItem
      Caption = 'Data Expressions'
      object ExpressionSet11: TMenuItem
        Caption = 'Series 1'
        OnClick = ExpressionSet11Click
      end
      object ExpressionSet21: TMenuItem
        Caption = 'Series 2'
        OnClick = ExpressionSet21Click
      end
    end
    object About1: TMenuItem
      Caption = 'Help'
      object DefiningFunctions1: TMenuItem
        Caption = 'Defining Functions'
        OnClick = DefiningFunctions1Click
      end
      object Navigatingthechart1: TMenuItem
        Caption = 'Navigating the chart'
        OnClick = Navigatingthechart1Click
      end
      object About2: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
    object Savepic1: TMenuItem
      Caption = 'Save pic'
      OnClick = Savepic1Click
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Graphic Plots (*.grf)|*.grf|All files (*.*)|*.*'
    Title = 'Select a graphic file'
    Left = 584
    Top = 88
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'grf'
    Filter = 'Graphics plot files (*.grf)|*.grf|All files (*.*)|*.*'
    Title = 'Specify a graphics output file'
    Left = 584
    Top = 128
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 584
    Top = 168
  end
end
