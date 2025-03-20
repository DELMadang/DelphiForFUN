object Form1: TForm1
  Left = 704
  Top = 239
  AutoScroll = False
  Caption = 'Six of a Kind'
  ClientHeight = 555
  ClientWidth = 962
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 532
    Width = 962
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
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 962
    Height = 532
    Align = alClient
    AutoSize = True
    TabOrder = 1
    object Case2Btn: TButton
      Left = 88
      Top = 64
      Width = 260
      Height = 25
      Caption = ' Case 2: Six of any single number   '
      TabOrder = 0
      OnClick = Case2BtnClick
    end
    object Case3Btn: TButton
      Left = 88
      Top = 112
      Width = 260
      Height = 25
      Caption = ' Case 3: "1,2,3,4,5,6" in order         '
      TabOrder = 1
      OnClick = Case3BtnClick
    end
    object Case4Btn: TButton
      Left = 88
      Top = 160
      Width = 260
      Height = 25
      Caption = ' Case 4: "1,2,3,4,5,6" in any order: '
      TabOrder = 2
      OnClick = Case4BtnClick
    end
    object Memo1: TMemo
      Left = 503
      Top = 24
      Width = 418
      Height = 457
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'In a popular club game, 6 dice are thrown and the'
        'player wins if all six show the same number.  If you get '
        '3 tries for $1 (rolling 6 dice each time) and the payoff '
        'is $1,000, is it a fair game?'
        ''
        'I implemented 4 cases defined in the buttons at left..'
        'Case 2 is the "Six of a Kind" game so you can answer '
        'the question for yourself. Case 3 requires that the dice '
        'be thrown one at a time because order matters.'
        ''
        'If you want to calculate the odds, the probability of'
        'success is the number of possible successful outcomes '
        '(6), divided by the total number of possible outcomes '
        '(6x6x6x6x6x6).  The other cases require similar '
        'reasoning.  When a button is clicked, this memo are at '
        'left will be replaced by my theoretical calculation.'
        ''
        'To check my theory, I made each button click also play '
        'a miilion random games and report the results in this '
        'space..  (I confess, my original reasoning was '
        'incorrect for one of the four cases.)')
      ParentFont = False
      TabOrder = 3
    end
    object Case1Btn: TButton
      Left = 88
      Top = 16
      Width = 260
      Height = 25
      Caption = ' Case 1: Six "1"s                            '
      TabOrder = 4
      OnClick = Case1BtnClick
    end
    object Memo2: TMemo
      Left = 24
      Top = 200
      Width = 449
      Height = 321
      Color = clWhite
      ScrollBars = ssVertical
      TabOrder = 5
    end
  end
end
