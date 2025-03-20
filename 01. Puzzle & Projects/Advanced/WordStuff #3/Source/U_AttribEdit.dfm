object EditwordDlg: TEditwordDlg
  Left = 470
  Top = 84
  BorderStyle = bsDialog
  Caption = 'Select attributes'
  ClientHeight = 218
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
   Position = poScreenCenter
  PixelsPerInch = 120
   object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 484
    Height = 129
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 30
    Top = 30
    Width = 41
    Height = 16
    Caption = 'Label1'
  end
  object OKBtn: TButton
    Left = 60
    Top = 162
    Width = 93
    Height = 32
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 324
    Top = 162
    Width = 93
    Height = 32
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 30
    Top = 69
    Width = 119
    Height = 21
    Caption = 'Abbreviation'
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 178
    Top = 69
    Width = 119
    Height = 21
    Caption = 'Foreign'
    TabOrder = 3
  end
  object CheckBox3: TCheckBox
    Left = 325
    Top = 69
    Width = 119
    Height = 21
    Caption = 'Capitalized'
    TabOrder = 4
  end
  object NoBtn: TButton
    Left = 188
    Top = 162
    Width = 93
    Height = 32
    Caption = 'No'
    Default = True
    ModalResult = 1
    TabOrder = 5
  end
end
