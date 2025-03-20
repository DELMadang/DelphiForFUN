object Form1: TForm1
  Left = 78
  Top = 101
  Width = 1291
  Height = 663
  Caption = 'Dice Probabilities V3.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 23
  object Label3: TLabel
    Left = 20
    Top = 72
    Width = 150
    Height = 23
    Caption = 'Nbr sides per die'
  end
  object Label1: TLabel
    Left = 20
    Top = 174
    Width = 182
    Height = 23
    Caption = 'Nbr to throw per trial'
  end
  object PageControl1: TPageControl
    Left = 225
    Top = 10
    Width = 931
    Height = 533
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Matched Sets'
      object MatchesBtn: TButton
        Left = 20
        Top = 276
        Width = 196
        Height = 32
        Caption = 'Run 1,000,000 trials'
        TabOrder = 0
        OnClick = MatchesBtnClick
      end
      object Memo1: TMemo
        Left = 276
        Top = 72
        Width = 625
        Height = 410
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Test results for exact number of matches in 1,000,000 trials '
          
            'throwing the specificed number of dice and checking for the spec' +
            'ified number of '
          'matched dice.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object MatchGrp: TRadioGroup
        Left = 10
        Top = 72
        Width = 257
        Height = 175
        Caption = 'Success matches ='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ItemIndex = 0
        Items.Strings = (
          'Pairs'
          '3-of-a-kind'
          '4-of-a-kind'
          '5-of-a-kind'
          '6-of-a-kind'
          'Full House (pair+3-of-a-kind)')
        ParentFont = False
        TabOrder = 2
      end
      object Button1: TButton
        Left = 24
        Top = 456
        Width = 217
        Height = 25
        Caption = 'Check all 5 die results'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button1Click
      end
      object Memo3: TMemo
        Left = 24
        Top = 368
        Width = 217
        Height = 89
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Here'#39's a button that will categorize '
          'all named outcomes when rolling 5 '
          'normal dice, including straights (5 '
          'consecutive numbers)')
        ParentFont = False
        TabOrder = 4
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Sum of Dots'
      ImageIndex = 1
      object Label4: TLabel
        Left = 31
        Top = 72
        Width = 165
        Height = 23
        Caption = 'Target sum of dots'
      end
      object SpinEdit4: TSpinEdit
        Left = 41
        Top = 112
        Width = 63
        Height = 28
        MaxValue = 100
        MinValue = 1
        TabOrder = 0
        Value = 2
      end
      object SumBtn: TButton
        Left = 51
        Top = 184
        Width = 185
        Height = 32
        Caption = 'Run 1,000,000 trials'
        TabOrder = 1
        OnClick = SumBtnClick
      end
      object Memo2: TMemo
        Left = 295
        Top = 61
        Width = 574
        Height = 411
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Test results for sum of dots equal to target value for 1,000,000' +
            ' '
          'trials throwing the specificed number of dice.'
          '')
        ParentFont = False
        TabOrder = 2
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 594
    Width = 1273
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2005, 2009  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object SidesEdt: TSpinEdit
    Left = 72
    Top = 102
    Width = 62
    Height = 34
    MaxValue = 6
    MinValue = 2
    TabOrder = 2
    Value = 6
  end
  object ThrowsEdt: TSpinEdit
    Left = 82
    Top = 204
    Width = 62
    Height = 34
    MaxValue = 6
    MinValue = 2
    TabOrder = 3
    Value = 2
  end
end
