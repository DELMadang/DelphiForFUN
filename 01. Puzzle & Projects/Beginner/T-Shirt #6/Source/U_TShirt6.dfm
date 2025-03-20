object Form1: TForm1
  Left = 316
  Top = 122
  Width = 390
  Height = 373
  Caption = 'T-Shirt #6'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 224
    Height = 60
    Caption = 
      'Find numbers with the sum of Nth powers of its digits equal to t' +
      'he number'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 24
    Top = 232
    Width = 18
    Height = 20
    Caption = 'N:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 248
    Top = 104
    Width = 121
    Height = 201
    ItemHeight = 13
    TabOrder = 0
  end
  object SpinEdit1: TSpinEdit
    Left = 56
    Top = 232
    Width = 49
    Height = 22
    MaxValue = 8
    MinValue = 1
    TabOrder = 1
    Value = 6
  end
  object Button1: TButton
    Left = 24
    Top = 272
    Width = 81
    Height = 25
    Caption = 'Search'
    TabOrder = 2
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 320
    Width = 382
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 104
    Width = 201
    Height = 113
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'There is only one  positive '
      'integer with the sum of the 6th '
      'powers of its digits equal to the '
      'number.  '
      ''
      'What is the number?')
    ParentFont = False
    TabOrder = 4
  end
end
