object Form1: TForm1
  Left = 270
  Top = 198
  Width = 1203
  Height = 775
  Caption = 'Fast File Search'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object SelectedDriveLbl: TLabel
    Left = 32
    Top = 89
    Width = 267
    Height = 40
    Caption = 
      'Click to navigate, Double-click to select inital folder for sear' +
      'ch.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 32
    Top = 24
    Width = 110
    Height = 20
    Caption = 'Select a drive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 32
    Top = 552
    Width = 240
    Height = 20
    Caption = 'Findf files matching this madk'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 32
    Top = 472
    Width = 163
    Height = 20
    Caption = 'Initial folder seleced'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CountLbl: TLabel
    Left = 472
    Top = 640
    Width = 189
    Height = 24
    Caption = 'Files found count: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 480
    Top = 96
    Width = 417
    Height = 49
    AutoSize = False
    Caption = 
      'Search results display below.  Double click any result entry to ' +
      'open the file or explore the folder. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 32
    Top = 574
    Width = 190
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '*.log'
  end
  object DriveComboBox1: TDriveComboBox
    Left = 32
    Top = 48
    Width = 200
    Height = 26
    AutoDropDown = True
    DirList = DirectoryListBox1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    TextCase = tcUpperCase
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 32
    Top = 136
    Width = 297
    Height = 305
    ItemHeight = 19
    TabOrder = 2
    OnClick = DirectoryListBox1Click
  end
  object Memo1: TMemo
    Left = 480
    Top = 144
    Width = 681
    Height = 489
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Never being able to get Windows 7 Search to work as advetised, I' +
        ' '
      'developed this file name search program as the easy way out.'
      ''
      
        'Usage should be quite self explanatory.  Choose a drive, then an' +
        ' initial '
      
        'folder for the search, then a "masK" to filter files to be liste' +
        'd..'
      ''
      
        'The output list is a simple tree structure with each folder/subf' +
        'older'
      
        'indented by a few character positions.  This avoids very long fi' +
        'le name '
      'strings for deeply embedded files.'
      ''
      
        'The edit boxes above specify characters to use to mark file and ' +
        'folders.'
      
        'The left-most charater in the text box will inserted before disp' +
        'layed'
      
        'entries.  Output limit can be set in the rightmost group box abo' +
        've.  There '
      
        'is also a Stop button displayed during runs which will abort the' +
        ' search.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 3
    OnDblClick = Memo1DblClick
  end
  object TypeBtn: TButton
    Left = 40
    Top = 640
    Width = 265
    Height = 25
    Caption = 'Find files '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = TypeBtnClick
  end
  object Edit2: TEdit
    Left = 32
    Top = 496
    Width = 305
    Height = 27
    TabOrder = 5
    Text = 'Edit2'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 705
    Width = 1185
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object LabeledEdit1: TLabeledEdit
    Left = 576
    Top = 32
    Width = 73
    Height = 27
    EditLabel.Width = 87
    EditLabel.Height = 40
    EditLabel.Caption = 'Placeholder  for folders'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clMaroon
    EditLabel.Font.Height = -17
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    EditLabel.Layout = tlCenter
    EditLabel.WordWrap = True
    LabelPosition = lpLeft
    TabOrder = 7
    Text = '- (Minus)'
  end
  object LabeledEdit2: TLabeledEdit
    Left = 768
    Top = 32
    Width = 81
    Height = 27
    EditLabel.Width = 87
    EditLabel.Height = 40
    EditLabel.Caption = 'Placeholder for files'
    EditLabel.Font.Charset = DEFAULT_CHARSET
    EditLabel.Font.Color = clMaroon
    EditLabel.Font.Height = -17
    EditLabel.Font.Name = 'MS Sans Serif'
    EditLabel.Font.Style = []
    EditLabel.ParentFont = False
    EditLabel.Layout = tlCenter
    EditLabel.WordWrap = True
    LabelPosition = lpLeft
    TabOrder = 8
    Text = ' (Blank)'
  end
  object CountGrp: TRadioGroup
    Left = 928
    Top = 24
    Width = 185
    Height = 65
    Caption = 'Limit found file count to'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 1
    Items.Strings = (
      '10'
      '100'
      '1000'
      'All')
    ParentFont = False
    TabOrder = 9
  end
  object StopPnl: TPanel
    Left = 32
    Top = 664
    Width = 281
    Height = 33
    Caption = 'Stop'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = StopPnlClick
  end
end
