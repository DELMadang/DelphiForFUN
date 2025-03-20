object bigints: Tbigints
  Left = 231
  Top = 206
  Width = 696
  Height = 480
  Caption = 'Big integers Division test'
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
  object Label1: TLabel
    Left = 512
    Top = 16
    Width = 116
    Height = 13
    Caption = 'Base power of 10 (1 to9)'
  end
  object Long1Edt: TEdit
    Left = 32
    Top = 32
    Width = 401
    Height = 21
    TabOrder = 0
    Text = '357977'
  end
  object Long2Edt: TEdit
    Left = 32
    Top = 112
    Width = 401
    Height = 21
    TabOrder = 1
    Text = '12'
  end
  object DivideBtn: TButton
    Left = 32
    Top = 72
    Width = 97
    Height = 25
    Caption = 'Old:    X div Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = DivideBtnClick
  end
  object Memo1: TMemo
    Left = 24
    Top = 160
    Width = 625
    Height = 209
    Color = 14548991
    Lines.Strings = (
      
        'My original Big Integer unit was written several years ago.  Of ' +
        'the 4 basic operations, division is the most complex by far and ' +
        'the '
      
        'orignal version was not very fast.   When large numbers were div' +
        'ided by small numbers, the successive subtraction technique '
      'used resulted in long execution '
      'times.'
      ''
      
        'I recently rewote the divide operation using algorithms defined ' +
        'by Per Brinch Hansen in his paper, "Multiple-length Division '
      
        'Revisited: a Tour of the Minefield", in Software - Practice and ' +
        'Experience, Vol24(6), June 1994.  It is an effiicent implementat' +
        'ion '
      
        'of the operations we use in performing long division with pencil' +
        ' and paper and seems to be  readily available on the Internet.  ' +
        'It'#39's '
      
        'amazing how hard the program (and the programmer) must work to c' +
        'reate something that any 4th grader can do. '
      ''
      
        'This program compares results and timings for old and new versio' +
        'ns.  Big integers are represented internally as an array or list' +
        ' of '
      
        'smaller pieces in some particular number base..  In the new vers' +
        'ion, the base, the max size of each "chunk",   is powers of 10, '
      
        'from 1 to 6  (10 to 1,000,000).   Warning -  large base values a' +
        'nd small divisors take a long time  to complete using the old '
      'divide method')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object Button1: TButton
    Left = 144
    Top = 72
    Width = 97
    Height = 25
    Caption = 'New:    X div Y '
    TabOrder = 4
    OnClick = Button1Click
  end
  object SpinEdit1: TSpinEdit
    Left = 512
    Top = 32
    Width = 49
    Height = 22
    MaxValue = 6
    MinValue = 1
    TabOrder = 5
    Value = 1
    OnChange = SpinEdit1Change
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2001-2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
end
