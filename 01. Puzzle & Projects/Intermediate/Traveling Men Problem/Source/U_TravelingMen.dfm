object Form1: TForm1
  Left = 181
  Top = 103
  Width = 803
  Height = 600
  Caption = 'The Traveling Men  Problem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 795
    Height = 553
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Panel1: TPanel
        Left = 64
        Top = 16
        Width = 609
        Height = 497
        Caption = 'Panel1'
        Color = 14548991
        TabOrder = 1
      end
      object Memo2: TMemo
        Left = 80
        Top = 40
        Width = 577
        Height = 457
        BorderStyle = bsNone
        Color = 14548991
        Lines.Strings = (
          'This is a program which solves the following logic problem:'
          ''
          ''
          
            'Mr. Barclay and five of his friends, each of whom works in a dif' +
            'ferent field, just returned from business trips.  Each man '
          
            'used two different methods of transportation during his trip.  A' +
            'll six traveled by either plane or train, but not both, and all ' +
            'six '
          
            'also traveled by bus, boat, or trolley.  No two used the same tw' +
            'o methods of transportation.  From the information provided, '
          
            'determine the first and last names of each man, his field (one d' +
            'eals in precious gems), and the two methods of travel he '
          'used on his business trip.'
          ''
          
            '1.  Mr. Rogers, who is not Vince or Russ, and Mr. Whitman togeth' +
            'er, used four different methods of transportation.'
          ''
          
            '2.  Mr. Potter traveled by bus.  The oil company executive visit' +
            'ed an area that can only be reached by a boat from the '
          'mainland.'
          ''
          
            '3.  Neither Myron, nor Russ, nor Mr. Henley, nor the mining engi' +
            'neer traveled by trolley.'
          ''
          
            '4.  Neither Leroy, who traveled by bus, nor Jeremy is the manufa' +
            'cturer.'
          ''
          
            '5.  The agricultural representative did not fly to his destinati' +
            'on.'
          ''
          '6.  Vince, who is not Mr. Henley, traveled by boat.'
          ''
          
            '7.  Dennis and Mr. Rogers traveled by train.  Mr. Strong travele' +
            'd by plane.'
          ''
          
            '8.  Both Mr. Whitman and the research scientist traveled by trol' +
            'ley'
          ''
          ''
          
            'Click the "Facts and Rules" tab to view the information extracte' +
            'd from the above clues.'
          ''
          
            'The program applies selected rules and facts to all possible way' +
            's that six first names can be matched with six last'
          
            'names, six occupations, and six ways to uniquely select two mode' +
            's of travel.  There are 720 ways to select each of these'
          
            'three characteristics (6x5x4x3x2x1=720) and 373,248,000 to selec' +
            't all three (720x720x720).  But each rule applied can'
          
            'eliminate thousands of outcomes, so the solution  search becomes' +
            's faster as more rules are applied.')
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Facts and Rules'
      ImageIndex = 1
      object totlbl: TLabel
        Left = 432
        Top = 472
        Width = 82
        Height = 13
        Caption = '0 cases checked'
      end
      object Label1: TLabel
        Left = 48
        Top = 24
        Width = 295
        Height = 16
        Caption = 'Click to toggle check marks for rules to be applied'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 432
        Top = 96
        Width = 103
        Height = 16
        Caption = 'Results of search'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Memo1: TMemo
        Left = 424
        Top = 120
        Width = 345
        Height = 329
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object CheckBtn: TButton
        Left = 424
        Top = 48
        Width = 177
        Height = 25
        Caption = 'Count possible outcomes'
        TabOrder = 1
        OnClick = CheckBtnClick
      end
      object CheckBox1: TCheckBox
        Left = 424
        Top = 24
        Width = 209
        Height = 17
        Caption = 'Show detail of possible outcomes (up to 1000)'
        TabOrder = 2
      end
      object CheckRule: TCheckListBox
        Left = 48
        Top = 56
        Width = 329
        Height = 441
        ItemHeight = 13
        Items.Strings = (
          '  {Russ is not Rogers or Whitman(#1)}'
          '  {Vince is not Rogers or Whitman (#1)}'
          '  {Whitman and  Rogers must use 4 modes of travel (#1)}'
          '  {Potter is Bus (#2)}'
          '  {Potter is not Oil (#2)}'
          '  {Oil is Boat (#2)}'
          '  {Myron not Trolley (#3) }'
          '  {Russ not trolley (#3)}'
          '  {Myron is not Henley (#3)}'
          '  {Russ is not Henley (#3)}'
          '  {Henley not trolley (#3)}'
          '  {Russ is not Mining (#3)}'
          '  {Myron is Not mining (#3)}'
          '  {Henley is not mining (#3)}'
          '  {Mining not Trolley (#3)}'
          '  {Leroy is Bus (#4)}'
          '  {Jeremy is not Mfg (#4)}'
          '  {Leroy is not Mfg (#4)}'
          '  {Agriculture not Plane (#5)}'
          '  {Vince is Boat (#6)}'
          '  {Vince is not Henley (#6)}'
          '  {Dennis is Train (#7)}'
          '  {Dennis is not Rogers (#7)}'
          '  {Dennis is not Strong (#7)}'
          '  {Strong is Plane (#7)}'
          '  {Rogers is Train (#7)}'
          '  {Whitman is Trolley (#8)}'
          '  {Whitman is not Research (#8)}'
          '  {Research is  Trolley (#8)}')
        TabOrder = 3
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
    Width = 795
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
end
