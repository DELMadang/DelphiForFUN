object Form1: TForm1
  Left = 375
  Top = 180
  AutoScroll = False
  Caption = 'Log Sawing Patterns  Version 4.1'
  ClientHeight = 742
  ClientWidth = 1192
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
    Top = 719
    Width = 1192
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, 2017 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1192
    Height = 719
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 864
      Top = 48
      Width = 55
      Height = 23
      Caption = 'inches'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 704
      Top = 48
      Width = 93
      Height = 23
      Caption = 'Cant width'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 512
      Top = 16
      Width = 129
      Height = 36
      AutoSize = False
      Caption = 'Minimum Log Diameter (inches)'
      WordWrap = True
    end
    object BladeEdt: TLabeledEdit
      Left = 512
      Top = 144
      Width = 81
      Height = 24
      EditLabel.Width = 104
      EditLabel.Height = 16
      EditLabel.Caption = 'Blade Thickness'
      TabOrder = 0
      Text = '0.00'
    end
    object CantwEdt: TEdit
      Left = 816
      Top = 44
      Width = 41
      Height = 31
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '12'
    end
    object ThickEdt: TLabeledEdit
      Left = 512
      Top = 96
      Width = 81
      Height = 24
      EditLabel.Width = 106
      EditLabel.Height = 16
      EditLabel.Caption = 'Board Thickness'
      TabOrder = 2
      Text = '1.0'
    end
    object MinWidthEdt: TLabeledEdit
      Left = 512
      Top = 192
      Width = 81
      Height = 24
      EditLabel.Width = 132
      EditLabel.Height = 16
      EditLabel.Caption = 'Minimum board width'
      TabOrder = 3
      Text = '3.0'
    end
    object SaveBtn: TButton
      Left = 512
      Top = 584
      Width = 145
      Height = 25
      Caption = 'Save this case'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = SaveBtnClick
    end
    object LoadBtn: TButton
      Left = 512
      Top = 632
      Width = 163
      Height = 25
      Caption = 'Load a saved case'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = LoadBtnClick
    end
    object DepthEdt: TEdit
      Left = 512
      Top = 48
      Width = 81
      Height = 24
      TabOrder = 6
      Text = '20'
    end
    object MinBladeEdt: TLabeledEdit
      Left = 512
      Top = 248
      Width = 81
      Height = 24
      EditLabel.Width = 165
      EditLabel.Height = 16
      EditLabel.Caption = 'Minimum blade above bed'
      TabOrder = 7
      Text = '1.0'
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 488
      Height = 717
      ActivePage = TabSheet2
      Align = alLeft
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      object TabSheet1: TTabSheet
        Caption = 'June 2010'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        object Memo1: TMemo
          Left = 8
          Top = 24
          Width = 489
          Height = 633
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            
              'I cut a large oak snag this year for firewood but the wood was s' +
              'o good'
            
              'looking  that it started me thinking about acquiring a bandmill.' +
              '  While '
            
              'waiting for the feeling to pass, I pondered  the mechanics of sa' +
              'wing, '
            
              'specifically those super-sized computer controlled mills we see ' +
              'on '
            
              'Discovery channel that use laser measurements and then calculate' +
              ' '
            'and display the optimum cutting pattern for each log..'
            ''
            
              'That led to this program for computing and displaying cutting pa' +
              'tterns '
            
              'for producing boards of given thickness given the diameter at th' +
              'e '
            'small end of the log.'
            ''
            
              'I'#39've never operated a mill so all of this may have no applicatio' +
              'n in the '
            
              'real world, but it was an interesting programming project. After' +
              ' '
            
              'watching the sawing videos at vendors sites and on You Tube, I'#39'v' +
              'e '
            
              'implemented three patterns which I imagine I might want to cut (' +
              'if I '
            
              'had a mill :>) 1:Entire logs as boards,boards 2: Around the larg' +
              'est '
            
              'cant that can be produced and 3: Boards around the largest cant ' +
              'of a '
            
              'given width.  I have also read about and might add "box" sawing,' +
              ' '
            
              '(turning the log 90 degrees after each board),  and "quarter" sa' +
              'wing '
            '(quartering the log and then cutting boards from each section '
            'alternating clockwise and counterclockwise 90 degree rotations '
            
              'between boards).  Another "real world" feature would allow for l' +
              'ogs '
            'with elliptical cross sections.'
            ''
            
              'It'#39's not clear to me how the depth measurements on a mill accoun' +
              't'
            
              'for blade thickness or whether they are accurate enought to allo' +
              'w me '
            
              'to start cutting several boards above a target board width, e.g.' +
              ' the '
            'surface of a cant being produced.'
            ''
            '')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'October 2017'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Memo2: TMemo
          Left = 0
          Top = 0
          Width = 480
          Height = 685
          Align = alClient
          Color = 14548991
          Lines.Strings = (
            'I'#39'm a new sawmill owner!  It'#39's a Wood-Mizer LT35 Hydraulic and '
            'it has surpassed programming and hunting as my favorite'
            'pastimes, at least until real winter arrives. The learning'
            
              'curve is steep and I'#39'm not yet satisfied with my efficicency as ' +
              'a '
            
              'logger.  Maximizing lumber return from a log will take more than' +
              ' '
            
              'five or six logs.  The plus side is that I now have a steady sup' +
              'ply '
            'of slab wodd to split as kindling for the stove.'
            ''
            'Here'#39's Version 4 of the program.  (Versions 2 and 3 were dead'
            'end aproaches.)  This one should be closer to having some'
            'practical application.  All cut heights are now given as inches'
            
              'above the bed with the assumption the the first cut is on the fa' +
              'ce'
            'labeled as Face 1 and log turns are counterclockwise to'
            'Face 2, Face 3,and Face 4.   Each face sawing result is shown '
            'in a separate image with its own tab.'
            ''
            'Currently only two logging patterns are supported: cutting to a '
            'given cant size by rotating 90 degrees counter clockwise, and '
            'flat sawing all boards (if desired cant size is et to 0 inches).'
            'The "largest square cant" option is invoked when a cant width '
            '>= diameter is input  Nummeric outputs may be displayed as '
            '10ths or 16ths of an inch.'
            ''
            'By the way, I'#39've resolved "accounting for blade thickness"  '
            'problem by setting blade thickness to zero and accepting that '
            'actual board dimensions will be about 1/16" undersized.. '
            'the question of'
            ''
            'I encourage feedback from other sawmill owners with bug '
            'reports and enhancement ideas.'
            ''
            'Happy sawing!')
          TabOrder = 0
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Results'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 2
        ParentFont = False
        object Memo3: TMemo
          Left = 0
          Top = 0
          Width = 480
          Height = 673
          Lines.Strings = (
            'Results display here')
          TabOrder = 0
        end
      end
    end
    object SawBtn: TButton
      Left = 512
      Top = 408
      Width = 137
      Height = 33
      Caption = 'Saw it!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = SawBtnClick
    end
    object PageControl2: TPageControl
      Left = 704
      Top = 264
      Width = 441
      Height = 441
      ActivePage = Face4
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Style = tsButtons
      TabOrder = 10
      OnChange = PageControl2Change
      object Face1: TTabSheet
        Caption = '   Face  1  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        ImageIndex = 1
        ParentFont = False
        object Image1: TImage
          Left = 32
          Top = 1
          Width = 392
          Height = 392
        end
      end
      object Face2: TTabSheet
        Caption = '   Face 2   '
        ImageIndex = 2
        object Image2: TImage
          Left = 32
          Top = 1
          Width = 392
          Height = 392
        end
      end
      object Face3: TTabSheet
        Caption = '   Face3   '
        ImageIndex = 3
        object Image3: TImage
          Left = 32
          Top = 1
          Width = 392
          Height = 392
        end
      end
      object Face4: TTabSheet
        Caption = '   Face4   '
        ImageIndex = 4
        object Image4: TImage
          Left = 32
          Top = 1
          Width = 392
          Height = 392
        end
      end
    end
    object Memo4: TMemo
      Left = 704
      Top = 96
      Width = 393
      Height = 121
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Note: Cant width of zero will flat saw entire log as '
        'Face 1.'
        ''
        'Cant width at or greater than diameter will set cant '
        'size to max square cant for this diameter.')
      ParentFont = False
      TabOrder = 11
    end
    object TextGrp: TRadioGroup
      Left = 504
      Top = 288
      Width = 161
      Height = 73
      Caption = 'Text output format'
      ItemIndex = 1
      Items.Strings = (
        'Decimal'
        'Fractional')
      TabOrder = 12
    end
  end
end
