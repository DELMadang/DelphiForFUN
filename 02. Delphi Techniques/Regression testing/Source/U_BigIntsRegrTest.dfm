object Form1: TForm1
  Left = 192
  Top = 120
  Width = 800
  Height = 600
  Caption = 'Big Integers Regression Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 144
    Width = 13
    Height = 20
    Caption = 'X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 176
    Width = 13
    Height = 20
    Caption = 'Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 208
    Width = 12
    Height = 20
    Caption = 'Z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 8
    Top = 248
    Width = 62
    Height = 20
    Caption = 'Results'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object TimeLbl: TLabel
    Left = 24
    Top = 361
    Width = 74
    Height = 13
    Caption = '0 microseconds'
  end
  object Label5: TLabel
    Left = 8
    Top = 328
    Width = 24
    Height = 20
    Caption = 'R2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 8
    Top = 272
    Width = 24
    Height = 20
    Caption = 'R1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 720
    Top = 360
    Width = 32
    Height = 13
    Caption = 'Label7'
  end
  object Baselbl: TLabel
    Left = 16
    Top = 520
    Width = 57
    Height = 13
    Caption = 'Base=1,000'
  end
  object XEdit: TEdit
    Left = 32
    Top = 144
    Width = 97
    Height = 21
    TabOrder = 0
    Text = '12'
    OnDblClick = XEditDblClick
  end
  object YEdit: TEdit
    Left = 32
    Top = 176
    Width = 97
    Height = 21
    TabOrder = 1
    Text = '34'
  end
  object ZEdit: TEdit
    Left = 32
    Top = 208
    Width = 97
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object Result1edt: TEdit
    Left = 32
    Top = 272
    Width = 121
    Height = 21
    TabOrder = 3
    OnDblClick = Result1edtDblClick
  end
  object OpGrp: TRadioGroup
    Left = 168
    Top = 16
    Width = 217
    Height = 521
    Caption = 'Operations'
    ItemIndex = 0
    Items.Strings = (
      'R1 =  X + Y'
      'R1 =  X - Y'
      'R1 =  X * Y'
      'R1 =  X / Y'
      'R1 =  X ^ Y'
      'R1 =  X ^ 2'
      'R1 =  X / Y,  R2= Remainder'
      'R1 =  X * Y (Y=Int64)'
      'R1 =  X '
      'R1 =  X ,  (X=Int64)'
      'R1 =  Isodd(X)  '
      'R1 =  X!   (Factorial)'
      'R1 =  Square Root(X)'
      'R1 =  Is Probably prime (x)'
      'R1 =  X modulo Y'
      'R1 =  X modulo Y, (Y=Int64);'
      'R1 =  X ^ Y Mod Z'
      'R1 = GCD(X,Y)'
      'R1=  GCD(X,Y),  (Y=Int64)'
      'R1 = Inv(X) mod Y, (R1*X Mod Y)=1'
      'R1 = Shiftt X Left by 1Base Exponent'
      'R1 = Shift X Right by Base Exponent'
      'R1 = New Integer base  = 10^X  ')
    TabOrder = 4
  end
  object Modegrp: TRadioGroup
    Left = 24
    Top = 16
    Width = 137
    Height = 97
    Caption = 'Mode'
    ItemIndex = 0
    Items.Strings = (
      'No file processing'
      'New file'
      'Append to existing'
      'Retrieve and test')
    TabOrder = 5
    OnClick = ModegrpClick
  end
  object CalcBtn: TButton
    Left = 16
    Top = 392
    Width = 137
    Height = 25
    Caption = 'Calculate'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = GetNextBtnClick
  end
  object Memo1: TMemo
    Left = 392
    Top = 16
    Width = 393
    Height = 481
    Color = 14548991
    Lines.Strings = (
      'Big Integers Regression Test'
      ''
      
        'This is a demo rpogram for the TRegress class which help build r' +
        'egression test '
      'cases.'
      ''
      
        'This program creates or adds cases to test case files and can re' +
        'play the cases'
      
        'against a recently modified version of the TBigInts control.  Di' +
        'fferences in '
      'results are reported.'
      ''
      'A few  notes:'
      ''
      '. Input numeric values are not yet edited for validity.'
      ''
      
        '. Operations take 1, 2, or 3 operands (X, Y, Z).  Values not nee' +
        'ded for a'
      'particular function are ignored.'
      ''
      
        '. Operations return 1 or 2 values (R1, R2). R2 is set to 0 if no' +
        't returned for a'
      'particular function.'
      ''
      
        '. Boolean functions return a value in R1 (0 for false and 1 for ' +
        'true).'
      ''
      
        '. Reset during playback will restart reading of cases from the b' +
        'eginning of'
      'the file.'
      ''
      '. Double click on any field to display all digits of that field.'
      ''
      
        '. TRegression has "renumber" function and the demo program has a' +
        ' '
      
        'Renumber button to invoke the function.  Renumber makes a backup' +
        ' copy of '
      
        'the selected input case file and then updates the input file ret' +
        'aining only the '
      
        'op code and operands from each case.  Cases are renumbered and r' +
        'esults '
      'and runtimes are replaced.')
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object Result2Edt: TEdit
    Left = 32
    Top = 328
    Width = 121
    Height = 21
    TabOrder = 8
  end
  object Movetoxbtn: TButton
    Left = 32
    Top = 296
    Width = 121
    Height = 25
    Caption = 'Move R1 to X'
    TabOrder = 9
    OnClick = MovetoxbtnClick
  end
  object ResetBtn: TButton
    Left = 16
    Top = 472
    Width = 137
    Height = 25
    Caption = 'Reset'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 10
    Visible = False
    OnClick = ResetBtnClick
  end
  object RunAllBtn: TButton
    Left = 16
    Top = 432
    Width = 137
    Height = 25
    Caption = 'Run All'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    Visible = False
    OnClick = RunAllBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 549
    Width = 792
    Height = 20
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 12
    OnClick = StaticText1Click
  end
  object Button2: TButton
    Left = 400
    Top = 512
    Width = 185
    Height = 25
    Caption = 'Update Case names and renumber'
    TabOrder = 13
    OnClick = Button2Click
  end
end
