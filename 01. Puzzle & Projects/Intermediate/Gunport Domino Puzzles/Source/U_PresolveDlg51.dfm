object PresolveDlg: TPresolveDlg
  Left = 1395
  Top = 395
  BorderStyle = bsDialog
  Caption = 'PreSolveDlg'
  ClientHeight = 635
  ClientWidth = 508
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 88
    Top = 520
    Width = 190
    Height = 16
    Caption = 'Presolve vale = sum of checked'
  end
  object OKBtn: TButton
    Left = 97
    Top = 590
    Width = 93
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 212
    Top = 590
    Width = 92
    Height = 30
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object PreSolves: TCheckListBox
    Left = 96
    Top = 176
    Width = 305
    Height = 329
    OnClickCheck = PreSolvesClickCheck
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 16
    Items.Strings = (
      'PRESOLVE_ROWS          {1}'
      'PRESOLVE_COLS               {2}'
      'PRESOLVE_LINEDEP            {4}'
      'PRESOLVE_AGGREGATE          {8}'
      'PRESOLVE_SPARSER           {16}'
      'PRESOLVE_SOS               {32}'
      'PRESOLVE_REDUCEMIP         {64}'
      'PRESOLVE_DUALS    {lp5.1} {128}'
      'PRESOLVE_SENSDUALS {LP5.1}{256}'
      'PRESOLVE_ROWDOMINATE     {8192}'
      'PRESOLVE_COLDOMINATE    {16384}'
      'PRESOLVE_BOUNDS        {262144}')
    ParentFont = False
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 508
    Height = 161
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      
        'The LPSolve solver has  an optional "Presolve" feature which can' +
        ' '
      
        'speed up the solution search. Knowing which options to use seems' +
        ' '
      'to'
      
        'be reserved for Gurus (not me),  but here they are if you want t' +
        'o'
      'play with changing them.  My current set is prechecked here.  If'
      'you find better ones, let me know at feedback@delphiforfun.org.'
      ''
      'You can also enter a previous presolve sum value and click the '
      'button to'
      'select the corresponding items.')
    ParentFont = False
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 280
    Top = 512
    Width = 121
    Height = 24
    TabOrder = 4
    Text = '0'
  end
  object SetPresolvesBtn: TButton
    Left = 72
    Top = 544
    Width = 321
    Height = 25
    Caption = 'Set checked items to presolve value'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = SetPresolvesBtnClick
  end
end
