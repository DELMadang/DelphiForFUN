object Form1: TForm1
  Left = 26
  Top = 76
  Width = 696
  Height = 480
  Caption = 'FlatLand Piano Movers'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 328
    Top = 8
    Width = 353
    Height = 345
  end
  object Label1: TLabel
    Left = 336
    Top = 376
    Width = 63
    Height = 13
    Caption = 'Piano Length'
  end
  object Label2: TLabel
    Left = 512
    Top = 376
    Width = 58
    Height = 13
    Caption = 'Piano Width'
  end
  object Label3: TLabel
    Left = 336
    Top = 416
    Width = 76
    Height = 13
    Caption = 'Corridor 1 Width'
  end
  object Label4: TLabel
    Left = 512
    Top = 416
    Width = 76
    Height = 13
    Caption = 'Corridor 2 Width'
  end
  object Label5: TLabel
    Left = 24
    Top = 416
    Width = 72
    Height = 13
    Hint = 'How many places to check as piano turns corner'
    Caption = 'Steps to check'
    ParentShowHint = False
    ShowHint = True
  end
  object TryMoveBtn: TBitBtn
    Left = 24
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Try move'
    TabOrder = 0
    OnClick = TryMoveBtnClick
  end
  object PLenUD: TUpDown
    Left = 465
    Top = 372
    Width = 12
    Height = 21
    Associate = PLengthEdt
    Min = 0
    Max = 200
    Position = 100
    TabOrder = 1
    Wrap = False
  end
  object PWidthUD: TUpDown
    Left = 641
    Top = 372
    Width = 12
    Height = 21
    Associate = PWidthEdt
    Min = 0
    Position = 35
    TabOrder = 2
    Wrap = False
  end
  object C1UD: TUpDown
    Left = 465
    Top = 412
    Width = 12
    Height = 21
    Associate = C1Edt
    Min = 0
    Position = 50
    TabOrder = 3
    Wrap = False
  end
  object C2UD: TUpDown
    Left = 641
    Top = 412
    Width = 12
    Height = 21
    Associate = C2Edt
    Min = 0
    Position = 75
    TabOrder = 4
    Wrap = False
  end
  object C1Edt: TEdit
    Left = 424
    Top = 412
    Width = 41
    Height = 21
    TabOrder = 5
    Text = '50'
    OnChange = PLengthEdtChange
  end
  object C2Edt: TEdit
    Left = 600
    Top = 412
    Width = 41
    Height = 21
    TabOrder = 6
    Text = '75'
    OnChange = PLengthEdtChange
  end
  object PLengthEdt: TEdit
    Left = 424
    Top = 372
    Width = 41
    Height = 21
    TabOrder = 7
    Text = '100'
    OnChange = PLengthEdtChange
  end
  object PWidthEdt: TEdit
    Left = 600
    Top = 372
    Width = 41
    Height = 21
    TabOrder = 8
    Text = '35'
    OnChange = PLengthEdtChange
  end
  object Steps: TEdit
    Left = 112
    Top = 416
    Width = 25
    Height = 17
    Hint = 'How many places to check as piano turns corner'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    Text = '16'
  end
  object StepsUD: TUpDown
    Left = 137
    Top = 416
    Width = 12
    Height = 17
    Hint = 'How many places to check as piano turns corner'
    Associate = Steps
    Min = 2
    ParentShowHint = False
    Position = 16
    ShowHint = True
    TabOrder = 10
    Wrap = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 305
    Height = 337
    Color = clYellow
    Lines.Strings = (
      'FlatLand Piano Movers, as part of their Total Quality '
      'Management project, has decided to focus on the job '
      'estimation process. Part of this process involves walking the '
      'proposed paths that are to be used to move a piano to see if it '
      
        'will fit through corridors and around corners. Now this is harde' +
        'r '
      'than it might seem,  since FlatLand is a 2-dimensional world. '
      ''
      'FlatLand pianos are rectangles of various sizes. FlatLand '
      'building codes require all turns in corridors to be right angle '
      'turns and prohibit ``T'#39#39' intersections. All dimensions are in '
      
        'furlongs. You can assume that each portion of a corridor is long' +
        ' '
      'enough so that other corners or doors into rooms don'#39't have '
      'any effect on getting around a turn. You can also assume that '
      'the piano is narrower than the width of any corridor. Note that '
      
        'the piano actually has to turn in the corner, since it can only ' +
        'be '
      
        'pushed or pulled on one of its shorter sides (there are no squar' +
        'e '
      'pianos). '
      ''
      'Your team'#39's job is to write a program for a palmtop computer '
      
        'that will determine if a given piano will fit around a corner in' +
        ' a '
      'corridor.  '
      ''
      '(Adapted from 1989 Southern California Regional ACM '
      'Programming contest) ')
    TabOrder = 11
  end
end
