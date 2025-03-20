object Form1: TForm1
  Left = 64
  Top = 76
  Width = 674
  Height = 389
  Caption = 'Test MakeCaption justification procedure '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 160
    Width = 93
    Height = 13
    Caption = 'Left Side of Caption'
  end
  object Label2: TLabel
    Left = 24
    Top = 240
    Width = 98
    Height = 13
    Caption = 'Right side of Caption'
  end
  object Memo1: TMemo
    Left = 288
    Top = 16
    Width = 345
    Height = 273
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object LeftEdt: TEdit
    Left = 24
    Top = 184
    Width = 249
    Height = 21
    TabOrder = 1
    Text = 'MakeCaption Procedure Test'
  end
  object RightEdt: TEdit
    Left = 24
    Top = 256
    Width = 249
    Height = 21
    TabOrder = 2
    Text = 'Copyright, G. Darby, www.delphiforfun.org'
  end
  object Memo2: TMemo
    Left = 16
    Top = 16
    Width = 257
    Height = 121
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Resize and/or change caption '
      'fields.  Left and right sides '
      'should remain justified left and '
      'right respectively.')
    ParentFont = False
    TabOrder = 3
  end
end
