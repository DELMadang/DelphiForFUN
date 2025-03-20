object f: Tf
  Left = 339
  Top = 55
  Width = 905
  Height = 714
  Caption = 'Manual Cutting Stock Solver'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 889
    Height = 658
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo2: TMemo
        Left = 40
        Top = 48
        Width = 785
        Height = 529
        Lines.Strings = (
          
            'The "cutting stock" problem is a one-dimensional optimization pr' +
            'oblem to design the best way to cut stock ito  produce the requi' +
            'red '
          'number of parts of given lengths.     '
          ''
          
            'This is a hard problem becvause the number of possible cutting p' +
            'atterns grows exponentially with the number of part lengths to b' +
            'e '
          
            'cut.  The common solution method, Delayed Column Generation" has' +
            ' an implementation elsewhere on DelphiForFun.org.  This '
          
            'program investigates manual solutions  of the problem by listing' +
            ' the available patterns and allowing users to specify thr number' +
            ' of '
          
            'each pattern to use.  This is part of a larger project to discov' +
            'er other heuristics for solving the problem.  '
          ''
          
            'The program loads and will save problems in a text formnat suita' +
            'ble for input the the Delayed Column Generastion program which '
          
            'produces solutions better than my manual attempts in all cases t' +
            'ried so far.   '
          ''
          
            'The problem is displayed in two grids; the "Parts" grid with a r' +
            'ow listing the part number of parts needed for each required len' +
            'gth, and '
          
            'a "Supply" grid which lists the available stock lengths and the ' +
            'cost for each.   A separate list shows the best cutting patterns' +
            ' in order '
          
            'of increasing waste cost per unit length  (Unusable Length/Lengt' +
            'h*Cost).  If there are more than 100 patterns, ony the best 100 '
          'patterns are listed.   '
          ''
          
            'The Parts grid is expanded with the patterns to cut as they are ' +
            'selected from the list of available patterns. When a pattern is ' +
            'clicked, '
          
            'it is added to the solution in the smallest quantity that will s' +
            'atisfy ar least one unsatisfied part length.  Double clicking on' +
            ' a pattern '
          
            'column allows the user to chnge the number of the pattern to be ' +
            'cut.  Setting the quantity to 0 will delete the pattern from the' +
            ' solution. '
          ''
          
            'Problem definition may be modified by doubleclicking on problem ' +
            'dfinition field in one of the grids (length,  number required,  ' +
            'or cost).  '
          
            'Selecting one of these fields with a single click and then press' +
            'ing Ins or Del key will allow fileds to be added or deleted.  Do' +
            'ing so will '
          
            'reset any parital soluion and restart  with a new set of pattern' +
            's.')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Make a solution'
      ImageIndex = 1
      object PatCountLbl: TLabel
        Left = 384
        Top = 584
        Width = 90
        Height = 16
        Caption = 'Pattern count ='
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 384
        Top = 296
        Width = 148
        Height = 16
        Caption = 'Possible Cutting Patterns'
      end
      object Label3: TLabel
        Left = 40
        Top = 48
        Width = 98
        Height = 16
        Caption = 'Required Parts - '
      end
      object Label4: TLabel
        Left = 40
        Top = 296
        Width = 272
        Height = 41
        AutoSize = False
        Caption = 
          'Stock - Doubleclick a length or cost to modify  Ins ir Del key t' +
          'o add or delete stock lengths'
        WordWrap = True
      end
      object CaseLbl: TLabel
        Left = 40
        Top = 8
        Width = 59
        Height = 22
        Caption = 'Case: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 544
        Top = 296
        Width = 242
        Height = 16
        Caption = 'Click a pattern to add it to the solution'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 136
        Top = 34
        Width = 330
        Height = 16
        Caption = 'Doubleclick a pattern column to change the number used'
        Visible = False
      end
      object Label6: TLabel
        Left = 136
        Top = 48
        Width = 592
        Height = 16
        Caption = 
          'Doubleclick a part length or the number required to modify, Ins ' +
          ' or Del key to add or delete part lengths'
      end
      object PartsGrid: TStringGrid
        Left = 40
        Top = 72
        Width = 785
        Height = 209
        ColCount = 2
        FixedCols = 0
        TabOrder = 0
        OnDblClick = PartsGridDblClick
        OnKeyUp = PartsGridKeyUp
      end
      object SupplyGrid: TStringGrid
        Left = 40
        Top = 336
        Width = 217
        Height = 145
        ColCount = 2
        FixedCols = 0
        TabOrder = 1
        OnDblClick = SupplyGridDblClick
        OnKeyUp = SupplyGridKeyUp
      end
      object Memo1: TMemo
        Left = 384
        Top = 320
        Width = 473
        Height = 241
        Lines.Strings = (
          '')
        ScrollBars = ssBoth
        TabOrder = 2
        OnClick = Memo1Click
      end
      object LoadcaseBtn: TButton
        Left = 48
        Top = 504
        Width = 129
        Height = 25
        Caption = 'Load a case'
        TabOrder = 3
        OnClick = LoadcaseBtnClick
      end
      object ResetBtn: TButton
        Left = 48
        Top = 560
        Width = 113
        Height = 25
        Caption = 'Reset'
        TabOrder = 4
        OnClick = ResetBtnClick
      end
      object SaveBtn: TButton
        Left = 208
        Top = 504
        Width = 97
        Height = 25
        Caption = 'Save case'
        TabOrder = 5
        OnClick = SaveBtnClick
      end
      object PatternSort: TRadioGroup
        Left = 664
        Top = 568
        Width = 185
        Height = 49
        Caption = 'Sort patterns by'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'WasteCost'
          'Lengths')
        TabOrder = 6
        OnClick = PatternSortClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 658
    Width = 889
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select problem case'
    Left = 816
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select or enter file name for save'
    Left = 712
    Top = 24
  end
end
