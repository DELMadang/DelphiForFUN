object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Reverse Coins V2.0'
  ClientHeight = 643
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = ResetBtnClick
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
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
    Width = 888
    Height = 620
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 512
      Top = 64
      Width = 182
      Height = 19
      Caption = 'Number of coins(3 to 10)'
    end
    object Label2: TLabel
      Left = 512
      Top = 136
      Width = 354
      Height = 19
      Caption = 'Number to reverse for each turn (2 to # of coins)'
    end
    object Proto: TLabel
      Left = 504
      Top = 328
      Width = 17
      Height = 27
      Caption = 'H'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = ProtoClick
    end
    object Label3: TLabel
      Left = 504
      Top = 256
      Width = 261
      Height = 19
      Caption = 'Click letters to select coins to flip'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 504
      Top = 276
      Width = 334
      Height = 19
      Caption = 'Flip will occur when 5 have been selected  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 504
      Top = 296
      Width = 308
      Height = 19
      Caption = 'Reclick a selected letter to unselect it.  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 504
      Top = 216
      Width = 240
      Height = 24
      Caption = 'Change all Heads to Tails'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic, fsUnderline]
      ParentFont = False
    end
    object Memo1: TMemo
      Left = 24
      Top = 54
      Width = 449
      Height = 387
      Color = 14548991
      Lines.Strings = (
        'The objective of this puzzle is to reverse a set of coins '
        'showing all heads so that they show all tails.  For each '
        'move, two or more coins must be reversed (from Heads '
        'to Tails or Tails to Heads). The number of coins and the '
        'number which must be reversed for each move are '
        'specified at right.'
        ''
        'In this version, the coins are represented by a row of "H" '
        'or "T" characters.  To solve the problem yourself, click '
        'on the each coin to be flipped in the current turn. '
        'Selected coins will display in red.  When the correct '
        'number have been selelected, those coins will be '
        'automatically be reversed.'
        ''
        'Click the "Search" button to start a program search for '
        'solutions.  Not all combinations of coin counts and '
        'number to be reversed per move are solvable.  The '
        'program will try up to 100,000 moves before giving up.')
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object NbrCoinsEdt: TSpinEdit
      Left = 512
      Top = 88
      Width = 57
      Height = 29
      MaxValue = 10
      MinValue = 3
      TabOrder = 1
      Value = 7
      OnChange = NbrCoinsEdtChange
    end
    object NbrReverseEdt: TSpinEdit
      Left = 512
      Top = 160
      Width = 57
      Height = 29
      MaxValue = 7
      MinValue = 2
      TabOrder = 2
      Value = 5
      OnChange = NbrReverseEdtChange
    end
    object ResetBtn: TButton
      Left = 500
      Top = 371
      Width = 117
      Height = 29
      Caption = 'Reset coins'
      TabOrder = 3
      OnClick = ResetBtnClick
    end
    object GroupBox1: TGroupBox
      Left = 512
      Top = 424
      Width = 345
      Height = 185
      Caption = 'Program search'
      Color = 15530727
      ParentColor = False
      TabOrder = 4
      object NbrSolutionsGrp: TRadioGroup
        Left = 72
        Top = 24
        Width = 193
        Height = 105
        Caption = 'Solutions to show'
        ItemIndex = 0
        Items.Strings = (
          'Shortest  solution'
          'First 10 solutions'
          'First 100 solutions')
        TabOrder = 0
      end
      object SearchBtn: TButton
        Left = 68
        Top = 140
        Width = 205
        Height = 29
        Caption = 'Search for solutions'
        TabOrder = 1
        OnClick = SearchBtnClick
      end
    end
  end
end
