object Form1: TForm1
  Left = 323
  Top = 122
  AutoScroll = False
  AutoSize = True
  Caption = 'Linear Least Squares'
  ClientHeight = 578
  ClientWidth = 942
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 556
    Width = 942
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 942
    Height = 556
    Align = alClient
    TabOrder = 1
    object Image1: TImage
      Left = 35
      Top = 216
      Width = 659
      Height = 271
    end
    object Label1: TLabel
      Left = 752
      Top = 24
      Width = 52
      Height = 18
      Caption = '  X      Y'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object EquationLbl: TLabel
      Left = 48
      Top = 496
      Width = 196
      Height = 22
      Caption = 'Best fit line:  y = Mx + B'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object RLbl: TLabel
      Left = 48
      Top = 528
      Width = 176
      Height = 18
      Caption = 'Corelation Coefficient (R)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object R2Lbl: TLabel
      Left = 464
      Top = 528
      Width = 75
      Height = 18
      Caption = 'R Squared'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo5: TMemo
      Left = 28
      Top = 32
      Width = 661
      Height = 177
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Find the best fit linear least squares  line for a given set of ' +
          'X,Y points. This is the unique line which '
        
          'minimizes the sum of squares of the differences between  the Y v' +
          'alue for each X point and the Y '
        'value for the line at that X.  Whew!'
        ' '
        
          'New points may be pasted or entered in the data area a  at right' +
          '.  Enter one X and one Y value per '
        'line separated by at least one space character. '
        ' '
        
          'The Calculate button generates the slope (M) and intercept (B) f' +
          'or the least squares line  as '
        
          'defined by the equation y = Mx + B.  The input points and the be' +
          'st fit  line are displayed below.')
      ParentFont = False
      TabOrder = 0
    end
    object Memo1: TMemo
      Left = 726
      Top = 50
      Width = 162
      Height = 415
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      TabOrder = 1
      OnExit = Memo1Exit
    end
    object CalcBtn: TButton
      Left = 720
      Top = 480
      Width = 201
      Height = 25
      Caption = 'Calculate best fit line'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = CalcBtnClick
    end
  end
end
