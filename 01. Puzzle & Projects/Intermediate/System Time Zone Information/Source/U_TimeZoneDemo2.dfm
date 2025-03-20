object Form1: TForm1
  Left = 192
  Top = 107
  Width = 698
  Height = 682
  Caption = 'Demo of GetTimeZoneInformation Windows API function, Version 2.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 60
    Top = 18
    Width = 552
    Height = 311
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    TabOrder = 0
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 611
    Width = 680
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2004, 2016  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object Memo2: TMemo
    Left = 16
    Top = 352
    Width = 641
    Height = 249
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Version 2 corrects the daylight saving time start and end date d' +
        'isplays. The system '
      
        '"Day of Month" value in these fields specifies which occurrence ' +
        'of the "Day of '
      
        'Week" value applies.  That is now converted to the correct "Day ' +
        'of Month" in the '
      'display above.'
      ''
      
        'Version 2.1 fixes a problem when Southern Hemisphere DST crosses' +
        ' a year '
      
        'boundary.  The only indication in Microsoft'#39's time zone records ' +
        'is that the ending '
      
        'month has a lower number than the starting month.  Ending year i' +
        's now '
      
        'incremented when this condition is found. Also, regions which do' +
        ' not use DST '
      
        '(e.g. Queensland, Austrailia).  have all zeros in the informatio' +
        'n records. Previous '
      
        'version crashed for those regions.  It now ends gracefully when ' +
        ' this occurs.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
