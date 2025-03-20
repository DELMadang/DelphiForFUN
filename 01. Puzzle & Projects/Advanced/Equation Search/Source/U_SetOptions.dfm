object Form2: TForm2
  Left = 236
  Top = 147
  Width = 411
  Height = 374
  Caption = 'Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 16
    Top = 24
    Width = 369
    Height = 265
  end
  object Label1: TLabel
    Left = 184
    Top = 64
    Width = 50
    Height = 13
    Caption = 'Max Value'
  end
  object Label2: TLabel
    Left = 184
    Top = 104
    Width = 78
    Height = 13
    Caption = 'Problems per set'
  end
  object Label3: TLabel
    Left = 184
    Top = 144
    Width = 95
    Height = 13
    Caption = '% Correct for reward'
  end
  object Label4: TLabel
    Left = 56
    Top = 40
    Width = 91
    Height = 13
    Caption = 'Allowed Operations'
  end
  object Label5: TLabel
    Left = 40
    Top = 192
    Width = 297
    Height = 81
    AutoSize = False
    Caption = 
      'Note: any .jpg image files in the program folder are randomly di' +
      'splayed with the reward screen,  Any .wav sound files in the pro' +
      'gram folder  are randomly played with the reward screen.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object MaxValEdit: TSpinEdit
    Left = 288
    Top = 59
    Width = 41
    Height = 22
    MaxValue = 99
    MinValue = 10
    TabOrder = 0
    Value = 99
  end
  object OpBox: TCheckListBox
    Left = 56
    Top = 64
    Width = 65
    Height = 97
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 20
    Items.Strings = (
      '+'
      '-'
      '*'
      '/')
    ParentFont = False
    TabOrder = 1
  end
  object ProbSetEdit: TSpinEdit
    Left = 288
    Top = 99
    Width = 41
    Height = 22
    MaxValue = 20
    MinValue = 1
    TabOrder = 2
    Value = 5
  end
  object RewardEdit: TSpinEdit
    Left = 288
    Top = 139
    Width = 41
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 3
    Value = 75
  end
  object OkBtn: TBitBtn
    Left = 96
    Top = 304
    Width = 75
    Height = 25
    TabOrder = 4
    OnClick = OkBtnClick
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 224
    Top = 304
    Width = 75
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
end
