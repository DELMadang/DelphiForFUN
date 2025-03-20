object Form1: TForm1
  Left = 304
  Top = 136
  Width = 870
  Height = 500
  Caption = 'Where does the ray intersect the triangle?'
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
  object Label1: TLabel
    Left = 80
    Top = 72
    Width = 38
    Height = 13
    Caption = 'Side AB'
  end
  object Label2: TLabel
    Left = 80
    Top = 104
    Width = 38
    Height = 13
    Caption = 'Side BC'
  end
  object Label3: TLabel
    Left = 80
    Top = 160
    Width = 28
    Height = 13
    Caption = 'Theta'
  end
  object Image1: TImage
    Left = 400
    Top = 64
    Width = 401
    Height = 369
  end
  object Label4: TLabel
    Left = 56
    Top = 40
    Width = 175
    Height = 13
    Caption = 'Type or click arrows to change setup'
  end
  object ABLength: TSpinEdit
    Left = 128
    Top = 64
    Width = 49
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 0
    Value = 100
    OnChange = ValueChange
    OnClick = ValueChange
  end
  object BCLength: TSpinEdit
    Left = 128
    Top = 96
    Width = 49
    Height = 22
    MaxValue = 200
    MinValue = 0
    TabOrder = 1
    Value = 100
    OnChange = ValueChange
    OnClick = ValueChange
  end
  object ThetaDegrees: TSpinEdit
    Left = 128
    Top = 152
    Width = 49
    Height = 22
    MaxValue = 359
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = ValueChange
    OnClick = ValueChange
  end
  object Memo1: TMemo
    Left = 24
    Top = 208
    Width = 297
    Height = 225
    Lines.Strings = (
      'Today'#39's problem is to determine which side or sides of'
      'a given rectangle are intersectected by a ray from the'
      'center at a given angle.'
      ''
      'Assume that the center of rectangle ABCD is at'
      'coordinates (0,0) and let'
      'S1=length(AB)/2  and'
      'S2=length(BC)/2'
      ''
      'Then the equations for the sides can be defined as'
      'follows:'
      'For AB: Y=S2,'
      'for BC: X=S1,'
      'for CD: Y=-S2, and'
      'for DA: X=-S1'
      ''
      'The intersection coordinates for the ray line can be'
      'defined as X=R*cos(Theta) and Y=R*sin(Theta) where R'
      'is the distance from the center  to the point of intersection.'
      ''
      'Let'#39's derive the intersection point for the ray and side AB'
      
        '----------------------------------------------------------------' +
        '---------------------'
      'Y=S2 and because Y=R*sin(theta), we can define R as'
      'R=S2/sin(theta).'
      'Substituting for R in the equation for X we have'
      ' X=(S2/sin(theta))*cos(theta)) or by rearranging terms'
      'X=S2*(cos(theta)/sin(theta)).'
      'Cos(theta)/sin(theta) it the definition of cotangent(thate) so'
      'X=S2*cotan(theta)'
      ''
      'The above equations do not take into account that we'
      'are checking line segments, not lines of unlimited length, '
      'so'
      'we need a few extra checks to make sure that the'
      'intersection point is within the bounds of AB (Y is between'
      '-S1 and +S1) and that we are not talking about the'
      '"backend" of the ray (angle must be between -90 (or 270) '
      'and +90 degrees. And we need to detect and not try to '
      'evaluate when the ray happens to be parallel to AB.  It will '
      'never intersect and the cotangent function is undefined '
      '(because the divisor, sin(theta), has value 0.'
      
        '----------------------------------------------------------------' +
        '------------'
      ''
      'Similar analyses can be applied to the other three sides to'
      'determine the point or points of intersection for the ray.'
      'It will intersect 2 adjacent sides if it happens to pass'
      'exactly through a corner of the rectangle.'
      ''
      
        '----------------------------------------------------------------' +
        '----------------'
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 453
    Width = 862
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
end
