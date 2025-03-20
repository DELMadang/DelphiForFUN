object Form1: TForm1
  Left = 456
  Top = 137
  Width = 1370
  Height = 723
  Caption = 'Pursuit'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 663
    Width = 1362
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2018, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1362
    Height = 663
    Align = alClient
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 328
      Top = 496
      Width = 120
      Height = 23
      Caption = 'Rabbit Speed'
    end
    object Label2: TLabel
      Left = 328
      Top = 536
      Width = 99
      Height = 23
      Caption = 'Dog Speed'
    end
    object MoveBtn: TButton
      Left = 329
      Top = 591
      Width = 208
      Height = 28
      Caption = 'Start the chase!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = MoveBtnClick
    end
    object Memo2: TMemo
      Left = 24
      Top = 8
      Width = 673
      Height = 465
      Color = 14548991
      Lines.Strings = (
        
          'I recently received an interesting book titled "Chases and Escap' +
          'es",'
        
          '(Paul Nahin, Princeton University Press).   The math gets a litt' +
          'le heavy'
        
          '(i.e. Differential Equations), but the initial approach, the "Pu' +
          'rsuit'
        
          'Curve" illustrated here, is straight forward and fun to simulate' +
          '. The'
        
          'Dog chases the Rabbit by always heading toward its current locat' +
          'ion. '
        
          ' If the dog runs faster than the rabbit (and the field is large ' +
          'enough),  '
        'he will always achieve his goal.'
        ''
        
          'I provided a Hole for the rabbit to reach safety.  In this initi' +
          'al version, '
        
          'the rabbit runs due North to reach his hole.  The dog can be dra' +
          'gged '
        
          'to any starting position and the speed for each animal can be se' +
          't as '
        'desired.'
        ''
        'Future possible enhancements include:'
        
          '* Allow Rabbit and Hole to also be dragged to new starting locat' +
          'ions.'
        
          '* Rotate the animal graphics to always point in the direction of' +
          ' their '
        
          'current heading.(The problem was avoided for now by representing' +
          ' '
        'the dog as a circle restrcting mouse to vertical movement).'
        '* Allow rabbit to deviate from straight line path (zig-zag?).'
        
          '* Evaluate th Pursuit Curve ODE (Ordinary Differential Equation)' +
          ' to let'
        
          'the dog head stratght for the point where the rabbit will be whe' +
          'n it'
        'gets there.'
        '* Explore other pursuit problems from the book:'
        '  - Duck swimming in a circle around a pond.'
        '  - Catch a bad guy boat at sea knowing only where it is now and'
        
          'that it travels in a staight line at a fixed speed in some unkow' +
          'n'
        'direction (heavy fog blocks seeing it during the chase).'
        ''
        '')
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object Panel2: TPanel
      Left = 712
      Top = 8
      Width = 641
      Height = 577
      Color = clWindow
      TabOrder = 3
      OnDragOver = ImageDragOver
      object Image1: TImage
        Left = 1
        Top = 1
        Width = 639
        Height = 575
        Align = alClient
        Transparent = True
        OnDragOver = ImageDragOver
      end
      object DogShape: TShape
        Tag = 3
        Left = 64
        Top = 488
        Width = 41
        Height = 40
        Brush.Color = 4677304
        DragMode = dmAutomatic
        Shape = stEllipse
        OnEndDrag = ShapeEndDrag
      end
      object RabbitShape: TShape
        Tag = 3
        Left = 552
        Top = 488
        Width = 25
        Height = 41
        Brush.Color = 4683894
        Shape = stEllipse
      end
      object DogName: TLabel
        Left = 64
        Top = 464
        Width = 36
        Height = 23
        Caption = 'Dog'
      end
      object RabbitName: TLabel
        Left = 536
        Top = 464
        Width = 57
        Height = 23
        Caption = 'Rabbit'
      end
      object HoleName: TLabel
        Left = 544
        Top = 32
        Width = 39
        Height = 23
        Caption = 'Hole'
      end
      object HoleShape: TShape
        Tag = 3
        Left = 544
        Top = 56
        Width = 41
        Height = 25
        Brush.Color = 64
        DragMode = dmAutomatic
        Shape = stCircle
      end
    end
    object RSpeed: TSpinEdit
      Left = 456
      Top = 488
      Width = 49
      Height = 34
      MaxValue = 10
      MinValue = 0
      TabOrder = 4
      Value = 2
    end
    object DSpeed: TSpinEdit
      Left = 456
      Top = 528
      Width = 49
      Height = 34
      MaxValue = 10
      MinValue = 0
      TabOrder = 5
      Value = 5
    end
    object ResetBtn: TButton
      Left = 712
      Top = 599
      Width = 161
      Height = 28
      Caption = 'Reset'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = ResetBtnClick
    end
    object HungryGrp: TRadioGroup
      Tag = 6
      Left = 24
      Top = 560
      Width = 233
      Height = 57
      BiDiMode = bdLeftToRight
      Caption = 'Is Rover  hungry?'
      Color = clSkyBlue
      Columns = 2
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Arial'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'No'
        'Yes')
      ParentBiDiMode = False
      ParentBackground = False
      ParentColor = False
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      TabStop = True
    end
    object Memo1: TMemo
      Left = 24
      Top = 488
      Width = 273
      Height = 65
      Color = clSkyBlue
      Lines.Strings = (
        'Drag the dog to a new '
        'starting position if desired.')
      TabOrder = 7
    end
  end
end
