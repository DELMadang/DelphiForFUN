object Form1: TForm1
  Left = 375
  Top = 177
  Width = 1006
  Height = 747
  Caption = 'Reaction Time  V4.03'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object TrialPnl: TPanel
    Left = 0
    Top = 7
    Width = 198
    Height = 573
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 88
      Height = 16
      Caption = 'Available tests'
    end
    object Label2: TLabel
      Left = 10
      Top = 394
      Width = 106
      Height = 16
      Caption = 'Description of test'
    end
    object Trialdefsbox: TListBox
      Left = 10
      Top = 39
      Width = 168
      Height = 317
      TabStop = False
      AutoComplete = False
      ExtendedSelect = False
      ItemHeight = 16
      TabOrder = 0
      OnClick = TrialDefsBoxChange
    end
    object Memo1: TMemo
      Left = 10
      Top = 423
      Width = 168
      Height = 169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'Select a test to run '
        'from list above')
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      OnMouseDown = Image1MouseDown
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 654
    Width = 988
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2001-2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 633
    Width = 988
    Height = 21
    Align = alBottom
    AutoSize = False
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 304
    Top = 30
    Width = 561
    Height = 444
    TabOrder = 3
    OnMouseDown = Image1MouseDown
    object Shape1: TShape
      Left = 28
      Top = 20
      Width = 80
      Height = 80
      Visible = False
      OnMouseDown = Image1MouseDown
    end
    object Image1: TImage
      Left = 200
      Top = 208
      Width = 105
      Height = 105
      AutoSize = True
      Center = True
    end
    object StartPnl: TPanel
      Left = 71
      Top = 38
      Width = 405
      Height = 326
      Color = clLime
      TabOrder = 0
      Visible = False
      OnClick = StartBtnClick
      DesignSize = (
        405
        326)
      object Memo2: TMemo
        Left = 30
        Top = 30
        Width = 345
        Height = 276
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        Color = clLime
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Select a trial at left and click here to '
          'start the test'
          ''
          'When target appears or sound is heard, '
          'click a mouse button or press any key '
          'as quickly as possible.  '
          ''
          '(It is not necessary to move the mouse '
          'to the target.)')
        ParentFont = False
        TabOrder = 0
        OnClick = StartBtnClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 392
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 320
    Top = 16
    object Administration1: TMenuItem
      Caption = 'Administration'
      object LogonNewUser1: TMenuItem
        Caption = 'Logon New User'
        OnClick = LogonNewUser1Click
      end
      object EditTrialDefinitions1: TMenuItem
        Caption = 'Set options && Edit trial definitions'
        OnClick = EditTrialDefinitions1Click
      end
    end
  end
end
