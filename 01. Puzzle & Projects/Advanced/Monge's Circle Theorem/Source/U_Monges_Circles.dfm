object Form1: TForm1
  Left = 237
  Top = 99
  Width = 953
  Height = 674
  Caption = 'Monge'#39's Circle Theorem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object PaintBox1: TPaintBox
    Left = 344
    Top = 16
    Width = 569
    Height = 569
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    OnPaint = PaintBox1Paint
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 616
    Width = 937
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 305
    Height = 521
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Given three circles of differing sizes'
      'none of which lies completely inside'
      'another, the common external tangent'
      'lines for each pair of circles lie on a'
      'straight line.'
      ''
      'To illustrate, there are two methods for '
      'creating the circles;'
      ''
      '1. Click the "Make random circles" button '
      'below or'
      '2. Click and drag any point in'
      'the field at left which is not inside an'
      'existing circle and drag to define the '
      'radius of each circle.'
      ''
      'Tangent lines for each pair of circles will '
      'be drawn automatically.  When all three '
      'circles have been defined the tangent line '
      'pairs will be extended and the intersection '
      'points connected (the red line);'
      ''
      'Click and drag the center of any circle '
      'to move it.  Click and drag on the '
      'circumference to change a'
      'circle size.')
    ParentFont = False
    TabOrder = 1
  end
  object ResetBtn: TButton
    Left = 240
    Top = 560
    Width = 91
    Height = 25
    Caption = 'Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = ResetBtnClick
  end
  object MakeRandBtn: TButton
    Left = 24
    Top = 560
    Width = 193
    Height = 25
    Caption = 'Make random circles'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = MakeRandBtnClick
  end
end
