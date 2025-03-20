object CoeffDlg: TCoeffDlg
  Left = 377
  Top = 213
  BorderStyle = bsDialog
  Caption = 'Set coefficients for quadratic equations to be solved'
  ClientHeight = 294
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object OKBtn: TButton
    Left = 255
    Top = 236
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 375
    Top = 236
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 48
    Top = 48
    Width = 753
    Height = 33
    TabOrder = 2
    object Label1: TLabel
      Tag = 15
      Left = 392
      Top = 8
      Width = 34
      Height = 16
      Caption = 'Z^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Tag = 16
      Left = 480
      Top = 8
      Width = 19
      Height = 16
      Caption = 'Z +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Tag = 17
      Left = 544
      Top = 8
      Width = 40
      Height = 16
      Caption = 'W^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Tag = 18
      Left = 632
      Top = 8
      Width = 25
      Height = 16
      Caption = 'W +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Tag = 11
      Left = 104
      Top = 8
      Width = 36
      Height = 16
      Caption = 'X^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Tag = 12
      Left = 184
      Top = 8
      Width = 21
      Height = 16
      Caption = 'X +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label13: TLabel
      Tag = 13
      Left = 248
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Y^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label14: TLabel
      Tag = 14
      Left = 328
      Top = 8
      Width = 20
      Height = 16
      Caption = 'Y +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label15: TLabel
      Tag = 19
      Left = 710
      Top = 8
      Width = 19
      Height = 16
      Caption = '= 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 8
      Top = 8
      Width = 33
      Height = 18
      Caption = 'Eq 1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object C11: TEdit
      Tag = 15
      Left = 352
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '1.0'
      OnChange = CoeffChange
    end
    object C12: TEdit
      Tag = 16
      Left = 440
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = '0.0'
      OnChange = CoeffChange
    end
    object C13: TEdit
      Tag = 17
      Left = 504
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '1.0'
      OnChange = CoeffChange
    end
    object C14: TEdit
      Tag = 18
      Left = 592
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = '0.0'
      OnChange = CoeffChange
    end
    object C15: TEdit
      Tag = 19
      Left = 664
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '-4.0'
      OnChange = CoeffChange
    end
    object Edit6: TEdit
      Tag = 11
      Left = 64
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit7: TEdit
      Tag = 12
      Left = 144
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit8: TEdit
      Tag = 13
      Left = 208
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit9: TEdit
      Tag = 14
      Left = 288
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '0.0'
      OnChange = CoeffChange
    end
  end
  object Panel2: TPanel
    Left = 48
    Top = 88
    Width = 753
    Height = 33
    TabOrder = 3
    object Label16: TLabel
      Tag = 25
      Left = 392
      Top = 8
      Width = 34
      Height = 16
      Caption = 'Z^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label17: TLabel
      Tag = 26
      Left = 480
      Top = 8
      Width = 19
      Height = 16
      Caption = 'Z +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label18: TLabel
      Tag = 27
      Left = 544
      Top = 8
      Width = 40
      Height = 16
      Caption = 'W^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Tag = 28
      Left = 632
      Top = 8
      Width = 25
      Height = 16
      Caption = 'W +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label21: TLabel
      Tag = 21
      Left = 104
      Top = 8
      Width = 36
      Height = 16
      Caption = 'X^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label22: TLabel
      Tag = 22
      Left = 184
      Top = 8
      Width = 21
      Height = 16
      Caption = 'X +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label23: TLabel
      Tag = 23
      Left = 248
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Y^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label24: TLabel
      Tag = 24
      Left = 328
      Top = 8
      Width = 20
      Height = 16
      Caption = 'Y +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label25: TLabel
      Tag = 29
      Left = 710
      Top = 8
      Width = 19
      Height = 16
      Caption = '= 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 8
      Top = 8
      Width = 33
      Height = 18
      Caption = 'Eq 2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit10: TEdit
      Tag = 25
      Left = 352
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit11: TEdit
      Tag = 26
      Left = 440
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit12: TEdit
      Tag = 27
      Left = 504
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit13: TEdit
      Tag = 28
      Left = 592
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit14: TEdit
      Tag = 29
      Left = 664
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '-1'
      OnChange = CoeffChange
    end
    object Edit15: TEdit
      Tag = 21
      Left = 64
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '1'
      OnChange = CoeffChange
    end
    object Edit16: TEdit
      Tag = 22
      Left = 144
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit17: TEdit
      Tag = 23
      Left = 208
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '0'
      OnChange = CoeffChange
    end
    object Edit18: TEdit
      Tag = 24
      Left = 288
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '-1'
      OnChange = CoeffChange
    end
  end
  object Panel3: TPanel
    Left = 48
    Top = 128
    Width = 753
    Height = 33
    TabOrder = 4
    object Label26: TLabel
      Tag = 35
      Left = 392
      Top = 8
      Width = 34
      Height = 16
      Caption = 'Z^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label27: TLabel
      Tag = 36
      Left = 480
      Top = 8
      Width = 19
      Height = 16
      Caption = 'Z +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label28: TLabel
      Tag = 37
      Left = 544
      Top = 8
      Width = 40
      Height = 16
      Caption = 'W^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label29: TLabel
      Tag = 38
      Left = 632
      Top = 8
      Width = 25
      Height = 16
      Caption = 'W +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label31: TLabel
      Tag = 31
      Left = 104
      Top = 8
      Width = 36
      Height = 16
      Caption = 'X^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label32: TLabel
      Tag = 32
      Left = 184
      Top = 8
      Width = 21
      Height = 16
      Caption = 'X +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label33: TLabel
      Tag = 33
      Left = 248
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Y^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label34: TLabel
      Tag = 34
      Left = 328
      Top = 8
      Width = 20
      Height = 16
      Caption = 'Y +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label35: TLabel
      Tag = 39
      Left = 710
      Top = 8
      Width = 19
      Height = 16
      Caption = '= 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 8
      Top = 8
      Width = 33
      Height = 18
      Caption = 'Eq 3'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit19: TEdit
      Tag = 35
      Left = 352
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit20: TEdit
      Tag = 36
      Left = 440
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit21: TEdit
      Tag = 37
      Left = 504
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit22: TEdit
      Tag = 38
      Left = 592
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit23: TEdit
      Tag = 39
      Left = 664
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '-4.0'
      OnChange = CoeffChange
    end
    object Edit24: TEdit
      Tag = 31
      Left = 64
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit25: TEdit
      Tag = 32
      Left = 144
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit26: TEdit
      Tag = 33
      Left = 208
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit27: TEdit
      Tag = 34
      Left = 288
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '0.0'
      OnChange = CoeffChange
    end
  end
  object Panel4: TPanel
    Left = 48
    Top = 168
    Width = 753
    Height = 33
    TabOrder = 5
    object Label36: TLabel
      Tag = 45
      Left = 392
      Top = 8
      Width = 34
      Height = 16
      Caption = 'Z^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label37: TLabel
      Tag = 46
      Left = 480
      Top = 8
      Width = 19
      Height = 16
      Caption = 'Z +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label38: TLabel
      Tag = 47
      Left = 544
      Top = 8
      Width = 40
      Height = 16
      Caption = 'W^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label39: TLabel
      Tag = 48
      Left = 632
      Top = 8
      Width = 25
      Height = 16
      Caption = 'W +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label41: TLabel
      Tag = 41
      Left = 104
      Top = 8
      Width = 36
      Height = 16
      Caption = 'X^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label42: TLabel
      Tag = 42
      Left = 184
      Top = 8
      Width = 21
      Height = 16
      Caption = 'X +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label43: TLabel
      Tag = 43
      Left = 248
      Top = 8
      Width = 35
      Height = 16
      Caption = 'Y^2 +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label44: TLabel
      Tag = 44
      Left = 328
      Top = 8
      Width = 20
      Height = 16
      Caption = 'Y +'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label45: TLabel
      Tag = 49
      Left = 710
      Top = 8
      Width = 19
      Height = 16
      Caption = '= 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 8
      Top = 8
      Width = 33
      Height = 18
      Caption = 'Eq 4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Edit28: TEdit
      Tag = 45
      Left = 352
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit29: TEdit
      Tag = 46
      Left = 440
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit30: TEdit
      Tag = 47
      Left = 504
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit31: TEdit
      Tag = 48
      Left = 584
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit32: TEdit
      Tag = 49
      Left = 664
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '-4.0'
      OnChange = CoeffChange
    end
    object Edit33: TEdit
      Tag = 41
      Left = 64
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit34: TEdit
      Tag = 42
      Left = 144
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '0.0'
      OnChange = CoeffChange
    end
    object Edit35: TEdit
      Tag = 43
      Left = 208
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '1.0'
      OnChange = CoeffChange
    end
    object Edit36: TEdit
      Tag = 44
      Left = 288
      Top = 4
      Width = 41
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = '0.0'
      OnChange = CoeffChange
    end
  end
end
