object Form1: TForm1
  Left = 36
  Top = 53
  Width = 720
  Height = 507
  Caption = 'Threads Demo - Elevators'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 8
    Top = 8
    Width = 321
    Height = 449
    Visible = False
  end
  object Label1: TLabel
    Left = 368
    Top = 56
    Width = 77
    Height = 13
    Caption = 'Number of floors'
  end
  object Label2: TLabel
    Left = 352
    Top = 88
    Width = 96
    Height = 13
    Caption = 'Number of Elevators'
  end
  object Label3: TLabel
    Left = 360
    Top = 136
    Width = 89
    Height = 33
    AutoSize = False
    Caption = 'Default door open seconds'
    WordWrap = True
  end
  object FloorEdit: TSpinEdit
    Left = 456
    Top = 48
    Width = 41
    Height = 22
    MaxValue = 4
    MinValue = 2
    TabOrder = 2
    Value = 3
    OnChange = FloorEditChange
  end
  object Button0: TButton
    Left = 552
    Top = 48
    Width = 121
    Height = 25
    Caption = 'Move Elevator 1'
    TabOrder = 0
    Visible = False
    OnClick = ButtonClick
  end
  object Button1: TButton
    Tag = 1
    Left = 552
    Top = 96
    Width = 121
    Height = 25
    Caption = 'Move Elevator 2'
    TabOrder = 1
    Visible = False
    OnClick = ButtonClick
  end
  object ElevEdit: TSpinEdit
    Left = 456
    Top = 80
    Width = 41
    Height = 22
    MaxValue = 4
    MinValue = 1
    TabOrder = 3
    Value = 2
    OnChange = ElevEditChange
  end
  object Button3: TButton
    Tag = 3
    Left = 552
    Top = 192
    Width = 121
    Height = 25
    Caption = 'Move Elevator 4'
    TabOrder = 4
    Visible = False
    OnClick = ButtonClick
  end
  object Button2: TButton
    Tag = 2
    Left = 552
    Top = 144
    Width = 121
    Height = 25
    Caption = 'Move Elevator 3'
    TabOrder = 5
    Visible = False
    OnClick = ButtonClick
  end
  object OpenEdit: TSpinEdit
    Left = 456
    Top = 136
    Width = 41
    Height = 22
    MaxValue = 60
    MinValue = 0
    TabOrder = 6
    Value = 5
    OnChange = OpenEditChange
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 463
    Width = 712
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 7
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 360
    Top = 240
    Width = 313
    Height = 145
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'This is a program written to explore use of '
      'the Delphi TThread component.  '
      ''
      'It runs from 1 to 5 elevators independently '
      'as separate processes.  ')
    ParentFont = False
    TabOrder = 8
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 672
  end
end
