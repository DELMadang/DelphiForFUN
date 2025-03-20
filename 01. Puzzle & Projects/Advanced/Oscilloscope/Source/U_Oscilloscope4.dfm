object frmMain: TfrmMain
  Left = 603
  Top = 169
  Width = 1096
  Height = 682
  Caption = 'Dual Trace Oscilloscope Ver 4.2.4'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 13
  object statustext: TPanel
    Left = 0
    Top = 0
    Width = 1078
    Height = 36
    Align = alTop
    BevelInner = bvLowered
    BevelWidth = 2
    Caption = 'Oscilloscope'
    Color = clMaroon
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -15
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel5: TPanel
    Left = 0
    Top = 36
    Width = 1078
    Height = 463
    Align = alTop
    Caption = 'Panel5'
    TabOrder = 1
    object Panel6: TPanel
      Left = 730
      Top = 1
      Width = 195
      Height = 461
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 0
      object btnRun: TSpeedButton
        Left = 9
        Top = 9
        Width = 44
        Height = 27
        Hint = 'Run'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FF0000000000
          00000000000000000000000000000000000000000000000000000000000000FF
          00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000000000
          000000FF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FF000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = btnRunClick
      end
      object btnDual: TSpeedButton
        Left = 10
        Top = 78
        Width = 104
        Height = 27
        Hint = 'Dual input'
        AllowAllUp = True
        GroupIndex = 2
        Caption = 'Dual inp.'
        ParentShowHint = False
        ShowHint = True
        OnClick = btnDualClick
      end
      object BtnOneFrame: TSpeedButton
        Left = 54
        Top = 9
        Width = 42
        Height = 27
        Hint = 'Single frame'
        AllowAllUp = True
        GroupIndex = 1
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FF000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FF000000000000
          000000000000FF00FF0000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FF00FF00000000000000
          0000000000000000000000000000000000000000000000FF00FFFF00FF000000
          000000000000FF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF0000
          00000000FF00FFFF00FFFF00FF000000000000000000FF00FF00000000000000
          0000FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          000000000000000000000000000000000000FF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        ParentShowHint = False
        ShowHint = True
        OnClick = BtnOneFrameClick
      end
      object Panel3: TPanel
        Left = 99
        Top = 9
        Width = 14
        Height = 16
        Hint = 'Blinks when running'
        BevelInner = bvLowered
        Color = clMaroon
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 9
        Top = 200
        Width = 160
        Height = 252
        Caption = 'Trigger'
        TabOrder = 1
        object btnTriggCh1: TSpeedButton
          Left = 9
          Top = 56
          Width = 35
          Height = 24
          Hint = 'Trigger on Channel 1'
          GroupIndex = 3
          Down = True
          Caption = 'Ch1'
        end
        object btnTriggCh2: TSpeedButton
          Left = 9
          Top = 81
          Width = 35
          Height = 24
          Hint = 'Trigger on Channel2'
          GroupIndex = 3
          Caption = 'Ch2'
        end
        object btnTrigPositiv: TSpeedButton
          Left = 9
          Top = 107
          Width = 35
          Height = 24
          Hint = 'Trigger on + rising level '
          GroupIndex = 4
          Caption = '+'
          OnClick = btnTrigerOnClick
        end
        object btnTrigNegativ: TSpeedButton
          Left = 9
          Top = 133
          Width = 35
          Height = 24
          Hint = 'Trigger on - falling level'
          GroupIndex = 4
          Caption = '-'
          OnClick = trOfsCh1Change
        end
        object Label4: TLabel
          Left = 81
          Top = 13
          Width = 7
          Height = 13
          Caption = '0'
        end
        object Label3: TLabel
          Left = 9
          Top = 233
          Width = 150
          Height = 16
          Caption = 'Level (-128 to +128): '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnTrigerOn: TSpeedButton
          Left = 9
          Top = 34
          Width = 35
          Height = 23
          AllowAllUp = True
          GroupIndex = 5
          Caption = 'On'
          OnClick = btnTrigerOnClick
        end
        object TrigLevelBar: TTrackBar
          Left = 61
          Top = 26
          Width = 44
          Height = 200
          Hint = 'Trigger level'
          Max = 128
          Min = -128
          Orientation = trVertical
          Frequency = 128
          TabOrder = 0
          TickMarks = tmBoth
          OnChange = TrigLevelBarChange
        end
      end
      object SpectrumBtn: TBitBtn
        Left = 9
        Top = 43
        Width = 44
        Height = 27
        Hint = 'Spectrum'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = SpectrumBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FF0000
          00FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FF000000FF
          00FF000000FF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000FF
          00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FF000000FF00FF000000FF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      end
      object CalibrateBtn: TBitBtn
        Left = 52
        Top = 43
        Width = 62
        Height = 27
        Hint = 'Set zero level'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = CalibrateBtnClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FF0000000000000000000000000000000000
          00000000FF00FFFF00FFFF00FF000000FF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
          00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FF}
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 154
      Height = 461
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 1
      object GrpChannel1: TGroupBox
        Left = 9
        Top = 9
        Width = 136
        Height = 217
        Caption = 'Channel 1'
        TabOrder = 0
        object Label5: TLabel
          Left = 84
          Top = 17
          Width = 41
          Height = 16
          Caption = 'Offset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 9
          Top = 65
          Width = 39
          Height = 20
          Caption = 'Gain'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnCH1Gnd: TSpeedButton
          Left = 9
          Top = 183
          Width = 35
          Height = 24
          AllowAllUp = True
          GroupIndex = 7
          Caption = 'Gnd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          OnClick = btnCH1GndClick
        end
        object trOfsCh1: TTrackBar
          Left = 84
          Top = 35
          Width = 27
          Height = 174
          Max = 160
          Min = -160
          Orientation = trVertical
          Frequency = 20
          TabOrder = 0
          OnChange = trOfsCh1Change
        end
        object upGainCh1: TUpDown
          Left = 41
          Top = 91
          Width = 21
          Height = 28
          Associate = edtGainCh1
          Max = 6
          Position = 3
          TabOrder = 1
        end
        object edtGainCh1: TEdit
          Left = 8
          Top = 91
          Width = 33
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '3'
          OnChange = edtGainCh1Change
        end
        object OnCh1Box: TCheckBox
          Left = 8
          Top = 24
          Width = 57
          Height = 17
          Caption = 'On'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnCh1OnClick
        end
      end
      object grpChannel2: TGroupBox
        Left = 8
        Top = 234
        Width = 137
        Height = 218
        Caption = 'Channel 2'
        TabOrder = 1
        object Label7: TLabel
          Left = 84
          Top = 17
          Width = 41
          Height = 16
          Caption = 'Offset'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 9
          Top = 73
          Width = 39
          Height = 20
          Caption = 'Gain'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
        end
        object btnCH2Gnd: TSpeedButton
          Left = 9
          Top = 175
          Width = 56
          Height = 24
          AllowAllUp = True
          GroupIndex = 7
          Caption = 'Gnd'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          OnClick = btnCH2GndClick
        end
        object trOfsCh2: TTrackBar
          Left = 84
          Top = 43
          Width = 27
          Height = 174
          Max = 160
          Min = -160
          Orientation = trVertical
          Frequency = 20
          TabOrder = 0
          OnChange = trOfsCh2Change
        end
        object upGainCh2: TUpDown
          Left = 36
          Top = 99
          Width = 21
          Height = 28
          Associate = edtGainCh2
          Max = 6
          Position = 3
          TabOrder = 1
        end
        object edtGainCh2: TEdit
          Left = 8
          Top = 99
          Width = 28
          Height = 28
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          Text = '3'
          OnChange = edtGainCh2Change
        end
        object OnCh2Box: TCheckBox
          Left = 8
          Top = 32
          Width = 57
          Height = 17
          Caption = 'On'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = btnCh2OnClick
        end
      end
    end
    object Panel4: TPanel
      Left = 925
      Top = 1
      Width = 148
      Height = 461
      Align = alLeft
      BevelInner = bvLowered
      BevelWidth = 2
      TabOrder = 2
      object GroupBox2: TGroupBox
        Left = 4
        Top = 4
        Width = 131
        Height = 349
        Caption = 'Time'
        TabOrder = 0
        object Label2: TLabel
          Left = 9
          Top = 130
          Width = 96
          Height = 14
          AutoSize = False
          Caption = 'Horizontal gain'
          WordWrap = True
        end
        object ScaleLbl: TLabel
          Left = 15
          Top = 22
          Width = 36
          Height = 13
          Caption = 'Scale:'
        end
        object sp11025Sample: TSpeedButton
          Left = 9
          Top = 43
          Width = 53
          Height = 24
          GroupIndex = 6
          Down = True
          Caption = '11,025'
          OnClick = sp11025SampleClick
        end
        object sp22050Sample: TSpeedButton
          Left = 9
          Top = 69
          Width = 53
          Height = 24
          GroupIndex = 6
          Caption = '22,050'
          OnClick = sp22050SampleClick
        end
        object sp44100Sample: TSpeedButton
          Left = 9
          Top = 95
          Width = 53
          Height = 24
          GroupIndex = 6
          Caption = '44,100'
          OnClick = sp44100SampleClick
        end
        object SweepEdt: TEdit
          Left = 9
          Top = 151
          Width = 31
          Height = 21
          TabOrder = 0
          Text = '1'
          OnChange = SweepEdtChange
        end
        object SweepUD: TUpDown
          Left = 40
          Top = 151
          Width = 17
          Height = 21
          Associate = SweepEdt
          Min = 1
          Max = 10
          Position = 1
          TabOrder = 1
        end
      end
      object GroupBox3: TGroupBox
        Left = 9
        Top = 191
        Width = 131
        Height = 162
        Caption = 'Capture frame'
        TabOrder = 1
        object btnExpand1: TSpeedButton
          Left = 9
          Top = 34
          Width = 25
          Height = 23
          GroupIndex = 8
          Down = True
          Caption = 'X1'
          OnClick = btnExpand1Click
        end
        object btnExpand2: TSpeedButton
          Left = 35
          Top = 33
          Width = 25
          Height = 23
          GroupIndex = 8
          Caption = 'X2'
          OnClick = btnExpand2Click
        end
        object btnExpand4: TSpeedButton
          Left = 61
          Top = 33
          Width = 25
          Height = 23
          GroupIndex = 8
          Caption = 'X4'
          OnClick = btnExpand4Click
        end
        object btnExpand8: TSpeedButton
          Left = 87
          Top = 33
          Width = 25
          Height = 23
          GroupIndex = 8
          Caption = 'X8'
          OnClick = btnExpand8Click
        end
        object Label11: TLabel
          Left = 9
          Top = 17
          Width = 47
          Height = 13
          Caption = 'Expand:'
        end
        object Label13: TLabel
          Left = 9
          Top = 61
          Width = 31
          Height = 13
          Caption = 'Gain:'
        end
        object btnGain0: TSpeedButton
          Left = 9
          Top = 78
          Width = 35
          Height = 24
          GroupIndex = 9
          Caption = '/2'
          OnClick = btnGain0Click
        end
        object btnGain1: TSpeedButton
          Left = 43
          Top = 78
          Width = 36
          Height = 24
          GroupIndex = 9
          Down = True
          Caption = 'X1'
          OnClick = btnGain1Click
        end
        object btnGain2: TSpeedButton
          Left = 78
          Top = 78
          Width = 36
          Height = 24
          GroupIndex = 9
          Caption = 'X2'
          OnClick = btnGain2Click
        end
        object Label12: TLabel
          Left = 40
          Top = 110
          Width = 54
          Height = 13
          Caption = '<-- X -->'
          OnDblClick = Label12DblClick
        end
        object trStartPos: TTrackBar
          Left = 4
          Top = 122
          Width = 123
          Height = 36
          Max = 400
          Min = -400
          Frequency = 40
          TabOrder = 0
          OnChange = trStartPosChange
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 360
        Width = 140
        Height = 97
        Align = alBottom
        Caption = 'Intensities'
        TabOrder = 2
        object Label9: TLabel
          Left = 9
          Top = 30
          Width = 31
          Height = 13
          Caption = 'Scale'
        end
        object Label1: TLabel
          Left = 54
          Top = 30
          Width = 33
          Height = 13
          Caption = 'Beam'
        end
        object Label10: TLabel
          Left = 93
          Top = 30
          Width = 30
          Height = 13
          Caption = 'focus'
        end
        object UpScaleLight: TUpDown
          Left = 17
          Top = 51
          Width = 19
          Height = 27
          Min = 25
          Max = 200
          Increment = 10
          Position = 70
          TabOrder = 0
          OnChanging = UpScaleLightChanging
        end
        object upBeamLight: TUpDown
          Left = 61
          Top = 51
          Width = 18
          Height = 27
          Min = -180
          Max = 150
          Increment = 15
          Position = 1
          TabOrder = 1
          OnClick = upBeamLightClick
        end
        object upFocus: TUpDown
          Left = 104
          Top = 51
          Width = 18
          Height = 27
          Min = 1
          Max = 6
          Position = 1
          TabOrder = 2
          OnClick = upFocusClick
        end
      end
    end
    object PageControl1: TPageControl
      Left = 155
      Top = 1
      Width = 575
      Height = 461
      ActivePage = Runsheet
      Align = alLeft
      TabOrder = 3
      object IntroSheet: TTabSheet
        Caption = 'Introduction'
        ImageIndex = 1
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 567
          Height = 433
          Align = alClient
          Color = 15400959
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Verdana'
          Font.Style = []
          Lines.Strings = (
            
              'This simple oscilloscope uses the Windows Wavein API to capture ' +
              'data '
            
              'from a sound card and display it in the screen area above.   Use' +
              ' the '
            
              'Windows "Volume Controls - Options - Properties"  dialog and sel' +
              'ect '
            
              '"Recording Controls" to select input source(s) to be displayed. ' +
              '   After the '
            
              'Start button is clicked, any messages describing capture problem' +
              's will be '
            'displayed here.'
            ''
            
              'Version  2: A "Trigger" capability has been added.  Each scan is' +
              ' triggered'
            
              'when the signal rises above (+) or below (-) the preset trigger ' +
              'level.  To'
            
              'improve the image capture of transient events, there is now a "C' +
              'apture'
            
              'Single Frame" button.  Use he "Trigger" feature to control when ' +
              'the frame'
            'will be captured.'
            ''
            
              'Version 3  Spectrum analysis of Captured frames.  User selectabl' +
              'e Sample'
            'rates.  Time scale ref.lines on display.'
            ''
            
              'Version 4:  Dual trace function added.  Improved visual layout. ' +
              '  Improved'
            
              'controls.  Input signal selectable via buttons.    Settings save' +
              'd from run to'
            
              'run.  Many thanks to "Krille", a very sharp Delphi programmer fr' +
              'om '
            'Sweden.  ()March 28, 2014: Version 4.2.3 cleans up a number of '
            
              'formatting errors and adds some control hints.  Still a work in ' +
              'progress so '
            'bug reports are welcome.)')
          ParentFont = False
          TabOrder = 0
        end
      end
      object Runsheet: TTabSheet
        Caption = 'Oscilloscope'
        inline frmOscilloscope1: TfrmOscilloscope
          Left = 0
          Top = 0
          Width = 567
          Height = 433
          Align = alClient
          AutoSize = True
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          inherited Image1: TImage
            Width = 567
            Height = 433
            Stretch = True
          end
          inherited Image2: TImage
            Left = 43
            Top = 42
            Width = 483
            Height = 347
          end
        end
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 592
    Width = 1078
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2014, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object MainMenu1: TMainMenu
    Left = 776
    Top = 648
    object File1: TMenuItem
      Caption = 'File'
      object menuSaveImage1: TMenuItem
        Caption = 'Save Image'
        OnClick = menuSaveImage1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object menuExit: TMenuItem
        Caption = 'Exit'
        OnClick = menuExitClick
      end
    end
    object Screen1: TMenuItem
      Caption = 'Screen'
      object Color1: TMenuItem
        Caption = 'Color'
        object menuBlack: TMenuItem
          Caption = 'Black'
          OnClick = menuBlackClick
        end
        object MenuGreen: TMenuItem
          Caption = 'Green'
          OnClick = MenuGreenClick
        end
      end
      object Data1: TMenuItem
        Caption = 'Data'
        object MenuData_Time: TMenuItem
          Caption = 'Time'
          OnClick = MenuData_TimeClick
        end
      end
    end
  end
end
