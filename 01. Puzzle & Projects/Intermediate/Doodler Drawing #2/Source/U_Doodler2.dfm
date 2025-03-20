object Form1: TForm1
  Left = 88
  Top = 79
  Width = 640
  Height = 483
  Caption = 'Doodler5'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 200
    Top = 12
    Width = 425
    Height = 425
    Anchors = []
    OnMouseDown = ImageMouseDown
    OnMouseMove = ImageMouseMove
    OnMouseUp = ImageMouseUp
  end
  object ResetBtn: TButton
    Left = 8
    Top = 416
    Width = 81
    Height = 25
    Caption = 'Clear'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = ResetBtnClick
  end
  object UndoBtn: TButton
    Left = 8
    Top = 256
    Width = 83
    Height = 25
    Caption = 'Undo last draw'
    TabOrder = 1
    OnClick = UndoBtnClick
  end
  object SaveBtn: TButton
    Left = 8
    Top = 376
    Width = 81
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = SaveBtnClick
  end
  object PrintBtn: TButton
    Left = 8
    Top = 336
    Width = 81
    Height = 25
    Caption = 'Print'
    TabOrder = 3
    OnClick = PrintBtnClick
  end
  object RefreshBtn: TButton
    Left = 8
    Top = 296
    Width = 81
    Height = 25
    Caption = 'Refresh'
    TabOrder = 4
    OnClick = RefreshBtnClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 177
    Height = 233
    ActivePage = TabSheet4
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = 'Pen'
      object Label7: TLabel
        Left = 12
        Top = 18
        Width = 33
        Height = 13
        Caption = 'Color:  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = PenColorBtnClick
      end
      object Label8: TLabel
        Left = 12
        Top = 57
        Width = 46
        Height = 16
        Caption = 'Width:   '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 8
        Top = 96
        Width = 88
        Height = 13
        Caption = 'Right click fill color'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object ColorRect: TPanel
        Left = 103
        Top = 10
        Width = 41
        Height = 23
        TabOrder = 0
        OnClick = PenColorBtnClick
      end
      object Edit6: TEdit
        Left = 103
        Top = 50
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '3'
      end
      object WidthUD: TUpDown
        Left = 136
        Top = 50
        Width = 12
        Height = 21
        Associate = Edit6
        Min = 1
        Max = 10
        Position = 3
        TabOrder = 2
        Wrap = False
      end
      object FillColorRect: TPanel
        Left = 103
        Top = 90
        Width = 41
        Height = 23
        TabOrder = 3
        OnClick = PenColorBtnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Rotate draw'
      ImageIndex = 1
      object Label4: TLabel
        Left = 13
        Top = 26
        Width = 76
        Height = 13
        Caption = 'Rotate degrees '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 13
        Top = 58
        Width = 83
        Height = 13
        Caption = 'How many times?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Edit2: TEdit
        Left = 104
        Top = 18
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '36'
        OnExit = RefreshBtnClick
      end
      object RotateDegUD: TUpDown
        Left = 137
        Top = 18
        Width = 12
        Height = 21
        Associate = Edit2
        Min = 0
        Max = 360
        Position = 36
        TabOrder = 1
        Wrap = False
        OnExit = RefreshBtnClick
      end
      object RotateTimesUD: TUpDown
        Left = 137
        Top = 53
        Width = 12
        Height = 21
        Associate = Edit3
        Min = 0
        Position = 9
        TabOrder = 2
        Wrap = False
        OnExit = RefreshBtnClick
      end
      object Edit3: TEdit
        Left = 104
        Top = 53
        Width = 33
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '9'
        OnExit = RefreshBtnClick
      end
      object RotateCheck: TCheckBox
        Left = 13
        Top = 90
        Width = 60
        Height = 23
        Caption = 'Activate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = RefreshBtnClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Kaleidoscope'
      ImageIndex = 2
      object Label5: TLabel
        Left = 8
        Top = 16
        Width = 105
        Height = 33
        AutoSize = False
        Caption = 'First mirror angle from horizontal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label6: TLabel
        Left = 8
        Top = 58
        Width = 113
        Height = 13
        Caption = 'Angle between mirrors:  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Edit4: TEdit
        Left = 120
        Top = 18
        Width = 25
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Text = '15'
        OnExit = RefreshBtnClick
      end
      object MirrorStartUD: TUpDown
        Left = 145
        Top = 18
        Width = 12
        Height = 21
        Associate = Edit4
        Min = 0
        Max = 360
        Position = 15
        TabOrder = 1
        Wrap = False
        OnExit = RefreshBtnClick
      end
      object MirrorAngleUD: TUpDown
        Left = 145
        Top = 53
        Width = 12
        Height = 21
        Associate = Edit5
        Min = 0
        Max = 180
        Position = 30
        TabOrder = 2
        Wrap = False
        OnExit = RefreshBtnClick
      end
      object Edit5: TEdit
        Left = 120
        Top = 53
        Width = 25
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '30'
        OnExit = RefreshBtnClick
      end
      object KaleidoscopeCheck: TCheckBox
        Left = 8
        Top = 80
        Width = 65
        Height = 17
        Caption = 'Activate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = RefreshBtnClick
      end
      object Showborders: TCheckBox
        Left = 8
        Top = 108
        Width = 137
        Height = 13
        Caption = 'Show mirrors'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = ShowbordersClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Info'
      ImageIndex = 3
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 169
        Height = 185
        Color = clYellow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'Welcome to Doodler 2!'
          ''
          'Click and drag to draw.'
          ''
          'Select PEN page to change'
          'pen color and width.  Also set'
          'color used to fill right clicked'
          'image areas.'
          ''
          'ROTATE DRAW page draws '
          'multiple copies of your drawing, '
          'each rotated by specified '
          'degrees and specified number '
          'of times.  Checkbox activates '
          'or deactivates.'
          ''
          'KALEIDOSCOPE page sets '
          'first mirror angle and angle '
          'between mirrors for '
          'kaleidoscope effect.'
          ''
          'Notes:  '
          ''
          'Kaleidoscope and rotate draw '
          'can both be activated at the '
          'same time, but you probably '
          'won'#39't like the result.'
          ''
          'Kaleidosope mirrors are '
          '"magic" 2-way virtual mirrors so '
          'entire drawing is reflected '
          'multiple times,  not just the '
          'portion between the mirrors.  '
          ''
          'Area fill changes color of '
          'clicked spot in all directions '
          'until a different color is found.  '
          'Fill is not preserved when '
          'image is redrawn so it'#39's best to '
          'save it '#39'til last.   '
          ''
          'Have fun!')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 440
    Top = 296
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'bmp|*.bmp'
    Left = 360
    Top = 296
  end
  object PrintDialog1: TPrintDialog
    Left = 528
    Top = 320
  end
end
