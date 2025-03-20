object Form1: TForm1
  Left = 187
  Top = 55
  Width = 800
  Height = 600
  Caption = 'SpringMass V2 - Displays detail data '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StopBtn: TButton
    Left = 200
    Top = 120
    Width = 97
    Height = 25
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = StopBtnClick
  end
  object Panel1: TPanel
    Left = 320
    Top = 16
    Width = 209
    Height = 513
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 289
    Height = 113
    TabStop = False
    Color = clYellow
    Lines.Strings = (
      'Program demonstating animation of a simple spring-mass '
      'system with damping.   Units are arbitrary.'
      ''
      'Constraints: Mass and spring constant must be greater than '
      '0.  Damping can range from  0 to 1,  Gravity must not be '
      'negative.'
      ''
      'Detailed results for up to 2000 iterations may be displayed.')
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 16
    Top = 144
    Width = 289
    Height = 385
    TabOrder = 2
    object Label2: TLabel
      Left = 27
      Top = 88
      Width = 64
      Height = 33
      AutoSize = False
      Caption = 'Initial Velocity (+=down)'
      WordWrap = True
    end
    object Label4: TLabel
      Left = 47
      Top = 128
      Width = 42
      Height = 13
      Caption = 'Damping'
    end
    object Label5: TLabel
      Left = 14
      Top = 156
      Width = 75
      Height = 13
      Caption = 'Spring Constant'
    end
    object Label6: TLabel
      Left = 64
      Top = 188
      Width = 25
      Height = 13
      Caption = 'Mass'
    end
    object Label8: TLabel
      Left = 56
      Top = 220
      Width = 33
      Height = 13
      Caption = 'Gravity'
    end
    object Label1: TLabel
      Left = 16
      Top = 252
      Width = 81
      Height = 29
      AutoSize = False
      Caption = 'Time inc/loop  0.1 to 1.0 secs.'
      WordWrap = True
    end
    object ConstraintRgrp: TRadioGroup
      Left = 16
      Top = 0
      Width = 265
      Height = 81
      Caption = 'Weight position'
      ItemIndex = 0
      Items.Strings = (
        'Unconstrained initiial postion'
        'Intial displacement from rest')
      TabOrder = 0
      OnClick = ConstraintRgrpClick
    end
    object V0Edt: TEdit
      Left = 104
      Top = 92
      Width = 49
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 20
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '30'
      OnChange = V0EdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object DampEdt: TEdit
      Left = 104
      Top = 124
      Width = 49
      Height = 21
      TabOrder = 3
      Text = '0.05'
      OnChange = DampEdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object SpringEdt: TEdit
      Left = 104
      Top = 156
      Width = 49
      Height = 21
      TabOrder = 4
      Text = '5'
      OnChange = SpringEdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object MassEdt: TEdit
      Left = 104
      Top = 188
      Width = 49
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 25
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = '15'
      OnChange = MassEdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object GravityEdt: TEdit
      Left = 104
      Top = 220
      Width = 49
      Height = 21
      TabOrder = 6
      Text = '9.81'
      OnChange = GravityEdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object X0Edt: TEdit
      Left = 192
      Top = 48
      Width = 49
      Height = 21
      TabOrder = 1
      Text = '100'
      OnChange = X0EdtChange
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object TypeRgrp: TRadioGroup
      Left = 176
      Top = 96
      Width = 97
      Height = 73
      Caption = 'Spring type'
      ItemIndex = 1
      Items.Strings = (
        'Pull only'
        'Push/Pull')
      TabOrder = 8
      OnClick = TypeRgrpClick
    end
    object StartBtn: TButton
      Left = 16
      Top = 328
      Width = 97
      Height = 25
      Caption = 'Start'
      TabOrder = 11
      OnClick = StartBtnClick
    end
    object TimeScaleGrp: TRadioGroup
      Left = 176
      Top = 184
      Width = 97
      Height = 89
      Caption = 'Time Scale'
      ItemIndex = 3
      Items.Strings = (
        'Real time'
        '2X'
        '4X'
        '8X ')
      TabOrder = 9
      OnClick = TimeScaleGrpClick
    end
    object TimeIncEdt: TEdit
      Left = 104
      Top = 252
      Width = 49
      Height = 21
      TabOrder = 7
      Text = '0.1'
      OnExit = TimeIncEdtExit
      OnKeyPress = EdtKeyPress
      OnKeyUp = EdtKeyUp
    end
    object Memo3: TMemo
      Left = 144
      Top = 312
      Width = 121
      Height = 57
      TabStop = False
      ReadOnly = True
      TabOrder = 12
    end
    object Displaybox: TCheckBox
      Left = 144
      Top = 280
      Width = 129
      Height = 17
      Caption = 'Display detail data'
      Checked = True
      State = cbChecked
      TabOrder = 10
    end
  end
  object Memo2: TMemo
    Left = 544
    Top = 16
    Width = 233
    Height = 513
    TabStop = False
    Lines.Strings = (
      'Time    A       V       Pos')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2000, 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 5
    TabStop = True
    OnClick = StaticText1Click
  end
end
