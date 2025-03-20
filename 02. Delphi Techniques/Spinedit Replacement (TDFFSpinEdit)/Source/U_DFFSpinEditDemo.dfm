object Form1: TForm1
  Left = 271
  Top = 94
  Width = 885
  Height = 599
  Caption = 'DFFSpinEdit  Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 531
    Top = 80
    Width = 77
    Height = 14
    Caption = 'Edit1+TUpDown'
  end
  object Label2: TLabel
    Left = 538
    Top = 8
    Width = 44
    Height = 14
    Caption = 'TSpinEdit'
  end
  object Label3: TLabel
    Left = 535
    Top = 144
    Width = 58
    Height = 14
    Caption = 'TMySpinEdit'
    WordWrap = True
  end
  object Label4: TLabel
    Left = 536
    Top = 216
    Width = 45
    Height = 14
    Caption = 'Min value'
  end
  object Label5: TLabel
    Left = 672
    Top = 216
    Width = 49
    Height = 14
    Caption = 'Max value'
  end
  object Min1Lbl: TLabel
    Left = 616
    Top = 24
    Width = 22
    Height = 14
    Caption = 'Min='
  end
  object Max1Lbl: TLabel
    Left = 720
    Top = 24
    Width = 29
    Height = 14
    Caption = 'Max ='
  end
  object Max2Lbl: TLabel
    Left = 720
    Top = 96
    Width = 26
    Height = 14
    Caption = 'Max='
  end
  object Min2Lbl: TLabel
    Left = 616
    Top = 96
    Width = 22
    Height = 14
    Caption = 'Min='
  end
  object Max3Lbl: TLabel
    Left = 720
    Top = 160
    Width = 26
    Height = 14
    Caption = 'Max='
  end
  object Min3Lbl: TLabel
    Left = 616
    Top = 160
    Width = 22
    Height = 14
    Caption = 'Min='
  end
  object Val1Lbl: TLabel
    Left = 664
    Top = 24
    Width = 22
    Height = 14
    Caption = 'Val='
  end
  object Val2Lbl: TLabel
    Left = 664
    Top = 96
    Width = 22
    Height = 14
    Caption = 'Val='
  end
  object Val3Lbl: TLabel
    Left = 664
    Top = 160
    Width = 22
    Height = 14
    Caption = 'Val='
  end
  object Label6: TLabel
    Left = 536
    Top = 280
    Width = 297
    Height = 25
    AutoSize = False
    Caption = 'Set new Min to be greater than Val to observe  errors below'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object Edit1: TEdit
    Left = 536
    Top = 96
    Width = 48
    Height = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = '0'
  end
  object UpDown1: TUpDown
    Left = 584
    Top = 96
    Width = 16
    Height = 30
    Associate = Edit1
    Min = 0
    Position = 0
    TabOrder = 1
    Wrap = False
    OnChanging = UpDown1Changing
  end
  object Edit3: TEdit
    Left = 536
    Top = 163
    Width = 48
    Height = 30
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Text = '0'
    OnChange = Edit3Change
  end
  object MinValEdt: TEdit
    Left = 592
    Top = 212
    Width = 33
    Height = 22
    TabOrder = 3
    Text = '10'
    OnDblClick = MinvalBtnClick
  end
  object MaxValEdt: TEdit
    Left = 728
    Top = 212
    Width = 33
    Height = 22
    TabOrder = 4
    Text = '45'
    OnDblClick = MaxvalBtnClick
  end
  object MinvalBtn: TButton
    Left = 536
    Top = 240
    Width = 105
    Height = 25
    Caption = 'Set new Min value'
    TabOrder = 6
    OnClick = MinvalBtnClick
  end
  object MaxvalBtn: TButton
    Left = 672
    Top = 240
    Width = 105
    Height = 25
    Caption = 'Set new Max value'
    TabOrder = 5
    OnClick = MaxvalBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 543
    Width = 869
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 7
    OnClick = StaticText1Click
  end
  object FixSpinEdit: TCheckBox
    Left = 536
    Top = 376
    Width = 97
    Height = 17
    Caption = 'FixSpinEdit'
    TabOrder = 8
    OnClick = FixSpinEditClick
  end
  object FixUpDown: TCheckBox
    Left = 544
    Top = 512
    Width = 97
    Height = 17
    Caption = 'FixUpDown'
    TabOrder = 9
    OnClick = FixUpDownClick
  end
  object Memo1: TMemo
    Left = 536
    Top = 304
    Width = 313
    Height = 65
    Lines.Strings = (
      'If  TSpinedit Maxvalue or MinValue is changed and the Value '
      
        'property then falls outside of the range, Value is not updated. ' +
        ' '
      'The check box below forces Value to be checked and set to '
      'MinValue or MaxValue if it is outside of the value range.'
      '')
    TabOrder = 10
  end
  object Memo2: TMemo
    Left = 544
    Top = 408
    Width = 305
    Height = 97
    Lines.Strings = (
      'TUpDown corntrol updates the Position property when '
      'required to keep it within the range of Min/Max property '
      'range.  However, a bug or at least a defect in the code '
      'prevents it from updating  the "Associated" TEdit control '
      'under these conditions.   The check box below forces a '
      'message to be sent to update the associated Tedit.')
    TabOrder = 12
  end
  object Memo3: TMemo
    Left = 24
    Top = 8
    Width = 481
    Height = 521
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'This program demonstrates three versions of spin controls.'
      ''
      
        'TSpinEdit is usually available in the "Samples" tab of Delphi'#39's ' +
        'Component '
      
        'Palette.  However it is not available in Turbo Delphi Explorer, ' +
        'the free version '
      'of Delphi currently available.'
      ''
      
        'TUpDown is a standard control that can be associated with a sepa' +
        'rately '
      'define TEdit control to simulate TSpinEdit.'
      ''
      
        'TDFFSpinEdit is a newly created control that simulates TSpinEdit' +
        ' with these'
      'advantages:'
      ''
      
        '1. It uses a TEdit control as the prototype and creates the TUpD' +
        'own control to'
      'associate with it.'
      ''
      
        '2. It is not an installed component so must be created within th' +
        'e program prior'
      
        'to use.Turbo Delphi will not allow additional components to be i' +
        'nstalled, but'
      'TDFFSpinEdit can used with any version.'
      ''
      
        '3. Both TSpinEdit and TUpDown with associated Tedit have undesir' +
        'able'
      
        'behavior when the range of allowable values is changed in such a' +
        ' way as to'
      
        'exclude the current value. The value may not be changed (TUpDown' +
        ') or the'
      
        'displayed value may not agree with the updated internal value (T' +
        'SpinEdit) '
      
        'under these conditions.  TDFFSpinEdit handles this situation by ' +
        'setting value '
      'to equal the nearest range value.'
      ''
      
        '4. Differences:  In TSpinEdit, when MinValue and MaxValue are bo' +
        'th set to 0, '
      
        'no range checking is performed.   Also TUpDown allows Max proper' +
        'ty to '
      
        'have a lower value the Min property in which case "Up" arrows lo' +
        'wer the value '
      
        'and "Down" arrow clicks increase the value.  I have chosen not t' +
        'o implement '
      
        'either behaivior.  TDFFSpinedit forces MaxValue to be greater th' +
        'an MinValue.')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 11
  end
  object SpinEdit1: TSpinEdit
    Left = 536
    Top = 24
    Width = 65
    Height = 32
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    MaxValue = 0
    MinValue = 0
    ParentFont = False
    TabOrder = 13
    Value = 0
  end
end
