object SaveDlg: TSaveDlg
  Left = 1039
  Top = 167
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 415
  ClientWidth = 385
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object OKBtn: TButton
    Left = 192
    Top = 366
    Width = 118
    Height = 30
    Caption = 'Save'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 36
    Top = 366
    Width = 125
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 32
    Top = 8
    Width = 281
    Height = 345
    Caption = 'Select or enter namr for current gris'
    TabOrder = 2
    object Label1: TLabel
      Left = 48
      Top = 280
      Width = 69
      Height = 16
      Caption = 'Case name'
    end
    object ListBox1: TListBox
      Left = 32
      Top = 24
      Width = 217
      Height = 233
      ItemHeight = 16
      TabOrder = 0
      OnClick = ListBox1Click
    end
    object Edit1: TEdit
      Left = 48
      Top = 297
      Width = 193
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
end
