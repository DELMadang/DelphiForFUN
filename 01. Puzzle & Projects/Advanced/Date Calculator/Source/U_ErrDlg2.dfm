object ErrDlg: TErrDlg
  Left = 348
  Top = 152
  ActiveControl = Difflimit
  BorderStyle = bsDialog
  Caption = 'Date Calc Checking/Debugging '
  ClientHeight = 588
  ClientWidth = 713
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 695
    Height = 447
    Shape = bsFrame
  end
  object d1Lbl: TLabel
    Left = 56
    Top = 24
    Width = 39
    Height = 16
    Caption = 'Date1:'
  end
  object D2Lbl: TLabel
    Left = 56
    Top = 48
    Width = 36
    Height = 16
    Caption = 'Date2'
  end
  object DDiffLbl: TLabel
    Left = 56
    Top = 72
    Width = 54
    Height = 16
    Caption = 'Date Diff:'
  end
  object RecalcLblYMD: TLabel
    Left = 56
    Top = 96
    Width = 154
    Height = 16
    Caption = 'Recalc Date: (YMD order)'
  end
  object RecalcLblDMY: TLabel
    Left = 56
    Top = 120
    Width = 154
    Height = 16
    Caption = 'Recalc Date: (DMY order)'
  end
  object Label1: TLabel
    Left = 272
    Top = 484
    Width = 169
    Height = 17
    AutoSize = False
    Caption = 'Report recalc differences of'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 488
    Top = 484
    Width = 79
    Height = 16
    Caption = 'or more days'
  end
  object OKBtn: TButton
    Left = 273
    Top = 526
    Width = 93
    Height = 30
    Caption = 'Continue'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 392
    Top = 526
    Width = 113
    Height = 30
    Caption = 'Stop/Close'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object Memo1: TMemo
    Left = 56
    Top = 176
    Width = 633
    Height = 265
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object PauseBox: TCheckBox
    Left = 56
    Top = 472
    Width = 121
    Height = 17
    Caption = 'Pause on error'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object Repeatbox: TCheckBox
    Left = 48
    Top = 504
    Width = 161
    Height = 65
    Caption = 
      'Make test repeatable (Main form "Test" button will repeat these ' +
      'tests)'
    Checked = True
    State = cbChecked
    TabOrder = 4
    WordWrap = True
  end
  object Memo2: TMemo
    Left = 408
    Top = 24
    Width = 281
    Height = 137
    Lines.Strings = (
      'Results from 1000 random date pairs, '
      'calculating  years, months, weeks, and '
      'days differences.  Because months are not '
      'all the same length, differences are not '
      'always reversable.   .')
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Difflimit: TSpinEdit
    Left = 448
    Top = 480
    Width = 33
    Height = 26
    MaxValue = 4
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
end
