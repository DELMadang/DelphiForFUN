object Form1: TForm1
  Left = 248
  Top = 118
  Width = 900
  Height = 580
  Caption = 'Shadow of a Vertical Rod for given Sun Azimuth & Altitide '
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    884
    544)
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 352
    Top = 8
    Width = 523
    Height = 497
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 11598260
    ParentColor = False
    OnPaint = PaintFigure
  end
  object Label1: TLabel
    Left = 72
    Top = 312
    Width = 56
    Height = 13
    Caption = 'Rod Length'
  end
  object Label2: TLabel
    Left = 24
    Top = 344
    Width = 108
    Height = 13
    Caption = 'Sun Azimuth (Degrees)'
  end
  object Label3: TLabel
    Left = 24
    Top = 376
    Width = 106
    Height = 13
    Caption = 'Sun Altitude (Degrees)'
  end
  object RodSpinEdt: TSpinEdit
    Left = 136
    Top = 304
    Width = 49
    Height = 22
    MaxValue = 500
    MinValue = 1
    TabOrder = 0
    Value = 100
    OnChange = RodSpinEdtChange
  end
  object AzSpinEdt: TSpinEdit
    Left = 136
    Top = 336
    Width = 49
    Height = 22
    MaxValue = 360
    MinValue = -360
    TabOrder = 1
    Value = 105
    OnChange = AzSpinEdtChange
  end
  object AltSpinEdt: TSpinEdit
    Left = 136
    Top = 368
    Width = 49
    Height = 22
    MaxValue = 90
    MinValue = 0
    TabOrder = 2
    Value = 45
    OnChange = AltSpinEdtChange
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 416
    Width = 321
    Height = 89
    Caption = 'Eye position from Rod base'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label4: TLabel
      Left = 56
      Top = 56
      Width = 42
      Height = 13
      Caption = 'Distance'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 32
      Width = 85
      Height = 13
      Caption = 'Bearing (Degrees)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 168
      Top = 32
      Width = 93
      Height = 13
      Caption = 'Elevation (Degrees)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object EyeDistSpinEdt: TSpinEdit
      Left = 104
      Top = 56
      Width = 49
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 1000
      MinValue = 1
      ParentFont = False
      TabOrder = 0
      Value = 200
      OnChange = EyeSpinEdtChange
    end
    object EyeAzSpinEdt: TSpinEdit
      Left = 104
      Top = 24
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 180
      MinValue = -180
      ParentFont = False
      TabOrder = 1
      Value = 10
      OnChange = EyeSpinEdtChange
    end
    object EyeAltSpinEdt: TSpinEdit
      Left = 264
      Top = 28
      Width = 41
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 90
      MinValue = 0
      ParentFont = False
      TabOrder = 2
      Value = 60
      OnChange = EyeSpinEdtChange
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 321
    Height = 281
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Here is program which displays the shadow cast when sun is '
      'at a given azimuth and altitude.'
      ''
      'The lower set of edit controls allow you to change your '
      'viewpoint by adjusting the bearing, altitude, and distance from '
      'the base of the rod.'
      ''
      'A late addition was the ability to plot an "analemma", a figure '
      'representing the path of the sun af observed from a fixed '
      
        'location and time of day for an entire year. Becuase the earth i' +
        's'
      
        'tilted relative to is path around the sun and because it'#39's path ' +
        'is '
      
        'slighty elliptical, the analemma, or its shadow version, traces ' +
        'a'
      'lopsided figure 8.  Azimuth and altitude points may be entered '
      
        'individually and the "Plot shadow point" button clicked.  A bett' +
        'er '
      
        'method is to build a text file of azimuth and altitude values, o' +
        'ne'
      'pair per line, and use he "Load Analemma" button to load and'
      'plot the data. File "Sample Analemma.txt" is included which has '
      '24 values for noon on the 1st and 15th of each month for my '
      'home town.')
    ParentFont = False
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 524
    Width = 884
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
  end
  object SavePtBtn: TButton
    Left = 200
    Top = 304
    Width = 129
    Height = 25
    Caption = 'Plot shadow point'
    TabOrder = 6
    OnClick = SavePtBtnClick
  end
  object ClearPtsBtn: TButton
    Left = 200
    Top = 336
    Width = 129
    Height = 25
    Caption = 'Clear points'
    TabOrder = 7
    OnClick = ClearPtsBtnClick
  end
  object LoadAnalemmaBtn: TButton
    Left = 200
    Top = 368
    Width = 129
    Height = 25
    Caption = 'Load analemma points'
    TabOrder = 8
    OnClick = LoadAnalemmaBtnClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 360
    Top = 464
  end
end
