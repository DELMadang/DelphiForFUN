object Form1: TForm1
  Left = 189
  Top = 130
  Width = 800
  Height = 597
  Caption = 'Test TRod and TDisplayPattern components'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 416
    Top = 8
    Width = 361
    Height = 65
  end
  object Image2: TImage
    Left = 16
    Top = 8
    Width = 241
    Height = 49
  end
  object Label1: TLabel
    Left = 16
    Top = 152
    Width = 185
    Height = 33
    AutoSize = False
    Caption = 
      '(Multiple clicks ==> multiple rods displayed in the scroll box a' +
      ' right)'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 248
    Top = 512
    Width = 85
    Height = 13
    Caption = 'Alllocated memory'
  end
  object DrawRodsBtn: TButton
    Left = 264
    Top = 24
    Width = 137
    Height = 25
    Caption = 'Draw 2 random rods'
    TabOrder = 0
    OnClick = DrawRodsBtnClick
  end
  object StockDisplayBtn: TButton
    Left = 16
    Top = 120
    Width = 185
    Height = 25
    Caption = 'Test "CuttingStock" results display'
    TabOrder = 1
    OnClick = StockDisplayBtnClick
  end
  object ScrollBox1: TScrollBox
    Left = 240
    Top = 96
    Width = 537
    Height = 401
    HorzScrollBar.Visible = False
    TabOrder = 2
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 513
      Height = 121
      TabOrder = 0
      Visible = False
      object Image3: TImage
        Left = 24
        Top = 24
        Width = 481
        Height = 65
      end
      object Label4: TLabel
        Left = 24
        Top = 8
        Width = 53
        Height = 13
        Caption = 'Pattern # 1'
      end
      object Label5: TLabel
        Left = 24
        Top = 96
        Width = 67
        Height = 13
        Caption = 'Number to cut'
      end
    end
  end
  object ClearBtn: TButton
    Left = 16
    Top = 232
    Width = 185
    Height = 25
    Caption = 'Clear  display'
    TabOrder = 3
    OnClick = ClearBtnClick
  end
  object Panel2: TPanel
    Left = 16
    Top = 192
    Width = 185
    Height = 33
    TabOrder = 4
    object ChooseColorBtn: TButton
      Left = 16
      Top = 8
      Width = 129
      Height = 17
      Caption = 'Set next pattern color'
      TabOrder = 0
      OnClick = ChooseColorBnClick
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 272
    Width = 217
    Height = 257
    Lines.Strings = (
      'This is a test program for displays to be'
      'used in an upcoming "Cutting Stock" '
      'program.  A TRod componenent draws a 3D '
      'view of a rod, (or pipe or wire) with the '
      'cutting pattern identified and labeled.  The '
      'TDisplayPattern combines TRod with a '
      'couple of TLabel components to display '
      '"Pattern id" and "Number to be cut".'
      ''
      'The 1-dimensional "Cutting Stock" problem '
      'uses a set of required part lengths and '
      'quantities, together with a set of available '
      'stock lengths and costs, and calculates the '
      'most economical cutting protocol.  '
      ''
      'The controls tested here will be used to '
      'display the results. The results here are '
      'randomly generated and do not represent an '
      'actual problem.'
      ' ')
    TabOrder = 5
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 792
    Height = 17
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 6
    OnClick = StaticText1Click
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 208
    Top = 72
  end
end
