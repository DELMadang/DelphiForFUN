object Form1: TForm1
  Left = 418
  Top = 170
  Width = 880
  Height = 727
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 21
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 659
    ActivePage = DemoSheet
    Align = alClient
    TabOrder = 0
    object IntroSheet: TTabSheet
      Caption = 'Introduction'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 854
        Height = 623
        Align = alClient
        Color = 14548991
        Lines.Strings = (
          
            'Here is a "Delphi Techniques" program which explores semi-transp' +
            'arent shading of a TImage '
          
            'bitmap.  It was prompted by a user with a specific problem requi' +
            'ring shading of a spcified '
          
            'quandrant of a small black and white image.  The image and shadi' +
            'ng option are displayed initially '
          'on the "Blend" tab page.'
          ''
          
            'The code was derived from our DFF Graphics Effects program which' +
            ' blends two overlapped'
          
            'images.  In this case, one of the images was replaced by a singl' +
            'e color.'
          ''
          
            'In addition to solving the initial problem, the program provided' +
            ' an opportunity to explore a number '
          'of extensions including:'
          ''
          '1) Other BMP or JPEG image can be loaded for testing.'
          ''
          '2) User can select the blend color using TColorDialog.'
          ''
          
            '3) User can change the level of the blend color shold be applied' +
            ' to the blended area. (0% implies'
          
            'blend is invisible) to 100% (shaded image area hiddden completel' +
            'y).'
          ''
          
            '4) Pixel by pixel processing can be very slow for larger images.' +
            '  The program illustrates the'
          
            '"Scanline" property of TBitmaps to greatly reduces the time to a' +
            'pply blending.  A "Performance'
          'Test" button allows comparing the speed of each method.'
          ''
          
            '5) In addition to specifying the quadrant to be shaded, users ca' +
            'n click and drag to move the'
          
            'shaded area in one of two ways.  Dragging the shaded area direct' +
            'ly is very jerky and slow for a '
          
            'larger image when Pixel based blending is applied.  An is availa' +
            'ble to drag an outline only '
          
            'provides acceptable speed under those conditions.  The shaded ar' +
            'ea is then relocated one time '
          'when the dragged outline is dropped.'
          ''
          ''
          ''
          '')
        TabOrder = 0
      end
    end
    object DemoSheet: TTabSheet
      Caption = 'Blend Demo'
      ImageIndex = 1
      object Image1: TImage
        Left = 374
        Top = 234
        Width = 50
        Height = 50
        OnMouseDown = Image1MouseDown
        OnMouseMove = Image1MouseMove
        OnMouseUp = Image1MouseUp
      end
      object BlendPctLbl: TLabel
        Left = 126
        Top = 225
        Width = 67
        Height = 21
        Caption = 'Blend %'
      end
      object Label1: TLabel
        Left = 216
        Top = 216
        Width = 113
        Height = 33
        AutoSize = False
        Caption = 'Sample blended with white'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Label2: TLabel
        Left = 392
        Top = 152
        Width = 369
        Height = 81
        AutoSize = False
        Caption = 
          'For larger images, dragging the shaded area with Pixel blending ' +
          'is noticeably slower than with ScanlLne blending.  '
        WordWrap = True
      end
      object FileNameLbl: TLabel
        Left = 400
        Top = 8
        Width = 132
        Height = 21
        Caption = 'Image label here'
      end
      object ShadeLoc: TRadioGroup
        Left = 22
        Top = 65
        Width = 307
        Height = 80
        Caption = 'Quarter to shade'
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'Top Left'
          'Bottom Left'
          'Top Right'
          'Bottom Right')
        TabOrder = 0
        OnClick = ShadeLocClick
      end
      object ColorBtn: TButton
        Left = 22
        Top = 169
        Width = 227
        Height = 25
        Caption = 'Change Blend Color'
        TabOrder = 1
        OnClick = ColorBtnClick
      end
      object LoadBtn: TButton
        Left = 390
        Top = 41
        Width = 195
        Height = 25
        Caption = 'Load new image'
        TabOrder = 2
        OnClick = LoadBtnClick
      end
      object BlendColor: TPanel
        Left = 270
        Top = 161
        Width = 57
        Height = 41
        TabOrder = 3
        OnClick = ColorBtnClick
      end
      object BlendedColor: TPanel
        Left = 216
        Top = 248
        Width = 71
        Height = 40
        TabOrder = 4
      end
      object BlendPct: TSpinEdit
        Left = 128
        Top = 248
        Width = 57
        Height = 34
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 100
        MinValue = 0
        ParentFont = False
        TabOrder = 5
        Value = 50
        OnChange = BlendPctChange
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 320
        Width = 313
        Height = 289
        Caption = 'Performance'
        TabOrder = 6
        object TimeLbl: TLabel
          Left = 18
          Top = 204
          Width = 97
          Height = 21
          Caption = 'Test results:'
        end
        object BlendTechnique: TRadioGroup
          Left = 14
          Top = 25
          Width = 275
          Height = 72
          Caption = 'Blend Technique'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -18
          Font.Name = 'Arial'
          Font.Style = []
          ItemIndex = 0
          Items.Strings = (
            'Blend by Pixel'
            'Blend by ScanLine')
          ParentFont = False
          TabOrder = 0
          OnClick = ShadeLocClick
        end
        object PerformBtn: TButton
          Left = 16
          Top = 144
          Width = 273
          Height = 49
          Caption = 'Test'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -23
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = PerformBtnClick
        end
        object Displaybox: TCheckBox
          Left = 16
          Top = 112
          Width = 297
          Height = 17
          Caption = 'Display all generated panels'
          TabOrder = 2
        end
      end
      object DragBtn: TRadioGroup
        Left = 392
        Top = 72
        Width = 353
        Height = 73
        Caption = 'Click  and drag shaded area to move: '
        ItemIndex = 0
        Items.Strings = (
          'Shaded area (slower)'
          'Outline only until dropped (faster) ')
        TabOrder = 7
      end
    end
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 659
    Width = 862
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2013, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 1
    OnClick = StaticText1Click
  end
  object ColorDialog1: TColorDialog
    Left = 736
    Top = 456
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Image file (*.BMP, *..JPG)|*.BMP;*.JPG'
    Left = 744
    Top = 568
  end
end
