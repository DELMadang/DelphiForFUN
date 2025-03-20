object SuggestionDlg: TSuggestionDlg
  Left = 245
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Suggestions'
  ClientHeight = 219
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 144
  TextHeight = 20
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 57
    Height = 20
    Caption = 'Change'
  end
  object Label2: TLabel
    Left = 152
    Top = 8
    Width = 19
    Height = 20
    Caption = 'To'
  end
  object OKBtn: TButton
    Left = 55
    Top = 172
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 151
    Top = 172
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 8
    Top = 32
    Width = 113
    Height = 113
    Lines.Strings = (
      '')
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 144
    Top = 32
    Width = 113
    Height = 113
    Lines.Strings = (
      '')
    TabOrder = 3
  end
end
