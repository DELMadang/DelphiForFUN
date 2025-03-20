object Form1: TForm1
  Left = 145
  Top = 162
  Width = 724
  Height = 535
  Caption = 'Making Change #2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 288
    Width = 49
    Height = 33
    AutoSize = False
    Caption = 'Cents to change'
    WordWrap = True
  end
  object MakeChangeBtn: TButton
    Left = 8
    Top = 368
    Width = 121
    Height = 25
    Caption = 'Make Change'
    TabOrder = 0
    OnClick = MakeChangeBtnClick
  end
  object AmtUD: TUpDown
    Left = 57
    Top = 328
    Width = 12
    Height = 24
    Associate = Edit1
    Min = 0
    Max = 200
    Position = 100
    TabOrder = 1
    Wrap = False
  end
  object Edit1: TEdit
    Left = 8
    Top = 328
    Width = 49
    Height = 24
    TabOrder = 2
    Text = '100'
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 297
    Height = 249
    Color = clYellow
    Lines.Strings = (
      'It is common knowledge that  there are 293 ways '
      'to make change for a dollar bill. (But I  have  '
      'doubts about #293.)'
      ''
      'So are there are probably 586 ways to make '
      'change for $2.  Right?'
      ''
      'This version also solves two other problems.  '
      ''
      '1.. The smallest set of coins that cannot make '
      'change in no matter which coins make up the set.'
      ''
      '2.. The set of coins with largest value which '
      'cannot make change. '
      ' ')
    TabOrder = 3
  end
  object ListView1: TListView
    Left = 360
    Top = 16
    Width = 345
    Height = 457
    Columns = <
      item
        Caption = '#'
        Width = 40
      end
      item
        Caption = '$1 Coin'
        Width = 60
      end
      item
        Caption = '50c'
        Width = 40
      end
      item
        Caption = '25c'
        Width = 40
      end
      item
        Caption = '10c'
        Width = 40
      end
      item
        Caption = '5c'
        Width = 40
      end
      item
        Caption = '1c'
      end>
    TabOrder = 4
    ViewStyle = vsReport
  end
  object MinCountBtn: TButton
    Left = 8
    Top = 408
    Width = 233
    Height = 25
    Caption = 'Min set of coins that cannot make change'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = MinCountBtnClick
  end
  object MaxValBtn: TButton
    Left = 8
    Top = 448
    Width = 233
    Height = 25
    Caption = 'Max value of coins that will not make change'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = MaxValBtnClick
  end
  object StopBtn: TButton
    Left = 160
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 7
    Visible = False
    OnClick = StopBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 488
    Width = 716
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 8
    OnClick = StaticText1Click
  end
end
