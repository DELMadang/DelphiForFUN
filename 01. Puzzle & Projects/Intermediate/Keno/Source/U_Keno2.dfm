object Form1: TForm1
  Left = 340
  Top = 103
  Width = 853
  Height = 621
  Caption = 'Keno V2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 16
  object Label4: TLabel
    Left = 336
    Top = 232
    Width = 33
    Height = 16
    Caption = 'Pool'
  end
  object Label5: TLabel
    Left = 336
    Top = 296
    Width = 33
    Height = 16
    Caption = 'Pool'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 837
    Height = 565
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 829
        Height = 534
        Align = alClient
        Caption = 'Panel1'
        Color = 14548991
        TabOrder = 0
        object Memo3: TMemo
          Left = 24
          Top = 16
          Width = 729
          Height = 473
          BorderStyle = bsNone
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'Keno is a casino game of chance.  No skill short of precognition' +
              ' will improve your chances of winning.'
            ''
            
              'The specific rules and payouts depend on the game operator but, ' +
              'in essence, you pick a set of'
            
              'numbers (called the "Spots")  from a given pool of numbers (the ' +
              '"Pool", usually  integers from 1 to 80) .'
            
              'For each game, the computer or some mechanical device (e.g. ping' +
              '-pong ball blower) randomly'
            
              'selects a specified number of numbers (the  "Draw", usually 20 n' +
              'umbers) fron the pool.'
            ''
            
              'You pay a fixed amount for each game  and receive a payout based' +
              ' on the number of  spots which'
            
              'match numbers in the draw (matches are called the "Catch") and a' +
              ' pre-established  "Payout" or rate'
            'table.'
            ''
            
              'The house margin is usually measured as the percent of money tak' +
              'en in which is not returned back to'
            
              'the player as winnings.  House percentages seem to range from 5%' +
              ' to 30%.  Higher margins are made'
            
              'attractive by offering little or no payout  for small catches an' +
              'd  very attractive payouts for'
            
              'high match counts, which are also very unlikely to occur.  Who c' +
              'ould resist the chance of winning'
            '$25,000 for a $1 investment?'
            ''
            
              'This version of the program expands choices for Pool, Draw and S' +
              'pots to include a Brazilian lottery'
            
              'game called "LotoMania".  In Lotomania the pool is 100 numbers, ' +
              'the Draw is 50 numbers and 20 Spots'
            
              'are selected.  The Payout grid has been expanded to include both' +
              ' the theroretical odds of catching each '
            
              'number of spots and the experimental odds for each of the extend' +
              'ed simulation runs (100,000 or '
            '1,000,000 runs per button click.)'
            ''
            
              'Each game setup has a default payout table table which will let ' +
              'you break even if you play enough games, '
            
              'i.e. the house percentage is 0%.  On the "Payout Table Maintenan' +
              'ce" page you can define other payout '
            'tables and save them '
            
              'for future use. You can also reload previously saved payout tabl' +
              'es.'
            ' ')
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Play'
      ImageIndex = 1
      object Label2: TLabel
        Left = 480
        Top = 32
        Width = 250
        Height = 13
        Caption = 'Click cells below to select or deselect spots'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 40
        Top = 40
        Width = 138
        Height = 16
        Caption = 'Size of number pool'
      end
      object Label7: TLabel
        Left = 16
        Top = 104
        Width = 164
        Height = 16
        Caption = 'Number of player Spots'
      end
      object Label6: TLabel
        Left = 24
        Top = 72
        Width = 153
        Height = 16
        Caption = 'Size of computer draw'
      end
      object Label1: TLabel
        Left = 16
        Top = 301
        Width = 193
        Height = 16
        Caption = 'Games to play per set of Spots'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object StopBtn: TButton
        Left = 8
        Top = 280
        Width = 401
        Height = 241
        Caption = 'Stop'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        Visible = False
        OnClick = StopBtnClick
      end
      object StringGrid1: TStringGrid
        Left = 480
        Top = 48
        Width = 257
        Height = 257
        Color = 8454016
        ColCount = 10
        DefaultColWidth = 24
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 10
        FixedRows = 0
        TabOrder = 0
        OnDrawCell = StringGrid1DrawCell
        OnSelectCell = StringGrid1SelectCell
      end
      object Play1Btn: TButton
        Left = 16
        Top = 448
        Width = 177
        Height = 25
        Caption = 'Play games'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = PlayBtnClick
      end
      object ClearBtn: TButton
        Left = 16
        Top = 488
        Width = 97
        Height = 25
        Caption = 'Clear Stats'
        TabOrder = 2
        OnClick = ClearBtnClick
      end
      object RandomFill: TCheckBox
        Left = 480
        Top = 312
        Width = 249
        Height = 17
        Caption = 'Fill missing selected spots randomly'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 3
      end
      object PoolEdit: TSpinEdit
        Left = 192
        Top = 35
        Width = 49
        Height = 26
        MaxValue = 100
        MinValue = 20
        TabOrder = 4
        Value = 80
        OnChange = PDSClick
      end
      object DrawEdit: TSpinEdit
        Left = 192
        Top = 67
        Width = 49
        Height = 26
        MaxValue = 50
        MinValue = 1
        TabOrder = 5
        Value = 20
        OnChange = PDSClick
      end
      object SpotEdit: TSpinEdit
        Left = 192
        Top = 99
        Width = 49
        Height = 26
        MaxValue = 20
        MinValue = 0
        TabOrder = 6
        Value = 10
        OnChange = PDSClick
      end
      object KenoSetupBtn: TButton
        Left = 16
        Top = 144
        Width = 297
        Height = 25
        Caption = 'Setup default keno (80,20,10)'
        TabOrder = 8
        OnClick = KenoSetupBtnClick
      end
      object LotomaniaSetupBtn: TButton
        Left = 16
        Top = 184
        Width = 297
        Height = 25
        Caption = 'Setup Brazilian Lotomania (100,50,20)'
        TabOrder = 9
        OnClick = LotomaniaSetupBtnClick
      end
      object NbrgamesGrp: TRadioGroup
        Left = 16
        Top = 352
        Width = 385
        Height = 89
        Caption = 'Games to play'
        Columns = 4
        ItemIndex = 2
        Items.Strings = (
          '1'
          '5'
          '10'
          '100'
          '1000'
          '100,000'
          '1,000,000'
          '10,000,000')
        TabOrder = 11
      end
      object GamesPerSpots: TSpinEdit
        Left = 216
        Top = 296
        Width = 49
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 10
        Value = 10
      end
    end
    object ResultsSheet: TTabSheet
      Caption = 'Results'
      ImageIndex = 3
      object PayoutTableLbl: TLabel
        Left = 40
        Top = 0
        Width = 88
        Height = 16
        Caption = 'Payout table'
      end
      object Label8: TLabel
        Left = 40
        Top = 360
        Width = 174
        Height = 16
        Caption = 'Detail && Summary results'
      end
      object Payoutgrid: TStringGrid
        Left = 40
        Top = 16
        Width = 633
        Height = 305
        ColCount = 6
        DefaultColWidth = 100
        FixedCols = 0
        RowCount = 12
        TabOrder = 0
      end
      object Memo1: TMemo
        Left = 40
        Top = 376
        Width = 673
        Height = 137
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object PayTableSheet: TTabSheet
      Caption = 'Payout table maintenance'
      ImageIndex = 2
      OnEnter = PayTableSheetEnter
      OnExit = PayTableSheetExit
      object GroupBox1: TGroupBox
        Left = 40
        Top = 32
        Width = 737
        Height = 449
        Caption = 'Payout Table'
        TabOrder = 0
        object FileLbl: TLabel
          Left = 520
          Top = 32
          Width = 54
          Height = 20
          Caption = 'FileLbl'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Payoutfile: TMemo
          Left = 520
          Top = 56
          Width = 185
          Height = 377
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = PayoutfileChange
        end
        object LoadBtn: TButton
          Left = 384
          Top = 40
          Width = 105
          Height = 25
          Caption = 'Load... '
          TabOrder = 1
          OnClick = LoadBtnClick
        end
        object SaveBtn: TButton
          Left = 384
          Top = 72
          Width = 105
          Height = 25
          Caption = 'Save'
          TabOrder = 2
          OnClick = SaveBtnClick
        end
        object SaveAsBtn: TButton
          Left = 384
          Top = 112
          Width = 105
          Height = 25
          Caption = 'Save as...'
          TabOrder = 3
          OnClick = SaveAsBtnClick
        end
        object Memo2: TMemo
          Left = 24
          Top = 40
          Width = 345
          Height = 369
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Lines.Strings = (
            'The payout table defines how much money is '
            'paid out based on the number of numbers in the '
            'draw which match  the spots selected by the '
            'player. '
            ''
            'Payout data may be saved in a file with each '
            'record containing the three fields for each row :'
            ' '
            '  Nbr of spots selected,  '
            '  Number of matches, and '
            '  Payout dollars for that outcome for each $1 bet.  '
            ''
            'The  fields in each record must be separated  by '
            'one or more spaces. '
            ''
            'You may create or modify a payout file in the  '
            'area on the right and use "Save" or "Save as" '
            'buttons to save it. ')
          ParentFont = False
          TabOrder = 4
        end
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 565
    Width = 837
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
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.pay'
    Filter = 'Payout files (*.pay)|*.pay|All files (*.*)|*.*'
    Left = 612
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'pay'
    Left = 656
  end
end
