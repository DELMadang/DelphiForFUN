object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Text Spinner Version 2.0'
  ClientHeight = 643
  ClientWidth = 888
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 23
  object StaticText1: TStaticText
    Left = 0
    Top = 620
    Width = 888
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2009, Gary Darby,  www.DelphiForFun.org'
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
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 886
      Height = 618
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Introduction'
        object Memo3: TMemo
          Left = 16
          Top = 16
          Width = 833
          Height = 521
          Color = 14548991
          Lines.Strings = (
            
              'Text spinning is a technique for randomly varying text based on ' +
              'user defined phrase '
            'choices embedded within  the text.'
            ''
            
              'In this implementation, "Phrase sets" of alternatives are define' +
              'd within pairs of curly brackets,'
            
              '{}.  Inside the brackets, alternative phrases, one of which will' +
              ' be randomly selected to be'
            
              'included in the output, are separated by a vertical line charact' +
              'er, |.  If a phrase set contains '
            
              'only a single phrase, it will be randomly included or omitted on' +
              ' a 50-50 basis.'
            ''
            
              'An example is included on the "Spin Text" page.  Other spinnable' +
              ' text input can be entered'
            
              'directly into  the Input form or copied and pasted from another ' +
              'source.'
            ''
            
              'Version 2 adds handling of the awkward result of the "{Not} A bu' +
              't B" structure of the Version'
            
              '1 included sample which could produce "A but B".  The syntax now' +
              ' allows %X, immediately'
            
              'following the { start symbol where X is any single letter or dig' +
              'it to uniquely identify this phrase'
            
              'set. This identifying symbol may be referenced in a later phrase' +
              ' set and the same index that'
            
              'applied to the X phrase set will be applied the the referencing ' +
              'phase set.  To allow for the'
            
              'single phrase set, I also now recognize a phrase consisting of a' +
              ' the lower case letter "b" as a'
            
              'place holder for "no phrase to be inserted" condition. Referenci' +
              'ng is indicated by an &X'
            
              'symbol+character following the opening { bracket.   So a revised' +
              ' spin might look like '
            
              '"{%1Not|b} A {&1but|and also} B." which could produce either sen' +
              'tence "Not A but B." or "A '
            'and also B."')
          TabOrder = 0
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Spin text'
        ImageIndex = 1
        object Label1: TLabel
          Left = 48
          Top = 24
          Width = 456
          Height = 23
          Caption = 'Input -  Enter or paste new spin definition text below'
        end
        object Label2: TLabel
          Left = 56
          Top = 354
          Width = 65
          Height = 23
          Caption = 'Output '
        end
        object SpinBtn: TButton
          Left = 380
          Top = 291
          Width = 86
          Height = 29
          Caption = 'Spin it!'
          TabOrder = 0
          OnClick = SpinBtnClick
        end
        object Memo1: TMemo
          Left = 41
          Top = 54
          Width = 776
          Height = 187
          Lines.Strings = (
            
              '{Ask|Fear} {%1not|b} what {your|my} {country|nation} can do {for' +
              '|to} {you|me|the '
            
              'guy down the street}, {&1but|and also} what {you|I|the guy down ' +
              'the street} can do '
            '{for|to} {your country|your nation|me|you}.'
            '')
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object Memo2: TMemo
          Left = 57
          Top = 385
          Width = 776
          Height = 179
          Lines.Strings = (
            '')
          ScrollBars = ssVertical
          TabOrder = 2
        end
        object ClearBtn: TButton
          Left = 616
          Top = 352
          Width = 217
          Height = 25
          Caption = 'Clear output area'
          TabOrder = 3
          OnClick = ClearBtnClick
        end
      end
    end
  end
end
