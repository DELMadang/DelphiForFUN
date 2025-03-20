object Form1: TForm1
  Left = 192
  Top = 114
  Width = 1047
  Height = 500
  Caption = 'Fast Highlighting Test'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 32
    Top = 40
    Width = 124
    Height = 18
    Caption = 'Words to highlight'
  end
  object Keywords: TMemo
    Left = 32
    Top = 64
    Width = 129
    Height = 137
    Lines.Strings = (
      'play'
      'forever'
      'highlight             '
      'highlighting'
      'highlighted')
    TabOrder = 0
  end
  object ColorBtn: TPanel
    Left = 32
    Top = 216
    Width = 177
    Height = 25
    Caption = 'Set Highlight Color'
    TabOrder = 1
    OnClick = ColorBtnClick
  end
  object ToggleBtn: TPanel
    Left = 32
    Top = 256
    Width = 185
    Height = 25
    Caption = 'Toggle highlighted text'
    TabOrder = 2
    OnClick = TogglebtnClick
  end
  object RichEdit1: TRichEdit
    Left = 368
    Top = 32
    Width = 617
    Height = 369
    Lines.Strings = (
      
        'Highlighting text in a RichEdit control can be a slow process if' +
        ' formatting is physically '
      'inserted into the control.'
      ''
      
        'The technique illustrated here intercepts the richedit WindowPro' +
        'c" call and checks '
      
        'only the current visible page for highlighted words after we let' +
        ' the original window proc '
      
        'paint the window.  Words to be highlighted are rewritten in the ' +
        'desired highlighting '
      
        'color.  One significant  restriction of this method is that the ' +
        'highlighted word must fit in '
      
        'the same width as the original word. This demo uses the richedit' +
        ' font for highlighted '
      
        'words, changing only the color.  If a fixed width font such as C' +
        'ourier New is used, '
      
        'highlighting could include font style (bold or italic, for examp' +
        'le).'
      ''
      
        'This program illustrates the simplest form, highlighting words b' +
        'y repainting them is the '
      'selected color.'
      ''
      
        'The remainder of the text below is simply to check some word rec' +
        'ognitions and '
      'highlighting across multiple pages.'
      ''
      '---------------------------------------------------------'
      ''
      
        'We can sing and play many songs especially if we highlight the w' +
        'ord play.'
      ''
      'Play it again forever Sam!'
      ''
      'Play, plAy, PLAY, Play? plaY!'
      ''
      'We'
      'need'
      'to make'
      'enough'
      'lines'
      'to check that'
      'highlight'
      'across'
      'pages'
      'works'
      'OK.'
      ''
      
        'And now on page 2 or 3, we should still be able to highlight the' +
        ' words "play" and '
      '"forever"')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 444
    Width = 1031
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2008, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object ColorDialog1: TColorDialog
    Left = 248
    Top = 152
  end
end
