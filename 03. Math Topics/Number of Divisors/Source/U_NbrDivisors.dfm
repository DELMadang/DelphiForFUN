object Form1: TForm1
  Left = 103
  Top = 87
  Width = 737
  Height = 484
  Caption = 'Number of divisors investigation'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object FlipBtn: TButton
    Left = 16
    Top = 168
    Width = 697
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = FlipBtnClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 8
    Width = 697
    Height = 153
    Color = clYellow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      
        'An interesting experiment - lay out 13 cards of a single suit fa' +
        'ce down in order Ace,  2 ...Queen, King.  Starting with'
      
        'card 1, turn over every card.  Then starting with card 2, turn o' +
        'ver every 2nd card, then starting with card 3 turn over'
      
        'every 3rd card, etc., until you turn over just the 13th card on ' +
        'the 13th pass.'
      ''
      'Successive clicks on the button below will flip cards for you.'
      ''
      
        'Which cards will be face up?  Which cards would be face up if we' +
        ' had cards numbered 1 to 50?  Can you explain why? '
      
        ' Hint: The title  of this program is related to the  number of f' +
        'lips for each card value.  What is special about the number '
      'of divisors of the face up cards?')
    ParentFont = False
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 438
    Width = 729
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2002, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
