object Form1: TForm1
  Left = 590
  Top = 203
  AutoScroll = False
  AutoSize = True
  Caption = 'The "MUSIC" Box Puzzle'
  ClientHeight = 643
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -23
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 26
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
    object ResetBtn: TButton
      Left = 772
      Top = 371
      Width = 86
      Height = 29
      Caption = 'Reset'
      TabOrder = 0
      OnClick = ResetBtnClick
    end
    object Memo1: TMemo
      Left = 41
      Top = 22
      Width = 472
      Height = 435
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Calabri'
      Font.Style = []
      Lines.Strings = (
        'Using the letters in the word MUSIC place one letter in '
        'each cell so that no two identical letters are in the same '
        'row, column, or diagonal.  We'#39've started you off with four '
        'letters. (Source: MENSA Puzzle-A-Day Calendar, May 1, '
        '2011)'
        ''
        'To place a letter, use arrow keys or the mouse to select a '
        'cell, then enter a letter.  Double click on an occupied cell '
        'to clear it.  To help you stay on track, only valid choices '
        'for the selected cell are allowed.'
        ''
        'Two hint levels are available if you need help; showing '
        'the number of available letters for each cell leaves a little '
        'work for you, showing the actual available letters for '
        'each cell makes solving trivial.  Even without hints, there '
        'are always one or more cells with only a single choice. '
        'For example, check the bottom right corner for which 4 of '
        'the 5 letter choices are already tasken.  When that cell '
        'has been filled, there is only one choce left for rightmost '
        'column in row 3. Then you'#39're on your way!')
      ParentFont = False
      TabOrder = 1
    end
    object Grid: TStringGrid
      Left = 536
      Top = 24
      Width = 329
      Height = 329
      DefaultRowHeight = 64
      DefaultDrawing = False
      FixedCols = 0
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Calibri'
      Font.Style = []
      Options = [goVertLine, goHorzLine, goDrawFocusSelected]
      ParentFont = False
      TabOrder = 2
      OnDblClick = GridDblClick
      OnDrawCell = GridDrawCell
      OnKeyPress = GridKeyPress
      OnMouseMove = GridMouseMove
    end
    object HintGrp: TRadioGroup
      Left = 40
      Top = 472
      Width = 657
      Height = 105
      Caption = 'Show hint'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'No hints (Hardest)'
        
          'Show the number of letters that might be correct for each cell (' +
          'Medium difficulty)'
        'Show the letters that might be correct for each cell (Easy)')
      ParentFont = False
      TabOrder = 3
      OnClick = HintGrpClick
    end
  end
end
