object OKBottomDlg: TOKBottomDlg
  Left = 753
  Top = 349
  BorderStyle = bsDialog
  Caption = 'Solved!'
  ClientHeight = 306
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Roboto'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 24
  object OKBtn: TButton
    Left = 57
    Top = 246
    Width = 176
    Height = 30
    Caption = 'Continue search'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 246
    Width = 149
    Height = 30
    Cancel = True
    Caption = 'Stop search'
    ModalResult = 2
    TabOrder = 1
  end
  object Memo3: TMemo
    Left = 16
    Top = 24
    Width = 489
    Height = 201
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Roboto'
    Font.Style = []
    Lines.Strings = (
      'Memo3')
    ParentFont = False
    TabOrder = 2
  end
end
