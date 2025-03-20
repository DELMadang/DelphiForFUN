object VerboseForm: TVerboseForm
  Left = 254
  Top = 227
  Width = 682
  Height = 516
  Caption = 'VerboseForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 224
    Top = 16
    Width = 95
    Height = 13
    Caption = 'Latest Guess results'
  end
  object Label2: TLabel
    Left = 8
    Top = 16
    Width = 43
    Height = 13
    Caption = 'Summary'
  end
  object ListBox1: TListBox
    Left = 256
    Top = 40
    Width = 409
    Height = 417
    ItemHeight = 13
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 233
    Height = 281
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 24
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Hide'
    TabOrder = 2
    OnClick = Button1Click
  end
end
