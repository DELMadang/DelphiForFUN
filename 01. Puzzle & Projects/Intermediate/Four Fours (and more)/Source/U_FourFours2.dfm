object Form1: TForm1
  Left = 397
  Top = 166
  AutoScroll = False
  Caption = 'Four Fours (and more)'
  ClientHeight = 563
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 541
    Width = 800
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
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
    Width = 800
    Height = 541
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 20
        Top = 15
        Width = 733
        Height = 466
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'The original problem as I interpreted it, was to find an express' +
            'ions containing only the four digits 4444, '
          
            'parentheses, the operators {+, -, *, /, and ^} (Plus, minus, mul' +
            'tiply, divide, and exponentiate), which '
          'evaluate to all values from 0 to 100.'
          ''
          
            'A small problem, there is no solution under these conditions.  T' +
            'he problem is from the book'
          
            '"Mathematical Bafflers" by Angela Dunn.  Her solution is less th' +
            'an satisfactory because it includes'
          
            'other tricks such as allowing the symbol "!" for factorial, the ' +
            'square root symbol, and decimal'
          
            'point. These all imply using digits not specifically included (a' +
            'll smaller digits for factorial, "2" for square'
          
            'root, and divide by 10 for the decimal point).  However it did l' +
            'ead me to generalize the problem to'
          
            'allow selection of other expression digits, operators, and targe' +
            'ts.'
          ''
          
            'The Calculate button evaluates all possible arrangements of the ' +
            'allowed operators and all possible'
          
            'ways to parenthesize a sting of alternating values and operators' +
            '.  We can optionally allow the digit'
          'values to be permuted as well.'
          ''
          
            'Under my rules, there not a set of 4 digit values which can gene' +
            'rate all values from 0 to 100, but 9252 '
          
            'will generate 75 of them and 13792 will generate all values from' +
            ' 0 to 100.  I believe that it is the '
          'smallest number to do so.'
          ''
          'Notes:'
          
            '* There is an implied "concatenation" operator so any adjacent d' +
            'igits will be tested as if they were a'
          '  single integer.'
          ''
          
            '* All operations are integer based.  Therefore the divide operat' +
            'or, "/", represents integer division and'
          
            '  remainders are dropped. I.e. "1 / 2" returns 0, "10 / 3" retur' +
            'ns 3, etc.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = '  Setup && Search   '
      ImageIndex = 1
      object Label3: TLabel
        Left = 376
        Top = 104
        Width = 217
        Height = 25
        AutoSize = False
        Caption = 'Return expression values from'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 608
        Top = 16
        Width = 123
        Height = 18
        Caption = 'Expression Digits'
      end
      object Label4: TLabel
        Left = 640
        Top = 107
        Width = 13
        Height = 18
        Caption = 'to'
      end
      object Memo2: TMemo
        Left = 384
        Top = 259
        Width = 401
        Height = 249
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 376
        Top = 16
        Width = 217
        Height = 73
        Caption = 'Operators'
        TabOrder = 1
        object Addbox: TCheckBox
          Left = 8
          Top = 24
          Width = 33
          Height = 17
          Caption = '+'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object SubBox: TCheckBox
          Left = 61
          Top = 24
          Width = 33
          Height = 17
          Caption = '-'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object DivBox: TCheckBox
          Left = 168
          Top = 24
          Width = 25
          Height = 17
          Caption = '/'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object Multbox: TCheckBox
          Left = 114
          Top = 24
          Width = 31
          Height = 17
          Caption = '*'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object ExpBox: TCheckBox
          Left = 8
          Top = 48
          Width = 145
          Height = 17
          Caption = '^ (Exponentiation)'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
      object SolutionsCountBox: TRadioGroup
        Left = 384
        Top = 136
        Width = 385
        Height = 81
        Caption = 'How many?'
        ItemIndex = 0
        Items.Strings = (
          'Show only the first expression for each target value'
          'Show all expressions for each target value'
          'Show only results summary')
        TabOrder = 2
      end
      object ShowErrors: TCheckBox
        Left = 392
        Top = 232
        Width = 225
        Height = 17
        Caption = 'Show rejected expressions'
        TabOrder = 3
      end
      object CalcBtn: TButton
        Left = 662
        Top = 229
        Width = 91
        Height = 25
        Caption = 'Calculate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = CalcBtnClick
      end
      object LowTargetEdt: TEdit
        Left = 592
        Top = 103
        Width = 41
        Height = 26
        TabOrder = 5
        Text = '0'
      end
      object SourceEdt: TEdit
        Left = 632
        Top = 34
        Width = 65
        Height = 26
        TabOrder = 6
        Text = '4444'
      end
      object HightargetEdt: TEdit
        Left = 656
        Top = 103
        Width = 41
        Height = 26
        TabOrder = 7
        Text = '10'
      end
      object PermuteBox: TCheckBox
        Left = 600
        Top = 72
        Width = 153
        Height = 17
        Caption = 'Permute the digits'
        TabOrder = 8
      end
      object Memo3: TMemo
        Left = 16
        Top = 16
        Width = 345
        Height = 345
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Notes about using the program:'
          '* Check boxes control which operators are used in   '
          ' forming expressions.'
          '* The digits to be used are entered in the "Express '
          '  Digits" edit box.  '
          '* The "Permute" check box causes all permutation of '
          '  the input digits when searching.'
          '* The "Show rejected" box causes display of '
          '  expressions which could not be evaluated. (Usually '
          '  "divide by 0" or "exponent too large" errors.)'
          '* The "Calulate"  button performs a search based on '
          '  the given inputs and options.'
          '* The box below allows searching for a range of input '
          '  digits. When using "Search" button it is '
          '  usually  best to make sure that "Permute" box is '
          '  unchecked  since the digits range can include '
          '  permutations. (I.E.   searching 111 to 999 will '
          '  automatically include 123,   132, 213, 231, 312, and '
          '  321.)  It will also speed   things  up if "Show only '
          '  results" is selected in the "How   many?" box. The '
          '  "Search" button caption will change to "Stop" while '
          '  searching and may be used to abort the search. ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 9
      end
      object RangeGrp: TGroupBox
        Left = 16
        Top = 384
        Width = 345
        Height = 113
        Caption = 'Range search'
        TabOrder = 10
        object Label1: TLabel
          Left = 160
          Top = 24
          Width = 177
          Height = 65
          AutoSize = False
          Caption = 'Highest so far: 0  targets found '
          WordWrap = True
        end
        object Label5: TLabel
          Left = 16
          Top = 24
          Width = 37
          Height = 18
          Caption = 'From'
        end
        object Label6: TLabel
          Left = 88
          Top = 24
          Width = 16
          Height = 18
          Caption = 'To'
        end
        object FromEdt: TEdit
          Left = 16
          Top = 48
          Width = 57
          Height = 26
          TabOrder = 0
          Text = '111'
        end
        object ToEdt: TEdit
          Left = 88
          Top = 48
          Width = 57
          Height = 26
          TabOrder = 1
          Text = '999'
        end
        object Searchbtn: TButton
          Tag = 1
          Left = 16
          Top = 80
          Width = 75
          Height = 25
          Caption = 'Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = SearchbtnClick
        end
      end
    end
  end
end
