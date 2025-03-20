object Form1: TForm1
  Left = 134
  Top = 70
  Width = 1181
  Height = 757
  Caption = 
    'Kirkman-Tabu V3.2:  Solving Kirkman'#39's Schoolgirl Problem using T' +
    'ABU search'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object Label12: TLabel
    Left = 549
    Top = 144
    Width = 57
    Height = 18
    Caption = 'Label12'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 690
    Width = 1163
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1163
    Height = 690
    ActivePage = IntroSheet
    Align = alClient
    TabOrder = 1
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 54
        Top = 9
        Width = 991
        Height = 613
        Color = 14811135
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'The fascinating Kirkman'#39's Schoolgirl problem asks for  7 arrange' +
            'ments of 15 girls so that they can walk in 5 groups of 3'
          
            'each day for a week with no girl in a group walking with another' +
            ' girl more than once.  Since each girl will be in a group '
          'with 2 '
          
            'other girls for each of 7 days, this means that she will be pair' +
            'ed with each of the other 14 girls exactly once.'
          ''
          
            'Using a breadth first or depth first search of the "state space"' +
            ' for solution is generally impractical because of the very '
          'large'
          
            'number of possible arrangements to check.  A 2005 paper "A Simpl' +
            'e and Efficient Tabu Search Heuristics for Kirkman'
          
            'Schoolgirl Problem", Dameng Deng, Jun Ma, and Hao Shen, provided' +
            ' the inspiration for this Delphi program which can'
          'indeed find all 7 distinct solutions in less than 60 seconds.'
          ''
          
            'A "state" describes a particular configuration of the board or p' +
            'uzzle being investigated.  In our case, a 7 particular'
          
            'arrangements of the 15 girls defines a state.  A "state space" i' +
            's the set of all possible states for the problem, a very large'
          
            'number for this problem.  One of the heuristic techniques for so' +
            'lving these problems when the space is too large to '
          'search is'
          
            'called "Hill Climbing".  We need some function that tells us how' +
            ' far we are from the solution.  It searches the '
          'neighborhood of'
          
            'a current states, (the states we can reach from this state with ' +
            'a single move),  and make the move that takes us the '
          'largest'
          
            'step closer to the goal state.  Hill climbing is successful for ' +
            'many problems, but there are times when the method gets '
          'stuck'
          
            'on top a "little hill" next to the mountiaa we want to climb, bu' +
            't we cannot climb any higher without moving "downhill", '
          'further'
          'away from our final goal.'
          ''
          
            'In Kirkman'#39's problem, our measure of distance to the solution is' +
            ' the number of pairs of girls that end up walking together'
          
            'more than once during the week under the current arrangement, we' +
            #39'll call it the "Conflict Score".  A "move" is defined as'
          
            'swapping the positions of a pair of girls within a day and the d' +
            'esired moves are thiose which reduce the conflict score.'
          
            'When we reach the top of one of these "little hills" where no sw' +
            'ap will reduce the count further.  At that point, the Tabu '
          'search'
          
            'kicks in and we'#39'll make a move that increases, or at least does ' +
            'not reduce the conflict score.  The "Tabu" part means '
          'that'
          
            'that particular pair swap for a particular day is "taboo" (not a' +
            'llowed) for the next "Tabu tenure" moves.  Tabu tenure is an'
          
            'arbitrary number which depends on the nature of the problem and ' +
            'the techniques used to choose the next move to be '
          'made.'
          
            ' In this implementation, 400 works well, the TUCS paper says the' +
            'y used 30, so clearly their selection technique is '
          'different,'
          
            'and perhaps even better, than mine.  I was unable to track down ' +
            'the authors for more information.'
          ''
          
            'The "Solution search" page investigates finding solutions.  Star' +
            'ting with a random arrangement of girls for each day'
          
            'solutions will be found at about 2 per second on most current co' +
            'mputers.'
          ''
          
            'The second part of the problem once we know how to find solution' +
            's rapidly, is to identify the 7 distinct solutions, those '
          'which'
          
            'cannot be converted to match another one of the 7 by renaming th' +
            'e girls, rearranging the girls within their group, groups '
          
            'within a day or order of the days.  The "Search for unique solut' +
            'ions" page accomplishes this in time which varies '
          'depending '
          
            'on the random starting arrangement.  The best "random seed" foun' +
            'd so far finds the 7 unique solutions in under 35 '
          'seconds '
          
            'on my Dell XPS laptop after checking only 14 solved cases. The u' +
            'niqueness check uses only the first of the techniques '
          
            'described in the paper Solving the Kirkmans Schoolgirl Problem i' +
            'n a Few Seconds,  Nicolas Barnier and Pascal Brisset.'
          
            'This "checking" process is several times slower than the "findin' +
            'g process and will be explored further in a future version'
          'of the program.'
          ''
          
            'Version 3 of the program adds an extra page, "Checking Isomorphi' +
            'sms", which show more detail of the search process,'
          
            'including the mapping which converts between 2 user selected cas' +
            'es (if one exists).  The "Search uniques" page now '
          'has a '
          
            '"Save all" option which will write all solved cases to a file an' +
            'd identify which cases are unique and which are isomorphic '
          'to a '
          
            'unique case. The "Checking isomorphisms" page allows users to se' +
            'lect a pairs of cases from the file and see details of '
          'the '
          'mapping.'
          ''
          
            'Version 3.1 adds a button on the Search unique page to search 10' +
            '0 random solutions (finding all 7 uniques cases) '
          'looking '
          'for random starting seeds which are faster.'
          '')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object SolveSheet: TTabSheet
      Caption = 'Search for a solution'
      ImageIndex = 1
      object Label1: TLabel
        Left = 909
        Top = 45
        Width = 111
        Height = 18
        Caption = 'Conflict Score ='
      end
      object Label2: TLabel
        Left = 468
        Top = 495
        Width = 80
        Height = 18
        Caption = 'Tabu tenure'
      end
      object Label3: TLabel
        Left = 756
        Top = 495
        Width = 130
        Height = 18
        Caption = 'Max iteration count'
      end
      object Label6: TLabel
        Left = 450
        Top = 9
        Width = 376
        Height = 18
        Caption = 'Conflict table - number of times each letter pair occurs)'
      end
      object Label8: TLabel
        Left = 765
        Top = 558
        Width = 244
        Height = 55
        AutoSize = False
        Caption = 
          'Maximum number of pair swaps before giving up on finding a solut' +
          'ion.'
        WordWrap = True
      end
      object Label9: TLabel
        Left = 477
        Top = 558
        Width = 262
        Height = 82
        AutoSize = False
        Caption = 
          'Tabu tenure = number of iterations that a specific pair swap wit' +
          'hin a row is taboo after a swap (unless it removes a conflict)'
        WordWrap = True
      end
      object NewBtn: TButton
        Left = 9
        Top = 504
        Width = 334
        Height = 28
        Caption = 'New random search start case (with conflicts)'
        TabOrder = 0
        OnClick = NewBtnClick
      end
      object StringGrid1: TStringGrid
        Left = 0
        Top = 243
        Width = 442
        Height = 235
        ColCount = 6
        RowCount = 8
        TabOrder = 1
      end
      object SearchBtn: TButton
        Left = 9
        Top = 549
        Width = 154
        Height = 28
        Caption = 'Search'
        TabOrder = 2
        OnClick = SearchBtnClick
      end
      object StringGrid2: TStringGrid
        Left = 468
        Top = 45
        Width = 419
        Height = 419
        ColCount = 16
        DefaultColWidth = 22
        DefaultRowHeight = 22
        RowCount = 16
        TabOrder = 3
      end
      object StopBtn: TButton
        Left = 288
        Top = 594
        Width = 145
        Height = 28
        Caption = 'Stop'
        TabOrder = 4
        OnClick = StopBtnClick
      end
      object TimingBtn: TButton
        Left = 9
        Top = 594
        Width = 271
        Height = 28
        Caption = 'Timing test: Find 100 solutions'
        TabOrder = 5
        OnClick = TimingBtnClick
      end
      object TenureBar: TTrackBar
        Left = 468
        Top = 513
        Width = 271
        Height = 46
        Max = 100
        Position = 40
        TabOrder = 6
        OnChange = TenureBarChange
      end
      object IterBar: TTrackBar
        Left = 756
        Top = 513
        Width = 271
        Height = 37
        Max = 20
        Min = 1
        Position = 10
        TabOrder = 7
        OnChange = IterBarChange
      end
      object Memo2: TMemo
        Left = 0
        Top = 36
        Width = 442
        Height = 154
        Color = 14811135
        Lines.Strings = (
          'This page illustrates generating solutions for Kirkman'#39's '
          'Schoolgirl problem using Tabu search.'
          ''
          'Parameters "Tabu tenure" amd "Max iterations" may be set '
          'by '
          'sliding the trackbar controls to assess effect on search '
          'times.')
        ScrollBars = ssVertical
        TabOrder = 8
      end
    end
    object UniqueSheet: TTabSheet
      Caption = 'Search for unique solutions'
      ImageIndex = 2
      object Label4: TLabel
        Left = 630
        Top = 17
        Width = 103
        Height = 18
        Caption = 'Search status: '
      end
      object Label5: TLabel
        Left = 864
        Top = 315
        Width = 98
        Height = 18
        Caption = 'Random seed'
      end
      object SearchUniqueBtn: TButton
        Left = 630
        Top = 495
        Width = 172
        Height = 28
        Caption = 'Search for unique'
        TabOrder = 0
        OnClick = SearchUniqueBtnClick
      end
      object SaveUniqueBtn: TButton
        Left = 873
        Top = 450
        Width = 253
        Height = 28
        Caption = 'Save unique cases...'
        TabOrder = 1
        OnClick = SaveBtnClick
      end
      object Edit1: TEdit
        Left = 864
        Top = 341
        Width = 136
        Height = 26
        TabOrder = 2
        Text = '44103121'
      end
      object Memo3: TMemo
        Left = 630
        Top = 36
        Width = 433
        Height = 235
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object StringGrid3: TStringGrid
        Left = 36
        Top = 261
        Width = 442
        Height = 235
        ColCount = 6
        RowCount = 8
        TabOrder = 4
      end
      object Memo4: TMemo
        Left = 873
        Top = 495
        Width = 244
        Height = 118
        Lines.Strings = (
          'Cases are saved in text format to '
          'a '
          'file name you select.  Each case '
          'begine with a label line followed '
          'by '
          '7 lines representing the girl'#39's '
          'arrangements for 7 days.  ')
        TabOrder = 5
      end
      object SeedGrp: TRadioGroup
        Left = 630
        Top = 313
        Width = 226
        Height = 120
        Caption = 'For Unique solution search'
        ItemIndex = 2
        Items.Strings = (
          'Start with seed entered ==>'
          'Start with 66,873,234 (fast)'
          'Start with random seed')
        TabOrder = 6
        OnClick = SeedGrpClick
      end
      object Stop2Btn: TButton
        Left = 630
        Top = 547
        Width = 172
        Height = 28
        Caption = 'Stop'
        TabOrder = 7
        OnClick = StopBtnClick
      end
      object PauseBox: TCheckBox
        Left = 630
        Top = 459
        Width = 235
        Height = 28
        Caption = 'Pause after each solution'
        TabOrder = 8
      end
      object Memo5: TMemo
        Left = 27
        Top = 27
        Width = 496
        Height = 217
        Color = 14811135
        Lines.Strings = (
          
            'Solutions are generated as on the previous page, but each soluti' +
            'on '
          'is '
          
            'checked against those previously identified a unique to see if i' +
            't is '
          
            '"Isomorphic" to one of them; i.e. cannot be mapped to be renamin' +
            'g '
          
            'girls, or rearranging groups or days.   To speed the process, we' +
            ' '
          
            'normalize each solution by renaming the girls so that  the initi' +
            'al day '
          
            'contains girls in groups as {A,B,C} {D,E,F} [G,H,I} {J,K,L} {M,N' +
            ',O}.  '
          
            'This renaming is applied to the other days which are then sorted' +
            ' so '
          
            'that the girls are in alpha sequence within groups, the groups a' +
            're in '
          'sequence within a day, and the days are in sequence.')
        ScrollBars = ssVertical
        TabOrder = 9
      end
      object SaveAllBtn: TButton
        Left = 873
        Top = 414
        Width = 253
        Height = 28
        Caption = 'Save all cases...'
        TabOrder = 10
        OnClick = SaveBtnClick
      end
      object GroupBox1: TGroupBox
        Left = 36
        Top = 513
        Width = 460
        Height = 127
        Caption = 'Search random seeds which find 7 distinct solutions quickly'
        TabOrder = 11
        object Label7: TLabel
          Left = 27
          Top = 64
          Width = 342
          Height = 18
          Caption = 'Fatsest solution so far (and less than 60 seconds)'
        end
        object Label10: TLabel
          Left = 27
          Top = 90
          Width = 180
          Height = 18
          Caption = '0 solutions checked so far'
        end
        object Button2: TButton
          Left = 27
          Top = 27
          Width = 73
          Height = 28
          Caption = 'Find 100'
          TabOrder = 0
          OnClick = Button2Click
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Checking Isomorphisms'
      ImageIndex = 3
      object Case1Lbl: TLabel
        Left = 9
        Top = 27
        Width = 47
        Height = 18
        Caption = 'Case1'
      end
      object Case2Lbl: TLabel
        Left = 9
        Top = 297
        Width = 47
        Height = 18
        Caption = 'Case2'
      end
      object StringGrid4: TStringGrid
        Left = 9
        Top = 45
        Width = 442
        Height = 235
        ColCount = 6
        RowCount = 8
        TabOrder = 0
      end
      object StringGrid5: TStringGrid
        Left = 9
        Top = 315
        Width = 442
        Height = 235
        ColCount = 6
        RowCount = 8
        TabOrder = 1
      end
      object CheckIsoBtnC: TButton
        Left = 9
        Top = 603
        Width = 190
        Height = 28
        Caption = 'Check for Isomorphism'
        TabOrder = 2
        OnClick = CheckIsoBtnCClick
      end
      object Memo7: TMemo
        Left = 684
        Top = 27
        Width = 432
        Height = 613
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'This page will check for an Isomorphic'
          'mapping between the two default cases or two'
          'cases selected by the user from a set of'
          'cases previously saved  from the Unique'
          'Solutions search page.  Think of mapping as '
          'renaming the girls.  After mapping, on any '
          'day, the girls in each group will end up '
          'paired with the same girls as before the '
          'mapping although the ordering of the girls '
          'within their group may be different as may '
          'the order of groups within the day. Also the '
          'day on which this occurs may have changed.'
          'This display area will be used to show some '
          'detail about the search and mapping process.'
          ''
          'Cases may be displayed in "As read" or'
          '"Normalized" format.  A case is normalized'
          'by remapping day 1 groups to the first 15'
          'girl names. (Luckily, the girls have one'
          'letter names running from "A" through "O";'
          '{ABC DEF GHI JLK MNO}. After remapping, each '
          'group of 3 girls for the other 6 days are '
          'sorted alphabetically, the groups are alpha '
          'sorted within each day by the first girl in '
          'each, and the rows are sorted by the second '
          'girl of the 1st group each day.  '
          ''
          'All of this simplifies the match checking'
          'process and the mapping displayed is for'
          'these normalized versions.  Clicking on the'
          '"as read" display option will display the'
          'mapping to return the girls to their'
          'original names.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object LoadBtn: TButton
        Left = 18
        Top = 567
        Width = 181
        Height = 28
        Caption = 'Load cases'
        TabOrder = 4
        OnClick = LoadBtnClick
      end
      object Panel1: TPanel
        Left = 459
        Top = 27
        Width = 217
        Height = 613
        Caption = 'Panel1'
        TabOrder = 5
        Visible = False
        object Label11: TLabel
          Left = 27
          Top = 27
          Width = 163
          Height = 64
          AutoSize = False
          Caption = 'Click to select 2 cases to check'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object ListBox1: TListBox
          Left = 1
          Top = 81
          Width = 215
          Height = 531
          Align = alBottom
          ExtendedSelect = False
          ItemHeight = 18
          MultiSelect = True
          TabOrder = 0
          OnClick = ListBox1Click
        end
      end
      object DisplayGrp: TRadioGroup
        Left = 234
        Top = 558
        Width = 217
        Height = 55
        Caption = 'Display cases '
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'As read'
          'Normalized')
        TabOrder = 6
        OnClick = DisplayGrpClick
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofCreatePrompt, ofEnableSizing]
    Left = 1028
    Top = 51
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select a Kirklman Girls case file'
    Left = 972
    Top = 51
  end
end
