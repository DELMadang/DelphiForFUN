object Form1: TForm1
  Left = 192
  Top = 107
  Width = 572
  Height = 480
  Caption = 'NIM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 216
    Width = 81
    Height = 13
    Caption = 'Number of Sticks'
  end
  object Image1: TImage
    Left = 264
    Top = 16
    Width = 281
    Height = 185
  end
  object NbrSticks: TSpinEdit
    Left = 96
    Top = 216
    Width = 41
    Height = 22
    MaxValue = 20
    MinValue = 1
    TabOrder = 0
    Value = 7
    OnChange = NewGameBtnClick
  end
  object TakeGrp: TGroupBox
    Left = 8
    Top = 280
    Width = 217
    Height = 153
    Caption = 'Player 1'
    TabOrder = 1
    Visible = False
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 183
      Height = 26
      Caption = 
        'Select 1 to 3 sticks and click "Take" , Click "Suggest" for a su' +
        'ggestion'
      WordWrap = True
    end
    object H1Takes: TSpinEdit
      Left = 16
      Top = 64
      Width = 41
      Height = 22
      MaxValue = 3
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object TakeBtn: TButton
      Left = 94
      Top = 64
      Width = 75
      Height = 25
      Caption = 'Take'
      TabOrder = 1
      OnClick = TakeBtnClick
    end
    object SuggestBtn: TButton
      Left = 94
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Suggest'
      TabOrder = 2
      OnClick = SuggestBtnClick
    end
  end
  object PlayList: TListBox
    Left = 264
    Top = 288
    Width = 281
    Height = 145
    ItemHeight = 13
    TabOrder = 2
  end
  object NewGameBtn: TButton
    Left = 8
    Top = 248
    Width = 217
    Height = 25
    Caption = 'New Game'
    TabOrder = 3
    OnClick = NewGameBtnClick
  end
  object DebugBox: TListBox
    Left = 272
    Top = 24
    Width = 281
    Height = 185
    ItemHeight = 13
    TabOrder = 4
    Visible = False
  end
  object Panel1: TPanel
    Left = 8
    Top = 16
    Width = 217
    Height = 185
    Color = clYellow
    TabOrder = 5
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 201
      Height = 169
      BorderStyle = bsNone
      Color = clYellow
      Lines.Strings = (
        'To play NIM, a number of sticks are laid '
        'out on a surface and two players take '
        'turns removing 1, 2 or 3 sticks at each '
        'turn.  The player who takes the last stick '
        'loses.'
        ' '
        'The program will suggest the best '
        'available move for the current player if the '
        '"Suggest" button is clicked.')
      TabOrder = 0
    end
  end
end
