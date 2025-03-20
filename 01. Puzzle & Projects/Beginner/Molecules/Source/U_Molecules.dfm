object Form1: TForm1
  Left = 56
  Top = 116
  Width = 696
  Height = 480
  Caption = 'Molekyl6'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 688
    Height = 407
    Align = alClient
    OnClick = Image1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 407
    Width = 688
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 40
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
    object Start1: TMenuItem
      Caption = 'Start'
      OnClick = Start1Click
    end
    object Stop1: TMenuItem
      Caption = 'Stop'
      OnClick = Stop1Click
    end
    object Setup1: TMenuItem
      Caption = 'Setup'
      object Setup11: TMenuItem
        Tag = 1
        Caption = 'Setup1 - Inline equal mass'
        OnClick = SetupClick
      end
      object Setup21: TMenuItem
        Tag = 2
        Caption = 'Setup2- Inline, one heavy'
        OnClick = SetupClick
      end
      object Setup31: TMenuItem
        Tag = 3
        Caption = 'Setup3 - Brownian'
        OnClick = SetupClick
      end
      object Stup41: TMenuItem
        Tag = 4
        Caption = 'Setup4 - Heavy && light, slow'
        OnClick = SetupClick
      end
      object Setup51: TMenuItem
        Tag = 5
        Caption = 'Setup5 - heavy && light , fast'
        OnClick = SetupClick
      end
    end
  end
end
