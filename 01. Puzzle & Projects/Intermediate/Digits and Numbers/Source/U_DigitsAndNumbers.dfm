object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  Caption = 'Digits and Numbers'
  ClientHeight = 512
  ClientWidth = 559
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 489
    Width = 559
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 559
    Height = 489
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object Memo6: TMemo
        Left = 16
        Top = 16
        Width = 505
        Height = 385
        Color = 14483455
        Lines.Strings = (
          'Here are program solutions fo a few problems adapted from the'
          'latest Dover Publications addition  to my library, "Challenging'
          'Mathematical Teasers" by J.A.H. Hunter.'
          ''
          
            'The puzzles I selected all involve extracting diigits from numbe' +
            'rs'
          'which is easy once you see how it'#39's done.'
          ''
          'Decimal number systems are almost universal in modern '
          
            'civilizations, probably because of the evolution provided most o' +
            'f us '
          
            'with 10 fingers.    Western civilizations use the positional sys' +
            'tem'
          
            'developed by Indian mathematicians about 2000 years ago.  In tha' +
            't '
          
            'system  successive powers of 10 are represented by their positio' +
            'ns '
          'from right to left.  One of the consequences is that we need'
          'something to represent the absence of any power of 10 in that '
          'position, thus "zero" was born.'
          ''
          
            'Western countries use  the 10 symbols '#39'0'#39' through '#39'9'#39' so, for ex' +
            'ample '
          
            'the number 1023 represents a quantity equal to 1000 things plus ' +
            '20 '
          'things plus 3 things.'
          ''
          
            'Only two operations are required to extract the digits from a nu' +
            'mber'
          
            'within a program.  "a Div b"  is integer division and returns th' +
            'e whole'
          'number quotient, dropping any remainder, and "a Mod b", the'
          
            'modulus function, which returns the remainder when "a" is divide' +
            'd by'
          
            '"b".  So "1023 mod 10" returns 3 effectively dropping all except' +
            ' the'
          
            'low order digit. Also "1023 div 3" returns 102, in effect shifti' +
            'ng the'
          
            'number one position to the right and/or dropping the low order d' +
            'igit,'
          
            'whichever way you prefer to think about it. Repeating the "mod" ' +
            'and'
          
            '"div" operations in a similar manner "102", then on "10" then on' +
            ' "1"'
          'can extract all of the digits into separate variable fields.'
          ''
          
            'As an example, given the problem: "Find the  3 digit numbers whi' +
            'ch'
          
            'are 35 times the sum of its digits.",  The essential Delphi solu' +
            'tion'
          'code'
          'looks like this  (Comments are enclosed in curly brackets  {}):'
          ''
          ' for n:=100 to 999 do'
          ' begin'
          '   test:=n; {Make "test" the work field}'
          
            '   sum:=test mod 10; {Put the low order digit of "test" into "su' +
            'm"}'
          '   test:=test div 10; {shift "test" one digit to the right}'
          '   sum:=sum + test mod 10; {add the second digit to sum}'
          '   test:=test div 10; {get down to the final digit}'
          '   sum:=sum+ test; {add it to "sum"}'
          '   {is n an exact multiple of sum and does n div sum =35?}'
          '   if (n mod sum = 0) and (n div sum =35)'
          '   then showmessage(  '#39'The number '#39'+inttostr(n) +'#39'  is '#39
          '                   + '#39' 35 times the sum  of its digits!'#39');'
          ' end;'
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object ExampleBtn: TButton
        Left = 208
        Top = 416
        Width = 75
        Height = 25
        Caption = 'Example'
        TabOrder = 1
        OnClick = ExampleBtnClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Number 16'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 27
        Top = 10
        Width = 406
        Height = 127
        Lines.Strings = (
          'John and Mary have 3 children under the age of 10.  One '
          'day he noticed that if he wrote the ages in a certain order '
          'and condered the result as a 3 digit number, the number '
          'was exactly 32 times greater than the sum of their ages.'
          ''
          'How old are the children?')
        TabOrder = 0
      end
      object AgeBtn: TButton
        Left = 28
        Top = 144
        Width = 125
        Height = 28
        Caption = 'Find Ages'
        TabOrder = 1
        OnClick = AgeBtnClick
      end
      object ExtraBtn: TButton
        Left = 32
        Top = 360
        Width = 137
        Height = 25
        Caption = 'Extra credit'
        TabOrder = 2
        OnClick = ExtraBtnClick
      end
      object Memo7: TMemo
        Left = 27
        Top = 232
        Width = 390
        Height = 121
        Lines.Strings = (
          'In the previous problem there is only one three digit '
          'number which is 32 times the sum of its digits.'
          ''
          'For extra credit, what are the smallest and largest '
          'numbers which are a unique product of the sum of their '
          'digits?')
        TabOrder = 3
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Number 17'
      ImageIndex = 2
      object Memo2: TMemo
        Left = 51
        Top = 18
        Width = 253
        Height = 190
        Lines.Strings = (
          'John discovered that his phone '
          'number had an unusual '
          'characteristic. If he treated it as a '
          '7 digit number and then moved the '
          'first 3 digits to the end, he gets a '
          'number that is one gretaer than '
          'twice the original number.'
          ''
          'I.e. 2*abcdefg+1=defgabc')
        TabOrder = 0
      end
      object PhoneBtn: TButton
        Left = 60
        Top = 216
        Width = 237
        Height = 28
        Caption = 'Find Phone #'
        TabOrder = 1
        OnClick = PhoneBtnClick
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Number 47'
      ImageIndex = 3
      object Memo3: TMemo
        Left = 27
        Top = 18
        Width = 253
        Height = 190
        Lines.Strings = (
          'Doug said "Today is my '
          'Grandfather'#39's birthday  and I made '
          'up something on his age.  If you '
          'add up all of the ages that have '
          'been, including my age now, you'
          'get one more than his age.  Plus '
          'the total of the two digit in his age '
          'is my age."'
          ''
          'What are the two ages?')
        TabOrder = 0
      end
      object GrandPaBtn: TButton
        Left = 28
        Top = 216
        Width = 245
        Height = 28
        Caption = 'Find Grandpa'#39's age'
        TabOrder = 1
        OnClick = GrandPaBtnClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Number 61'
      ImageIndex = 4
      object LicenseBtn: TButton
        Left = 28
        Top = 225
        Width = 245
        Height = 28
        Caption = 'Find  the license plates'
        TabOrder = 0
        OnClick = LicenseBtnClick
      end
      object Memo4: TMemo
        Left = 27
        Top = 18
        Width = 253
        Height = 199
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Arial'
        Font.Pitch = fpFixed
        Font.Style = []
        Lines.Strings = (
          ' "I found something very interesting '
          'about your license plate" said Stan.'
          '"It'#39's one  more than the number you '
          'get if you square the two halves and '
          'add  them together.  You'#39're number '
          'is 403491" and the two halves '
          'squared sum to 403490"  '
          ''
          'Are there any othe 6 digit numbers '
          'that have this  property?}')
        ParentFont = False
        TabOrder = 1
      end
      object Memo5: TMemo
        Left = 36
        Top = 270
        Width = 424
        Height = 154
        Lines.Strings = (
          '')
        TabOrder = 2
      end
    end
  end
end
