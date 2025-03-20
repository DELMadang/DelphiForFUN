object SupplyEditDlg: TSupplyEditDlg
  Left = 383
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Edit Supply piece'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 56
    Top = 72
    Width = 33
    Height = 13
    Caption = 'Length'
  end
  object Label2: TLabel
    Left = 56
    Top = 112
    Width = 21
    Height = 13
    Caption = 'Cost'
  end
  object Label3: TLabel
    Left = 40
    Top = 32
    Width = 159
    Height = 13
    Caption = 'Enter values and  click OK button'
  end
  object OKBtn: TButton
    Left = 79
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 159
    Top = 180
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 96
    Top = 68
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 96
    Top = 108
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'Edit2'
  end
end
