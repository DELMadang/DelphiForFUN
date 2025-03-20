object Form1: TForm1
  Left = -4
  Top = -4
  Width = 808
  Height = 608
  Caption = 'Genaille'#39's Multiplying Rods'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 24
    Top = 336
    Width = 45
    Height = 26
    Caption = 'Font size (0=Auto)'
    WordWrap = True
  end
  object Image1: TImage
    Left = 234
    Top = 42
    Width = 319
    Height = 339
    Constraints.MaxHeight = 2000
    IncrementalDisplay = True
  end
  object BarSizeBox: TGroupBox
    Left = 23
    Top = 181
    Width = 162
    Height = 140
    Caption = 'Rod Size (pixels)'
    TabOrder = 0
    object Label3: TLabel
      Left = 20
      Top = 26
      Width = 51
      Height = 13
      Caption = 'Rod Width'
    end
    object Label4: TLabel
      Left = 20
      Top = 59
      Width = 74
      Height = 13
      Caption = 'Unit Box Height'
    end
    object BarSizeLbl: TLabel
      Left = 20
      Top = 91
      Width = 111
      Height = 40
      AutoSize = False
      Caption = 'BarSizeLbl'
      WordWrap = True
    end
    object BarWidthUpDn: TUpDown
      Left = 129
      Top = 24
      Width = 12
      Height = 21
      Associate = BarWidthEdt
      Min = 0
      Position = 40
      TabOrder = 0
      Wrap = False
    end
    object BarHeightUpDn: TUpDown
      Left = 129
      Top = 56
      Width = 12
      Height = 21
      Associate = BarHeightEdt
      Min = 0
      Position = 24
      TabOrder = 1
      Wrap = False
    end
    object BarHeightEdt: TEdit
      Left = 104
      Top = 56
      Width = 25
      Height = 21
      TabOrder = 2
      Text = '24'
    end
    object BarWidthEdt: TEdit
      Left = 104
      Top = 24
      Width = 25
      Height = 21
      TabOrder = 3
      Text = '40'
    end
  end
  object DrawItBtn: TButton
    Left = 24
    Top = 387
    Width = 109
    Height = 25
    Caption = 'Draw it'
    TabOrder = 1
    OnClick = DrawItBtnClick
  end
  object PrintBtn: TButton
    Left = 24
    Top = 424
    Width = 109
    Height = 25
    Caption = 'Print full rod set'
    TabOrder = 2
    OnClick = PrintBtnClick
  end
  object FontSizeEdt: TEdit
    Left = 88
    Top = 336
    Width = 25
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object FontsizeUpDn: TUpDown
    Left = 113
    Top = 336
    Width = 12
    Height = 21
    Associate = FontSizeEdt
    Min = 0
    Max = 24
    Position = 0
    TabOrder = 4
    Wrap = False
  end
  object BkgndBtn: TButton
    Left = 24
    Top = 464
    Width = 109
    Height = 25
    Caption = 'Background Info'
    TabOrder = 5
    OnClick = BkgndBtnClick
  end
  object SampleBtn: TButton
    Left = 24
    Top = 504
    Width = 109
    Height = 25
    Caption = 'Usage sample'
    TabOrder = 6
    OnClick = SampleBtnClick
    OnExit = SampleBtnExit
  end
  object Usagememo2: TMemo
    Left = 232
    Top = 472
    Width = 385
    Height = 81
    Lines.Strings = (
      
        'Now, starting at the right-most rod, the "3" rod,  move down to ' +
        'the "4'#39' row '
      
        '(indicated by the index rod).  The topmost number at this inters' +
        'ection point is "2" '
      
        'and is the rightmost number in the answer.  Now starting with th' +
        'is position, simply '
      'follow the "arrows" to the left to produce the answer,  34252.'
      ' ')
    TabOrder = 7
    Visible = False
  end
  object UsageMemo1: TMemo
    Left = 232
    Top = 16
    Width = 425
    Height = 73
    Lines.Strings = (
      
        'To use Genaille'#39's Rods to multiply, print a set of rods on havy ' +
        'paper and cut them into '
      'separate strips. '
      ''
      
        'Here'#39's an example of how to multiply 8563 by 4.  First, arrange ' +
        'the Index, 8,5,6 and 3 '
      'rods from left to right. ')
    TabOrder = 8
    Visible = False
  end
  object RodRadioGrp: TRadioGroup
    Left = 24
    Top = 8
    Width = 161
    Height = 73
    Caption = 'Digit (which rod)'
    ItemIndex = 1
    Items.Strings = (
      'Single  rod for #'
      'All rods (0-9)')
    TabOrder = 9
  end
  object DigitEdt: TEdit
    Left = 144
    Top = 32
    Width = 17
    Height = 21
    TabOrder = 10
    Text = '4'
  end
  object DigitUpDn: TUpDown
    Left = 161
    Top = 32
    Width = 12
    Height = 21
    Associate = DigitEdt
    Min = 0
    Max = 9
    Position = 4
    TabOrder = 11
    Wrap = False
  end
  object IndexRadioGrp: TRadioGroup
    Left = 24
    Top = 96
    Width = 161
    Height = 73
    Caption = 'Index (vertical position)'
    ItemIndex = 1
    Items.Strings = (
      'Single box for #'
      'All boxes (1-9)')
    TabOrder = 12
  end
  object IndexEdt: TEdit
    Left = 144
    Top = 112
    Width = 17
    Height = 21
    TabOrder = 13
    Text = '5'
  end
  object IndexUpDn: TUpDown
    Left = 161
    Top = 112
    Width = 12
    Height = 21
    Associate = IndexEdt
    Min = 0
    Max = 9
    Position = 5
    TabOrder = 14
    Wrap = False
  end
  object PrintDialog1: TPrintDialog
    Left = 664
  end
end
