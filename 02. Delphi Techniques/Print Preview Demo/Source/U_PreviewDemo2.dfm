object Form1: TForm1
  Left = 229
  Top = 109
  Width = 800
  Height = 600
  Caption = 'Print Preview Demo  V2.3'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 493
    Top = 496
    Width = 19
    Height = 13
    Caption = 'Top'
  end
  object Label2: TLabel
    Left = 594
    Top = 496
    Width = 33
    Height = 13
    Caption = 'Bottom'
  end
  object Label3: TLabel
    Left = 400
    Top = 496
    Width = 18
    Height = 13
    Caption = 'Left'
  end
  object Label4: TLabel
    Left = 696
    Top = 496
    Width = 25
    Height = 13
    Caption = 'Right'
  end
  object Label5: TLabel
    Left = 392
    Top = 456
    Width = 337
    Height = 33
    AutoSize = False
    Caption = 
      'Margins in tenths of an inch  (e.g. 10 = 1.0").  Margins which e' +
      'xtend into the non-printable area display in red. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object PreviewBtn: TButton
    Left = 144
    Top = 484
    Width = 100
    Height = 25
    Caption = 'Preview  pages'
    TabOrder = 0
    OnClick = PreviewBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 353
    Height = 441
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's a demonstration of a "Print Preview" unit which will '
      'preview and print memo and stringlist data.  It handles '
      'multiple pages, scaling of the preview, and the ability to '
      'save print preview files and reload them at a later '
      'date.'
      ''
      'The string grid illustrates use of an OnDrawCell exit to '
      'display any cell with a valid numeric value in red and '
      'underlined.  (The grid is initially filled with random numbers '
      'and letters.  You can double click on any white cell to '
      'modify the data.)'
      ''
      'Version 2 adds automatic page breaking for  string grids '
      'which cross page boundaries.   Any fixed rows (i.e. '
      'column headings) are replicated at the top of each '
      'continuation page for the grid. '
      ''
      'The demo will preview or print the stringgrid at full page '
      'width followed by this memo text.  The  memo is then '
      'previewed in narrow format (2 inches on the printed page) '
      'followed by a 4 inch wide version of the stringgrid.'
      '  '
      'Version 2.1: Margin control added'
      'Version 2.2 adds a Margin Test button and fixes some '
      'margin errors.'
      'Version 2.3 Margins which result in using the non-printable '
      'area are displayed in red.')
    ParentFont = False
    TabOrder = 1
  end
  object StringGrid1: TStringGrid
    Left = 416
    Top = 24
    Width = 313
    Height = 417
    DefaultColWidth = 57
    DefaultDrawing = False
    RowCount = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
    OnDrawCell = StringGrid1DrawCell
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 784
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2004, 2011 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 3
  end
  object SetupBtn: TButton
    Left = 16
    Top = 484
    Width = 100
    Height = 25
    Caption = 'Printer setup'
    TabOrder = 4
    OnClick = SetupBtnClick
  end
  object MarginChkBtn: TButton
    Left = 272
    Top = 484
    Width = 100
    Height = 25
    Caption = 'Test Margins'
    TabOrder = 5
    OnClick = MarginChkBtnClick
  end
  object Edit1: TEdit
    Left = 493
    Top = 512
    Width = 25
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    Text = '10'
    OnChange = SetminMarginColors
  end
  object Edit2: TEdit
    Left = 392
    Top = 512
    Width = 25
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Text = '10'
    OnChange = SetminMarginColors
  end
  object Edit3: TEdit
    Left = 594
    Top = 512
    Width = 25
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    Text = '10'
    OnChange = SetminMarginColors
  end
  object Edit4: TEdit
    Left = 696
    Top = 512
    Width = 25
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    Text = '10'
    OnChange = SetminMarginColors
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 728
    Top = 24
  end
  object PrintDialog1: TPrintDialog
    Left = 728
    Top = 64
  end
end
