object DicMaintForm: TDicMaintForm
  Left = 231
  Top = 58
  AutoScroll = False
  Caption = 'Dictionary Maintenance'
  ClientHeight = 484
  ClientWidth = 901
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 62
    Top = 126
    Width = 33
    Height = 16
    Caption = 'Word'
  end
  object Label2: TLabel
    Left = 0
    Top = 0
    Width = 901
    Height = 25
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 
      '     Use  Ins &&  Del keys to add and delete words, double or ri' +
      'ght click to edit attributes.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label6: TLabel
    Left = 456
    Top = 280
    Width = 145
    Height = 57
    Caption = ' Type a word to search, press Enter to clear search field'
    WordWrap = True
  end
  object FindEdt: TEdit
    Left = 457
    Top = 340
    Width = 119
    Height = 24
    TabOrder = 1
    OnKeyPress = FindEdtKeyPress
  end
  object WordGrid: TStringGrid
    Left = 0
    Top = 25
    Width = 901
    Height = 233
    Align = alTop
    ColCount = 8
    DefaultColWidth = 105
    FixedCols = 0
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial Narrow'
    Font.Style = []
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnContextPopup = WordGridContextPopup
    OnDblClick = WordGridDblClick
    OnKeyDown = WordGridKeyDown
    OnKeyPress = WordGridKeyPress
  end
  object FindBtn: TButton
    Left = 462
    Top = 364
    Width = 74
    Height = 25
    Caption = 'Find word'
    TabOrder = 2
    OnClick = FindBtnClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 264
    Width = 441
    Height = 177
    TabOrder = 3
    object Label3: TLabel
      Left = 277
      Top = 54
      Width = 121
      Height = 16
      Caption = 'Min length to display'
    end
    object Label5: TLabel
      Left = 277
      Top = 110
      Width = 125
      Height = 16
      Caption = 'Max length to display'
    end
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 162
      Height = 16
      Caption = 'Show words beginning with '
    end
    object ABtn: TSpeedButton
      Left = 8
      Top = 23
      Width = 16
      Height = 22
      GroupIndex = 1
      Caption = 'a'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = ABtnClick
    end
    object MinLenEdit: TEdit
      Left = 346
      Top = 74
      Width = 31
      Height = 24
      TabOrder = 0
      Text = '1'
      OnChange = MinLenEditChange
    end
    object MaxLenEdit: TEdit
      Left = 346
      Top = 130
      Width = 31
      Height = 24
      TabOrder = 1
      Text = '15'
      OnChange = MaxLenEditChange
    end
    object UpDown1: TUpDown
      Left = 377
      Top = 74
      Width = 15
      Height = 24
      Associate = MinLenEdit
      Min = 1
      Max = 15
      Position = 1
      TabOrder = 2
    end
    object UpDown2: TUpDown
      Left = 377
      Top = 130
      Width = 15
      Height = 24
      Associate = MaxLenEdit
      Min = 1
      Max = 15
      Position = 15
      TabOrder = 3
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 54
      Width = 257
      Height = 112
      Caption = 'Display options'
      TabOrder = 4
      object Shownormal: TCheckBox
        Left = 16
        Top = 16
        Width = 96
        Height = 25
        Caption = 'Shownormal'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = checkboxclick
      end
      object Showabbrevs: TCheckBox
        Left = 16
        Top = 62
        Width = 145
        Height = 18
        Caption = 'Show abbreviations'
        TabOrder = 1
        OnClick = checkboxclick
      end
      object Showforeign: TCheckBox
        Left = 16
        Top = 39
        Width = 113
        Height = 24
        Caption = 'Show foreign'
        TabOrder = 2
        OnClick = checkboxclick
      end
      object Showcaps: TCheckBox
        Left = 16
        Top = 86
        Width = 136
        Height = 17
        Caption = 'Show caps'
        TabOrder = 3
        OnClick = checkboxclick
      end
    end
  end
  object GroupBox2: TGroupBox
    Left = 633
    Top = 315
    Width = 240
    Height = 103
    Caption = 'Special'
    TabOrder = 4
    object ReSortBtn: TButton
      Left = 24
      Top = 62
      Width = 166
      Height = 26
      Caption = 'Fixup:  Re-sort this letter'
      TabOrder = 0
      OnClick = ReSortBtnClick
    end
    object ScanBtn: TButton
      Left = 24
      Top = 24
      Width = 193
      Height = 24
      Caption = 'Scan a text file for new words'
      TabOrder = 1
      OnClick = ScanBtnClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 432
    Width = 901
    Height = 32
    Panels = <
      item
        Text = 'Letter'
        Width = 250
      end
      item
        Text = 'Normal'
        Width = 120
      end
      item
        Text = 'Abbrevs'
        Width = 120
      end
      item
        Text = 'Foreign'
        Width = 120
      end
      item
        Text = 'Capitalized'
        Width = 120
      end
      item
        Text = 'Total'
        Width = 70
      end>
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 464
    Width = 901
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2000-2003, 2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object MainMenu1: TMainMenu
    Left = 592
    Top = 200
    object Dictionary1: TMenuItem
      Caption = '&Dictionary'
      object Load1: TMenuItem
        Caption = '&Open'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As'
        OnClick = SaveAs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Dictionary (*.dic)|*.dic|Text (*.txt)|*.txt'
    Left = 552
    Top = 200
  end
  object TextOpenDlg: TOpenDialog
    Filter = 'Text file (*txt)|*.txt|Any file (*.*)|*.*'
    Title = 'Select a file to scan'
    Left = 512
    Top = 200
  end
  object PopupMenu1: TPopupMenu
    Left = 632
    Top = 200
    object Delete1: TMenuItem
      Caption = 'Delete'
      OnClick = Delete1Click
    end
    object abbreviation: TMenuItem
      Caption = 'abbreviation'
      OnClick = optionclick
    end
    object foreign: TMenuItem
      Caption = 'foreign word'
      OnClick = optionclick
    end
    object Capitalized: TMenuItem
      Caption = 'Capitalized'
      OnClick = optionclick
    end
  end
end
