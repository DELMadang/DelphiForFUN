object Form1: TForm1
  Left = 143
  Top = 39
  Width = 1136
  Height = 845
  Caption = 'Chart reaction time density fucntion  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 777
    Width = 1118
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, 2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Chart1: TChart
    Left = 261
    Top = 18
    Width = 838
    Height = 397
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Font.Charset = DEFAULT_CHARSET
    Title.Font.Color = clBlue
    Title.Font.Height = -16
    Title.Font.Name = 'Arial'
    Title.Font.Style = []
    Title.Text.Strings = (
      'Frequency Chart of Reaction Times')
    BottomAxis.AxisValuesFormat = '#,##0.##'
    BottomAxis.ExactDateTime = False
    BottomAxis.Increment = 0.100000000000000000
    BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
    BottomAxis.LabelsFont.Color = clBlack
    BottomAxis.LabelsFont.Height = -12
    BottomAxis.LabelsFont.Name = 'Arial'
    BottomAxis.LabelsFont.Style = []
    BottomAxis.LabelsSeparation = 5
    BottomAxis.PositionPercent = -1.000000000000000000
    BottomAxis.Title.Caption = 'Reaction Time (Seconds)'
    LeftAxis.AxisValuesFormat = '#,##0.#'
    LeftAxis.ExactDateTime = False
    LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
    LeftAxis.LabelsFont.Color = clBlack
    LeftAxis.LabelsFont.Height = -12
    LeftAxis.LabelsFont.Name = 'Arial'
    LeftAxis.LabelsFont.Style = []
    LeftAxis.Title.Caption = 'Percent'
    Legend.LegendStyle = lsValues
    Legend.ShadowSize = 4
    TabOrder = 1
    object Series1: TBarSeries
      ColorEachPoint = True
      Marks.ArrowLength = 20
      Marks.Visible = True
      SeriesColor = clRed
      ShowInLegend = False
      MultiBar = mbStacked
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
      object TeeFunction1: TAddTeeFunction
      end
    end
  end
  object SaveBmpBtn: TButton
    Left = 27
    Top = 153
    Width = 203
    Height = 28
    Caption = 'Save as bitmap file'
    TabOrder = 2
    OnClick = SaveBmpBtnClick
  end
  object PtintBtn: TButton
    Left = 27
    Top = 108
    Width = 199
    Height = 28
    Caption = 'Print it'
    TabOrder = 3
    OnClick = PtintBtnClick
  end
  object GetFileBtn: TButton
    Left = 27
    Top = 63
    Width = 203
    Height = 28
    Caption = 'Select reaction time file'
    TabOrder = 4
    OnClick = GetFileBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 549
    Top = 468
    Width = 550
    Height = 298
    Caption = 'Chart Controls'
    TabOrder = 5
    object Label1: TLabel
      Left = 36
      Top = 54
      Width = 64
      Height = 54
      Caption = 'Interval size (in seconds)'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 216
      Top = 54
      Width = 63
      Height = 18
      Caption = 'Max time'
    end
    object Label3: TLabel
      Left = 36
      Top = 117
      Width = 28
      Height = 18
      Caption = 'Title'
    end
    object MaxTimeEdt: TEdit
      Left = 279
      Top = 54
      Width = 37
      Height = 24
      TabOrder = 0
      Text = '1.0'
    end
    object IntvEdt: TEdit
      Left = 135
      Top = 54
      Width = 37
      Height = 24
      TabOrder = 1
      Text = '0.05'
    end
    object TitleEdit: TEdit
      Left = 72
      Top = 117
      Width = 460
      Height = 24
      TabOrder = 2
      Text = 'Title'
      OnChange = TitleEditChange
    end
    object ShowValues: TCheckBox
      Left = 45
      Top = 198
      Width = 262
      Height = 19
      Caption = 'Show values above bars'
      TabOrder = 3
      OnClick = ShowItBtnClick
    end
    object Coloredbars: TCheckBox
      Left = 45
      Top = 234
      Width = 109
      Height = 19
      Caption = 'Colored bars'
      TabOrder = 4
      OnClick = ShowItBtnClick
    end
    object ShowItBtn: TButton
      Left = 387
      Top = 54
      Width = 84
      Height = 28
      Caption = 'Show it'
      TabOrder = 5
      OnClick = ShowItBtnClick
    end
    object ChartType: TRadioGroup
      Left = 315
      Top = 153
      Width = 208
      Height = 118
      Caption = 'Chart Type'
      ItemIndex = 0
      Items.Strings = (
        'Frequency'
        'Percent'
        'Cumulative frequency'
        'Cumulative percent')
      TabOrder = 6
      OnClick = ShowItBtnClick
    end
  end
  object SaveWMFBtn: TButton
    Left = 27
    Top = 324
    Width = 203
    Height = 28
    Caption = 'Save as Metafile'
    TabOrder = 6
    OnClick = SaveWMFBtnClick
  end
  object Memo1: TMemo
    Left = 27
    Top = 198
    Width = 208
    Height = 118
    Lines.Strings = (
      '"Metafiles" , (WMF file '
      'extension), is much smaller '
      'and more scalable than '
      'bitmap images.  They can '
      'be '
      'imported to Word '
      'documents '
      'and resized to fit. ')
    TabOrder = 7
  end
  object Memo2: TMemo
    Left = 63
    Top = 477
    Width = 424
    Height = 91
    Color = 14548991
    Lines.Strings = (
      'This program will read  files of detailed reaction time results '
      'captured by the DelphiforFun "ReactionTimes" program '
      'and '
      'will produce frequency distribution charts in various '
      'versions.')
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    FileName = 'reactiondetail.rsd'
    Filter = 'Reaction detail (*.rsd)|*.rsd|All files (*.*)|*.*'
    Left = 448
    Top = 24
  end
end
