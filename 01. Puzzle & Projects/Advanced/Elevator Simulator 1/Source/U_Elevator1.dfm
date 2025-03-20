object Form1: TForm1
  Left = 41
  Top = 51
  Width = 1086
  Height = 769
  Caption = 'Elevator Simulator - Version 1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnMouseUp = ElMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 10
    Top = 0
    Width = 346
    Height = 671
    Visible = False
  end
  object Label1: TLabel
    Left = 758
    Top = 49
    Width = 98
    Height = 16
    Caption = 'Number of floors'
  end
  object Label2: TLabel
    Left = 738
    Top = 98
    Width = 122
    Height = 16
    Caption = 'Number of Elevators'
  end
  object Label3: TLabel
    Left = 414
    Top = 650
    Width = 304
    Height = 20
    Caption = 'Click an elevator to select destination floors'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object FloorEdit: TSpinEdit
    Left = 866
    Top = 38
    Width = 51
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MaxValue = 8
    MinValue = 2
    ParentFont = False
    TabOrder = 0
    Value = 5
    OnChange = FloorEditChange
  end
  object ElevEdit: TSpinEdit
    Left = 866
    Top = 89
    Width = 51
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MaxValue = 6
    MinValue = 1
    ParentFont = False
    TabOrder = 1
    Value = 2
    OnChange = ElevEditChange
  end
  object ElPanel: TPanel
    Left = 384
    Top = 10
    Width = 139
    Height = 168
    Caption = 'ElPanel'
    Color = clOlive
    TabOrder = 2
    Visible = False
    OnClick = CloseBtnClick
    object ElLbl: TLabel
      Left = 0
      Top = 0
      Width = 70
      Height = 16
      Caption = 'Elevator # 1'
    end
    object Label4: TLabel
      Left = 10
      Top = 30
      Width = 87
      Height = 16
      Caption = 'Select Floor(s)'
    end
    object ElButtonBox: TCheckListBox
      Left = 10
      Top = 49
      Width = 119
      Height = 70
      OnClickCheck = ElButtonBoxClick
      BiDiMode = bdLeftToRight
      Color = clAqua
      Columns = 3
      Flat = False
      ItemHeight = 16
      Items.Strings = (
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8')
      ParentBiDiMode = False
      TabOrder = 0
      TabWidth = 6
    end
    object CloseBtn: TButton
      Left = 10
      Top = 128
      Width = 119
      Height = 31
      Caption = 'Close doors'
      TabOrder = 1
      OnClick = CloseBtnClick
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 704
    Width = 1068
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  '#169' 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 394
    Top = 187
    Width = 523
    Height = 435
    Color = 8454143
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        ' This is version 1 of an elevator simulator.  This version imple' +
        'ments '
      
        'manual   control of up to 6 elevators traveling across 2 to 8 fl' +
        'oors with '
      
        'up/down Call   buttons outside of the elevators and Floor button' +
        's inside '
      'each car.'
      ''
      
        'A simple control strategy is implemented.  Elevators have enough' +
        ' '
      
        'internal   intelligence to handle all floor and call buttons mov' +
        'ing in one '
      
        'direction and  then those requests requiring travel in the oppos' +
        'ite '
      
        'direction.  Calls are assigned   by the scheduler to the first s' +
        'topped car '
      'found.'
      ''
      
        'Version 1 is presented primarily for programmers wishing to stud' +
        'y '
      'the code required to animate multiple elevators operating '
      'independently '
      '(using a technique called "threading" ).'
      ''
      
        'The next version will allow user to control the strategy for ser' +
        'vicing calls '
      
        'with the objective of minimizing total wait time for a particula' +
        'r set of '
      'passenger arrivals.'
      ' '
      ' ')
    ParentFont = False
    TabOrder = 4
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 648
    Top = 40
  end
end
