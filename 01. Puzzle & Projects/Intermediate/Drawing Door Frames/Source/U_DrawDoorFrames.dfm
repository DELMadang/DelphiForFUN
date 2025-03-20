object Form1: TForm1
  Left = 428
  Top = 225
  Width = 1224
  Height = 760
  Caption = 'Draw framed doors '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 23
  object Label3: TLabel
    Left = 64
    Top = 472
    Width = 147
    Height = 23
    Caption = 'Door Size (HxW)'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 690
    Width = 1206
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2016, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1206
    Height = 690
    Align = alClient
    TabOrder = 1
    object Image1: TImage
      Left = 576
      Top = 24
      Width = 609
      Height = 617
    end
    object Label1: TLabel
      Left = 40
      Top = 184
      Width = 147
      Height = 23
      Caption = 'Door Size (HxW)'
    end
    object Label2: TLabel
      Left = 256
      Top = 184
      Width = 9
      Height = 23
      Caption = 'x'
    end
    object Label4: TLabel
      Left = 72
      Top = 232
      Width = 129
      Height = 49
      AutoSize = False
      Caption = 'Mullion height above base'
      WordWrap = True
    end
    object Label5: TLabel
      Left = 72
      Top = 296
      Width = 121
      Height = 33
      AutoSize = False
      Caption = 'Mullion Width'
      WordWrap = True
    end
    object DrawBtn: TButton
      Left = 40
      Top = 352
      Width = 417
      Height = 25
      Caption = 'Draw it'
      TabOrder = 0
      OnClick = DrawBtnClick
    end
    object Memo1: TMemo
      Left = 32
      Top = 400
      Width = 521
      Height = 273
      Color = 15400959
      Lines.Strings = (
        'An exercise to draw doors subdivided with  one or more '
        'vertical frames separated and divided by mullions of a '
        'given size.')
      TabOrder = 1
    end
    object NbrFramesGrp: TRadioGroup
      Left = 32
      Top = 64
      Width = 225
      Height = 89
      Caption = 'Number of Subframes'
      Columns = 2
      ItemIndex = 1
      Items.Strings = (
        '1'
        '2'
        '3'
        '4')
      TabOrder = 2
    end
    object DoorHEdt: TEdit
      Left = 192
      Top = 184
      Width = 57
      Height = 31
      TabOrder = 3
      Text = '2100'
    end
    object DoorWEdt: TEdit
      Left = 272
      Top = 184
      Width = 57
      Height = 31
      TabOrder = 4
      Text = '1018'
    end
    object MullionHOBEdt: TEdit
      Left = 200
      Top = 240
      Width = 57
      Height = 31
      TabOrder = 5
      Text = '500'
    end
    object MullionWEdt: TEdit
      Left = 200
      Top = 296
      Width = 49
      Height = 31
      TabOrder = 6
      Text = '35'
    end
  end
end
