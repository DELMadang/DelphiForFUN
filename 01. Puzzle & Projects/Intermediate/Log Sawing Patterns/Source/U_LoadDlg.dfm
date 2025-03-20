object LoadDlg: TLoadDlg
  Left = 816
  Top = 222
  BorderStyle = bsDialog
  Caption = 'Select a case to load'
  ClientHeight = 263
  ClientWidth = 385
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 365
    Height = 198
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 97
    Top = 222
    Width = 93
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 196
    Top = 222
    Width = 92
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ListBox1: TListBox
    Left = 64
    Top = 16
    Width = 233
    Height = 169
    ItemHeight = 16
    TabOrder = 2
  end
end
