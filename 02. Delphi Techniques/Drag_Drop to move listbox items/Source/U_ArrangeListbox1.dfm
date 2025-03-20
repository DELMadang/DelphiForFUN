object Form1: TForm1
  Left = 189
  Top = 152
  Width = 690
  Height = 439
  Caption = 'Rearrange Listbox items with drag/drop'
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
    Height = 276
    DragMode = dmAutomatic
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    IntegralHeight = True
    ItemHeight = 16
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnDragDrop = ListBoxDragDrop
    OnDragOver = ListBoxDragOver
    OnStartDrag = ListBoxStartDrag
  end
  object Button1: TButton
    Left = 424
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 1
    OnClick = FormActivate
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 392
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
    Height = 337
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'This is the initial and simplest  version of '
      'a program which allows a listbox to be  '
      'rearranged by dragging items up or down.'
      ''
      'It uses Delphi'#39's built-in drag/drop methods to '
      'keep track of where the items is to be dropped.   '
      'The actual movement of the selected item takes '
      'place when the mouse button is released and '
      'the OnDragDrop event is processed. Scrolling is '
      'limited to one page at a time. Drag the top or '
      'bottom of a page and use the scroll bar to '
      'continue the drag on an adjacent page.other  if '
      'the'
      ''
      'A "Reset" button redraws the initial '
      'arrangement.')
    ParentFont = False
    TabOrder = 3
  end
end
