object ExplainDlg: TExplainDlg
  Left = 245
  Top = 227
  BorderStyle = bsDialog
  Caption = 'Math explination od "Digits Sum To 3"'
  ClientHeight = 454
  ClientWidth = 702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object OKBtn: TButton
    Left = 281
    Top = 406
    Width = 93
    Height = 30
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object Memo3: TMemo
    Left = 16
    Top = 30
    Width = 665
    Height = 363
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'We can mathematically determine the number without knowing the '
      
        'exact values by considering the three possible sets of digits th' +
        'at sum to '
      
        '3, namely "3", "12", and "111".  If we have 6 zeros,the number o' +
        'f ways'
      
        'to select R of them to replace with digits is the number of comb' +
        'inations'
      
        'of "6 choose R".  [N c R = N!/(N-R)!]. For the first two cases, ' +
        'the '
      
        'values are 6!/(6-1)!=6!/5!=6 and 6!/(6-2)! = 6!/4! =30.  For the' +
        ' "111" '
      
        'case, the value is 120 but because there are duplicate digit val' +
        'ues in '
      
        'this case,  duplicate results will be produced;  in fact each pe' +
        'rmutation '
      
        'of the three "1"s will produce a duplicate.  There 3! (6) of the' +
        'se, so the '
      
        'number of unique integers produced will be 120/6 = 20  and the f' +
        'inal '
      'solution will be 6+30+20=56. As the mathematicians say: "QED"!.'
      ''
      
        'In case you don'#39't know: X! to a math guy means X  factorial whic' +
        'h is '
      'shorthand for the prodict of integers 1 through N. ')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
