object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Latitude, Longitude Calculations   V4.0'
  ClientHeight = 572
  ClientWidth = 944
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 944
    Height = 552
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Distance between points'
      object Label1: TLabel
        Left = 24
        Top = 56
        Width = 82
        Height = 18
        Caption = 'Location #1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 24
        Top = 160
        Width = 82
        Height = 18
        Caption = 'Location #2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 120
        Top = 64
        Width = 69
        Height = 18
        Caption = 'Longitude'
      end
      object Label4: TLabel
        Left = 120
        Top = 24
        Width = 56
        Height = 18
        Caption = 'Latitude'
      end
      object Label5: TLabel
        Left = 120
        Top = 128
        Width = 56
        Height = 18
        Caption = 'Latitude'
      end
      object Label6: TLabel
        Left = 120
        Top = 168
        Width = 69
        Height = 18
        Caption = 'Longitude'
      end
      object Loc1Lat: TEdit
        Left = 120
        Top = 40
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '40:40:11N'
        OnChange = VIInputChange
      end
      object Memo1: TMemo
        Left = 272
        Top = 32
        Width = 618
        Height = 313
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'Enter latitude  (north/south angles fron the equator) and longit' +
            'ude (east/west'
          'angle fro the Greenwich meridian)  for each location as:'
          ''
          
            '..... Degrees only  (may include decimal point and fractional de' +
            'gree (for '
          'example 74.625)'
          
            ' ..... Degrees and minutes separated by a space, colon, or comma' +
            ' (for '
          'example 47:14.5)'
          
            '....  Degrees, minutes, and seconds as three numbers separated b' +
            'y spaces,'
          'colons, for commas (for example  47, 14, 24.5)'
          ''
          
            'North latitudes may be preceded or suffixed with N or +, South l' +
            'atitudes with S  '
          
            'or -,  East longitudes may be preceded or suffixed with E or +, ' +
            'West longitudes '
          'with  W or --.'
          ''
          'Default initial coordinates represent New York and  Zurich.'
          ''
          
            'The second "Calculate Distance" button (ellipsoid) uses an appox' +
            'imation of the'
          
            'distance taking into account the fact that the earth is slightly' +
            ' flattened - the '
          
            'east/west distance around the equator is larger than the north/s' +
            'outh distance'
          
            'through the poles.  Around 1670, Sir Isaac Newton,  based on his' +
            ' theory of'
          
            'gravity hypothesized that Earth must be flattened on the poles'#39' ' +
            'axis, making it'
          
            #39'wider'#39' on equatorial axis. He measured the flattening to be aro' +
            'und 1/300 of the'
          
            'equatorial radius. Todays value is about 1/298.   Not bad! The a' +
            'lgorithm used'
          'here is from website'
          
            'http://www.codeguru.com/Cpp/Cpp/algorithms/general/article.php/c' +
            '5115/.'
          ''
          
            'The Vincenty Inverse algorithm produces the most acccurate dista' +
            'nce result'
          
            'and include bearing information.  See the "End Point" calculatio' +
            'n on the next '
          'tab for more information.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object UnitsGrp: TRadioGroup
        Left = 24
        Top = 224
        Width = 185
        Height = 73
        Caption = '  Units for result  '
        ItemIndex = 0
        Items.Strings = (
          'Miles'
          'Kilometers'
          'Nautical miles')
        TabOrder = 2
        OnClick = VIInputChange
      end
      object SphereBtn: TButton
        Left = 24
        Top = 312
        Width = 226
        Height = 25
        Caption = 'Calculate distance (sphere)'
        TabOrder = 3
        OnClick = SphereBtnClick
      end
      object Loc1Lon: TEdit
        Left = 120
        Top = 80
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = '73:56:38W'
        OnChange = VIInputChange
      end
      object Loc2lat: TEdit
        Left = 120
        Top = 144
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = '47:22:00N'
        OnChange = VIInputChange
      end
      object Loc2Lon: TEdit
        Left = 120
        Top = 184
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Text = '8:32 :00E'
        OnChange = VIInputChange
      end
      object EllispeBtn: TBitBtn
        Left = 24
        Top = 352
        Width = 226
        Height = 25
        Caption = 'Calculate distance (ellipsoid)'
        TabOrder = 7
        OnClick = EllispeBtnClick
      end
      object VInverseBtn: TButton
        Left = 24
        Top = 392
        Width = 226
        Height = 33
        Caption = 'Distance by Vincenty'#39's Inverse'
        TabOrder = 8
        OnClick = VInverseBtnClick
      end
      object VIResults: TGroupBox
        Left = 272
        Top = 352
        Width = 513
        Height = 145
        Caption = 'Results'
        TabOrder = 9
        object Label20: TLabel
          Left = 24
          Top = 40
          Width = 62
          Height = 18
          Caption = 'Distance'
        end
        object Panel1: TPanel
          Left = 246
          Top = 20
          Width = 265
          Height = 123
          Align = alRight
          TabOrder = 0
          Visible = False
          object Label17: TLabel
            Left = 24
            Top = 8
            Width = 92
            Height = 18
            Caption = 'Initial bearing'
          end
          object Label18: TLabel
            Left = 24
            Top = 40
            Width = 91
            Height = 18
            Caption = 'Final bearing'
          end
          object Label19: TLabel
            Left = 0
            Top = 73
            Width = 115
            Height = 18
            Caption = 'Reverse bearing'
          end
          object B12I: TEdit
            Left = 128
            Top = 4
            Width = 121
            Height = 26
            ReadOnly = True
            TabOrder = 0
            Text = 'B12I'
          end
          object B12F: TEdit
            Left = 128
            Top = 36
            Width = 121
            Height = 26
            ReadOnly = True
            TabOrder = 1
            Text = 'B12F'
          end
          object B21I: TEdit
            Left = 128
            Top = 65
            Width = 121
            Height = 26
            ReadOnly = True
            TabOrder = 2
            Text = 'B21I'
          end
        end
        object VIDist: TEdit
          Left = 24
          Top = 60
          Width = 153
          Height = 26
          ReadOnly = True
          TabOrder = 1
        end
      end
      object Button1: TButton
        Left = 24
        Top = 445
        Width = 226
        Height = 25
        Caption = 'Rhumb Line Travel'
        TabOrder = 10
        OnClick = Button1Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = '   End point from point, bearing && distance  '
      ImageIndex = 1
      object Label7: TLabel
        Left = 24
        Top = 56
        Width = 82
        Height = 18
        Caption = 'Location #1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 120
        Top = 64
        Width = 69
        Height = 18
        Caption = 'Longitude'
      end
      object Label10: TLabel
        Left = 120
        Top = 24
        Width = 56
        Height = 18
        Caption = 'Latitude'
      end
      object Label15: TLabel
        Left = 48
        Top = 112
        Width = 65
        Height = 41
        AutoSize = False
        Caption = 'Initial Bearing'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label16: TLabel
        Left = 40
        Top = 160
        Width = 66
        Height = 18
        Caption = 'Distance '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object StepGrp: TGroupBox
        Left = 320
        Top = 21
        Width = 570
        Height = 335
        Caption = 'Steps'
        TabOrder = 10
        object Label21: TLabel
          Left = 50
          Top = 28
          Width = 343
          Height = 18
          Caption = 'Great Circle Route steps: Dist, Lat, Long, Bearing'
        end
        object Memo3: TMemo
          Left = 50
          Top = 57
          Width = 399
          Height = 257
          Lines.Strings = (
            'Memo3')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object Memo2: TMemo
        Left = 320
        Top = 24
        Width = 572
        Height = 340
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Thaddeus Vincenty was a geodesist best known for developing an '
          
            'algorithm and  equations which accurately calculate distances an' +
            'd '
          
            'bearings for locations on the earth'#39's surface.  This was in the ' +
            '1970s '
          'when digital computers were in the process of replacing desktop '
          
            'calculators for these problems. His iterative method quickly pro' +
            'duced '
          'results accurate within 1/2 millimeter (1 part in 5,000,000).'
          ''
          
            'His formulas are widely available on the web, (start with Wikipe' +
            'dia '
          'entriesfor Vincenty) and are implemented here.'
          ''
          
            'The  previous "Distance between points" tab sheet calculates dis' +
            'tance'
          
            'and bearings between two given points using the Vincenty Inverse' +
            ' '
          
            'equations. Because shortest distance follow the great circle rou' +
            'te, initial '
          
            'and final bearings are not identical. In the sample case given, ' +
            'from New '
          
            'York to Zurich, we start out heading  northeast (bearing 53 degr' +
            'ees) '
          'and arrive traveling southeast (bearing 116 degrees).'
          ''
          
            'This page calculates an end point and final bearing from a given' +
            ' '
          'starting point, bearing, and distance in two navigation modes:'
          ''
          
            '1) If you are in an commercial airliner, chances are that you wi' +
            'll follow'
          
            'the Great Circle route, the shortest distance between points A a' +
            'nd B.'
          
            'It only looks curved and longer when you project it onto a flat ' +
            'map.  A'
          
            'piece of string and a globe will sconvince you otherwise. The Gr' +
            'eat'
          
            'Circle mode will show how bearings change along the route. It us' +
            'es'
          
            'my comversion  of the NGIS "Forward.for" Fortran program because' +
            ' I '
          
            'could never find the error that kept my Vincintry Direct algorit' +
            'hm from '
          'matching up.'
          ''
          
            '2) If you travel from A to B with a constant bearing, as in a sa' +
            'iling ship, '
          
            'then you will travel further, but navigation is much simpler, es' +
            'pecially '
          'true before computers and GPS became common.  Constant bearing '
          
            'lines on a Mercator projection map are called Rhumb Lines.  Choo' +
            'sing '
          
            'that mode will display where you end up after traveling a fixed ' +
            'distance. '
          
            'Using the greatcircle intial beraing in the Northern hemisphere ' +
            'will land '
          
            'you shortand North of the Great Circle end point (short and sout' +
            'h in the '
          'Southernhemisphere).')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object VDLat1: TEdit
        Left = 120
        Top = 40
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '40:40:1'
        OnChange = VDInputChange
      end
      object VDUnits: TRadioGroup
        Left = 24
        Top = 193
        Width = 185
        Height = 73
        Caption = '  Units for distance  '
        ItemIndex = 0
        Items.Strings = (
          'Miles'
          'Kilometers'
          'Nautical miles')
        TabOrder = 1
        OnClick = VDInputChange
      end
      object VDLon1: TEdit
        Left = 120
        Top = 80
        Width = 121
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '73:56:38W'
        OnChange = VDInputChange
      end
      object VDirectBtn: TButton
        Left = 24
        Top = 404
        Width = 276
        Height = 67
        Caption = 'Great Cirlcle or Rhumb Line Destination'
        TabOrder = 3
        WordWrap = True
        OnClick = VDirectBtnClick
      end
      object Az12edt: TEdit
        Left = 120
        Top = 120
        Width = 121
        Height = 26
        TabOrder = 4
        Text = '53.3267'
        OnChange = VDInputChange
      end
      object Distedt: TEdit
        Left = 120
        Top = 160
        Width = 121
        Height = 26
        TabOrder = 5
        Text = '3937.945'
        OnChange = VDInputChange
      end
      object GroupBox1: TGroupBox
        Left = 320
        Top = 376
        Width = 401
        Height = 137
        Caption = 'Results'
        TabOrder = 6
        object Label8: TLabel
          Left = 22
          Top = 29
          Width = 96
          Height = 18
          Caption = 'End  Location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label11: TLabel
          Left = 19
          Top = 57
          Width = 56
          Height = 18
          Caption = 'Latitude'
        end
        object Label12: TLabel
          Left = 9
          Top = 89
          Width = 69
          Height = 18
          Caption = 'Longitude'
        end
        object Label13: TLabel
          Left = 238
          Top = 29
          Width = 93
          Height = 18
          Caption = 'Final Bearing'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label14: TLabel
          Left = 238
          Top = 77
          Width = 117
          Height = 18
          Caption = 'Reverse Bearing'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object VDLat2: TEdit
          Left = 88
          Top = 53
          Width = 121
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
        end
        object VDLon2: TEdit
          Left = 88
          Top = 85
          Width = 121
          Height = 24
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          TabOrder = 1
        end
        object VDAZFinal: TEdit
          Left = 240
          Top = 48
          Width = 121
          Height = 26
          TabOrder = 2
        end
        object VDAZBack: TEdit
          Left = 240
          Top = 96
          Width = 121
          Height = 26
          TabOrder = 3
        end
      end
      object NGISDirectBtn: TButton
        Left = 21
        Top = 487
        Width = 267
        Height = 33
        Caption = 'Converted NGIS Vincinty'#39's Direct'
        TabOrder = 8
        OnClick = VDirectBtnClick
      end
      object StepsGrp: TRadioGroup
        Left = 28
        Top = 334
        Width = 173
        Height = 65
        Caption = 'Show steps along path'
        Columns = 3
        ItemIndex = 0
        Items.Strings = (
          '1'
          '2'
          '10'
          '100')
        TabOrder = 9
      end
      object NavModeGrp: TRadioGroup
        Left = 28
        Top = 277
        Width = 264
        Height = 44
        Caption = 'Navigation mode'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Great Circle'
          'Rhumb Line')
        TabOrder = 11
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 552
    Width = 944
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2004-2017 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
