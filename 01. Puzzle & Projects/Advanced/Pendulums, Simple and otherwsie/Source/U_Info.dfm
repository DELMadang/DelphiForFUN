object Info: TInfo
  Left = 130
  Top = 155
  Width = 696
  Height = 480
  Caption = 'Info'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 296
    Top = 416
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 453
    Align = alClient
    Color = 14548991
    TabOrder = 1
    object RichEdit1: TRichEdit
      Left = 42
      Top = 1
      Width = 645
      Height = 432
      Align = alRight
      BorderStyle = bsNone
      Color = 14548991
      HideScrollBars = False
      Lines.Strings = (
        'RichEdit1')
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 433
      Width = 686
      Height = 19
      Panels = <
        item
          Alignment = taCenter
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          Text = 'Copyright  © 2002, Gary Darby, www.DelphiForFun.org'
          Width = 50
        end>
      SimplePanel = False
    end
  end
end
