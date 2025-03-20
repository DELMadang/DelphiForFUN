object Form1: TForm1
  Left = 22
  Top = 37
  Width = 651
  Height = 478
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Cartesian - Polar Coordinates Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 256
    Top = 32
    Width = 353
    Height = 337
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object Label1: TLabel
    Left = 288
    Top = 405
    Width = 14
    Height = 24
    Anchors = [akLeft, akBottom]
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 169
    Top = 168
    Width = 12
    Height = 24
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 320
    Top = 413
    Width = 69
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '=R*cos(Theta)'
  end
  object Label6: TLabel
    Left = 144
    Top = 200
    Width = 65
    Height = 13
    Caption = '=R*sin(Theta)'
  end
  object Label9: TLabel
    Left = 8
    Top = 0
    Width = 226
    Height = 16
    Caption = 'Drag sliders to see relationships'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 4227072
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 129
    Height = 390
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 0
    object Label3: TLabel
      Left = 7
      Top = 72
      Width = 58
      Height = 24
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 'Radius'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 4
      Top = 245
      Width = 48
      Height = 24
      Anchors = [akLeft, akBottom]
      Caption = 'Theta'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 104
      Width = 71
      Height = 13
      Caption = '=sqrt(X*X+Y*Y)'
    end
    object Label8: TLabel
      Left = 8
      Top = 269
      Width = 65
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = '=arcTan(Y/X)'
    end
    object RBar: TTrackBar
      Left = 86
      Top = 8
      Width = 30
      Height = 193
      Max = 142
      Orientation = trVertical
      PageSize = 1
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 0
      TickMarks = tmBottomRight
      TickStyle = tsManual
      OnChange = RTBarChange
    end
    object TBar: TTrackBar
      Left = 86
      Top = 189
      Width = 30
      Height = 193
      Anchors = [akRight, akBottom]
      Max = 360
      Orientation = trVertical
      PageSize = 1
      Frequency = 1
      Position = 0
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      TickMarks = tmBottomRight
      TickStyle = tsManual
      OnChange = RTBarChange
    end
    object REdt: TEdit
      Left = 11
      Top = 136
      Width = 41
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
      Text = 'REdt'
    end
    object TEdt: TEdit
      Left = 8
      Top = 301
      Width = 41
      Height = 21
      Anchors = [akLeft, akBottom]
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = 'TEdt'
    end
  end
  object XBar: TTrackBar
    Left = 232
    Top = 381
    Width = 385
    Height = 30
    Anchors = [akLeft, akRight, akBottom]
    Max = 100
    Min = -100
    Orientation = trHorizontal
    PageSize = 1
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 1
    TickMarks = tmBottomRight
    TickStyle = tsManual
    OnChange = XYBarChange
  end
  object XEdt: TEdit
    Left = 408
    Top = 407
    Width = 41
    Height = 21
    Anchors = [akLeft, akBottom]
    AutoSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Text = 'XEdt'
  end
  object Ybar: TTrackBar
    Left = 216
    Top = 24
    Width = 33
    Height = 350
    Anchors = [akLeft, akTop, akBottom]
    Max = 100
    Min = -100
    Orientation = trVertical
    PageSize = 1
    Frequency = 1
    Position = -50
    SelEnd = 0
    SelStart = 0
    TabOrder = 3
    TickMarks = tmBottomRight
    TickStyle = tsManual
    OnChange = XYBarChange
  end
  object YEdt: TEdit
    Left = 160
    Top = 224
    Width = 30
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
    Text = 'YEdt'
  end
  object MainMenu1: TMainMenu
    Left = 168
    Top = 64
    object Info1: TMenuItem
      Caption = 'Info     '
      OnClick = Info1Click
    end
    object Anglerange1: TMenuItem
      Caption = '       Angle range    '
      object N0to360degrees1: TMenuItem
        Caption = '0 to 360 degrees'
        Checked = True
        OnClick = N0to360degrees1Click
      end
      object N180to180degrees1: TMenuItem
        Caption = '-180 to +180 degrees'
        OnClick = N180to180degrees1Click
      end
    end
  end
end
