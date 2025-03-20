object Form1: TForm1
  Left = 573
  Top = 166
  Width = 1102
  Height = 760
  Caption = 
    'Bulk Find & Replace V2.0 (Now handles Uniciode text string corre' +
    'ctly)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 692
    Width = 1084
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, 2015, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1084
    Height = 692
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      1084
      692)
    object Label2: TLabel
      Left = 27
      Top = 27
      Width = 93
      Height = 19
      Caption = 'Select Drive'
    end
    object Label3: TLabel
      Left = 18
      Top = 92
      Width = 227
      Height = 19
      Caption = 'Double click to select a folder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 352
      Top = 32
      Width = 65
      Height = 19
      Caption = 'Look for'
    end
    object Label4: TLabel
      Left = 352
      Top = 72
      Width = 98
      Height = 19
      Caption = 'Replace with'
    end
    object Label5: TLabel
      Left = 352
      Top = 104
      Width = 72
      Height = 19
      Caption = 'File mask'
    end
    object Label6: TLabel
      Left = 24
      Top = 320
      Width = 189
      Height = 19
      Caption = 'Selected initial directory:'
    end
    object DirLbl: TLabel
      Left = 24
      Top = 344
      Width = 214
      Height = 19
      Caption = 'H:\DFF\Utilities\FindReplace'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object DriveComboBox1: TDriveComboBox
      Left = 27
      Top = 51
      Width = 280
      Height = 23
      DirList = DirectoryListBox1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Memo1: TMemo
      Left = 24
      Top = 400
      Width = 1041
      Height = 284
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 1
      WordWrap = False
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 23
      Top = 114
      Width = 290
      Height = 191
      DirLabel = DirLbl
      ItemHeight = 19
      TabOrder = 2
    end
    object FindStrEdt: TEdit
      Left = 424
      Top = 28
      Width = 121
      Height = 27
      TabOrder = 3
      Text = 'Test'
    end
    object ReplaceStrEdt: TEdit
      Left = 456
      Top = 68
      Width = 121
      Height = 27
      TabOrder = 4
      Text = 'Replaced'
    end
    object RecurseBox: TCheckBox
      Left = 352
      Top = 144
      Width = 241
      Height = 17
      Caption = 'Include subdirectories'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object MatchCaseBox: TCheckBox
      Left = 352
      Top = 176
      Width = 145
      Height = 17
      Caption = 'Match case'
      TabOrder = 6
    end
    object ActionRGrp: TRadioGroup
      Left = 632
      Top = 8
      Width = 401
      Height = 97
      Caption = 'Actions'
      ItemIndex = 0
      Items.Strings = (
        'Display only - do not  replace'
        'Replace first occurrence in file'
        'Replace all occurrences in file')
      TabOrder = 7
      OnClick = ActionRGrpClick
    end
    object MaskEdt: TEdit
      Left = 432
      Top = 104
      Width = 121
      Height = 27
      TabOrder = 8
      Text = 'T*.txt'
    end
    object GoBtn: TButton
      Left = 584
      Top = 352
      Width = 75
      Height = 25
      Caption = 'Go!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      TabOrder = 9
      OnClick = GoBtnClick
    end
    object Memo2: TMemo
      Left = 352
      Top = 264
      Width = 713
      Height = 81
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Lines.Strings = (
        
          'Note:  In general, changes are not reversible.  Please check the' +
          ' "Backup '
        
          'files" box or make other full backup of target folders  before u' +
          'sing a '
        '"Replace..." option.')
      ParentFont = False
      TabOrder = 10
    end
    object BackupBox: TCheckBox
      Left = 352
      Top = 208
      Width = 257
      Height = 49
      Caption = 'Backup files before changing with "Copy of"" prefix'
      Checked = True
      State = cbChecked
      TabOrder = 11
      WordWrap = True
    end
    object LineRGrp: TRadioGroup
      Left = 632
      Top = 120
      Width = 401
      Height = 81
      Caption = 'On each line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'LineRGrp'
      Font.Style = [fsBold, fsItalic]
      ItemIndex = 1
      Items.Strings = (
        'Check/change  1st occerrence'
        'Check/change all occurrences  ')
      ParentFont = False
      TabOrder = 12
    end
  end
end
