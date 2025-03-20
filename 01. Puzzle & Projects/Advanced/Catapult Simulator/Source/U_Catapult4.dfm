object Form1: TForm1
  Left = 110
  Top = 30
  Width = 889
  Height = 688
  Caption = 'A Catapult Simulator   Version 4.2 '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 881
    Height = 632
    ActivePage = SetUpSheet
    Align = alClient
    TabOrder = 0
    object SetUpSheet: TTabSheet
      Caption = 'Setup'
      ImageIndex = 2
      OnShow = SetupEnter
      object Image2: TImage
        Left = 312
        Top = 16
        Width = 513
        Height = 169
      end
      object SaveBtn: TButton
        Left = 176
        Top = 552
        Width = 121
        Height = 25
        Caption = 'Save Catapult'
        TabOrder = 0
        OnClick = SaveBtnClick
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 248
        Width = 289
        Height = 129
        Caption = 'Simulation parameters'
        TabOrder = 1
        object Label3: TLabel
          Left = 8
          Top = 40
          Width = 110
          Height = 13
          Caption = 'Max simulated run secs'
        end
        object Label5: TLabel
          Left = 23
          Top = 68
          Width = 95
          Height = 13
          Caption = 'Return samples/sec'
        end
        object Label6: TLabel
          Left = 26
          Top = 96
          Width = 83
          Height = 26
          Caption = 'Calc samples per retuned value'
          WordWrap = True
        end
        object Label14: TLabel
          Left = 136
          Top = 16
          Width = 25
          Height = 13
          Caption = 'Firing'
        end
        object Label23: TLabel
          Left = 232
          Top = 16
          Width = 46
          Height = 13
          Caption = 'Free flight'
        end
        object Maxsecs: TSpinEdit
          Left = 136
          Top = 35
          Width = 40
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 1
        end
        object ReturnSPS: TSpinEdit
          Left = 136
          Top = 63
          Width = 57
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 20
        end
        object CalcSPRet: TSpinEdit
          Left = 136
          Top = 91
          Width = 57
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 2
          Value = 10
        end
        object Maxsecs2: TSpinEdit
          Left = 224
          Top = 35
          Width = 48
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 10
        end
        object ReturnSPS2: TSpinEdit
          Left = 216
          Top = 63
          Width = 56
          Height = 22
          MaxValue = 1000
          MinValue = 1
          TabOrder = 4
          Value = 20
        end
        object CalcSPRet2: TSpinEdit
          Left = 216
          Top = 91
          Width = 56
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 5
          Value = 10
        end
      end
      object UnitsGrp: TRadioGroup
        Left = 16
        Top = 392
        Width = 281
        Height = 113
        Caption = 'Units'
        ItemIndex = 0
        Items.Strings = (
          'Large metric (meters, kilograms, Newtons)'
          'Small metric (centimeters, grams, CentiNewtons)'
          'Large English (feet, pounds, pounds force)'
          'Small English (inches, ounces, ounces force)')
        TabOrder = 2
        OnClick = UnitsGrpClick
      end
      object FireBtn: TButton
        Left = 16
        Top = 520
        Width = 137
        Height = 57
        Caption = 'Fire!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = FireBtnClick
      end
      object LoadBtn: TButton
        Left = 176
        Top = 520
        Width = 121
        Height = 25
        Caption = 'Load Catapult'
        TabOrder = 4
        OnClick = LoadBtnClick
      end
      object Memo4: TMemo
        Left = 16
        Top = 16
        Width = 281
        Height = 209
        Lines.Strings = (
          'Catapults for this simulator always throw their '
          'projectiles from left to right.  Coordinates increase '
          'upwards and to the right and are relative to the beam '
          'pivot point at (0,0).'
          ''
          'Driving force may be rotational, (i.e. as if the beam '
          'were being driven by a coil spring or twisted ropes as '
          'in the original onager), or by a spring which either pulls '
          'up (fastened to the left of the pivot point, indicated by '
          'a negative distance to force value) or down '
          '(fastened right of the pivot).  Sample catapults of all'
          'three force types are included.'
          ''
          'Normally, the "stopper" bar controls when the'
          'projectile is fired.  This stopper location is drawn as the'
          'red rectangle on the cataplut diagram.  Actually, thne'
          'projectile leaves the beam whenever beam'
          'acceleration becomes negative (velocity decreases).'
          'The spring attachement angle affects this point.'
          ''
          'Resolution of results can be increased by increasing'
          'the number of returned samples per second.  For light'
          'projectile weights or  high forces, "Return'
          'Samples/sec" sampling rate for the firing phase should '
          'be high enough to produce consistent. The length and '
          'mass values for the beam will be more significant '
          'results for light projectiles.')
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object Button3: TButton
        Left = 352
        Top = 464
        Width = 145
        Height = 25
        Caption = 'Advanced setup'
        TabOrder = 6
      end
      object PageControl2: TPageControl
        Left = 320
        Top = 200
        Width = 513
        Height = 377
        ActivePage = TabSheet5
        TabOrder = 7
        object TabSheet5: TTabSheet
          Caption = 'Catapult  Specifications'
          object Label1: TLabel
            Left = 32
            Top = 32
            Width = 120
            Height = 13
            Caption = 'Initial arm angle (degrees)'
          end
          object Label10: TLabel
            Left = 34
            Top = 65
            Width = 118
            Height = 13
            Caption = 'Final arm angle (degrees)'
          end
          object Label28: TLabel
            Left = 16
            Top = 99
            Width = 142
            Height = 13
            Caption = 'Pivot height above ground (m)'
          end
          object Label9: TLabel
            Left = 67
            Top = 132
            Width = 91
            Height = 13
            Caption = 'Length of beam (m)'
          end
          object Label4: TLabel
            Left = 25
            Top = 157
            Width = 136
            Height = 28
            AutoSize = False
            Caption = 'Distance pivot to force (m)   (negative=left of pivot}'
            WordWrap = True
          end
          object Label8: TLabel
            Left = 16
            Top = 198
            Width = 142
            Height = 13
            Caption = 'Distance pivot to projectile (m)'
          end
          object Label21: TLabel
            Left = 47
            Top = 232
            Width = 103
            Height = 13
            Caption = 'Mass of projectile (kg)'
          end
          object Label20: TLabel
            Left = 62
            Top = 265
            Width = 87
            Height = 13
            Caption = 'Gravity (m/sec^2))'
          end
          object Label32: TLabel
            Left = 32
            Top = 312
            Width = 217
            Height = 33
            AutoSize = False
            Caption = 
              'Note: 1 Kg force = 9.806 Newtons (N)                       1 gra' +
              'm force  = 0.9806 Centinewtons'
            WordWrap = True
          end
          object Edit1: TEdit
            Left = 168
            Top = 28
            Width = 57
            Height = 21
            TabOrder = 0
            Text = '0.0'
            OnChange = ParamChanged
          end
          object Edit6: TEdit
            Left = 168
            Top = 61
            Width = 57
            Height = 21
            TabOrder = 1
            Text = '50'
            OnChange = ParamChanged
          end
          object Edit16: TEdit
            Left = 168
            Top = 95
            Width = 57
            Height = 21
            TabOrder = 2
            Text = '1'
            OnChange = ParamChanged
          end
          object Edit9: TEdit
            Left = 168
            Top = 128
            Width = 57
            Height = 21
            TabOrder = 3
            Text = '2.5'
            OnChange = ParamChanged
          end
          object Edit7: TEdit
            Left = 168
            Top = 159
            Width = 57
            Height = 21
            TabOrder = 4
            Text = '-1.0'
            OnChange = ParamChanged
          end
          object Edit8: TEdit
            Left = 168
            Top = 194
            Width = 57
            Height = 21
            TabOrder = 5
            Text = '2.0'
            OnChange = ParamChanged
          end
          object Edit4: TEdit
            Left = 168
            Top = 228
            Width = 57
            Height = 21
            TabOrder = 6
            Text = '1.0'
            OnChange = ParamChanged
          end
          object Edit3: TEdit
            Left = 168
            Top = 261
            Width = 57
            Height = 21
            TabOrder = 7
            Text = '9.806'
            OnChange = ParamChanged
          end
          object GroupBox3: TGroupBox
            Left = 256
            Top = 32
            Width = 233
            Height = 241
            Caption = 'Forcing type'
            TabOrder = 8
            object Label2: TLabel
              Left = 24
              Top = 48
              Width = 79
              Height = 13
              Caption = 'Applied force (N)'
            end
            object Label22: TLabel
              Left = 36
              Top = 160
              Width = 30
              Height = 13
              Caption = ' X (m) '
            end
            object Label11: TLabel
              Left = 132
              Top = 160
              Width = 24
              Height = 13
              Caption = 'Y (m)'
            end
            object Label15: TLabel
              Left = 24
              Top = 184
              Width = 129
              Height = 41
              AutoSize = False
              Caption = 'Spring constant K  (N/m)'
              WordWrap = True
            end
            object Label16: TLabel
              Left = 40
              Top = 140
              Width = 182
              Height = 13
              Caption = 'Fixed end coordinates relative to pivot '
            end
            object Edit2: TEdit
              Left = 136
              Top = 44
              Width = 57
              Height = 21
              TabOrder = 0
              Text = '100.0'
              OnChange = ParamChanged
            end
            object Edit10: TEdit
              Left = 72
              Top = 156
              Width = 41
              Height = 21
              TabOrder = 1
              Text = '1.0'
              OnChange = ParamChanged
            end
            object RotateRBtn: TRadioButton
              Left = 16
              Top = 24
              Width = 113
              Height = 17
              Caption = 'Rotational force'
              TabOrder = 2
              OnClick = ParamChanged
            end
            object Edit13: TEdit
              Left = 168
              Top = 188
              Width = 49
              Height = 21
              TabOrder = 3
              Text = '25'
              OnChange = ParamChanged
            end
            object Edit11: TEdit
              Left = 168
              Top = 156
              Width = 41
              Height = 21
              TabOrder = 4
              Text = '1.0'
              OnChange = ParamChanged
            end
            object SpringrBtn: TRadioButton
              Left = 24
              Top = 120
              Width = 113
              Height = 17
              Caption = 'Fixed end spring'
              Checked = True
              TabOrder = 5
              TabStop = True
              OnClick = ParamChanged
            end
          end
          object StaticText1: TStaticText
            Left = 32
            Top = 304
            Width = 4
            Height = 4
            TabOrder = 9
          end
        end
        object TabSheet6: TTabSheet
          Caption = '     Advanced'
          ImageIndex = 1
          object Label17: TLabel
            Left = 26
            Top = 48
            Width = 88
            Height = 13
            Caption = 'Air drag coefficient'
          end
          object Edit14: TEdit
            Left = 120
            Top = 44
            Width = 50
            Height = 21
            TabOrder = 0
            Text = '0.05'
            OnChange = ParamChanged
          end
          object GroupBox4: TGroupBox
            Left = 312
            Top = 32
            Width = 169
            Height = 73
            Caption = 'Beam Moment of Inertia'
            TabOrder = 1
            object Label12: TLabel
              Left = 10
              Top = 27
              Width = 67
              Height = 13
              Caption = 'Mass of Beam'
            end
            object Label25: TLabel
              Left = 8
              Top = 48
              Width = 138
              Height = 13
              Caption = '(Assumes solid uniform beam)'
            end
            object Edit12: TEdit
              Left = 88
              Top = 23
              Width = 57
              Height = 21
              TabOrder = 0
              Text = '0'
            end
          end
          object Panel1: TPanel
            Left = 8
            Top = 136
            Width = 481
            Height = 173
            Enabled = False
            TabOrder = 2
            object Label13: TLabel
              Left = 16
              Top = 16
              Width = 165
              Height = 20
              Caption = 'Not yet implemented'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold, fsUnderline]
              ParentFont = False
            end
            object GroupBox6: TGroupBox
              Left = 296
              Top = 24
              Width = 145
              Height = 57
              Caption = 'Beam Moment of Inertia'
              TabOrder = 0
              object Label29: TLabel
                Left = 24
                Top = 32
                Width = 61
                Height = 13
                Caption = 'Beam Shape'
              end
            end
            object GroupBox7: TGroupBox
              Left = 296
              Top = 88
              Width = 153
              Height = 73
              Caption = 'Second force '
              TabOrder = 1
            end
            object GroupBox5: TGroupBox
              Left = 8
              Top = 56
              Width = 241
              Height = 105
              Caption = 'Beam Pivot Friction'
              TabOrder = 2
              object Label18: TLabel
                Left = 80
                Top = 32
                Width = 69
                Height = 13
                Caption = 'Pivot Diameter'
              end
              object Label24: TLabel
                Left = 24
                Top = 64
                Width = 126
                Height = 13
                Caption = 'Bearing Friction Coefficient'
              end
              object Edit5: TEdit
                Left = 160
                Top = 23
                Width = 49
                Height = 21
                TabOrder = 0
                Text = '0.1'
              end
              object Edit15: TEdit
                Left = 160
                Top = 55
                Width = 57
                Height = 21
                TabOrder = 1
                Text = '0.05'
              end
            end
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Fire!'
      ImageIndex = 1
      object Image1: TImage
        Left = 272
        Top = 8
        Width = 567
        Height = 233
      end
      object Label7: TLabel
        Left = 16
        Top = 320
        Width = 372
        Height = 16
        Caption = 
          'Secs        Angle      Ang-Vel.   Ang-Acccel.        (X, ,Y)    ' +
          '       ((X'#39', Y'#39')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label19: TLabel
        Left = 552
        Top = 312
        Width = 304
        Height = 16
        Caption = 'Secs      (X,Y) Coordinates             (Distance, height)   '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label26: TLabel
        Left = 24
        Top = 296
        Width = 76
        Height = 16
        Caption = 'Fire Phase'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label27: TLabel
        Left = 552
        Top = 288
        Width = 87
        Height = 16
        Caption = 'Flight Phase'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label30: TLabel
        Left = 272
        Top = 264
        Width = 80
        Height = 13
        Caption = 'Simulation speed'
      end
      object Button1: TButton
        Left = 56
        Top = 496
        Width = 75
        Height = 25
        Caption = 'Button1'
        TabOrder = 0
        Visible = False
      end
      object Test1InfoMemo: TMemo
        Left = 8
        Top = 8
        Width = 233
        Height = 145
        Lines.Strings = (
          'Results of firing the catapult are animated and '
          'displayed in two lists of values showing some '
          'projectile parameters during the firing phase and '
          'the free flight phase.'
          ''
          'Coordinates are relative to the beam pivot  (i.e. '
          'pivot is at (0,0))')
        TabOrder = 1
      end
      object Memo1: TMemo
        Left = 16
        Top = 336
        Width = 529
        Height = 201
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object Button2: TButton
        Left = 104
        Top = 184
        Width = 75
        Height = 25
        Caption = 'Fire!'
        TabOrder = 3
        OnClick = FireBtnClick
      end
      object Memo2: TMemo
        Left = 560
        Top = 336
        Width = 289
        Height = 193
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object ResetBtn: TButton
        Left = 16
        Top = 184
        Width = 75
        Height = 25
        Caption = 'Cock it'
        TabOrder = 5
        OnClick = ResetBtnClick
      end
      object TrackBar1: TTrackBar
        Left = 360
        Top = 256
        Width = 150
        Height = 33
        Max = 500
        Position = 400
        TabOrder = 6
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 632
    Width = 881
    Height = 25
    Align = alBottom
    TabOrder = 1
    object CatNameLbl: TLabel
      Left = 1
      Top = 1
      Width = 58
      Height = 23
      Align = alLeft
      Caption = 'CatNameLbl'
    end
    object Label31: TLabel
      Left = 509
      Top = 1
      Width = 371
      Height = 23
      Cursor = crHandPoint
      Align = alRight
      Caption = 
        'Copyright 2005, 2017  Gary Darby  garyd@delphiforfun.org        ' +
        ' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label31Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'cat'
    Filter = 'Catapult files (*.cat)|*.cat|Any file (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save a Catapult'
    Left = 732
    Top = 552
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.cat'
    Filter = 'Catapult files (*.cat)|*.cat|All files (*.*) |*.*'
    Title = 'Select a Catapult file to load'
    Left = 780
    Top = 560
  end
end
