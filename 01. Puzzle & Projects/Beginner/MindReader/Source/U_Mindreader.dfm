object Form1: TForm1
  Left = 152
  Top = 9
  Width = 812
  Height = 743
  Caption = 'THE MINDREADER!'
  Color = 12615935
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
  object Panel1: TPanel
    Left = 440
    Top = 8
    Width = 329
    Height = 673
    Caption = 'Panel1'
    Color = 14572763
    TabOrder = 1
    object Image1: TImage
      Left = 120
      Top = 32
      Width = 177
      Height = 169
    end
    object TryAgainBtn: TButton
      Left = 128
      Top = 512
      Width = 129
      Height = 25
      Caption = 'Try again'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = TryAgainBtnClick
    end
    object Memo2: TMemo
      Left = 56
      Top = 248
      Width = 265
      Height = 201
      BorderStyle = bsNone
      Color = 14572763
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Verdana'
      Font.Style = []
      Lines.Strings = (
        'If this is your '
        'symbol, we did it!'
        ''
        'If I chose incorrectly '
        'perhaps you need to '
        'concentrate harder.')
      ParentFont = False
      TabOrder = 1
    end
  end
  object StringGrid1: TStringGrid
    Left = 440
    Top = 8
    Width = 329
    Height = 665
    DefaultRowHeight = 32
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 20
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Wingdings'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 409
    Height = 513
    Color = 14603126
    TabOrder = 2
    object Memo1: TMemo
      Left = 32
      Top = 16
      Width = 345
      Height = 401
      BorderStyle = bsNone
      Color = 14603126
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Lines.Strings = (
        'The Mindreader program can read your '
        'mind!  If you are at least average '
        'intelligence, this should work pretty well.'
        ''
        'Think of a 2 digit number, add the digits '
        'together and subtract from the original '
        'number.  For example, if you chose 47, '
        'then your result would be 47- 11 = 36.'
        ''
        'Look up the symbol for your result in the '
        'table at left.   Do NOT move the mouse '
        'over it or click on it!  Just concentrate and '
        'visualize that  symbol while you click the '
        'button below.'
        ' ')
      ParentFont = False
      TabOrder = 0
    end
    object ShowMeBtn: TButton
      Left = 144
      Top = 456
      Width = 105
      Height = 25
      Caption = 'Show me'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ShowMeBtnClick
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 692
    Width = 804
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 3
    OnClick = StaticText1Click
  end
end
