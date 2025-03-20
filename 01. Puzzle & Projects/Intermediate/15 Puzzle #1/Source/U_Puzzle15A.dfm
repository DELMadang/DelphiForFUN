object Form1: TForm1
  Left = 221
  Top = 108
  Width = 544
  Height = 375
  Caption = 'Put the sliders in sequence,  click a slider to move it'
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
  object Panel1: TPanel
    Left = 224
    Top = 32
    Width = 289
    Height = 289
    Caption = 'Panel1'
    Color = clLime
    TabOrder = 0
    Visible = False
  end
  object SolveBtn: TButton
    Left = 32
    Top = 272
    Width = 105
    Height = 25
    Caption = 'Solve it (not yet)'
    Enabled = False
    TabOrder = 1
  end
  object ScrambleBtn: TButton
    Left = 32
    Top = 224
    Width = 105
    Height = 25
    Caption = 'Scramble'
    TabOrder = 2
    OnClick = ScrambleBtnClick
  end
  object SizeGrp: TRadioGroup
    Left = 32
    Top = 72
    Width = 129
    Height = 105
    Caption = 'Select a board size'
    ItemIndex = 1
    Items.Strings = (
      '3X3'
      '4X4'
      '5X5')
    TabOrder = 3
    OnClick = SizeGrpClick
  end
end
