object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Shuffle'
  ClientHeight = 541
  ClientWidth = 912
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
    Top = 516
    Width = 912
    Height = 25
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
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
    Width = 912
    Height = 516
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 352
      Top = 392
      Width = 100
      Height = 16
      Caption = 'Cards per Hand'
    end
    object Label2: TLabel
      Left = 512
      Top = 392
      Width = 109
      Height = 16
      Caption = 'Number of Hands'
    end
    object Label3: TLabel
      Left = 232
      Top = 392
      Width = 60
      Height = 16
      Caption = 'Deck size'
    end
    object DealBtn: TButton
      Left = 232
      Top = 464
      Width = 345
      Height = 29
      Caption = 'Deal'
      TabOrder = 0
      OnClick = DealBtnClick
    end
    object Memo1: TMemo
      Left = 33
      Top = 22
      Width = 820
      Height = 355
      Color = 14483455
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Here is a "Beginners" level program with less than 50 lines of '
        
          'user written code to shuffle an arbitrary "deck" of  numbers and' +
          ' '
        '"deal" them a number of "hands" with a number of  "cards" per '
        '"hand" as specified by the user.'
        ''
        'It was prompted by a user who was trying to do this by randomly '
        
          'choosing hands  from the deck without choosing duplicates.  That' +
          ' '
        'is the hard and slow way to do it.  The easy way is to shuffle '
        
          'the deck, randomly arrange the cards and then choosing "handsize' +
          '" '
        'number at  a time  from top to bottom to represent the hands.'
        ''
        
          'The key trick is the 10 line "Shuffle" procedure which works fro' +
          'm '
        'the end of an array of numbers swapping each with a randomly '
        'chosen number whose position is less than or equal to the '
        'position of the number being swapped.  '
        ''
        '         ')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object HandSizeEdt: TSpinEdit
      Left = 376
      Top = 416
      Width = 57
      Height = 26
      MaxValue = 100
      MinValue = 1
      TabOrder = 2
      Value = 6
    end
    object NbrHandsEdt: TSpinEdit
      Left = 536
      Top = 416
      Width = 57
      Height = 26
      MaxValue = 100
      MinValue = 1
      TabOrder = 3
      Value = 10
    end
    object DeckSizeEdt: TSpinEdit
      Left = 232
      Top = 416
      Width = 57
      Height = 26
      MaxValue = 100
      MinValue = 1
      TabOrder = 4
      Value = 60
    end
  end
end
