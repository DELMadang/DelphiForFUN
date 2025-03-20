object Form1: TForm1
  Left = 191
  Top = 104
  Width = 796
  Height = 500
  Caption = 'Arrage Listbox with auto scroll (Version 3)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = ResetBtnClick
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Listbox2: TListBox
    Left = 568
    Top = 24
    Width = 169
    Height = 209
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ItemHeight = 13
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnDrawItem = ListBoxDrawItem
    OnMouseDown = Listbox2MouseDown
    OnMouseMove = Listbox2MouseMove
    OnMouseUp = Listbox2MouseUp
  end
  object Button1: TButton
    Left = 576
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 1
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 446
    Width = 788
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
    Left = 24
    Top = 24
    Width = 465
    Height = 353
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'This is the 3rd version of a program which allows a '
      'listbox to be  rearranged by dragging items up or down.'
      ''
      ' This version replaces Delphi'#39's built in drag/drop processing '
      'with  Mouse events.  The advantage is that we can capture '
      'the mouse so that when the  cursor moves above or below '
      
        'the listbox we can start automatic scrolling to  bring additiona' +
        'l '
      'items into view.  While dragging, if the cursor moves above or '
      'below the listbox and there are items to scroll,  a timer is '
      'started to scroll up or down one item at a time until drag ends '
      'or mouse is moved back over the listbox.'
      ''
      'If the "Verbose" box is checked, this description will be '
      'replaced by information about the various index values '
      'as the mouse drags an item.  It was useful during '
      'debugging so I left it in "just in case". ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Verbose: TCheckBox
    Left = 576
    Top = 296
    Width = 161
    Height = 17
    Caption = 'Verbose (for debugging)'
    TabOrder = 4
  end
  object scrollList: TTimer
    Enabled = False
    Interval = 500
    OnTimer = scrollListTimer
    Left = 552
    Top = 400
  end
end
