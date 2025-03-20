object Form1: TForm1
  Left = 191
  Top = 120
  Width = 800
  Height = 609
  Caption = 'Text file update'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 592
    Top = 16
    Width = 30
    Height = 13
    Caption = 'Action'
  end
  object Label2: TLabel
    Left = 208
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Master'
  end
  object Label3: TLabel
    Left = 392
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Update'
  end
  object SumryLbl: TLabel
    Left = 200
    Top = 400
    Width = 265
    Height = 81
    AutoSize = False
    Caption = 'SumryLbl'
    WordWrap = True
  end
  object USumryLbl: TLabel
    Left = 496
    Top = 400
    Width = 273
    Height = 81
    AutoSize = False
    Caption = 'SumryLbl'
    WordWrap = True
  end
  object Label5: TLabel
    Left = 32
    Top = 496
    Width = 705
    Height = 16
    Caption = 
      'The program has not been extensively tested and is presented "as' +
      ' is" for your testing or modification.  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UpdateBtn: TButton
    Left = 24
    Top = 456
    Width = 153
    Height = 25
    Caption = 'Process updates'
    TabOrder = 0
    OnClick = UpdateBtnClick
  end
  object M_and_U_Grp: TRadioGroup
    Left = 24
    Top = 32
    Width = 153
    Height = 50
    Caption = 'Update rec matches Master'
    ItemIndex = 0
    Items.Strings = (
      'Delete Master record'
      'Ignore')
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 200
    Top = 32
    Width = 185
    Height = 345
    Lines.Strings = (
      '')
    ScrollBars = ssHorizontal
    TabOrder = 2
  end
  object DupMasterGrp: TRadioGroup
    Left = 24
    Top = 144
    Width = 153
    Height = 50
    Caption = 'Duplicates in Master'
    ItemIndex = 1
    Items.Strings = (
      'Accept duplicates'
      'Delete duplicates')
    TabOrder = 3
    OnClick = DupMasterGrpClick
  end
  object DupUpdateGrp: TRadioGroup
    Left = 24
    Top = 200
    Width = 153
    Height = 50
    Caption = 'Duplicates in Update'
    ItemIndex = 1
    Items.Strings = (
      'Process update'
      'Ignore update')
    TabOrder = 4
    Visible = False
    OnClick = DupUpdateGrpClick
  end
  object MatchingGrp: TRadioGroup
    Left = 24
    Top = 256
    Width = 153
    Height = 50
    Caption = 'Updates to Master matching'
    ItemIndex = 1
    Items.Strings = (
      'One to one'
      'One to many')
    TabOrder = 5
    Visible = False
  end
  object U_NotMGrp: TRadioGroup
    Left = 24
    Top = 88
    Width = 153
    Height = 50
    Caption = 'Update rec not in Master'
    ItemIndex = 1
    Items.Strings = (
      'Add to Master'
      'Ignore')
    TabOrder = 6
  end
  object Memo3: TMemo
    Left = 584
    Top = 32
    Width = 169
    Height = 345
    ScrollBars = ssBoth
    TabOrder = 7
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 383
    Top = 32
    Width = 201
    Height = 345
    Lines.Strings = (
      '')
    ScrollBars = ssHorizontal
    TabOrder = 8
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 525
    Width = 792
    Height = 33
    Panels = <
      item
        Text = 'Master File:'
        Width = 350
      end
      item
        Text = 'Update File:'
        Width = 350
      end>
    SimplePanel = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 558
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSingle
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
  object SelmasterBtn: TButton
    Left = 24
    Top = 392
    Width = 153
    Height = 25
    Caption = 'Select master file'
    TabOrder = 11
    OnClick = SelmasterBtnClick
  end
  object SelUpdateBtn: TButton
    Left = 24
    Top = 424
    Width = 153
    Height = 25
    Caption = 'Select update file'
    TabOrder = 12
    OnClick = SelUpdateBtnClick
  end
  object NoCase: TCheckBox
    Left = 24
    Top = 312
    Width = 145
    Height = 17
    Caption = 'Case insensitive , ('#39'a'#39'='#39'A'#39') '
    Checked = True
    State = cbChecked
    TabOrder = 13
    OnClick = NoCaseClick
  end
  object Trimbox: TCheckBox
    Left = 24
    Top = 336
    Width = 169
    Height = 17
    Caption = 'Trim leading && trailng blanks'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Txt files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 416
    Top = 32
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)'
    Title = 'Enter or select Output file name'
    Left = 320
    Top = 40
  end
  object OpenDialog2: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 456
    Top = 32
  end
end
