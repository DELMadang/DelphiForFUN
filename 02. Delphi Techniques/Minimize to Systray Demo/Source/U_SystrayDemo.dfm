object Form1: TForm1
  Left = 181
  Top = 163
  Width = 696
  Height = 434
  Caption = 'Systray Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ModeGrp: TRadioGroup
    Left = 352
    Top = 16
    Width = 305
    Height = 81
    Caption = 'Mode'
    ItemIndex = 0
    Items.Strings = (
      'Systray icon stays visible '
      'Remove systray icon when program form is visible ')
    TabOrder = 0
    OnClick = ModeGrpClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 313
    Height = 161
    Color = 14548991
    Lines.Strings = (
      
        'This is a demonstration using system tray (systray - bottom righ' +
        't '
      'icon area) to hold the icon for a program.'
      ''
      'Typcially, systray icons remain visible while the programs are '
      'running (Volume control, Antivirus, Modem activity, etc.).  '
      ''
      'It also possible to remove the icon when the program is visible '
      'and redisplay it when the program is "minimized".'
      ''
      
        'To see the effect, click Minimize or Close icon in the top right' +
        ' '
      'corner of this form.'
      ' . ')
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 380
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 352
    Top = 112
    Width = 289
    Height = 193
    ActivePage = TabSheet2
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Label2: TLabel
        Left = 64
        Top = 48
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Button1: TButton
        Left = 64
        Top = 80
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Label1: TLabel
        Left = 48
        Top = 48
        Width = 32
        Height = 13
        Caption = 'Label1'
      end
      object Button2: TButton
        Left = 56
        Top = 72
        Width = 75
        Height = 25
        Caption = 'Button2'
        TabOrder = 0
      end
    end
  end
end
