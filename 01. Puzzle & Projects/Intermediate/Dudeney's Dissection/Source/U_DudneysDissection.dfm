object Form1: TForm1
  Left = 265
  Top = 107
  Width = 640
  Height = 480
  Caption = 'Dudney'#39's Dissection'
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
  object Image1: TImage
    Left = 312
    Top = 8
    Width = 313
    Height = 409
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 241
    Height = 225
    Color = clYellow
    Lines.Strings = (
      'In 1902,  puzzleist H.E. Dudeney discovered this '
      'interesting method of cutting a square into four '
      'pieces that can be reassembled to form an '
      'equilateral triangle with the same area.'
      ''
      'Here are three ways to play with this puzzle:'
      ''
      '     Hardest - print the outlines and try it yourself.'
      ''
      '     Easier -  let the program show you the '
      'dissection, then print, cut and reassemble into the '
      'triangle.'
      ''
      '     Real Wimp!  - let the program show you both '
      'the dissection and the reassembly. ')
    TabOrder = 0
  end
  object PrintBtn: TButton
    Left = 8
    Top = 360
    Width = 193
    Height = 25
    Caption = 'Print current image'
    TabOrder = 1
    OnClick = PrintBtnClick
  end
  object ShowGrp: TRadioGroup
    Left = 8
    Top = 248
    Width = 217
    Height = 105
    Caption = 'Display '
    ItemIndex = 0
    Items.Strings = (
      'Square and triangle outlines'
      'Disectected square'
      'Square reassembled as triangle')
    TabOrder = 2
    OnClick = ShowGrpClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object Button1: TButton
    Left = 8
    Top = 400
    Width = 193
    Height = 25
    Caption = 'View solution construction details'
    TabOrder = 4
    OnClick = Button1Click
  end
end
