object Form1: TForm1
  Left = 232
  Top = 143
  Width = 627
  Height = 480
  Caption = 'Mouse Enter - Mouse Leave Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = 8
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 8
    Width = 512
    Height = 13
    Caption = 
      'Program processes MouseEnter and MouseLeave messages to detect m' +
      'ovement into and out of the shapes '
  end
  object Panel1: TPanel
    Left = 24
    Top = 32
    Width = 569
    Height = 377
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 10
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Shape2: TShape
      Left = 288
      Top = 56
      Width = 257
      Height = 257
      Brush.Color = 127
      Shape = stCircle
      OnMouseMove = ShapeMouseMove
    end
    object Shape1: TShape
      Left = 40
      Top = 64
      Width = 217
      Height = 225
      Brush.Color = 7405568
      Shape = stSquare
      OnMouseMove = ShapeMouseMove
    end
    object IdLbl: TLabel
      Left = 208
      Top = 336
      Width = 31
      Height = 16
      Caption = 'Idlbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 432
    Width = 619
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = 8
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
