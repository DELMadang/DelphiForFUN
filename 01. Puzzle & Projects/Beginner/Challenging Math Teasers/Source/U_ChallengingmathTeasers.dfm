object Form1: TForm1
  Left = 389
  Top = 65
  Width = 1043
  Height = 865
  AutoSize = True
  Caption = 'Challenging Mathematical Teasers'
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
    Top = 797
    Width = 1025
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
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1025
    Height = 793
    TabOrder = 1
    object Memo5: TMemo
      Left = 24
      Top = 13
      Width = 985
      Height = 140
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        ''
        
          'Here are three problems from the 100 presented in the "Challengi' +
          'ng Mathematical Teasers" book by J.A.H. '
        
          'Hunter and published ny Dover Publications.  These puzzles gener' +
          'ally require math techniques beyond simply '
        
          'solving an algebraic equation or two.  The three presented here ' +
          'were chosen randomly are easily amenable to '
        'programmed solutions (and have relatively short descriptions :>)'
        '.'
        ''
        '')
      ParentFont = False
      TabOrder = 0
    end
    object GrandpaBtn: TButton
      Left = 16
      Top = 183
      Width = 481
      Height = 28
      Caption = '#47: Granpa'#39's Birthday (click to view solution)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 1
      OnClick = GrandpaBtnClick
    end
    object SquaresBtn: TButton
      Left = 8
      Top = 384
      Width = 481
      Height = 25
      Caption = '#44 A Matter of Squares (click to view solution)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 2
      OnClick = SquaresBtnClick
    end
    object Memo1: TMemo
      Left = 16
      Top = 208
      Width = 993
      Height = 121
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          '"Don'#39't be late now", said Susan.  Your grandfather'#39's coming over' +
          '.  It'#39's his birthday, you know."  Doug nodded. "Sure,  and I mad' +
          'e up '
        
          'something on his age.  If you add up all the ages I'#39've been , in' +
          'cluding my age now, you get one year more than his age," he repl' +
          'ied. '
        '"And the total of the two figures of his age is my age."'
        ''
        
          'What are the two ages? (The program finds several solutions, but' +
          ' probably only one with a feasible age for grandpa.)')
      ParentFont = False
      TabOrder = 3
    end
    object Memo3: TMemo
      Left = 8
      Top = 624
      Width = 993
      Height = 145
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Wendy watched with growing impatience as the clerk made out the ' +
          'check for her purchases.  "Say!" she exclaimed at last.  You '
        
          'multiplied the three amounts instead of adding them.  That'#39's cra' +
          'zy!".  "Sure I did, but it'#39's okay." the young man replied. "The ' +
          'total '
        
          'comes to $5.70 either way.  Add them up yourself."  Indeed, he w' +
          'as right. '
        ''
        
          'What were the individual amounts?  (Program needs a few tricks t' +
          'o allow calculations in cents using integer arithmetic.  Floatin' +
          'g point '
        
          'is more problematic since there is no exact binary representatio' +
          'n for any multiple of 10, thus requiring a "close enough" test w' +
          'hen '
        'comparing the product to the target.)'
        '')
      ParentFont = False
      TabOrder = 4
    end
    object WrongBtn: TButton
      Left = 8
      Top = 600
      Width = 473
      Height = 25
      Caption = '#24: Wrong but Right (click to view solution)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsItalic]
      ParentFont = False
      TabOrder = 5
      OnClick = WrongBtnClick
    end
    object Memo2: TMemo
      Left = 8
      Top = 408
      Width = 993
      Height = 145
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'Charlie stopped outside the entrance.  "Anyway it does have an i' +
          'nteresting number." he commented.  Quite unique in fact.."    "L' +
          'ooks '
        
          'very ordinary to me" George shook his head.  "But you know how I' +
          ' am about figures."  '
        
          '"Deplorable in a man of your age!'#39' Charlie smiled.  "But I'#39'll te' +
          'll you.  If you total the squares of its three digits, you'#39'll ge' +
          't exactly half that '
        'number."'
        ''
        
          'What was the number? (Fewer than 10 lines of code required to so' +
          'lve this using "mod"  and "div" operators to extract  and test t' +
          'he '
        'digits of a bunch of 3 digit even numbers.)')
      ParentFont = False
      TabOrder = 6
    end
  end
end
