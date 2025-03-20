object Form1: TForm1
  Left = 64
  Top = 73
  Width = 1171
  Height = 612
  Anchors = [akLeft, akTop, akRight, akBottom]
  Caption = 
    'Intersecting lines test  V3.1  (Adds buttons to compare results ' +
    'from DFF library functions "Intersect" and "LinesIntersect")'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object Image1: TImage
    Left = 16
    Top = 104
    Width = 593
    Height = 433
    OnClick = Image1Click
    OnMouseMove = Image1MouseMove
  end
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 481
    Height = 49
    AutoSize = False
    Caption = 
      'Click 4 points on image to define two lines to test             ' +
      'or enter 4 points in boxes at right and click "Check" button'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 568
    Top = 80
    Width = 38
    Height = 16
    Caption = 'Label2'
  end
  object Label3: TLabel
    Left = 688
    Top = 88
    Width = 51
    Height = 24
    Caption = 'Line 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 656
    Top = 120
    Width = 29
    Height = 24
    Caption = 'X1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 656
    Top = 152
    Width = 27
    Height = 24
    Caption = 'Y1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 656
    Top = 208
    Width = 27
    Height = 24
    Caption = 'Y2:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 656
    Top = 176
    Width = 29
    Height = 24
    Caption = 'X2:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 696
    Top = 248
    Width = 51
    Height = 24
    Caption = 'Line 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 664
    Top = 280
    Width = 29
    Height = 24
    Caption = 'X1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label10: TLabel
    Left = 664
    Top = 312
    Width = 27
    Height = 24
    Caption = 'Y1:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 664
    Top = 336
    Width = 29
    Height = 24
    Caption = 'X2:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label12: TLabel
    Left = 664
    Top = 368
    Width = 27
    Height = 24
    Caption = 'Y2:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label13: TLabel
    Left = 808
    Top = 40
    Width = 319
    Height = 16
    Caption = 'Previously checked lines.  Double click a line to replay '
  end
  object Label14: TLabel
    Left = 24
    Top = 80
    Width = 60
    Height = 19
    Caption = 'Label14'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label15: TLabel
    Left = 624
    Top = 456
    Width = 174
    Height = 16
    Caption = '"LinesIntersect" vs. :Intersect"'
  end
  object X11UD: TUpDown
    Left = 729
    Top = 112
    Width = 17
    Height = 24
    Associate = Edit1
    Max = 700
    Position = 341
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 688
    Top = 112
    Width = 41
    Height = 24
    TabOrder = 1
    Text = '341'
  end
  object Edit2: TEdit
    Left = 688
    Top = 144
    Width = 41
    Height = 24
    TabOrder = 2
    Text = '14'
  end
  object Y11UD: TUpDown
    Left = 729
    Top = 144
    Width = 17
    Height = 24
    Associate = Edit2
    Max = 700
    Position = 14
    TabOrder = 3
  end
  object Edit3: TEdit
    Left = 688
    Top = 176
    Width = 41
    Height = 24
    TabOrder = 4
    Text = '384'
  end
  object X12UD: TUpDown
    Left = 729
    Top = 176
    Width = 17
    Height = 24
    Associate = Edit3
    Max = 700
    Position = 384
    TabOrder = 5
  end
  object Edit4: TEdit
    Left = 688
    Top = 208
    Width = 41
    Height = 24
    TabOrder = 6
    Text = '255'
  end
  object Y12UD: TUpDown
    Left = 729
    Top = 208
    Width = 17
    Height = 24
    Associate = Edit4
    Max = 700
    Position = 255
    TabOrder = 7
  end
  object Edit5: TEdit
    Left = 696
    Top = 272
    Width = 41
    Height = 24
    TabOrder = 8
    Text = '402'
  end
  object X21Ud: TUpDown
    Left = 737
    Top = 272
    Width = 17
    Height = 24
    Associate = Edit5
    Max = 700
    Position = 402
    TabOrder = 9
  end
  object Edit6: TEdit
    Left = 696
    Top = 304
    Width = 41
    Height = 24
    TabOrder = 10
    Text = '174'
  end
  object Y21UD: TUpDown
    Left = 737
    Top = 304
    Width = 17
    Height = 24
    Associate = Edit6
    Max = 700
    Position = 174
    TabOrder = 11
  end
  object Edit7: TEdit
    Left = 696
    Top = 336
    Width = 41
    Height = 24
    TabOrder = 12
    Text = '369'
  end
  object X22UD: TUpDown
    Left = 737
    Top = 336
    Width = 17
    Height = 24
    Associate = Edit7
    Max = 700
    Position = 369
    TabOrder = 13
  end
  object Edit8: TEdit
    Left = 696
    Top = 368
    Width = 41
    Height = 24
    TabOrder = 14
    Text = '181'
  end
  object Y22UD: TUpDown
    Left = 737
    Top = 368
    Width = 17
    Height = 24
    Associate = Edit8
    Max = 700
    Position = 181
    TabOrder = 15
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 552
    Width = 1155
    Height = 24
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  '#169' 2005, 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 16
    OnClick = StaticText1Click
  end
  object CheckBtn: TButton
    Left = 624
    Top = 408
    Width = 169
    Height = 25
    Caption = 'Check'
    TabOrder = 17
    OnClick = CheckBtnClick
  end
  object RandomTestBtn: TButton
    Left = 624
    Top = 472
    Width = 177
    Height = 25
    Caption = 'Check 1M random line pairs'
    TabOrder = 18
    OnClick = RandomTestBtnClick
  end
  object ListBox1: TListBox
    Left = 808
    Top = 64
    Width = 329
    Height = 433
    ItemHeight = 16
    TabOrder = 19
    OnDblClick = Memo1DblClick
    OnKeyUp = ListBox1KeyUp
  end
  object Button1: TButton
    Left = 624
    Top = 504
    Width = 177
    Height = 25
    Caption = 'Compare current lines'
    TabOrder = 20
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 816
    Top = 504
    Width = 193
    Height = 25
    Caption = 'Clear check lines list'
    TabOrder = 21
    OnClick = Button2Click
  end
end
