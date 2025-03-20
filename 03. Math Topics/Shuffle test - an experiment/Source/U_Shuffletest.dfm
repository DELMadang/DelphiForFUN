object Form1: TForm1
  Left = 121
  Top = 93
  Width = 800
  Height = 600
  Caption = 'Card shuffling experiment'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Countlbl: TLabel
    Left = 608
    Top = 464
    Width = 71
    Height = 13
    Caption = 'Nbr. of shuffles'
  end
  object VarLbl: TLabel
    Left = 608
    Top = 488
    Width = 121
    Height = 41
    AutoSize = False
    Caption = 'Variance of mean card values in each position from expected'
    WordWrap = True
  end
  object Label1: TLabel
    Left = 56
    Top = 328
    Width = 50
    Height = 13
    Caption = 'Deck size:'
  end
  object Label2: TLabel
    Left = 8
    Top = 360
    Width = 97
    Height = 13
    Caption = 'Nbr Shuffles per run:'
  end
  object MeanLbl: TLabel
    Left = 608
    Top = 440
    Width = 83
    Height = 13
    Caption = 'Mean card value:'
  end
  object StopBtn: TButton
    Left = 16
    Top = 392
    Width = 161
    Height = 49
    Caption = 'Stop'
    TabOrder = 3
    OnClick = StopBtnClick
  end
  object StartBtn: TButton
    Left = 16
    Top = 400
    Width = 161
    Height = 25
    Caption = 'Start'
    TabOrder = 0
    OnClick = StartBtnClick
  end
  object Chart1: TChart
    Left = 216
    Top = 16
    Width = 568
    Height = 377
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      'Average Shuffled Card Value '
      '(By position in deck)')
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 52
    Legend.Alignment = laBottom
    View3D = False
    TabOrder = 1
    object Series1: TLineSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clRed
      Title = 'Old Shuffle'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clGreen
      Title = 'New Shuffle'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
  object SpinEdit1: TSpinEdit
    Left = 112
    Top = 328
    Width = 41
    Height = 22
    MaxValue = 52
    MinValue = 2
    TabOrder = 2
    Value = 50
  end
  object SpinEdit2: TSpinEdit
    Left = 112
    Top = 360
    Width = 57
    Height = 22
    MaxValue = 100000
    MinValue = 2
    TabOrder = 4
    Value = 500
  end
  object ListBox1: TListBox
    Left = 312
    Top = 416
    Width = 241
    Height = 97
    ItemHeight = 13
    TabOrder = 5
  end
  object ShowVarBox: TCheckBox
    Left = 32
    Top = 496
    Width = 257
    Height = 17
    Caption = 'Display 1st 100  cum. variance values'
    TabOrder = 6
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 193
    Height = 265
    Color = 14548991
    Lines.Strings = (
      'Comparison of existing shuffle method '
      'with a method which is,  in theory, more '
      'statistically correct.'
      ''
      'Old shuffle: Swap each card with any '
      'position in the deck.'
      ''
      'New shuffle: Swap each card only with '
      'positions not yet swapped. '
      ''
      'Non-scientific result: Definite bias of old '
      'method toward having too many high '
      'value cards near the end of the deck '
      'when each shuffle is with a "new '
      'deck".'
      ''
      'Note: card values here range from 0 to '
      'Decksize-1.  So mean card value is '
      '(Decksize-1)/2')
    TabOrder = 7
  end
  object ShowDetailbox: TCheckBox
    Left = 32
    Top = 520
    Width = 193
    Height = 17
    Caption = 'Display 1st 100 results'
    TabOrder = 8
  end
  object ResetBox: TCheckBox
    Left = 32
    Top = 472
    Width = 257
    Height = 17
    Caption = 'Reset deck after each shuffle'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 546
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
end
