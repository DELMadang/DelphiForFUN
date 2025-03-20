object Form1: TForm1
  Left = 240
  Top = 105
  AutoScroll = False
  Caption = 'Revolving Letters'
  ClientHeight = 560
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 539
    Width = 969
    Height = 21
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169'  2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    Transparent = False
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 969
    Height = 539
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 272
      Top = 19
      Width = 59
      Height = 16
      Caption = 'User input'
    end
    object Output: TLabel
      Left = 400
      Top = 191
      Width = 39
      Height = 16
      Caption = 'Output'
    end
    object Label2: TLabel
      Left = 72
      Top = 143
      Width = 87
      Height = 16
      Caption = 'Selected Input:'
    end
    object Label3: TLabel
      Left = 808
      Top = 178
      Width = 149
      Height = 16
      Caption = 'Special test for Sebastion'
      Visible = False
    end
    object Edit1: TEdit
      Left = 363
      Top = 16
      Width = 390
      Height = 24
      TabOrder = 0
      Text = '1234567890'
      OnChange = Edit1Change
    end
    object ToBase1Grp: TRadioGroup
      Left = 72
      Top = 257
      Width = 281
      Height = 49
      Caption = 'Output Base (OB1'
      Columns = 5
      ItemIndex = 3
      Items.Strings = (
        '2'
        '8'
        '10'
        '16'
        '256')
      TabOrder = 1
    end
    object Memo1: TMemo
      Left = 432
      Top = 213
      Width = 321
      Height = 164
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object FromBaseGrp: TRadioGroup
      Left = 64
      Top = 202
      Width = 281
      Height = 49
      Caption = 'Input Base (IB1)'
      Columns = 5
      DragKind = dkDock
      ItemIndex = 2
      Items.Strings = (
        '2'
        '8'
        '10'
        '16'
        '256')
      TabOrder = 3
    end
    object ToBase2Grp: TRadioGroup
      Left = 72
      Top = 312
      Width = 281
      Height = 49
      Caption = 'Output Base 2 (OB2)'
      Columns = 5
      ItemIndex = 3
      Items.Strings = (
        '2'
        '8'
        '10'
        '16'
        '256')
      TabOrder = 4
    end
    object Edit2: TEdit
      Left = 259
      Top = 62
      Width = 81
      Height = 24
      TabOrder = 5
      Text = '1000'
    end
    object OpsGrp: TRadioGroup
      Left = 16
      Top = 406
      Width = 409
      Height = 66
      Caption = 'Test choices'
      Color = 8454016
      ItemIndex = 0
      Items.Strings = (
        'From Input (IB1) to Output 1 (OB1)'
        'From Input (IB1) to Output 1 (OB1) then to Output 2 (OB2)')
      ParentBackground = False
      ParentColor = False
      TabOrder = 6
    end
    object ValidateBox: TCheckBox
      Left = 733
      Top = 383
      Width = 196
      Height = 59
      Caption = 'Validate result by converting Result back to Input base'
      Checked = True
      Color = 8454016
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      State = cbChecked
      TabOrder = 7
      WordWrap = True
    end
    object MakeRandomBtn: TButton
      Left = 64
      Top = 62
      Width = 189
      Height = 25
      Caption = 'Make Base 10 Random of size'
      TabOrder = 8
      OnClick = MakeRandomBtnClick
    end
    object SourceGrp: TRadioGroup
      Left = 64
      Top = 93
      Width = 620
      Height = 41
      Caption = 'Select soure to convert'
      Color = 8454016
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        'User Input'
        'Current Random'
        'Current Output')
      ParentBackground = False
      ParentColor = False
      TabOrder = 9
      OnClick = SourceGrpClick
    end
    object Edit3: TEdit
      Left = 363
      Top = 60
      Width = 390
      Height = 24
      ReadOnly = True
      TabOrder = 10
      Text = '1234567890'
    end
    object SelectedTxt: TEdit
      Left = 173
      Top = 140
      Width = 548
      Height = 24
      ReadOnly = True
      TabOrder = 11
      Text = '1234567890'
    end
    object DoItBtn: TButton
      Left = 678
      Top = 492
      Width = 75
      Height = 25
      Caption = 'DoIt!'
      TabOrder = 12
      OnClick = DoItBtnClick
    end
    object CodeGrp: TRadioGroup
      Left = 448
      Top = 407
      Width = 263
      Height = 65
      Caption = 'Code to test'
      Color = 8454016
      ItemIndex = 0
      Items.Strings = (
        'Test ConvertToBase function '
        'ConvertBase TBigInteger method  ')
      ParentBackground = False
      ParentColor = False
      TabOrder = 13
    end
    object Memo2: TMemo
      Left = 776
      Top = 19
      Width = 185
      Height = 115
      Lines.Strings = (
        'Note: User input is limited to '
        '50 characters.  Other inputs '
        'or outputs may be up '
        '1,000,000 characters but only '
        'the first 50 are displayed.')
      TabOrder = 14
    end
    object Button1: TButton
      Left = 808
      Top = 200
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 15
      Visible = False
      OnClick = Button1Click
    end
  end
end
