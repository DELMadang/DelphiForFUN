object Form1: TForm1
  Left = 641
  Top = 161
  AutoScroll = False
  Caption = 'Instant Insanity,  Version 1.0'
  ClientHeight = 723
  ClientWidth = 892
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 700
    Width = 892
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 892
    Height = 700
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo2: TMemo
        Left = 80
        Top = 32
        Width = 737
        Height = 553
        Color = 13172735
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Instant Insanity is a variation of an older cube arrangement puz' +
            'zle and one of a large family of '
          
            'similar puzzles.  In this one, we have four cubes with one of fo' +
            'ur colors on each face of each cube. '
          
            ' The objective is to stack the cubes so each column of faces is ' +
            'the same color.'
          ''
          
            'Most of the online literature describes a graph search method wh' +
            'ich can be applied to find solutions'
          'without the aid of a computer.'
          ''
          
            'I imagine that the "trial and error" approach to solving the puz' +
            'zle led to its name, although "Eventual'
          
            'Insanity" might be more appropriate since there are 41,472 arran' +
            'gements to check!   Why 41,272? '
          
            ' There are 24 orientations of each cube.  Check this yourself wi' +
            'th a die by placing each of the 6 '
          
            'faces up and for each of these rotate the 4 vertical faces (left' +
            ', front, right and back) to the front.  '
          
            'The product 6x4 is the number of possible orientations for that ' +
            'cube.'
          ''
          
            'For the first placed cube, we don'#39't need to check all 24 orienta' +
            'tions because any solution would '
          
            'appear 8 times. That is, rotating a solution stack with each of ' +
            'the 4 faces pointing to the front would '
          
            'represent 4 solutions and inverting the entire stack and then ro' +
            'tating it would produce 4 more '
          
            'solutions.  So for the first cube, we only need to place one fac' +
            'e of each of the 3 axes facing up, '
          
            'skipping the other 21 possible orientations.  The other three cu' +
            'bes must be checked in each of the '
          
            '24 orientations, so the total number of configurations to check ' +
            'is 3 x 24 x 24 x24 = 41,472.'
          ''
          
            'Version 1 of this program takes advantage of the computer'#39's spee' +
            'd to check all 41,472'
          
            'arrangements looking for solutions. Four sample cube sets are in' +
            'cluded, plus a sample text file '
          
            'which maybe used as a model to input additional sets.  Future pr' +
            'ogram versions may add better '
          
            'graphics, other cube set sizes,  Future versions may add better ' +
            'graphics, other cube set sizes,'
          'and a cube set generator.')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Search'
      ImageIndex = 1
      object Label1: TLabel
        Left = 48
        Top = 40
        Width = 321
        Height = 105
        AutoSize = False
        Caption = 
          'The sample cube sets at right were gathered from the Internet.  ' +
          'Search "Instant Insanity" plus a name in the list to find the so' +
          'urce page.  I suspect that the first 3 sets are isomorphic (vari' +
          'ations of the same set but with modified color mapping or cube o' +
          'rder).   '
        WordWrap = True
      end
      object Label2: TLabel
        Left = 656
        Top = 8
        Width = 201
        Height = 50
        AutoSize = False
        Caption = 
          'Use the  Load button to load a cube set (4 lines with 6 color le' +
          'tters per line) from a text file.'
        WordWrap = True
      end
      object Memo1: TMemo
        Left = 41
        Top = 168
        Width = 808
        Height = 472
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object CubeList: TRadioGroup
        Left = 448
        Top = 16
        Width = 185
        Height = 121
        Caption = 'Select a test cube set'
        ItemIndex = 0
        Items.Strings = (
          'Francine Webster'
          'Jaap'#39's Puzzle Page'
          'Ivars Peterson'
          'Sarah Graham')
        TabOrder = 1
        OnClick = CubeListClick
      end
      object SearchBtn: TButton
        Left = 656
        Top = 107
        Width = 165
        Height = 29
        Caption = 'Solution search'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = SearchBtnClick
      end
      object Button1: TButton
        Left = 656
        Top = 64
        Width = 165
        Height = 29
        Caption = 'Load cube set'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = Button1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.trxt)|*.txt|All files (*.*)|*.*'
    Title = 'SELECT A CUBE SET FILE'
    Left = 844
    Top = 11
  end
end
