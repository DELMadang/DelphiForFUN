object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Products of Digits  Version 2'
  ClientHeight = 659
  ClientWidth = 737
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
    Top = 636
    Width = 737
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
    Width = 737
    Height = 636
    Align = alClient
    TabOrder = 1
    object SearchBtn: TButton
      Left = 492
      Top = 227
      Width = 93
      Height = 29
      Caption = 'Search'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object PageControl1: TPageControl
      Left = 16
      Top = 216
      Width = 441
      Height = 377
      ActivePage = Problem1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Problem1: TTabSheet
        Caption = 'Problem 1'
        ImageIndex = 1
        object P1Memo: TMemo
          Left = 0
          Top = 0
          Width = 433
          Height = 343
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            'Problem 1'
            ''
            'Find the 2 and 3 digit positive integers the product of '
            'whise digits equals the original number when multiplied '
            'by digit 2 through 9.   For example if N=24, the '
            'product  of its digits is 8 and 8 x 3 = 24, the original '
            'number.'
            ' ')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object Problem2: TTabSheet
        Caption = 'Problem 2'
        ImageIndex = 2
        object P2Memo: TMemo
          Left = 0
          Top = 0
          Width = 433
          Height = 343
          Align = alClient
          Lines.Strings = (
            'Problem 2'
            ''
            'We are looking for a 6 digit number whose digits get '
            'reversed when multiplied by a digit between 2 and 9.'
            ' ')
          TabOrder = 0
        end
      end
      object Problem3: TTabSheet
        Caption = 'Problem 3'
        ImageIndex = 3
        object P3Memo: TMemo
          Left = 0
          Top = 0
          Width = 433
          Height = 343
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            'Problem 3 '
            ''
            'Find an integer, X, with the property that its cube '
            'together with its 4th power contain 10 digits.  The digits 0'
            'through 9 occur exactly one time each.'
            '')
          ParentFont = False
          TabOrder = 0
        end
      end
      object Problem4: TTabSheet
        Caption = 'Problem 4'
        object P4Memo: TMemo
          Left = 0
          Top = 0
          Width = 433
          Height = 343
          Align = alClient
          Lines.Strings = (
            'Problem 4 '
            ''
            'A numerically handicapped shopper wanted to find the '
            'total amount spent before checking out with her 4 items,'
            'but she confused "*" with "+" on the keypad and came up '
            'withg the product of the prices; $7.11.'
            ''
            'By strange coincidence, when the cashier totaled the '
            'order, $7.11 was the correct amount!'
            ''
            'What were item prices?'
            ''
            ' .  ')
          TabOrder = 0
        end
      end
    end
    object Memo1: TMemo
      Left = 24
      Top = 32
      Width = 537
      Height = 137
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Here are several digit manipulation problems, each '
        'probably too complex to be solved manually in '
        'reasonable time, but simple enough to be classified '
        'as "Beginners" level when aided by a computer.')
      ParentFont = False
      TabOrder = 2
    end
  end
end
