object Form1: TForm1
  Left = 412
  Top = 165
  Width = 1182
  Height = 849
  Caption = 'Accordion Solitaire V5.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 781
    Width = 1164
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, 2009  Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1164
    Height = 781
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo2: TMemo
        Left = 100
        Top = 25
        Width = 865
        Height = 656
        Color = 14548991
        Lines.Strings = (
          
            'Accordian Solitaire is a solitaire card for those who believe th' +
            'at the journey is more important than the destination.  Winning '
          
            'is very difficult, probably less than 1 in 100 unless some strat' +
            'egy is applied.'
          ''
          'Here are the rules:'
          ''
          
            'Cards are dealt out one in a row, from left to right. Whenever a' +
            ' card matches its immediate neighbor to the left, or matches'
          
            'the third card to the left, it may be moved onto that card. Card' +
            's match if they are of the same suit or same rank.'
          
            'Game play continues until the deck runs out and the game is won ' +
            'if you can reduce the entire played deck to a'
          
            'single pile.  Since no moves are mandatory, there'#39's no disadvant' +
            'age (and may be an advantage) to deal all the cards first '
          'and  them make moves.'
          ''
          
            'This program allows manual play and automates several strategies' +
            ' for program play. Manual (user) play is an option'
          
            'implemented by clicking on a source pile and then a valid destin' +
            'ation pile.'
          ''
          
            'For "program play", the ptrogram searches for a solution,  Optio' +
            'ns are:'
          ''
          
            '... "Random" randomly selects one of the available valid moves f' +
            'or the currently available visible cards.'
          ''
          
            '... "Highest first" selects  the move using the rightmost valid ' +
            'move source card.'
          ''
          
            '... "Sweepers" uses a strategy described on web page http://www.' +
            'semicolon.com/Solitaire/Articles/Accordion.html where a'
          
            'particular card value that appears near the end of the displayed' +
            ' cards is selected as the "sweeper" value and the 4 cards '
          
            'with that value are moved whenever possible and are not overlaid' +
            ' until the end game.'
          ''
          
            '... "Sweepers with Heuristics" applies additional rules to impro' +
            've the sweeper stratehgy. Currently there is only a single rule;'
          
            'to reduce end game time, the search is aborted when there is no ' +
            'matching suit or rank for any remaining card.'
          ''
          
            'The "end game" for any game requires some thought or the ability' +
            ' try try lots of moves very fast.  Computers are poor'
          
            'thinkers but can try things very rapidly, so this program uses a' +
            'n "exhaustive search" (try all possible moves) technique for the' +
            ' '
          
            'end game.  It works for the last 15 or fewer moves.  If more tha' +
            'n 15 piles remain, then trying all possible moves would require'
          
            'minutes, hours, days, years, or centuries depending on the numbe' +
            'r of piles remaining.'
          ''
          
            'For computational speed, the "auto-play" options do not display ' +
            'card images but use textual card identifiers (1-S for Ace of'
          'Spades, etc.)'
          ''
          ''
          ''
          '')
        TabOrder = 0
      end
    end
    object Manual: TTabSheet
      Caption = 'Manual play'
      ImageIndex = 2
      object Label11: TLabel
        Left = 27
        Top = 14
        Width = 157
        Height = 18
        Caption = 'Previous random seed'
      end
      object Label12: TLabel
        Left = 648
        Top = 27
        Width = 15
        Height = 18
        Caption = 'N:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object VNewBtn: TButton
        Left = 261
        Top = 23
        Width = 190
        Height = 28
        Caption = 'Make a layout'
        TabOrder = 0
        OnClick = VNewBtnClick
      end
      object VRandStart: TEdit
        Left = 27
        Top = 32
        Width = 136
        Height = 26
        TabOrder = 1
        Text = '101010'
      end
      object VUsePrevious: TCheckBox
        Left = 27
        Top = 56
        Width = 270
        Height = 19
        Caption = 'Use  key above for next game'
        TabOrder = 2
      end
      object UndoBtn: TButton
        Left = 477
        Top = 23
        Width = 154
        Height = 28
        Caption = 'Undo N moves'
        TabOrder = 3
        OnClick = UndoBtnClick
      end
      object ListBox5: TListBox
        Left = 0
        Top = 604
        Width = 1156
        Height = 72
        Align = alBottom
        Columns = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        Items.Strings = (
          'Current moves')
        ParentFont = False
        ScrollWidth = 1200
        TabOrder = 4
      end
      object RedoBtn: TButton
        Left = 738
        Top = 18
        Width = 154
        Height = 28
        Caption = 'Redo last undo'
        TabOrder = 5
        OnClick = RedoBtnClick
      end
      object ListBox6: TListBox
        Left = 0
        Top = 676
        Width = 1156
        Height = 72
        Align = alBottom
        Columns = 13
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 16
        Items.Strings = (
          'Moves from '
          'program play')
        ParentFont = False
        ScrollWidth = 1200
        TabOrder = 6
      end
      object SpinEdit1: TSpinEdit
        Left = 666
        Top = 21
        Width = 46
        Height = 28
        MaxValue = 51
        MinValue = 1
        TabOrder = 7
        Value = 1
      end
      object RedoWinBtn: TButton
        Left = 918
        Top = 18
        Width = 172
        Height = 28
        Caption = 'Replay winning moves'
        TabOrder = 8
        OnClick = ShowWinBtnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Program play'
      ImageIndex = 1
      object Label1: TLabel
        Left = 879
        Top = 655
        Width = 48
        Height = 18
        Caption = 'Label1'
      end
      object Label2: TLabel
        Left = 726
        Top = 44
        Width = 127
        Height = 19
        AutoSize = False
        Caption = 'Visible cards'
        WordWrap = True
      end
      object Label3: TLabel
        Left = 27
        Top = 18
        Width = 157
        Height = 18
        Caption = 'Previous random seed'
      end
      object Label6: TLabel
        Left = 576
        Top = 44
        Width = 75
        Height = 18
        Caption = 'Start deck '
      end
      object Label7: TLabel
        Left = 242
        Top = 99
        Width = 223
        Height = 73
        AutoSize = False
        Caption = 
          'For Random, Highest, or Sweepers, switch to end game strategy wh' +
          'en less than'
        WordWrap = True
      end
      object Label8: TLabel
        Left = 236
        Top = 153
        Width = 89
        Height = 18
        Caption = 'piles remain.'
      end
      object Label9: TLabel
        Left = 243
        Top = 324
        Width = 129
        Height = 18
        Caption = 'Multiple game limit'
      end
      object Label10: TLabel
        Left = 870
        Top = 44
        Width = 90
        Height = 18
        Caption = 'Moves made'
      end
      object Label4: TLabel
        Left = 27
        Top = 369
        Width = 351
        Height = 18
        Caption = 'Game time limit ( seconds before abandon search)'
      end
      object Stopbtn: TButton
        Left = 18
        Top = 270
        Width = 208
        Height = 73
        Caption = 'Stop'
        TabOrder = 0
        Visible = False
        OnClick = StopbtnClick
      end
      object Howgrp: TRadioGroup
        Left = 18
        Top = 90
        Width = 208
        Height = 163
        Caption = 'Move selection strategy'
        ItemIndex = 2
        Items.Strings = (
          'Random play'
          'Highest move first'
          '"Sweepers"'
          '"Sweepers" w/Heuristics')
        TabOrder = 1
        OnClick = HowgrpClick
      end
      object PlayBtn: TButton
        Left = 27
        Top = 270
        Width = 199
        Height = 28
        Caption = 'Play a game'
        TabOrder = 2
        OnClick = PlayBtnClick
      end
      object Memo1: TMemo
        Left = 9
        Top = 432
        Width = 460
        Height = 206
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Run stats display here. ')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object ListBox3: TListBox
        Left = 726
        Top = 62
        Width = 136
        Height = 577
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        TabOrder = 4
      end
      object Play100Btn: TButton
        Left = 27
        Top = 315
        Width = 199
        Height = 28
        Caption = 'Play  multiple games'
        TabOrder = 5
        OnClick = Play100BtnClick
      end
      object randstart: TEdit
        Left = 27
        Top = 36
        Width = 136
        Height = 26
        TabOrder = 6
        Text = '123456'
      end
      object TryAll: TSpinEdit
        Left = 412
        Top = 135
        Width = 46
        Height = 28
        MaxValue = 52
        MinValue = 1
        TabOrder = 7
        Value = 10
      end
      object GameLimit: TSpinEdit
        Left = 386
        Top = 315
        Width = 64
        Height = 28
        MaxValue = 1000
        MinValue = 1
        TabOrder = 8
        Value = 100
      end
      object ListBox4: TListBox
        Left = 870
        Top = 62
        Width = 226
        Height = 577
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        TabOrder = 9
      end
      object Endgame: TRadioGroup
        Left = 242
        Top = 180
        Width = 208
        Height = 73
        Caption = 'End game strategies'
        ItemIndex = 1
        Items.Strings = (
          'Manual play'
          'Exhaustive search')
        TabOrder = 10
      end
      object Useprevious: TCheckBox
        Left = 207
        Top = 27
        Width = 346
        Height = 46
        Caption = 
          'Use  current deck for for next game. Otherwise random deck will ' +
          'be created'
        TabOrder = 11
        WordWrap = True
        OnClick = UsepreviousClick
      end
      object ShowWinBtn: TButton
        Left = 242
        Top = 270
        Width = 208
        Height = 28
        Caption = 'Click to animate replay'
        TabOrder = 12
        OnClick = ShowWinBtnClick
      end
      object TimeLimit: TSpinEdit
        Left = 386
        Top = 369
        Width = 64
        Height = 28
        MaxValue = 600
        MinValue = 1
        TabOrder = 13
        Value = 120
      end
      object ListBox1: TListBox
        Left = 573
        Top = 62
        Width = 136
        Height = 577
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        TabOrder = 14
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Left = 632
    Top = 16
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 680
    Top = 16
  end
end
