object Form1: TForm1
  Left = 109
  Top = 4
  Width = 1072
  Height = 746
  Caption = 'Mercator Projection Test Program'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1056
    Height = 690
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 24
        Top = 24
        Width = 985
        Height = 609
        Color = 14811135
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            ' A viewer recently asked about our Traveling Salesman Program.  ' +
            'Would it be possible to add additional locations to the existing' +
            ' map and'
          
            'would it be possible to load maps other than the default USA map' +
            '?   It is certainly possible, the question is how difficult?'
          ''
          'Mercator Projection:'
          '--------------------'
          ''
          
            'Mapping features based on Latitude/Longitude coordinates require' +
            's that we convert points from Lat/Long to screen Pixel (x,y) loc' +
            'ations.'
          
            'Since we live on a spherical earth and most maps, including scre' +
            'ens, are generally flat,  maps distort the data'
          
            'points in some way.   The Mercator projection, developed in the ' +
            '16th century and is still widely used,  is a cylindrical project' +
            'ion with straight'
          
            'equally spaced longitude lines, the ones running vertically thro' +
            'ugh the poles.   (X coordinate on our map is directly proportion' +
            'al to longitude'
          
            'angle).  Away from the equator, the map is "stretched" in an eas' +
            't-west and north-south direction so that the latitude lines, the' +
            ' ones parallel'
          
            'to the equator which get shorter as we move away from the equato' +
            'r, also lie on the surface of a cylinder.  (Think of  a rubber g' +
            'lobe inflated'
          
            'inside of glass cylinder).  There is a problem of course near th' +
            'e poles where the scaling (stretching) would have to approach in' +
            'finity as the '
          
            'length of the latitude lines approached zero.  In practice, 70 o' +
            'r 80 degrees North or South is as far as we want to go.  This gr' +
            'eater stretching '
          
            'at higher latitudes has the effect of maintaining geographic sha' +
            'pes but increasing their area so that on a map of North America ' +
            'for '
          
            'example, Alaska with an area about 1/5 of the lower 48 states ap' +
            'pears to be about 1/2 as large as the lower 48.'
          ''
          ''
          'Operation:'
          '----------'
          ''
          
            'In order to establish the scaling factors to convert lat/long an' +
            'gle coordinates to pixel x,y coordinates, we need to locate two ' +
            'known points,'
          
            'preferably widely separated in latitude and longitude.  If scali' +
            'ng has not been established, it will be necessary to define and ' +
            'click on two'
          
            'known scaling points first.  After the scaling has been establis' +
            'hed, the user can click on any point on the map to see its coord' +
            'inates in the'
          
            'location list.  The user can also click on any item in the locat' +
            'ion list (where lat/long are specified) to see its location on t' +
            'he map.'
          ''
          
            '***The "Load Map" button will allow the user to select a new map' +
            '.  Four Mercator projection outline maps are included in the dow' +
            'nloaded'
          'zip file:'
          ''
          
            '......"USA.bmp" is the default outline map of the USA.  Scaling ' +
            'predefined using San Diego, California and Estcourt Station, Mai' +
            'ne.'
          
            'The location of these points as well as the Cape Alava, WA & Bal' +
            'last Key, FL pair used for testing have been pre-located with co' +
            'lored dots'
          ' on the map file.'
          ''
          
            '......"Europe.bmp":  Scaling predefined using Lisbon and Stockho' +
            'lm.'
          ''
          
            '......"Mexico.bmp":  Not tested.  Scaling points have not been e' +
            'stablished for this map.  User must enter Lat/Long coordinates f' +
            'or two points '
          
            'which can be located and clicked on the outline based on geometr' +
            'ic features of the outline. I would try "Tijuana" and "Cancuin".'
          ''
          '......"Canada.bmp": Not tested. See comments above for Mexico.'
          ''
          
            '***The "Add Location" button displays a dialog to add additional' +
            ' points.'
          ''
          
            '***The "Rescale" button allows users to scale points again if no' +
            't satisfied with the accuracy of initial scaling clicks.'
          ''
          
            '***"Change Name or Lat/Long" button in the scaling points box al' +
            'lows user to define or redefine the two points used to establish' +
            ' the scaling'
          ' factors.'
          ''
          'The INI file:'
          '-------------'
          ''
          
            'Information about scaling points (Name, Latitude/Longitude and P' +
            'ixel X/Y coordinates)  and Location List contents are saved for ' +
            'each map'
          
            'in file "Mercator.ini".  This is a text file which may be viewed' +
            ' or edited (carefully) outside of the program.   Since the progr' +
            'am generates'
          
            'content of this file, error checking when retrieved may be less ' +
            'stringent than for direct user input.'
          ''
          'Location List:'
          '--------------'
          ''
          
            'A list of predefined named locations with Latitude/Longitude coo' +
            'rdinates is maintained for each map.  The Add Location button wi' +
            'll solicit'
          
            'that information from the user and add it to the list.  Clicked ' +
            'items on the list to see the point highlighted with a red dot on' +
            ' the map.  Select a'
          
            'an entry and press the Delete key to remove it from the list. Po' +
            'ints clicked on the map will be added to the list with a name of' +
            ' "Clicked'
          'point" and the Lat/Long of the point.'
          ''
          'Lat/Long Formats:'
          '-----------------'
          ''
          
            'Latitude angles are measured North and South from the equator.  ' +
            'North angles are 0 to 90 degrees positive, South angles are 0 to' +
            ' -90'
          
            'negative. Longitude angles are measured East and West from an ar' +
            'bitrary line through both poles and Greenwich, England.  Values ' +
            'range'
          
            'from 0 to 180 moving East and 0 to -180 moving to the West.  Ang' +
            'les may be specified as Degrees:Minutes:Seconds similar to time '
          'formatting with 60 minutes per degree and 60 seconds per minute.'
          
            'This program accepts this program accepts inputs in several form' +
            'ats:'
          ''
          
            'One, two or three numbers separated by space or colon, final num' +
            'ber may be decimal (xxx.xxx) format; 14.269 or 14:16.14 or 14 16' +
            ' 8.4 for'
          
            'example.  Optional degree, minute or second symbols (° ´ ´´)igno' +
            'red by conversion routine; 32° 42´ 55.00´´ for example. Negative' +
            ' angles '
          
            'denoted by S (latitudes), W (longitudes) preceding or following ' +
            'the angle, or by preceding the angle with a - sign; 117 9 26 W o' +
            'r -117°  9´ '
          '26.00´´ for example.'
          ''
          ''
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'View Map'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1048
        Height = 659
        Align = alClient
        Caption = 'Panel1'
        Color = clActiveBorder
        TabOrder = 0
        object SetScaleLbl: TLabel
          Left = 16
          Top = 8
          Width = 329
          Height = 57
          AutoSize = False
          Caption = 'SetScaleLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Label2: TLabel
          Left = 24
          Top = 88
          Width = 110
          Height = 16
          Caption = 'Defined locations'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Image1: TImage
          Left = 391
          Top = 8
          Width = 638
          Height = 649
          OnClick = Image1Click
        end
        object LocationList: TListBox
          Left = 16
          Top = 104
          Width = 289
          Height = 209
          ItemHeight = 16
          Items.Strings = (
            'Cape Alava, WA; 48 10 N; 124 44 W'
            'Ballast key, FL; 24 31 15 N; 81 57 49 W'
            'Four Corners; 36 59 56 N; 109 2 42 W'
            'Estcourt Station, ME; 47 27 58 N; 69 13 47 W'
            ' ')
          TabOrder = 0
          OnClick = LocationListClick
          OnKeyUp = LocationListKeyUp
        end
        object AddlocBtn: TButton
          Left = 24
          Top = 336
          Width = 145
          Height = 25
          Caption = 'Add a location'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = AddlocBtnClick
        end
        object RescaleBtn: TButton
          Left = 24
          Top = 368
          Width = 145
          Height = 25
          Caption = 'Rescale'
          TabOrder = 2
          OnClick = RescaleBtnClick
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 464
          Width = 385
          Height = 185
          Caption = 'Current Map Scaling Points'
          TabOrder = 3
          object Label4: TLabel
            Left = 32
            Top = 104
            Width = 69
            Height = 16
            Caption = 'Scale Loc 2'
          end
          object Label3: TLabel
            Left = 32
            Top = 32
            Width = 69
            Height = 16
            Caption = 'Scale Loc 1'
          end
          object Scale1PixelLbl: TLabel
            Left = 32
            Top = 70
            Width = 158
            Height = 17
            Caption = 'Pixel  location Y=0; X=0)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object Scale2PixelLbl: TLabel
            Left = 32
            Top = 150
            Width = 158
            Height = 17
            Caption = 'Pixel Location  Y=0, X=0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
          end
          object ScaleLoc1Edt: TEdit
            Left = 32
            Top = 48
            Width = 337
            Height = 24
            TabOrder = 0
            Text = 'Cape Alava, WA; 48 10 N; 124 44 W'
            OnExit = ScaleChange
          end
          object ScaleLoc2Edt: TEdit
            Left = 32
            Top = 128
            Width = 337
            Height = 24
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Pitch = fpFixed
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Text = 'Ballast Key, FL; 24 31 15 N; 81 57 49 W'
            OnExit = ScaleChange
          end
          object ChangeScaleBtn: TButton
            Left = 192
            Top = 16
            Width = 177
            Height = 25
            Caption = 'Change Name or  Lat/Long'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'Arial'
            Font.Style = [fsItalic]
            ParentFont = False
            TabOrder = 2
            OnClick = ChangeScaleBtnClick
          end
        end
        object Button1: TButton
          Left = 24
          Top = 408
          Width = 145
          Height = 25
          Caption = 'Load Map'
          TabOrder = 4
          OnClick = LoadmapBtnClick
        end
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 690
    Width = 1056
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object LoadMapDlg: TOpenDialog
    DefaultExt = 'bmp'
    Filter = 'BMP Image|*.bmp'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 864
    Top = 24
  end
end
