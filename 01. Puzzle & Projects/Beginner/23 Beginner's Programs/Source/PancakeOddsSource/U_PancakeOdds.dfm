object Form1: TForm1
  Left = 316
  Top = 256
  Width = 682
  Height = 677
  Caption = 'Pancake Odds Simulation '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 609
    Width = 664
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2014, Gary Darby,  www.DelphiForFun.org'
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
    Width = 664
    Height = 609
    Align = alClient
    TabOrder = 1
    object ShowSourceLbl: TLabel
      Left = 56
      Top = 536
      Width = 504
      Height = 24
      Caption = 'View  Delphi source code for the "Simulate..." button '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = ShowSourceLblClick
    end
    object SearchBtn: TButton
      Left = 88
      Top = 448
      Width = 417
      Height = 41
      Caption = 'Simulate 1,000,000 random  trials'
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object Memo1: TMemo
      Left = 24
      Top = 16
      Width = 601
      Height = 409
      Color = 15400959
      Lines.Strings = (
        'Puzzle from Marilyn Vos Savant in the 9/28/14 edition of Parade'
        'magazine,'
        ''
        'We have three pancake types;'
        '* Burned on both sides (We'#39'll call these "Type 0"),'
        '* Burned on one side and OK on the other side "Type 1"), and'
        '* OK on both sides ("Type 2").'
        ''
        'Assume you pick a pancake at random, and it is OK on the side '
        
          'you can  see (i.e. Type 1 or Type 2).   What are the odds that i' +
          't '
        'is also OK on the other side (is a Type 2)?'
        ''
        'Marilyn says that the other side is OK 2/3 of the time, but I'
        'decided to simulate a million trial to prove it to myself.'
        ''
        'This 25 line program resolves the issue.')
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
