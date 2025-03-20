object Form1: TForm1
  Left = 162
  Top = 191
  Width = 633
  Height = 470
  Anchors = [akLeft, akBottom]
  Caption = 'The Sevn Coins Puzzle'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel1: TBevel
    Left = 264
    Top = 24
    Width = 345
    Height = 305
    Visible = False
  end
  object MoveBtn: TButton
    Left = 16
    Top = 344
    Width = 193
    Height = 25
    Caption = 'Program  solution (add a coin)'
    TabOrder = 0
    OnClick = MoveBtnClick
  end
  object ResetBtn: TButton
    Left = 16
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 1
    OnClick = ResetBtnClick
  end
  object Panel1: TPanel
    Left = 16
    Top = 24
    Width = 233
    Height = 305
    BorderStyle = bsSingle
    Color = clYellow
    TabOrder = 2
    object Memo1: TMemo
      Left = 10
      Top = 10
      Width = 199
      Height = 279
      BorderStyle = bsNone
      Color = clYellow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'Place a coin on any unoccupied '
        'star point connected to an '
        'unoccupied star point and move it '
        'to the other end.  Can you do this '
        '6 more times so that 7 of the star '
        'points are occupied?'
        ''
        ' Click on a unoccupied star point '
        'to set a coin down (it will blink).  '
        'Click on an unoccupied point '
        'connected to this blinking coin to '
        'move it. '
        ''
        'The program is smart enough to '
        'win every time if you click the '
        '"Program solution" button 7 times '
        'on an empty board. '
        '  ')
      ParentFont = False
      TabOrder = 0
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 423
    Width = 625
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2000-2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 224
    Top = 8
  end
end
