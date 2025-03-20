object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  Caption = 'Special Maigic Square'
  ClientHeight = 606
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 584
    Width = 767
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 767
    Height = 584
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 759
        Height = 551
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Here'#39's a puzzle sent to me by a viewer who says it is from a set' +
            ' of questions written by Clive Sinclair and '
          
            'published in a magazine, perhaps "Design Technology",  many year' +
            's ago as "Mensa Steps":'
          ''
          
            'You have twenty five numbers. You have to arrange them in a five' +
            ' by five square in such a way that each '
          
            'horizontal, vertical and the two main diagonal rows total exactl' +
            'y twenty.'
          ''
          
            'Here are the 25 numbers; 1,1,2,2,2,2,2,3,3,3,3,3,3,4,5,5,5,5,6,6' +
            ',6,6,6,7,9'
          ''
          
            'I have no idea how this would be solved with pencil and paper.  ' +
            'On the next page is my computer solution.  '
          ''
          
            'Phase 1 generates all combinations of 5 digits from the given se' +
            't of 25, then filters out those whose  digits '
          
            'do not sum to 20.  There are more than 50,000 combninations but ' +
            'most of them do not  sum to 20 and, of '
          
            'those that do, many are duplicates because of the repeated value' +
            's in the original input set.   When we are '
          
            'done filtering  there are only 30 unique sets to choose from. Ev' +
            'ery row and  every column (as well as the two '
          
            'main diagonals), must consist of one of these 30 sets arranged i' +
            'n some  order.'
          ''
          
            'Phase 2 assembles potential full grids by building 5 groups of t' +
            'he Phase 1 "columns" which contain the '
          
            'correct number of each digit value Two "1"s, five "2"s, six "3"s' +
            ', etc. Solutions must come from these sets,  '
          
            'although each of these "columns" will likely have to be rearrang' +
            'ed to find rows and diagonals that sum to  20 '
          'also.  "Phase 2" produces 110 potential column sets,'
          ''
          
            'Phase 3 finds solutions from the Phase 2 results. Clicking any o' +
            'f them starts generating all unique '
          
            'permutaions of each column looking for arrangements where the 5 ' +
            'rows and 2 diagonals also sum to 20.'
          ''
          
            'The current version of the  program finds 5786 solutions in:  99' +
            '5 seconds for all 110  Phase 2 candidates.   '
          
            'Columns are nolt rearranged during  the search, only the row pos' +
            'itions within each column, so there are likely '
          
            ' thousands more  solutions than this version finds.   (But 5000 ' +
            'is probably enough! :>)'
          ''
          '')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '   Find solutions  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      object Label1: TLabel
        Left = 256
        Top = 32
        Width = 252
        Height = 16
        Caption = 'Possible solution digits grouped by  column'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object ClickLbl: TLabel
        Left = 536
        Top = 32
        Width = 164
        Height = 16
        Caption = 'Click a group to start search'
        Visible = False
      end
      object TimeLbl1: TLabel
        Left = 408
        Top = 376
        Width = 85
        Height = 18
        Caption = '0.0 seconds'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 24
        Top = 32
        Width = 159
        Height = 16
        Caption = 'Digit groups summing to 20'
      end
      object Phase1Btn: TButton
        Left = 22
        Top = 363
        Width = 163
        Height = 25
        Caption = 'Run Phase 1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = Phase1BtnClick
      end
      object Phase1Memo: TMemo
        Left = 20
        Top = 55
        Width = 197
        Height = 298
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Phase  1 '
          'All unique sets of 5 '
          'digits which sum '
          'to 20')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object Phase2Btn: TButton
        Left = 256
        Top = 240
        Width = 137
        Height = 25
        Caption = 'Run Phase 2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = Phase2BtnClick
      end
      object StatusMemo: TMemo
        Left = 8
        Top = 419
        Width = 721
        Height = 105
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'StatusMemo')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object Phase2Memo: TMemo
        Left = 252
        Top = 48
        Width = 493
        Height = 185
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Phase 2 '
          'Find groups of 5 strings from Phase1 which contain all '
          'of the required digits')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 4
        OnClick = Phase2MemoClick
      end
      object StopBtn: TButton
        Left = 256
        Top = 371
        Width = 105
        Height = 33
        Caption = 'Stop'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Visible = False
        OnClick = StopBtnClick
      end
      object PauseBox: TCheckBox
        Left = 256
        Top = 343
        Width = 265
        Height = 17
        Caption = 'Pause on each solution found'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object StringGrid1: TStringGrid
        Left = 560
        Top = 243
        Width = 169
        Height = 169
        DefaultColWidth = 32
        DefaultRowHeight = 32
        DefaultDrawing = False
        FixedCols = 0
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
        ParentFont = False
        TabOrder = 7
        OnDrawCell = StringGrid1DrawCell
      end
      object SearchModeGrp: TRadioGroup
        Left = 256
        Top = 275
        Width = 241
        Height = 57
        Caption = 'Search mode'
        ItemIndex = 0
        Items.Strings = (
          'Search only clicked line'
          'Search all lines from clicked')
        TabOrder = 8
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 692
    Top = 17
  end
end
