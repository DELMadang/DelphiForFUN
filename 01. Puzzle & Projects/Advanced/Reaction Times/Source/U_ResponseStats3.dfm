object Form1: TForm1
  Left = 227
  Top = 136
  AutoScroll = False
  Caption = 'Reaction time analysis V3.2'
  ClientHeight = 775
  ClientWidth = 1264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 755
    Width = 1264
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    AutoSize = False
    Caption = 'Copyright '#169' 2001-2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1264
    Height = 755
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 18
      Top = 9
      Width = 878
      Height = 48
      Caption = 
        'File data is in the center listbox.  For simple stats, use the a' +
        'rrows to select trials for Sample 1.  Add trials to Sample 2 for' +
        ' Student'#39's T comparison of two sample means. '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
      OnClick = Del1BtnClick
    end
    object Label2: TLabel
      Left = 27
      Top = 113
      Width = 55
      Height = 16
      Caption = 'Sample1'
    end
    object Label3: TLabel
      Left = 514
      Top = 113
      Width = 140
      Height = 16
      Caption = 'Reaction time file data'
    end
    object Label4: TLabel
      Left = 877
      Top = 121
      Width = 59
      Height = 16
      Caption = 'Sample2 '
    end
    object Label5: TLabel
      Left = 347
      Top = 269
      Width = 311
      Height = 16
      Caption = 'Selected trial information (highlighted row ablove)'
    end
    object Add1Btn: TBitBtn
      Left = 386
      Top = 131
      Width = 56
      Height = 29
      TabOrder = 0
      OnClick = Add1BtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object Del1Btn: TBitBtn
      Left = 386
      Top = 168
      Width = 56
      Height = 29
      TabOrder = 1
      OnClick = Del1BtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object Delbtn2: TBitBtn
      Left = 814
      Top = 168
      Width = 56
      Height = 29
      TabOrder = 2
      OnClick = Delbtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333FF3333333333333003333333333333F77F33333333333009033
        333333333F7737F333333333009990333333333F773337FFFFFF330099999000
        00003F773333377777770099999999999990773FF33333FFFFF7330099999000
        000033773FF33777777733330099903333333333773FF7F33333333333009033
        33333333337737F3333333333333003333333333333377333333333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object Addbtn2: TBitBtn
      Left = 814
      Top = 139
      Width = 56
      Height = 29
      TabOrder = 3
      OnClick = Addbtn2Click
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333FF3333333333333003333
        3333333333773FF3333333333309003333333333337F773FF333333333099900
        33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
        99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
        33333333337F3F77333333333309003333333333337F77333333333333003333
        3333333333773333333333333333333333333333333333333333333333333333
        3333333333333333333333333333333333333333333333333333}
      NumGlyphs = 2
    end
    object ListBox1: TListBox
      Left = 449
      Top = 131
      Width = 360
      Height = 111
      ItemHeight = 16
      ScrollWidth = 500
      TabOrder = 4
      OnClick = ListBoxClick
      OnDblClick = ListBoxDblClick
    end
    object ListBox2: TListBox
      Left = 18
      Top = 131
      Width = 360
      Height = 111
      ItemHeight = 16
      ScrollWidth = 500
      TabOrder = 5
      OnClick = ListBoxClick
      OnDblClick = ListBoxDblClick
    end
    object ListBox3: TListBox
      Left = 872
      Top = 139
      Width = 360
      Height = 111
      ItemHeight = 16
      ScrollWidth = 500
      TabOrder = 6
      OnClick = ListBoxClick
      OnDblClick = ListBoxDblClick
    end
    object CalcBtn: TButton
      Left = 27
      Top = 421
      Width = 222
      Height = 36
      Caption = 'Calculate statistics'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      OnClick = CalcBtnClick
    end
    object Memo2: TMemo
      Left = 656
      Top = 410
      Width = 577
      Height = 321
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'Results display here')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 8
      WantTabs = True
    end
    object OpenBtn: TButton
      Left = 275
      Top = 422
      Width = 342
      Height = 36
      Caption = 'Select another reaction time summary file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      WordWrap = True
      OnClick = OpenBtnClick
    end
    object Memo1: TMemo
      Left = 347
      Top = 312
      Width = 632
      Height = 57
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 10
    end
    object Edit1: TEdit
      Left = 347
      Top = 287
      Width = 632
      Height = 25
      Color = clInactiveCaption
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -14
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
      Text = 
        '   Name       Trial    Date/Time,           Nbr   Max.  Min.  Me' +
        'an, Variance'
    end
  end
  object OpenDialog1: TOpenDialog
    FileName = 'Reactiontimes.rsp'
    Filter = 'Reation summary (*.rsp)|*.rsp|All files (*.*)|*.*'
    Left = 1000
    Top = 32
  end
end
