object bigints: Tbigints
  Left = 260
  Top = 1
  Caption = 'Big integers test V2.2'
  ClientHeight = 817
  ClientWidth = 1239
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1239
    Height = 800
    ActivePage = TabSheet2
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitWidth = 1247
    ExplicitHeight = 808
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 1231
        Height = 768
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            ' This is a test program for Version 4 of our TInteger Delphi cla' +
            'ss, UBigIntsV4.  (Scroll to bottom of this page for latest chang' +
            'e details.)'
          ''
          
            'TInteger was developed in 2001 to explore large integer arithmet' +
            'ic. The original version contained class methods Assign, '
          
            'Add, Subtract, Mult, Divide, Modulo, Compare, Factorial, Convert' +
            'ToDecimalString with variations to accept both TInteger and in'
          'some cases:  Int64 (64 bit integer), and/or String parameters.'
          ''
          
            'Since then a number of viewers, Charles Doumar and Hans Klein in' +
            ' particular,  have made valuable contributions to improve'
          
            'the speed of existing methods and to introduce additional method' +
            's.'
          ''
          'In addition to the above, the current version includes:'
          ''
          '    '#164'   AssignZero;  {Fast way to assign 0 to '#39'self'#39')'
          '    '#164'   AssignOne;   {Fast way to assign 1 to '#39'self'#39')'
          '    '#164'   ConvertToInt64'
          '    '#164'   FastMult  (Faster version of Multiply)'
          '    '#164'   Pow    (exponentiation '#39'self'#39'^Y'
          '    '#164'   NRoot  (Find Nth root of X)'
          '    '#164'   Square ( self * self)'
          '    '#164'   FastSquare (Faster version of Square)'
          '    '#164'   SqRoot (Square root of self)'
          '    '#164'   GCD (Greatest Common Denominatorvalue'
          '    '#164'   IsOdd (Returns True if integer is odd)'
          
            '    '#164'   DigitCount: integer; (Number of decimal digits in the in' +
            'teger)'
          ''
          ''
          'The following methods test or manipulate the sign of '#39'self'#39':'
          ''
          
            '    '#164'   GetSign {returns +1,0, or -1 or positive, zero, negative' +
            '}'
          '    '#164'   SetSign {Sets sign to +1, 0 or -1}'
          
            '    '#164'   AbsoluteValue (Sets sign to +1 if integer value is not z' +
            'ero}'
          '    '#164'   ChangeSign (equivalent to multiply by -1)'
          '    '#164'   IsPositive  (returns True if sign = +1)'
          '    '#164'   IsZero  (returns True if sign = 0)'
          '    '#164'   IsNegative  (returns True if sign = -1)'
          ''
          ''
          
            'These procedures get and set the global base value used by TInte' +
            'ger classes.  They should not normally be called by users.'
          ''
          
            '    '#164'   GetBase (Returns 10^x, size of each "digit", default and' +
            ' maximum is 1,000,000)'
          
            '    '#164'   SetBaseVal (Changing this value from default will use mo' +
            're space and slow calculations)'
          ''
          
            'Visit Delphiforfun.org website or search the Internet for :'#39'Mill' +
            'er Rabin'#39', '#39'RSA'#39', '#39'ModPow'#39', or  '#39'InvMod'#39' for more'
          'information on the following 3 functions and their usage..'
          ''
          
            '    '#164'  IsProbablyPrime (Miller Rabin primality test, identifies ' +
            'number as probably prime)'
          
            '    '#164'  ModPow (X^Y mod Z, used in Miller Rabin probabistic test ' +
            'for primes and in cryptographic key generation)'
          
            '    '#164'  InvMod (Used with ModPow in RSA cryptographic key generat' +
            'ion)'
          ''
          ''
          
            'Version 3 evaluates additional definitions for division with rem' +
            'ainder all meeting the requirement that Divisor*Quotient +'
          
            'Remainder = Dividend, but producing differing Quotients and Rema' +
            'inders if Divisor and or Dividend is <0.  See the paper'
          
            '"Divisions and Modulus for Computer Scientists" by Daan Leijen a' +
            't'
          
            'http://www.cs.uu.nl/~daan/download/papers/divmodnote.pdf for an ' +
            'excelent discussion.'
          ''
          
            '    '#164'   DivideRem (The original divide with remainder using trnc' +
            'ated division)'
          '    '#164'   DivideRemTrunc (caalls the original Dividerem)'
          '    '#164'   DivideRemFloor (Floored division definition)'
          
            '    '#164'   DivideRemEuclidean  (Euclidean division definition, rema' +
            'iner is always positive)'
          ''
          'May 11, 2009'
          
            '   Added routines Random,  RandomOfSize, GetNextPrime,  AssignHe' +
            'x, and ConvertHexToString to UBigIntsV3 and tests for '
          'those routines to this program.'
          ''
          'November 16, 2013:  UBigIntsV4 adds significant features:'
          
            '    '#164'   A "Verbose" chaeck box turns on the display of the inter' +
            'nal "Digits" property array for those interested in  internals.'
          
            '    '#164'   For Delphis after Version 7, "Operator overloading" simp' +
            'lifies coding  big integer arithmetic.'
          
            '    '#164'   Conditional compilation tests allow maintaing a common s' +
            'oude code base for versions with and without operator overlaodin' +
            'g code.'
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Test'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 15
        Top = 209
        Width = 14
        Height = 16
        Caption = 'X:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 371
        Top = 209
        Width = 15
        Height = 16
        Caption = 'Y:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 124
        Top = 410
        Width = 260
        Height = 63
        AutoSize = False
        Caption = 
          'Compare multiplply times for two random integers x and y digits ' +
          'long..  FastMult significantly faster above 4000 digits.  Result' +
          ' size (x+y) limited to 500,000 digits for time considerations. '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        WordWrap = True
      end
      object TimeLbl: TLabel
        Left = 442
        Top = 384
        Width = 51
        Height = 17
        Caption = 'TimeLbl'
      end
      object Label3: TLabel
        Left = 735
        Top = 209
        Width = 14
        Height = 16
        Caption = 'Z:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object AllocLbl: TLabel
        Left = 26
        Top = 624
        Width = 125
        Height = 17
        Caption = 'Allocated memory: '
      end
      object Long1Edt: TEdit
        Left = 34
        Top = 205
        Width = 326
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Text = '9876543217'
      end
      object Long2Edt: TEdit
        Left = 390
        Top = 205
        Width = 326
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        Text = '1234567891'
      end
      object AddBtn: TButton
        Left = 7
        Top = 247
        Width = 79
        Height = 20
        Hint = 'Addition'
        Caption = 'x + y  (V)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = AddBtnClick
      end
      object MultBtn: TButton
        Left = 186
        Top = 247
        Width = 76
        Height = 20
        Hint = 'Multiplication'
        Caption = 'x * y    (V,)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = MultBtnClick
      end
      object FactorialBtn: TButton
        Left = 362
        Top = 280
        Width = 59
        Height = 20
        Hint = 'Factorial(x), x limited to 3000'
        Caption = 'x!'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = FactorialBtnClick
      end
      object SubtractBtn: TButton
        Left = 100
        Top = 247
        Width = 71
        Height = 20
        Hint = 'Subraction'
        Caption = 'x - y    (V)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = SubtractBtnClick
      end
      object DivideBtn: TButton
        Left = 275
        Top = 247
        Width = 85
        Height = 20
        Hint = 'Trunc(x/y),  i.e. rounded toward zero'
        Caption = 'x div y    (V)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
        OnClick = DivideBtnClick
      end
      object ModBtn: TButton
        Left = 241
        Top = 312
        Width = 86
        Height = 20
        Hint = 'Truncate Mod (d*(D/d)+ModT(D,d)=D'
        Caption = 'x modulo y (o)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        OnClick = ModBtnClick
      end
      object ComboBtn: TButton
        Left = 7
        Top = 312
        Width = 130
        Height = 20
        Hint = 'Combinations (Coose y of x)'
        Caption = 'Combo (y of x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
        OnClick = ComboBtnClick
      end
      object XtotheYBtn: TButton
        Left = 450
        Top = 280
        Width = 66
        Height = 20
        Hint = 'Power function'
        Caption = 'x^y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        OnClick = powerbtnClick
      end
      object Long3Edt: TEdit
        Left = 754
        Top = 205
        Width = 132
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 10
        Text = '3'
      end
      object ModPowBtn: TButton
        Left = 494
        Top = 312
        Width = 176
        Height = 20
        Hint = 'PowMod function'
        Caption = 'ModPow(x,y) =  x^y (modulo z)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        OnClick = modpowbtnClick
      end
      object SqRootBtn: TButton
        Left = 100
        Top = 280
        Width = 66
        Height = 20
        Hint = 'Square root'
        Caption = 'Sq. root'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        OnClick = rootbtnClick
      end
      object SquareBtn: TButton
        Left = 5
        Top = 280
        Width = 66
        Height = 20
        Hint = 'Square'
        Caption = 'x^2'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        OnClick = squareButtonClick
      end
      object CopyBtn: TButton
        Left = 481
        Top = 449
        Width = 105
        Height = 20
        Caption = 'Copy result to x'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
        OnClick = copyButtonClick
      end
      object ProbPrimeBtn: TButton
        Left = 182
        Top = 280
        Width = 150
        Height = 20
        Caption = 'is probably prime?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        OnClick = primetestclick
      end
      object GCDBtn: TButton
        Left = 156
        Top = 312
        Width = 66
        Height = 20
        Hint = 'Greatest Common Denominator'
        Caption = 'GCD(x,y)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 16
        OnClick = gcdClick
      end
      object InvModBtn: TButton
        Left = 345
        Top = 312
        Width = 137
        Height = 20
        Hint = 'Inverse mod function (InvMod)'
        Caption = 'InvMod(x,y)*x =1 modulo y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        OnClick = invbuttonClick
      end
      object YthRootBtn: TButton
        Left = 546
        Top = 280
        Width = 93
        Height = 20
        Caption = 'Yth root of X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        OnClick = YthRootBtnClick
      end
      object FastMultBtn: TButton
        Left = 7
        Top = 416
        Width = 111
        Height = 20
        Caption = 'FastMult  '
        ParentShowHint = False
        ShowHint = True
        TabOrder = 19
        OnClick = FastMultBtnClick
      end
      object FloorBtn: TButton
        Left = 371
        Top = 247
        Width = 65
        Height = 20
        Hint = '(x/y) rounded toward minus infinityo'
        Caption = 'Floor(x/y)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 20
        OnClick = FloorBtnClick
      end
      object Button12: TButton
        Left = 156
        Top = 345
        Width = 131
        Height = 20
        Caption = 'invmod(x,y)*x mod y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 21
        Visible = False
        OnClick = Button12Click
      end
      object Memo1: TMemo
        Left = 13
        Top = 475
        Width = 579
        Height = 124
        ScrollBars = ssVertical
        TabOrder = 22
      end
      object DivRemBtn: TButton
        Left = 455
        Top = 247
        Width = 183
        Height = 20
        Caption = 'x /y (with remainder, 3 methods)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 23
        OnClick = DivRemBtnClick
      end
      object ToInt64Btn: TButton
        Left = 7
        Top = 345
        Width = 130
        Height = 20
        Caption = 'ConvertToInt64(x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 24
        OnClick = ToInt64BtnClick
      end
      object RandomBtn: TButton
        Left = 316
        Top = 345
        Width = 72
        Height = 20
        Caption = 'Random(x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 25
        OnClick = RandomBtnClick
      end
      object RandomOfSizeBtn: TButton
        Left = 403
        Top = 345
        Width = 137
        Height = 20
        Hint = 'Return random number x digits long '
        Caption = 'Random Of Size(x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 26
        OnClick = RandomOfSizeBtnClick
      end
      object NextPrimeBtn: TButton
        Left = 7
        Top = 377
        Width = 85
        Height = 20
        Hint = 'Rwruen next  larger probable prime'
        Caption = 'Next Prime(x)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 27
        OnClick = NextPrimeBtnClick
      end
      object ToHexBtn: TButton
        Left = 104
        Top = 377
        Width = 118
        Height = 20
        Caption = 'Convert To Hex String'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 28
        OnClick = ToHexBtnClick
      end
      object FromHexBtn: TButton
        Left = 241
        Top = 377
        Width = 156
        Height = 20
        Caption = 'Convert Hex String to BigInt'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 29
        OnClick = FromHexBtnClick
      end
      object Button1: TButton
        Left = 553
        Top = 345
        Width = 111
        Height = 20
        Caption = 'Misc testing'
        TabOrder = 30
        OnClick = Button1Click
      end
      object GroupBox1: TGroupBox
        Left = 13
        Top = 13
        Width = 408
        Height = 176
        Caption = 'Verbose (displays internal Digits Array)'
        TabOrder = 31
        object Label5: TLabel
          Left = 9
          Top = 143
          Width = 247
          Height = 20
          AutoSize = False
          Caption = 'Set N for new base 10^N:  (1<=N<=6):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object Verbosebox: TCheckBox
          Left = 9
          Top = 20
          Width = 339
          Height = 21
          Caption = 'Set  Verbose (V) display optioon by checking this box.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          WordWrap = True
          OnClick = VerboseboxClick
        end
        object BaseEdt: TSpinEdit
          Left = 280
          Top = 143
          Width = 39
          Height = 34
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          MaxValue = 8
          MinValue = 1
          ParentFont = False
          TabOrder = 1
          Value = 5
          OnChange = BaseEdtChange
        end
        object Memo5: TMemo
          Left = 9
          Top = 48
          Width = 384
          Height = 90
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            ' Results for +, -, *,Div, and Mod operations will include the  '
            'Digits values for each input and output.  By default each '
            
              'Digits entry contains 5 digits of the integer in left ot right o' +
              'rder.  The '
            
              'Digits entries themselves run from low to high order so the firs' +
              't 5 '
            
              'digits appear in Digits[0], the 2nd 5 digits in Digits[1],  etc.' +
              '  '
            'Changing Baseval from the default of 100,000 will change the '
            'number of digits per Digits entry.')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
      object OverLoadTextGrp: TGroupBox
        Left = 462
        Top = 13
        Width = 397
        Height = 176
        Caption = 'Overloaded Operators'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 32
        Visible = False
        object Memo3: TMemo
          Left = 20
          Top = 26
          Width = 364
          Height = 137
          BorderStyle = bsNone
          Lines.Strings = (
            'For versions of Delphi after Version 7, it is possible '
            'to "overload" certain operators so that the fuinctions '
            'are implicitly called when operator symbols are '
            'found.  Operators tested in this version are (+, -, *, '
            'Div, and Mod). The biuttons below for thos operation '
            'will display display overloaded operator results if '
            'available.  A radio box with comparison opertors will '
            'display results for recent Delphi versions.  ')
          ScrollBars = ssVertical
          TabOrder = 0
          Visible = False
        end
      end
      object OverloadGrp: TGroupBox
        Left = 689
        Top = 247
        Width = 202
        Height = 352
        Caption = 'Operator Overloads'
        TabOrder = 33
        Visible = False
        object OverAddBtn: TButton
          Left = 15
          Top = 26
          Width = 86
          Height = 20
          Hint = 'Addition'
          Caption = 'x + y   (V)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = OverAddBtnClick
        end
        object OverModBtn: TButton
          Left = 15
          Top = 94
          Width = 87
          Height = 21
          Hint = 'Truncate Mod (d*(D/d)+ModT(D,d)=D'
          Caption = 'x mod y '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = OverModBtnClick
        end
        object OverSubtreactBtn: TButton
          Left = 15
          Top = 60
          Width = 86
          Height = 20
          Hint = 'Subraction'
          Caption = 'x - y    (V)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = OverSubtractBtnClick
        end
        object OverMultBtn: TButton
          Left = 115
          Top = 26
          Width = 85
          Height = 20
          Hint = 'Multiplication'
          Caption = 'x * y    (V)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = OverMultBtnClick
        end
        object OverDivBtn: TButton
          Left = 115
          Top = 60
          Width = 85
          Height = 20
          Hint = 'Trunc(x/y),  i.e. rounded toward zero'
          Caption = 'x div y    (V)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          OnClick = OverDivBtnClick
        end
        object Memo4: TMemo
          Left = 2
          Top = 202
          Width = 203
          Height = 143
          Lines.Strings = (
            'Click to test these compare '
            'operations:'
            ''
            'Equal  (x = y)'
            'Not Equal (x <> y)'
            'Greater than (x > y)'
            'Greater than or equal (x >= '
            'y)'
            'Less than (x < y)'
            'Less than or equal (x <= y)')
          TabOrder = 5
          OnClick = Memo4Click
        end
        object IncBtn: TButton
          Left = 15
          Top = 128
          Width = 86
          Height = 21
          Hint = 'Trunc(x/y),  i.e. rounded toward zero'
          Caption = 'Inc(X)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 6
          OnClick = IncBtnClick
        end
        object DecBtn: TButton
          Left = 15
          Top = 163
          Width = 87
          Height = 21
          Hint = 'Truncate Mod (d*(D/d)+ModT(D,d)=D'
          Caption = 'Dec(X)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          OnClick = DecBtnClick
        end
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 800
    Width = 1239
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2001-2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
    ExplicitWidth = 350
  end
end
