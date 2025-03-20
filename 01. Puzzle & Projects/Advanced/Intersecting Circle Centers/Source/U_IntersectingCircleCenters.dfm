object Form1: TForm1
  Left = 390
  Top = 159
  AutoScroll = False
  Caption = 'Find intersecting circle centers given intersection area'
  ClientHeight = 673
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 651
    Width = 820
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 651
    Align = alClient
    TabOrder = 1
    object Image1: TImage
      Left = 465
      Top = 506
      Width = 292
      Height = 144
    end
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 818
      Height = 213
      Align = alTop
      Color = 14483455
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'I received this email a few weeks ago:'
        
          '================================================================' +
          '==='
        'Intersecting circle coordinates'
        'From: michael.XXXXXX@XXXXXXXXX.com'
        'ContactRequested  - Wednesday, August 29, 2012  04:47 PM'
        ''
        'Hello and thank you for the great webpage!'
        
          'Question: Is there a formula to determine the X,Y coordinates of' +
          ' two intersecting circles when you know:'
        
          '1) the area of circle A (or radius)     2) the area of circle B ' +
          '(or radius)     3) the area of the intersection'
        'Assume: 1) center of circle A = (0,0)     '
        '        2) center of circle B = (x1,0) (i.e. on same plane)'
        
          '        3) 0 < radius(A) < x1 (meaning circle B is not inside ci' +
          'rcle A)'
        'Thanks for your consideration!'
        
          '================================================================' +
          '===')
      ParentFont = False
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 1
      Top = 214
      Width = 818
      Height = 275
      Align = alTop
      Color = 16511165
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'In researching my reply, I found this relevant formula for the a' +
          'rea of intersection when the two radii and the distance between'
        
          'circle centers is known.  It is equation #14 on the Wolfram page' +
          ' at http://mathworld.wolfram.com/Circle-'
        'CircleIntersection.html.'
        ''
        
          'A=area of intersection, r1, R2 = radii of the two circles, d= th' +
          'e distance between the two circle centers'
        ''
        
          'A= sqr(r1)*arccos((sqr(d)+(+sqr(r1)-sqr(R2))/(2*d*r1)) + sqr(R2)' +
          '*arccos((sqr(d)+sqr(R2)-sqr(r1))/(2*d*R2))'
        '   - 0.5*sqrt((-d+r1+R2)*(d+r1-R2)*(d-r1+R2)*(d+r1+R2))'
        ''
        
          'It doesn'#39't seem feasible to directly solve the "Area" equation f' +
          'or d, but given an Area and any 2 of the other 3 variables, we'
        
          'can solve for the other by iterating on that variable and findin' +
          'g the minimum error between calculated and given areas. '
        ''
        
          'Enter any 3 of the 4 variables and click the radio button for th' +
          'e 4th  to compute its value.  If the missing value is not "Area"' +
          ','
        
          'it is incremented from the lowest legal value until the calculat' +
          'ed area matches the given area.  An animation of interim results'
        
          'are displayed, if the animation runs too slowly, increase the re' +
          'solution or uncheck the "Animation"  checkbox..'
        '')
      ParentFont = False
      TabOrder = 1
    end
    object R1Btn: TRadioButton
      Left = 16
      Top = 512
      Width = 113
      Height = 17
      Caption = 'Radius 1'
      TabOrder = 2
      OnClick = RadioBtnClick
    end
    object DistBtn: TRadioButton
      Left = 144
      Top = 512
      Width = 169
      Height = 17
      Caption = 'Distance between centers'
      TabOrder = 3
      OnClick = RadioBtnClick
    end
    object AreaBtn: TRadioButton
      Left = 152
      Top = 576
      Width = 113
      Height = 17
      Caption = 'Area'
      TabOrder = 4
      OnClick = RadioBtnClick
    end
    object R2Btn: TRadioButton
      Left = 16
      Top = 576
      Width = 113
      Height = 17
      Caption = 'Radius 2'
      TabOrder = 5
      OnClick = RadioBtnClick
    end
    object AreaEdt: TEdit
      Left = 168
      Top = 592
      Width = 100
      Height = 24
      TabOrder = 6
      Text = '.522'
    end
    object DistEdt: TEdit
      Left = 160
      Top = 528
      Width = 89
      Height = 24
      TabOrder = 7
      Text = '2.5'
    end
    object R1Edt: TEdit
      Left = 32
      Top = 528
      Width = 81
      Height = 24
      TabOrder = 8
      Text = '2.0'
    end
    object R2Edt: TEdit
      Left = 32
      Top = 592
      Width = 81
      Height = 24
      TabOrder = 9
      Text = '1.0'
    end
    object ResolutionGrp: TRadioGroup
      Left = 344
      Top = 520
      Width = 89
      Height = 89
      Caption = 'Resolution'
      ItemIndex = 2
      Items.Strings = (
        '0.1'
        '0.01'
        '0.001'
        '0.0001')
      TabOrder = 10
      OnClick = ResolutionGrpClick
    end
    object AnimateBox: TCheckBox
      Left = 344
      Top = 616
      Width = 97
      Height = 17
      Caption = 'Animate'
      Checked = True
      State = cbChecked
      TabOrder = 11
    end
  end
end
