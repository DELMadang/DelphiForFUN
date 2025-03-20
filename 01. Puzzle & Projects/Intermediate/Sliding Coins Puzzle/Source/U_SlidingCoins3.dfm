object Form1: TForm1
  Left = 24
  Top = 80
  Width = 732
  Height = 480
  Caption = 
    'Click and drag to move a large/small or small/large pair to reac' +
    'h goal arrangement '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDragDrop = CoinDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 96
  TextHeight = 20
  object Label1: TLabel
    Left = 288
    Top = 328
    Width = 52
    Height = 20
    Caption = 'Moves'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 48
    Top = 400
    Width = 131
    Height = 20
    Caption = 'Goal Arrangement'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 16
    Width = 666
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Click and drag to move large/small or small/large pairs to reach' +
      ' goal arrangement  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object ResetBtn: TButton
    Left = 416
    Top = 336
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object MoveEdt: TEdit
    Left = 288
    Top = 360
    Width = 57
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    Text = '0'
  end
  object SolveBtn: TButton
    Left = 416
    Top = 392
    Width = 97
    Height = 25
    Caption = 'Auto Solve'
    TabOrder = 2
    OnClick = SolveBtnClick
  end
  object Panel1: TPanel
    Left = 56
    Top = 328
    Width = 161
    Height = 57
    TabOrder = 3
    object Shape1: TShape
      Left = 8
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = clBlue
      Shape = stCircle
    end
    object Shape2: TShape
      Left = 68
      Top = 8
      Width = 40
      Height = 40
      Brush.Color = clBlue
      Shape = stCircle
    end
    object Shape3: TShape
      Left = 28
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = clBlue
      Shape = stCircle
    end
    object Shape4: TShape
      Left = 48
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = clBlue
      Shape = stCircle
    end
    object Shape5: TShape
      Left = 108
      Top = 8
      Width = 40
      Height = 40
      Brush.Color = clBlue
      Pen.Width = 0
      Shape = stCircle
    end
  end
  object Memo1: TMemo
    Left = 496
    Top = 80
    Width = 225
    Height = 321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 4
    Visible = False
  end
end
