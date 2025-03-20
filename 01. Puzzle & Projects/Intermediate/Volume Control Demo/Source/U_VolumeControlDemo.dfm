object Form1: TForm1
  Left = 80
  Top = 162
  Width = 935
  Height = 760
  Caption = 'Controlling Master Volume Level'
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
    Top = 692
    Width = 917
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2015, Gary Darby,  www.DelphiForFun.org'
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
    Width = 917
    Height = 692
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 320
      Width = 257
      Height = 65
      AutoSize = False
      Caption = 'Master Volume - slide or click to change.'
      WordWrap = True
    end
    object Memo1: TMemo
      Left = 32
      Top = 32
      Width = 601
      Height = 273
      Color = 15400959
      Lines.Strings = (
        
          'Controlling the master sound volume from a program is the target' +
          ' '
        'of this demonstration.  It uses an MMDevAPI unit coverted to'
        'Delphi and downloaded from the web.  Only one of the many '
        'MMDevAPI procedures, '
        'SetMasterVolumeLevelScalar,is used here.'
        ''
        'Slide the trackbar pointer to play a sound (the IconExclamation '
        
          'sound) at that volume specified in the range of 0.0 to 1.0.  If ' +
          'you '
        'open the Mixer window from the Speaker icon, you can also see '
        'the master volume slider change '
        '')
      TabOrder = 0
    end
    object Memo2: TMemo
      Left = 648
      Top = 32
      Width = 249
      Height = 569
      TabOrder = 1
    end
    object PlayBtn: TButton
      Left = 32
      Top = 472
      Width = 337
      Height = 25
      Caption = 'Replay sound at current level'
      TabOrder = 2
      OnClick = PlayBtnClick
    end
    object TrackBar1: TTrackBar
      Left = 32
      Top = 376
      Width = 225
      Height = 45
      PageSize = 1
      Position = 5
      TabOrder = 3
      OnChange = TrackBar1Change
    end
  end
end
