object Form1: TForm1
  Left = 151
  Top = 67
  Width = 1018
  Height = 670
  Caption = 
    'Bitmap chunks V3.1  (Scans black/white bitmap for connected "chu' +
    'nks")'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 144
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Timelbl: TLabel
    Left = 24
    Top = 120
    Width = 234
    Height = 13
    Caption = 'Processed 0 chunks in 0 x0 image in 0.0 seconds'
  end
  object Label2: TLabel
    Left = 568
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Chunks found'
  end
  object Label3: TLabel
    Left = 568
    Top = 24
    Width = 161
    Height = 13
    Caption = 'Click a chunk to view points detail'
  end
  object Label4: TLabel
    Left = 784
    Top = 24
    Width = 152
    Height = 13
    Caption = 'Point information i(Row, Column)'
  end
  object Label5: TLabel
    Left = 688
    Top = 480
    Width = 110
    Height = 13
    Caption = '(Press scan button first)'
  end
  object Label6: TLabel
    Left = 592
    Top = 496
    Width = 145
    Height = 33
    AutoSize = False
    Caption = 'Select dark/bright cutoff level (0=Black, 255=White)'
    WordWrap = True
  end
  object RowCollbl: TLabel
    Left = 352
    Top = 152
    Width = 3
    Height = 13
  end
  object ScanBtn: TButton
    Left = 392
    Top = 48
    Width = 105
    Height = 25
    Caption = 'Scan for chunks'
    TabOrder = 0
    OnClick = ScanBtnClick
  end
  object ListBox1: TListBox
    Left = 568
    Top = 40
    Width = 193
    Height = 369
    ItemHeight = 13
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object Filegrp: TRadioGroup
    Left = 24
    Top = 40
    Width = 337
    Height = 65
    Caption = 'Select a file'
    Columns = 3
    ItemIndex = 1
    Items.Strings = (
      'Other file'
      'Test.bmp'
      'ClearType.bmp'
      'To.bmp'
      'Overlapped.bmp'
      'Fullpage.bmp')
    TabOrder = 2
    OnClick = FilegrpClick
  end
  object KeepPoints: TCheckBox
    Left = 392
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Retain point info'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 617
    Width = 1002
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object DoDiag: TCheckBox
    Left = 392
    Top = 112
    Width = 161
    Height = 17
    Caption = 'Allow diagonal connections'
    TabOrder = 5
  end
  object UsedColorsBtn: TButton
    Left = 792
    Top = 448
    Width = 177
    Height = 25
    Caption = 'Show lookup table for colors used'
    TabOrder = 6
    OnClick = UsedColorsBtnClick
  end
  object ListBox2: TListBox
    Left = 776
    Top = 40
    Width = 185
    Height = 369
    ExtendedSelect = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ItemHeight = 16
    ParentFont = False
    Style = lbOwnerDrawFixed
    TabOrder = 7
    OnDrawItem = ListBox2DrawItem
  end
  object SpinEdit1: TSpinEdit
    Left = 592
    Top = 528
    Width = 49
    Height = 22
    MaxValue = 255
    MinValue = 0
    TabOrder = 8
    Value = 250
  end
  object FormatGrp: TRadioGroup
    Left = 576
    Top = 432
    Width = 185
    Height = 49
    Caption = 'Pixel Format'
    ItemIndex = 1
    Items.Strings = (
      'Process as B/W'
      'Process as 256 color')
    TabOrder = 9
    OnClick = FormatGrpClick
  end
  object PreviewBtn: TButton
    Left = 792
    Top = 528
    Width = 177
    Height = 25
    Caption = 'Preview image'
    TabOrder = 10
    OnClick = PreviewBtnClick
  end
  object ScrollBox1: TScrollBox
    Left = 24
    Top = 176
    Width = 400
    Height = 425
    TabOrder = 11
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 396
      Height = 421
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
    object ZoomImage: TImage
      Left = 188
      Top = 192
      Width = 128
      Height = 128
      Visible = False
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 489
    Height = 25
    Lines.Strings = (
      
        'An investigation about how to efficiently identify parts of a bi' +
        'tmap separated by "white space". '
      ' '
      ''
      ''
      ' ')
    TabOrder = 12
  end
  object SelectType: TRadioGroup
    Left = 592
    Top = 560
    Width = 257
    Height = 49
    Caption = 'Brightness Type'
    ItemIndex = 0
    Items.Strings = (
      'Select based on average of R,G,B colors'
      'Select based on scaled HSV Brightness (0-255)')
    TabOrder = 13
    OnClick = SelectTypeClick
  end
  object FullColortableBtn: TButton
    Left = 792
    Top = 496
    Width = 177
    Height = 25
    Caption = 'Shpw full Color Lookup table'
    TabOrder = 14
    OnClick = UsedColorsBtnClick
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'Bmp (*.bmp)|*.bmp|All files (*.*)|*.*'
    Title = 'Select B/W BMP file to scan'
    Left = 936
    Top = 65512
  end
end
