object Form1: TForm1
  Left = 65
  Top = 124
  Width = 1130
  Height = 739
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'Circle Covering Points - V2.2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 414
    Top = 10
    Width = 369
    Height = 369
    OnMouseUp = Image1MouseUp
  end
  object ResultsLbl: TLabel
    Left = 417
    Top = 394
    Width = 408
    Height = 100
    AutoSize = False
    Caption = 'resultslbl'
    WordWrap = True
  end
  object TimeLbl: TLabel
    Left = 880
    Top = 601
    Width = 49
    Height = 16
    Caption = 'TimeLbl'
  end
  object ResetBtn: TButton
    Left = 876
    Top = 10
    Width = 139
    Height = 31
    Caption = 'Reset'
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object MethodGrp: TRadioGroup
    Left = 414
    Top = 502
    Width = 434
    Height = 149
    Caption = 'Algorithm'
    ItemIndex = 5
    Items.Strings = (
      '1. Circle through 2 points furthest apart'
      '2. As above but radius = max distance from center to any point '
      
        '3. As above but set 3rd point to give triangle with max perimete' +
        'r'
      '4. Circle through the triangle with maximum perimeter'
      
        '5. Try circles though all point triplets, pick smallest enclosin' +
        'g all pts. '
      '6. Elzinga-Hearn Algorithm  ')
    TabOrder = 1
    OnClick = CalcBtnClick
  end
  object Memo1: TMemo
    Left = 20
    Top = 10
    Width = 375
    Height = 552
    Color = 14483455
    Lines.Strings = (
      ''
      'Here'#39's a simple problem with a not-so-simple solution:'
      '"Draw the smallest circle that will cover a given set of '
      'points."  The last method listed below is the best '
      '(quickest)known, also the most complicated.  Search the '
      'Internet for "Elzinga-Hearn" and you can find many '
      'refernces decribing the algorithm.  The source code for '
      'this program also descibes it.'
      ''
      'The other methods are my attempts to solve the problem'
      'with less complexity.  Sure enough, they either don'#39't '
      'work, almost work, or work more slowly than Elzinga-'
      'Hearn.  According to the literature, Elzinga-Hearn runs in '
      'time proportional to the square of the number of points, '
      'other viable methods run in time proportional to the 4th '
      'power of number of points!'
      ''
      'To run just select an algorithm and start clicking on the'
      'white rectangle.  Each click after the 2nd will draw it'#39's '
      'circle and report the run time.  Change algorithms to see '
      'effect on a set of points.'
      ''
      'Version 2 Note - You can now enter/ modify x-y'
      'coordinates in the memo box at the right hand side of the '
      'screen.  Enter one coordinate per line as x,y (x and y '
      'values separated by a comma).   E.g. 23.45,9.5.   Points '
      'can be saved and reloaded as text files. Sample files are '
      'included with point sets that fail for at least one of the '
      'first 5 algorithms.'
      ''
      'The circle for the currently selected algorithm will be'
      'automatically recalculated for each image click or point'
      'entered.')
    TabOrder = 2
  end
  object Memo2: TMemo
    Left = 864
    Top = 207
    Width = 233
    Height = 365
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
    OnChange = Memo2Change
  end
  object Loadbtn: TButton
    Left = 876
    Top = 59
    Width = 139
    Height = 31
    Caption = 'Load data'
    TabOrder = 4
    OnClick = LoadbtnClick
  end
  object SaveBtn: TButton
    Left = 876
    Top = 108
    Width = 139
    Height = 31
    Caption = 'Save data'
    TabOrder = 5
    OnClick = SaveBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 673
    Width = 1112
    Height = 21
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files  (*.txt)|*.txt|Any file (*.*)|*.*'
    Left = 344
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files  (*.txt)|*.txt|All files  (*.*)|*.*'
    Left = 400
    Top = 24
  end
end
