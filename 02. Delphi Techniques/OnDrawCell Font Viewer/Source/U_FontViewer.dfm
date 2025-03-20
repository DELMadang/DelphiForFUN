object Form1: TForm1
  Left = 64
  Top = 33
  Width = 640
  Height = 480
  Caption = 'FontViewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 224
    Width = 24
    Height = 13
    Caption = 'Font:'
  end
  object FontLbl: TLabel
    Left = 16
    Top = 240
    Width = 33
    Height = 20
    Caption = 'xxxx'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StringGrid1: TStringGrid
    Left = 224
    Top = 8
    Width = 385
    Height = 433
    ColCount = 17
    DefaultColWidth = 20
    DefaultDrawing = False
    RowCount = 17
    TabOrder = 0
    OnDrawCell = StringGrid1DrawCell
  end
  object FontBtn: TButton
    Left = 16
    Top = 296
    Width = 81
    Height = 25
    Caption = 'Select a Font'
    TabOrder = 1
    OnClick = FontBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 185
    Height = 177
    Color = clYellow
    Lines.Strings = (
      'Select a font to see all 256 of it'#39's '
      'characters.   '
      ''
      'Characters are identified by '
      'hexadecimal representation 00-FF.  '
      'Columns are  labeled with the units '
      'digit and rows with the "16'#39's" digit.'
      '  '
      'For example, in most fonts the '
      'letter A is character number hex 41 '
      '(decimal 65) and appears in the row '
      'labeled 4 and the column labeled 1.'
      '  ')
    TabOrder = 2
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Options = [fdForceFontExist]
    Left = 192
    Top = 8
  end
end
