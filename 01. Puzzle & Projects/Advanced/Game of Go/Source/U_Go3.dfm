object Form1: TForm1
  Left = 115
  Top = 136
  Width = 814
  Height = 625
  Caption = 'Go - Version 3.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Image1: TImage
    Left = 240
    Top = 16
    Width = 500
    Height = 500
    OnMouseUp = Image1MouseUp
  end
  object TurnLbl: TLabel
    Left = 96
    Top = 128
    Width = 91
    Height = 20
    Caption = 'Black plays'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 264
    Width = 104
    Height = 20
    Caption = 'White Score:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Whitescorelbl: TLabel
    Left = 144
    Top = 264
    Width = 11
    Height = 20
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 296
    Width = 102
    Height = 20
    Caption = 'Black Score:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object blackscorelbl: TLabel
    Left = 144
    Top = 296
    Width = 11
    Height = 20
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape1: TShape
    Left = 32
    Top = 112
    Width = 49
    Height = 49
    Brush.Color = clBlack
    Shape = stCircle
  end
  object Button1: TButton
    Left = 24
    Top = 184
    Width = 81
    Height = 25
    Caption = 'Pass'
    TabOrder = 0
    OnClick = Button1Click
  end
  object BoardSizeGrp: TRadioGroup
    Left = 32
    Top = 16
    Width = 185
    Height = 81
    Caption = 'Board size'
    ItemIndex = 0
    Items.Strings = (
      '9 X 9'
      '13 X 13'
      '19 X 19')
    TabOrder = 1
    OnClick = BoardSizeGrpClick
  end
  object ResetBtn: TButton
    Left = 120
    Top = 184
    Width = 83
    Height = 25
    Caption = 'New game'
    TabOrder = 2
    OnClick = ResetBtnClick
  end
  object modegrp: TRadioGroup
    Left = 16
    Top = 336
    Width = 201
    Height = 81
    Caption = 'Mode'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Normal play'
      'DEBUG/PRACTICE - Black only'
      'DEBUG/PRACTICE -White only')
    ParentFont = False
    TabOrder = 3
    OnClick = modegrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 569
    Width = 798
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005,2007  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 16
    Top = 432
    Width = 201
    Height = 57
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'In  Debug modes, stones are '
      'displayed with currently assigned block '
      'number and right clicks will remove '
      'stones.')
    ParentFont = False
    TabOrder = 5
  end
  object UndoBtn: TButton
    Left = 24
    Top = 224
    Width = 177
    Height = 25
    Caption = 'Undo last move'
    TabOrder = 6
    OnClick = UndoBtnClick
  end
  object SaveBtn: TButton
    Left = 16
    Top = 528
    Width = 91
    Height = 25
    Caption = 'Save board...'
    TabOrder = 7
    OnClick = SaveBtnClick
  end
  object LoadBtn: TButton
    Left = 128
    Top = 528
    Width = 91
    Height = 25
    Caption = 'Load Board ...'
    TabOrder = 8
    OnClick = LoadBtnClick
  end
  object ReloadBtn: TButton
    Left = 240
    Top = 528
    Width = 217
    Height = 25
    Caption = 'Restore previously loaded board'
    TabOrder = 9
    OnClick = ReloadBtnClick
  end
  object Savedialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text file (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 616
    Top = 24
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 544
    Top = 24
  end
end
