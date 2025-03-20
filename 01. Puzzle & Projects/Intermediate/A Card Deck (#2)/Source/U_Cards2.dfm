object Form1: TForm1
  Left = 202
  Top = 126
  Width = 725
  Height = 528
  Caption = 'Form1'
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 144
    Top = 424
    Width = 286
    Height = 40
    Caption = 
      'Cards may be dragged to new locations, right click turns cards o' +
      'ver'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object ShuffleBtn: TButton
    Left = 574
    Top = 430
    Width = 74
    Height = 25
    Caption = 'Shuffle'
    TabOrder = 0
    OnClick = ShuffleBtnClick
  end
  object DealBtn: TButton
    Left = 574
    Top = 465
    Width = 74
    Height = 25
    Caption = 'Deal'
    TabOrder = 1
    OnClick = DealBtnClick
  end
  object SelectDeckBtn: TButton
    Left = 576
    Top = 392
    Width = 129
    Height = 25
    Caption = 'Select a deck'
    TabOrder = 2
    OnClick = SelectDeckBtnClick
  end
end
