object TConvertTest: TTConvertTest
  Left = 156
  Top = 37
  Width = 779
  Height = 600
  Caption = 'TAstronomy Conversion Tests'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 84
    Width = 94
    Height = 13
    Caption = 'Latitude (D M S)'
  end
  object Label2: TLabel
    Left = 16
    Top = 36
    Width = 104
    Height = 13
    Caption = 'Longitude (D M S)'
  end
  object Label3: TLabel
    Left = 360
    Top = 24
    Width = 28
    Height = 13
    Caption = 'Date'
  end
  object Label8: TLabel
    Left = 360
    Top = 80
    Width = 61
    Height = 13
    Caption = 'Time Zone'
  end
  object DatePicker: TDateTimePicker
    Left = 416
    Top = 20
    Width = 97
    Height = 21
    CalAlignment = dtaLeft
    Date = 33870
    Time = 33870
    DateFormat = dfShort
    DateMode = dmComboBox
    Kind = dtkDate
    ParseInput = True
    TabOrder = 0
    OnUserInput = DatePickerUserInput
  end
  object TZBox: TComboBox
    Left = 432
    Top = 76
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      '-12'
      '-11'
      '-10'
      '-09'
      '-08  (PST)'
      '-07  (MST)'
      '-06  (CST) '
      '-05  (EST)  '
      '-04  '
      '-03 '
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
  object NSRGrp: TRadioGroup
    Left = 256
    Top = 62
    Width = 81
    Height = 49
    ItemIndex = 1
    Items.Strings = (
      'North'
      'South')
    TabOrder = 2
  end
  object EWRGrp: TRadioGroup
    Left = 256
    Top = 14
    Width = 81
    Height = 49
    ItemIndex = 0
    Items.Strings = (
      'East'
      'West')
    TabOrder = 3
  end
  object LatEdt: TEdit
    Left = 136
    Top = 80
    Width = 97
    Height = 21
    TabOrder = 4
    Text = '20 0 3.4'
  end
  object LongEdt: TEdit
    Left = 136
    Top = 32
    Width = 97
    Height = 21
    TabOrder = 5
    Text = '62 10 12'
  end
  object DLSRGrp: TRadioGroup
    Left = 552
    Top = 24
    Width = 177
    Height = 73
    Caption = 'Daylight Saving'
    ItemIndex = 0
    Items.Strings = (
      'Added 0 hours to local'
      'Added 1 hour to local'
      'Added 2 hours to local')
    TabOrder = 6
    OnClick = DLSRGrpClick
  end
  object BitBtn1: TBitBtn
    Left = 296
    Top = 184
    Width = 177
    Height = 25
    Caption = 'Convert In to Out'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = TestBtnClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333FF3333333333333003333
      3333333333773FF3333333333309003333333333337F773FF333333333099900
      33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
      99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
      33333333337F3F77333333333309003333333333337F77333333333333003333
      3333333333773333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    Layout = blGlyphRight
    NumGlyphs = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 120
    Width = 257
    Height = 409
    Caption = 'Data In'
    TabOrder = 8
    object Label6: TLabel
      Left = 24
      Top = 124
      Width = 75
      Height = 13
      Caption = 'Time (H,M,S)'
    end
    object HrDegInLbl: TLabel
      Left = 32
      Top = 340
      Width = 60
      Height = 13
      Caption = 'X  (D,M,S)'
    end
    object Label9: TLabel
      Left = 32
      Top = 372
      Width = 60
      Height = 13
      Caption = 'Y  (D,M,S)'
    end
    object TimeInRGrp: TRadioGroup
      Left = 24
      Top = 24
      Width = 185
      Height = 89
      Caption = 'Time base '
      ItemIndex = 0
      Items.Strings = (
        'Local '
        'Universal '
        'Greewich sidereal'
        'Local sidereal')
      TabOrder = 0
    end
    object CoordInRGrp: TRadioGroup
      Left = 24
      Top = 152
      Width = 185
      Height = 169
      Caption = 'Coordinate system'
      ItemIndex = 2
      Items.Strings = (
        'Horizon (Azimuth,Altitude)'
        'Ecliptic (Long,Lat)'
        'Equatorial (HA,Decl)'
        'Equatorial (RA,Decl)'
        'Galactic (Long,Lat)'
        'Sun Position for this time'
        'Sunrise'
        'Sunset')
      TabOrder = 1
      OnClick = CoordInRGrpClick
    end
    object XInEdt: TEdit
      Left = 104
      Top = 336
      Width = 105
      Height = 21
      TabOrder = 2
      Text = '12 16 0'
    end
    object YInEdt: TEdit
      Left = 104
      Top = 368
      Width = 105
      Height = 21
      TabOrder = 3
      Text = '14 34 0'
    end
    object TimeIn: TDateTimePicker
      Left = 104
      Top = 120
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 36526.9391921296
      Time = 36526.9391921296
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 496
    Top = 136
    Width = 257
    Height = 393
    Caption = 'Data Out'
    TabOrder = 9
    object Label14: TLabel
      Left = 24
      Top = 124
      Width = 75
      Height = 13
      Caption = 'Time (H,M,S)'
    end
    object HrDegOutLbl: TLabel
      Left = 32
      Top = 300
      Width = 60
      Height = 13
      Caption = 'X  (D,M,S)'
    end
    object Label16: TLabel
      Left = 32
      Top = 332
      Width = 60
      Height = 13
      Caption = 'Y  (D,M,S)'
    end
    object TimeOutRGrp: TRadioGroup
      Left = 24
      Top = 24
      Width = 185
      Height = 89
      Caption = 'Time base'
      ItemIndex = 1
      Items.Strings = (
        'Local '
        'Universal '
        'Greewich sidereal'
        'Local sidereal')
      TabOrder = 0
      OnClick = TestBtnClick
    end
    object TimeOut: TDateTimePicker
      Left = 104
      Top = 120
      Width = 105
      Height = 21
      CalAlignment = dtaLeft
      Date = 36526.9391921296
      Time = 36526.9391921296
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkTime
      ParseInput = False
      TabOrder = 1
    end
    object CoordOutRGrp: TRadioGroup
      Left = 24
      Top = 160
      Width = 185
      Height = 121
      Caption = 'Coordinate system'
      ItemIndex = 0
      Items.Strings = (
        'Horizon (Azimuth,Altitude)'
        'Ecliptic (Long,Lat)'
        'Equatorial (HA,Decl)'
        'Equatorial (RA,Decl)'
        'Galactic (Long,Lat)')
      TabOrder = 2
      OnClick = CoordOutRGrpClick
    end
    object XoutEdt: TEdit
      Left = 120
      Top = 296
      Width = 105
      Height = 21
      TabOrder = 3
      Text = '12 16 0'
    end
    object YOutEdt: TEdit
      Left = 120
      Top = 328
      Width = 105
      Height = 21
      TabOrder = 4
      Text = '14 34 0'
    end
  end
  object Panel1: TPanel
    Left = 288
    Top = 304
    Width = 185
    Height = 225
    TabOrder = 10
    Visible = False
    object Label4: TLabel
      Left = 48
      Top = 32
      Width = 47
      Height = 13
      Caption = 'Sunrise '
    end
    object Label5: TLabel
      Left = 37
      Top = 63
      Width = 57
      Height = 13
      Caption = '   Azimuth'
    end
    object Label10: TLabel
      Left = 51
      Top = 93
      Width = 44
      Height = 13
      Caption = 'Sunset '
    end
    object Label11: TLabel
      Left = 37
      Top = 124
      Width = 57
      Height = 13
      Caption = '   Azimuth'
    end
    object Label7: TLabel
      Left = 16
      Top = 152
      Width = 151
      Height = 13
      Caption = 'LST = Local Sideeal Time)'
    end
    object SRAz: TEdit
      Left = 104
      Top = 59
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 0
      Text = '0:0:0'
    end
    object SSAz: TEdit
      Left = 104
      Top = 120
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 1
      Text = '0:0:0'
    end
    object SRmsg: TEdit
      Left = 16
      Top = 176
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object SSTime: TEdit
      Left = 104
      Top = 91
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 3
      Text = '0:0:0'
    end
    object SRTime: TEdit
      Left = 104
      Top = 27
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 4
      Text = '0:0:0'
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 771
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 11
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 280
    Top = 272
    Width = 201
    Height = 257
    Lines.Strings = (
      'Initial values are copied from '
      'Astronomy Demo main form.  Make '
      'any changes desired, select the '
      'output time and coordinate '
      'systems desired and click the '
      '"Convert" button to view '
      'conversion results.'
      ''
      'If you select one of the bottom '
      'three radio buttons from the box '
      'at left (Sun Position, Sunrise, '
      'Sunset), the Time Base is set to '
      '"Local", the coordinates '
      'option is set to to "Horizon" '
      'and Azimuth and Altitude are '
      'displayed.  For "Sunrise" and '
      '"Sunset", the Time field  is also '
      'changed to that time.')
    TabOrder = 12
  end
end
