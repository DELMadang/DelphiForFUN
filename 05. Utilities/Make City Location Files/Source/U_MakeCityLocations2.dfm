object Form1: TForm1
  Left = 336
  Top = 50
  AutoScroll = False
  AutoSize = True
  Caption = 'Make City Location File V2.0'
  ClientHeight = 563
  ClientWidth = 777
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 541
    Width = 777
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 777
    Height = 541
    Align = alClient
    BevelInner = bvRaised
    TabOrder = 1
    object Label2: TLabel
      Left = 40
      Top = 504
      Width = 148
      Height = 16
      Caption = 'Zip file contains 0 records'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Panel2: TPanel
      Left = 296
      Top = 56
      Width = 217
      Height = 441
      TabOrder = 4
      object Label1: TLabel
        Left = 40
        Top = 24
        Width = 169
        Height = 41
        AutoSize = False
        Caption = 'Please wait while city zip file is loaded'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object ProgressBar1: TProgressBar
        Left = 8
        Top = 88
        Width = 201
        Height = 17
        Step = 5
        TabOrder = 0
      end
    end
    object InListBox: TListBox
      Left = 8
      Top = 56
      Width = 289
      Height = 433
      ItemHeight = 14
      MultiSelect = True
      TabOrder = 0
      OnClick = InListBoxClick
    end
    object CityLocListBox: TListBox
      Left = 512
      Top = 56
      Width = 249
      Height = 425
      ItemHeight = 14
      TabOrder = 1
      OnClick = CityLocListBoxClick
    end
    object Memo1: TMemo
      Left = 328
      Top = 56
      Width = 145
      Height = 73
      BevelEdges = [beRight, beBottom]
      BevelInner = bvLowered
      BevelKind = bkSoft
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Color = 13171135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Click here to load a list '
        'of cities to have lat/long '
        'coordinates assigned '
        'or updated.   ')
      ParentFont = False
      TabOrder = 2
      OnClick = Memo1Click
    end
    object Memo2: TMemo
      Left = 320
      Top = 440
      Width = 169
      Height = 41
      BevelEdges = [beRight, beBottom]
      BevelInner = bvLowered
      BevelKind = bkSoft
      BevelOuter = bvRaised
      BorderStyle = bsNone
      Color = 13171135
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Click here to save selected '
        'cities list.')
      ParentFont = False
      TabOrder = 3
      OnClick = Memo2Click
    end
    object Memo3: TMemo
      Left = 312
      Top = 184
      Width = 185
      Height = 153
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Click a line in the complete '
        'list of cities (left side) to add '
        'it to the selected cities list '
        '(right side).'
        ''
        'Selected  a line in the right '
        'side cities list and press Del '
        'key to remove it from the list.')
      ParentFont = False
      TabOrder = 5
    end
    object Memo4: TMemo
      Left = 8
      Top = 8
      Width = 289
      Height = 41
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Complete list of city locations derived from U.S. '
        'zip code files')
      ParentFont = False
      TabOrder = 6
    end
    object Memo5: TMemo
      Left = 512
      Top = 8
      Width = 249
      Height = 41
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Selected records containing (city, state-'
        'id, latitude, longitude) records  to save.')
      ParentFont = False
      TabOrder = 7
    end
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 376
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    Left = 440
    Top = 24
  end
end
