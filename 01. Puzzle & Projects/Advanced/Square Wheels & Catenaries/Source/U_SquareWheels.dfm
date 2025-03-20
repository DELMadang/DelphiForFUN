object Form1: TForm1
  Left = 90
  Top = 139
  Width = 800
  Height = 600
  Caption = 'Square Wheels'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 542
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Roll a square wheel'
      object Roadbtn: TButton
        Left = 48
        Top = 232
        Width = 89
        Height = 25
        Caption = 'Draw roadbed'
        TabOrder = 0
        OnClick = RoadbtnClick
      end
      object Rollbtn: TButton
        Left = 48
        Top = 376
        Width = 89
        Height = 25
        Caption = 'Roll the wheel'
        TabOrder = 1
        OnClick = RollbtnClick
      end
      object Panel1: TPanel
        Left = 160
        Top = 232
        Width = 601
        Height = 209
        Caption = 'Panel1'
        Color = clBlue
        TabOrder = 2
        object Image1: TImage
          Left = 8
          Top = 8
          Width = 585
          Height = 193
        end
      end
      object Memo2: TMemo
        Left = 24
        Top = 16
        Width = 737
        Height = 185
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'Wheels do not have to be round if if they "roll" over a roadbed ' +
            'that rises and falls in exactly the right way to keep the center' +
            ' of'
          'the wheel at a constant height.'
          ''
          
            'In the case of wheels that are regular polygons, the road must c' +
            'onsist of a series of regular bumps of the correct width,'
          
            'height and shape.  The shape in this case is an "inverted catena' +
            'ry" curve. The hard part of writing this program was'
          
            'finding the width and height of the "bumps".  See the "Catenary ' +
            'parameters" page for more information.   The sample here'
          
            'uses square wheels, but regular pentagons, hexagons, octagons, e' +
            'tc. would work the same way except bumps become'
          
            'successively narrower and shallower, but are still inverted cate' +
            'naries.'
          ''
          
            'The two buttons below will draw the roadbed and roll the wheel a' +
            'cross it.'
          ' '
          ' ')
        ParentFont = False
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Find Catenary parameters'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 32
        Top = 8
        Width = 441
        Height = 473
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          
            'Imagine a square wheel standing on one corner.  We would like to' +
            ' roll'
          
            'it 1/8 of a turn up a small hill in such a way that the center o' +
            'f the wheel '
          
            'remains at the same height above the floor.  The shape of such a' +
            ' '
          
            'curve is half of an inverted catenary. And of course the next 1/' +
            '8 turn '
          
            'must roll down the hill over the descending version of the same ' +
            'shape, '
          'the other half of the catenary.'
          ''
          
            'Say each side of the square has length L.  The height of the cat' +
            'enary'
          
            'when the square has rotated 1/8 turn must be the difference betw' +
            'een '
          
            '.5L and the distance from the center to the corner [sqrt(2)L-.5L' +
            '].  In our '
          
            'case, L=50 and the height of the caternary must be  H =sqrt(2)*5' +
            '0 - 25 = '
          
            '10.355 units. Also note that as the edge rolls over the catenary' +
            ', every '
          
            'point on the edge must come in contact with the curve without sl' +
            'ipping '
          
            'as it rotates from one cusp to the next. This implies that the a' +
            'rc length of '
          'the catenary = L =50 or, for 1/2 of the catenary, S = .5L = 25.'
          ''
          
            'These two parameters, the height, H,  and the arc length, S, are' +
            ' enough'
          
            'to define a unique catenary curve.  However I could find no equa' +
            'tion for '
          
            'the curve using these two values. Instead,the  commonly availabl' +
            'e '
          
            'equation defines the height,Y, interms of of two other parameter' +
            's:  the'
          
            'width X, and a parameter called the C parameter which indirectly' +
            ' '
          
            'controls the height.   The equation is  for our case, where we w' +
            'ant the Y'
          
            'to equal the height at the end of the curve is Y=C cosh(X/C)- C ' +
            'where'
          'cosh is the hyperbolic cosine function.'
          ''
          
            'This equation applies to the upright form of the curve, but the ' +
            'desired'
          
            'values are the same whether the curve is upright or inverted, th' +
            'e only'
          
            'difference being whether the desired height is reached at the en' +
            'ds or in'
          
            'the center of the catenary.  The arc length,S, over the interval' +
            ' 0 to A is'
          
            'defined by S=C sinh(A/C). We'#39'll apply the equations to the right' +
            ' half of'
          
            'the upright curve with the origin at the low point and the end o' +
            'f the curve'
          'at A, where the height is H. So we have two equations with two'
          
            'unknowns (A and C) in terms of two knowns (H and S) namely:  H =' +
            ' '
          'C*(cosh(A/C)-1) and S = C*sinh(A/C).'
          ''
          
            'These simple equations have no closed solution that I could find' +
            '.  I'
          
            'initially resorted to "trial and error" as a way to get the job ' +
            'done (the top'
          
            'button a right).  I just plugged in trial values for A and C in ' +
            'the boxes at'
          
            'left until the equations "C cosh(A/C) - H" and "C Sinh(A/C) - S"' +
            ' were'
          'both near zero.'
          ''
          
            'Since then, I'#39've implemented a Newton'#39's root finding algorithm t' +
            'o find '
          
            '"A" and "C" values which minimize the differences between equati' +
            'on '
          'results and the target Height and Arc Length values.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Calcbtn: TButton
        Left = 512
        Top = 240
        Width = 241
        Height = 25
        Caption = 'Calculate trial H  and S using given A and C'
        TabOrder = 1
        OnClick = CalcbtnClick
      end
      object Button1: TButton
        Left = 512
        Top = 328
        Width = 241
        Height = 25
        Caption = 'Solve using Newton'#39's method'
        TabOrder = 2
        OnClick = NewtonsBtnClick
      end
      object Memo3: TMemo
        Left = 488
        Top = 192
        Width = 281
        Height = 49
        Lines.Strings = (
          'Play with finding A and C values which produce target '
          'catenary width and arc length by changing values and '
          'clicking the button below. ')
        TabOrder = 3
      end
      object Memo4: TMemo
        Left = 488
        Top = 280
        Width = 281
        Height = 49
        Lines.Strings = (
          'Alternatively, let the program use Newton'#39's root finding '
          'method by entering inital A and C guesses and '
          'clicking the button below. ')
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object GroupBox1: TGroupBox
        Left = 512
        Top = 8
        Width = 241
        Height = 81
        Caption = 'Target valuess'
        TabOrder = 5
        object Label4: TLabel
          Left = 25
          Top = 43
          Width = 102
          Height = 16
          Caption = '1/2  arc length (S)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 69
          Top = 20
          Width = 60
          Height = 16
          Caption = 'Height (H)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object ArcEdt: TEdit
          Left = 136
          Top = 43
          Width = 73
          Height = 21
          TabOrder = 0
          Text = '25'
        end
        object HEdt: TEdit
          Left = 136
          Top = 20
          Width = 73
          Height = 21
          TabOrder = 1
          Text = '10.355'
        end
      end
      object GroupBox2: TGroupBox
        Left = 512
        Top = 96
        Width = 241
        Height = 81
        Caption = 'Independent variables (initial guess)'
        TabOrder = 6
        object Label1: TLabel
          Left = 52
          Top = 19
          Width = 77
          Height = 16
          Caption = 'Half width (A)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 32
          Top = 44
          Width = 97
          Height = 16
          Caption = ' C parameter (C)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object RangeEdt: TEdit
          Left = 136
          Top = 19
          Width = 65
          Height = 21
          TabOrder = 0
          Text = '20'
        end
        object CEdt: TEdit
          Left = 136
          Top = 44
          Width = 65
          Height = 21
          TabOrder = 1
          Text = '20'
        end
      end
      object Memo5: TMemo
        Left = 496
        Top = 368
        Width = 273
        Height = 97
        Lines.Strings = (
          'Finally, thanks to Hans Klein, here is a analytical '
          'solution based on manipulation of the original '
          'equations to conclude that a=c*ln((s+h)/(s-h)) and '
          'c=(s^2-h^2)/(2h).'
          '')
        ScrollBars = ssVertical
        TabOrder = 7
      end
      object KleinsBtn: TButton
        Left = 512
        Top = 465
        Width = 241
        Height = 25
        Caption = 'Find A and C directly from target values '
        TabOrder = 8
        OnClick = KleinsBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 792
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
