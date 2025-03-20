object Form1: TForm1
  Left = 77
  Top = 161
  Width = 868
  Height = 469
  Caption = 'Systray Demo2 - CoolTrayIcon Usage'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ModeGrp: TRadioGroup
    Left = 433
    Top = 20
    Width = 376
    Height = 99
    Caption = 'Mode'
    ItemIndex = 0
    Items.Strings = (
      'Systray icon stays visible '
      'Remove systray icon when program form is visible ')
    TabOrder = 0
    OnClick = ModeGrpClick
  end
  object Memo1: TMemo
    Left = 20
    Top = 20
    Width = 385
    Height = 355
    Color = 14548991
    Lines.Strings = (
      'This demonstration uses the  "CoolTrayIcon" component written'
      'by Troels Jakobsen.'
      ''
      'The component is much more comprehensive than the direct '
      'API '
      'calls used in the SystrayDemo1 version.  CoolTrayIcon handles '
      'differences in Windows and  Delphi versions, supports popup '
      'menus, animated cursors, control of hints display etc.  This '
      'demo '
      'simply uses the compnent to minimize the program to the systray '
      'and restore it when the tray icon is clicked.'
      ''
      'I use the component without installing it, meaning that the '
      
        'program must create the object itself and initialize any propert' +
        'ies '
      'that are different from defaults.'
      ''
      
        'Typcially, icons in the taskbar notification area (systray) rema' +
        'in '
      
        'visible while the program is running although it also possible t' +
        'o '
      'remove the icon when the program is visible.  Both modes are '
      'implemented here.'
      ''
      
        'To see the effect, click Minimize or Close icon in the top right' +
        ' '
      'corner of this form.'
      ' . '
      ' ')
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 400
    Width = 850
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
end
