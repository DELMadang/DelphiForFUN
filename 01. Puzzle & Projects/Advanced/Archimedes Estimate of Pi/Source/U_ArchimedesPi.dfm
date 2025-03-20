object Form1: TForm1
  Left = 495
  Top = 152
  Width = 1309
  Height = 953
  Caption = 'Archimdes: "Measuring the Circle" '
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 18
  object StaticText1: TStaticText
    Left = 0
    Top = 885
    Width = 1291
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
    Width = 1291
    Height = 885
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 1
    object Label1: TLabel
      Left = 872
      Top = 304
      Width = 157
      Height = 23
      Caption = 'Polygon sides = 6'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 328
      Width = 1289
      Height = 556
      ActivePage = TabSheet4
      Align = alBottom
      TabOrder = 0
      object TabSheet2: TTabSheet
        Caption = 'Overview'
        ImageIndex = 1
        object Image1: TImage
          Left = 748
          Top = 18
          Width = 493
          Height = 495
        end
        object Memo4: TMemo
          Left = 24
          Top = 16
          Width = 705
          Height = 489
          Lines.Strings = (
            
              'After 4 iterations, Archimedes determined that the true vaue of ' +
              'Pi was greater than 3 10/71 but'
            
              'less that 3 1/7.  Decimal terminology had not yet been developed' +
              ' so he used rational fraction'
            
              'estimates for irrational values, starting with estimates for the' +
              ' square root of 3, but making sure'
            
              'that the error introduced only made his estimate worse than if h' +
              'e could have used the true value.'
            'Pretty smart fellow!'
            ''
            
              'In the "Circumscribed" and "Inscribed" tabbed pages, I'#39'll try to' +
              ' describe the "clever" part in getting '
            'from the known perimeter of the'
            
              'hexagon to the perimeter of the 12 sided polygon.  Actually, he ' +
              'only needed to concentrate on the'
            'length of one'
            
              'side and what happens to side lengths if we bisect N sides to cr' +
              'eate a polygon with 2N sides.  '
            'The'
            
              'technique for interior and exterior side lengths both use Euclid' +
              #39's Angle Bisector Theorem: "The'
            
              'angle bisector of any angle in a triangle divides the opposite s' +
              'ide in the same ratio as the sides '
            'adjacent'
            
              'to the angle."  It is from Euclid'#39's Book VI, Proposition 3 and, ' +
              'as Heath did,  we'#39'll refer to it as '
            'EUCL VI.3 in the'
            
              'following explanations. Archimedes tended to omit intermediate s' +
              'teps and explanations in his '
            'proofs.'
            
              'Heath added some explanatory text in his translation and I added' +
              ' a bit more where the rationale'
            'was not clear to a jack-leg "mathematician" such as myself :>).'
            ''
            
              'Each click of the "Next Polygon" button will show the next doubl' +
              'ing of the original 6 sided'
            
              'circumscribed and inscribed polygons here.  The two additional p' +
              'ages will describe the logic '
            'used to'
            'derive the interior and exterior side lengths.'
            ''
            '')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object TabSheet3: TTabSheet
        Caption = '   Circumscribed detail   '
        ImageIndex = 2
        object PaintBox1: TPaintBox
          Left = 755
          Top = 43
          Width = 460
          Height = 469
          OnPaint = PaintCircumscribedDetail
        end
        object Label2: TLabel
          Left = 864
          Top = 8
          Width = 48
          Height = 18
          Caption = 'Label2'
        end
        object StringGrid2: TStringGrid
          Left = 32
          Top = 304
          Width = 705
          Height = 153
          ColCount = 6
          DefaultColWidth = 88
          RowCount = 6
          TabOrder = 0
        end
        object Memo2: TMemo
          Left = 8
          Top = 16
          Width = 737
          Height = 257
          Lines.Strings = (
            
              'On this page, I'#39'll follow Archimedes'#39' derivation of the Pi estim' +
              'ate for circumscribed polygons.'
            
              'Heath placed his explanations in [ ] brackets which I have tried' +
              ' to retain.  I'#39've addded additional'
            
              'explanation for the parts that weren'#39't as obvious to me as they ' +
              'must have been to Archimedes and'
            'Heath.'
            ''
            
              'For the exterior hexagon, he considers the triangle formed by co' +
              'nnecting point O, the circle'#39's center  to'
            
              'point A, the point of tangency of a side, to point C, the end of' +
              ' that side. He knows that angle AOC'
            
              'is 1/3 of a right angle (30 degrees to us).  He also knows that,' +
              ' for such a triangle (which we  commonly'
            'call a 30-60-90 triangle),'
            ''
            'Archimedes then says:'
            ''
            '(1)  the ratio of OA:AC [= sqrt(3):1] >265:152 and'
            '(2) the OC:AC ratio i[= 2:1] = 306:153.'
            ''
            'Me:'
            
              'From this we can derive an estimate of Pi as the perimeter divid' +
              'ed by the diameter (twice the length of'
            
              'OA ) or 12*AC/(2*OA) = 6*(AC/OA)=6*1/sqrt(3)=3.464 or, for Archi' +
              'medes since decimal notation did'
            'not yet exist, six times the ratio of the'
            
              'radius to the semi-perimeter =  6*265/153.  We'#39'll use this same ' +
              'concept to track the values for the rest'
            'of the exercise.'
            ''
            'Archimedes:'
            '  First, draw OD bisecting the angle AOC and meeting AC in D.'
            ''
            
              'Me: So that now AD represents half the length of one side of a 1' +
              '2 sided polygon.'
            ''
            'Archimedes:'
            'Now     CO:OA=CD:DA [By EUCL VI.3]'
            'So that [(CO+OA):OA = CA:DA or]'
            '       (CO+OA):CA = OA:DA'
            ''
            'Me:I had to step through it this way:'
            '     CO/OA=CD:DA'
            '     CO/OA+1 = CD/DA +1'
            '==>  CO/OA+OA/OA = CD/DA + DA/DA'
            '==>  (CO+OA)/OA = (CD+DA)/DA'
            '==>  [(CO+OA)/OA = CA/DA]'
            '     Multiply both sides of the above by OA/CA to get'
            '==>  (CO+OA):CA = OA:DA'
            ''
            ''
            'Archmedes:'
            'Therefore  [by (1) and (2)] OD : DA  > 571 : 153   (3)'
            ''
            'Me:'
            
              'The estimate for Pi, for the 12 sided polygon, if A. had bothere' +
              'd to record it, is'
            'Pi < 12*AD/OA=12*153/571 = 3.215'
            ''
            'Archmededes:'
            
              'Hence  sqr(OD) : sqr(AD) [= (sqr(OA) + sqr(AD)) :sqr(AD)]   > (s' +
              'qr(571 )+ sqr(153)) : sqr(153)'
            
              '                                                         > 34935' +
              '0 : 23409,'
            ''
            'So that    OD : DA > 591 1/8 : 153   (4)'
            ''
            
              'Me: Pythagoras allows us to replace the square of hypotenuse OD ' +
              'with the sum of the squares of'
            
              'OA and AD. We now have a ratio for the triangle AOD which we can' +
              ' bisect again, giving Archimedes'#39
            
              'point E for the 24 sided polygon and giving an OA/AE ratio of 11' +
              '62.125/153 and a Pi estimate of'
            '24*153/1162.125=3.160.'
            ''
            
              'Similarly Archimedes uses AOE to calculate AOF for the 48 sided ' +
              'case, he gets 2334 1/4 : 153 and'
            'we can calculate Pi < 153*48/2334.25 = 3.1462.'
            ''
            
              'An finally, from AOG, the 96 side case, he gets 4673 1/2 : 153 a' +
              'nd Pi < 153*96/4673.5 = 3.1428'
            'which he expresses as 3 1/7.'
            '')
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
      object TabSheet1: TTabSheet
        Caption = '    Inscribed detail   '
        ImageIndex = 2
        object PaintBox2: TPaintBox
          Left = 755
          Top = 32
          Width = 481
          Height = 481
          OnPaint = PaintInscribedDetail
        end
        object Label3: TLabel
          Left = 872
          Top = 8
          Width = 48
          Height = 18
          Caption = 'Label3'
        end
        object StringGrid1: TStringGrid
          Left = 32
          Top = 304
          Width = 689
          Height = 153
          ColCount = 6
          DefaultColWidth = 88
          RowCount = 6
          TabOrder = 0
        end
        object Memo3: TMemo
          Left = 8
          Top = 16
          Width = 737
          Height = 257
          Lines.Strings = (
            
              'Calculating Pi estimates for the inscribed polygons seemed trick' +
              'ier than for superscribed.  Again, I'#39'll'
            
              'expand the Archimedes proof to add my explanations of things whi' +
              'ch may not be obvious to us meere'
            'mortals.'
            ''
            'Archimedes:'
            
              'Let AB be the diameter of a circle and let AC meeting the circle' +
              ' at C make the angle CAB equalto one'
            'third of a right angle.  Join BC.'
            ''
            'Then   AC:CB [sqrt(3):1)] < 1351 :780.'
            ''
            
              'Me:  This time the estimate of sqrt(3) is less than the true val' +
              'ue so we can be sure that it does not'
            
              'make the estimate, which will always be low, closer than the res' +
              't of the mathematics indicate.'
            ''
            
              'We can make our first estimate of Pi from the known ratios From ' +
              'the given triangle; we know that the'
            
              'ratio of the diameter (AB) to one side of the hexagon (CB) is 1/' +
              '2 or so our initial (low) estimate of'
            'the value of Pi is 6/2 or 3.00.'
            ''
            
              'Archimedes:  First let AD bisect the angle BAC and meet BC in d ' +
              'and the circle in D.  Join BD.'
            ''
            'Then          angle BAD = angle dAC = angle dBD'
            'and the angles  at D and C are both right angles.'
            ''
            'It follows that the triangles ADB [ACd], and BDd are similar.'
            ''
            
              'Me:  BAD = dAC by construction .  Angles at D and C are right an' +
              'gles because they are angles'
            
              'inscribed in a semicircle which are always right angles.   (Sear' +
              'ch Web for "angle inscribed semicircle"'
            
              'for many proofs).   The vertical angles at d are equal. So angle' +
              ' dAC = 180-90-Cda = 180-90-DdB = '
            'DBd,'
            
              'The three triangles are simlar all have the same three angle val' +
              'ues so are similar by definition.'
            ''
            'Archimedes:'
            ''
            'Therefore         AD : DB = BD : Dd'
            '                          [=AC : Cd]'
            '                         =AB : Bd    [Eucl. VI.3]'
            '                        = AB + AC : Bd + Cd'
            '                        = AB + AC : BC'
            'or             BA + AC : BC = AD : DB'
            ''
            
              'Me: It might be obvious to geometers, but it wasn'#39't clear to me ' +
              'that if AC:Cd=AB:Bd then it also true'
            'that AC:Cd = (AB+AC):(Cd+Bd).  Here'#39's my proof:'
            ''
            
              'AC/Cd=AB/Bd = some constant, k.  Then AC= k*Cd and AB = k*Bd.  A' +
              'dding these equations, we get '
            'AC+AB=k*Cd+k*Bd,'
            
              'so AC+AB= k*(Cd+Bd) and (AC+AB)/(Cd+Bd)=k. ===> (AC+AB) : (Cd+Bd' +
              ') = k = AC:Cd'
            ''
            'Archimedes:  But    AC:CB < 1351:780 from above'
            'while               BA:BC = 2:1 = 1550:780'
            ''
            'Therefore          AD:DB < 2911 : 780            (1)'
            
              '[Hence     sqr(AB):sqr(BD) < sqr(2911) + sqr(780) : sqr(780) < 9' +
              '082321:608400]'
            'Thus          AB:BD < 3013 3/4: 780              (2)'
            ''
            
              'Me: This is enough to give us our estimate for the 12 sided insc' +
              'ribed polygons.'
            
              'Because AB is the hypotenuse of right triangle ABD, AB:DB less t' +
              'han the calculated value'
            '3013 3/4:780 and Pi > 12* (780/3013.75) = 3.1057'
            ''
            
              'Now the hard thinking is done and with the help of a calculator ' +
              'or computer, even most of the work is'
            
              'done.  Archimedes bisects DAB with AE to get the 24 sided ratios' +
              '.'
            '         AB:BE < 1838 9/11: 240   (4)'
            
              'giving the 24 sided case estimate:  Pi > 24*(240/1838.818) = 3.1' +
              '325.  Similarly'
            ''
            
              '48 side case:  AB:BF < 1009 1/6: 66 and Pi > 48*66/1009.167 = 3.' +
              '1392  and'
            ''
            
              '96 side case: AB:BG < 2017 1/6: 66  and Pi > 96*66/2017.167 - 3.' +
              '1410')
          ScrollBars = ssVertical
          TabOrder = 1
        end
      end
      object TabSheet4: TTabSheet
        Caption = '   Final notes   '
        ImageIndex = 3
        object Memo5: TMemo
          Left = 48
          Top = 32
          Width = 713
          Height = 409
          Lines.Strings = (
            'A few final notes:'
            ''
            #160
            
              '. Archimedes use of rational fractions raises the question: "Whe' +
              'n did the positional notation'
            
              'decimal system develop?"  The answer from http://en.wikipedia.or' +
              'g/wiki/Hindu-'
            
              'Arabic_numeral_system is:  "The Hindu'#8211'Arabic numeral system or H' +
              'indu numeral system is a '
            
              'positional decimal numeral system developed by the 9th century b' +
              'y Indian mathematicians, '
            
              'adopted by Persian (Al-Khwarizmi'#39's circa 825 book On the Calcula' +
              'tion with Hindu Numerals) and '
            
              'Arabic mathematicians (Al-Kindi'#39's circa 830 volumes On the Use o' +
              'f the Indian Numerals), and '
            'spread to the western world by the High Middle Ages."'
            ''
            
              '.  The statements about the values Archimedes used for  sqrt(3) ' +
              'seemed to need verification.  '
            'Here'#39's what I found:'
            
              'For the circumscribed case, 265/153 is indeed less than the sqrt' +
              '(3).  This value represents the '
            
              'length of the radius which appears the denominator of the Pi est' +
              'imate, making that estimate '
            'larger that the true value.'
            
              'For inscribed, the assumed sqrt(3) value, 1351/780  is larger th' +
              'an the which, thanks to '
            
              'Pythagoras, forces the calculated polygon side value to be too s' +
              'mall which in turn forces the Pi '
            'estimate to be too small.'
            ''
            
              '.  If you download the PDF version of the Heath text, he has an ' +
              'extensive introduction which is '
            
              'interesting but the the text used here is from page numbers 93-9' +
              '8 of "Measurement of a Circle"  '
            'and  starts around PDF page number 281.'
            ''
            
              '. I entered many letter combinations describing lines, angles, a' +
              'nd triangles as I transcribed and '
            
              'expanded on Archimedes'#39' text.  In the process I'#39'm sure that ther' +
              'e is more than one typo.  If you '
            
              'work through the text and find any of these, please use the feed' +
              'back link at DFF tolet me know.'
            '')
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object Memo1: TMemo
      Left = 16
      Top = 8
      Width = 825
      Height = 313
      Color = 14548991
      Lines.Strings = (
        
          'Here is an illustrated description of Archimedes'#39' method for est' +
          'imating Pi developed a couple of hundred years'
        
          'BC. Starting with circumscribed and inscribed hexagons for a giv' +
          'en circle, he calculated the perimeters as he '
        
          'doubled the number of sides and used the ratio of each perimeter' +
          ' to the diameter of the given circle as an estimate '
        
          'of Pi.  Since the circumscribed perimeter will be larger than th' +
          'e circumference of the circle, the derived estimate of '
        
          'Pi will be too large.  Similarly the inscribed perimeter will be' +
          ' too small and produce a low estimate. As the number '
        'of sides increases, the two estimates converge towards Pi.'
        ''
        
          'Archimedes started with what was probably the largest number of ' +
          'sides for which he knew the actual ratio of the'
        
          'side lengths to the diameter, a hexagon.  He then cleverly deriv' +
          'ed the ratios for 12 sided regular polygons and'
        
          'repeated the same logic for 24, 48, and 96 sided polygons.  Most' +
          ' current explanations of Archimedes procedure,'
        
          'cheat and use trigonometry but here we'#39'll do it the way he did i' +
          't using only algebra and geometry.  The'
        
          'English translation of Proposition 3 in "The Measure of a Circle' +
          '" used here is from "The Works of Archimedes"'
        
          'translated from Greek by T.L. Heath and published in 1897.  A fr' +
          'ee download is available from the link below.'
        '')
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object NextPolygonsBtn: TButton
      Left = 886
      Top = 15
      Width = 289
      Height = 28
      Caption = 'Draw next polygons'
      TabOrder = 2
      OnClick = NextPolygonsBtnClick
    end
    object ResetBtn: TButton
      Left = 888
      Top = 64
      Width = 289
      Height = 25
      Caption = 'Reset'
      TabOrder = 3
      OnClick = ResetBtnClick
    end
    object StaticText2: TStaticText
      Left = 288
      Top = 280
      Width = 293
      Height = 22
      Cursor = crHandPoint
      Caption = 'Click to download "Works of Archimedes"'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      TabOrder = 4
      OnClick = StaticText2Click
    end
  end
end
