object Form1: TForm1
  Left = 157
  Top = 153
  Width = 690
  Height = 382
  Caption = 'Rearrange Listbox items with drag/drop (Version 2)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 416
    Top = 24
    Width = 169
    Height = 184
    DragMode = dmAutomatic
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    IntegralHeight = True
    ItemHeight = 18
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnDragDrop = ListBoxDragDrop
    OnDragOver = ListBoxDragOver
    OnDrawItem = ListBoxDrawItem
    OnStartDrag = ListBoxStartDrag
  end
  object Button1: TButton
    Left = 424
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 1
    OnClick = FormActivate
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 328
    Width = 682
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 345
    Height = 265
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'This is the 2nd version of a program which'
      'allows a listbox to be  rearranged by dragging'
      'items up or down.'
      ''
      'This version adds to the previous version by  '
      'using the OnDrawItem exit to draw a bold '
      'horizontal line on current drop point to indicate '
      'to the user where the dragged item will be '
      'placed.   '
      ''
      'Dragging however is still constrained to a single '
      'page at a time. '
      '')
    ParentFont = False
    TabOrder = 3
  end
end
