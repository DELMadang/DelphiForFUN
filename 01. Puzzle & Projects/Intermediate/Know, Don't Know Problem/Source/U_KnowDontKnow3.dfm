object Form1: TForm1
  Left = 356
  Top = 115
  Width = 1197
  Height = 883
  Caption = 'The Know/Don'#39't Know Problem  V3.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 21
  object Label3: TLabel
    Left = 43
    Top = 725
    Width = 111
    Height = 25
    Caption = 'Maximum #'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 743
    Top = 662
    Width = 103
    Height = 25
    Caption = 'Solution(s)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1179
    Height = 620
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Introduction'
      object IntroMemo: TMemo
        Left = 0
        Top = 0
        Width = 1171
        Height = 584
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Two integers, A and B, each between 2 and 100 inclusive, have be' +
            'en chosen.  The product, AB, is given to '
          
            'mathematician Dr. P.  The sum, A+B, is given to mathematician Dr' +
            '. S. They each know the range of numbers.  Their'
          'conversation is as follows:2'
          ''
          'P: "I don'#39't have the foggiest idea what your sum is, S."'
          ''
          
            'S: "That'#39's no news to me, P. I already knew that you didn'#39't  kno' +
            'w.  I don'#39't know your product either."'
          ''
          'P: "Aha, Now I know what your sum must be, S!"'
          ''
          'S: "And likewise P, I have figured out your product!!"'
          ''
          'Time for you to play Sherlock Holmes: find the integers A and B.'
          ''
          
            'Note: Version 2 allows you change the upper limit for the allowe' +
            'd integers (up to 1000).  This may result in more than one '
          
            'pair of integers which meet the conditions implied by the above ' +
            'conversation.  So either the lower limit would have to be '
          
            'increased to make a pair unique; or the conversation should be m' +
            'odified slightly.'
          ''
          
            'Version 3:  The search for a solution when neither the sum nor p' +
            'roduct ius known is a different problem than that faced by'
          
            'the professors.  Version 3  adds a "Walkthrough" page simulating' +
            ' the thinking of the professors once we know what sum'
          
            'and product to reveal to each.  V3.1 adds an interactive walk-th' +
            'rough page given any sum and product.   (I used it to'
          'verify program generated solutions.)')
        ParentFont = False
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Approach to solving'
      ImageIndex = 1
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 1171
        Height = 584
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -22
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            #160'Note that even though there are similarities,  our problem, fin' +
            'ding the solution or solutions '
          
            'to the problem without knowing either the sum or product of the ' +
            'two numbers is a much '
          'larger problem than the professors faced.'
          ''
          
            'Observation 1: The product A'#215'B can'#39't be the product of 2 primes,' +
            ' otherwise Dr. P would  '
          'know the solution.'
          ''
          
            'Observation 2: The product also cannot be the cube of a prime ot' +
            'herwise there would only '
          
            'be one choice for A and B (p2 * p) and Dr. P would have figured ' +
            'that out also.'
          ''
          
            'Observation 3: The sum A+B given to Dr. S must not be expressibl' +
            'e as sum of two primes, '
          
            'otherwise Dr. S could not have been sure in advance that Dr. P d' +
            'id not know the numbers.'#160
          ''
          
            'Action 1: So we will make a list of all possible sums which pass' +
            ' the filters defined by the '
          
            'above three observations. Call it SumList1.  (Dr. S at this poin' +
            't would need only to examine '
          
            'pairs of numbers that sum to his given value.  See the "Walk-thr' +
            'ough" page for specifics.)'
          ''
          
            'Observation 4: Since Dr. P says that he knows the numbers in his' +
            ' second response, there'
          
            'must be only one factorization of his product into two numbers w' +
            'hose sum is in Sumlist1.'
          
            '(Dr. P at this point only knows the pairs of numbers which sum t' +
            'o the two term  factorizations'
          
            'of the product he was given.  See the Walk-through page for spec' +
            'ifics.)'
          ''
          
            'Action 2: Once he knows that Dr. P had a unique factorization, D' +
            'r. S is smart enough to'
          
            'make a second list from his first sum list keeping those that me' +
            'et the criteria of Observation '
          
            '4. Of these possible pairs, there must be only one whose sum occ' +
            'urs in only one way, otherwise'
          
            'Dr. S could not say that he knows the number also.  We will do t' +
            'he same thing with our larger'
          'sum list.'
          ''
          
            'Action 3: For our solution, by keeping a count of how many times' +
            ' each unique sum'
          
            'occurs (and the numbers that form that sum) in Sumlist2, we find' +
            ' unique sums.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'SumLists'
      ImageIndex = 2
      object Label1: TLabel
        Left = 33
        Top = 11
        Width = 186
        Height = 61
        AutoSize = False
        Caption = 'SumList1 - possible solution A + B sums'
        WordWrap = True
      end
      object Label2: TLabel
        Left = 360
        Top = 11
        Width = 470
        Height = 64
        AutoSize = False
        Caption = 
          'Sumlist2 - The number of ways that P'#39's potential products can be' +
          ' spilt into 2 factors whose sum is on Sumlist1.  Count must = 1 ' +
          'for a solution.'
        WordWrap = True
      end
      object ListBox2: TListBox
        Left = 33
        Top = 89
        Width = 164
        Height = 469
        ItemHeight = 21
        TabOrder = 0
      end
      object ListBox3: TListBox
        Left = 360
        Top = 95
        Width = 359
        Height = 463
        ItemHeight = 21
        TabOrder = 1
      end
    end
    object TabSheet4: TTabSheet
      Caption = ' Walk-through '
      ImageIndex = 3
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 1171
        Height = 584
        Align = alClient
        Color = 14548991
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          
            'Understanding and verifying the logic of the conclusions reached' +
            ' by the professors is difficult without a specfic example. So'
          
            'pretending that we do not know the solution, here is a walkthrou' +
            'gh given thar Dr.S has received sum 17 and Dr P has received  '
          
            'the product  52.  They both know that they are searching for two' +
            ' integers between 2 and 100 and that S has the sum abd P has '
          'the product  of the two numbers.'
          ''
          'S Observation 1:'
          '----------------'
          
            'My sum 17 so the two numbers must be one of (2,15), (3,14), (4,1' +
            '3), (5,12), (6,11), (7,10), or (8,9).   That means that , P'#39's  '
          
            'product is one of 30 (2x3x5),42, (2x3x7), 52 (2x2x13), 60 (2x2x3' +
            'x5), 66 (2x3x11), 70 (2x5x7), or 72 (2x2x2x3x 3).   This might  '
          'come in handy   later.'
          ''
          'P Observation 1:'
          ' ----------------'
          
            'My product is 52 which factors as 2x2x13 so the two solution num' +
            'bers must be (2 & 26) or (4 & 13) and S'#39's sum is 28, or  17. It '
          
            'seems that they are equally likely  so I might as well tell S th' +
            'at "I don'#39't know what the two number are."'
          ''
          'S Observation 2: '
          '---------------- '
          
            'I noticed that all seven of P'#39's possible products can all be exp' +
            'ressed as the product of two numbers in more than one way, so I '
          'can tell him: "I already knew that you would not know."'
          ''
          'P Observation 2: '
          '----------------'
          
            'I had previously decided that S'#39's sum must be 28 or 17 but, once' +
            ' S said that, I know that his sum cannot be 28 because if it'
          
            'were, he would have realized the numbers could possibly be 5+23,' +
            ' 2 primes,  and he could not know for sure that I didn'#39't know.'
          
            'If his sum  is not 28, it  must be 17.  As a double check, his s' +
            'um of 17 cannot be expressed as the some of two primes, so I'#39'm'
          'sure I can say:  "I now  know your sum  and the two numbers".'
          ''
          'S Observation 3:'
          ' ----------------'
          
            'Well, I'#39'll be darned - the only way he could know the the number' +
            ' is if he has eliminated all of the ways that he can factor his'
          
            'product into two  parts except one.  He must have done this by l' +
            'ooking at all of the ways that sums of factors of each of the tw' +
            'o'
          
            'term factorizations  can be  divided into two term-factors that ' +
            'are prime numbers. If for any of his possible products, I can'
          
            'eliminate all but my acutal sum  because the  sum can be express' +
            'ed as the sum of two primes, that one will be answer. It may'
          
            'take a while, but I know all of the possible  products so I'#39'll  ' +
            'check them.'
          'The possible solutions from my first observation are :'
          
            '30 = 2x15 or 3x10 or 5x6.  Could P eliminate (3+10) and (5+6) as' +
            ' my sum based on being expressable as sum of primes? No.'
          
            '42= 2x21 or 3x14 or 6x7.  Could P eliminate (2+21) and (6+7) as ' +
            'my sum based on being expressable as sum of primes?  No.'
          
            '52 = 2x26 or 4x13  Coud P eliminate (2+26) being my sum based on' +
            ' sum being  expressable as being sum of primes?  Yes!'
          '(28=5+13). So (4,13) is a solution.'
          ''
          'Check the rest just to make sure:'
          
            '60 = 2x30 or 3x20 or 4x15 or 5x12 or 6x10. Could P eliminate (2+' +
            '30) and (3+20) and (4+15) as my sum based on being'
          
            ' expressable as sum  of primes?   32=3+29 and 19=2+17,  but no s' +
            'um of two primes = 16.'
          
            '66 = 2x33 or 3x22 or 6x11.  Could P eliminate (2+33) and (3+22) ' +
            'as my sum based on being expressable as sum of two primes?  '
          '       35=2+33    but no sum of 2 primes = 25 '
          
            '70 = 2x35 or 5x14 or 7x10.  None can be written as sum of two pr' +
            'imes. '
          
            '72 = 2x36 or 3x24 or 4x18 or 6x12 or 8x9.  Could P eliminate (2+' +
            '36) and (3+24) or (4+18) as my sum based on being'
          
            'expressable as sum of  primes?  38=7+21 and 22=3+19 and 18=5+13,' +
            ' but no pair of primes sum to 27.'
          ''
          
            'Note: The professors would no doubt have used a shortcut to chec' +
            'k using the fact that no odd numbers can be the sum to two  '
          
            'primes unless one of the addends is 2.  Understanding and verify' +
            'ing the logic of the conclusions reached by the professors is '
          'difficult without a specfic example. So'
          
            'pretending that we do not know the solution, here is a walkthrou' +
            'gh given thar Dr.S has received sum 17 and Dr P has received  '
          
            'the product  52.  They both know that they are searching for two' +
            ' integers between 2 and 100 and that S has the sum abd P has '
          'the product  of the two numbers.'
          ''
          'S Observation 1:'
          '----------------'
          
            'My sum 17 so the two numbers must be one of (2,15), (3,14), (4,1' +
            '3), (5,12), (6,11), (7,10), or (8,9).   That means that , P'#39's  '
          
            'product is one of 30 (2x3x5),42, (2x3x7), 52 (2x2x13), 60 (2x2x3' +
            'x5), 66 (2x3x11), 70 (2x5x7), or 72 (2x2x2x3x 3).   This might  '
          'come in handy   later.'
          ''
          'P Observation 1:'
          ' ----------------'
          
            'My product is 52 which factors as 2x2x13 so the two solution num' +
            'bers must be (2 & 26) or (4 & 13) and S'#39's sum is 28, or  17. It '
          
            'seems that they are equally likely  so I might as well tell S th' +
            'at "I don'#39't know what the two number are."'
          ''
          'S Observation 2: '
          '---------------- '
          
            'I noticed that all seven of P'#39's possible products can all be exp' +
            'ressed as the product of two numbers in more than one way, so I '
          'can tell him: "I already knew that you would not know."'
          ''
          'P Observation 2: '
          '----------------'
          
            'I had previously decided that S'#39's sum must be 28 or 17 but, once' +
            ' S said that, I know that his sum cannot be 28 because if it'
          
            'were, he would have realized the numbers could possibly be 5+23,' +
            ' 2 primes,  and he could not know for sure that I didn'#39't know.'
          
            'If his sum  is not 28, it  must be 17.  As a double check, his s' +
            'um of 17 cannot be expressed as the some of two primes, so I'#39'm'
          'sure I can say:  "I now  know your sum  and the two numbers".'
          ''
          'S Observation 3:'
          ' ----------------'
          
            'Well, I'#39'll be darned - the only way he could know the the number' +
            ' is if he has eliminated all of the ways that he can factor his'
          
            'product into two  parts except one.  He must have done this by l' +
            'ooking at all of the ways that sums of factors of each of the tw' +
            'o'
          
            'term factorizations  can be  divided into two term-factors that ' +
            'are prime numbers. If for any of his possible products, I can'
          
            'eliminate all but my acutal sum  because the  sum can be express' +
            'ed as the sum of two primes, that one will be answer. It may'
          
            'take a while, but I know all of the possible  products so I'#39'll  ' +
            'check them.'
          'The possible solutions from my first observation are :'
          
            '30 = 2x15 or 3x10 or 5x6.  Could P eliminate (3+10) and (5+6) as' +
            ' my sum based on being expressable as sum of primes? No.'
          
            '42= 2x21 or 3x14 or 6x7.  Could P eliminate (2+21) and (6+7) as ' +
            'my sum based on being expressable as sum of primes?  No.'
          
            '52 = 2x26 or 4x13  Coud P eliminate (2+26) being my sum based on' +
            ' sum being  expressable as being sum of primes?  Yes!'
          '(28=5+13). So (4,13) is a solution.'
          ''
          'Check the rest just to make sure:'
          
            '60 = 2x30 or 3x20 or 4x15 or 5x12 or 6x10. Could P eliminate (2+' +
            '30) and (3+20) and (4+15) as my sum based on being'
          
            ' expressable as sum  of primes?   32=3+29 and 19=2+17,  but no s' +
            'um of two primes = 23 or 17.'
          
            '66 = 2x33 or 3x22 or 6x11.  Could P eliminate (2+33) and (3+22) ' +
            'as my sum based on being expressable as sum of two primes?'
          '       35=2+33    but no sum of 2 primes = 25'
          
            '70 = 2x35 or 5x14 or 7x10.  5+14=19=2+17, but neither 37 nor 17 ' +
            'can be written as sum of two primes.'
          
            '72 = 2x36 or 3x24 or 4x18 or 6x12 or 8x9.  Could P eliminate (2+' +
            '36) and (3+24) or (4+18) as my sum based on being'
          
            'expressable as sum of  primes?  38=7+21 and 22=3+19 and 18=5+13,' +
            ' but no pair of primes sum to 27 or 17.'
          ''
          
            'Note: The professors would no doubt have used a shortcut to chec' +
            'k using the fact that no odd numbers can be the sum to two  '
          
            'primes unless one of the addends is 2 but any even number >2  ca' +
            'n be.')
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Interactive Walk-through'
      ImageIndex = 4
      object Label5: TLabel
        Left = 352
        Top = 24
        Width = 36
        Height = 21
        Caption = 'Sum'
      end
      object Label6: TLabel
        Left = 456
        Top = 24
        Width = 62
        Height = 21
        Caption = 'Product'
      end
      object Label7: TLabel
        Left = 824
        Top = 16
        Width = 85
        Height = 21
        Caption = 'Comments'
      end
      object Label9: TLabel
        Left = 453
        Top = 280
        Width = 151
        Height = 21
        Caption = 'Prof. S Scratchpad'
      end
      object Label8: TLabel
        Left = 32
        Top = 280
        Width = 151
        Height = 21
        Caption = 'Prof. P Scratchpad'
      end
      object Edit1: TEdit
        Left = 392
        Top = 20
        Width = 49
        Height = 29
        TabOrder = 0
        Text = '17'
      end
      object Edit2: TEdit
        Left = 528
        Top = 20
        Width = 49
        Height = 29
        TabOrder = 1
        Text = '52'
      end
      object NextBtn: TButton
        Left = 352
        Top = 88
        Width = 217
        Height = 49
        Caption = 'Start solving'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = NextBtnClick
      end
      object Say: TMemo
        Left = 680
        Top = 40
        Width = 433
        Height = 217
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object SPad: TMemo
        Left = 448
        Top = 312
        Width = 705
        Height = 249
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -18
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 4
      end
      object PPad: TMemo
        Left = 24
        Top = 304
        Width = 393
        Height = 257
        Lines.Strings = (
          '')
        ScrollBars = ssVertical
        TabOrder = 5
      end
      object Memo3: TMemo
        Left = 8
        Top = 16
        Width = 241
        Height = 209
        Color = 14548991
        Lines.Strings = (
          'Enter trial Sum and Product '
          'numbers and press "Next '
          'Step" button multiple times '
          'to step through the '
          'professors'#39' reasoning.   '
          'Note that the validity of a '
          'solution is based on the '
          'Maximum # specified at the '
          'bottom of this page.')
        TabOrder = 6
      end
    end
  end
  object ListBox1: TListBox
    Left = 746
    Top = 683
    Width = 376
    Height = 102
    ItemHeight = 21
    TabOrder = 0
  end
  object SearchBtn: TButton
    Left = 20
    Top = 662
    Width = 246
    Height = 33
    Caption = 'Search for solutions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = SearchBtnClick
  end
  object MaxNum: TEdit
    Left = 162
    Top = 722
    Width = 45
    Height = 29
    TabOrder = 3
    Text = '100'
    OnChange = MaxNumChange
  end
  object MaxNumUD: TUpDown
    Left = 207
    Top = 722
    Width = 21
    Height = 29
    Associate = MaxNum
    Min = 2
    Max = 1000
    Position = 100
    TabOrder = 4
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 808
    Width = 1179
    Height = 30
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2002, 2007, 2013 Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -22
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 5
    OnClick = StaticText1Click
  end
end
