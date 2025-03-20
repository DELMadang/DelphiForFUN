object Form1: TForm1
  Left = 90
  Top = 83
  Width = 835
  Height = 476
  Caption = 'Match Merge'
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
    Left = 256
    Top = 8
    Width = 22
    Height = 13
    Caption = 'File1'
  end
  object Label2: TLabel
    Left = 448
    Top = 8
    Width = 22
    Height = 13
    Caption = 'File2'
  end
  object Label3: TLabel
    Left = 632
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Merged'
  end
  object Size1lbl: TLabel
    Left = 264
    Top = 384
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Size2Lbl: TLabel
    Left = 448
    Top = 384
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Size3Lbl: TLabel
    Left = 640
    Top = 384
    Width = 6
    Height = 13
    Caption = '0'
  end
  object DupsLbl: TLabel
    Left = 640
    Top = 408
    Width = 6
    Height = 17
    Caption = '0'
  end
  object MergeBtn: TButton
    Left = 24
    Top = 312
    Width = 75
    Height = 25
    Caption = 'Merge files'
    TabOrder = 0
    OnClick = MergeBtnClick
  end
  object ListBox1: TListBox
    Left = 256
    Top = 24
    Width = 169
    Height = 345
    ItemHeight = 13
    TabOrder = 1
  end
  object ListBox2: TListBox
    Left = 440
    Top = 24
    Width = 169
    Height = 345
    ItemHeight = 13
    TabOrder = 2
  end
  object ListBox3: TListBox
    Left = 632
    Top = 24
    Width = 169
    Height = 345
    ItemHeight = 13
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 16
    Top = 24
    Width = 225
    Height = 225
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'MatchMerge merges two files and optionally '
      'writes the output to a new file.'
      ''
      'Input files are checked to ensure that they are '
      'in sequence and may be sortedf if not.  If a '
      'sort is required, the original file is saved with '
      'an extension of ~txt as a backup before the '
      'sorted file is written over the original.'
      ''
      'Duplicates may be eliminated or retained in the '
      'output.'
      ''
      'For you Delphi programmers, potential '
      'enhancements include the ability to merge '
      'more than 2 files and to select fields from the '
      'record for comparison.')
    ParentFont = False
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 425
    Width = 827
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
  object DupsBox: TCheckBox
    Left = 16
    Top = 280
    Width = 185
    Height = 17
    Caption = 'Eliminate duplicates'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select 1st input file'
    Left = 688
    Top = 8
  end
  object OpenDialog2: TOpenDialog
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Select 2nd input file'
    Left = 744
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 792
    Top = 8
  end
end
