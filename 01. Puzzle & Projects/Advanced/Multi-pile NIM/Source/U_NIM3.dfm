object Form1: TForm1
  Left = 101
  Top = 96
  Width = 648
  Height = 480
  Caption = 'NIM'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object HumanRGrp: TGroupBox
    Left = 8
    Top = 184
    Width = 217
    Height = 137
    Caption = 'Your turn, Human 1 '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 24
      Width = 176
      Height = 64
      Caption = 
        'Click ( or click/shift-click) as many tokens as you desire in an' +
        'y single row.  Press Take button to finalize your move'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object TakeBtn: TButton
      Left = 6
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Take'
      TabOrder = 0
      OnClick = TakeBtnClick
    end
  end
  object NewGameBtn: TButton
    Left = 8
    Top = 397
    Width = 217
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'New Game'
    TabOrder = 1
    OnClick = NewGameBtnClick
  end
  object TypeRGrp: TRadioGroup
    Left = 8
    Top = 119
    Width = 217
    Height = 57
    Caption = 'Play type'
    ItemIndex = 0
    Items.Strings = (
      'Last token taker wins'
      'Last token taker loses')
    TabOrder = 2
    OnClick = TypeRGrpClick
  end
  object Panel1: TPanel
    Left = 248
    Top = 16
    Width = 385
    Height = 278
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Computer wins!'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 3
    OnResize = Panel1Resize
  end
  object PlayerGrp: TRadioGroup
    Left = 8
    Top = 16
    Width = 217
    Height = 89
    Caption = 'Players (in play order)'
    ItemIndex = 0
    Items.Strings = (
      'Human 1 vs.  Human 2'
      'Computer vs. Human'
      'Human vs. Computer')
    TabOrder = 4
    OnClick = PlayerGrpClick
  end
  object PlayList: TListBox
    Left = 248
    Top = 308
    Width = 385
    Height = 117
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 5
  end
  object RestoreBtn: TButton
    Left = 8
    Top = 342
    Width = 217
    Height = 25
    Caption = 'Restore game'
    TabOrder = 6
    OnClick = RestoreBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 427
    Width = 640
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
