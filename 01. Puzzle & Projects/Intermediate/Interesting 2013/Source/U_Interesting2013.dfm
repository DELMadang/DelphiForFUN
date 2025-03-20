object Form1: TForm1
  Left = 423
  Top = 164
  ActiveControl = NbrConsecUD
  AutoScroll = False
  Caption = 'Interesting 2013 Version 2.1'
  ClientHeight = 743
  ClientWidth = 1014
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 18
  object Label3: TLabel
    Left = 144
    Top = 160
    Width = 225
    Height = 23
    Caption = 'National Post 2013 article'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label3Click
  end
  object Label7: TLabel
    Left = 464
    Top = 160
    Width = 287
    Height = 23
    Caption = 'DFF "Interesting 2013" webpage'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label7Click
  end
  object RichEdit1: TRichEdit
    Left = 16
    Top = 8
    Width = 961
    Height = 145
    Color = 14548991
    Lines.Strings = (
      
        'This program checks two claims made about interesting properties' +
        ' of the year 2013 made in a January 1st article in the Canadian '
      'newspaper, the National  Post.'
      ''
      
        '1. 2013 has three prime factors.  So does 2014 and 2015.  The ne' +
        'xt time that this occurs is in year 2665!'
      
        '2. 2013 is the smallest number requiring at least 6 squared numb' +
        'ers added or subtracted to equal its value.'
      ''
      
        'Are they true? 1). Almost and 2.) Not even close!  (see links be' +
        'low for more information ).')
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 720
    Width = 1014
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, 2013 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo2: TMemo
    Left = 368
    Top = 192
    Width = 633
    Height = 465
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Results display here')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 24
    Top = 192
    Width = 321
    Height = 201
    Color = clMoneyGreen
    TabOrder = 2
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 54
      Height = 18
      Caption = 'Analyze'
    end
    object Label2: TLabel
      Left = 136
      Top = 24
      Width = 73
      Height = 18
      Caption = 'years from'
    end
    object Label4: TLabel
      Left = 16
      Top = 61
      Width = 72
      Height = 18
      Caption = 'looking for'
    end
    object Label5: TLabel
      Left = 136
      Top = 64
      Width = 163
      Height = 18
      Caption = 'consecutive years  with '
    end
    object Label6: TLabel
      Left = 16
      Top = 88
      Width = 236
      Height = 18
      Caption = 'the same number of prime factors.'
    end
    object Case1Btn: TButton
      Left = 56
      Top = 160
      Width = 169
      Height = 25
      Caption = 'Case 1 Search'
      TabOrder = 0
      OnClick = Case1BtnClick
    end
    object NbryearsUD: TSpinEdit
      Left = 64
      Top = 19
      Width = 65
      Height = 28
      Color = clWhite
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 1000
    end
    object StartYearUD: TSpinEdit
      Left = 224
      Top = 16
      Width = 65
      Height = 28
      Color = clWhite
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 2013
    end
    object NbrConsecUD: TSpinEdit
      Left = 96
      Top = 56
      Width = 41
      Height = 28
      Color = clWhite
      MaxValue = 0
      MinValue = 0
      TabOrder = 3
      Value = 3
    end
    object UniqueBox: TCheckBox
      Left = 8
      Top = 112
      Width = 249
      Height = 49
      Caption = 'Factors of each year value must be unique (no duplicates)'
      TabOrder = 4
      WordWrap = True
    end
  end
  object Panel2: TPanel
    Left = 24
    Top = 400
    Width = 329
    Height = 297
    Color = clSkyBlue
    TabOrder = 3
    object Label10: TLabel
      Left = 0
      Top = 13
      Width = 140
      Height = 18
      Caption = 'Analyze the year (Y) '
    end
    object Label11: TLabel
      Left = 8
      Top = 96
      Width = 305
      Height = 73
      AutoSize = False
      Caption = 
        'A. What is the shortest expression made up of sums and differenc' +
        'es of prime squares and evaluating to the given Y?   (1st 10 of ' +
        'each length from 1 to 6 are displayed)'
      WordWrap = True
    end
    object Label8: TLabel
      Left = 16
      Top = 216
      Width = 299
      Height = 41
      AutoSize = False
      Caption = 
        'B. What is the smallest year  >= Y  requiring each term count fr' +
        'om 1 to 6?'
      WordWrap = True
    end
    object Case2ABtn: TButton
      Left = 56
      Top = 176
      Width = 177
      Height = 25
      Caption = 'Case 2A Search'
      TabOrder = 0
      OnClick = Case2ABtnClick
    end
    object StartYear2UD: TSpinEdit
      Left = 152
      Top = 8
      Width = 65
      Height = 28
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 2013
    end
    object Case2BBtn: TButton
      Left = 56
      Top = 256
      Width = 177
      Height = 25
      Caption = 'Case 2B Search'
      TabOrder = 2
      OnClick = Case2BBtnClick
    end
    object TermMultGrp: TRadioGroup
      Left = 8
      Top = 48
      Width = 249
      Height = 41
      Caption = 'Maximum  term value'
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'Year (Y)'
        '2 x Year ( Y)')
      TabOrder = 3
    end
  end
  object Memo1: TMemo
    Left = 192
    Top = 72
    Width = 1
    Height = 17
    Lines.Strings = (
      'M'
      'e'
      'm'
      'o'
      '1')
    TabOrder = 5
  end
end
