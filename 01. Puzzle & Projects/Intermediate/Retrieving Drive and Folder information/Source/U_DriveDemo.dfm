object Form1: TForm1
  Left = 202
  Top = 104
  Width = 686
  Height = 480
  Caption = 'Find drives and files demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RandomBtn: TButton
    Left = 24
    Top = 232
    Width = 137
    Height = 25
    Caption = 'Select a Random File'
    TabOrder = 0
    OnClick = RandomBtnClick
  end
  object Button2: TButton
    Left = 24
    Top = 304
    Width = 113
    Height = 25
    Caption = 'List files  of type'
    TabOrder = 1
    OnClick = TypeBtnClick
  end
  object ListBox1: TListBox
    Left = 320
    Top = 32
    Width = 321
    Height = 409
    ItemHeight = 13
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 144
    Top = 304
    Width = 65
    Height = 21
    TabOrder = 3
    Text = '*.dll'
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 16
    Width = 129
    Height = 129
    Caption = 'Drive types to search'
    TabOrder = 4
    object CDROMBox: TCheckBox
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Caption = 'CD-ROMs'
      TabOrder = 0
      OnClick = DriveBoxClick
    end
    object FixedDiskBox: TCheckBox
      Left = 16
      Top = 56
      Width = 97
      Height = 17
      Caption = 'Fixed local disks'
      TabOrder = 1
      OnClick = DriveBoxClick
    end
    object NetworkBox: TCheckBox
      Left = 16
      Top = 88
      Width = 97
      Height = 17
      Caption = 'Network drives'
      TabOrder = 2
      OnClick = DriveBoxClick
    end
  end
  object DrivesBtn: TButton
    Left = 24
    Top = 168
    Width = 75
    Height = 25
    Caption = 'List drives'
    TabOrder = 5
    OnClick = DrivesBtnClick
  end
  object StopBtn: TButton
    Left = 200
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    Visible = False
    OnClick = StopBtnClick
  end
end
