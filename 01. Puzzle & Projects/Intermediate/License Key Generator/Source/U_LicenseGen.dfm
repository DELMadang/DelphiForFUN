object Form1: TForm1
  Left = 80
  Top = 22
  Width = 1033
  Height = 615
  Caption = 'License Key Generation  V2.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 564
    Width = 1025
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 564
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 81
      Top = 426
      Width = 233
      Height = 54
      Caption = 
        'Encrypt Key (Row1 in, Row 2 out    Decrypt Key (Row 2 in, Row 1 ' +
        ' out)'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 81
      Top = 157
      Width = 170
      Height = 38
      AutoSize = False
      Caption = 'Field Names and Sizes (V==> Variable length)'
      WordWrap = True
    end
    object Label5: TLabel
      Left = 545
      Top = 112
      Width = 92
      Height = 18
      Caption = 'Sample Data'
    end
    object Label6: TLabel
      Left = 544
      Top = 224
      Width = 449
      Height = 57
      AutoSize = False
      Caption = 
        'Note: Only letters and digits allowed.  Others will be  removed ' +
        'in variable length fields and replaced with X in fixed length fi' +
        'elds.  Short fixed lenghth fields will be extended with X.'#39's .  ' +
        'Overlength fields will be  truncated.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object MakeEncDecBtn: TButton
      Left = 81
      Top = 392
      Width = 383
      Height = 26
      Caption = 'Make Encryption Key'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = MakeEncDecBtnClick
    end
    object Memo1: TMemo
      Left = 24
      Top = 6
      Width = 977
      Height = 91
      Color = 15400959
      Lines.Strings = (
        
          'I have often wondered how companies generate unique program lice' +
          'nses when a product is purchased or activated.  At a  user'#39's'
        
          'request, here'#39's a "proof of concept" demo program implementing m' +
          'y ideas of how  would do it.'
        ''
        
          'Let it be clear that this program will NOT generate keys for any' +
          ' exisitng commercial programs!')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object DecryptBtn: TButton
      Left = 552
      Top = 408
      Width = 209
      Height = 20
      Caption = 'Back to plain text'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = DecryptBtnClick
    end
    object DataMemo: TMemo
      Left = 545
      Top = 130
      Width = 326
      Height = 95
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'EncryptVersion=2.2'
        'ExpireDays=365'
        'FirstName=Mary'
        'LastName=Doe')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object EncryptMemo: TMemo
      Left = 552
      Top = 320
      Width = 370
      Height = 70
      Lines.Strings = (
        'Encrypted data')
      TabOrder = 4
    end
    object MakeLicenseKeyBtn: TButton
      Left = 552
      Top = 296
      Width = 201
      Height = 20
      Caption = 'Make License Key'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = MakeLicenseKeyBtnClick
    end
    object DecryptMemo: TMemo
      Left = 552
      Top = 432
      Width = 370
      Height = 105
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Decrypted Data')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 6
    end
    object EncryptKeyMemo: TMemo
      Left = 81
      Top = 464
      Width = 402
      Height = 76
      HelpType = htKeyword
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      WordWrap = False
    end
    object Defmemo: TMemo
      Left = 81
      Top = 201
      Width = 202
      Height = 104
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'EncryptVersion=V4'
        'FirstName=V8'
        'LastName=V12'
        'StartDate=6'
        'ExpireDays=3')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 8
    end
    object randomSeedRBtn: TRadioButton
      Left = 94
      Top = 361
      Width = 170
      Height = 13
      Caption = 'Use random seed'
      Checked = True
      TabOrder = 9
      TabStop = True
      OnClick = randomSeedRBtnClick
    end
    object TisSeedRBtn: TRadioButton
      Left = 94
      Top = 328
      Width = 147
      Height = 25
      Caption = 'Use this seed ==>'
      TabOrder = 10
      OnClick = randomSeedRBtnClick
    end
    object RandSeedEdt: TEdit
      Left = 248
      Top = 329
      Width = 216
      Height = 26
      TabOrder = 11
      Text = '000000'
    end
    object GroupBox1: TGroupBox
      Left = 285
      Top = 202
      Width = 219
      Height = 101
      Caption = 'License key format'
      TabOrder = 12
      object Label2: TLabel
        Left = 8
        Top = 27
        Width = 155
        Height = 18
        Caption = '# of license segments:'
      end
      object Label4: TLabel
        Left = 3
        Top = 58
        Width = 172
        Height = 18
        Caption = 'Characters per segment:'
      end
      object NbrSegsEdt: TEdit
        Left = 182
        Top = 27
        Width = 19
        Height = 26
        TabOrder = 0
        Text = '5'
      end
      object SegSizeEdt: TEdit
        Left = 182
        Top = 58
        Width = 19
        Height = 26
        TabOrder = 1
        Text = '6'
      end
    end
    object ShowRukesBtnCkick: TButton
      Left = 88
      Top = 112
      Width = 273
      Height = 25
      Caption = 'Click for usage guidelines'
      TabOrder = 13
      OnClick = ShowRukesBtnCkickClick
    end
  end
end
