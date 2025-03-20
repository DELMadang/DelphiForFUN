object Form1: TForm1
  Left = 37
  Top = 61
  Width = 640
  Height = 480
  Caption = 'A Weighty Problem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 336
    Width = 88
    Height = 13
    Caption = 'Number of weights'
  end
  object Label2: TLabel
    Left = 360
    Top = 16
    Width = 113
    Height = 13
    Caption = 'Best solutions so far'
  end
  object Label3: TLabel
    Left = 184
    Top = 320
    Width = 161
    Height = 73
    AutoSize = False
    Caption = 
      'If watching the program search isn'#39't your cup of tea, click the ' +
      'button below to test your weighing skills.  (Set the number of w' +
      'eights first.)'
    Color = clYellow
    ParentColor = False
    WordWrap = True
  end
  object NbrWeightsUD: TUpDown
    Left = 49
    Top = 356
    Width = 16
    Height = 21
    Associate = Edit1
    Min = 1
    Max = 5
    Position = 3
    TabOrder = 0
    Wrap = False
  end
  object Edit1: TEdit
    Left = 24
    Top = 356
    Width = 25
    Height = 21
    TabOrder = 1
    Text = '3'
  end
  object SearchBtn: TButton
    Left = 24
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Search'
    TabOrder = 2
    OnClick = SearchBtnClick
  end
  object ListBox1: TListBox
    Left = 360
    Top = 40
    Width = 257
    Height = 377
    ItemHeight = 13
    TabOrder = 3
  end
  object ScaleBtn: TButton
    Left = 184
    Top = 400
    Width = 105
    Height = 25
    Caption = 'Play with scale'
    TabOrder = 4
    OnClick = ScaleBtnClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 16
    Width = 337
    Height = 297
    Caption = 'Panel1'
    Color = clYellow
    TabOrder = 5
    object Memo1: TMemo
      Left = 16
      Top = 8
      Width = 305
      Height = 281
      BorderStyle = bsNone
      Color = clYellow
      Lines.Strings = (
        'Once some kids wanted to set up a lemonade stand to make '
        'some money.  To set themselves apart from the other lemonade '
        'stands on the block, they decided to sell their lemonade by the '
        'pound.   They found an old balance beam scale, the kind with a '
        'weight pan on each side, and three  weights.    They discovered '
        'that they could sell any whole number of pounds from 1 to 13.  '
        'What weights did they have.?'
        ''
        'This weighing program searches for weight values which allow '
        'measurement of the maximum number of items in whole number '
        'incemements.   You can choose  the number of weights from 1 '
        
          'to 5.  (Searching for best 5 weights will take a munute or two.)' +
          '  '
        'After seeing the values for a few, you will see the pattern '
        'and be able to assign weight values for any number of weights.  '
        ''
        
          'Another interesting question is "What is the largest item that c' +
          'an '
        'be weighed with such a set?"   The answer turns out to be '
        '(3^n-1)/2.  For 3 weights that is (27-1)/2 or 13.  How many '
        'weights are necessary to weigh any item from 1 to 100?'
        '')
      TabOrder = 0
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 434
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright 2002, Gary Darby,  www.delphiforfun.org'
        Width = 250
      end>
    SimplePanel = False
  end
end
