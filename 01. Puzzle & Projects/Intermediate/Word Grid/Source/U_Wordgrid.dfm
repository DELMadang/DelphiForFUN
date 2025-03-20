object Form1: TForm1
  Left = 467
  Top = 236
  AutoScroll = False
  Caption = 'The Brain Game Word Grid'
  ClientHeight = 485
  ClientWidth = 874
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 18
  object Label1: TLabel
    Left = 336
    Top = 368
    Width = 66
    Height = 18
    Caption = 'Checking'
  end
  object TestLbl: TLabel
    Left = 360
    Top = 392
    Width = 66
    Height = 18
    Caption = 'Test word'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 462
    Width = 874
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object StringGrid1: TStringGrid
    Left = 328
    Top = 32
    Width = 201
    Height = 201
    ColCount = 3
    DefaultRowHeight = 64
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 3
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -40
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goVertLine, goHorzLine, goDrawFocusSelected, goEditing]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 1
    OnClick = StringGrid1Click
    OnDrawCell = StringGrid1DrawCell
  end
  object MakeBtn: TButton
    Left = 320
    Top = 272
    Width = 217
    Height = 25
    Caption = 'Make word templates'
    TabOrder = 2
    OnClick = MakeBtnClick
  end
  object Memo1: TMemo
    Left = 568
    Top = 32
    Width = 185
    Height = 201
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Word Templates')
    ParentFont = False
    TabOrder = 3
  end
  object SearchBtn: TButton
    Left = 320
    Top = 312
    Width = 217
    Height = 25
    Caption = 'Search templates for words'
    Enabled = False
    TabOrder = 4
    OnClick = SearchBtnClick
  end
  object Memo2: TMemo
    Left = 576
    Top = 264
    Width = 273
    Height = 169
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Search Results')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object Memo3: TMemo
    Left = 16
    Top = 24
    Width = 289
    Height = 425
    Color = 13631487
    Lines.Strings = (
      'WORD GRID'
      ''
      '"A nine letter word is starts at a corner '
      'and spirals into the center.  Fill in the '
      'missing letters to find out what it is."'
      ''
      'This is the January 3 puzzle  from "The '
      'Brain Game", our daily puzzle calendar '
      'for 2013. (My rule is that I can use any '
      'program I have written as a brain '
      'extender! :>)'
      ''
      'Click the "Make templates", then '
      '"Search templates" buttons to process '
      'the grid.'
      ''
      'Modify the puzzle by clicking on any cell '
      'to enter "edit" mode. In this mode, click '
      'or use arrow keys to move to each cell '
      'to be changed.  Press "Make '
      'templates" button when editing is '
      'complete.'
      ''
      '')
    TabOrder = 6
  end
end
