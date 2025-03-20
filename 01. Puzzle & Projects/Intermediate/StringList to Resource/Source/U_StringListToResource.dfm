object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = '"Text to Stringlist resource" Helper'
  ClientHeight = 643
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
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
      Left = 448
      Top = 72
      Width = 92
      Height = 16
      Hint = 'Click to change resource name'
      Caption = 'Resource type'
      ParentShowHint = False
      ShowHint = True
    end
    object ConvertBtn: TButton
      Left = 448
      Top = 307
      Width = 377
      Height = 29
      Caption = 'Convert text file to Stringlist .RES resource'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = ConvertBtnClick
    end
    object Memo1: TMemo
      Left = 17
      Top = 38
      Width = 413
      Height = 539
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'There are several programs on DFF which,in addition '
        'to the executable file,  require a text file used internally '
        'or for user display.  Here'#39's a way to embed text files '
        'into executables as resources (.res files).  They can '
        'be be retrieved within the program as TString or '
        'TStringlist components when needed.'
        ''
        'This program gets a text file name, <filename>, from'
        'the user and builds the resource script file,'
        '<filename>.rc, with a single line containing the user'
        'defined resource type, (STRINGLIST by default), and'
        'text filename.'
        ''
        'The Convert button then invokes the Borland resource'
        'compiler, BRCC32.exe, which reads <filename>.rc to'
        'compile a resource file, <filename>.res, that can be '
        'embedded into the executable program file.'
        ''
        'If the .res file is created successfully, the program '
        'displays guidelines for incorporating resource into '
        'your program.  BRCC32.exe is a command line '
        'program.  If errors are encountered, the message may '
        'not be displayed.  In that case, a search of for '
        '"Brcc32.exxe" will provide several websites with '
        'instructions for running the program as a DOS '
        'command.')
      ParentFont = False
      TabOrder = 1
    end
    object SelectBtn: TButton
      Left = 448
      Top = 27
      Width = 369
      Height = 29
      Caption = 'Select a text file'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = SelectBtnClick
    end
    object Edit1: TEdit
      Left = 448
      Top = 88
      Width = 305
      Height = 27
      Hint = 'Click to change resource name'
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 3
      Text = 'STRINGLIST'
      OnClick = Edit1Click
    end
    object Memo3: TMemo
      Left = 448
      Top = 352
      Width = 417
      Height = 249
      Lines.Strings = (
        '')
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object RichEdit1: TRichEdit
      Left = 448
      Top = 128
      Width = 417
      Height = 169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      TabOrder = 5
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Text (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 840
  end
end
