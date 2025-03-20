object Form1: TForm1
  Left = 207
  Top = 65
  Width = 772
  Height = 580
  AutoSize = True
  Caption = 'OnIdle Exit Demo '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 14
  object StaticText1: TStaticText
    Left = 0
    Top = 520
    Width = 756
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
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 756
    Height = 520
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 456
      Top = 256
      Width = 124
      Height = 16
      Caption = '# of integers checked'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo5: TMemo
      Left = 28
      Top = 32
      Width = 413
      Height = 465
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'The Delphi Application.OnIdle exit is a reasonable way to perfor' +
          'm '
        
          'background calculations in your program. It gets called eveytime' +
          ' your '
        'program has nothing else to do.'
        ''
        
          'The trick is to avoid interefering with user actions by minimizi' +
          'ng'
        
          'the amount of work done on each entry.  I use the technique when' +
          ' '
        
          'the program wants to solve a puzzle in the background while the ' +
          'user '
        
          'works on finding a solution in the foreground.  Finding the solu' +
          'tion in '
        'the background minimizes user wait time when he asks for the '
        'solution or a hint.'
        ''
        
          'In this example, we'#39'll calculate the average digit value for 100' +
          ' million'
        'random 5 digit integers (10,000 to 99,999).  This takes about '
        
          '8 seconds on my Dell Studio 17 laptop; long enough to demonstrat' +
          'e '
        'the effects of foreground vs background processing.'
        ''
        
          'The "Foreground calculation" button performs the calculation wit' +
          'hout '
        
          'using the OnIdle exit.  The routine does not check for user acti' +
          'ons so '
        
          'attempts to enter text in the memo box will not be processed unt' +
          'il '
        'calculations are complete.'
        ''
        
          'The "Background calculation" button uses the OnIdle Exit to  per' +
          'form '
        
          'the same calculation but only calculates 10,000 integers on each' +
          ' '
        
          'entry.  This will lock the the user out, but only for a millisec' +
          'ond or so '
        
          'at a time so he is unlikely to notice..  For each key press in t' +
          'he '
        
          'memo, the text below the memo wil display the number of integers' +
          ' '
        'processed so far.')
      ParentFont = False
      TabOrder = 0
    end
    object NoInterruptBtn: TButton
      Left = 456
      Top = 32
      Width = 257
      Height = 25
      Caption = 'Foreground calculation (No OnIdle exit)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = NoInterruptBtnClick
    end
    object OnIdleExitBtn: TButton
      Left = 456
      Top = 72
      Width = 257
      Height = 25
      Caption = 'Background calculation (Uses OnIdle exit)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Comic Sans MS'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = OnIdleExitBtnClick
    end
    object Memo1: TMemo
      Left = 456
      Top = 304
      Width = 257
      Height = 193
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Calculation results  display here')
      ParentFont = False
      TabOrder = 3
    end
    object Memo2: TMemo
      Left = 456
      Top = 112
      Width = 257
      Height = 137
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Try to enter some text '
        'here while calculations '
        'are running.')
      ParentFont = False
      TabOrder = 4
      OnChange = Memo2Change
    end
  end
end
