object Form1: TForm1
  Left = 316
  Top = 256
  Width = 1129
  Height = 767
  Caption = 'String and Integer lists timimg tests'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 699
    Width = 1111
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2014, Gary Darby,  www.DelphiForFun.org'
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
    Width = 1111
    Height = 699
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 48
      Top = 480
      Width = 57
      Height = 41
      AutoSize = False
      Caption = 'Entry size'
      WordWrap = True
    end
    object String1Btn: TButton
      Tag = 1
      Left = 48
      Top = 576
      Width = 561
      Height = 25
      Caption = 'Test Stringlist (Build sorted) '
      TabOrder = 0
      OnClick = StringBtnClick
    end
    object Memo1: TMemo
      Left = 40
      Top = 24
      Width = 569
      Height = 449
      Color = 14548991
      Lines.Strings = (
        'This program runs timing tests for two list types: the'
        'standard TStringlist Delphi type and DFF TIntList type '
        'which has most TStringList methods but with 64 bit '
        'integer keys.'
        ''
        'Each test builds the specified number (Nbr Entries) of '
        'random records of the specified length and then '
        'randomly retrieves records with two different strategies.  '
        'Multiple trials can be run with a single button click and '
        'results are displayed at right.'
        ''
        'From my testing, I have concluded that the Delphi 7 version '
        'of this program populates an integer list 30 times faster than '
        'for a string list of the same size. It  also randomly retrieves '
        'integer records 2 or 3 time faster than string records.'
        ''
        'When the program is compiled under Delphi XE, string lists '
        'are built 2 or 3 times faster than in Delphi 7. Integer lists '
        'have exactly the same code under XE are built at about the '
        'same speed as under D7 and are therefore "only" about 10 '
        
          'times faster than string lists. Random retrievals of string list' +
          ' '
        'records in XE are also several times faster than string list '
        'records under Delphi 7.'
        ''
        ''
        ''
        '')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object IntBtn: TButton
      Left = 48
      Top = 624
      Width = 553
      Height = 25
      Caption = 'Test Intlist'
      TabOrder = 2
      OnClick = IntBtnClick
    end
    object NbrEntriesEdt: TLabeledEdit
      Left = 120
      Top = 529
      Width = 97
      Height = 31
      EditLabel.Width = 96
      EditLabel.Height = 46
      EditLabel.Caption = 'List entries per trial'
      EditLabel.WordWrap = True
      TabOrder = 3
      Text = '100000'
    end
    object NbrTrialsEdt: TLabeledEdit
      Left = 240
      Top = 529
      Width = 41
      Height = 31
      EditLabel.Width = 47
      EditLabel.Height = 46
      EditLabel.Caption = 'Nbr Trials'
      EditLabel.WordWrap = True
      TabOrder = 4
      Text = '3'
    end
    object Memo2: TMemo
      Left = 640
      Top = 24
      Width = 449
      Height = 625
      Lines.Strings = (
        '')
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object EntrysizeEdt: TSpinEdit
      Left = 48
      Top = 528
      Width = 49
      Height = 34
      MaxValue = 20
      MinValue = 1
      TabOrder = 6
      Value = 6
    end
    object SearchGrp: TRadioGroup
      Left = 312
      Top = 488
      Width = 297
      Height = 73
      Caption = 'Random search options'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Within existing entries (100%hits)'
        'Up to max entry size (<100% hits)')
      ParentFont = False
      TabOrder = 7
    end
  end
end
