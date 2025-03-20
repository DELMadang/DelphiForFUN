object Form1: TForm1
  Left = 333
  Top = 200
  Width = 1486
  Height = 829
  Caption = 'The "Bug" time trials  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object Head: TShape
    Left = 516
    Top = 327
    Width = 35
    Height = 35
    Brush.Color = clRed
    Pen.Color = clRed
    Shape = stCircle
  end
  object Label11: TLabel
    Left = 39
    Top = 20
    Width = 53
    Height = 20
    Caption = 'Speed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 10
    Top = 63
    Width = 88
    Height = 20
    Caption = 'Turn Angle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object VLabel: TLabel
    Left = 305
    Top = 30
    Width = 71
    Height = 16
    Caption = '0 pixels/sec'
  end
  object ALabel: TLabel
    Left = 305
    Top = 59
    Width = 61
    Height = 16
    Caption = '0 degrees'
  end
  object Body: TShape
    Left = 499
    Top = 346
    Width = 70
    Height = 70
    Brush.Color = clRed
    Pen.Color = clRed
    Shape = stCircle
  end
  object Shape4: TShape
    Left = 761
    Top = 135
    Width = 19
    Height = 20
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape3: TShape
    Left = 761
    Top = 20
    Width = 19
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape8: TShape
    Left = 790
    Top = 645
    Width = 20
    Height = 20
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape7: TShape
    Left = 790
    Top = 529
    Width = 20
    Height = 20
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape9: TShape
    Left = 465
    Top = 414
    Width = 20
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape10: TShape
    Left = 583
    Top = 414
    Width = 20
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object StartLbl: TLabel
    Left = 455
    Top = 354
    Width = 33
    Height = 16
    Caption = 'Start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object EndLbl: TLabel
    Left = 455
    Top = 433
    Width = 28
    Height = 16
    Caption = 'End'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Shape1: TShape
    Left = 465
    Top = 335
    Width = 20
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape2: TShape
    Left = 583
    Top = 335
    Width = 20
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape5: TShape
    Left = 958
    Top = 335
    Width = 19
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object Shape6: TShape
    Left = 1076
    Top = 335
    Width = 19
    Height = 19
    Brush.Color = 65408
    Shape = stCircle
  end
  object DistanceLbl: TLabel
    Left = 662
    Top = 394
    Width = 92
    Height = 32
    Caption = '0 Pixels'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MsgLbl: TLabel
    Left = 24
    Top = 600
    Width = 39
    Height = 29
    Caption = 'Msg'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Comic Sans MS'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ResetBtn: TButton
    Left = 156
    Top = 562
    Width = 119
    Height = 31
    Caption = 'Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object VBar: TTrackBar
    Left = 108
    Top = 17
    Width = 185
    Height = 31
    Max = 100
    Min = -100
    TabOrder = 1
  end
  object AngleBar: TTrackBar
    Left = 108
    Top = 58
    Width = 185
    Height = 31
    Max = 90
    Min = -90
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 10
    Top = 104
    Width = 351
    Height = 441
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Use arrow keys or drag sliders above to '
      'control speed and direction of the "bug".   '
      'If the arrows keys on the numeric keypad '
      'are used, the "5" key can be used to '
      'returnthe  turn angle to zero.  The "Z" '
      'also resets the turn angle to zero.'
      ''
      'To "race", pass through the Start gate '
      'and the other 3 gates (without touching '
      'them!) in a clockwise direction and back '
      'to the End line in the shortest possible '
      'time and/or distance.   (My record is 19  '
      'seconds and 1370 pixels traveled on a '
      '1024 x 768 screen.).'
      ''
      'Version 2 add the  "Bug Size" group '
      'below which sets difficulty level by '
      'controling bug clearance thorugh the '
      'gates.'
      ''
      'Click the "Start" button below to begin.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
  end
  object StartBtn: TButton
    Left = 18
    Top = 562
    Width = 119
    Height = 31
    Caption = 'Start'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = StartBtnClick
  end
  object Panel1: TPanel
    Left = 662
    Top = 325
    Width = 228
    Height = 50
    Caption = 'Panel1'
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 761
    Width = 1468
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2006, 2014, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object BugSizeGrp: TRadioGroup
    Left = 24
    Top = 648
    Width = 337
    Height = 73
    Caption = 'Bug Size'
    Columns = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Aria;'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Easy'
      'Harder'
      'Expert')
    ParentFont = False
    TabOrder = 7
    OnClick = BugSizeGrpClick
  end
end
