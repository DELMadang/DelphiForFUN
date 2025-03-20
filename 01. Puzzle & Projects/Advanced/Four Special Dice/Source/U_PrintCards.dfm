object Form2: TForm2
  Left = 116
  Top = 133
  Width = 798
  Height = 596
  Caption = 'Four Dice Problem - Cards representing a solution'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnDeactivate = FormDeactivate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 208
    Top = 8
    Width = 569
    Height = 449
  end
  object Label8: TLabel
    Left = 24
    Top = 272
    Width = 32
    Height = 13
    Caption = 'Across'
  end
  object Label9: TLabel
    Left = 24
    Top = 301
    Width = 28
    Height = 13
    Caption = 'Down'
  end
  object Memo3: TMemo
    Left = 8
    Top = 8
    Width = 185
    Height = 225
    Color = 14548991
    Lines.Strings = (
      'You can print a deck of cards '
      'representing a set of dice, one card '
      'for each side of each die and each '
      'die represented by a unique card '
      'back.'
      '   '
      'Set your printer to print in Landscape '
      'mode. :Fronts and backs may be '
      'printed separately with the paper '
      'reinserted between clicks to print the '
      'other side.  Or use the "Print Both" '
      'button if your printer suports duplex '
      'printing.   ')
    TabOrder = 0
  end
  object SpinEdit5: TSpinEdit
    Left = 96
    Top = 267
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 6
    OnChange = SpinEditChange
  end
  object SpinEdit6: TSpinEdit
    Left = 96
    Top = 296
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 4
    OnChange = SpinEditChange
  end
  object PreviewFrontBtn: TButton
    Left = 24
    Top = 336
    Width = 137
    Height = 25
    Caption = 'Preview fronts'
    TabOrder = 3
    OnClick = PreviewFrontBtnClick
  end
  object PreviewbackBtn: TButton
    Left = 24
    Top = 368
    Width = 137
    Height = 25
    Caption = 'Preview backs'
    TabOrder = 4
    OnClick = PreviewbackBtnClick
  end
  object PrtFrontBtn: TButton
    Left = 24
    Top = 408
    Width = 137
    Height = 25
    Caption = 'Print fronts...'
    TabOrder = 5
    OnClick = PrtBtnClick
  end
  object PrtBackBtn: TButton
    Left = 24
    Top = 440
    Width = 137
    Height = 25
    Caption = 'Print backs...'
    TabOrder = 6
    OnClick = PrtBtnClick
  end
  object PrtBothBtn: TButton
    Left = 24
    Top = 472
    Width = 137
    Height = 25
    Caption = 'Print Both...'
    TabOrder = 7
    OnClick = PrtBothBtnClick
  end
  object CloseBt: TButton
    Left = 24
    Top = 504
    Width = 137
    Height = 25
    Caption = 'Close'
    TabOrder = 8
    OnClick = CloseBtClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 545
    Width = 790
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 9
    OnClick = StaticText1Click
  end
  object PrintDialog1: TPrintDialog
    Left = 496
  end
end
