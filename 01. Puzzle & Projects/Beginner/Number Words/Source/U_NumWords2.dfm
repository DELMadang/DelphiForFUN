object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Number Words 2'
  ClientHeight = 610
  ClientWidth = 1262
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 144
  TextHeight = 19
  object StaticText1: TStaticText
    Left = 0
    Top = 582
    Width = 1262
    Height = 28
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1262
    Height = 582
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 952
      Top = 72
      Width = 117
      Height = 24
      Caption = 'My Guesses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 952
      Top = 96
      Width = 132
      Height = 38
      Caption = 'Enter numbers or number words'
      WordWrap = True
    end
    object SolveitBtn: TButton
      Left = 632
      Top = 277
      Width = 102
      Height = 34
      Caption = 'Solve it!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = SolveitBtnClick
    end
    object Memo1: TMemo
      Left = 49
      Top = 336
      Width = 496
      Height = 193
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'This rectangle holds __________ L'#39's, '
        '__________ N'#39's, and __________ vowels '
        'in all.'
        '')
      ParentFont = False
      TabOrder = 1
    end
    object CheckBox1: TCheckBox
      Left = 632
      Top = 159
      Width = 281
      Height = 17
      Caption = 'Count occurrences of letter'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 904
      Top = 152
      Width = 25
      Height = 31
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = 'L'
    end
    object Memo2: TMemo
      Left = 48
      Top = 32
      Width = 489
      Height = 249
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Find the spelled out numbers to make the '
        'statement below true. You may modify the text, and '
        'the letters to test.'
        ''
        'Enter your guesses in the fields at right and '
        'click the "Check my guesses" button, or click the '
        '"Solve" button to let the program solve it.'
        ''
        'Currently the tested letter or vowel count '
        'cannot exceed 20.')
      ParentFont = False
      TabOrder = 4
    end
    object Memo3: TMemo
      Left = 640
      Top = 336
      Width = 481
      Height = 185
      Lines.Strings = (
        'Answer displays here.')
      TabOrder = 5
    end
    object Edit3: TEdit
      Left = 952
      Top = 152
      Width = 153
      Height = 27
      TabOrder = 6
      Text = '0'
    end
    object Edit4: TEdit
      Left = 952
      Top = 192
      Width = 153
      Height = 27
      TabOrder = 7
      Text = '0'
    end
    object Edit5: TEdit
      Left = 952
      Top = 232
      Width = 153
      Height = 27
      TabOrder = 8
      Text = '0'
    end
    object CheckitBtn: TButton
      Left = 928
      Top = 280
      Width = 177
      Height = 33
      Caption = 'Check my guesses'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = CheckitBtnClick
    end
  end
  object CheckBox2: TCheckBox
    Left = 632
    Top = 191
    Width = 281
    Height = 17
    Caption = 'Count occurrences of letter'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 2
  end
  object Edit2: TEdit
    Left = 904
    Top = 184
    Width = 25
    Height = 31
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = 'N'
  end
  object CheckBox3: TCheckBox
    Left = 632
    Top = 231
    Width = 281
    Height = 17
    Caption = 'Count number of vowels'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 4
  end
end
