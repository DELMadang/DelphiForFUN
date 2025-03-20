object Form1: TForm1
  Left = 384
  Top = 191
  Width = 896
  Height = 759
  Caption = 'Form1'
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
    Top = 691
    Width = 878
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
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
    Width = 878
    Height = 691
    Align = alClient
    TabOrder = 1
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 876
      Height = 689
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'The Puzzle'
        ImageIndex = 1
        object Memo4: TMemo
          Left = 440
          Top = 18
          Width = 401
          Height = 154
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -17
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            '')
          ParentFont = False
          TabOrder = 0
          Visible = False
        end
        object ShowMeBtn: TButton
          Left = 24
          Top = 535
          Width = 377
          Height = 25
          Caption = 'Show me the solution'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -20
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = ShowMeBtnClick
        end
        object Memo5: TMemo
          Left = 24
          Top = 194
          Width = 377
          Height = 319
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 4194432
          Font.Height = -17
          Font.Name = 'Arial'
          Font.Style = [fsBold, fsItalic]
          Lines.Strings = (
            'Four sparrows found a dish of seed,'
            'FIne bird food, no common seed.'
            'Said Pip: "In turn each take 2 grains'
            'And then a third of what remains'
            'It'#39's me as first, then Pep, then Pop,'
            'With Pap the last and then we stop."'
            ''
            'But Pap cried out: "It isn'#39't fair.'
            'Mine'#39's two seeds less than half Pep'#39's share."'
            'Old Pip was boss, his word was law,'
            'So little Pap got nothing more.'
            'Poor Pap, his share was rather small!'
            'How many seeds were there in all?'
            ''
            'From: "Challenging Mathematical Teasers", '
            'J.A.H. Hunter, Dover Pubs, 1980')
          ParentFont = False
          TabOrder = 2
        end
        object Memo3: TMemo
          Left = 24
          Top = 16
          Width = 377
          Height = 156
          Color = 14548991
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -17
          Font.Name = 'Comic Sans MS'
          Font.Style = []
          Lines.Strings = (
            'Here'#39's a little puzzle which can be solved '
            'using algebra if you are really careful about '
            'using substitions and and calculating '
            'coefficients.  I'#39'm not so, for me, it was '
            'easier to write this program to solve it by '
            '"trial and error".  ')
          ParentFont = False
          TabOrder = 3
        end
        object Memo6: TMemo
          Left = 440
          Top = 192
          Width = 401
          Height = 377
          Lines.Strings = (
            'The next 2 pages show 2 versions of the code which solve'
            'the problem.  Variables are used to represent the numbers of '
            'seeds; (Pip, Pep, Pop, and Pap stand for the number of '
            'seeds each bird has taken and variable "Remaining" holds '
            'the number of seeds remaining after each action. I run a loop '
            'trying numbers from 5 to 1000 for the initial number of seeds. '
            ' For each trial value, we check two things:'
            '1) Before each  share is taken, is the number of seeds '
            'available two more than a multiple of 3?'
            '2) When each bird has drawn his seeds, is Pap'#39's share 2 '
            'seeds  less than half of Pep'#39's share?'
            ''
            'When both of these conditions are met, we have a solution.  '
            'Version 2 moves the common testing for each bird into a '
            'function and uses "Begin".."End" structures;'
            ''
            'If you do not speak "Delphian", you should still be able to '
            'read the code if you know that things in curly brackets {}, are '
            'comments,  the  "X mod Y" function returns the remaninder '
            'when X is divided by Y, and the "Continue" function means '
            '"Restart the loop with the next number".')
          TabOrder = 4
          Visible = False
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'The Delphi code (Version 1)'
        ImageIndex = 2
        object Memo2: TMemo
          Left = 0
          Top = 0
          Width = 868
          Height = 658
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Tahoma'
          Font.Style = []
          Lines.Strings = (
            'procedure TForm1.Button1Click(Sender: TObject);'
            'Var'
            '  Pip,pep,pap,pop, N, Remain:integer;'
            'begin'
            '  for n:=5 to 1000 do'
            '  begin'
            
              '    if (n-2) mod 3 <> 0 then continue; {2 less than total seeds ' +
              'must be divisible by 3}'
            '    {Pip}'
            '    remain:=N-2; {Pip takes 2 seeds}'
            '    pip:=2+remain div 3;  {plus 1/3 of what is left}'
            
              '    remain:=remain-remain div 3;  {take that 1/3 from remaining ' +
              'seeds}'
            
              '    If (remain-2) mod 3 <>0 then continue; {2 less than remainin' +
              'g seeds must be divisible by 3}'
            '    {Pep}'
            '    remain:=remain-2;  {Pep takes 2 seeds}'
            '    Pep:=2 + remain div 3;  {and 1/3 of what is left}'
            '    remain:=remain-remain div 3;'
            
              '    If (remain-2) mod 3 <>0 then continue; {2 less than remainin' +
              'g seeds must be divisible by 3}'
            '    {Pop}'
            '    remain:=remain-2; {Pop takes 2 seeds}'
            '    Pop:= 2+ remain div 3;  {and 1/3 of what is left}'
            '    remain:=remain-remain div 3;'
            
              '    If (remain-2) mod 3 <> 0 then continue; {2 less than remaini' +
              'ng seeds must be divisible by 3}'
            '    {Pap}'
            '    remain:=remain-2;   {Pap takes 2 seeds}'
            '    Pap:= 2 + remain div 3;   {plus 1/3 of what is left}'
            '    remain:=remain - remain div 3;'
            
              '    if Pap = (Pep div 2) -2 then  {Is that number 2 less then 1/' +
              '2 of Pep'#39's seeds?}'
            '    with memo1.Lines do'
            '    begin  {Yes!   Display the answer}'
            '      Add(format('#39'Starting # = %d'#39',[N]));'
            '      Add(format('#39'Pip= %d'#39',[Pip]));'
            '      Add(format('#39'Pep= %d'#39',[Pep]));'
            '      Add(format('#39'Pop= %d'#39',[Pop]));'
            '      Add(format('#39'Pap= %d'#39',[Pap]));'
            '      Add(format('#39'Total taken = %d'#39',[Pip+pep+pop+pap]));'
            '      Add(format('#39'Left over # = %d'#39',[remain]));'
            '    end;'
            '  end;')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'The Delphi Code (Version 2)'
        ImageIndex = 2
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 868
          Height = 658
          Align = alClient
          Lines.Strings = (
            '    {************ CalculateShare ************}'
            '   Function CalculateShare(Var X, R:integer):boolean;'
            
              '    begin  {Function to test if R is valid seed count and return' +
              ' X'#39's share and new R if so}'
            '      if (R mod 3 = 2) then'
            '      begin'
            
              '        X:=2+(R-2) div 3; {X takes 2 seeds plus 1/3 of the pile ' +
              'after he takes 2}'
            '        R:=R-X;  {take X amount from the pile}'
            
              '        result:=true; {true if remaining mod 3 = 2, false others' +
              'ise}'
            '      end'
            '      else result:=false;'
            '    end;'
            ''
            '{********** ShowMeBtnCLick *********}'
            'procedure TForm1.ShowMeBtnClick(Sender: TObject);'
            'var'
            '   Pip,pep,pap,pop, N, Remaining:integer;'
            'begin'
            '  for n:=5 to 1000 do'
            '  begin'
            '    Remaining:=N; {Set "Remaining" to the number being tested}'
            
              '    {If # seeds is valid, return True and set Pip'#39's share and re' +
              'maining seeds}'
            '    If CalculateShare(Pip, Remaining) then'
            '    begin {same for Pep}'
            '      If  CalculateShare(Pep,Remaining) then'
            '      begin {same for Pop}'
            '        if CalculateShare(Pop,Remaining) then'
            '        begin {same for Pap}'
            '          if CalculateShare(Pap,Remaining) then'
            '          begin;'
            
              '            if (Pap = (Pep div 2) -2)  {Is Pap'#39's number 2 less t' +
              'han 1/2 of Pep'#39's seeds?}'
            '            then {Yes!   Display the answer}'
            '            with memo4.Lines do'
            '            begin'
            '              Add('#39'Solution:'#39');'
            '              Add(format('#39'Starting # = %d'#39',[N]));'
            
              '              Add(format('#39'Pip= %d, Pep= %d, Pop= %d, Pap= %d'#39',[P' +
              'ip, Pep, Pop, Pap]));'
            '              Add(format('#39'Total taken = %d'#39',[Pip+pep+pop+pap]));'
            '              Add(format('#39'Left over # = %d'#39',[Remaining]));'
            '            end ;'
            '          end;'
            '        end;'
            '      end;'
            '    end;'
            '  end;'
            'end;')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
