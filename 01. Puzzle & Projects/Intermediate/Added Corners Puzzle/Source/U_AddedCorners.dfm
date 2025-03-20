object Form1: TForm1
  Left = 122
  Top = 99
  Width = 857
  Height = 588
  Caption = 'Added Corners'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 120
  TextHeight = 16
  object Shape2: TShape
    Left = 601
    Top = 69
    Width = 80
    Height = 80
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape6: TShape
    Left = 601
    Top = 286
    Width = 80
    Height = 80
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape8: TShape
    Left = 492
    Top = 177
    Width = 80
    Height = 80
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape4: TShape
    Left = 709
    Top = 177
    Width = 80
    Height = 80
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape1: TShape
    Left = 492
    Top = 69
    Width = 80
    Height = 80
    Shape = stCircle
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape3: TShape
    Left = 709
    Top = 69
    Width = 80
    Height = 80
    Shape = stCircle
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape7: TShape
    Left = 492
    Top = 286
    Width = 80
    Height = 80
    Shape = stCircle
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Shape5: TShape
    Left = 709
    Top = 286
    Width = 80
    Height = 80
    Shape = stCircle
    OnDragDrop = Shape1DragDrop
    OnDragOver = Shape1DragOver
  end
  object Label9: TLabel
    Left = 404
    Top = 59
    Width = 30
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = '1'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label10: TLabel
    Left = 404
    Top = 98
    Width = 30
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = '2'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label11: TLabel
    Left = 404
    Top = 138
    Width = 30
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = '3'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label12: TLabel
    Left = 404
    Top = 177
    Width = 30
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = '4'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label13: TLabel
    Left = 404
    Top = 217
    Width = 30
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = '5'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label14: TLabel
    Left = 404
    Top = 256
    Width = 30
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = '6'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label15: TLabel
    Left = 404
    Top = 295
    Width = 30
    Height = 30
    Alignment = taCenter
    AutoSize = False
    Caption = '7'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object Label16: TLabel
    Left = 404
    Top = 335
    Width = 30
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Caption = '8'
    Color = clWhite
    DragMode = dmAutomatic
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    OnDragDrop = Label9DragDrop
    OnDragOver = Label9DragOver
  end
  object ResetBtn: TButton
    Left = 601
    Top = 423
    Width = 92
    Height = 31
    Caption = 'Reset'
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object Memo1: TMemo
    Left = 30
    Top = 49
    Width = 315
    Height = 408
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'The object of Added Corners is to drag al '
      'of the number blocks to the blank squares '
      'and circles in such a way the the sum of '
      'the numbers in each square is the sum of '
      'the two circles which are next to it.'
      ''
      'To play, drag the numbers one at a time to '
      'the circles and squares.  You can drag '
      'umbers from one figure to another as '
      'often as necessary.    '
      ''
      'If you haven'#39't found the solution after an '
      'hour or so, you can download  '
      ''
      ''
      'which has "Added Corners" as one of the '
      'sample problems it knows how to solve.'
      ''
      ''
      'Adapted from :The Giant Book of Mensa '
      'Mind Challenges, (Stirling Publications, '
      '2003) '
      '')
    ParentFont = False
    TabOrder = 1
  end
  object StaticText1: TStaticText
    Left = 81
    Top = 273
    Width = 140
    Height = 24
    Cursor = crHandPoint
    Caption = 'Brute Force Solver '
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText1Click
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 519
    Width = 839
    Height = 24
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2006, 2013  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText2Click
  end
  object Solvedtext: TStaticText
    Left = 197
    Top = 158
    Width = 523
    Height = 158
    AutoSize = False
    Caption = '  Congratulations!        You did it!'
    Color = clLime
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -60
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
end
