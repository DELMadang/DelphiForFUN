object Form1: TForm1
  Left = 274
  Top = 112
  Width = 1133
  Height = 701
  Caption = 'Point in space from 4 sensors  V5.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object Label1: TLabel
    Left = 612
    Top = 81
    Width = 67
    Height = 18
    Caption = 'Sensor 1 '
  end
  object Label2: TLabel
    Left = 711
    Top = 56
    Width = 19
    Height = 21
    Caption = 'X:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 792
    Top = 56
    Width = 19
    Height = 21
    Caption = 'Y:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 873
    Top = 56
    Width = 17
    Height = 21
    Caption = 'Z:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 954
    Top = 56
    Width = 41
    Height = 21
    Caption = 'Dist:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 612
    Top = 117
    Width = 67
    Height = 18
    Caption = 'Sensor 2 '
  end
  object Label7: TLabel
    Left = 612
    Top = 153
    Width = 67
    Height = 18
    Caption = 'Sensor 3 '
  end
  object Label8: TLabel
    Left = 612
    Top = 189
    Width = 67
    Height = 18
    Caption = 'Sensor 4 '
  end
  object AnswerLbl: TLabel
    Left = 621
    Top = 549
    Width = 73
    Height = 18
    Caption = 'AnswerLbl'
    Visible = False
  end
  object Label11: TLabel
    Left = 585
    Top = 27
    Width = 482
    Height = 18
    Caption = 
      'Load, generate, or enter a case and click "Solve" to see the sol' +
      'ution'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label9: TLabel
    Left = 630
    Top = 369
    Width = 117
    Height = 21
    Caption = 'Current Case: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Caselbl: TLabel
    Left = 630
    Top = 396
    Width = 200
    Height = 21
    Caption = 'Simple case 1 (Unsaved)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 634
    Width = 1115
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, 2014,   Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object RandcaseBtn: TButton
    Left = 846
    Top = 261
    Width = 199
    Height = 28
    Caption = 'Generate random case'
    TabOrder = 1
    OnClick = RandcaseBtnClick
  end
  object Edit1: TEdit
    Tag = 1
    Left = 711
    Top = 81
    Width = 59
    Height = 26
    TabOrder = 2
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit2: TEdit
    Tag = 2
    Left = 792
    Top = 81
    Width = 59
    Height = 26
    TabOrder = 3
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit3: TEdit
    Tag = 3
    Left = 873
    Top = 81
    Width = 59
    Height = 26
    TabOrder = 4
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit4: TEdit
    Tag = 4
    Left = 954
    Top = 81
    Width = 59
    Height = 26
    TabOrder = 5
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit5: TEdit
    Tag = 5
    Left = 711
    Top = 117
    Width = 59
    Height = 26
    TabOrder = 6
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit6: TEdit
    Tag = 6
    Left = 792
    Top = 117
    Width = 59
    Height = 26
    TabOrder = 7
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit7: TEdit
    Tag = 7
    Left = 873
    Top = 117
    Width = 59
    Height = 26
    TabOrder = 8
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit8: TEdit
    Tag = 8
    Left = 954
    Top = 117
    Width = 59
    Height = 26
    TabOrder = 9
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit9: TEdit
    Tag = 9
    Left = 711
    Top = 153
    Width = 59
    Height = 26
    TabOrder = 10
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit10: TEdit
    Tag = 10
    Left = 792
    Top = 153
    Width = 59
    Height = 26
    TabOrder = 11
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit11: TEdit
    Tag = 11
    Left = 873
    Top = 153
    Width = 59
    Height = 26
    TabOrder = 12
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit12: TEdit
    Tag = 12
    Left = 954
    Top = 153
    Width = 59
    Height = 26
    TabOrder = 13
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit13: TEdit
    Tag = 13
    Left = 711
    Top = 189
    Width = 59
    Height = 26
    TabOrder = 14
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit14: TEdit
    Tag = 14
    Left = 792
    Top = 189
    Width = 59
    Height = 26
    TabOrder = 15
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit15: TEdit
    Tag = 15
    Left = 873
    Top = 189
    Width = 59
    Height = 26
    TabOrder = 16
    Text = '0.0'
    OnChange = EditChange
  end
  object Edit16: TEdit
    Tag = 16
    Left = 954
    Top = 189
    Width = 59
    Height = 26
    TabOrder = 17
    Text = '0.0'
    OnChange = EditChange
  end
  object Solvebtn: TButton
    Left = 621
    Top = 477
    Width = 217
    Height = 28
    Caption = 'Gaussian Elimination'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
    OnClick = SolvebtnClick
  end
  object Memo2: TMemo
    Left = 18
    Top = 414
    Width = 568
    Height = 208
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Results display here')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 19
  end
  object GentestBtn: TButton
    Left = 621
    Top = 261
    Width = 199
    Height = 28
    Caption = 'Generate Simple case 1'
    TabOrder = 20
    OnClick = GentestBtnClick
  end
  object SaveBtn: TButton
    Left = 846
    Top = 315
    Width = 199
    Height = 28
    Caption = 'Save Case'
    TabOrder = 21
    OnClick = SaveBtnClick
  end
  object LoadBtn: TButton
    Left = 621
    Top = 315
    Width = 199
    Height = 28
    Caption = 'Load case'
    TabOrder = 22
    OnClick = LoadBtnClick
  end
  object TrilaterateBtn: TButton
    Left = 864
    Top = 477
    Width = 190
    Height = 28
    Caption = 'Trilateration'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 23
    OnClick = TrilaterateBtnClick
  end
  object PageControl1: TPageControl
    Left = 9
    Top = 18
    Width = 559
    Height = 379
    ActivePage = TabSheet1
    TabOrder = 24
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 551
        Height = 346
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            'We have 4 sensors at known locations in 3D space. Each sensor ca' +
            'n '
          'supply'
          
            'distance information to a target but knows nothing about the tar' +
            'get'#39's '
          'direction.'
          
            'Alternatively, the sensors are Satellites and the target is a GP' +
            'S receiver '
          'which'
          
            'reads very accurate time stamps transmitted by the satellites an' +
            'd '
          'calculates'
          
            'distances based on time offsets between its clock and satellites' +
            #39' clocks.'
          ''
          
            'Given the sensor (X,Y,Z) coordinates and their reported distance' +
            '-to-target'
          
            'values, we want to determine the target location.  The program u' +
            'ses either '
          'of'
          
            'two methods to locate the target object; "Gaussian Elimination" ' +
            'or'
          
            '"Trilateration" which is new with Version 5 of the program.  In ' +
            'both methods, '
          'a '
          
            'set of distance equations is solved based finding the single int' +
            'ersection '
          'point of '
          
            'spheres centered on the sensors with radii equal to the sensor'#39's' +
            ' (or the '
          'target'#39's) '
          'estimate of the distance to (or from) the target.'
          ''
          
            'Note that, in general, the problem requires 4 equations to narro' +
            'w solutions '
          'to a '
          
            'single point.  Two sensors can narrow target location down to a ' +
            'circle (the '
          
            'intersection of 2 spheres with target distances as radii), the 3' +
            'rd sensor can '
          
            'narrow the location down to two possible points, (the intersecti' +
            'on of the '
          'circle '
          
            'with the 3rd sensor'#39's sphere). The 4th sensor'#39's distance should ' +
            'determine '
          
            'which of those two points is the target.  Any error in specified' +
            ' locations or '
          
            'distances would either have no solution or require that some inp' +
            'ut values '
          'be '
          'adjusted.'
          ''
          'The techniques applied here result in reported distances being'
          
            'adjusted to produce a solution if necessary.  Differences betwee' +
            'n input and '
          
            'calculated distances are listed as part of the solution.  The do' +
            'wnload for '
          'this '
          
            'program includes an unfiltered set of test cases created during ' +
            'testing.  At '
          'least '
          
            'one case, "Random1.ini", returns significantly different results' +
            ' for the two '
          'methods and needs further investigation.')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '   Gaussian Elimination  '
      ImageIndex = 1
      object Memo3: TMemo
        Left = 0
        Top = 0
        Width = 551
        Height = 346
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            'Gaussian Elimination is a technique used to solve a set of linea' +
            'r equations. '
          'The '
          
            '4 distances equation describing the distance from a sensor to th' +
            'e target '
          'can be '
          
            'reduce to three liniear equations by subtracting one of the equa' +
            'tions from '
          'the '
          'other 3.'
          ''
          
            'The set of linear equations describing the problem are derived a' +
            's follows:'
          ''
          
            'The distance Di to target at (Xt,Yt,Zt) for sensor "i" located a' +
            't'
          
            '(Ai, Bi, Ci) is given by Sqr(Di)=Sqr((Ai - Xt) + Sqr(Bi - Yt) + ' +
            'Sqr(Ci - -Zt)'
          ''
          
            '==> Di^2 = Ai^2 - 2AiXt + Xt^2 +Bi^2 - 2BiYt +Yt^2 +Ci^2 - 2CiZt' +
            ' + Zt^2'
          ''
          'We can subtract the Sensor1 equation  from each of the other 3'
          'to obtain linear equations like the following example  for'
          'Sensor2::'
          ''
          '2(A1-A2)Xt + 2(B1-B2)Yt + 2((C1-C2)Zt'
          
            '            = D2^2 - A2^2 - B2^2 - C2^2 - D1^2 + A1^2 + B1^2 + C' +
            '1^2'
          ''
          'The resulting 3 equations in 3 unknowns form a system of linear'
          'equations which are solved using Gaussian Elimination to find'
          'the (Xt, Yt, Zt) target coordinates.'
          ''
          
            'The "Gaussian Elimination" button assumes that errors are caused' +
            ' by a'
          'clock synchronization error between a satellite and the GPS'
          
            'receiver, resulting in a constant error for each distance calcul' +
            'ated.'
          
            'By iteratively adding 1/2 the difference bewteen the previous in' +
            'put'
          'distance and the newly calculated distance in each step, we can'
          'converge results to near zero differences.')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = '   Trilateration   '
      ImageIndex = 2
      object Memo4: TMemo
        Left = 0
        Top = 0
        Width = 551
        Height = 346
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            'Trilateration is another technique, mathematically exact this ti' +
            'me, to find the '
          
            'intersection point of 3 spheres by finding the point of the tetr' +
            'ahedron '
          'formed by'
          
            'three of the given points and their distances from the target.  ' +
            'The Wikipedia '
          
            'article on "Trilateration" provides an excellent derivation of t' +
            'he mathematics '
          'behind the method.'
          ''
          
            'As an experiment,  I coded the calculation and here apply it to ' +
            'each '
          'combination of'
          
            'three of the four sensor locations given (Sensors (1,2,3), (1,2,' +
            '4),(1,3,4), '
          'and '
          
            '(2,3,4) .  There may be two results for each calculation represe' +
            'nting the '
          'target '
          
            'on either side of the triangle formed by the three sensors used.' +
            ' Results of '
          'each '
          
            'calculation are saved and the set with the smallest sum of diffe' +
            'rences from '
          'the '
          'input distance is defined as the solution.'
          ''
          
            'The solutions tested so far agree with Gaussian method results, ' +
            'but this'
          
            'methos is more robust, solving the case below which Gaussian fai' +
            'ls to '
          'solve; '
          
            '(x,y,z,r): P1:(0,0,0,10), P2:(10,0,0,10), P3:(0,10,0,10), P4:(10' +
            ',10,0,10).  '
          'This '
          'case is included with the download as TestCase5.ini.')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object VerboseBox: TCheckBox
    Left = 630
    Top = 450
    Width = 316
    Height = 19
    Caption = 'Verbose (show more result detail)'
    TabOrder = 25
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Case files (*.ini)|*.ini|All files (*.*)|*.*'
    Left = 752
    Top = 520
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Case files (*.ini)|*.ini|All files (*.*)|*.*'
    Left = 816
    Top = 512
  end
end
