object Form1: TForm1
  Left = 247
  Top = 132
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  Anchors = []
  AutoScroll = False
  BiDiMode = bdLeftToRight
  Caption = 'Print Stringgrid test'
  ClientHeight = 559
  ClientWidth = 808
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 33
    Top = 355
    Width = 134
    Height = 42
    AutoSize = False
    Caption = 'Number of grids to print on a page'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    OnClick = PrintBtnClick
  end
  object StringGrid1: TStringGrid
    Left = 264
    Top = 336
    Width = 521
    Height = 185
    ColCount = 9
    Ctl3D = True
    DefaultColWidth = 50
    DefaultRowHeight = 50
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = []
    GridLineWidth = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
  end
  object PrintBtn: TButton
    Left = 24
    Top = 416
    Width = 189
    Height = 33
    Caption = 'Print'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = PrintBtnClick
  end
  object SpinEdit1: TSpinEdit
    Left = 168
    Top = 360
    Width = 41
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    MaxValue = 10
    MinValue = 1
    ParentFont = False
    TabOrder = 2
    Value = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 537
    Width = 808
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 32
    Top = 32
    Width = 737
    Height = 281
    Color = 14811135
    Lines.Strings = (
      
        'Here'#39's a program to test a "printgrid"  procedure which prints a' +
        ' Stringgrid starting at a specified location'
      
        'and within a specified width and height.  The printed grid is dr' +
        'awn using "Stretchdraw" so some'
      
        'degradation will occur if a small grid is printed in a large rec' +
        'tangular area.  The height to width aspect'
      'ratio of the grid on the screen will be maintained for printing.'
      ''
      
        'The calling program should use the provided XOffset and YOffset ' +
        'functions to get the physical offsets to'
      
        'the areas where printing is allowed.   Minimum X coordinate is X' +
        'offset and maximum X coordinate is'
      
        'Printer.Pagewidth - Xoffset.  The minimum vertical coordinate is' +
        ' YOffset and the maximum printable'
      'pixel value is Printer.Pageheight - YOffset.'
      ''
      ''
      
        'It is also the callers responsibility to establish any printer s' +
        'etup parameters and to issue "BeginDoc"'
      
        'before the first call and "EndDoc"  after the last call to Print' +
        'Grid.'
      ''
      '')
    TabOrder = 4
  end
end
