object Form1: TForm1
  Left = 526
  Top = 86
  Width = 726
  Height = 734
  Caption = 'Countdown timer class Demo  Version 2.1'
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
  object Memo1: TMemo
    Left = 18
    Top = 18
    Width = 676
    Height = 262
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'Here is a demo program for a TCountDown timer control.  The cont' +
        'rol uses a TPanel as the'
      
        'prototype  passed to the Create constructor.  The size, location' +
        ', font, ownership, and'
      
        'parentage are inherited from the prototype.  The timer also has ' +
        'an "OnExpired" event exit,'
      'which is initially set as the "OnExit" event in the prototype.  '
      ''
      
        'Each timer has one second resolution and may be Digital (numbers' +
        ' only) or Analog, a clock'
      
        'face with optional numerical time displayed below the clock face' +
        '. Time is displayed as hours,'
      
        'minutes and seconds remaining.  For the Analog version, the nume' +
        'rical display appears'
      
        'automatically in the area by which the height exceeds the width.' +
        '  If the height does not'
      'exceed the width, no numbers are displayed.'
      ''
      
        'The numerical time display ihas format HH:MM:SS if start time is' +
        ' greater than one hour,'
      
        'MM:SS otherwise.  Text is sized to fit the available space.  A o' +
        'nce per second click sound'
      
        'may be  turned on or off.  Methods are provided to Set, Start,  ' +
        'and Stop the timer.'
      ''
      
        'Version 2: The timer may now be set to run in either direction, ' +
        'up or down.  The displayed'
      
        'time now does not depend on the timer being updated every second' +
        '. In version 1,  a busy'
      
        'computer might have caused the timer to "run slow".  This versio' +
        'n always updates the time to'
      
        'reflect time since the timer was started, even if an interim upd' +
        'ate was missed.'
      ''
      
        'Version 2.1 tests the new "OnTimerPop" exit to give user acess o' +
        'nce per second. In this '
      
        'demo, the digital display panel has a checkbox to tell the timer' +
        ' pop exit procedure to "beep" '
      'on minute boundaries.'
      ''
      '')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 667
    Width = 708
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2006, 2016   Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object GroupBox1: TGroupBox
    Left = 18
    Top = 288
    Width = 289
    Height = 316
    Caption = 'Analog timer'
    TabOrder = 2
    object Label1: TLabel
      Left = 9
      Top = 108
      Width = 13
      Height = 21
      Caption = 'H'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 99
      Top = 108
      Width = 15
      Height = 21
      Caption = 'M'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 198
      Top = 108
      Width = 12
      Height = 21
      Caption = 'S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TimeExpiredA: TLabel
      Left = 162
      Top = 279
      Width = 77
      Height = 18
      Caption = 'Time is up!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object StartBtnA: TButton
      Left = 18
      Top = 198
      Width = 100
      Height = 28
      Caption = 'Start timer'
      TabOrder = 0
      OnClick = StartBtnClick
    end
    object StopBtnA: TButton
      Left = 18
      Top = 243
      Width = 100
      Height = 28
      Caption = 'Stop timer'
      TabOrder = 1
      OnClick = StopBtnClick
    end
    object SoundBoxA: TCheckBox
      Left = 18
      Top = 36
      Width = 109
      Height = 19
      Caption = 'Audible click'
      TabOrder = 2
      OnClick = SoundBoxClick
    end
    object SetBtnA: TButton
      Left = 18
      Top = 153
      Width = 100
      Height = 28
      Caption = 'Set timer'
      TabOrder = 3
      OnClick = SetBtnClick
    end
    object HSpinEditA: TSpinEdit
      Left = 36
      Top = 104
      Width = 46
      Height = 28
      MaxLength = 23
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object MSpinEditA: TSpinEdit
      Left = 126
      Top = 104
      Width = 46
      Height = 28
      MaxValue = 59
      MinValue = 0
      TabOrder = 5
      Value = 2
    end
    object SSpinEditA: TSpinEdit
      Left = 225
      Top = 104
      Width = 46
      Height = 28
      MaxValue = 59
      MinValue = 0
      TabOrder = 6
      Value = 30
    end
    object PanelA: TPanel
      Left = 162
      Top = 153
      Width = 91
      Height = 109
      Color = 16777111
      TabOrder = 7
      OnExit = PanelDExit
    end
    object DirectionA: TRadioGroup
      Left = 144
      Top = 18
      Width = 127
      Height = 73
      Caption = 'Clock Direction'
      ItemIndex = 1
      Items.Strings = (
        'Up'
        'Down')
      TabOrder = 8
    end
  end
  object GroupBox2: TGroupBox
    Left = 405
    Top = 288
    Width = 289
    Height = 316
    Caption = 'Dgital Timer'
    TabOrder = 3
    object Label4: TLabel
      Left = 9
      Top = 126
      Width = 13
      Height = 21
      Caption = 'H'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 99
      Top = 126
      Width = 15
      Height = 21
      Caption = 'M'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 198
      Top = 126
      Width = 12
      Height = 21
      Caption = 'S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object TimeExpiredD: TLabel
      Left = 171
      Top = 279
      Width = 77
      Height = 18
      Caption = 'Time is up!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object StartBtnD: TButton
      Left = 18
      Top = 207
      Width = 100
      Height = 28
      Caption = 'Start timer'
      TabOrder = 0
      OnClick = StartBtnClick
    end
    object StopBtnD: TButton
      Left = 18
      Top = 252
      Width = 100
      Height = 28
      Caption = 'Stop timer'
      TabOrder = 1
      OnClick = StopBtnClick
    end
    object SoundBoxD: TCheckBox
      Left = 16
      Top = 36
      Width = 109
      Height = 19
      Caption = 'Audible click'
      TabOrder = 2
      OnClick = SoundBoxClick
    end
    object SetbtnD: TButton
      Left = 18
      Top = 162
      Width = 100
      Height = 28
      Caption = 'Set timer'
      TabOrder = 3
      OnClick = SetBtnClick
    end
    object HSpinEditD: TSpinEdit
      Left = 36
      Top = 122
      Width = 46
      Height = 28
      MaxLength = 23
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object MSpinEditD: TSpinEdit
      Left = 126
      Top = 122
      Width = 46
      Height = 28
      MaxValue = 59
      MinValue = 0
      TabOrder = 5
      Value = 2
    end
    object SSpinEditD: TSpinEdit
      Left = 225
      Top = 122
      Width = 46
      Height = 28
      MaxValue = 59
      MinValue = 0
      TabOrder = 6
      Value = 30
    end
    object PanelD: TPanel
      Left = 153
      Top = 207
      Width = 109
      Height = 46
      Color = 8057975
      TabOrder = 7
      OnExit = PanelDExit
    end
    object DirectionD: TRadioGroup
      Left = 176
      Top = 18
      Width = 103
      Height = 73
      Caption = 'Up/Down'
      ItemIndex = 1
      Items.Strings = (
        'Up'
        'Down')
      TabOrder = 8
    end
    object OnMinuteBeep: TCheckBox
      Left = 16
      Top = 64
      Width = 145
      Height = 17
      Caption = 'Beep on minute'
      TabOrder = 9
    end
  end
end
