object Form1: TForm1
  Left = 76
  Top = 79
  Width = 640
  Height = 480
  Caption = 'Derangements'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 160
    Top = 364
    Width = 18
    Height = 16
    Caption = 'for '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 232
    Top = 364
    Width = 32
    Height = 16
    Caption = 'items'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 369
    Height = 345
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Charlie was pressured to hire his nephew Max for his '
      'business.  Max, not having  many skills, was put to work '
      'assisting a secretary stuffing letters into pre-addressed '
      'envelopes.   His first day however, he managed to stuff every '
      'one of a batch of 10 letters into the wrong envelopes!'
      ''
      'Charlie decided  to assume it was an accident and not fire '
      'Max for sabotage unles he could be at least 90% sure that this '
      'could not have happened by accident'
      ''
      'An arrangement of ordered items with every element in the '
      'wrong place is called a "derangement".'
      ''
      'Will Max keep his job?  i.e.  Is there less than  a 10% chance '
      'that  a random assignment of 10 uniquely numbered items into '
      'similarly 10 numbered slots will be a derangement?'
      ''
      'The curious can perform the experiment themselves by '
      'selecting Ace through 10 from a deck of cards, and after '
      'mixing them face down, laying them out in a row.  If no card is '
      'in its proper place, you have found a derangement. '
      '')
    ParentFont = False
    TabOrder = 0
  end
  object CalcChanceBtn: TButton
    Left = 8
    Top = 360
    Width = 129
    Height = 25
    Caption = 'Calculate probability'
    TabOrder = 1
    OnClick = CalcChanceBtnClick
  end
  object SpinEdit1: TSpinEdit
    Left = 184
    Top = 361
    Width = 41
    Height = 22
    MaxValue = 10
    MinValue = 1
    TabOrder = 2
    Value = 4
  end
  object Memo2: TMemo
    Left = 392
    Top = 8
    Width = 225
    Height = 401
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object ShowDetailBtn: TButton
    Left = 8
    Top = 392
    Width = 249
    Height = 25
    Caption = 'Show derangements (up to 100 entries)'
    TabOrder = 4
    OnClick = ShowDetailBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
