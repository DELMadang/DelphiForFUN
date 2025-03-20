object Form1: TForm1
  Left = 192
  Top = 107
  Width = 800
  Height = 600
  Caption = 'Integer vs. Floating Point Rotations'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PaintBox1: TPaintBox
    Left = 32
    Top = 232
    Width = 313
    Height = 289
  end
  object PaintBox2: TPaintBox
    Left = 448
    Top = 232
    Width = 313
    Height = 289
  end
  object Label1: TLabel
    Left = 648
    Top = 26
    Width = 38
    Height = 13
    Caption = 'degrees'
  end
  object Label2: TLabel
    Left = 744
    Top = 26
    Width = 24
    Height = 13
    Caption = 'times'
  end
  object Label3: TLabel
    Left = 40
    Top = 176
    Width = 175
    Height = 24
    Caption = 'Integer processing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 40
    Top = 208
    Width = 297
    Height = 13
    Caption = 
      'Draw a figure and rotate it (integer coordinates introduce error' +
      's)'
  end
  object Label5: TLabel
    Left = 440
    Top = 176
    Width = 238
    Height = 24
    Caption = 'Floating Point processing'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 440
    Top = 208
    Width = 331
    Height = 13
    Caption = 
      'Draw a figure and rotate it (using "exact" coordinates eliminate' +
      's errors)'
  end
  object ClearAllBtn: TBitBtn
    Left = 444
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Clear all'
    TabOrder = 0
    OnClick = ClearAllBtnClick
  end
  object RotateBtn: TBitBtn
    Left = 436
    Top = 20
    Width = 75
    Height = 25
    Caption = 'Rotate'
    TabOrder = 1
    OnClick = RotateBtnClick
  end
  object Degrees: TSpinEdit
    Left = 600
    Top = 21
    Width = 45
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 10
  end
  object ClearRoateBtn: TBitBtn
    Left = 440
    Top = 64
    Width = 159
    Height = 25
    Caption = 'Clear rotated image'
    TabOrder = 3
    OnClick = ClearRoateBtnClick
  end
  object ShowOriginalBox: TCheckBox
    Left = 624
    Top = 64
    Width = 129
    Height = 17
    Caption = 'Show original image'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = ShowOriginalBoxClick
  end
  object CopyLeftBtn: TBitBtn
    Left = 360
    Top = 272
    Width = 75
    Height = 49
    Caption = 'Copy'
    TabOrder = 5
    OnClick = CopyLeftBtnClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF3333333333333744333333333333F773333333333337
      44473333333333F777F3333333333744444333333333F7733733333333374444
      4433333333F77333733333333744444447333333F7733337F333333744444444
      433333F77333333733333744444444443333377FFFFFFF7FFFFF999999999999
      9999733777777777777333CCCCCCCCCC33333773FF333373F3333333CCCCCCCC
      C333333773FF3337F333333333CCCCCCC33333333773FF373F3333333333CCCC
      CC333333333773FF73F33333333333CCCCC3333333333773F7F3333333333333
      CCC333333333333777FF33333333333333CC3333333333333773}
    NumGlyphs = 2
  end
  object CopyRightBtn: TBitBtn
    Left = 360
    Top = 352
    Width = 75
    Height = 49
    Caption = 'Copy'
    TabOrder = 6
    OnClick = CopyRightBtnClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333FF3333333333333447333333333333377FFF33333333333744473333333
      333337773FF3333333333444447333333333373F773FF3333333334444447333
      33333373F3773FF3333333744444447333333337F333773FF333333444444444
      733333373F3333773FF333334444444444733FFF7FFFFFFF77FF999999999999
      999977777777777733773333CCCCCCCCCC3333337333333F7733333CCCCCCCCC
      33333337F3333F773333333CCCCCCC3333333337333F7733333333CCCCCC3333
      333333733F77333333333CCCCC333333333337FF7733333333333CCC33333333
      33333777333333333333CC333333333333337733333333333333}
    Layout = blGlyphRight
    NumGlyphs = 2
  end
  object NbrTurns: TSpinEdit
    Left = 696
    Top = 21
    Width = 41
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 36
  end
  object Memo1: TMemo
    Left = 24
    Top = 8
    Width = 393
    Height = 161
    Color = 14548991
    Lines.Strings = (
      
        'Drawing a figure with integer coordinates works fine for most pu' +
        'rposes.  But if it is '
      
        'rotated, the new coordinates will generally not be integers and ' +
        'errors are '
      'introduced.'
      ''
      
        'A viewer recently sent a version of this program illustrating he' +
        ' problem.  I modified '
      
        'the code, converting the drawing/rotating code into two separate' +
        ' objects.  '
      
        'TIntegerRotate stores coordinates in integer form, and TRealRota' +
        'te uses '
      
        '"extended" floating point format and only converts location valu' +
        'es to integer '
      'when drawing on the screen.'
      ''
      'The difference can be seen below.')
    TabOrder = 8
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
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
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 9
    OnClick = StaticText1Click
  end
end
