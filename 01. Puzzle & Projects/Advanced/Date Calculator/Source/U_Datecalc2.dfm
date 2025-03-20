object Form1: TForm1
  Left = 756
  Top = 124
  AutoScroll = False
  AutoSize = True
  Caption = 'Date calculator (Emulates W7 Date Calculator)'
  ClientHeight = 465
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 425
    Color = clCream
    TabOrder = 1
    object Label1: TLabel
      Left = 33
      Top = 25
      Width = 230
      Height = 16
      Caption = 'Select the date calculation you want '
    end
    object AddSubPanel: TPanel
      Left = 24
      Top = 104
      Width = 481
      Height = 201
      Color = clCream
      TabOrder = 3
      object Label3: TLabel
        Left = 17
        Top = 25
        Width = 33
        Height = 16
        Caption = 'From'
      end
      object Label8: TLabel
        Left = 17
        Top = 129
        Width = 30
        Height = 16
        Caption = 'Date'
        ShowAccelChar = False
      end
      object Label7: TLabel
        Left = 17
        Top = 80
        Width = 46
        Height = 16
        Caption = 'Year(s)'
      end
      object Label9: TLabel
        Left = 176
        Top = 80
        Width = 56
        Height = 16
        Caption = 'Month(s)'
      end
      object Label10: TLabel
        Left = 320
        Top = 80
        Width = 42
        Height = 16
        Caption = 'Day(s)'
      end
      object DiffdatePicker: TDateTimePicker
        Left = 57
        Top = 17
        Width = 120
        Height = 24
        Date = 41352.578630590280000000
        Time = 41352.578630590280000000
        TabOrder = 0
        OnChange = DiffdataChange
      end
      object DateDiffEdt: TEdit
        Left = 17
        Top = 153
        Width = 449
        Height = 24
        Color = 15461355
        ReadOnly = True
        TabOrder = 1
      end
      object Addbtn: TRadioButton
        Left = 216
        Top = 24
        Width = 65
        Height = 17
        Caption = 'Add'
        Checked = True
        TabOrder = 2
        TabStop = True
      end
      object SubtractBtn: TRadioButton
        Left = 328
        Top = 24
        Width = 97
        Height = 17
        Caption = 'Subtract'
        TabOrder = 3
      end
      object YearsEdt: TSpinEdit
        Left = 88
        Top = 72
        Width = 57
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 4
        Value = 15
        OnChange = DiffdataChange
      end
      object MonthsEdt: TSpinEdit
        Left = 240
        Top = 72
        Width = 57
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 5
        Value = 11
        OnChange = DiffdataChange
      end
      object DaysEdt: TSpinEdit
        Left = 368
        Top = 72
        Width = 57
        Height = 26
        MaxValue = 0
        MinValue = 0
        TabOrder = 6
        Value = 20
        OnChange = DiffdataChange
      end
    end
    object DiffPanel: TPanel
      Left = 24
      Top = 96
      Width = 497
      Height = 209
      Color = clCream
      TabOrder = 2
      object Label2: TLabel
        Left = 9
        Top = 25
        Width = 33
        Height = 16
        Caption = 'From'
      end
      object Label5: TLabel
        Left = 9
        Top = 65
        Width = 253
        Height = 16
        Caption = 'Difference (years, months, weeks, days)'
      end
      object Label6: TLabel
        Left = 9
        Top = 129
        Width = 109
        Height = 16
        Caption = 'Difference (days)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ShowAccelChar = False
      end
      object Label4: TLabel
        Left = 281
        Top = 25
        Width = 15
        Height = 16
        Caption = 'To'
      end
      object FromDate: TDateTimePicker
        Left = 49
        Top = 17
        Width = 120
        Height = 24
        Date = 41352.000000000000000000
        Time = 41352.000000000000000000
        TabOrder = 0
        OnChange = DateDataChange
      end
      object YMWDDiffsEdt: TEdit
        Left = 9
        Top = 89
        Width = 449
        Height = 24
        Color = 15461355
        ReadOnly = True
        TabOrder = 1
      end
      object DaysDiffEdt: TEdit
        Left = 9
        Top = 153
        Width = 449
        Height = 24
        Color = 15461355
        ReadOnly = True
        TabOrder = 2
      end
      object Todate: TDateTimePicker
        Left = 305
        Top = 17
        Width = 112
        Height = 24
        Date = 35519.578630590280000000
        Time = 35519.578630590280000000
        TabOrder = 3
        OnChange = DateDataChange
      end
    end
    object CalcType: TComboBox
      Left = 33
      Top = 57
      Width = 440
      Height = 24
      Style = csDropDownList
      DropDownCount = 2
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 0
      Text = 'Calculate the difference between two dates'
      OnClick = CalcTypeClick
      Items.Strings = (
        'Calculate the difference between two dates'
        'Add or subtract days to a specific date')
    end
    object CalcBtn: TButton
      Left = 440
      Top = 312
      Width = 91
      Height = 25
      Caption = 'Calculate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = CalcBtnClick
    end
    object TestBtn: TButton
      Left = 32
      Top = 392
      Width = 201
      Height = 25
      Caption = 'Test random date pairs'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowFrame
      Font.Height = -14
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = TestBtnClick
    end
    object Memo1: TMemo
      Left = 32
      Top = 312
      Width = 329
      Height = 81
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowFrame
      Font.Height = -14
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'For debugging: Generate 1000 random date pairs, '
        'calculate year, month, day differences, then '
        'recalculate Date2 from Date1 plus  Y, M, D values '
        'and display differences greater than specified amount.')
      ParentFont = False
      TabOrder = 5
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 432
    Width = 521
    Height = 33
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
end
