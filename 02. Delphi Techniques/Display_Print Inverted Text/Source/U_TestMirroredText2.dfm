object Form1: TForm1
  Left = 179
  Top = 92
  Width = 819
  Height = 630
  Align = alClient
  Caption = 'Mirrored  Text V2.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 30
    Height = 13
    Caption = 'Input'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 400
    Top = 0
    Width = 71
    Height = 13
    Caption = 'Transformed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 583
    Width = 811
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, 2006, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object ScrollBox1: TScrollBox
    Left = 400
    Top = 16
    Width = 400
    Height = 409
    HorzScrollBar.Smooth = True
    HorzScrollBar.Visible = False
    VertScrollBar.ButtonSize = 4
    VertScrollBar.Color = clBtnFace
    VertScrollBar.Increment = 1
    VertScrollBar.ParentColor = False
    VertScrollBar.Size = 4
    VertScrollBar.ThumbSize = 1
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 396
      Height = 405
      Align = alClient
      Anchors = []
    end
  end
  object ScrollBox2: TScrollBox
    Left = 0
    Top = 16
    Width = 404
    Height = 401
    HorzScrollBar.Visible = False
    VertScrollBar.ButtonSize = 4
    VertScrollBar.Size = 4
    VertScrollBar.ThumbSize = 1
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = False
    TabOrder = 2
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 400
      Height = 397
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Here'#39's a demonstration of drawing '
        'or printing mirrored text.'
        ''
        'Vertical mirroring, flipping, inverts the text '
        'as if a transparent sheet were flipped '
        'over about its horizontal axis and viewed '
        'from the back,  '
        ''
        'Horizontal mirroring displays text  '
        'as if the transparent sheet were rotated '
        '180 degrees about its vertical axis, or as '
        'if viewed in a mirror.'
        ''
        'Applying both transformations is '
        'equivalent to rotating 180 degrees '
        'about the Z axis, as if the sheet '
        'were laid flat on a table and rotated 180 '
        'degrees.'
        ''
        'You may enter replacement text in this '
        'area or use the '#39'Load text" button to load '
        'a text file. to display or print.   The "Font" '
        ' button selects any available font.   '
        ''
        'If text exceeds the space available,  '
        'the virtual text area will be extended  '
        'even though the display are remains '
        'fixed.'
        '  '
        '"Auto-Scroll" buttons allow users to scroll '
        'text up and down in both windows at the '
        'same rate.   A trackbar slider contols '
        'scrolling speed.'
        ''
        '  '
        'The "Maximize" button will display '
        'transformed text in a fullscreen window.  '
        'In this mode, the left/right mouse buttons '
        '(or down/up arrow keys) control scrolling '
        'speed and direction.'
        ''
        'The keyboard can also be used to enter '
        'additional commands when the screen '
        'view is maximized.   The "S" key wil start '
        'or stop scrolling.  "C" changes scroll '
        'direction and  "T" resets display to the '
        'top of  text.  The Esc key closes the '
        'maximized window. '
        ''
        ''
        ''
        ' ')
      ParentFont = False
      TabOrder = 0
      WantReturns = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 422
    Width = 811
    Height = 161
    Align = alBottom
    TabOrder = 3
    object Label3: TLabel
      Left = 400
      Top = 88
      Width = 48
      Height = 16
      Caption = 'Margins'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 648
      Top = 88
      Width = 23
      Height = 13
      Caption = 'Slow'
    end
    object Label6: TLabel
      Left = 752
      Top = 88
      Width = 20
      Height = 13
      Caption = 'Fast'
    end
    object StopBtn: TButton
      Left = 640
      Top = 16
      Width = 153
      Height = 65
      Caption = 'Stop'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Visible = False
      OnClick = StopBtnClick
    end
    object Modegrp: TRadioGroup
      Left = 8
      Top = 8
      Width = 273
      Height = 89
      Caption = 'Display mode'
      ItemIndex = 0
      Items.Strings = (
        'Normal'
        'Flip (Mirror top to bottom)'
        'Mirror (Left to right)'
        'Invert (Flip and Mirror = Rotate 180 about Z axis)')
      TabOrder = 0
      OnClick = DisplayBtnClick
    end
    object Edit1: TEdit
      Left = 400
      Top = 104
      Width = 33
      Height = 21
      TabOrder = 1
      Text = '10'
    end
    object MarginsUD: TUpDown
      Left = 433
      Top = 104
      Width = 17
      Height = 21
      Associate = Edit1
      Min = 1
      Max = 50
      Position = 10
      TabOrder = 2
      Wrap = False
      OnChangingEx = MarginsUDChangingEx
    end
    object FontBtn: TButton
      Left = 504
      Top = 104
      Width = 113
      Height = 25
      Caption = 'Change Font'
      TabOrder = 3
      OnClick = FontBtnClick
    end
    object PrintBtn: TButton
      Left = 504
      Top = 56
      Width = 113
      Height = 25
      Caption = 'Print'
      TabOrder = 4
      OnClick = PrintBtnClick
    end
    object DisplayBtn: TButton
      Left = 504
      Top = 16
      Width = 113
      Height = 25
      Caption = 'Display'
      TabOrder = 5
      OnClick = DisplayBtnClick
    end
    object ScrollUpBtn: TButton
      Left = 640
      Top = 16
      Width = 153
      Height = 25
      Caption = 'Auto Scroll Up'
      TabOrder = 6
      OnClick = ScrollBtnClick
    end
    object ScrollDownBtn: TButton
      Left = 640
      Top = 56
      Width = 153
      Height = 25
      Caption = 'Auto Scroll Down'
      TabOrder = 8
      OnClick = ScrollBtnClick
    end
    object Scrollspeed: TTrackBar
      Left = 640
      Top = 104
      Width = 153
      Height = 45
      Max = 100
      Min = 5
      Orientation = trHorizontal
      Frequency = 1
      Position = 50
      SelEnd = 0
      SelStart = 0
      TabOrder = 9
      TickMarks = tmBottomRight
      TickStyle = tsAuto
    end
    object MaximizeBtn: TButton
      Left = 360
      Top = 16
      Width = 113
      Height = 25
      Caption = 'Full Screen'
      TabOrder = 10
      OnClick = MaximizeBtnClick
    end
    object Button2: TButton
      Left = 16
      Top = 112
      Width = 209
      Height = 25
      Caption = 'Load text'
      TabOrder = 11
      OnClick = Button2Click
    end
    object Button1: TButton
      Left = 360
      Top = 56
      Width = 113
      Height = 25
      Caption = 'Background Color'
      TabOrder = 12
      OnClick = Button1Click
    end
  end
  object PrintDialog1: TPrintDialog
    Left = 560
    Top = 280
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MinFontSize = 0
    MaxFontSize = 0
    Left = 520
    Top = 280
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Title = 'Choose input text file'
    Left = 474
    Top = 282
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 618
    Top = 282
  end
end
