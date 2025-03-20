object Form1: TForm1
  Left = 407
  Top = 156
  Width = 808
  Height = 621
  Caption = 'The Counterfeit Coin  Version 2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 792
    Height = 565
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo2: TMemo
        Left = 24
        Top = 56
        Width = 713
        Height = 377
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'The object of this puzzle is to determine which one of a stack o' +
            'f coins is counterfeit based on it'#39's '
          
            'weight,  which will always be different than all the other coins' +
            ' in the stack.'
          ''
          
            'We'#39'll do this by moving coins to (or from) the pans of a balance' +
            ' beam scale.  Coins are moved from '
          
            'the stack to the left pan by clicking on it with the left mouse ' +
            'button.  Use the right mouse button to move '
          
            'to the right pan.  Coins may be moved from the pans back to the ' +
            'stack by clicking on them.  A '
          
            'weighing is recorded each time there are the same number of weig' +
            'hts in each pan, so it is good '
          
            'practice to adjust all of the coins in one pan before adjusting ' +
            'the other.'
          ''
          
            'The objective is to find the counterfeit  coin in the fewest pos' +
            'sible number of weighings.  When you '
          
            'think you know, specify the odd coin by holding down the "Ctrl" ' +
            'key while clicking on it.  In the "heavy or '
          
            'light" case you will be also asked whether the odd coin is heavy' +
            ' or light.'
          ''
          
            'The stack may contain up to 12 coins.  For 2 to 9 coins, if it i' +
            's known whether the countertfeit coin is'
          
            'lighter or heavier than the standard, it can be found in two wei' +
            'ghings!  For more than 9, or more than 3 '
          
            'if "light or heavy" is unknown, 3 weighings may be required.  Al' +
            'so for the "light or heavy" case with '
          
            'more than 3 coins, spare known good coins are provided.  The "Ma' +
            'rtin Gardner" algorithm '
          
            'implmented for the "Show me" solutions will use the spares altho' +
            'ugh I would love to find a simpler  '
          'algorithm  ')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Weigh Coins'
      ImageIndex = 1
      object Image1: TImage
        Left = 24
        Top = 256
        Width = 609
        Height = 241
      end
      object Label1: TLabel
        Left = 648
        Top = 8
        Width = 58
        Height = 13
        Caption = 'Nbr of Coins'
      end
      object WeighingsLbl: TLabel
        Left = 656
        Top = 248
        Width = 56
        Height = 13
        Caption = 'Weighings: '
      end
      object MinWeighingsLbl: TLabel
        Left = 656
        Top = 288
        Width = 84
        Height = 13
        Caption = 'Target Weighings'
      end
      object Sparecoin: TStaticText
        Left = 568
        Top = 208
        Width = 54
        Height = 17
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'Good coin'
        Color = clWhite
        ParentColor = False
        TabOrder = 7
        Visible = False
        OnMouseDown = CoinMouseDown
      end
      object Protocoin: TStaticText
        Left = 568
        Top = 208
        Width = 54
        Height = 17
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'protocoin'
        Color = clSilver
        ParentColor = False
        TabOrder = 0
        Visible = False
        OnMouseDown = CoinMouseDown
      end
      object UpDown1: TUpDown
        Left = 681
        Top = 32
        Width = 16
        Height = 21
        Associate = CoinCountEdt
        Min = 2
        Max = 12
        Position = 2
        TabOrder = 1
      end
      object CoinCountEdt: TEdit
        Left = 648
        Top = 32
        Width = 33
        Height = 21
        TabOrder = 2
        Text = '2'
        OnChange = CoinCountEdtChange
      end
      object WeightRGrp: TRadioGroup
        Left = 640
        Top = 64
        Width = 129
        Height = 73
        Caption = 'Counterfeit coin is'
        ItemIndex = 0
        Items.Strings = (
          'heavier'
          'lighter'
          'heavier or lighter')
        TabOrder = 3
        OnClick = WeightRGrpClick
      end
      object ResetBtn: TButton
        Left = 696
        Top = 184
        Width = 75
        Height = 25
        Caption = 'New set'
        TabOrder = 4
        OnClick = ResetBtnClick
      end
      object Button1: TButton
        Left = 656
        Top = 312
        Width = 75
        Height = 25
        Caption = 'Show me'
        TabOrder = 5
        OnClick = Button1Click
      end
      object RestartBtn: TButton
        Left = 696
        Top = 144
        Width = 75
        Height = 25
        Caption = 'Restart'
        TabOrder = 6
        OnClick = RestartBtnClick
      end
      object Memo1: TMemo
        Left = 24
        Top = 8
        Width = 417
        Height = 217
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Lines.Strings = (
          '1. Select number of coins and counterfeit coin type (light, '
          'heavy, or either)'
          ''
          
            '2. From the coin stack, left click to add to left pan, right cli' +
            'ck to '
          'add to right pan'
          ''
          '3. Click coins in scale pans to move them back to the input '
          'stack.'
          ''
          '4. When you think you have identified the counter coin, Ctrl-'
          'click to verify your choice.')
        ParentFont = False
        TabOrder = 8
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Solution'
      ImageIndex = 2
      object M1Lbl: TLabel
        Left = 408
        Top = 8
        Width = 280
        Height = 49
        AutoSize = False
        Caption = 'M1Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object M2Lbl: TLabel
        Left = 408
        Top = 72
        Width = 280
        Height = 49
        AutoSize = False
        Caption = 'M2Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object M3Lbl: TLabel
        Left = 408
        Top = 144
        Width = 280
        Height = 49
        AutoSize = False
        Caption = 'M3Lbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object ResultsLbl: TLabel
        Left = 408
        Top = 208
        Width = 63
        Height = 16
        Caption = 'ResultsLbl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Case1Memo: TMemo
        Left = 8
        Top = 8
        Width = 353
        Height = 505
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Solving cases where we know whether the counterfeit coin'
          'os heavy or light is much simpler than when we do not'
          'know.'
          ''
          '1. The trick here is to divide the set of coins into 3 parts A,'
          'B, and C, and weigh set A against B. Set sizes are as '
          'follows:'
          ''
          '# Coins : (A,B,C) Groups: Max weighings to solve'
          ' 1:             (1,0,0):                0'
          ' 2:             (1,1,0):                1'
          ' 3:             (1,1,1):                1'
          ' 4:             (2,2,0):                1'
          ' 5:             (2,2,1);                1'
          ' 6:             (2,2,2):                2'
          ' 7:             (3,3,1):                2'
          ' 8:             (3,3,2):                2'
          ' 9:             (3,3,3):                2'
          '10:             (4,4,2):                3'
          '11:             (4,4,3):                3'
          '12:             (4,4,4):                3'
          ''
          '2. If they balance, select set C as the new set to test, '
          'otherwise select the set that is heavy or light depending on '
          'the known weight of the counterfeit.'
          ''
          '3. Repeat steps 1 and 2 until the selected  set contains'
          'only a single coin which will be in the light or heacy pan.'
          ''
          '')
        ParentFont = False
        TabOrder = 0
      end
      object Case2Memo: TMemo
        Left = 8
        Top = 8
        Width = 353
        Height = 385
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'The "heavier or lighter" case is especially difficult to solve'
          'and identify whether the coin is heavy or light in the'
          'minimum  number of moves.  The algorithm described by'
          'Martin Gardner many years ago can solve the 12 coin'
          'case in three weighings.'
          ''
          'The method is not intuitive, but it works.  You can search'
          'for "Gardner counterfeit coin"  on the web or at'
          'delphiforfun.org for details. I obtained it from'
          ''
          ''
          ''
          'For manual solving, I use a variation of the grouping'
          'method described for the case when error direction is '
          'known and it works in most all cases.  The hard case is'
          '11 or 12 coins when the first two groups balance.  Now we'
          'must determine which coin in Group C is bad, without '
          'doing whether it is heavy or light and we must do it in two '
          'weighings! If you'#39're lucky, it can be done, but in the general '
          'case, not.'
          ''
          '')
        ParentFont = False
        TabOrder = 1
      end
      object Button2: TButton
        Left = 472
        Top = 296
        Width = 75
        Height = 25
        Caption = 'OK'
        TabOrder = 2
        OnClick = Button2Click
      end
      object StaticText2: TStaticText
        Left = 16
        Top = 156
        Width = 277
        Height = 20
        Caption = 'http://www.greylabyrinth.com/puzzle/puzzle019'
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        TabOrder = 3
        Visible = False
        OnClick = StaticText2Click
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 565
    Width = 792
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2003, 2009  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
