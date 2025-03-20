object Form1: TForm1
  Left = 54
  Top = 92
  BorderStyle = bsSingle
  BorderWidth = 4
  Caption = 'SafeCracker'
  ClientHeight = 561
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 192
    Top = 0
    Width = 529
    Height = 529
    OnMouseDown = Image1MouseDown
  end
  object MakeBtn: TButton
    Left = 8
    Top = 304
    Width = 169
    Height = 25
    Caption = 'Make a new combination'
    TabOrder = 0
    OnClick = MakeBtnClick
  end
  object UnlockBtn: TButton
    Left = 8
    Top = 384
    Width = 169
    Height = 25
    Caption = 'Auto-unlock'
    TabOrder = 1
    OnClick = UnlockBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 169
    Height = 105
    Caption = 'Board Size'
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 40
      Height = 13
      Caption = 'Columns'
    end
    object Label2: TLabel
      Left = 24
      Top = 72
      Width = 27
      Height = 13
      Caption = 'Rows'
    end
    object ColEdt: TEdit
      Left = 80
      Top = 32
      Width = 25
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Text = '4'
      OnChange = EdtChange
    end
    object ColUD: TUpDown
      Left = 105
      Top = 32
      Width = 12
      Height = 21
      Associate = ColEdt
      Min = 2
      Max = 10
      Position = 4
      TabOrder = 1
      Wrap = False
    end
    object RowEdt: TEdit
      Left = 80
      Top = 64
      Width = 25
      Height = 21
      TabOrder = 2
      Text = '4'
      OnChange = EdtChange
    end
    object RowUD: TUpDown
      Left = 105
      Top = 64
      Width = 12
      Height = 21
      Associate = RowEdt
      Min = 2
      Max = 10
      Position = 4
      TabOrder = 3
      Wrap = False
    end
  end
  object ClearBtn: TButton
    Left = 8
    Top = 344
    Width = 169
    Height = 25
    Caption = 'Clear path'
    TabOrder = 3
    OnClick = ClearBtnClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 0
    Width = 169
    Height = 161
    Color = clYellow
    Lines.Strings = (
      'Unlock the safe by clicking all '
      'squares in order from first to last,  '
      'Last square is marked  "LAST".  It '
      'is up to you to find the first square. '
      ''
      'Each square except the last, has '
      'a number for the distance to move '
      'and a direction letter (U=Up, '
      'D=Down, L=Left, R=Right). ')
    TabOrder = 4
  end
  object SavePicBtn: TButton
    Left = 8
    Top = 144
    Width = 75
    Height = 25
    Caption = 'SavePicBtn'
    TabOrder = 5
    Visible = False
    OnClick = SavePicBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 541
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2002, 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
