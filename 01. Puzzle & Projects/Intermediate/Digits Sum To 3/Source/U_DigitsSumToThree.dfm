object Form1: TForm1
  Left = 450
  Top = 220
  Width = 1242
  Height = 677
  Caption = 'Integer digits sum to 3'
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
    Top = 617
    Width = 1234
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2017 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1234
    Height = 617
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object GenerateAllBtn: TButton
      Left = 280
      Top = 247
      Width = 393
      Height = 28
      Caption = '#2: Generate all valid numbers'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = GenerateAllBtnClick
    end
    object Memo1: TMemo
      Left = 872
      Top = 26
      Width = 353
      Height = 567
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Memo2: TMemo
      Left = 24
      Top = 16
      Width = 833
      Height = 217
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Here'#39's  problem #57 from Terry Stickels'#39' "Challenging Math Probl' +
          'ems" book.  "How many numbers less than '
        
          '1,000,000 have digits that sum to three? Examples: 1200,111000, ' +
          '21, 300".'
        'Three strategies for finding the solution are presented here:'
        ''
        
          '#1: The "Math" solution button explains how to find the total nu' +
          'mber without producing any of the values which '
        'make up the solution.'
        
          '#2: Not practical for us mere humans, generates all possible int' +
          'eger values from smallest (3) to largets'
        '(300,000) and filters out those whose digits do not sum to 3.'
        
          '#3: Implements an algorithm , described below, which is do-able ' +
          'by humans and generates all in-range '
        'integers whoise digits sum to three.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object AgorithmBtn: TButton
      Left = 16
      Top = 560
      Width = 793
      Height = 25
      Cursor = crDrag
      Caption = 
        '#3: Generate details for groups  by content: [3], [12], ,[21], [' +
        '111]'
      TabOrder = 3
      OnClick = AgorithmBtnClick
    end
    object Button1: TButton
      Left = 24
      Top = 248
      Width = 185
      Height = 25
      Caption = '#1: Math Solution'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Memo3: TMemo
      Left = 24
      Top = 304
      Width = 825
      Height = 241
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          '#3: One algorithm for generating the solution values is as follo' +
          'ws:'
        ''
        
          '> Consider the initial digit groups:"3","12","21" and "111".  Th' +
          'ese are the only digit sets that can sum to '
        'three. Call these Level 1 sets.'
        
          '> For each group create the next level set one digit longer by i' +
          'nserting a "0" after each non-zero digit in the '
        'previous level set'
        '> Discard any resutiung number which has already been generated.'
        '> Stop when the level set contains 6-digit numbers.'
        ''
        'To illustrate, here'#39's  "12" group (with duplicates removed):'
        'Level 1:12'
        'Level 2:102,120'
        'Level 3:1002, 1020, 1200'
        'Level 4:10002, 10020, 10200, 12000'
        'Level 5:100002,100020, 100200, 102000, 120000'
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 5
    end
  end
end
