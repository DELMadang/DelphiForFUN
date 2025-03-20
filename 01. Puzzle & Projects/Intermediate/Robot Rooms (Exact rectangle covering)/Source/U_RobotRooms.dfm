object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  Caption = 'Robot Rooms  (Exact random rectangle packing)'
  ClientHeight = 645
  ClientWidth = 941
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 18
  object Image1: TImage
    Left = 436
    Top = 24
    Width = 493
    Height = 505
  end
  object Label7: TLabel
    Left = 448
    Top = 536
    Width = 257
    Height = 18
    Caption = 'Random seed generating this display'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 623
    Width = 941
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
    Width = 425
    Height = 593
    ActivePage = TabSheet1
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 417
        Height = 560
        Align = alClient
        Color = 14548991
        TabOrder = 0
        object Memo2: TMemo
          Left = 24
          Top = 15
          Width = 393
          Height = 545
          BorderStyle = bsNone
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Lines.Strings = (
            '"Robot Rooms" implements an algorithm for exactly covering a'
            'rectangular area with random rectangles meeting certain size '
            'and shape constraints.  The authors'#39' 2001 paper "Data Set '
            'Generation for Rectangular Placement Problems",  C .L. '
            'Valenzuela and P. Y. Wang, is available at'
            ''
            ''
            'The paper slightly complex but well presented and requires no'
            
              'more than high school math and a few hours of study to digest. I' +
              't'
            
              'proves the existence of exact rectangle covering with rectangles' +
              ' '
            
              'that are constrained by aspect ratio (are not too long and narro' +
              'w) '
            
              'and by area ratio (range in size from largetst to smallest).  Th' +
              'e '
            
              'proofs provide the basis for an algorithm for generating coverin' +
              'gs.'
            ''
            'It was just what a long time viewer needed generate a random'
            'arrangement of rectangles (rooms) for a Delphi investigation of'
            'intelligent robot behavior.  I helped him by providing a way to'
            'create "doorways" connecting adjacent rooms.  I found the'
            'problem so interesting that I independently implemented the'
            '"room generator" algorithm as well.'
            ''
            
              'The "door generator" portion finds overlapping edges of adjacent' +
              ' '
            'rectangles and assigns doorways if the line segment defined by '
            'the shared area is as least as long as the defined door width.'
            ''
            'The "Generate Rectangles" page lets you control base size, '
            
              'aspect and area ratios, and the number of rooms to create.  I le' +
              'ft '
            
              'two features which were used for debugging: an option to display' +
              ' '
            'text for generated rectangles and the random seed used to '
            'generate each set of rooms.   (This is handy for generating the '
            'same set of rooms multiple times.)'
            ''
            ''
            ''
            '')
          ParentFont = False
          TabOrder = 0
        end
        object RefPaperLink: TStaticText
          Left = 9
          Top = 102
          Width = 384
          Height = 20
          Cursor = crHandPoint
          Alignment = taCenter
          Caption = 'http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.39.3218'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsUnderline]
          ParentFont = False
          TabOrder = 1
          OnClick = RefPaperLinkClick
        end
      end
    end
    object TabSheet2: TTabSheet
      BorderWidth = 1
      Caption = 'Generate Rectangles'
      ImageIndex = 1
      object Label1: TLabel
        Left = 32
        Top = 24
        Width = 148
        Height = 18
        Caption = 'Number of rectangles'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 19
        Top = 73
        Width = 161
        Height = 25
        AutoSize = False
        Caption = 'Container size(W x H)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label3: TLabel
        Left = 248
        Top = 76
        Width = 11
        Height = 18
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 14
        Top = 128
        Width = 166
        Height = 18
        Caption = 'Max Aspect Ratio (H.W)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 51
        Top = 176
        Width = 129
        Height = 41
        AutoSize = False
        Caption = 'Max Area Ratio (Largest/Smallest)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 56
        Top = 304
        Width = 67
        Height = 18
        Caption = 'Door size'
      end
      object Label8: TLabel
        Left = 256
        Top = 24
        Width = 70
        Height = 18
        Caption = '(Max 100)'
      end
      object Label9: TLabel
        Left = 248
        Top = 128
        Width = 61
        Height = 18
        Caption = '(Max 10)'
      end
      object Label10: TLabel
        Left = 248
        Top = 187
        Width = 61
        Height = 18
        Caption = '(Max 10)'
      end
      object DoorsBtn: TButton
        Left = 205
        Top = 301
        Width = 180
        Height = 25
        Caption = 'Add doors'
        TabOrder = 0
        OnClick = DoorsBtnClick
      end
      object Edit1: TEdit
        Left = 184
        Top = 16
        Width = 41
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '10'
      end
      object NbrRectsUD: TUpDown
        Left = 225
        Top = 16
        Width = 16
        Height = 26
        Associate = Edit1
        Min = 2
        Position = 10
        TabOrder = 2
      end
      object WidthEdt: TEdit
        Left = 184
        Top = 72
        Width = 41
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '500'
        OnChange = SizeChange
      end
      object WidthUD: TUpDown
        Left = 225
        Top = 72
        Width = 16
        Height = 26
        Associate = WidthEdt
        Min = 50
        Max = 500
        Position = 500
        TabOrder = 4
      end
      object HeightEdt: TEdit
        Left = 272
        Top = 72
        Width = 41
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        Text = '500'
        OnChange = SizeChange
      end
      object HeightUD: TUpDown
        Left = 313
        Top = 72
        Width = 16
        Height = 26
        Associate = HeightEdt
        Min = 50
        Max = 500
        Position = 500
        TabOrder = 6
      end
      object Edit4: TEdit
        Left = 184
        Top = 124
        Width = 33
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        Text = '4'
      end
      object AspectUD: TUpDown
        Left = 217
        Top = 124
        Width = 16
        Height = 26
        Associate = Edit4
        Min = 2
        Max = 10
        Position = 4
        TabOrder = 8
      end
      object Edit5: TEdit
        Left = 184
        Top = 183
        Width = 33
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
        Text = '5'
      end
      object AreaUD: TUpDown
        Left = 217
        Top = 183
        Width = 16
        Height = 26
        Associate = Edit5
        Min = 2
        Max = 10
        Position = 5
        TabOrder = 10
      end
      object GenBtn: TButton
        Left = 208
        Top = 232
        Width = 177
        Height = 25
        Caption = 'Generate Rectangles'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        OnClick = GenBtnClick
      end
      object Memo1: TMemo
        Left = 16
        Top = 384
        Width = 385
        Height = 169
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssVertical
        TabOrder = 12
      end
      object Edit6: TEdit
        Left = 128
        Top = 300
        Width = 33
        Height = 26
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 13
        Text = '15'
      end
      object DoorSizeUD: TUpDown
        Left = 161
        Top = 300
        Width = 16
        Height = 26
        Associate = Edit6
        Min = 2
        Max = 25
        Position = 15
        TabOrder = 14
      end
      object DebugBox: TCheckBox
        Left = 24
        Top = 360
        Width = 313
        Height = 17
        Caption = 'Show intermediate results (for debugging)'
        TabOrder = 15
      end
    end
  end
  object RandSeedEdt: TEdit
    Left = 720
    Top = 536
    Width = 121
    Height = 26
    TabOrder = 2
    Text = '1218652454'
  end
  object UserandSeedBtn: TButton
    Left = 616
    Top = 568
    Width = 233
    Height = 25
    Caption = 'Generate again using this seed'
    TabOrder = 3
    OnClick = UserandSeedBtnClick
  end
end
