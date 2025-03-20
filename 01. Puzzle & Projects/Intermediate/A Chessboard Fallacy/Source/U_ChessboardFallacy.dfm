object Form1: TForm1
  Left = 52
  Top = 11
  Width = 712
  Height = 479
  Caption = 'The missing square  -- a chessboard  fallacy'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 304
    Top = 16
    Width = 396
    Height = 409
  end
  object Oopsmemo: TMemo
    Left = 8
    Top = 16
    Width = 281
    Height = 329
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'How many squares are  in our '
      'reshaped  "chessboard"? '
      ''
      'Ooops!  Did you lose  something?'
      ''
      'As you may suspect,  things are not '
      'always as they seem'
      ''
      'Click Reset and try again to see a more '
      'accurate view.')
    ParentFont = False
    TabOrder = 7
    Visible = False
  end
  object OopsMemo2: TMemo
    Left = 8
    Top = 16
    Width = 281
    Height = 329
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Here'#39's is the actual view.   '
      ''
      'Notice that  the 1st cut was  not at a 45 '
      'degree angle but at about 48.8 '
      'degrees  (7 squares over and 8 '
      'squares down, (arctan(8/7) = 48.8 '
      'degrees).  '
      ''
      'Because of this, when we shift the '
      'piece one square to the left, we must '
      'raise it  by 1 1/7 square.   This makes '
      'the new height 9 1/7 squares and the '
      'area of the board 7 x 9 1/7 =64.   So it '
      'appears that the square was not lost '
      'after all!! '
      ''
      'Click Reset to start over.')
    ParentFont = False
    TabOrder = 8
    Visible = False
  end
  object Button1: TButton
    Left = 176
    Top = 48
    Width = 105
    Height = 25
    Caption = 'Make 1st cut'
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 176
    Top = 136
    Width = 105
    Height = 25
    Caption = 'Shift 1st piece'
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 176
    Top = 224
    Width = 105
    Height = 25
    Caption = 'Move small triangle'
    Enabled = False
    TabOrder = 2
    OnClick = Button3Click
  end
  object ResetBtn: TButton
    Left = 16
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Reset'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 169
    Height = 89
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Step1: Cut a chessboard '
      'from the top left corner of '
      'the 2nd square in the top '
      'row to the bottom right '
      'corner of the board. ')
    ParentFont = False
    TabOrder = 4
  end
  object Memo2: TMemo
    Left = 16
    Top = 112
    Width = 169
    Height = 73
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Step 2: Slide the cut piece '
      'up and left by one square. '
      ' ')
    ParentFont = False
    TabOrder = 5
  end
  object Memo3: TMemo
    Left = 16
    Top = 192
    Width = 169
    Height = 89
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Step 3: Clip off the small'
      'triangle in the bottom right '
      'corner and move it into the '
      'triangular hole in the top left '
      'corner.')
    ParentFont = False
    TabOrder = 6
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 433
    Width = 704
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002 Gary Darby, www.delphiforfun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
