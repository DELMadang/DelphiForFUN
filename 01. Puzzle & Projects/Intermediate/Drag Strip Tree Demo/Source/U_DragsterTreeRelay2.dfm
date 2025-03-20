object Form1: TForm1
  Left = 292
  Top = 125
  Width = 1018
  Height = 709
  Caption = 'Drag Strip "Christmas Tree" (Relay  Version 2)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 408
    Top = 232
    Width = 137
    Height = 49
    AutoSize = False
    Caption = 'On green light ,    Press "Q" key to go!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 808
    Top = 232
    Width = 145
    Height = 49
    AutoSize = False
    Caption = 'On green light ,    Press "P" key to go!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Time2Lbl: TLabel
    Left = 812
    Top = 352
    Width = 109
    Height = 49
    AutoSize = False
    Caption = 'Reaction 9.999 seconds'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Time1Lbl: TLabel
    Left = 424
    Top = 344
    Width = 121
    Height = 57
    AutoSize = False
    Caption = 'Reaction 9.999 seconds'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Panel1: TPanel
    Left = 568
    Top = 128
    Width = 217
    Height = 361
    Color = clBlack
    TabOrder = 0
    object Start1A: TShape
      Left = 8
      Top = 88
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Start1B: TShape
      Left = 8
      Top = 144
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Start1C: TShape
      Left = 8
      Top = 200
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Go1: TShape
      Left = 8
      Top = 256
      Width = 65
      Height = 41
      Brush.Color = clGreen
      Shape = stCircle
    end
    object Foul1: TShape
      Left = 8
      Top = 312
      Width = 65
      Height = 41
      Brush.Color = 213
      Shape = stCircle
    end
    object PreStage1A: TShape
      Left = 16
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object PreStage1B: TShape
      Left = 48
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object Stage1A: TShape
      Left = 16
      Top = 48
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object Stage1B: TShape
      Left = 48
      Top = 48
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object Start2A: TShape
      Left = 136
      Top = 88
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Start2B: TShape
      Left = 136
      Top = 144
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Start2C: TShape
      Left = 136
      Top = 200
      Width = 65
      Height = 41
      Brush.Color = 180946
      Shape = stCircle
    end
    object Go2: TShape
      Left = 136
      Top = 256
      Width = 65
      Height = 41
      Brush.Color = clGreen
      Shape = stCircle
    end
    object Foul2: TShape
      Left = 136
      Top = 312
      Width = 65
      Height = 41
      Brush.Color = 213
      Shape = stCircle
    end
    object PreStage2A: TShape
      Left = 144
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object PreStage2B: TShape
      Left = 176
      Top = 16
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object Stage2A: TShape
      Left = 144
      Top = 48
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
    object Stage2B: TShape
      Left = 176
      Top = 48
      Width = 20
      Height = 20
      Brush.Color = 180946
      Shape = stCircle
    end
  end
  object PageControl1: TPageControl
    Left = 32
    Top = 16
    Width = 353
    Height = 609
    ActivePage = RelaySheet
    TabOrder = 1
    OnChange = PageControl1Change
    object PlaySheet: TTabSheet
      Caption = 'Christmas Tree Simulator'
      object Memo1: TMemo
        Left = 8
        Top = -63
        Width = 265
        Height = 505
        Color = 14548991
        Lines.Strings = (
          'Here'#39's a program illustrating the use of '
          'timers to control the lights of simulated '
          'drag strip starting lights.'
          ''
          'You can use buttons at right for head-to-'
          'head competion to pre-stage and'
          'stage the dragsters and then click the '
          '"Activate start sequence" button to start the '
          'countdown.  When the green light is lit, '
          'press "P'#39' and "Q"  keys to report reaction '
          'times for the left and right lanes '
          'respectively.'
          ''
          'You can use the "Auto stage"  checkbox to '
          'automate the staging process using '
          'random delay times.  The yellow-ywllow-'
          'yellow-green sequence will begin when both '
          'lanes are staged.')
        TabOrder = 0
      end
    end
    object RelaySheet: TTabSheet
      Caption = '  Relay Tree Simulator'
      ImageIndex = 1
      object Label4: TLabel
        Left = 176
        Top = 448
        Width = 46
        Height = 16
        Caption = 'minutes'
      end
      object Memo2: TMemo
        Left = 8
        Top = 8
        Width = 321
        Height = 193
        Color = 14548991
        Lines.Strings = (
          'This page simulates an automated display mode '
          'with lights operating according to a user schedule '
          'as defined below..'
          ''
          'It was designed to operate an actual display '
          'version of the tree with lights driven by a Numato '
          'USB interface relay board.   ')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object StringGrid1: TStringGrid
        Left = 8
        Top = 224
        Width = 281
        Height = 209
        ColCount = 3
        DefaultColWidth = 90
        RowCount = 8
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
        TabOrder = 1
      end
      object StartBtn: TButton
        Left = 232
        Top = 440
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 2
        OnClick = StartBtnClick
      end
      object CycleTimeEdt: TEdit
        Left = 136
        Top = 444
        Width = 33
        Height = 24
        TabOrder = 3
        Text = '1.5'
      end
      object CycleBox: TCheckBox
        Left = 0
        Top = 448
        Width = 137
        Height = 17
        Caption = 'Replay cycle every  '
        TabOrder = 4
      end
      object RelayBox: TCheckBox
        Left = 16
        Top = 496
        Width = 193
        Height = 17
        Caption = 'Use Relay board on Com port'
        TabOrder = 5
        OnClick = RelayBoxClick
      end
      object Edit1: TEdit
        Left = 208
        Top = 496
        Width = 49
        Height = 24
        TabOrder = 6
        Text = 'COM8'
      end
      object RelayDelayEdt: TLabeledEdit
        Left = 264
        Top = 528
        Width = 33
        Height = 24
        EditLabel.Width = 238
        EditLabel.Height = 16
        EditLabel.Caption = 'Ms delay between relay off and next on   '
        LabelPosition = lpLeft
        TabOrder = 7
        Text = '100'
        Visible = False
      end
    end
  end
  object PreStage1Btn: TButton
    Left = 464
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Pre-stage'
    TabOrder = 2
    OnClick = PreStageBtnClick
  end
  object Stage1Btn: TButton
    Left = 464
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Stage'
    Enabled = False
    TabOrder = 3
    OnClick = StageBtnClick
  end
  object AutoStage: TCheckBox
    Left = 392
    Top = 96
    Width = 385
    Height = 17
    Caption = '"Click to "Auto stage" and  "Auto activate"  vehicles '
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = AutoStageClick
  end
  object TreeTypeGrp: TRadioGroup
    Left = 504
    Top = 32
    Width = 273
    Height = 49
    Caption = 'Start type'
    Columns = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      'Sportsman'
      'Pro')
    ParentFont = False
    TabOrder = 5
  end
  object PreStage2Btn: TButton
    Left = 822
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Pre-stage'
    TabOrder = 6
    OnClick = PreStageBtnClick
  end
  object Stage2Btn: TButton
    Left = 822
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Stage'
    Enabled = False
    TabOrder = 7
    OnClick = StageBtnClick
  end
  object ActivateBtn: TButton
    Left = 536
    Top = 504
    Width = 161
    Height = 25
    Caption = 'Activate start sequence'
    Enabled = False
    TabOrder = 8
    OnClick = ActivateBtnClick
  end
  object ResetBtn: TButton
    Left = 718
    Top = 504
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 9
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 649
    Width = 1002
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 10
    OnClick = StaticText1Click
  end
  object AutoTimer2: TTimer
    Enabled = False
    OnTimer = AutoTimer
    Left = 752
    Top = 32
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 328
    Top = 32
  end
  object AutoTimer1: TTimer
    Enabled = False
    OnTimer = AutoTimer
    Left = 408
    Top = 8
  end
end
