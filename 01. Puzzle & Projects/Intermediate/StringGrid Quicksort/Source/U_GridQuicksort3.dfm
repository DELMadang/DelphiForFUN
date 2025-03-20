object Form1: TForm1
  Left = 211
  Top = 139
  Width = 875
  Height = 613
  Caption = 
    'StringGrid Sort Demo 3.0 (supports data types, sort direction, a' +
    'nd multi-column sorting)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 256
    Width = 448
    Height = 20
    Caption = 'Click column headers from major to minor to select sort columns'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 40
    Top = 160
    Width = 97
    Height = 49
    AutoSize = False
    Caption = 'Number of rows for random grid'
    WordWrap = True
  end
  object Label6: TLabel
    Left = 488
    Top = 176
    Width = 113
    Height = 18
    Caption = 'Sort parameters'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object SortTimeLbl: TLabel
    Left = 496
    Top = 504
    Width = 100
    Height = 16
    Caption = 'SortTime: 0.0 ms'
  end
  object Label7: TLabel
    Left = 488
    Top = 200
    Width = 321
    Height = 41
    AutoSize = False
    Caption = 
      'Hint:  Integer data type generates more equal keys for testing m' +
      'ulti-column sorts'
    WordWrap = True
  end
  object StringGrid1: TStringGrid
    Left = 32
    Top = 288
    Width = 449
    Height = 257
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
    Left = 40
    Top = 208
    Width = 65
    Height = 24
    TabOrder = 1
    Text = '1,000'
  end
  object RowsUD: TUpDown
    Left = 105
    Top = 208
    Width = 9
    Height = 24
    Associate = RowsEdt
    Min = 2
    Max = 10000
    Position = 1000
    TabOrder = 2
  end
  object DataTypeGrp: TRadioGroup
    Left = 160
    Top = 168
    Width = 113
    Height = 81
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
    Top = 560
    Width = 859
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2002-2006, 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object Panel2: TPanel
    Left = 488
    Top = 240
    Width = 329
    Height = 241
    BorderStyle = bsSingle
    Color = 14023069
    TabOrder = 5
    object Label4: TLabel
      Left = 72
      Top = 48
      Width = 49
      Height = 16
      Caption = 'Column'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 176
      Top = 48
      Width = 36
      Height = 16
      Caption = 'Order'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 8
      Top = 64
      Width = 305
      Height = 33
      TabOrder = 0
      Visible = False
      OnEnter = Panel1Enter
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 42
        Height = 16
        Caption = 'Sort by'
      end
      object ComboBox1: TComboBox
        Left = 64
        Top = 4
        Width = 89
        Height = 24
        AutoDropDown = True
        AutoCloseUp = True
        Style = csDropDownList
        DropDownCount = 4
        ItemHeight = 16
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
        Left = 168
        Top = 4
        Width = 89
        Height = 24
        AutoCloseUp = True
        Style = csDropDownList
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 1
        Text = 'Ascending'
        Items.Strings = (
          'Ascending'
          'Descending')
      end
    end
    object AddColBtn: TButton
      Left = 16
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Add level'
      TabOrder = 1
      OnClick = AddColBtnClick
    end
    object DelColBtn: TButton
      Left = 176
      Top = 8
      Width = 89
      Height = 25
      Caption = 'Delete level'
      TabOrder = 2
      OnClick = DelColBtnClick
    end
    object SortBtn: TButton
      Left = 128
      Top = 208
      Width = 75
      Height = 25
      Caption = 'Sort'
      TabOrder = 3
      OnClick = SortBtnClick
    end
  end
  object SortGrp: TRadioGroup
    Left = 296
    Top = 168
    Width = 169
    Height = 81
    Caption = 'Sort Method'
    ItemIndex = 0
    Items.Strings = (
      'Shell Sort (Unstable)'
      'Quick Sort (Unstable)'
      'Merge Sort (Stable)')
    TabOrder = 6
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 825
    Height = 129
    Color = 14548991
    Lines.Strings = (
      
        'This version of the Grid Sort program explores multi-column sort' +
        'ing.   The straightforward, method, sorting one column at at tim' +
        'e from'
      
        'minor to majoir column, only works for "stable" sort algorithms.' +
        '  A stable sort is one that retains the original input order of ' +
        'records (rows) for '
      
        'equal values in the specified sort column. Most efficient sortin' +
        'g methods, including Shell sort and Quick sort implemented here,' +
        '  are not '
      
        'stable and will not produce the expected results if more than on' +
        'e sort column is speciifed..  However Merge Sort, implemented he' +
        're, is '
      'stable and relatively efficient.'
      ''
      
        'Use the "Add Level" select a column and direction to sort.  Sele' +
        'ct a sort  column  entry and use the "Delete level" button to re' +
        'move it.'
      ''
      '')
    TabOrder = 7
  end
end
