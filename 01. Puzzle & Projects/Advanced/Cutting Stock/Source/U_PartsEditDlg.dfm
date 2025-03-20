object PartEditDlg: TPartEditDlg
  Left = 383
  Top = 164
  BorderStyle = bsDialog
  Caption = 'Edit Required Parts'
  ClientHeight = 214
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 297
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 112
    Top = 72
    Width = 39
    Height = 16
    Caption = 'Length'
  end
  object Label2: TLabel
    Left = 56
    Top = 112
    Width = 99
    Height = 16
    Caption = 'Number required '
  end
  object Label3: TLabel
    Left = 72
    Top = 32
    Width = 154
    Height = 16
    Caption = 'Enter values and  click OK'
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
    Left = 160
    Top = 68
    Width = 75
    Height = 24
    TabOrder = 2
    Text = '0.00'
  end
  object Edit2: TEdit
    Left = 160
    Top = 108
    Width = 75
    Height = 24
    TabOrder = 3
    Text = '0.00'
  end
end
