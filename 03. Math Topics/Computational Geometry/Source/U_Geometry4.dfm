object Form1: TForm1
  Left = 183
  Top = 77
  Width = 996
  Height = 700
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 'A Little Computational Geometry  V4.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 552
    Top = 48
    Width = 401
    Height = 409
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object Label2: TLabel
    Left = 547
    Top = 16
    Width = 3
    Height = 16
  end
  object ResultLbl: TLabel
    Left = 552
    Top = 480
    Width = 401
    Height = 89
    AutoSize = False
    Caption = 'Results: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object AreaLbl: TLabel
    Left = 704
    Top = 16
    Width = 31
    Height = 16
    Caption = 'Area:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Aeial'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 32
    Top = 32
    Width = 505
    Height = 577
    ActivePage = PerpSheet
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 0
    OnChange = ClearBtnClick
    object IntersectSheet: TTabSheet
      Caption = '1. Intersecting lines'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 16
        Top = 8
        Width = 353
        Height = 209
        Color = 14548991
        Lines.Strings = (
          'Click define start drawing a line, click '
          'again to end the line.  Repeat to draw a '
          'second line. '
          ''
          'End points alignment may be aligned '
          'on 5 or 10 pixel boundaries by using the '
          '"Point alignment" box.'
          ' '
          'Program will report whether lines '
          'intersect.  (Easy for humans, not so '
          'easy for programs.)'
          '')
        TabOrder = 0
      end
      object AlignGrpIL: TRadioGroup
        Left = 32
        Top = 240
        Width = 185
        Height = 81
        Caption = 'Point alignment'
        ItemIndex = 0
        Items.Strings = (
          '1 pixel'
          '5 pixel boundaries'
          '10 pixel boundaries')
        TabOrder = 1
        OnClick = AlignGrpClick
      end
    end
    object PerpSheet: TTabSheet
      Caption = '2. Perpendicular from point to line'
      ImageIndex = 2
      object Memo2: TMemo
        Left = 24
        Top = 16
        Width = 305
        Height = 145
        Color = 14548991
        Lines.Strings = (
          'Click to start drawing a baseline, click '
          'again to end the line,   then click '
          'at some points not on the line.   '
          ''
          'Program will draw lines from the '
          'clicked points and  perpendicular to '
          'the original base  line. '
          ' ')
        TabOrder = 0
      end
    end
    object AngleSheet: TTabSheet
      Caption = '3. Angle from point on line for distance'
      ImageIndex = 2
      object Label1: TLabel
        Left = 16
        Top = 272
        Width = 63
        Height = 16
        Caption = 'Line length'
      end
      object Label3: TLabel
        Left = 16
        Top = 304
        Width = 117
        Height = 16
        Caption = 'Line angle (degrees)'
      end
      object DistEdt: TSpinEdit
        Left = 152
        Top = 272
        Width = 57
        Height = 26
        MaxValue = 200
        MinValue = 0
        TabOrder = 0
        Value = 25
      end
      object Memo3: TMemo
        Left = 16
        Top = 0
        Width = 289
        Height = 217
        Color = 14548991
        Lines.Strings = (
          'Click to define the start point of a  '
          'baseline, cliick again to end the line.  Then '
          'click any location on or near the line.  '
          ''
          'This procedure generates a line of the '
          'specified length at the  specified angle  to '
          'the reference line and on the specified  '
          'side.  '
          ''
          'The "side" of the line, right or left is as '
          'viewed by a observer walking the reference '
          'line from the initial point. ')
        TabOrder = 1
      end
      object RightLeftBox: TRadioGroup
        Left = 16
        Top = 224
        Width = 249
        Height = 41
        Caption = 'Which side of line?'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Right'
          'Left')
        TabOrder = 2
      end
      object AngleEdt: TSpinEdit
        Left = 152
        Top = 304
        Width = 57
        Height = 26
        MaxValue = 180
        MinValue = 0
        TabOrder = 3
        Value = 45
      end
      object AdjustBox: TCheckBox
        Left = 24
        Top = 336
        Width = 201
        Height = 17
        Caption = 'Adjust 1st point to lie on liine'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object PointInPolySheet: TTabSheet
      Caption = '4. Point In Polygon'
      ImageIndex = 3
      object Memo4: TMemo
        Left = 8
        Top = 24
        Width = 361
        Height = 257
        Color = 14548991
        Lines.Strings = (
          'Click to start a polygon and click at each '
          'corner.  Polygon will be automatically '
          'closed when you click near the starting '
          'point.'
          ''
          'Then click additional points and displayed '
          'message will tell you if you are inside the '
          'polygon, outside the polygon, on a vertex, '
          'or on the border but not on a vertex. '
          ' '
          'Algorithm works by extending a line from '
          'the point to infinity and counting the number '
          'of polygon edges that are intersected.  '
          'Odd count =inside, even count = outside! ')
        TabOrder = 0
      end
      object AlignGrp: TRadioGroup
        Left = 16
        Top = 328
        Width = 185
        Height = 81
        Caption = 'Point alignment'
        ItemIndex = 0
        Items.Strings = (
          '1 pixel'
          '5 pixel boundaries'
          '10 pixel boundaries')
        TabOrder = 1
        OnClick = AlignGrpClick
      end
    end
    object InflateSheet: TTabSheet
      Caption = '5. Inflate Polygon'
      ImageIndex = 4
      object Label4: TLabel
        Left = 48
        Top = 390
        Width = 65
        Height = 20
        Caption = 'Inflate by'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 168
        Top = 390
        Width = 39
        Height = 20
        Caption = 'pixels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Memo5: TMemo
        Left = 8
        Top = 8
        Width = 281
        Height = 361
        Color = 14548991
        Lines.Strings = (
          'Click the image area at right  to start a '
          'polygon and click at each corner.   Polygon '
          'will be automatically closed when you click '
          'near the starting point.'
          ''
          'When the polygon is closed, it will be'
          'inflated (or deflated) by the pixel value'
          'given below. Negative values will reduce the'
          'polygon size. The value given is the '
          'perpendular pixel distance from each existing '
          'edge to the new edge.  Clicking the up/down '
          'arrows on the value below will redraw the '
          'polygon inflated by the new value.'
          ''
          'Algorithm works by finding points at the '
          'perpendicular distance from each end of each '
          'edge.   This defines slope and intercept of a '
          'new edge line (but probably not intersecting).  '
          'We then extend each adjacent pair of lines if '
          'necessay to find the intersection point which '
          'defines a new vertex for the inflated polygon.   ')
        TabOrder = 0
      end
      object InflateBy: TSpinEdit
        Left = 120
        Top = 387
        Width = 41
        Height = 26
        EditorEnabled = False
        MaxValue = 50
        MinValue = -50
        TabOrder = 1
        Value = 10
        OnChange = InflateByChange
      end
    end
    object LineManip: TTabSheet
      Caption = '6. Line Translate/Rotate'
      ImageIndex = 6
      object Label6: TLabel
        Left = 24
        Top = 208
        Width = 134
        Height = 16
        Caption = 'Translate start point to:'
      end
      object Label7: TLabel
        Left = 24
        Top = 232
        Width = 16
        Height = 24
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 104
        Top = 232
        Width = 14
        Height = 24
        Caption = 'Y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 24
        Top = 280
        Width = 155
        Height = 16
        Caption = 'Rotate about start point to:'
      end
      object Label10: TLabel
        Left = 112
        Top = 304
        Width = 46
        Height = 16
        Caption = 'degrees'
      end
      object Memo6: TMemo
        Left = 56
        Top = 8
        Width = 289
        Height = 185
        Color = 14548991
        Lines.Strings = (
          'Click to start a line.  Move the mouse and click '
          'again to end the line.  '
          ''
          'Buttons below wil translate or rotate the line,'
          ''
          'These routines to translate and rotates lines are '
          'required for the Circle-Circle intersection  '
          'operations.')
        TabOrder = 0
      end
      object SpinEdit2: TSpinEdit
        Left = 120
        Top = 232
        Width = 49
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 1
        Value = 100
      end
      object TranslateBtn: TButton
        Left = 192
        Top = 232
        Width = 65
        Height = 25
        Caption = 'Go'
        TabOrder = 2
        OnClick = TranslateBtnClick
      end
      object RotateBtn: TButton
        Left = 192
        Top = 304
        Width = 65
        Height = 25
        Caption = 'Go'
        TabOrder = 3
        OnClick = RotateBtnClick
      end
      object SpinEdit1: TSpinEdit
        Left = 48
        Top = 232
        Width = 49
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 100
      end
      object SpinEdit3: TSpinEdit
        Left = 56
        Top = 304
        Width = 49
        Height = 26
        MaxValue = 360
        MinValue = -360
        TabOrder = 5
        Value = 45
      end
      object Memo7: TMemo
        Left = 8
        Top = 352
        Width = 281
        Height = 97
        Lines.Strings = (
          '')
        TabOrder = 6
      end
    end
    object CircleCircleIntersectSheet: TTabSheet
      Caption = '7. Circle-Circle Intersection '
      ImageIndex = 7
      object Memo9: TMemo
        Left = 16
        Top = 16
        Width = 433
        Height = 185
        Color = 14548991
        Lines.Strings = (
          
            'Click the button below to generate 2 random circles and draw lin' +
            'es from '
          
            'center of the fiirst circle to the interesction points with the ' +
            'second (if they '
          
            'intersect).   Circle-Circle intersection operations are  require' +
            'd when  '
          'calculating tangent lines for circles.'
          ''
          
            'The algorithm requires translating and rotating the line connect' +
            'ing the '
          
            'cirlce centers to (0,0) origin and 0 degree angle.  Realtively s' +
            'imple '
          
            'equations then allow the intersection point coordinates to be ca' +
            'lculated,  '
          
            'after which the lines from the origin to the intersection points' +
            ' can be '
          
            'rotated and translated back to the original origin and orientati' +
            'on.  ')
        TabOrder = 0
      end
      object CCIntersectBtn: TButton
        Left = 16
        Top = 224
        Width = 225
        Height = 25
        Caption = 'Generate && test 2 random circles '
        TabOrder = 1
        OnClick = CCIntersectBtnClick
      end
      object Memo10: TMemo
        Left = 8
        Top = 272
        Width = 449
        Height = 201
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
    object TangentPC: TTabSheet
      Caption = '8. Point-Circle Tangent'
      ImageIndex = 5
      object Memo8: TMemo
        Left = 24
        Top = 16
        Width = 401
        Height = 321
        Color = 14548991
        Lines.Strings = (
          'Click the button below to draw a random circle and a random '
          'external point;'
          ''
          'The algorithm is'
          ''
          '1. Define the line,L, from the point, P, to the circle center.'
          '2.  Find the midpoint, M, of line L}'
          
            '3.  Define the circle, C1, centered on M through the endpoints o' +
            'f L.'
          
            '4,  Define the circle, C2, to be the original circle with center' +
            ' a C.'
          
            '5.  Find the intersection points of C1 and C2, call them IP1 and' +
            ' '
          'IP2'
          '6   Define the tangent lines  from P through IP1 and IP2'
          ''
          
            'Notice that angles (C,I P1,P) and (C,IP2,P)  are inscribed angle' +
            's of '
          
            'C2 and are therefore right angles. This  makes points IP1 and IP' +
            '2 '
          'points of tangency by definition.'
          '')
        TabOrder = 0
      end
      object PointTanBtn: TButton
        Left = 32
        Top = 392
        Width = 369
        Height = 25
        Caption = 'Generate tangent lines for random circle and external point'
        TabOrder = 1
        OnClick = PointTanBtnClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = '9. Circle - Circle Tangent Lines'
      ImageIndex = 8
      object Memo11: TMemo
        Left = 24
        Top = 16
        Width = 401
        Height = 305
        Color = 14548991
        Lines.Strings = (
          
            'Click the button below to draw 2 random circles for which the th' +
            'e 2 '
          'exterior lines tangent to both circles will be calculated.'
          ''
          'The algorithm is'
          ''
          
            '1. Name the given circles C1 and C2 with radii R1 and R2 such th' +
            'at '
          'R1>=R2.'
          
            '2. Define a circle , C3, centered on C1 with a radius equal R1-R' +
            '2. '
          '(Yellow on the diagram)'
          
            '3..Use the Point-Circle algorithm presented on another sheet to ' +
            'find'
          
            'the lines, L1 and L2, through the center of C2 and and tangent t' +
            'o '
          'C3. (Also drawn in yellow.)'
          '3. Define the lines, PL1 and PL2, through the center of C2 and '
          'perpendicular to L1 and L2.  (Green lines.)'
          '4. Translate L1 a distance R2 along PL1 and L2 and distance R2 '
          
            'along PL2 to create the two exteroir tangent lines.  (Blue lines' +
            '.)'
          ''
          '')
        TabOrder = 0
      end
      object CircCircTanBtn: TButton
        Left = 32
        Top = 344
        Width = 385
        Height = 25
        Caption = 'Create 2 random circles and  their exterior tangent lines. '
        TabOrder = 1
        OnClick = CircCircTanBtnClick
      end
    end
  end
  object ClearBtn: TButton
    Left = 544
    Top = 584
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 1
    OnClick = ClearBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 635
    Width = 978
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2002 - 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
end
