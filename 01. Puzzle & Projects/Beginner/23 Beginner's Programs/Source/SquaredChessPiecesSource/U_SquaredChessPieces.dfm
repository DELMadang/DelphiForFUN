object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Squared Chess Pieces'
  ClientHeight = 507
  ClientWidth = 896
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 484
    Width = 896
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 896
    Height = 484
    Align = alClient
    TabOrder = 1
    object SearchBtn: TButton
      Left = 596
      Top = 59
      Width = 205
      Height = 29
      Caption = 'Search for solution'
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object Memo1: TMemo
      Left = 41
      Top = 54
      Width = 536
      Height = 387
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'In a set of geometric chess pieces the KNIGHT amd KING '
        'have the the property that if the letters in their names are '
        'replaced by appropriate unique digits, the resulting '
        'numbers are both perfect squares.  '
        ''
        'What are the digt to letter assignments?')
      ParentFont = False
      TabOrder = 1
    end
  end
end
