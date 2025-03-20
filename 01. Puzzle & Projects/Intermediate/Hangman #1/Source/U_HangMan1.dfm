object Form1: TForm1
  Left = 155
  Top = 122
  Width = 544
  Height = 528
  Caption = 'Hangman1 (Human vs Human)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object DeadLbl: TLabel
    Left = 336
    Top = 432
    Width = 119
    Height = 24
    Caption = 'You are dead!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object GallowsImage: TImage
    Left = 248
    Top = 16
    Width = 257
    Height = 393
  end
  object NewGameBtn: TBitBtn
    Left = 32
    Top = 360
    Width = 105
    Height = 25
    Caption = 'New Game'
    TabOrder = 2
    Visible = False
    OnClick = NewGameBtnClick
  end
  object AboutBtn: TButton
    Left = 32
    Top = 408
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 3
    OnClick = AboutBtnClick
  end
  object HangmanPanel: TPanel
    Left = 16
    Top = 24
    Width = 409
    Height = 201
    TabOrder = 1
    object Label1: TLabel
      Left = 128
      Top = 16
      Width = 165
      Height = 20
      Caption = 'Enter secret word here '
    end
    object Label6: TLabel
      Left = 16
      Top = 16
      Width = 95
      Height = 20
      Caption = 'Hangman --'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WordEdt: TEdit
      Left = 16
      Top = 56
      Width = 193
      Height = 28
      CharCase = ecUpperCase
      PasswordChar = '*'
      TabOrder = 0
      OnKeyPress = EditKeyPress
    end
    object HideBox: TCheckBox
      Left = 16
      Top = 112
      Width = 377
      Height = 17
      Caption = 'Hide word  (in case your opponent is peeking as you type)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      OnClick = HideBoxClick
    end
    object OKBtn: TBitBtn
      Left = 128
      Top = 160
      Width = 75
      Height = 25
      TabOrder = 2
      OnClick = OKBtnClick
      Kind = bkOK
    end
  end
  object PlayerPanel: TPanel
    Left = 16
    Top = 16
    Width = 209
    Height = 257
    TabOrder = 0
    Visible = False
    object Label4: TLabel
      Left = 16
      Top = 104
      Width = 120
      Height = 20
      Caption = 'Correct Guesses'
    end
    object WordLbl: TLabel
      Left = 13
      Top = 136
      Width = 100
      Height = 20
      Caption = '_ _ _ _ _ _ _ _'
    end
    object Label3: TLabel
      Left = 16
      Top = 173
      Width = 108
      Height = 20
      Caption = 'Guesses so far'
    end
    object Label2: TLabel
      Left = 24
      Top = 61
      Width = 92
      Height = 20
      Caption = 'Enter a letter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Guesseslbl: TLabel
      Left = 17
      Top = 200
      Width = 160
      Height = 41
      AutoSize = False
      Caption = 'xxx'
      WordWrap = True
    end
    object Label5: TLabel
      Left = 24
      Top = 16
      Width = 83
      Height = 20
      Caption = 'Convict ---'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 160
      Top = 61
      Width = 25
      Height = 28
      TabOrder = 0
      OnKeyPress = Edit1KeyPress
    end
  end
end
