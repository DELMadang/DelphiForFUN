object Form1: TForm1
  Left = 352
  Top = 90
  Width = 1102
  Height = 875
  Caption = 'Astronomy Unit Demo, Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClick = FormClick
  OnResize = FormResize
  PixelsPerInch = 120
  TextHeight = 16
  object PBox: TPaintBox
    Left = 682
    Top = 278
    Width = 346
    Height = 345
    OnPaint = PBoxPaint
  end
  object Memo1: TMemo
    Left = 10
    Top = 276
    Width = 582
    Height = 461
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Here'#39's a program to demonstrate some of the capabilities of the'
      'TAstronomy  unit.'
      ''
      
        'Given a viewer'#39's location on earth  (Latitude, Longitude, and El' +
        'evation'
      
        'above sea level), and a date/Time reference, options are availab' +
        'le to'
      
        'determine the current position of the Sun, Moon or planets along' +
        ' with'
      'other information.'
      ''
      
        'Other buttons show information about Solar and Lunar eclipses ne' +
        'ar the '
      
        'reference date. and Analemmas  (diagram of the Sun;s position in' +
        ' the '
      'sky at a certain time of day for the entire year. '
      ''
      
        'One of the most confusing  aspects for astronomy beginners, incl' +
        'uding '
      
        'myself, is the multiple time systems (4) and location coordinate' +
        ' '
      
        'systems (5) in use.   The "Unit Conversions" button allow experi' +
        'mental '
      
        'conversions among these systems.   Be warned however, you will n' +
        'eed '
      'to look up the definitions elsewhere.'
      ''
      
        'Version 2.0 adds "decimal format" option to the "degrees, minute' +
        's, seconds" '
      
        'format for angles.  Also analemmas can now be animated to show s' +
        'un position '
      'on by date.  ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object ShowBtn: TButton
    Left = 807
    Top = 0
    Width = 130
    Height = 31
    Caption = 'Sun Info'
    TabOrder = 0
    OnClick = ShowBtnClick
  end
  object AnalemmaBtn: TButton
    Left = 807
    Top = 178
    Width = 130
    Height = 31
    Caption = 'Analemma'
    TabOrder = 2
    OnClick = AnalemmaBtnClick
  end
  object Panel1: TPanel
    Left = 10
    Top = 0
    Width = 779
    Height = 257
    TabOrder = 3
    object Label2: TLabel
      Left = 39
      Top = 84
      Width = 106
      Height = 16
      Caption = 'Longitude (D M S)'
    end
    object Label1: TLabel
      Left = 39
      Top = 34
      Width = 94
      Height = 16
      Caption = 'Latitude (D M S)'
    end
    object Label3: TLabel
      Left = 39
      Top = 148
      Width = 29
      Height = 16
      Caption = 'Date'
    end
    object Label8: TLabel
      Left = 226
      Top = 148
      Width = 65
      Height = 16
      Caption = 'Time Zone'
    end
    object Label4: TLabel
      Left = 512
      Top = 39
      Width = 141
      Height = 16
      Caption = 'Meters above sea level'
    end
    object LongEdt: TEdit
      Left = 167
      Top = 79
      Width = 120
      Height = 24
      Hint = 'May be entered as decimal degrees  or degrees, minutes, seconds'
      TabOrder = 0
      Text = '77 0 0'
      OnChange = BaseDataChange
      OnExit = LongEdtExit
    end
    object EWRGrp: TRadioGroup
      Left = 295
      Top = 69
      Width = 159
      Height = 41
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        'East'
        'West')
      TabOrder = 1
      OnClick = BaseDataChange
    end
    object NSRGrp: TRadioGroup
      Left = 295
      Top = 20
      Width = 159
      Height = 40
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'North'
        'South')
      TabOrder = 2
      OnClick = BaseDataChange
    end
    object LatEdt: TEdit
      Left = 167
      Top = 30
      Width = 120
      Height = 24
      Hint = 'May be entered as decimal degrees  or degrees, minutes, seconds'
      TabOrder = 3
      Text = '37 0 0 '
      OnChange = BaseDataChange
    end
    object DatePicker: TDateTimePicker
      Left = 89
      Top = 148
      Width = 119
      Height = 24
      Date = 30832.000000000000000000
      Time = 30832.000000000000000000
      ParseInput = True
      TabOrder = 4
      OnChange = BaseDataChange
      OnUserInput = DatePickerUserInput
    end
    object TZBox: TComboBox
      Left = 305
      Top = 148
      Width = 100
      Height = 24
      ItemHeight = 16
      TabOrder = 5
      Text = 'TZBox'
      OnChange = BaseDataChange
      Items.Strings = (
        '-12'
        '-11'
        '-10'
        '-09'
        '-08  (PST)'
        '-07  (MST)'
        '-06   (CST) '
        '-05  (EST)'
        '-04  '
        '-03  '
        '-02 '
        '-01'
        '00'
        '+01'
        '+02'
        '+03'
        '+04'
        '+05'
        '+06'
        '+07'
        '+08'
        '+09'
        '+10'
        '+11')
    end
    object TimePicker: TDateTimePicker
      Left = 482
      Top = 148
      Width = 110
      Height = 24
      Date = 36526.500000000000000000
      Time = 36526.500000000000000000
      Checked = False
      Kind = dtkTime
      TabOrder = 6
      OnChange = BaseDataChange
    end
    object DLSRGrp: TRadioGroup
      Left = 482
      Top = 187
      Width = 268
      Height = 51
      Caption = 'Daylight Saving Add'
      Columns = 3
      ItemIndex = 0
      Items.Strings = (
        '0 hours '
        '1 hour'
        '2 hours')
      TabOrder = 7
      OnClick = BaseDataChange
    end
    object HeightEdt: TEdit
      Left = 660
      Top = 39
      Width = 70
      Height = 24
      TabOrder = 8
      Text = '0'
      OnChange = BaseDataChange
    end
    object HeightUD: TUpDown
      Left = 730
      Top = 39
      Width = 15
      Height = 24
      Associate = HeightEdt
      Min = -500
      Max = 10000
      TabOrder = 9
    end
    object TimeBox: TComboBox
      Left = 601
      Top = 148
      Width = 149
      Height = 24
      ItemHeight = 16
      TabOrder = 10
      Text = 'Select a time base'
      OnChange = TimeBoxChange
      Items.Strings = (
        'Local Time'
        'Universal Time (UT)')
    end
    object Button1: TButton
      Left = 39
      Top = 207
      Width = 189
      Height = 31
      Caption = 'Set date/time to now'
      TabOrder = 11
      OnClick = Button1Click
    end
  end
  object TstBtn: TButton
    Left = 807
    Top = 223
    Width = 130
    Height = 31
    Caption = 'Unit conversions'
    TabOrder = 4
    OnClick = TstBtnClick
  end
  object MoonBtn: TButton
    Left = 807
    Top = 44
    Width = 130
    Height = 31
    Caption = 'Moon Info'
    TabOrder = 5
    OnClick = MoonBtnClick
  end
  object EclipseBtn: TButton
    Left = 807
    Top = 133
    Width = 130
    Height = 31
    Caption = 'Eclipse Info'
    TabOrder = 6
    OnClick = EclipseBtnClick
  end
  object PlanetBox: TComboBox
    Left = 807
    Top = 89
    Width = 130
    Height = 24
    ItemHeight = 16
    TabOrder = 7
    Text = 'Select a planet'
    OnClick = PlanetBoxClick
    Items.Strings = (
      'MERCURY'
      'VENUS'
      'MARS'
      'JUPITER'
      'SATURN'
      'URANUS'
      'NEPTUNE'
      'PLUTO'
      ' ')
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 793
    Width = 1094
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2003, 2015  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 8
    OnClick = StaticText1Click
  end
  object AnalemmaPanel: TPanel
    Left = 632
    Top = 632
    Width = 441
    Height = 161
    TabOrder = 9
    Visible = False
    OnExit = AnallemmPanelExit
    object AnDateLbl: TLabel
      Left = 16
      Top = 72
      Width = 34
      Height = 19
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AzLbl: TLabel
      Left = 16
      Top = 96
      Width = 40
      Height = 19
      Caption = 'AzLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AltLbl: TLabel
      Left = 16
      Top = 120
      Width = 39
      Height = 19
      Caption = 'AltLbl'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object AnimateBtn: TButton
      Left = 8
      Top = 40
      Width = 129
      Height = 25
      Caption = 'Animate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = AnimateBtnClick
    end
    object AnTypeGrp: TRadioGroup
      Left = 208
      Top = 8
      Width = 225
      Height = 89
      Caption = 'Analemma type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Shadow (Looking South)'
        'Camera (Pointing South)')
      ParentFont = False
      TabOrder = 1
      OnClick = AnTypeGrpClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 976
    Top = 232
    object File1: TMenuItem
      Caption = 'File'
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Calctype1: TMenuItem
        Caption = 'Time system for display...'
        object LocalCiviltime1: TMenuItem
          Caption = 'Local Civil '
          Checked = True
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object UniversalTime1: TMenuItem
          Caption = 'Universal '
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object GreenwichSiderealTime1: TMenuItem
          Caption = 'Greenwich Sidereal '
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
        object LocalSidereal1: TMenuItem
          Caption = 'Local Sidereal'
          RadioItem = True
          OnClick = SelectTimeOptClick
        end
      end
      object Displaycelestialpositonformat1: TMenuItem
        Caption = 'Celestial positon system for display ...'
        object EclOpt: TMenuItem
          Caption = 'Ecliptic Long/lat'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object AzAltOpt: TMenuItem
          Caption = 'Azimth/Altitude'
          Checked = True
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object RADeclOpt: TMenuItem
          Caption = 'Right Ascension /Declination'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object HADeclOpt: TMenuItem
          Caption = 'Hour Angle/Declination'
          RadioItem = True
          OnClick = AngleOptionClick
        end
        object GalOpt: TMenuItem
          Caption = 'Galactic Long/Lat'
          OnClick = AngleOptionClick
        end
      end
      object AngleFormat1: TMenuItem
        Caption = 'Angle Format...'
        object DMSFmt: TMenuItem
          Caption = 'Dgerees Minutes Seconds'
          Checked = True
          OnClick = DMSFmtClick
        end
        object DecimalDegrees1: TMenuItem
          Caption = 'Decimal Degrees'
          OnClick = DecimalDegrees1Click
        end
      end
    end
    object Actions1: TMenuItem
      Caption = 'Actions'
      object SunriseSunset1: TMenuItem
        Caption = 'Sun Info'
        OnClick = ShowBtnClick
      end
      object Moonrisemoonset1: TMenuItem
        Caption = 'Moon Info'
        OnClick = MoonBtnClick
      end
      object Planetpositions1: TMenuItem
        Caption = 'Planets'
        object Mercury1: TMenuItem
          Caption = 'Mercury'
          OnClick = PlanetItemClick
        end
        object Venus1: TMenuItem
          Tag = 1
          Caption = 'Venus'
          OnClick = PlanetItemClick
        end
        object Mars1: TMenuItem
          Tag = 2
          Caption = 'Mars'
          OnClick = PlanetItemClick
        end
        object Jupiter1: TMenuItem
          Tag = 3
          Caption = 'Jupiter'
          OnClick = PlanetItemClick
        end
        object Saturn2: TMenuItem
          Tag = 4
          Caption = 'Saturn'
          OnClick = PlanetItemClick
        end
        object Saturn1: TMenuItem
          Tag = 5
          Caption = 'Uranus'
          OnClick = PlanetItemClick
        end
        object Neptune1: TMenuItem
          Tag = 6
          Caption = 'Neptune'
          OnClick = PlanetItemClick
        end
        object Pluto1: TMenuItem
          Tag = 7
          Caption = 'Pluto'
          OnClick = PlanetItemClick
        end
      end
      object EclipseInfo1: TMenuItem
        Caption = 'Eclipse Info'
        OnClick = EclipseBtnClick
      end
      object Analemma2: TMenuItem
        Caption = 'Analemma'
        OnClick = AnalemmaBtnClick
      end
      object Checkunitconversions1: TMenuItem
        Caption = 'Unit conversions'
        OnClick = TstBtnClick
      end
    end
  end
end
