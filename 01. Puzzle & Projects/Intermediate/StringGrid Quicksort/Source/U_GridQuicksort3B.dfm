object Form1: TForm1
  Left = 211
  Top = 139
  Width = 1011
  Height = 723
  Caption = 
    'StringGrid Sort Demo 3.0 (supports data types, sort direction, a' +
    'nd multi-column sorting)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object Label1: TLabel
    Left = 27
    Top = 288
    Width = 535
    Height = 24
    Caption = 'Click column headers from major to minor to select sort columns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 45
    Top = 180
    Width = 109
    Height = 55
    AutoSize = False
    Caption = 'Number of rows for random grid'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 549
    Top = 189
    Width = 128
    Height = 21
    Caption = 'Sort parameters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object SortTimeLbl: TLabel
    Left = 558
    Top = 513
    Width = 118
    Height = 18
    Caption = 'SortTime: 0.0 ms'
  end
  object StringGrid1: TStringGrid
    Left = 36
    Top = 324
    Width = 505
    Height = 289
    DefaultColWidth = 75
    DefaultDrawing = False
    RowCount = 10
    ScrollBars = ssVertical
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object RowsEdt: TEdit
    Left = 45
    Top = 234
    Width = 73
    Height = 24
    TabOrder = 1
    Text = '1,000'
  end
  object RowsUD: TUpDown
    Left = 118
    Top = 234
    Width = 10
    Height = 27
    Associate = RowsEdt
    Min = 2
    Max = 10000
    Position = 1000
    TabOrder = 2
  end
  object DataTypeGrp: TRadioGroup
    Left = 180
    Top = 189
    Width = 127
    Height = 91
    Caption = 'Data type'
    ItemIndex = 0
    Items.Strings = (
      'Alpha'
      'Integer'
      'Real')
    TabOrder = 3
    OnClick = DataTypeGrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 658
    Width = 993
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2002-2006, 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object Panel2: TPanel
    Left = 549
    Top = 216
    Width = 370
    Height = 271
    TabOrder = 5
    object Label4: TLabel
      Left = 81
      Top = 54
      Width = 54
      Height = 18
      Caption = 'Column'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 198
      Top = 54
      Width = 42
      Height = 18
      Caption = 'Order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 9
      Top = 72
      Width = 343
      Height = 37
      TabOrder = 0
      Visible = False
      OnEnter = Panel1Enter
      object Label3: TLabel
        Left = 9
        Top = 9
        Width = 49
        Height = 18
        Caption = 'Sort by'
      end
      object ComboBox1: TComboBox
        Left = 72
        Top = 5
        Width = 100
        Height = 26
        AutoDropDown = True
        AutoCloseUp = True
        Style = csDropDownList
        DropDownCount = 4
        ItemHeight = 18
        ItemIndex = 0
        TabOrder = 0
        Text = 'Column 2'
        Items.Strings = (
          'Column 2'
          'Column 3'
          'Column 4'
          'Column 5')
      end
      object ComboBox2: TComboBox
        Left = 189
        Top = 5
        Width = 100
        Height = 26
        AutoCloseUp = True
        Style = csDropDownList
        ItemHeight = 18
        ItemIndex = 0
        TabOrder = 1
        Text = 'Ascending'
        Items.Strings = (
          'Ascending'
          'Descending')
      end
    end
    object AddColBtn: TButton
      Left = 18
      Top = 9
      Width = 100
      Height = 28
      Caption = 'Add level'
      TabOrder = 1
      OnClick = AddColBtnClick
    end
    object DelColBtn: TButton
      Left = 198
      Top = 9
      Width = 100
      Height = 28
      Caption = 'Delete level'
      TabOrder = 2
      OnClick = DelColBtnClick
    end
    object SortBtn: TButton
      Left = 144
      Top = 234
      Width = 84
      Height = 28
      Caption = 'Sort'
      TabOrder = 3
      OnClick = SortBtnClick
    end
  end
  object SortGrp: TRadioGroup
    Left = 333
    Top = 189
    Width = 190
    Height = 91
    Caption = 'Sort Method'
    ItemIndex = 0
    Items.Strings = (
      'Shell Sort (Unstable)'
      'Quick Sort (Unstable)'
      'Merge Sort (Stable)')
    TabOrder = 6
  end
  object Memo1: TMemo
    Left = 18
    Top = 18
    Width = 928
    Height = 145
    Color = 14548991
    Lines.Strings = (
      
        'This version of the Grid Sort program explores multi-column sort' +
        'ing.   The straightforward, method, sorting one column at at tim' +
        'e from'
      
        'minor to majoir column, only works for "stable" sort algorithms.' +
        '  The key feature of a stable sort is that it  retains the origi' +
        'nal input'
      
        'order of records (rows) for equal values in the specified sort c' +
        'olumn. Most efficient sorting methods, including Shell sort and ' +
        'Quick '
      'sort '
      
        'implemented here,  are not stable and will not produce the expec' +
        'ted results if more than one sort column is speciifed..  However' +
        ' '
      'Merge '
      'Sort, implemented here, is stable and relatively efficient.'
      ''
      
        'Use the "Add Level" select a column and direction to sort.  Sele' +
        'ct a sort  column  entry and use the "Delete level" button to re' +
        'move it.'
      ''
      '')
    TabOrder = 7
  end
end
