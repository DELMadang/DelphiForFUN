object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Text Spinner Version 1.0'
  ClientHeight = 643
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
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
    Width = 888
    Height = 620
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 48
      Top = 24
      Width = 456
      Height = 23
      Caption = 'Input -  Enter or paste new spin definition text below'
    end
    object Introlbl: TLabel
      Left = 24
      Top = 368
      Width = 116
      Height = 24
      Caption = 'Introduction'
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold, fsItalic]
      ParentColor = False
      ParentFont = False
    end
    object SpinBtn: TButton
      Left = 380
      Top = 291
      Width = 86
      Height = 29
      Caption = 'Spin it!'
      TabOrder = 0
      OnClick = SpinBtnClick
    end
    object Memo1: TMemo
      Left = 33
      Top = 54
      Width = 824
      Height = 187
      Lines.Strings = (
        
          '{Ask|Fear} {not|} what {your|my} {country|nation} can do {for|to' +
          '} {you|me|the guy '
        
          'down the street}, but what {you|I|the guy down the street} can d' +
          'o {for|'
        'to} {your country|your nation|me|you}.')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Memo2: TMemo
      Left = 25
      Top = 398
      Width = 856
      Height = 187
      BorderStyle = bsNone
      Color = 14548991
      Lines.Strings = (
        
          'Text spinning is a technique for randomly varying text based on ' +
          'user defined phrase '
        'choices embedded within  the text.'
        ''
        
          'In this implementation, "Phrase sets" of alternatives are define' +
          'd within pairs of curly brackets, '
        
          '{}.  Inside the brackets, alternatitive phrases to be randomly s' +
          'elected are separated by a '
        
          'vertical line character, |.  If a phrase set contains only a sin' +
          'gle phrase, it will be randomly '
        
          'included or omitted on a 50-50 basis. An example is included abo' +
          've.')
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object ClearBtn: TButton
      Left = 616
      Top = 360
      Width = 217
      Height = 25
      Caption = 'Clear output area'
      TabOrder = 3
      Visible = False
      OnClick = ClearBtnClick
    end
  end
end
