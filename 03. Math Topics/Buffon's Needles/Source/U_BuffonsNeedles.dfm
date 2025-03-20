object Form1: TForm1
  Left = 184
  Top = 29
  Width = 800
  Height = 600
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object StaticText1: TStaticText
    Left = 0
    Top = 549
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 549
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Drop needles'
      object Image1: TImage
        Left = 352
        Top = 24
        Width = 361
        Height = 313
      end
      object Label1: TLabel
        Left = 32
        Top = 368
        Width = 273
        Height = 113
        AutoSize = False
        Caption = 'Label1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
      end
      object Label2: TLabel
        Left = 184
        Top = 32
        Width = 89
        Height = 16
        Caption = 'Line spacing'
      end
      object Label3: TLabel
        Left = 184
        Top = 88
        Width = 98
        Height = 16
        Caption = 'Needle length'
      end
      object TimeLbl: TLabel
        Left = 32
        Top = 488
        Width = 65
        Height = 16
        Caption = 'Run time:'
      end
      object Label7: TLabel
        Left = 184
        Top = 136
        Width = 129
        Height = 49
        AutoSize = False
        Caption = ' Note: Needle length limited to two times the line spacing '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object StopBtn: TButton
        Left = 32
        Top = 200
        Width = 289
        Height = 73
        Caption = 'STOP'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnClick = StopBtnClick
      end
      object CountGrp: TRadioGroup
        Left = 32
        Top = 32
        Width = 121
        Height = 129
        Caption = 'Needles to drop'
        ItemIndex = 3
        Items.Strings = (
          '1,000'
          '10,000'
          '100,000'
          '1,000,000'
          '10,000,000'
          '100,000,000')
        TabOrder = 1
      end
      object SpacingEdt: TSpinEdit
        Left = 184
        Top = 56
        Width = 81
        Height = 26
        MaxValue = 50
        MinValue = 5
        TabOrder = 2
        Value = 20
        OnChange = SpacingEdtChange
      end
      object NeedleEdt: TSpinEdit
        Left = 184
        Top = 104
        Width = 81
        Height = 26
        MaxValue = 50
        MinValue = 5
        TabOrder = 3
        Value = 20
        OnChange = NeedleEdtChange
      end
      object GraphitBtn: TButton
        Left = 32
        Top = 208
        Width = 289
        Height = 25
        Caption = 'Drop needles (1st 1000 plotted)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = GraphitBtnClick
      end
      object FastCalcBtn: TButton
        Left = 32
        Top = 240
        Width = 289
        Height = 25
        Caption = 'Fast drop (assumes needle length=spacing)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = FastCalcBtnClick
      end
      object Memo1: TMemo
        Left = 400
        Top = 344
        Width = 281
        Height = 145
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Buffon'#39's Needles algorithm  estimates Pi by '
          'counting crossings of needles dropped  '
          'randomly on a grid of horizontal lines and '
          'counting line crossings. '
          ''
          ' Accurate estimates require several milllion '
          'trials, making it  an interesting but rather poor '
          'estimator of Pi.')
        ParentFont = False
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = ' Show distribution chart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Image2: TImage
        Left = 400
        Top = 32
        Width = 361
        Height = 257
      end
      object Label4: TLabel
        Left = 400
        Top = 296
        Width = 369
        Height = 25
        AutoSize = False
        Caption = 
          '0                                     Angle                     ' +
          '                 Pi'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 376
        Top = 24
        Width = 21
        Height = 16
        Caption = '1.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 376
        Top = 280
        Width = 21
        Height = 16
        Caption = '0.0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 408
        Top = 328
        Width = 302
        Height = 20
        Caption = 'A       B       C       D       E        F       G'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 24
        Top = 312
        Width = 94
        Height = 16
        Caption = 'Column Legend'
      end
      object Memo2: TMemo
        Left = 24
        Top = 24
        Width = 345
        Height = 273
        Lines.Strings = (
          'Here is a probability chart of number of line'
          'crossings/imagewidth plotted against the angle of the '
          'needle.  Angles are calculated for every pixel in the '
          'image width.  This is currently 360 so each line represents '
          'Pi/360 radians or 1/2 degree.  For the simplest case with  '
          'needle length equal to line spacing,  the probability that a '
          'needle dropped at angle theta will cross a line is '
          'sine(theta) (the red curve).  1.0.   For other spacings and '
          'lengths, the "crossings" number is adjusted by the ratio of '
          'spacing to needle length.'
          ''
          'For angles from 0 to 180 degrees, (0 to Pi radians), the '
          'area under  this curve, 1/2 cycle of sin(theta) is 2/Pi .  So, '
          'since p=2/Pi, the estimate of Pi, given P, is Pi = 2/P.'
          ''
          'Actual values are listed in a table belw the chart.')
        TabOrder = 0
      end
      object Memo4: TMemo
        Left = 24
        Top = 328
        Width = 345
        Height = 185
        Color = 16777088
        Lines.Strings = (
          'A: Angle of needles in degrees (Theta)'
          'B: Number needles at this angle that crossed a line '
          '    (adjusted for line spacing and  needle length).'
          'C; Number of needles at this angle (should be about the '
          '     same for each angle}'
          'D: Probability of crossing (B/C)'
          'E: Sine of Theta'
          'F: Sum of the rectangle areas.  Cumulative sum of '
          '   (Probability[A] * (Pi/360) )  '
          'G: Integral of Sine Theta (0 to A)  (Area under  the  red '
          '    curve}')
        TabOrder = 2
      end
      object Memo3: TMemo
        Left = 408
        Top = 352
        Width = 345
        Height = 161
        Color = 16777088
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
  end
end
