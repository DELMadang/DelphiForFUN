object Form1: TForm1
  Left = 336
  Top = 175
  Width = 639
  Height = 487
  Caption = 'Validating numeric input  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 496
    Top = 41
    Width = 93
    Height = 16
    Caption = 'Enter an integer'
  end
  object Label2: TLabel
    Left = 424
    Top = 112
    Width = 171
    Height = 16
    Caption = 'Enter a floating point number '
  end
  object IntEdt: TEdit
    Left = 472
    Top = 57
    Width = 121
    Height = 24
    TabOrder = 0
    Text = '0'
    OnChange = editchange
    OnDblClick = IntEdtDblCkick
    OnKeyPress = IntEdtKeyPress
  end
  object FloatEdt: TEdit
    Left = 472
    Top = 128
    Width = 121
    Height = 24
    TabOrder = 1
    Text = '0'
    OnChange = editchange
    OnDblClick = FloatEdtDblClick
    OnKeyPress = FloatEdtKeyPress
  end
  object Memo1: TMemo
    Left = 25
    Top = 16
    Width = 328
    Height = 385
    Lines.Strings = (
      'Extracting numbers from an edit control is not too '
      'difficult after the fact, that is, let the user enter any '
      'characters and then check it when the number is '
      'needed.  In favct, that is the apporach I use most oif the '
      'time..'
      ' '
      'In some cases though it might be desirable to check '
      'characters as they are entered.  This program '
      'illustrates that approach using OnKeyPress exits to '
      'validate keys as they are entered.  Invalid characters, '
      'inlcuding misplaced + or - signs, are rejected and a '
      'beep sounded.'
      '.'
      'Version 2.0 handles multiple integers or floating point '
      'numbers separated by commas in a single edit '
      'control.  A double click or pressing the Enter key '
      'converts the numbers for further processing.process '
      'the numbers.'
      ''
      'For our European friends, the program also now uses '
      'the built-in variables, DecimalSeparator and '
      'ThousandSeparator to represent our decimal point '
      'and comma.')
    TabOrder = 2
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 419
    Width = 621
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
end
