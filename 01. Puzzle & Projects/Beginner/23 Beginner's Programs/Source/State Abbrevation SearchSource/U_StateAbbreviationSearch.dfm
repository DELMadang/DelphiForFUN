object Form1: TForm1
  Left = 316
  Top = 256
  Width = 1103
  Height = 760
  Caption = 'Find State abbreviaitions embedded in state names  '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 692
    Width = 1085
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1085
    Height = 692
    Align = alClient
    TabOrder = 1
    object DisplayLbl: TLabel
      Left = 648
      Top = 16
      Width = 327
      Height = 28
      Caption = 'Standard State name abbreviations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentFont = False
    end
    object SearchBtn: TButton
      Left = 40
      Top = 416
      Width = 417
      Height = 41
      Caption = 'Search for embedded abbreviations'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object Memo1: TMemo
      Left = 32
      Top = 16
      Width = 601
      Height = 377
      Color = 15400959
      Lines.Strings = (
        
          'A surprising number of U.S. state names contain multiple pairs o' +
          'f'
        'letters which form standard two-letter state abbreviations.  For'
        'example  ALABAMA contains two: AL and MA'
        ''
        'If we disallow overlapping abbreviations, can you find the only'
        'state name that contains four abbreviations?'
        ''
        'Source: The Mensa Puzzle Calendar entry for May 30,2015.'
        ''
        'Bonus question: Which two state names contain no state name '
        'abbreviations at all?'
        ''
        'The button below will alternate between searching for solutions '
        'and displaying the standard abbreviations for each state.')
      TabOrder = 1
    end
    object Memo2: TMemo
      Left = 656
      Top = 48
      Width = 417
      Height = 625
      Lines.Strings = (
        'Alabama=AL'
        'Alaska=AK'
        'Arizona=AZ'
        'Arkansas=AR'
        'California=CA'
        'Colorado=CO'
        'Connecticut=CT'
        'Delaware=DE'
        'Florida=FL'
        'Georgia=GA'
        'Hawaii=HI'
        'Idaho=ID'
        'Illinois=IL'
        'Indiana=IN'
        'Iowa=IA'
        'Kansas=KS'
        'Kentucky=KY'
        'Louisiana=LA'
        'Maine=ME'
        'Maryland=MD'
        'Massachusetts=MA'
        'Michigan=MI'
        'Minnesota=MN'
        'Mississippi=MS'
        'Missouri=MO'
        'Montana=MT'
        'Nebraska=NE'
        'Nevada=NV'
        'New Hampshire=NH'
        'New Jersey=NJ'
        'New Mexico=NM'
        'New York=NY'
        'North Carolina=NC'
        'North Dakota=ND'
        'Ohio=OH'
        'Oklahoma=OK'
        'Oregon=OR'
        'Pennsylvania=PA'
        'Rhode Island=RI'
        'South Carolina=SC'
        'South Dakota=SD'
        'Tennessee=TN'
        'Texas=TX'
        'Utah=UT'
        'Vermont=VT'
        'Virginia=VA'
        'Washington=WA'
        'West Virginia=WV'
        'Wisconsin=WI'
        'Wyoming=WY')
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
end
