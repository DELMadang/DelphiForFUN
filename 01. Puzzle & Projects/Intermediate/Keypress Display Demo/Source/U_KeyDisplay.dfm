object Form1: TForm1
  Left = 1225
  Top = 1
  Width = 314
  Height = 142
  Caption = 'Keyboard Hook Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Label2: TLabel
    Left = 200
    Top = 0
    Width = 47
    Height = 20
    Caption = 'Count:'
  end
  object Label1: TLabel
    Left = 16
    Top = 0
    Width = 78
    Height = 20
    Caption = 'Keystrokes'
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 107
    Height = 20
    Caption = 'Prev key stroke'
    Visible = False
  end
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 273
    Height = 73
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 273
    Height = 73
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Monitors key strokes from any window until '
      'return (Enter) key is pressed or this program '
      'is closed.')
    ParentFont = False
    TabOrder = 0
    OnKeyPress = Memo1KeyPress
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 93
    Width = 306
    Height = 18
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
end
