object Form1: TForm1
  Left = 311
  Top = 144
  Align = alCustom
  AutoScroll = False
  AutoSize = True
  Caption = 'Heap'#39's permutation algorithm demo'
  ClientHeight = 546
  ClientWidth = 840
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 840
    Height = 525
    Align = alClient
    AutoSize = True
    Caption = 'Panel1'
    UseDockManager = False
    TabOrder = 0
    DesignSize = (
      840
      525)
    object Label1: TLabel
      Left = 544
      Top = 48
      Width = 125
      Height = 16
      Caption = 'Characters to pemute'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo1: TMemo
      Left = 12
      Top = 16
      Width = 509
      Height = 481
      Anchors = []
      Color = 14548991
      Constraints.MinWidth = 465
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      Lines.Strings = (
        
          'Here'#39's an algorithm developed by J.R. Heap in 1963 which generat' +
          'es '
        
          'permutations of data items.  It is quite efficient because it sw' +
          'aps only 2 '
        
          'elements for each one generated.  The disadvantage may be that t' +
          'hat there is '
        
          'no apparent order in the generated permutations.  Search "Heap'#39's' +
          ' '
        'algorithm"on Wikipedia for more information.'
        ''
        
          'Our DelphiforFun website has a "UCombosV2" unit which generates ' +
          'many '
        
          'kinds of permutations and combinations, but I needed one that wa' +
          's easy to '
        'code for another "start from scratch" project.'
        ''
        
          'The Wikipedia article has "pseudocode" for both recursive and no' +
          'n-recursive '
        
          'implementations of the algorithm.  This demo has two Delphi vers' +
          'ions of each; '
        
          'inputs as an array of characters and as a strig of characters.  ' +
          'The four '
        
          'versions (PermuteCharArray_R, PermuteString_R, PermuteCharArray_' +
          'NR,  and '
        'PermuteStringArray_NR.   '
        ''
        
          'All four routines run about the same speed generatig the 3.6 mil' +
          'lion '
        
          'permutations of 10 characters in less than 200 milliseconds.  Ch' +
          'ecking the '
        '"Display" box increases the run time considerably!'
        '')
      OEMConvert = True
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 544
      Top = 72
      Width = 273
      Height = 24
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'ABCD'
    end
    object TypeGrp: TRadioGroup
      Left = 544
      Top = 112
      Width = 281
      Height = 105
      Caption = 'Heap'#39's Algoithm Varaints'
      ItemIndex = 0
      Items.Strings = (
        'Recursive Permute Character Array'
        'Recursive Pernute String Charatcers'
        'Non-Recursive Permute Character Array'
        'Non-Rrecursive Permute String Charatcers')
      TabOrder = 2
    end
    object DisplayBox: TCheckBox
      Left = 552
      Top = 232
      Width = 217
      Height = 25
      Caption = 'Display 1st 1,000 permutations'
      TabOrder = 3
    end
    object PermuteBtn: TButton
      Left = 552
      Top = 336
      Width = 217
      Height = 25
      Caption = 'Permute!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = PermuteBtnClick
    end
    object VerboseBox: TCheckBox
      Left = 552
      Top = 264
      Width = 193
      Height = 25
      Caption = 'Display character swaps'
      TabOrder = 5
      WordWrap = True
      OnClick = VerboseBoxClick
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 525
    Width = 840
    Height = 21
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2017, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 1
    Transparent = False
    OnClick = StaticText1Click
  end
end
