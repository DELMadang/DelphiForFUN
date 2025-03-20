object frmChoose: TfrmChoose
  Left = 266
  Top = 202
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Choose a voice'
  ClientHeight = 453
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 261
    Height = 26
    Caption = 
      'Please select the text-to-speech voice to use and file to'#13#10'write' +
      ' out to.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 16
    Top = 112
    Width = 80
    Height = 13
    Caption = 'Output file name:'
  end
  object FileLbl: TLabel
    Left = 16
    Top = 128
    Width = 69
    Height = 13
    Caption = 'None selected'
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 40
    Width = 265
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 304
    Top = 16
    Width = 297
    Height = 273
    Lines.Strings = (
      'Enter or paste text to be saved as a  ".wav" sound file in this '
      'area.')
    TabOrder = 1
  end
  object RadioGroup1: TRadioGroup
    Left = 16
    Top = 160
    Width = 89
    Height = 81
    Caption = 'Record Speed'
    ItemIndex = 0
    Items.Strings = (
      '1x'
      '2x'
      '4x'
      '8x')
    TabOrder = 2
    OnClick = RadioGroup1Click
  end
  object Button3: TButton
    Left = 16
    Top = 72
    Width = 161
    Height = 25
    Caption = 'Select output file'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 16
    Top = 264
    Width = 161
    Height = 25
    Caption = 'Write file'
    TabOrder = 4
    OnClick = Button4Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 632
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'wav'
    Filter = 'Wav files (*.wav)|*.wav'
    Left = 288
    Top = 16
  end
end
