object Form1: TForm1
  Left = 398
  Top = 108
  Width = 1171
  Height = 784
  Caption = 'List Large Files   V3.3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    1153
    739)
  PixelsPerInch = 120
  TextHeight = 18
  object Label1: TLabel
    Left = 387
    Top = 15
    Width = 95
    Height = 18
    Caption = 'Number to list'
  end
  object Label2: TLabel
    Left = 27
    Top = 27
    Width = 85
    Height = 18
    Caption = 'Select Drive'
  end
  object Label3: TLabel
    Left = 18
    Top = 108
    Width = 252
    Height = 17
    Caption = 'Click a file to open the containing folder'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object TimeLbl: TLabel
    Left = 567
    Top = 108
    Width = 69
    Height = 18
    Caption = 'Run time: '
    OnClick = TimeLblClick
  end
  object StopBtn: TButton
    Left = 495
    Top = 51
    Width = 84
    Height = 28
    Caption = 'Stop'
    TabOrder = 0
    Visible = False
    OnClick = StopBtnClick
  end
  object ListBtn: TButton
    Left = 495
    Top = 15
    Width = 370
    Height = 28
    Caption = 'List largest files on selected drive'
    TabOrder = 1
    OnClick = ListBtnClick
  end
  object NbrEdt: TSpinEdit
    Left = 387
    Top = 42
    Width = 64
    Height = 28
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 100
  end
  object DriveComboBox1: TDriveComboBox
    Left = 27
    Top = 51
    Width = 280
    Height = 23
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 34
    Top = 152
    Width = 1079
    Height = 553
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
    OnClick = Memo1Click
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 718
    Width = 1153
    Height = 21
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2002-2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
  end
  object Button1: TButton
    Left = 612
    Top = 54
    Width = 253
    Height = 28
    Caption = 'Save CSV file list  for Excel'
    TabOrder = 6
    OnClick = Button1Click
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'CSV (*.csv)|*.csv|All files (*.*)|*.*'
    Left = 736
    Top = 80
  end
end
