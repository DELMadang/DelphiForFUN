object PuzzleDlg: TPuzzleDlg
  Left = 893
  Top = 148
  BorderStyle = bsDialog
  Caption = 'Available Puzzles'
  ClientHeight = 263
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 23
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 503
    Height = 198
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 32
    Top = 40
    Width = 132
    Height = 46
    Caption = 'Select a puzzle to load'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object OKBtn: TButton
    Left = 185
    Top = 222
    Width = 93
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 222
    Width = 92
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PuzzleList: TListBox
    Left = 216
    Top = 24
    Width = 265
    Height = 169
    ItemHeight = 23
    TabOrder = 2
    OnDblClick = PuzzleListDblClick
  end
end
