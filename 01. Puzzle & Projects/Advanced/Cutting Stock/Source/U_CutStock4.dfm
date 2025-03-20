object Form1: TForm1
  Left = 116
  Top = 123
  Width = 1282
  Height = 743
  Caption = 'Solving the Cutting Stock Problem  V4.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1264
    Height = 653
    ActivePage = SolutionSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object IntroSheet: TTabSheet
      Caption = 'Introduction for users'
      object Memo1: TMemo
        Left = 27
        Top = 18
        Width = 838
        Height = 478
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'The Cutting Stock problem requires that we find the best (cheape' +
            'st) way to cut one-dimensional stock pieces (pipe, 2x4'
          
            'lumber,wire, rolls of paper or other sheet materlial to be slit,' +
            '  etc.) in such a way that a given number of pieces of specified' +
            ' '
          'lengths or widths are created.'
          ''
          
            'The program takes two types of data as input, Parts and Stock:  ' +
            'The "Solve" button finds the lowest cost way to cut the'
          
            'required material.  Results are displayed in text and graphical ' +
            'form.  Check boxes specify whether the text version of'
          
            'fractional and/or integer solutions are displayed.  The fraction' +
            'al solution assumes that unused "waste" has value.  I.E.'
          
            'fractional stock pieces left over are not charged to the coast. ' +
            ' In the integer solution, any piece cut from a stock piece '
          
            'results in a charge for the entire stock piece.  There is also a' +
            ' "Verbose" checkbox used for debugging which displays '
          'information about intermediate results.'
          ''
          'The graphical integer solution is always displayed.'
          ''
          
            'The "Parts" grid  reflects the desired output part defined by pa' +
            'rt lengths and the number of each part length required.  '
          
            '"Stock" input defines the lengths of stock material required and' +
            ' the cost of each length.'
          ''
          
            'Enter data by clicking on a row of data and entering new values.' +
            ' There should always be a blank line for entering a new'
          
            'row of data.  If not, the "Insert" keybpard key will create one.' +
            ' The "Delete" key will delete any selected row. For the Parts '
          
            'list, the system defines a random default color of that length f' +
            'or the graphical display.   Click on any color in the Parts grid' +
            ' '
          'to '
          'bring a dialog where color may be changed to your preference.'
          ''
          
            'Cases may be saved and restored using the "Save" and "Load" butt' +
            'ons.  Cases are saved in text format and include the '
          
            'solution if the case has been solved. Printing a saved case file' +
            ' is an easy way to obtain a printout of the problem and '
          'solution.'
          ' ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Method overview'
      ImageIndex = 2
      object Label3: TLabel
        Left = 63
        Top = 459
        Width = 37
        Height = 16
        Caption = 'Links'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Memo4: TMemo
        Left = 27
        Top = 9
        Width = 838
        Height = 442
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Ths is an LP (Linear programming) problem with the complication ' +
            'that the number of different ways to cut'
          
            'each stock piece grows exponentially with the number of lengths ' +
            'required and may get too large for '
          
            'traditional LP techniques.    The different lengths required are' +
            ' rows of the solution matrix and the unique '
          
            'cutting patterns are the columns. The intersections of the input' +
            ' matrix contain the number of that length '
          
            '(row) which can be cut from that pattern (column). Since there m' +
            'ay be hundreds (or thousands or '
          
            'millions) of columns, they cannot all be generated. The solution' +
            ' uses a technique called "Delayed Column'
          
            'Generation". Here we generate enough columns to define a solutio' +
            'n, usually not the optimal one (for '
          
            'each part length, cut as many as possible of that length from ea' +
            'ch stock piece) until enough parts have '
          
            'been cut.  That solution is used as input to the second part of ' +
            'the algorithm, a "Knapsack" problem, which '
          
            'searches for an unused pattern that improves the solution, i.e. ' +
            'reduces the total cost. Since the '
          
            'Knapsack algorithm maximizes the value of goods, the trick here ' +
            'is use the "dual variables" of the LP '
          'problem to maximize the amount of material cut per unit cost.'
          ''
          
            'The code was adapted to Delphi code from a Pascal version publis' +
            'hed several years ago by a'
          
            'group of Korean students working under Professor Soondal Park.  ' +
            'Follow the link below for '
          
            'more information.  I wish I could say that I fully understood ev' +
            'ery step of the code, but my Mother '
          
            'taught me never to lie.  The section of the code which generates' +
            ' the integer solution from the '
          
            'fractional solution is original by me.   The Argonne National La' +
            'boratories pages provide the most '
          'referenced and best problem description I have found.'
          ''
          ''
          ' '
          ' '
          ' '
          ' '
          ' ')
        ParentFont = False
        TabOrder = 0
      end
      object Memo3: TMemo
        Left = 63
        Top = 477
        Width = 559
        Height = 46
        Cursor = crHandPoint
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        Lines.Strings = (
          'Argonne National Laboratories (Problem description)'
          'Operations Research Laboratory (Original Pascal code source)')
        ParentFont = False
        TabOrder = 1
        OnClick = Memo3Click
      end
    end
    object SolutionSheet: TTabSheet
      Caption = 'Solver'
      ImageIndex = 1
      object Label1: TLabel
        Left = 9
        Top = 18
        Width = 93
        Height = 17
        Caption = 'Ordered sizes'
      end
      object Label2: TLabel
        Left = 9
        Top = 306
        Width = 307
        Height = 19
        AutoSize = False
        Caption = 'Available stock size (length or width) && cost'
        WordWrap = True
      end
      object Label4: TLabel
        Left = 9
        Top = 555
        Width = 880
        Height = 19
        Caption = 
          'Notice: This is a programming exercise.  All results are present' +
          'ed "as is" with  no warranty expressed or implied'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object PageControl2: TPageControl
        Left = 351
        Top = 18
        Width = 622
        Height = 451
        ActivePage = TabSheet1
        TabOrder = 5
        object TabSheet1: TTabSheet
          Caption = 'Solutution text '
          object Memo2: TMemo
            Left = 0
            Top = 0
            Width = 614
            Height = 388
            Align = alTop
            ScrollBars = ssVertical
            TabOrder = 0
          end
          object ShowFractional: TCheckBox
            Left = 189
            Top = 394
            Width = 199
            Height = 19
            Caption = 'Show fractional results'
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = ShowDetailClick
          end
          object ShowDetail: TCheckBox
            Left = 378
            Top = 394
            Width = 208
            Height = 19
            Caption = 'Show intermediate results'
            TabOrder = 2
            OnClick = ShowDetailClick
          end
          object ShowInteger: TCheckBox
            Left = 9
            Top = 394
            Width = 145
            Height = 19
            Caption = 'Show integer results'
            Checked = True
            State = cbChecked
            TabOrder = 3
            OnClick = ShowDetailClick
          end
        end
        object TabSheet3: TTabSheet
          Caption = 'Visual Solution'
          ImageIndex = 1
          object ScrollBox1: TScrollBox
            Left = 0
            Top = 0
            Width = 614
            Height = 419
            Align = alClient
            TabOrder = 0
            object Panel1: TPanel
              Left = 18
              Top = 9
              Width = 577
              Height = 127
              TabOrder = 0
              object Image1: TImage
                Left = 27
                Top = 32
                Width = 532
                Height = 59
              end
              object PatternIdLbl: TLabel
                Left = 27
                Top = 9
                Width = 71
                Height = 17
                Caption = 'Pattern # 1'
              end
              object NbtToCutLblLabel5: TLabel
                Left = 27
                Top = 90
                Width = 92
                Height = 17
                Caption = 'Number to cut'
              end
            end
          end
        end
      end
      object PartsGrid: TStringGrid
        Left = 9
        Top = 36
        Width = 316
        Height = 226
        ColCount = 3
        DefaultColWidth = 48
        DefaultDrawing = False
        FixedCols = 0
        RowCount = 10
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
        TabOrder = 0
        OnClick = PartsGridClick
        OnDrawCell = PartsGridDrawCell
        OnKeyUp = GridKeyUp
      end
      object Supplygrid: TStringGrid
        Left = 9
        Top = 333
        Width = 316
        Height = 181
        ColCount = 2
        FixedCols = 0
        RowCount = 10
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 1
        OnKeyUp = GridKeyUp
      end
      object SolveBtn: TButton
        Left = 504
        Top = 486
        Width = 84
        Height = 28
        Caption = 'Solve'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = SolveBtnClick
      end
      object Loadbtn: TButton
        Left = 603
        Top = 486
        Width = 127
        Height = 28
        Caption = 'Load problem'
        TabOrder = 3
        OnClick = LoadbtnClick
      end
      object SaveBtn: TButton
        Left = 738
        Top = 486
        Width = 127
        Height = 28
        Caption = 'Save problem'
        TabOrder = 4
        OnClick = SaveBtnClick
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 653
    Width = 1264
    Height = 22
    Align = alBottom
    Caption = 'Current case:  Initial default '
    TabOrder = 1
  end
  object StaticText2: TStaticText
    Left = 0
    Top = 675
    Width = 1264
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2007-2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 2
    OnClick = StaticText2Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Data (*.dat, *.txt)|*.dat;*.txt|All files (*.*)|*.*'
    Title = 'Selat a problem file'
    Left = 536
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Cases (*.dat, *,txt)|*.dat; *.txt|All files (*.*)|*.*'
    Title = 'Select or enter file name for save '
    Left = 592
    Top = 16
  end
  object ColorDialog1: TColorDialog
    Left = 652
    Top = 24
  end
end
