object Form1: TForm1
  Left = 384
  Top = 191
  Width = 800
  Height = 600
  Caption = 'Rectangle Counts'
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
    Top = 540
    Width = 784
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2012, Gary Darby,  www.DelphiForFun.org'
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
    Width = 784
    Height = 540
    Align = alClient
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 782
      Height = 488
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Here'#39's a puzzle sent to me by a viewer who says it is from a set' +
          ' of questions written by '
        
          'computer pioneer and inventor Sir Clive Sinclair. They were  pub' +
          'lished many years ago as '
        
          '"Mensa Steps" in a magazine, perhaps "Design Technology" as the ' +
          'viewer recalls ,'
        '==========================='
        
          '"If you draw a nine by nine square, thus giving yourself eightyo' +
          'ne small squares in total; '
        
          'how many rectangles can you count in total? "   (Squares are rec' +
          'tangles, by the way.)'
        '==========================='
        ''
        
          'One of my standard problem solving strategies is to "simplify"; ' +
          'solve a smaller version of'
        
          'the program and hope that it provides a clue to solving the larg' +
          'er one.  The button below'
        
          'will generate the number of rectangles for grids from from 1x1 t' +
          'o 9x9.  It does it in a'
        
          'nested loop by summing all rectangle counts from 1x1 to NxN for ' +
          'each NxN grid.'
        ''
        
          'I did not discover the generating function based solely on the r' +
          'esults, but if you search on'
        
          'the sequences of results (1,9,36,100,225,441) you'#39'll find lots o' +
          'f fascinating information'
        
          'including the formula at http://oeis.org/A000537.  Also notice t' +
          'hat the numbers in the'
        
          'sequence are perfect squares of the sequence 1,3,6,10,15.... The' +
          'se are called '
        
          '"triangular numbers" with the property that the Nth member is th' +
          'e number of dots in an '
        'equilateral triangle with N dots per side! See '
        
          'http://en.wikipedia.org/wiki/Squared_triangular_number for more ' +
          'interesting information.'
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Button1: TButton
      Left = 286
      Top = 501
      Width = 203
      Height = 25
      Caption = 'Count Rectangles'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
