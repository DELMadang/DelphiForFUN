object Form1: TForm1
  Left = 408
  Top = 130
  Width = 993
  Height = 874
  Caption = 'Circle from 3 points, Version 2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 19
  object Image1: TImage
    Left = 554
    Top = 20
    Width = 405
    Height = 385
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
  end
  object Label1: TLabel
    Left = 562
    Top = 415
    Width = 103
    Height = 19
  end
  object Label2: TLabel
    Left = 640
    Top = 592
    Width = 14
    Height = 24
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 784
    Top = 592
    Width = 12
    Height = 24
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 560
    Top = 624
    Width = 49
    Height = 20
    Caption = 'Point 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 560
    Top = 664
    Width = 49
    Height = 20
    Caption = 'Point 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 560
    Top = 704
    Width = 49
    Height = 20
    Caption = 'Point 3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 552
    Top = 448
    Width = 409
    Height = 137
    ItemHeight = 19
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 20
    Top = 20
    Width = 517
    Height = 477
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This program tests two functions which define a circle given '
      'three points on its circumference.'
      ''
      'Function "GetCenter" determines the equation (slope and '
      
        'intercept) of the perpendicular bisectors of lines connecting an' +
        'y '
      
        '2 pairs from the three given points.  These bisectors intersect ' +
        'at '
      'the center of the circle.  So by solving  the two bisector '
      'equations we can determine the center point.  '
      ''
      'Of course, Pythagoras will tell us the radius if we use his '
      
        'theorem to calculate the distance from the center to  any of the' +
        ' '
      'three points. '
      '  '
      'In this case, though, a second function GetRadius is used to '
      
        'obtain the radius.  GetRadius is much quicker if we don'#39't need t' +
        'o '
      'know where the center is, '
      'just how far away it is.   '
      ''
      
        'To test, just click three points on the rectangle at right and w' +
        'atch the '
      'circle magically appear.'
      ''
      'References:'
      
        'http://forum.swarthmore.edu/dr.math/problems/culpepper9.9.97.htm' +
        'l'
      'http://192.154.43.167/goebel/statecon/Topics/triangl/TRIANGL.htm'
      '')
    ParentFont = False
    TabOrder = 1
  end
  object P1X: TEdit
    Left = 627
    Top = 618
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '0'
    OnChange = ManualChange
  end
  object P1Y: TEdit
    Left = 770
    Top = 618
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '0'
    OnChange = ManualChange
  end
  object P2x: TEdit
    Left = 627
    Top = 658
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Text = '0'
    OnChange = ManualChange
  end
  object P2y: TEdit
    Left = 770
    Top = 658
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    Text = '0'
    OnChange = ManualChange
  end
  object P3x: TEdit
    Left = 627
    Top = 698
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    Text = '0'
    OnChange = ManualChange
  end
  object P3y: TEdit
    Left = 770
    Top = 698
    Width = 100
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    Text = '0'
    OnChange = ManualChange
  end
  object ShowBtn: TButton
    Left = 776
    Top = 760
    Width = 145
    Height = 25
    Caption = 'Show circle'
    TabOrder = 8
    OnClick = ShowBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 805
    Width = 975
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2003, 2009 , Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 9
    OnClick = StaticText1Click
  end
  object Memo2: TMemo
    Left = 24
    Top = 512
    Width = 505
    Height = 209
    Color = 13172735
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'Version 2 (December 2009) adds ability to manually enter points ' +
        'to '
      'solve specific problems. Manually entered values may  have '
      
        'decimal points.  When the "Show circle" button is clicked, cente' +
        'r '
      
        'and radius for the circumscribing circle are given in the inout ' +
        'units  '
      'and the points are automatically scaled to fit the screen.')
    ParentFont = False
    TabOrder = 10
  end
end
