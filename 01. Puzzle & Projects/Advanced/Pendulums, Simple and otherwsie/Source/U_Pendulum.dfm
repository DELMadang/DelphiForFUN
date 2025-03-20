object Form1: TForm1
  Tag = 1
  Left = 74
  Top = 12
  Width = 698
  Height = 546
  Caption = 'Pendulums, Simple and Otherwise'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 690
    Height = 496
    ActivePage = DoubleSheet
    Align = alClient
    TabOrder = 0
    OnChange = SheetEnter
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      ImageIndex = 3
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 682
        Height = 468
        Align = alClient
        Color = 14548991
        TabOrder = 0
        object RichEdit1: TRichEdit
          Left = 36
          Top = 1
          Width = 645
          Height = 466
          Align = alRight
          BorderStyle = bsNone
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Andale Mono'
          Font.Style = []
          HideScrollBars = False
          Lines.Strings = (
            'RichEdit1')
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object SimpleSheet: TTabSheet
      Caption = 'Simple Pendulum'
      OnExit = SheetExit
      object Label1: TLabel
        Left = 16
        Top = 40
        Width = 166
        Height = 13
        Caption = 'Initial angle (degrees: -180 to +180)'
      end
      object Label2: TLabel
        Left = 27
        Top = 109
        Width = 155
        Height = 13
        Caption = 'Gravity (981 cm/sec/sec normal)'
      end
      object Label3: TLabel
        Left = 36
        Top = 75
        Width = 146
        Height = 13
        Caption = 'Pendulum Length (centimeters)'
      end
      object Label4: TLabel
        Left = 32
        Top = 144
        Width = 90
        Height = 13
        Caption = 'Damping (0 to 100)'
      end
      object TimeLbl: TLabel
        Left = 296
        Top = 280
        Width = 3
        Height = 13
      end
      object CycleLbl: TLabel
        Left = 296
        Top = 308
        Width = 3
        Height = 13
      end
      object Image1: TImage
        Left = 304
        Top = 24
        Width = 353
        Height = 225
      end
      object P1RunBtn: TButton
        Tag = 1
        Left = 16
        Top = 176
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 1
        OnClick = P1RunBtnClick
      end
      object DegEdt: TEdit
        Left = 192
        Top = 36
        Width = 41
        Height = 21
        TabOrder = 2
        Text = '-40'
        OnChange = P1EdtChange
      end
      object LenEdt: TEdit
        Left = 192
        Top = 71
        Width = 41
        Height = 21
        TabOrder = 3
        Text = '100'
        OnChange = P1EdtChange
      end
      object GravEdt: TEdit
        Left = 192
        Top = 105
        Width = 41
        Height = 21
        TabOrder = 4
        Text = '981'
        OnChange = P1EdtChange
      end
      object DampEdt: TEdit
        Left = 192
        Top = 140
        Width = 41
        Height = 21
        TabOrder = 5
        Text = '10'
        OnChange = P1EdtChange
      end
      object ShowValues: TCheckBox
        Left = 152
        Top = 176
        Width = 97
        Height = 17
        Caption = 'Show Values'
        TabOrder = 6
      end
      object GroupBox1: TGroupBox
        Left = 368
        Top = 268
        Width = 233
        Height = 153
        Caption = 'Computational Parameters'
        TabOrder = 7
        object Label5: TLabel
          Left = 48
          Top = 40
          Width = 81
          Height = 13
          Caption = 'Max run seconds'
        end
        object Label6: TLabel
          Left = 49
          Top = 75
          Width = 80
          Height = 13
          Caption = 'Samples/second'
        end
        object Label7: TLabel
          Left = 10
          Top = 109
          Width = 125
          Height = 13
          Caption = 'Returned samples/second'
        end
        object MaxTimeEdt: TEdit
          Left = 144
          Top = 36
          Width = 57
          Height = 21
          TabOrder = 0
          Text = '300'
        end
        object SampRateEdt: TEdit
          Left = 144
          Top = 71
          Width = 57
          Height = 21
          TabOrder = 1
          Text = '100'
        end
        object PctToReturnEdt: TEdit
          Left = 144
          Top = 105
          Width = 57
          Height = 21
          TabOrder = 2
          Text = '25'
        end
        object MaxTimeUD: TUpDown
          Left = 201
          Top = 36
          Width = 15
          Height = 21
          Associate = MaxTimeEdt
          Min = -1000
          Max = 1000
          Position = 300
          TabOrder = 3
          Wrap = False
        end
        object SampRateUD: TUpDown
          Left = 201
          Top = 71
          Width = 15
          Height = 21
          Associate = SampRateEdt
          Min = -1000
          Max = 1000
          Position = 100
          TabOrder = 4
          Wrap = False
        end
        object ReturnedSampRateUD: TUpDown
          Left = 201
          Top = 105
          Width = 15
          Height = 21
          Associate = PctToReturnEdt
          Min = -1000
          Max = 1000
          Position = 25
          TabOrder = 5
          Wrap = False
        end
      end
      object DegUD: TUpDown
        Left = 233
        Top = 36
        Width = 15
        Height = 21
        Associate = DegEdt
        Min = -90
        Max = 90
        Position = -40
        TabOrder = 8
        Wrap = False
      end
      object LenUD: TUpDown
        Left = 233
        Top = 71
        Width = 15
        Height = 21
        Associate = LenEdt
        Min = 0
        Max = 1000
        Position = 100
        TabOrder = 9
        Wrap = False
      end
      object GravUD: TUpDown
        Left = 233
        Top = 105
        Width = 15
        Height = 21
        Associate = GravEdt
        Min = 0
        Max = 10000
        Position = 981
        TabOrder = 10
        Wrap = False
      end
      object DampUD: TUpDown
        Left = 233
        Top = 140
        Width = 15
        Height = 21
        Associate = DampEdt
        Min = 0
        Position = 10
        TabOrder = 11
        Wrap = False
      end
      object Memo1: TMemo
        Left = 16
        Top = 252
        Width = 241
        Height = 149
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Button1: TButton
        Left = 16
        Top = 216
        Width = 75
        Height = 25
        Caption = 'Info'
        TabOrder = 12
        OnClick = InfoBtnClick
      end
    end
    object DoubleSheet: TTabSheet
      Caption = 'Double Pendulum'
      ImageIndex = 1
      ParentShowHint = False
      ShowHint = True
      OnExit = SheetExit
      object Image2: TImage
        Left = 224
        Top = 16
        Width = 433
        Height = 233
      end
      object Label9: TLabel
        Left = 11
        Top = 269
        Width = 155
        Height = 13
        Caption = 'Gravity (981 cm/sec/sec normal)'
      end
      object Label11: TLabel
        Left = 8
        Top = 312
        Width = 90
        Height = 13
        Caption = 'Damping (0 to 100)'
      end
      object Label12: TLabel
        Left = 296
        Top = 280
        Width = 3
        Height = 13
      end
      object Label13: TLabel
        Left = 296
        Top = 308
        Width = 3
        Height = 13
      end
      object P2RuntimeLbl: TLabel
        Left = 216
        Top = 272
        Width = 45
        Height = 13
        Caption = 'Run time '
      end
      object Memo2: TMemo
        Left = 120
        Top = 296
        Width = 209
        Height = 97
        Color = clYellow
        Lines.Strings = (
          'Chaos demo - Mass of lower bob multiplied '
          'by 1.0001 for a second double pendulum.  '
          ' '
          'Watch for 20 seconds or so...')
        TabOrder = 9
      end
      object StartP2Btn: TButton
        Tag = 1
        Left = 24
        Top = 368
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 0
        OnClick = StartP2BtnClick
      end
      object Edit3: TEdit
        Left = 40
        Top = 289
        Width = 41
        Height = 21
        TabOrder = 1
        Text = '981'
        OnChange = P2EdtChange
      end
      object Edit4: TEdit
        Left = 40
        Top = 332
        Width = 41
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = P2EdtChange
      end
      object GroupBox2: TGroupBox
        Left = 384
        Top = 264
        Width = 225
        Height = 137
        Caption = 'Computational Parameters'
        TabOrder = 3
        object Label14: TLabel
          Left = 48
          Top = 40
          Width = 81
          Height = 13
          Caption = 'Max run seconds'
        end
        object Label15: TLabel
          Left = 49
          Top = 75
          Width = 80
          Height = 13
          Caption = 'Samples/second'
        end
        object Label16: TLabel
          Left = 26
          Top = 109
          Width = 110
          Height = 13
          Caption = 'Returned samples/sec.'
        end
        object Edit5: TEdit
          Left = 144
          Top = 36
          Width = 57
          Height = 21
          TabOrder = 0
          Text = '300'
        end
        object Edit6: TEdit
          Left = 144
          Top = 71
          Width = 57
          Height = 21
          TabOrder = 1
          Text = '100'
        end
        object Edit7: TEdit
          Left = 144
          Top = 105
          Width = 57
          Height = 21
          TabOrder = 2
          Text = '50'
        end
        object MaxTime2UD: TUpDown
          Left = 201
          Top = 36
          Width = 15
          Height = 21
          Associate = Edit5
          Min = 1
          Max = 1000
          Position = 300
          TabOrder = 3
          Wrap = False
        end
        object SampRate2UD: TUpDown
          Left = 201
          Top = 71
          Width = 15
          Height = 21
          Associate = Edit6
          Min = 1
          Max = 1000
          Position = 100
          TabOrder = 4
          Wrap = False
        end
        object ReturnedSampRate2UD: TUpDown
          Left = 201
          Top = 105
          Width = 15
          Height = 21
          Associate = Edit7
          Min = 0
          Position = 50
          TabOrder = 5
          Wrap = False
        end
      end
      object Grav2UD: TUpDown
        Left = 81
        Top = 289
        Width = 15
        Height = 21
        Associate = Edit3
        Min = 0
        Max = 10000
        Position = 981
        TabOrder = 4
        Wrap = False
      end
      object Damp2UD: TUpDown
        Left = 81
        Top = 332
        Width = 15
        Height = 21
        Associate = Edit4
        Min = 0
        Position = 0
        TabOrder = 5
        Wrap = False
      end
      object StartP2X2Btn: TButton
        Left = 152
        Top = 360
        Width = 145
        Height = 25
        Hint = 'Mass of lower bobs  differs by .0001'
        Caption = 'Start 2 double pendulums'
        TabOrder = 6
        OnClick = StartP2X2BtnClick
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 16
        Width = 185
        Height = 113
        Caption = 'Top Link'
        TabOrder = 7
        object Label8: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'Start angle( deg.)'
        end
        object Label10: TLabel
          Left = 12
          Top = 54
          Width = 56
          Height = 13
          Caption = 'Length (cm)'
        end
        object Label19: TLabel
          Left = 12
          Top = 83
          Width = 46
          Height = 13
          Caption = 'Mass (kg)'
        end
        object Edit1: TEdit
          Left = 96
          Top = 20
          Width = 41
          Height = 21
          TabOrder = 0
          Text = '-120'
          OnChange = P2EdtChange
        end
        object P1TAngleUD: TUpDown
          Left = 137
          Top = 20
          Width = 12
          Height = 21
          Associate = Edit1
          Min = -180
          Max = 180
          Position = -120
          TabOrder = 1
          Wrap = False
        end
        object P1TLenUD: TUpDown
          Left = 137
          Top = 50
          Width = 12
          Height = 21
          Associate = Edit2
          Min = 0
          Max = 1000
          Position = 600
          TabOrder = 2
          Wrap = False
        end
        object Edit2: TEdit
          Left = 96
          Top = 50
          Width = 41
          Height = 21
          TabOrder = 3
          Text = '600'
          OnChange = P2EdtChange
        end
        object Edit10: TEdit
          Left = 96
          Top = 79
          Width = 41
          Height = 21
          TabOrder = 4
          Text = '2'
          OnChange = P2EdtChange
        end
        object P1TMassUd: TUpDown
          Left = 137
          Top = 79
          Width = 12
          Height = 21
          Associate = Edit10
          Min = 0
          Max = 1000
          Position = 2
          TabOrder = 5
          Wrap = False
        end
      end
      object GroupBox4: TGroupBox
        Left = 8
        Top = 140
        Width = 185
        Height = 113
        Caption = 'BottomLink'
        TabOrder = 8
        object Label17: TLabel
          Left = 8
          Top = 24
          Width = 81
          Height = 13
          Caption = 'Start angle( deg.)'
        end
        object Label18: TLabel
          Left = 12
          Top = 54
          Width = 56
          Height = 13
          Caption = 'Length (cm)'
        end
        object Label20: TLabel
          Left = 12
          Top = 83
          Width = 46
          Height = 13
          Caption = 'Mass (kg)'
        end
        object Edit8: TEdit
          Left = 96
          Top = 20
          Width = 41
          Height = 21
          TabOrder = 0
          Text = '0'
          OnChange = P2EdtChange
        end
        object P1BAngleUD: TUpDown
          Left = 137
          Top = 20
          Width = 12
          Height = 21
          Associate = Edit8
          Min = -180
          Max = 180
          Position = 0
          TabOrder = 1
          Wrap = False
        end
        object Edit9: TEdit
          Left = 96
          Top = 50
          Width = 41
          Height = 21
          TabOrder = 2
          Text = '400'
          OnChange = P2EdtChange
        end
        object P1BLenUD: TUpDown
          Left = 137
          Top = 50
          Width = 12
          Height = 21
          Associate = Edit9
          Min = 0
          Max = 1000
          Position = 400
          TabOrder = 3
          Wrap = False
        end
        object Edit11: TEdit
          Left = 96
          Top = 79
          Width = 41
          Height = 21
          TabOrder = 4
          Text = '3'
          OnChange = P2EdtChange
        end
        object P1BMassUD: TUpDown
          Left = 137
          Top = 79
          Width = 12
          Height = 21
          Associate = Edit11
          Min = 0
          Max = 1000
          Position = 3
          TabOrder = 5
          Wrap = False
        end
      end
      object InfoBtn: TButton
        Left = 24
        Top = 416
        Width = 75
        Height = 25
        Caption = 'Info'
        TabOrder = 10
        OnClick = InfoBtnClick
      end
    end
    object ForcedSheet: TTabSheet
      Caption = 'Damped Forced Pendulum'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 2
      ParentFont = False
      OnEnter = SheetEnter
      OnExit = SheetExit
      object Label28: TLabel
        Left = 16
        Top = 364
        Width = 90
        Height = 13
        Caption = 'Damping (0 to 100)'
      end
      object Image3: TImage
        Left = 16
        Top = 32
        Width = 337
        Height = 217
      end
      object Image4: TImage
        Left = 392
        Top = 32
        Width = 217
        Height = 217
      end
      object P3RunTimeLbl: TLabel
        Left = 264
        Top = 272
        Width = 45
        Height = 13
        Caption = 'Run time '
      end
      object Label23: TLabel
        Left = 12
        Top = 299
        Width = 146
        Height = 13
        Caption = 'Pendulum Length (centimeters)'
      end
      object Label24: TLabel
        Left = 11
        Top = 333
        Width = 155
        Height = 13
        Caption = 'Gravity (981 cm/sec/sec normal)'
      end
      object Edit15: TEdit
        Left = 176
        Top = 360
        Width = 33
        Height = 21
        TabOrder = 0
        Text = '50'
        OnChange = P3EdtChange
      end
      object P3DampUd: TUpDown
        Left = 209
        Top = 360
        Width = 12
        Height = 21
        Associate = Edit15
        Min = 0
        Position = 50
        TabOrder = 1
        Wrap = False
      end
      object GroupBox5: TGroupBox
        Left = 472
        Top = 368
        Width = 193
        Height = 97
        Caption = 'Computational Parameters'
        TabOrder = 2
        object Label29: TLabel
          Left = 16
          Top = 16
          Width = 81
          Height = 13
          Caption = 'Max run seconds'
        end
        object Label30: TLabel
          Left = 17
          Top = 43
          Width = 80
          Height = 13
          Caption = 'Samples/second'
        end
        object Label21: TLabel
          Left = 16
          Top = 72
          Width = 98
          Height = 13
          Caption = 'Return samples/sec.'
        end
        object Edit16: TEdit
          Left = 128
          Top = 12
          Width = 41
          Height = 21
          TabOrder = 0
          Text = '600'
        end
        object Edit17: TEdit
          Left = 128
          Top = 39
          Width = 41
          Height = 21
          TabOrder = 1
          Text = '50'
        end
        object Edit18: TEdit
          Left = 128
          Top = 65
          Width = 41
          Height = 21
          TabOrder = 2
          Text = '10'
        end
        object MaxTime3UD: TUpDown
          Left = 169
          Top = 12
          Width = 12
          Height = 21
          Associate = Edit16
          Min = -1000
          Max = 1000
          Position = 600
          TabOrder = 3
          Wrap = False
        end
        object SampRate3UD: TUpDown
          Left = 169
          Top = 39
          Width = 12
          Height = 21
          Associate = Edit17
          Min = -1000
          Max = 1000
          Position = 50
          TabOrder = 4
          Wrap = False
        end
        object ReturnedRate3UD: TUpDown
          Left = 169
          Top = 65
          Width = 12
          Height = 21
          Associate = Edit18
          Min = -1000
          Max = 1000
          Position = 10
          TabOrder = 5
          Wrap = False
        end
      end
      object GroupBox6: TGroupBox
        Left = 8
        Top = 392
        Width = 249
        Height = 73
        Caption = 'Forcing function'
        TabOrder = 3
        object Label27: TLabel
          Left = 11
          Top = 44
          Width = 124
          Height = 13
          Caption = 'Amplitiude (Centi-newtons)'
        end
        object Label25: TLabel
          Left = 8
          Top = 16
          Width = 138
          Height = 13
          Caption = 'Frequency (degrees per sec.)'
        end
        object Edit14: TEdit
          Left = 168
          Top = 40
          Width = 33
          Height = 21
          TabOrder = 0
          Text = '115'
          OnChange = P3EdtChange
        end
        object FF_AmpUD: TUpDown
          Left = 201
          Top = 40
          Width = 15
          Height = 21
          Associate = Edit14
          Min = 0
          Max = 10000
          Position = 115
          TabOrder = 1
          Wrap = False
        end
        object Edit19: TEdit
          Left = 168
          Top = 12
          Width = 33
          Height = 21
          TabOrder = 2
          Text = '38'
          OnChange = P3EdtChange
        end
        object FF_FReqUD: TUpDown
          Left = 201
          Top = 12
          Width = 15
          Height = 21
          Associate = Edit19
          Min = 0
          Max = 360
          Position = 38
          TabOrder = 3
          Wrap = False
        end
      end
      object StartP3Btn: TButton
        Left = 288
        Top = 294
        Width = 75
        Height = 25
        Caption = 'Start'
        TabOrder = 4
        OnClick = StartP3BtnClick
      end
      object GroupBox7: TGroupBox
        Left = 288
        Top = 368
        Width = 153
        Height = 97
        Caption = 'Plot '
        TabOrder = 5
        object P3RealTime: TCheckBox
          Left = 16
          Top = 20
          Width = 97
          Height = 17
          Caption = 'Real time plot'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = P3RealTimeClick
        end
        object P3ClearBtn: TButton
          Left = 22
          Top = 48
          Width = 75
          Height = 25
          Caption = 'Clear chart'
          TabOrder = 1
          OnClick = P3ClearBtnClick
        end
      end
      object Edit12: TEdit
        Left = 176
        Top = 295
        Width = 33
        Height = 21
        TabOrder = 6
        Text = '981'
        OnChange = P1EdtChange
      end
      object Len3UD: TUpDown
        Left = 209
        Top = 295
        Width = 14
        Height = 21
        Associate = Edit12
        Min = 0
        Max = 1000
        Position = 981
        TabOrder = 7
        Wrap = False
      end
      object Edit13: TEdit
        Left = 176
        Top = 329
        Width = 33
        Height = 21
        TabOrder = 8
        Text = '981'
        OnChange = P1EdtChange
      end
      object Grav3UD: TUpDown
        Left = 209
        Top = 329
        Width = 14
        Height = 21
        Associate = Edit13
        Min = 0
        Max = 10000
        Position = 981
        TabOrder = 9
        Wrap = False
      end
      object Button3: TButton
        Left = 288
        Top = 328
        Width = 75
        Height = 25
        Caption = 'Info'
        TabOrder = 10
        OnClick = InfoBtnClick
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 496
    Width = 690
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby, www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
