object CreateDlg: TCreateDlg
  Left = 492
  Top = 308
  BorderStyle = bsDialog
  Caption = 'Create or modify puzzle definition'
  ClientHeight = 289
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 361
    Height = 233
    Shape = bsFrame
  end
  object OKBtn: TButton
    Left = 92
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 220
    Top = 246
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Modifygrp: TRadioGroup
    Left = 32
    Top = 144
    Width = 313
    Height = 81
    Caption = 'Select build option'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Manually modify  current puzzle'
      'Manually key in a new puzzle')
    ParentFont = False
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 329
    Height = 113
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'For manual changes, enter or change initial cell values '
      'with 1 through 9. No duplicates allowed in the same '
      'column, row, or block. Enter 0 or space character to '
      'remove a value.  Save puzzle to exit "Create" mode.'
      'For creating random puzzles, a new panel will be '
      'displayed with addition options.')
    ParentFont = False
    TabOrder = 3
  end
end
