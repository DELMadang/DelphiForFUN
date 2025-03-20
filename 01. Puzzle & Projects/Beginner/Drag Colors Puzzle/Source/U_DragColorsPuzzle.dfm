object Form1: TForm1
  Left = 192
  Top = 107
  Width = 707
  Height = 400
  Caption = 'Drag Colors Puzzle'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 392
    Top = 24
    Width = 281
    Height = 105
    Caption = 'Drag 3 colors from here (same or different)'
    TabOrder = 0
    object Shape4: TShape
      Left = 16
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clRed
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape5: TShape
      Left = 80
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clYellow
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape6: TShape
      Left = 144
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clBlue
      DragMode = dmAutomatic
      Shape = stCircle
    end
    object Shape7: TShape
      Left = 208
      Top = 24
      Width = 57
      Height = 57
      Brush.Color = clLime
      DragMode = dmAutomatic
      Shape = stCircle
    end
  end
  object GroupBox2: TGroupBox
    Left = 392
    Top = 144
    Width = 193
    Height = 89
    Caption = 'To "Guess" target circles here'
    TabOrder = 1
    object Shape3: TShape
      Left = 120
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
    object Shape2: TShape
      Left = 64
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
    object Shape1: TShape
      Left = 8
      Top = 24
      Width = 57
      Height = 57
      Shape = stCircle
      OnDragDrop = ShapeDragDrop
      OnDragOver = ShapeDragOver
    end
  end
  object Memo1: TMemo
    Left = 32
    Top = 24
    Width = 257
    Height = 281
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'The program has assigned hidden'
      'colors to the three target circles.'
      ''
      'Your task is to discover the secret'
      'pattern by dragging colors to the'
      'target circles and then clicking the'
      '"Guess" button.'
      ''
      'For extra credit:'
      ''
      'What is the optimal (fewest'
      'guesses) strategy?  What is the'
      'expected number of guesses to'
      'solve the puzzle under this strategy?'
      ''
      ' ')
    ParentFont = False
    TabOrder = 2
  end
  object GuessBtn: TButton
    Left = 600
    Top = 152
    Width = 75
    Height = 81
    Caption = 'Guess'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = GuessBtnClick
  end
  object ResetBtn: TButton
    Left = 392
    Top = 264
    Width = 289
    Height = 33
    Caption = 'Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = ResetBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 353
    Width = 699
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    BorderStyle = sbsSunken
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
