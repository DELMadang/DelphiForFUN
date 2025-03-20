object Form1: TForm1
  Left = 310
  Top = 154
  AutoScroll = False
  Caption = 'Memo Click Demo'
  ClientHeight = 536
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 513
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
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
    Height = 513
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 240
      Top = 432
      Width = 421
      Height = 23
      Caption = 'Clicked line and character positions display here'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Memo1: TMemo
      Left = 41
      Top = 38
      Width = 820
      Height = 340
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -22
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Here'#39's a simple little program which illustrates  the Delphi tec' +
          'hniques for '
        
          'recognizing user clicks on  a Tmemo and determining the line num' +
          'ber and the '
        'position within the line where the click occurred.'
        ''
        
          'I have used the techniques previously but always had difficulty ' +
          'finding exactly'
        
          'where and how to do it.  The solution is two functions addedto o' +
          'ur DFFUtils unit.'
        ''
        
          'Function ClickedMemoLine(Memo:TMemo):integer;  returns the line ' +
          'number'
        
          'clicked relativeto 0 (the first line has line number 0).  For th' +
          'e forgetful (me), '
        
          'alternative names for this function are: ClickedMemoLine, MemoLi' +
          'neClicked, and  '
        'LineNumberClicked.'
        ''
        
          'Function LinePositionClicked(Memo:TMemo):integer returns the pos' +
          'ition'
        
          'clicked within the line relative to 1 (the first character in th' +
          'e line is position number'
        
          '1);  For the forgetful (me), alternative names for this function' +
          ' are: '
        'ClickedMemoPosition and MemoPositionClicked.'
        ''
        
          'To test the routines, click anywhere on this memo and the progra' +
          'm will report the'
        'line and position clicked.')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnClick = Memo1Click
    end
  end
end
